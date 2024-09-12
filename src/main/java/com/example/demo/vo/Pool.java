package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Pool {

	private int id; // 번호
	
	private String statusCode; // 영업상태구분코드
	private String statusName; // 영업상태명
	private String detailStatusCode; // 상세영업상태코드
	private String detailStatusName; // 상세영업상태명
	
	private String closingDate; // 폐업일자
	private String suspensionStartDate; // 휴업시작일자
	private String suspensionEndDate; // 휴업종료일자
	
	private String callNumber; // 소재지전화
	private String postalCodeLocation; // 소재지우편번호
	private String postalCodeStreet; // 도로명우편번호
	private String addressLocation;// 소재지전체주소
	private String addressStreet;// 도로명전체주소
	
	private String name;// 사업장명
	
	private String latitude; // 좌표정보(x)
	private String longitude; // 좌표정보(y)

}
