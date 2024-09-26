package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Beach;

@Mapper
public interface BeachRepository {

	@Select("SELECT LAST_INSERT_ID();")
	public int getLastInsertId();

	// 해수욕장 정보를 Beach 객체로 반환하는 쿼리
	@Select("""
			    SELECT `id`, `name`, nx, ny, latitude, longitude
			    FROM beach
			""")
	public List<Beach> getAllBeaches(); // 모든 해수욕장의 정보를 가져오는 메서드

	// 이하 일회성 쿼리
	@Insert("""
			INSERT INTO `beach`
			SET id = #{id},
			`name` = #{name},
			nx = #{nx},
			ny = #{ny},
			latitude = #{latitude},
			longitude = #{longitude}
			""")
	public void doInsertInfo(int id, String name, int nx, int ny, String latitude, String longitude);

}