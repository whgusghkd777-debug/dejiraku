package com.globalin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.globalin.domain.Member;
import com.globalin.service.ReservationService;

@Controller
public class ReservationController {

    private final ReservationService reservationService;
    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    /** 예약 취소 (본인 소유 + PAID 일 때만) */
    @PostMapping("/reservation/{id}/cancel")
    public String cancel(@PathVariable("id") long reservationId,
                         HttpSession session) {
        Member login = (Member) session.getAttribute("loginUser");
        if (login == null) {
            return "redirect:/login?next=/mypage?tab=resv";
        }

        reservationService.cancel(login.getMemberId(), reservationId);
        // 취소 후 내 예약 탭으로, 방금 건 하이라이트
        
        return "redirect:/mypage?tab=resv&cid=" + reservationId;
    }
    
}
