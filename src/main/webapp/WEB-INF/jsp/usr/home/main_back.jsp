<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MAIN"></c:set>
<%@ include file="../common/head_NonOption.jspf"%>
<!-- 여기서부터 내용 -->

<div id="background" style="width: 100%; height: 100vh;"></div>

<script>
	VANTA.WAVES({
		el : "#background",
		mouseControls : true,
		touchControls : true,
		gyroControls : false,
		minHeight : 200.00,
		minWidth : 200.00,
		scale : 1.00,
		scaleMobile : 1.00,
		color : 0x1d549b
	})
</script>

<div class="container">
	<div class="side-bar left">
		<p>실내 수영</p>
	</div>
	<div>
		<a href="/">
			<img src="/resource/LOGO_black.png" alt="logo" class="h-20">
		</a>
		<div>환영합니다.</div>
	</div>
	<div class="side-bar right">
		<p>야외 수영</p>
	</div>
</div>


<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>