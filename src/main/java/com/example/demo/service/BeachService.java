package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.BeachRepository;
import com.example.demo.vo.Beach;

@Service
public class BeachService {

	@Autowired
	private BeachRepository beachRepository;

	public BeachService(BeachRepository beachRepository) {
		this.beachRepository = beachRepository;
	}

	public void doInsertBeachInfo(int id, String localGovernment, String managementOffice, String name,
			String address) {
		beachRepository.doInsertInfo(id, localGovernment, managementOffice, name, address);
	}

	// 해수욕장 리스트를 가져오는 메서드
	public List<Beach> getAllBeaches() {
		return beachRepository.getAllBeaches();
	}

	// 해수욕장의 위도/경도를 업데이트하는 메서드 (String 타입 사용)
	public void updateLatLon(int id, double latitude, double longitude) {
		// double 값을 문자열로 변환하여 저장
		String latStr = String.valueOf(latitude);
		String lonStr = String.valueOf(longitude);
		beachRepository.updateLatLon(id, latStr, lonStr);
	}
}