package com.globalin.controller;

import com.globalin.domain.Member;
import com.globalin.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.sql.Date;

@Controller
@RequestMapping("/login")
public class JoinController {

 @Autowired MemberService memberService;

 @GetMapping("/join")
 public String showJoin() { return "join"; }

 @PostMapping("/join")
 public String doJoin(@RequestParam String userid,
                      @RequestParam String password,
                      @RequestParam String name,
                      @RequestParam String email,
                      @RequestParam String phone,
                      @RequestParam(required=false) String birth,
                      @RequestParam String gender) {

     Member m = new Member();
     m.setUserid(userid);
     m.setPasswordHash(password);
     m.setName(name);
     m.setEmail(email);
     m.setPhone(phone);
     if (birth != null && !birth.isEmpty()) {
         m.setBirthdate(Date.valueOf(birth)); // yyyy-MM-dd
     }
     m.setGender(gender);

     memberService.register(m);
     return "redirect:/login";  // 가입 성공 후 로그인 화면으로
 }
}