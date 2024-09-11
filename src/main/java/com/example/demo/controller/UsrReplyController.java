package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ReplyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Reply;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrReplyController {

	@Autowired
	private Rq rq;

	@Autowired
	private ReplyService replyService;

	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, String relTypeCode, int relId, String body) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(body)) {
			return Ut.jsHistoryBack("F-2", "내용을 입력해주세요");
		}

		ResultData writeReplyRd = replyService.writeReply(rq.getLoginedMemberId(), body, relTypeCode, relId);

		int id = (int) writeReplyRd.getData1();

		return Ut.jsReplace(writeReplyRd.getResultCode(), writeReplyRd.getMsg(), "../article/detail?id=" + relId);
	}

	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, int id, String body) {
		System.err.println(id);
		System.err.println(body);
		Rq rq = (Rq) req.getAttribute("rq");

		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 댓글은 존재하지 않습니다", id));
		}

		ResultData loginedMemberCanModifyRd = replyService.userCanModify(rq.getLoginedMemberId(), reply);

		if (loginedMemberCanModifyRd.isSuccess()) {
			replyService.modifyReply(id, body);
		}

		reply = replyService.getReply(id);

		return reply.getBody();
	}
	
	// 로그인 체크 -> 유무 체크 -> 권한 체크 -> 삭제
		@RequestMapping("/usr/reply/doDelete")
		@ResponseBody
		public String doDelete(HttpServletRequest req, int id) {

			Rq rq = (Rq) req.getAttribute("rq");

			// 유무 체크
			Reply reply = replyService.getReply(id);

			if (reply == null) {
				return Ut.jsHistoryBack("F-1", Ut.f("%d번 댓글이 없어 삭제되지 않았습니다.", id));
			}

			// 권한 체크
			ResultData userCanDeleteRd = replyService.userCanDelete(rq.getLoginedMemberId(), reply);

			if (userCanDeleteRd.isFail()) {
				return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
			}

			if (userCanDeleteRd.isSuccess()) {
				replyService.deleteReply(id);
			}

			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());

		}
}