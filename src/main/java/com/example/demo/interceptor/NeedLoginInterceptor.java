package com.example.demo.interceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedLoginInterceptor implements HandlerInterceptor {

	@Autowired
	private Rq rq;

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
		Rq rq = (Rq) req.getAttribute("rq");

		if (!rq.isLogined()) {
			System.err.println("================== 로그인 하고 써주세요. ====================");
			String afterLoginUri = rq.getEncodedCurrentUri();
			// 로그인 페이지로 이동, 로그인 후 원래 페이지로 이동하도록 옵션 붙임.
			rq.printReplace("F-A", "로그인 후 이용해주세요", "/usr/member/login?afterLoginUri=" + afterLoginUri);

//			resp.getWriter().append("<script>~~~~");
			// 바로 이전 페이지로 이동
//			rq.printHistoryBack("로그인 하고 이용해주세요.");

			return false;

		}

		return HandlerInterceptor.super.preHandle(req, resp, handler);
	}

}