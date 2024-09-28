package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Pool;

@Mapper
public interface PoolRepository {

	@Select("SELECT LAST_INSERT_ID();")
	public int getLastInsertId();

	@Select("""
			<script>
				SELECT COUNT(*)
				FROM pool;
			</script>
			""")
	public int getPoolsCount();

//	@Select("""
//			SELECT * FROM pool WHERE `name` LIKE '%삼부%';
//			""")
//	public List<Pool> getAllPools();

	@Select("""
			SELECT *
			FROM pool
			WHERE 1
			AND latitude IS NOT NULL AND latitude != ''
			AND longitude IS NOT NULL AND longitude != ''
			AND statusCode = 1;
			""")
	public List<Pool> getAllPools();

	@Select("""
			SELECT latitude
			FROM pool
			WHERE id = #{id}
			""")
	public String getX(int id);

	@Select("""
			SELECT longitude
			FROM pool
			WHERE id = #{id}
			""")
	public String getY(int id);

	// 이하 일회성 쿼리

	@Insert("""
			INSERT INTO `pool`
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
	public void doInsertPoolInfo(int id, String statusCode, String statusName, String detailStatusCode,
			String detailStatusName, String suspensionStartDate, String suspensionEndDate, String callNumber,
			String postalCodeLocation, String postalCodeStreet, String addressLocation, String addressStreet,
			String name, String latitude, String longitude);

	@Update("""
			UPDATE pool
			SET latitude = #{lat},
			longitude = #{lon}
			WHERE id = #{id}
			""")
	public void setLatLon(int id, double lat, double lon);

//	@Select("""
//			SELECT *
//			FROM pool
//			WHERE `name` = #{name}
//			""")
//	public Pool findByName(String name);

}