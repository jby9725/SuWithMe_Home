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

	public void doInsertBeachInfo(int id, String name, int nx, int ny, String latitude, String longitude) {
		beachRepository.doInsertInfo(id, name, nx, ny, latitude, longitude);
	}

	// 해수욕장 리스트를 가져오는 메서드
	public List<Beach> getAllBeaches() {
		return beachRepository.getAllBeaches();
	}

}