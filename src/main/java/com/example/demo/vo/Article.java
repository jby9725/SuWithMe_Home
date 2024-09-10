package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Article {

	private int id;
	private String regDate;
	private String updateDate;
	
	private int memberId;
	private int boardId;
	
	private String title;
	private String body;
	private int hit;
	
	private int goodReactionPoint;
	private int badReactionPoint;
	
	private int extra__sumReactionPoint;
	private String extra__writer;
	private String extra__repliesCount;
	
	private boolean userCanModify;
	private boolean userCanDelete;
}
