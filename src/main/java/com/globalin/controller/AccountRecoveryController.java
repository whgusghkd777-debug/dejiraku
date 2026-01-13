// src/main/java/com/globalin/controller/AccountRecoveryController.java
package com.globalin.controller;

import com.globalin.dao.MemberDao;
import com.globalin.domain.Member;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.SecureRandom;

@Controller
@RequestMapping("/member/find")
public class AccountRecoveryController {

    private final MemberDao memberDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public AccountRecoveryController(MemberDao memberDao, BCryptPasswordEncoder passwordEncoder) {
        this.memberDao = memberDao;
        this.passwordEncoder = passwordEncoder;
    }
    // ID 探すこと
    @PostMapping("/id")
    public String findId(@RequestParam String name,
                         @RequestParam String email,
                         Model model) {

        Member m = memberDao.findByNameAndEmail(name, email);
        if (m != null) {
            model.addAttribute("ok", "該当会員のID: " + m.getUserid());
        } else {
            model.addAttribute("error", "該当する会員を見つけられませんでした。");
        }
        return "recovery/result"; // /WEB-INF/views/recovery/result.jsp
    }
// Pw探す
    @PostMapping("/pw")
    public String findPw(@RequestParam String userid,
                         @RequestParam String email,
                         Model model) {

        Member m = memberDao.findByUseridAndEmail(userid, email);
        if (m == null) {
            model.addAttribute("error", "IDまたはメールが一致しません。");
            return "recovery/result";
        }

        // 1️⃣ 임시 비밀번호 생성
        String temp = generateTempPassword(10);

        // 2️⃣ 해시화 후 DB에 저장
        String hash = passwordEncoder.encode(temp);
        int updated = memberDao.updatePasswordHashByUseridAndEmail(userid, email, hash);

        // 3️⃣ 결과 처리
        if (updated > 0) {
            model.addAttribute("ok", "仮パスワード: " + temp + "  (ログイン後に変更してください)");
        } else {
            model.addAttribute("error", "一時パスワードの発行に失敗しました。");
        }

        return "recovery/result";
    }

    /** =====================
     *  🔹 GET 접근 시 안내문
     *  ===================== */
    @GetMapping({"/id", "/pw"})
    @ResponseBody
    public String methodNotAllowed() {
        return "このエンドポイントはPOSTのみ対応しています。";
    }

    /** =====================
     *  🔹 임시 비밀번호 생성 헬퍼
     *  ===================== */
    private static final String ALPH =
            "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";
    private static final SecureRandom RND = new SecureRandom();

    private String generateTempPassword(int n) {
        StringBuilder sb = new StringBuilder(n);
        for (int i = 0; i < n; i++)
            sb.append(ALPH.charAt(RND.nextInt(ALPH.length())));
        return sb.toString();
    }
}

