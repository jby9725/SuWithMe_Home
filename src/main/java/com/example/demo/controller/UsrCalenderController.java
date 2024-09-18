package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrCalenderController {

//	@Autowired
//	private CalenderService calenderService;

	@RequestMapping("/usr/swimming/calender")
	public String showCalender() {
		return "/usr/swimming/calender";
	}
}