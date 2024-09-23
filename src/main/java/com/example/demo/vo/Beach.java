package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Beach {

	private int id; // 번호
	
	private String localGovernment; // 지자체
    private String managementOffice; // 관리청
    private String name; // 해수욕장 이름
    private String address; // 해수욕장 주소
		
	private String latitude; // 좌표정보(x)
	private String longitude; // 좌표정보(y)

}
