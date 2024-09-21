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

/* 이벤트에 이미지가 들어가는 경우 스타일 설정 */
.fc-event-title img {
    display: block;
    margin: 0 auto; /* 중앙 정렬 */
    width: 20px; /* 이미지 너비 설정 */
    height: 20px; /* 이미지 높이 설정 */
    vertical-align: middle;
}
</style>

<!-- FullCalendar 초기화 및 렌더링 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',  // 월간 보기 설정
        locale: 'ko',  // 한국어 설정
        headerToolbar: {
            left: 'prev,next today',  // 이전 달, 다음 달, 오늘 버튼만 표시
            center: 'title',  // 캘린더 타이틀만 표시
            right: ''  // 오른쪽에는 아무 버튼도 표시하지 않음
        },
        events: [
            <c:forEach var="event" items="${events}" varStatus="status">
                {
                    id: "${event.id}",
                    title: "${event.title}",
                    start: "${event.startDate}",  // 날짜만 표시
                    end: "${event.endDate}",
                    description: "${event.body}",
                    completed: ${event.completed},
                    allDay: true  // 하루 종일로 설정
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ],
        selectable: true,  // 날짜 선택 가능
        select: function(info) {  // 날짜를 선택했을 때 호출되는 함수
            // 선택한 날짜에 이미 일정이 있는지 확인
            var existingEvent = calendar.getEvents().find(event =>
                event.startStr === info.startStr
            );

            if (existingEvent) {
                alert('이미 일정이 존재합니다. 해당 일정을 클릭하여 완료 표시를 해주세요.');
            } else {
                var title = prompt('일정 제목을 입력하세요:');
                var description = prompt('일정 설명을 입력하세요:');

                if (title) {
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
                                id: response.id,
                                title: title,
                                start: info.startStr,
                                end: info.endStr,
                                description: description,
                                completed: false
                            });
                        },
                        error: function() {
                            alert('일정 추가 중 오류가 발생했습니다.');
                        }
                    });
                }
            }
            calendar.unselect();  // 선택 해제
        },
        eventClick: function(info) {  // 기존 이벤트 클릭 시
            var confirmComplete = confirm("이 일정을 '오수완'으로 표시하시겠습니까?");
            
            if (confirmComplete) {
                $.ajax({
                    url: '/usr/swimming/calender/markComplete',
                    method: 'POST',
                    data: {
                        eventId: info.event.id
                    },
                    success: function(response) {
                        if (response.resultCode === 'S-1') {
                            alert('일정이 완료 처리되었습니다.');
                            info.event.setProp('classNames', ['completed']);  // CSS 클래스 적용
                            info.event.setExtendedProp('completed', true);  // 이벤트 속성 변경
                            calendar.refetchEvents();  // 캘린더를 다시 로드하여 변경사항 반영
                        } else {
                            alert(response.msg);  // 실패 시 메시지 출력
                        }
                    },
                    error: function() {
                        alert('일정 완료 처리 중 오류가 발생했습니다.');
                    }
                });
            }
        },
        eventContent: function(arg) {  // 이벤트가 렌더링될 때 실행
            var completed = arg.event.extendedProps.completed;

            var eventContent = document.createElement('div');
            eventContent.classList.add('fc-event-title');
            eventContent.innerText = arg.event.title;

            if (completed) {
                var img = document.createElement('img');
                img.src = '/resource/success-640.png';  // 이미지 경로 설정
                img.style.width = '20px';
                img.style.height = '20px';
                eventContent.appendChild(img);
            }

            return { domNodes: [eventContent] };  // DOM 요소를 반환
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
