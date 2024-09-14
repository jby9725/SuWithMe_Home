package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.PoolRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;

@Service
public class PoolService {

	@Autowired
	private PoolRepository poolRepository;

	public PoolService(PoolRepository poolRepository) {
		this.poolRepository = poolRepository;
	}

	public void doInsertPoolInfo(int id, String statusCode, String statusName, String detailStatusCode,
			String detailStatusName, String suspensionStartDate, String suspensionEndDate, String callNumber,
			String postalCodeLocation, String addressLocation, String addressStreet, String postalCodeStreet,
			String name, String latitude, String longitude) {

		poolRepository.doInsertPoolInfo(id, statusCode, statusName, detailStatusCode, detailStatusName,
				suspensionStartDate, suspensionEndDate, callNumber, postalCodeLocation, addressLocation, addressStreet,
				postalCodeStreet, name, latitude, longitude);

	}

	public int getPoolsCount() {
		return poolRepository.getPoolsCount();
	}

	public String getX(int i) {
		return poolRepository.getX(i);
	}

	public String getY(int i) {
		return poolRepository.getY(i);
	}

	public void setLatLon(int i, double lat, double lon) {
		poolRepository.setLatLon(i, lat, lon);
		System.err.println(i+"번째 행 Update...");
	}

}