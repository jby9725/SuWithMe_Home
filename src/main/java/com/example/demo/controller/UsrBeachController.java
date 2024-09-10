package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrBeachController {

	@RequestMapping("/usr/beach/main")
	public String showBeachMain() {
		return "/usr/beach/main";
	}

	@RequestMapping("/usr/beach/map")
	public String showBeachMap() {
		return "/usr/beach/map";
	}
	
}