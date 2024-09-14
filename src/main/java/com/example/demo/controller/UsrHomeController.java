package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.util.CoordinateConverter;

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

	@RequestMapping("/usr/crawl")
	public String doCrawl() {

//		crawlTest.crawl();

		return "redirect:/usr/home/main";
	}

	@RequestMapping("/usr/home/doConvert")
	@ResponseBody
	public String doConvert() {
		// 예시 좌표 중부원점
		// 삼부스포렉스
		double x = 235289.3598;
		double y = 313785.6328;
		// 스위밍키즈 도안관저점
		double x2 = 230225.1814;
		double y2 = 311389.7903;
		// 프렌즈 아쿠아 키즈풀
		double x3 = 229834.4983;
		double y3 = 311562.7245;
		// 로키 스위밍 클럽
		double x4 = 234687.8785;
		double y4 = 316640.0369;
		// 아쿠아 차일드
		double x5 = 228687.1304;
		double y5 = 320281.1948;

		
		
		// 좌표 변환 수행
		// 삼부스포렉스
		double[] result = CoordinateConverter.convertProj4j(x, y);
		// 스위밍키즈 도안관저점
		double[] result2 = CoordinateConverter.convertProj4j(x2, y2);
		// 프렌즈 아쿠아 키즈풀
		double[] result3 = CoordinateConverter.convertProj4j(x3, y3);
		// 로키 스위밍 클럽
		double[] result4 = CoordinateConverter.convertProj4j(x4, y4);
		// 아쿠아 차일드
		double[] result5 = CoordinateConverter.convertProj4j(x5, y5);

		
		
		// 변환 결과 출력 (위도, 경도)
		return "Converted Coordinates<hr>" + "삼부 " + "Latitude = " + result[0] + ", Longitude = " + result[1] + "<hr>"
				+ "스위밍키즈 도안관저점 " + "Latitude = " + result2[0] + ", Longitude = " + result2[1] + "<hr>" + "프렌즈 아쿠아 키즈풀 "
				+ "Latitude = " + result3[0] + ", Longitude = " + result3[1] + "<hr>" + "로키 스위밍 클럽 " + "Latitude = "
				+ result4[0] + ", Longitude = " + result4[1] + "<hr>" + "아쿠아 차일드 " + "Latitude = " + result5[0]
				+ ", Longitude = " + result5[1] + "<hr>";
	}

//	@RequestMapping("/usr/home/doReverseConvert")
//	@ResponseBody
//	public String doReverseConvert() {
//		// 예시 좌표 위도경도
//
//		// 삼부 Latitude = 36.321275660519596, Longitude = 127.39303838517404
//		// 스위밍키즈 도안관저점 Latitude = 36.29985486233857, Longitude = 127.33654378665993
//		// 프렌즈 아쿠아 키즈풀 Latitude = 36.30142563006297, Longitude = 127.33220038211773
//		// 로키 스위밍 클럽 Latitude = 36.34702306539013, Longitude = 127.38646652309892
//		// 아쿠아 차일드 Latitude = 36.38003689859994, Longitude = 127.31974591948253
//
//		// 삼부스포렉스
//		double x = 36.321275660519596; // 위도
//		double y = 127.39303838517404; // 경도
//		// 스위밍키즈 도안관저점
//		double x2 = 36.29985486233857; // 위도
//		double y2 = 127.33654378665993; // 경도
//		// 프렌즈 아쿠아 키즈풀
//		double x3 = 36.30142563006297; // 위도
//		double y3 = 127.33220038211773; // 경도
//		// 로키 스위밍 클럽
//		double x4 = 36.34702306539013; // 위도
//		double y4 = 127.38646652309892; // 경도
//		// 아쿠아 차일드
//		double x5 = 36.38003689859994; // 위도
//		double y5 = 127.31974591948253; // 경도
//
//		// 좌표 변환 수행
//		double[] result = CoordinateConverter.reverseConvertProj4j(x, y);
//		double[] result2 = CoordinateConverter.reverseConvertProj4j(x2, y2);
//		double[] result3 = CoordinateConverter.reverseConvertProj4j(x3, y3);
//		double[] result4 = CoordinateConverter.reverseConvertProj4j(x4, y4);
//		double[] result5 = CoordinateConverter.reverseConvertProj4j(x5, y5);
//
//		// 변환 결과 출력 (중부원점)
//		return "Reverse Converted Coordinates<hr>" + "삼부 " + "x = " + result[0] + ", y = " + result[1] + "<hr>"
//				+ "스위밍키즈 도안관저점 " + "x = " + result2[0] + ", y = " + result2[1] + "<hr>" + "프렌즈 아쿠아 키즈풀 " + "x = "
//				+ result3[0] + ", y = " + result3[1] + "<hr>" + "로키 스위밍 클럽 " + "x = " + result4[0] + ", y = "
//				+ result4[1] + "<hr>" + "아쿠아 차일드 " + "x = " + result5[0] + ", y = " + result5[1] + "<hr>";
//	}
}