package com.example.demo.controller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class UsrProxyController {
	private final String CLIENT_ID = "tZ8PAfL1CjFknwH_rWcD"; // 발급받은 Client ID
	private final String CLIENT_SECRET = "DXtbtb6Jpo"; // 발급받은 Client Secret

	// 이미지 검색 API 프록시
	@GetMapping("/proxy/search/image")
	public ResponseEntity<String> searchImage(@RequestParam String query) {
		String apiUrl = "https://openapi.naver.com/v1/search/image?query=" + query;

		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Naver-Client-Id", CLIENT_ID);
		headers.set("X-Naver-Client-Secret", CLIENT_SECRET);

		HttpEntity<String> entity = new HttpEntity<>(headers);
		ResponseEntity<String> response = restTemplate.exchange(apiUrl, HttpMethod.GET, entity, String.class);

		return response;
	}
}