package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrPoolController {

	@RequestMapping("/usr/pool/main")
	public String showPoolMain() {
		return "/usr/pool/main";
	}

	@RequestMapping("/usr/pool/map")
	public String showPoolMap() {
		return "/usr/pool/map";
	}

	@RequestMapping("/usr/pool/teaching")
	public String showPoolTeaching() {
		return "/usr/pool/teaching";
	}

}