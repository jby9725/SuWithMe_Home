<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="LOGIN"></c:set>
<%@ include file="../common/head_NonOption.jspf"%>


<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		<form action="../member/doLogin" method="POST">
			<input type="hidden" name="afterLoginUri" value="${param.afterLoginUri }" />
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th>아이디</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="loginId" autocomplete="off"
								type="text" placeholder="아이디를 입력해" />
						</td>

					</tr>
					<tr>
						<th>비밀번호</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="loginPw" autocomplete="off"
								type="text" placeholder="비밀번호를 입력해" />
						</td>

					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-primary">로그인</button>
						</td>

					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<a class="btn btn-outline btn-primary" href="${rq.findLoginIdUri }">아이디 찾기</a>
							<a class="btn btn-outline btn-success" href="${rq.findLoginPwUri }">비밀번호찾기</a>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn" type="button" onclick="history.back()">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf"%>

<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> --%>
<%-- <c:set var="pageTitle" value="LOGIN"></c:set> --%>
<%-- <%@ include file="../common/head.jspf"%> --%>
<!-- <hr /> -->


<!-- <form action="/usr/member/doLogin" method="post" class="max-w-md mx-auto mt-10 p-6 bg-white rounded-lg shadow-lg"> -->
<%-- 	<input type="hidden" name="afterLoginUri" value="${param.afterLoginUri }" /> --%>
<!-- 	<div class="mb-4"> -->
<!-- 		<label for="loginId" class="block text-sm font-medium text-gray-700">ID</label> -->
<!-- 		<input type="text" id="loginId" name="loginId" required -->
<!-- 			class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"> -->
<!-- 	</div> -->
<!-- 	<div class="mb-6"> -->
<!-- 		<label for="loginPw" class="block text-sm font-medium text-gray-700">Password</label> -->
<!-- 		<input type="text" id="loginPw" name="loginPw" required -->
<!-- 			class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"> -->
<!-- 	</div> -->
<!-- 	<div> -->
<!-- 		<button type="submit" -->
<!-- 			class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">Login</button> -->
<!-- 	</div> -->
<!-- </form> -->

<!-- <div class="btns"> -->
<!-- 	<button class="btn" type="button" onclick="history.back()">뒤로가기</button> -->
<!-- </div> -->


<%-- <%@ include file="../common/foot.jspf"%> --%>