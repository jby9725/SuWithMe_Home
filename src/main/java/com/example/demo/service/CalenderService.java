package com.example.demo.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CalenderRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Event;
import com.example.demo.vo.ResultData;

@Service
public class CalenderService {

	@Autowired
	private CalenderRepository calenderRepository;

	public CalenderService(CalenderRepository calenderRepository) {
		this.calenderRepository = calenderRepository;
	}

	public List<Event> getAllEventsByMemberId(int memberId) {
		return calenderRepository.getAllEventsBymemberId(memberId); // 모든 일정 조회
	}

	public ResultData addEvent(String title, String body, String startDate, String endDate, int userId) {
		calenderRepository.addEvent(title, body, startDate, endDate, userId);

		return ResultData.from("S-1", Ut.f("일정이 등록되었습니다"));
	}

	public ResultData markComplete(int eventId) {
		// 이벤트 조회
		Event event = calenderRepository.getEventById(eventId);
		if (event == null) {
			return ResultData.from("F-1", "해당 일정이 존재하지 않습니다.");
		}

		// 이미 완료된 일정인지 확인
		if (event.isCompleted()) {
			return ResultData.from("F-2", "이미 '오수완'으로 표시된 일정입니다.");
		}

		// 완료 상태로 업데이트
		calenderRepository.updateCompletedStatus(eventId, true);

		return ResultData.from("S-1", "일정이 '오수완'으로 표시되었습니다.");
	}

	public ResultData addMultipleEvents(String title, String body, String startDate, String endDate, int memberId) {
        // startDate와 endDate를 LocalDate로 변환
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        // startDate부터 endDate까지 모든 날짜에 대해 이벤트 추가
        while (!start.isAfter(end)) {
            String currentDay = start.toString(); // 현재 날짜를 String 형식으로 변환
            
         // endDate를 다음 날 00:00으로 설정
            LocalDateTime endOfDay = start.plusDays(1).atStartOfDay(); // 다음 날 00:00
            String endDateTime = endOfDay.toString().replace("T", " "); // "yyyy-MM-dd HH:mm:ss" 형식으로 변환
            
            calenderRepository.addEvent(title, body, currentDay, endDateTime, memberId); // 하루 일정 추가
            
            start = start.plusDays(1); // 다음 날로 이동
        }

        return ResultData.from("S-1", Ut.f("일정이 %d일 동안 추가되었습니다.", ChronoUnit.DAYS.between(LocalDate.parse(startDate), LocalDate.parse(endDate)) + 1));
    }
	
	public Event getEventById(int id) {
        return calenderRepository.getEventById(id);
    }

	public ResultData userCanDelete(int loginedMemberId, Event event) {
		if (event.getMemberId() != loginedMemberId) {
			return ResultData.from("F-2", Ut.f("%d번 일정에 대한 삭제 권한이 없습니다", event.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 일정을 삭제했습니다", event.getId()));
	}

	public ResultData userCanModify(int loginedMemberId, Event event) {
		if (event.getMemberId() != loginedMemberId) {
			return ResultData.from("F-2", Ut.f("%d번 일정에 대한 수정 권한이 없습니다", event.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 일정을 수정했습니다", event.getId()), "수정된 일정", event);
	}

	public void deleteEvent(int id) {
		calenderRepository.deleteEvent(id);
	}

	public void modifyEvent(int id, String title, String body) {
		calenderRepository.modifyEvent(id, title, body);
	}
	
	public int getCompletedEventCountByMemberId(int memberId) {
        return calenderRepository.countCompletedEventsByMemberId(memberId);
    }

	public Map<String, Object> getTopCompletedMember() {
		return calenderRepository.getTopCompletedMember();
	}
}
