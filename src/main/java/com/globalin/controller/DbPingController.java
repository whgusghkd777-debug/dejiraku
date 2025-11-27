package com.globalin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DbPingController {
    @Autowired JdbcTemplate jdbcTemplate;

    @GetMapping("/dbping")
    @ResponseBody
    public String ping() {
        return jdbcTemplate.queryForObject("select 'OK' from dual", String.class);
    }
}