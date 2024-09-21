<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="SWIMMING CALENDER"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>

<!-- 여기서부터 내용 -->

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>


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
//     document.addEventListener('DOMContentLoaded', function() {
//         var calendarEl = document.getElementById('calendar');

//         var calendar = new FullCalendar.Calendar(calendarEl, {
//             initialView : 'dayGridMonth', // 월간 보기 설정
//             locale : 'ko', // 한국어 설정
//             headerToolbar : {
//                 left : 'prev,next today',
//                 center : 'title',
//                 right : 'dayGridMonth,dayGridWeek,dayGridDay'
//             },
//             events: [
//                 <c:forEach var="event" items="${events}" varStatus="status">
//                     {
//                         id: "${event.id}",
//                         title: "${event.title}",
//                         start: "${event.startDate}",
//                         end: "${event.endDate}",
//                         description: "${event.body}",
//                         completed: ${event.completed}
//                     }<c:if test="${!status.last}">,</c:if>
//                 </c:forEach>
//             ],
//             eventClick: function (info) {
//                 alert('Event: ' + info.event.title);
//                 // 상세 정보를 모달이나 팝업으로 표시할 수 있습니다.
//             }
//         });

//         calendar.render(); // 달력 렌더링
//     });
</script>

<!-- 캘린더 일정 추가 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',  // 월간 보기 설정
            locale: 'ko',  // 한국어 설정
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: ''
            },
            events: [
                <c:forEach var="event" items="${events}" varStatus="status">
                    {
                        id: "${event.id}",
                        title: "${event.title}",
                        start: "${event.startDate}",
                        end: "${event.endDate}",
                        description: "${event.body}",
                        completed: ${event.completed},
                        allDay: true  // 하루 종일로 설정
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            selectable: true,  // 날짜 선택 가능
            select: function(info) {  // 날짜를 선택했을 때 호출되는 함수
                // 모달 또는 팝업으로 일정 제목과 설명을 입력받도록 설정
                var title = prompt('일정 제목을 입력하세요:');
                var description = prompt('일정 설명을 입력하세요:');
                
                if (title) {
                    // 서버로 일정 추가 요청을 보냄
                    $.ajax({
                        url: '/usr/swimming/calender/addEvent',
                        method: 'POST',
                        data: {
                            title: title,
                            body: description,
                            startDate: info.startStr,
                            endDate: info.endStr
                        },
                        success: function(response) {
                            alert('일정이 추가되었습니다.');
                            calendar.addEvent({
                                id: response.id,  // 서버에서 생성된 일정 ID
                                title: title,
                                start: info.startStr,
                                end: info.endStr,
                                description: description
                            });
                        },
                        error: function() {
                            alert('일정 추가 중 오류가 발생했습니다.');
                        }
                    });
                }
                calendar.unselect();  // 선택 해제
            }
        });

        calendar.render();  // 달력 렌더링
    });
</script>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">

	<!-- FullCalendar가 표시될 div -->
	<div id="calendar" style="max-width: 900px; margin: 40px auto;"></div>

</section>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>
