package com.globalin.controller;

import com.globalin.domain.Member;
import com.globalin.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private MemberService memberService;
    
// 로그인 화면 보여주기
// - 이미 로그인된 상태면 next 페이지나 홈으로 이동
// - 로그인 안 된 상태면 로그인 폼 페이지로 이동

    @GetMapping("/login")
    public String loginForm(@RequestParam(value = "next", required = false) String next,
                            HttpSession session,
                            Model model) {

        if (session.getAttribute("loginUser") != null) {
            if (next != null && !next.isEmpty()) {
                return "redirect:" + next;
            }
            return "redirect:/";
        }

        model.addAttribute("next", next);
        return "login";
    }

// 로그인 처리
// - 아이디/비번 확인 (memberService.login 호출)
// - 실패: 에러 메시지와 함께 로그인 화면 다시 보여줌
// - 성공: 세션에 loginUser 저장 후 next 페이지나 홈으로 이동
    @PostMapping("/login")
    public String doLogin(@RequestParam("username") String userId,
                          @RequestParam("password") String rawPassword,
                          @RequestParam(value = "next", required = false) String next,
                          HttpSession session,
                          Model model) {

        Member m = memberService.login(userId, rawPassword);
        if (m == null) {
            model.addAttribute("errorMsg", "IDまたはPasswordが正しくありません。");
            model.addAttribute("next", next);
            return "login"; // 실패 -> 로그인 화면
        }

        // 성공 -> 세션 저장 후 이동
        session.setAttribute("loginUser", m);
        if (next != null && !next.isEmpty()) {
            return "redirect:" + next;
        }
        return "redirect:/";
    }

 
// 로그아웃 처리
// - 세션을 완전히 종료 (invalidate)
// - next 페이지가 있으면 거기로, 없으면 홈으로 이동
    @PostMapping("/logout")
    public String logout(@RequestParam(value = "next", required = false) String next,
                         HttpSession session) {
        session.invalidate();
        if (next != null && !next.isEmpty()) {
            return "redirect:" + next;
        }
        return "redirect:/";
    }

}
