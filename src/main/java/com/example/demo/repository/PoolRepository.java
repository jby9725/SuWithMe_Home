package com.example.demo.repository;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface PoolRepository {

	@Select("SELECT LAST_INSERT_ID();")
	public int getLastInsertId();

	@Insert("""
			INSERT INTO`pool`
			SET id = #{id},
			statusCode = #{statusCode}, 
			statusName = #{statusName}, 
			detailStatusCode = #{detailStatusCode}, 
			detailStatusName = #{detailStatusName}, 
			suspensionStartDate = #{suspensionStartDate}, 
			suspensionEndDate = #{suspensionEndDate}, 
			callNumber = #{callNumber}, 
			postalCodeLocation = #{postalCodeLocation}, 
			postalCodeStreet = #{postalCodeStreet}, 
			addressLocation = #{addressLocation}, 
			addressStreet = #{addressStreet}, 
			`name` = #{name}, 
			latitude = #{latitude}, 
			longitude = #{longitude}
			""")
	public void doInsertPoolInfo(int id, String statusCode, String statusName, String detailStatusCode, String detailStatusName, String suspensionStartDate, String suspensionEndDate, String callNumber, String postalCodeLocation, String postalCodeStreet, String addressLocation, String addressStreet, String name, String latitude, String longitude);

}