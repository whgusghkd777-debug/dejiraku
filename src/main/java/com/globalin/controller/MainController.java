package com.globalin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainController {

    @GetMapping({"/", "/home"})
    @ResponseBody 
    public String home() {
        // 일본어 메인 메시지 구성
        return "<html><body style='text-align:center; padding-top:50px; font-family: sans-serif;'>" +
               "<h1>ホテル予約システム (Hotel Reservation System)</h1>" +
               "<p style='color: green;'>✔ サーバー (正常稼働中)</p>" +
               "<p>Replitへのデプロイに成功しました。おめでとうございます！</p>" +
               "<hr style='width:50%;'>" +
               "<a href='/login/find' style='text-decoration:none; color: #007bff; font-weight: bold;'>🔍 ログイン情報を忘れた方はこちら</a>" +
               "</body></html>";
    }

    @GetMapping("/login/find")
    @ResponseBody 
    public String find() {
        // 찾기 페이지 응답
        return "<h3>ログイン情報探し (Login Recovery Page)</h3>" +
               "<p>こちらはログイン情報を確認するページです。</p>" +
               "<br><a href='/'>[戻る]</a>";
    }
}
