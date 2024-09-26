<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="SWIMMING CALENDER"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>

<%@ include file="../common/sidebar.jspf"%>

<!-- 여기서부터 내용 -->

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 스타일 설정 -->
<style>
#calendar {
	width: 100%;
	height: 75vh; /* 화면 높이의 75%로 조정 */
	max-width: 900px;
	margin: 20px auto;
}

/* 날짜 셀에 이미지가 중앙에 크게 표시되도록 설정 */
.fc-daygrid-day {
	position: relative; /* 내부 요소 절대 위치를 위해 부모 요소를 상대 위치로 설정 */
}

/* 이벤트 칸의 스타일 수정 */
.fc-daygrid-event {
	border: 1px solid #000 !important; /* 테두리 색상 설정 */
	color: #000 !important; /* 글자 색상을 검은색으로 설정 */
	font-weight: bold; /* 글자 두께 설정 */
	z-index: 1 !important; /* 이벤트 글씨 z-index 설정 */
}

/* 오수완 이미지 스타일 */
.osuwan-img {
	position: absolute;
	width: 100px; /* 이미지 크기 설정 */
	height: 100px; /* 이미지 크기 설정 */
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	opacity: 0.8; /* 투명도 설정 */
	z-index: 2; /* 다른 요소보다 위에 표시 */
}

/* 일정 추가 버튼 스타일 */
#addEventButton {
	display: block;
	margin: 20px auto;
	padding: 10px 20px;
	background-color: #4CAF50; /* 버튼 배경색 */
	color: white; /* 버튼 글자색 */
	border: none; /* 테두리 없음 */
	border-radius: 5px; /* 모서리 둥글게 */
	cursor: pointer; /* 마우스 커서 변경 */
	font-size: 16px; /* 글자 크기 */
	font-weight: bold; /* 글자 굵게 */
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
	transition: background-color 0.3s; /* 배경색 전환 효과 */
}

#addEventButton:hover {
	background-color: #45a049; /* 마우스 오버 시 배경색 변경 */
}

/* 일정 추가 폼(모달) 스타일 */
#addEventModal {
	display: none; /* 기본적으로 숨김 */
	position: fixed;
	z-index: 3; /* 모달이 맨 위에 표시되도록 */
	left: 50%;
	top: 50%;
	transform: translate(-50%, -50%);
	width: 400px;
	background-color: #fff;
	padding: 20px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 그림자 효과 */
	border-radius: 8px; /* 모서리 둥글게 */
}

/* 모달 배경 */
#modalBackground {
	display: none; /* 기본적으로 숨김 */
	position: fixed;
	z-index: 2; /* 모달 배경은 모달보다 뒤에 위치 */
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
}

#addEventModal input, #addEventModal textarea {
	width: 100%;
	margin-bottom: 10px;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

#addEventModal button {
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	padding: 10px;
	cursor: pointer;
}

#addEventModal button:hover {
	background-color: #45a049;
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
        selectable: false,  // 셀 클릭으로 일정 추가 기능 비활성화
        select: null,  // 셀 클릭으로 일정 추가 기능 비활성화
        dayCellDidMount: function(arg) {  // 각 날짜 셀이 렌더링된 후 실행
            var eventsOnDay = calendar.getEvents().filter(event => {
                // startDate와 endDate를 하루 전으로 설정
                var startDate = new Date(event.startStr);
                var endDate = new Date(event.endStr);
                
                // startDate와 endDate에서 하루를 빼기
                startDate.setDate(startDate.getDate() - 1);
                endDate.setDate(endDate.getDate() - 1);
                
                var cellDate = arg.date;
                
                // cellDate가 startDate-1와 endDate-1 사이에 있는지 확인
                return cellDate >= startDate && cellDate <= endDate && event.extendedProps.completed;
            });

            // 완료된 이벤트가 있으면 해당 날짜 셀에 이미지 추가
            if (eventsOnDay.length > 0) {
                var img = document.createElement('img');
                img.src = '/resource/success-640.png';  // 이미지 경로 설정
                img.classList.add('osuwan-img');  // 스타일 클래스 추가

                // 날짜 셀에 이미지 추가
                arg.el.style.position = 'relative';  // 부모 요소의 상대 위치 설정
                arg.el.appendChild(img);
            }
        },
        eventClick: function(info) {  // 이벤트 클릭 시 상세 페이지로 이동
            var eventId = info.event.id;  // 클릭한 이벤트의 ID
            window.location.href = "/usr/swimming/calender/detail?id=" + eventId;  // 상세 페이지로 이동
        }
    });

    calendar.render();  // 달력 렌더링

    // 일정 추가 폼 열기
    document.getElementById('addEventButton').addEventListener('click', function() {
        document.getElementById('addEventModal').style.display = 'block';
        document.getElementById('modalBackground').style.display = 'block';
    });

    // 모달 배경 클릭 시 폼 닫기
    document.getElementById('modalBackground').addEventListener('click', function() {
        document.getElementById('addEventModal').style.display = 'none';
        document.getElementById('modalBackground').style.display = 'none';
    });

    // 일정 추가 폼 제출
    document.getElementById('addEventForm').addEventListener('submit', function(event) {
        event.preventDefault();  // 폼 제출 기본 동작 막기

        var title = document.getElementById('eventTitle').value;
        var description = document.getElementById('eventDescription').value;
        var startDate = document.getElementById('eventStartDate').value;
        var endDate = document.getElementById('eventEndDate').value;

        if (!title || !startDate || !endDate) {
            alert('필수 항목을 모두 입력해주세요.');
            return;
        }

        // 서버로 일정 추가 요청
        $.ajax({
            url: '/usr/swimming/calender/addEvent',
            method: 'POST',
            data: {
                title: title,
                body: description,
                startDate: startDate,
                endDate: endDate
            },
            success: function(response) {
                alert('일정이 추가되었습니다.');
                window.location.reload();  // 일정 추가 후 페이지 새로고침
            },
            error: function() {
                alert('일정 추가 중 오류가 발생했습니다.');
            } 
        });
    });
});
</script>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex justify-center items-center m-16 bg-white rounded-lg">

	<div>
		<!-- 오수완 왕 섹션 -->
		<section class="top-completed-user">
			<div style="text-align: center; font-size: 1.5em; margin: 20px 0;">
				<strong>오수완 왕:</strong>
				<c:choose>
					<c:when test="${topMember != null}">
                ${topMember.nickname} (완료 횟수: ${topMember.completedCount})
            </c:when>
					<c:otherwise>
                오수완 왕이 아직 없습니다.
            </c:otherwise>
				</c:choose>
			</div>
		</section>

		<!-- 나의 오수완 완료 횟수 출력 -->
		<div style="text-align: center; font-size: 1.5rem; margin: 20px 0;">
			<strong>나의 오수완 완료 횟수:</strong>
			${completedEventCount}회
		</div>
	</div>

	<div>
		<!-- 일정 추가 버튼 -->
		<button id="addEventButton">일정 추가</button>

		<!-- FullCalendar가 표시될 div -->
		<div id="calendar" style="width: 900px; margin: 40px auto;"></div>
	</div>
</section>

<!-- 모달 배경 -->
<div id="modalBackground"></div>

<!-- 일정 추가 폼(모달) -->
<div id="addEventModal">
	<form id="addEventForm">
		<label for="eventTitle">일정 제목</label>
		<input type="text" id="eventTitle" name="eventTitle" required>
		<label for="eventDescription">일정 설명</label>
		<textarea id="eventDescription" name="eventDescription"></textarea>

		<label for="eventStartDate">시작 날짜</label>
		<input type="date" id="eventStartDate" name="eventStartDate" required>

		<label for="eventEndDate">종료 날짜</label>
		<input type="date" id="eventEndDate" name="eventEndDate" required>

		<button type="submit">일정 추가</button>
	</form>
</div>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>
