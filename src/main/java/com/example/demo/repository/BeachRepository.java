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
        SELECT `id`, localGovernment, managementOffice, `name`, address 
        FROM beach
    """)
    public List<Beach> getAllBeaches(); // 모든 해수욕장의 정보를 가져오는 메서드
	
    // 일회성 쿼리
    // 해수욕장의 위도/경도를 업데이트하는 쿼리 (VARCHAR로 저장)
    @Update("""
        UPDATE beach 
        SET latitude = #{latitude}, longitude = #{longitude} 
        WHERE id = #{id}
    """)
    public void updateLatLon(int id, String latitude, String longitude);
    
	// 이하 일회성 쿼리
	@Insert("""
			INSERT INTO `beach`
			SET id = #{id},
			localGovernment = #{localGovernment},
			managementOffice = #{managementOffice},
			`name` = #{name},
			address = #{address}
			""")
	public void doInsertInfo(int id, String localGovernment, String managementOffice, String name, String address);

}