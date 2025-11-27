package com.globalin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping({"/", "/home"})
    public String home() {
        return "main"; // /WEB-INF/views/main.jsp
    }

    @GetMapping("/login/find")
    public String find() {
    	return "find";
    }
}