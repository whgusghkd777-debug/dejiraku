package com.globalin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HotelDetailController {

  @GetMapping("/hotel")
  public String detail() {
    return "hotel_detail"; // /WEB-INF/views/hotel_detail.jsp
  }
}
