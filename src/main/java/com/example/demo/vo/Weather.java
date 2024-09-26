package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Weather {

	private String baseTime; // 기준 시간
	private String temperature; // 기온
	private String precipitationType; // 강수 형태
	private String precipitationProbability; // 강수 확률
	
}
