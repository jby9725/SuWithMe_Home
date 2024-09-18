<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="SWIMMING CALENDER"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>

<!-- 스타일 설정 -->
<style>
#calendar {
	width: 100%;
	height: 75vh; /* 화면 높이의 75%로 조정 */
	max-width: 900px;
	margin: 40px auto;
}
</style>

<!-- FullCalendar 초기화 및 렌더링 -->
<script>
	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');

		var calendar = new FullCalendar.Calendar(calendarEl, {
			initialView : 'dayGridMonth', // 월간 보기 설정
			locale : 'ko', // 한국어 설정
			headerToolbar : {
				left : 'prev,next today',
				center : 'title',
				right : 'dayGridMonth,dayGridWeek,dayGridDay'
			}
		});

		calendar.render(); // 달력 렌더링
	});
</script>

<!-- 여기서부터 내용 -->

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">

	<!-- FullCalendar가 표시될 div -->
	<div id='calendar'></div>

</section>


<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>