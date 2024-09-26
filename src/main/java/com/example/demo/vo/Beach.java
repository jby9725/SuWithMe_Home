package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Beach {

	private int id; // 번호
	private String name; // 해수욕장 이름
    
	private int nx; // 기상청 좌표 nx
	private int ny; // 기상청 좌표 ny
	
	private String latitude; // 위도
	private String longitude; // 경도

}
