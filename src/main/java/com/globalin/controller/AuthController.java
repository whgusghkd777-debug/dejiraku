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

    /**
     * 로그인 처리
     * - 실패 시 에러메시지와 next를 그대로 들고 로그인 화면으로
     * - 성공 시 next(있으면)로, 없으면 홈으로
     */
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

    /**
     * 로그아웃
     * - next가 있으면 거기로, 없으면 홈으로
     */
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
