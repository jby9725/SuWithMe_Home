package com.example.demo.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Event {

	private int id;

	private String title;
	private String body;
	private Date createDate;
	private Date updateDate;
	private Date startDate;
	private Date endDate;
	private boolean completed;
	private int userId;
	
	private int memberId;
	private String nickname;
}
