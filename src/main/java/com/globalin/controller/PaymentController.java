package com.globalin.controller;

import com.globalin.domain.Member;
import com.globalin.domain.Reservation;
import com.globalin.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Optional;

@Controller
public class PaymentController {

    private final ReservationService reservationService;

    public PaymentController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    /** 결제 페이지 진입
     *  호텔 상세에서 넘겨준 파라미터를 그대로 모델에 실어 JSP에서 표시만 하게 함
     *  (파라미터가 없어도 페이지는 열림)
     */
    @GetMapping("/payment")
    public String payment(
            @RequestParam(required = false) Long hotelId,
            @RequestParam(required = false) String hotelName,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) String checkin,
            @RequestParam(required = false) String checkout,
            @RequestParam(required = false) Integer guests,
            @RequestParam(required = false) String roomType,
            @RequestParam(required = false) Long price,  // 1박 요금(옵션)
            @RequestParam(required = false) Long amount, // 총액(옵션)
            @RequestParam(required = false) String error, // 결제수단 점검중 등
            Model model
    ) {
        model.addAttribute("hotelId", hotelId);
        model.addAttribute("hotelName", hotelName);
        model.addAttribute("region", region);
        model.addAttribute("checkin", checkin);
        model.addAttribute("checkout", checkout);
        model.addAttribute("guests", guests);
        model.addAttribute("roomType", roomType);
        model.addAttribute("price", price);
        model.addAttribute("amount", amount);
        model.addAttribute("error", error);
        return "payment"; // /WEB-INF/views/payment.jsp
    }

    /** 결제 확정
     *  - VISA만 허용 (다른 결제수단이면 payment로 리다이렉트 + 에러쿼리)
     *  - 세션 사용자 필수
     *  - 날짜 파싱
     *  - Reservation 엔티티 채워서 서비스에 위임
     *  - 완료 후 마이페이지 '내 예약' 탭으로 이동
     */
    @PostMapping("/payment/confirm")
    public String confirm(
            HttpSession session,
            RedirectAttributes ra,
            // 필수 값
            @RequestParam Long hotelId,
            @RequestParam String hotelName,
            @RequestParam String region,
            @RequestParam String checkin,     // "YYYY-MM-DD"
            @RequestParam String checkout,    // "YYYY-MM-DD"
            @RequestParam Integer guests,
            @RequestParam String roomType,
            @RequestParam String paymentMethod,
            // 선택 값: 총액/1박가 중 하나만 넘어와도 동작
            @RequestParam(required = false) Long amount,
            @RequestParam(required = false) Long price
    ) {
        // 로그인 확인
        Member user = (Member) session.getAttribute("loginUser");
        if (user == null) {
            // 로그인 후 다시 돌아오도록 next 지정
            return "redirect:/login?next=/payment";
        }

        // 결제수단 서버 검증 (VISA만 허용)
        if (!"VISA".equalsIgnoreCase(paymentMethod)) {
            ra.addAttribute("hotelId", hotelId);
            ra.addAttribute("hotelName", hotelName);
            ra.addAttribute("region", region);
            ra.addAttribute("checkin", checkin);
            ra.addAttribute("checkout", checkout);
            ra.addAttribute("guests", guests);
            ra.addAttribute("roomType", roomType);
            if (price != null)  ra.addAttribute("price", price);
            if (amount != null) ra.addAttribute("amount", amount);
            ra.addAttribute("error", "method"); // JSP에서 "点検中" 말풍선 처리
            return "redirect:/payment";
        }

        // 날짜 파싱
        LocalDate ci, co;
        try {
            ci = LocalDate.parse(checkin);
            co = LocalDate.parse(checkout);
        } catch (DateTimeParseException e) {
            ra.addAttribute("error", "date");
            return "redirect:/payment";
        }

        // 총액 없으면 1박가 * 박수로 계산 (프론트가 넘기지 않아도 안전)
        long nights = Math.max(0, java.time.temporal.ChronoUnit.DAYS.between(ci, co));
        long safeAmount = Optional.ofNullable(amount)
                .orElseGet(() -> {
                    long p = Optional.ofNullable(price).orElse(0L);
                    return p * nights;
                });

        // Reservation 엔티티 구성 (현재 네 코드 구조에 맞춰 필드명 사용)
        Reservation r = new Reservation();
        r.setMemberId(user.getMemberId());
        r.setHotelId(hotelId);
        r.setHotelName(hotelName);
        r.setRegion(region);
        r.setRoomType(roomType);
        r.setCheckin(ci);
        r.setCheckout(co);
        r.setGuests(guests);
        r.setAmount(safeAmount);
        r.setPaymentMethod("VISA");
        r.setStatus("PAID"); // 저장 상태

        // 저장
        reservationService.create(r);

        // 마이페이지 '내 예약' 탭으로
        return "redirect:/mypage?tab=resv";
    }
}
