package com.globalin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HotelsController {

  @GetMapping("/hotels")
  public String listHotels(
      @RequestParam(defaultValue = "all") String region,
      @RequestParam String checkin,
      @RequestParam String checkout,
      @RequestParam(defaultValue = "1") int guests,
      Model model) {

    model.addAttribute("region", region);
    model.addAttribute("checkin", checkin);
    model.addAttribute("checkout", checkout);
    model.addAttribute("guests", guests);
    return "hotels"; // /WEB-INF/views/hotels.jsp
  }
}
