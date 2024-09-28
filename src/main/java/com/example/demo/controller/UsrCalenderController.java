package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.CalenderService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Event;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrCalenderController {

	@Autowired
	private Rq rq;

	@Autowired
	private CalenderService calenderService;

	@RequestMapping("/usr/swimming/calender")
	public String showCalender(HttpServletRequest req, Model model) {

		Rq rq = (Rq) req.getAttribute("rq");

		int userId = rq.getLoginedMemberId();

		System.err.println("userId : " + userId);

		List<Event> events = calenderService.getAllEventsByMemberId(userId); // 모든 일정 조회
		model.addAttribute("events", events); // 조회한 일정들을 모델에 추가

		// 로그인한 사용자가 완료한 일정의 개수를 조회하여 모델에 추가
		int completedEventCount = calenderService.getCompletedEventCountByMemberId(userId);
		model.addAttribute("completedEventCount", completedEventCount);

		// 오수완 왕 조회
		Map<String, Object> topMember = calenderService.getTopCompletedMember();
		model.addAttribute("topMember", topMember);

		return "/usr/swimming/calender";
	}

	@RequestMapping("/usr/swimming/calender/addEvent")
	@ResponseBody
	public String addEvent(HttpServletRequest req, String title, String body, String startDate, String endDate) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(title)) {
			return Ut.jsHistoryBack("F-1", "일정 제목을 입력해주세요");
		}
		if (Ut.isEmptyOrNull(body)) {
			return Ut.jsHistoryBack("F-2", "일정 내용을 입력해주세요");
		}
		if (Ut.isEmptyOrNull(startDate)) {
			return Ut.jsHistoryBack("F-3", "일정 시작 날짜를 선택해주세요");
		}
		if (Ut.isEmptyOrNull(endDate)) {
			return Ut.jsHistoryBack("F-4", "일정 종료 날짜를 선택해주세요");
		}

		System.err.println(rq.getLoginedMemberId());

		int userId = rq.getLoginedMemberId();

		// ResultData addEventRd = calenderService.addEvent(title, body, startDate, endDate, userId);
		ResultData addEventRd = calenderService.addMultipleEvents(title, body, startDate, endDate, userId);
		
		return Ut.jsReplace(addEventRd.getResultCode(), addEventRd.getMsg(), "/usr/swimming/calender");
	}

	@RequestMapping("/usr/swimming/calender/markComplete")
	@ResponseBody
	public ResultData markComplete(@RequestParam("eventId") int id) {

		System.out.println("확인) eventId : " + id);

		if (id == 0) {
			return ResultData.from("F-1", "일정 ID가 전달되지 않았습니다.");
		}

		// 이벤트를 완료 상태로 업데이트하는 서비스 호출
		ResultData markCompleteRd = calenderService.markComplete(id);
		return markCompleteRd;
	}

	@RequestMapping("/usr/swimming/calender/detail")
	public String showEventDetail(@RequestParam("id") int id, Model model) {
		Event event = calenderService.getEventById(id);
		if (event == null) {
			return "redirect:/usr/swimming/calender";
		}
		model.addAttribute("event", event);
		return "/usr/swimming/detail";
	}

	@RequestMapping("/usr/swimming/calender/doDelete")
	@ResponseBody
	public String doDelete(HttpServletRequest req, int id) {

		Rq rq = (Rq) req.getAttribute("rq");

		// 유무 체크
		Event event = calenderService.getEventById(id);

		if (event == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 일정이 없어 삭제되지 않았습니다.", id));
		}

		// 권한 체크
		ResultData userCanDeleteRd = calenderService.userCanDelete(rq.getLoginedMemberId(), event);

		if (userCanDeleteRd.isFail()) {
			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
		}

		if (userCanDeleteRd.isSuccess()) {
			calenderService.deleteEvent(id);
		}

		return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../swimming/calender");

	} // /usr/article/doDelete?id=1

	// 유무 체크 -> 권한 체크 -> 수정
	@RequestMapping("/usr/swimming/calender/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, int id, String title, String body) {

		Rq rq = (Rq) req.getAttribute("rq");

		// id 값 확인 로그
		System.err.println("id 값 확인 로그. id: " + id);

		if (id == 0) {
			return Ut.jsHistoryBack("F-1", "일정 ID가 전달되지 않았습니다.");
		}

		// 수정되기 전
		Event event = calenderService.getEventById(id);

		// 유무 체크
		if (event == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 일정을 찾을 수 없어 수정되지 않았습니다.", id));
		}

		// 권한 체크
		ResultData userCanModifyRd = calenderService.userCanModify(rq.getLoginedMemberId(), event);

		if (userCanModifyRd.isFail()) {
			return Ut.jsHistoryBack("F-2", Ut.f("%d번 일정을 수정할 권한이 없습니다.", id));
		}

		// 수정
		if (userCanModifyRd.isSuccess()) {
			calenderService.modifyEvent(id, title, body);
		}

		// 수정된 게시글 다시 불러옴
		// event = calenderService.getEventById(id);

		return Ut.jsReplace(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "../swimming/calender");
	}
}