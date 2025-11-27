// src/main/java/com/globalin/controller/MypageController.java
package com.globalin.controller;

import java.nio.charset.StandardCharsets;
import java.sql.Date;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriUtils;

import com.globalin.domain.Member;
import com.globalin.dto.ReservationView;
import com.globalin.service.MemberService;
import com.globalin.service.ReservationService;

@Controller
public class MypageController {

    private final ReservationService reservationService;
    private final MemberService memberService;

    public MypageController(ReservationService reservationService, MemberService memberService) {
        this.reservationService = reservationService;
        this.memberService = memberService;
    }

    @GetMapping("/mypage")
    public String mypage(
            @RequestParam(value = "show", required = false) String show,
            @RequestParam(value = "cid",  required = false) Long cid, // ← 취소 직후 표시용
            HttpSession session,
            Model model) {

        Member user = (Member) session.getAttribute("loginUser");
        if (user == null) {
            String next = UriUtils.encode("/mypage", StandardCharsets.UTF_8);
            return "redirect:/login?next=" + next;
        }

        model.addAttribute("user", user);

        // 기본: 취소 가능 건(PAID)만, show=all 이면 전체
        if ("all".equalsIgnoreCase(show)) {
            model.addAttribute("reservations",
                    reservationService.findByMemberId(user.getMemberId()));
        } else {
            model.addAttribute("reservations",
                    reservationService.findCancelableByMemberId(user.getMemberId()));
        }

        // 방금 취소한 건 한 줄만 별도로 보여주기 (세션 유지 중 한 번)
        if (cid != null) {
            ReservationView v = reservationService.findViewById(cid); // ← 변수명 수정
            if (v != null && v.getOwnerId() == user.getMemberId()) {
                model.addAttribute("lastCanceled", v);
            }
        }

        return "mypage";
    }

    /** 내 정보 수정 폼 */
    @GetMapping("/mypage/edit")
    public String editForm(HttpSession session, Model model) {
        Member login = (Member) session.getAttribute("loginUser");
        if (login == null) {
            String next = UriUtils.encode("/mypage/edit", StandardCharsets.UTF_8);
            return "redirect:/login?next=" + next;
        }
        model.addAttribute("user", login);
        return "mypage_edit"; // /WEB-INF/views/mypage_edit.jsp
    }

    /** 내 정보 수정 처리 */
    @PostMapping("/mypage/edit")
    public String editSubmit(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String birthdate, // yyyy-MM-dd
            @RequestParam(required = false) String gender,    // 'M'/'F'
            HttpSession session,
            RedirectAttributes redirect) {

        Member login = (Member) session.getAttribute("loginUser");
        if (login == null) {
            String next = UriUtils.encode("/mypage/edit", StandardCharsets.UTF_8);
            return "redirect:/login?next=" + next;
        }

        // 입력값 정리
        name      = trimToNull(name);
        email     = trimToNull(email);
        phone     = trimToNull(phone);
        birthdate = trimToNull(birthdate);
        gender    = trimToNull(gender);

        // 업데이트할 필드만 채워서 전달
        Member toUpdate = new Member();
        toUpdate.setMemberId(login.getMemberId()); // WHERE 키

        if (name != null)  toUpdate.setName(name);
        if (email != null) toUpdate.setEmail(email);
        if (phone != null) toUpdate.setPhone(phone);

        if (birthdate != null) {
            try {
                toUpdate.setBirthdate(Date.valueOf(birthdate)); // "yyyy-MM-dd"
            } catch (IllegalArgumentException ignore) {
                // 형식 오류면 생일은 업데이트하지 않음
            }
        }

        if ("M".equalsIgnoreCase(gender) || "F".equalsIgnoreCase(gender)) {
            toUpdate.setGender(gender.toUpperCase());
        }

        // DB 업데이트
        memberService.updateProfile(toUpdate);

        // 세션 최신화
        Member refreshed = memberService.findByUserId(login.getUserid());
        if (refreshed != null) {
            session.setAttribute("loginUser", refreshed);
        }

        redirect.addFlashAttribute("msg", "내 정보가 수정되었습니다.");
        return "redirect:/mypage?tab=info";
    }

    /** 회원탈퇴 확인 페이지 */
    @GetMapping("/member/withdraw")
    public String withdrawConfirm(HttpSession session, Model model) {
        Member login = (Member) session.getAttribute("loginUser");
        if (login == null) {
            String next = UriUtils.encode("/member/withdraw", StandardCharsets.UTF_8);
            return "redirect:/login?next=" + next;
        }
        model.addAttribute("user", login);
        return "member_withdraw"; // /WEB-INF/views/member_withdraw.jsp
    }

    /** 회원탈퇴 실행 */
    @PostMapping("/member/withdraw")
    public String withdrawDo(HttpSession session, RedirectAttributes redirect) {
        Member login = (Member) session.getAttribute("loginUser");
        if (login == null) {
            String next = UriUtils.encode("/member/withdraw", StandardCharsets.UTF_8);
            return "redirect:/login?next=" + next;
        }

        long memberId = login.getMemberId();

        // 예약 먼저 삭제(자식 FK 회피)
        reservationService.deleteByMemberId(memberId);

        // 회원 삭제
        memberService.deleteById(memberId);

        // 세션 종료
        session.invalidate();

        redirect.addFlashAttribute("msg", "회원탈퇴가 완료되었습니다。ご利用ありがとうございました。");
        return "redirect:/";
    }

    /** 공백 → null */
    private static String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
