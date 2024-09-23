package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrHomeController {

	@RequestMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}

	@RequestMapping("/usr/home/main")
	public String showMain() {
		return "/usr/home/main";
	}

	@RequestMapping("/usr/home/menu")
	public String showMenu() {
		return "/usr/home/menu";
	}

	@RequestMapping("/usr/crawl")
	public String doCrawl() {

//		crawlTest.crawl();

		return "redirect:/usr/home/main";
	}
	
}