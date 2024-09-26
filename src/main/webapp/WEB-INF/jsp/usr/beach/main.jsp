<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="BEACH MAIN"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<%@ include file="../common/sidebar.jspf"%>

<!-- 여기서부터 내용 -->

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<div class="">
	<a href="../article/list?boardId=1">공지사항</a>
</div>
<div class="">
	<a href="../article/list?boardId=2">자유게시판</a>
</div>
<div class="">
	<a href="../article/list?boardId=4">야외 수영 위드미 게시판</a>
</div>
<div class="">
	<a href="../beach/map">해수욕장</a>
</div>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>