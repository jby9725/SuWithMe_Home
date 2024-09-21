<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Event Detail"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<!-- 여기서부터 내용 -->

<style>
    .detail-container {
        max-width: 800px;
        margin: 40px auto;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #f9f9f9;
    }
    .detail-item {
        margin-bottom: 15px;
    }
    .detail-item label {
        font-weight: bold;
        display: block;
    }
    .detail-item span, .detail-item input, .detail-item textarea {
        display: block;
        margin-top: 5px;
        font-size: 16px;
    }
    .detail-item input, .detail-item textarea {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .btn-container {
        text-align: center;
        margin-top: 20px;
    }
    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        background-color: #4CAF50;
        color: white;
        cursor: pointer;
        font-size: 16px;
        text-decoration: none;
    }
    .btn:hover {
        background-color: #45a049;
    }
    .btn-complete {
        background-color: #2196F3;
    }
    .btn-complete:hover {
        background-color: #1e88e5;
    }
    .btn-delete {
        background-color: #f44336;
    }
    .btn-delete:hover {
        background-color: #e53935;
    }
    .btn-cancel {
        background-color: #888;
    }
    .btn-cancel:hover {
        background-color: #777;
    }
    .disabled-field {
        background-color: #f0f0f0;
        color: #888;
    }
    .btn-disabled {
        cursor: not-allowed;
        background-color: #cccccc; /* 비활성화 버튼 색상 */
    }
</style>

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<div class="detail-container">
    <form id="updateEventForm">
        <input type="hidden" id="eventId" value="${event.id}">

        <div class="detail-item">
            <label for="eventTitle">일정 제목:</label>
            <input type="text" id="eventTitle" name="title" value="${event.title}" required>
        </div>
        <div class="detail-item">
            <label for="eventBody">일정 내용:</label>
            <textarea id="eventBody" name="body" required>${event.body}</textarea>
        </div>
        <div class="detail-item">
            <label for="eventCompleted">오수완:</label>
            <!-- completed 필드를 텍스트로만 표시 -->
            <span>${event.completed ? '완료됨' : '미완료'}</span>
        </div>
        <div class="detail-item">
            <label for="eventStartDate">시작 날짜:</label>
            <!-- 시작 날짜를 수정할 수 없도록 input을 비활성화 -->
            <input type="date" id="eventStartDate" name="startDate" value="${event.startDate}" class="disabled-field" readonly>
        </div>
        <div class="detail-item">
            <label for="eventEndDate">종료 날짜:</label>
            <!-- 종료 날짜를 수정할 수 없도록 input을 비활성화 -->
            <input type="date" id="eventEndDate" name="endDate" value="${event.endDate}" class="disabled-field" readonly>
        </div>
        <div class="detail-item">
            <label>생성일:</label>
            <span>${event.createDate}</span>
        </div>
        <div class="detail-item">
            <label>수정일:</label>
            <span>${event.updateDate}</span>
        </div>
        <div class="detail-item">
            <label>작성자:</label>
            <span>${event.nickname}</span> <!-- 작성자를 nickname으로 표시 -->
        </div>

        <div class="btn-container">
            <button type="submit" class="btn">일정 수정</button>
            <button type="button" id="completeEventButton" 
                class="btn btn-complete ${event.completed ? 'btn-disabled' : ''}" 
                ${event.completed ? 'disabled' : ''}>일정 완료</button>
            <button type="button" id="deleteEventButton" class="btn btn-delete">일정 삭제</button>
            <a href="/usr/swimming/calender" class="btn btn-cancel">취소</a>
        </div>
    </form>
</div>

<script>
    // 일정 수정
    document.getElementById('updateEventForm').addEventListener('submit', function(event) {
        event.preventDefault();  // 폼 제출 기본 동작 막기

        var eventId = document.getElementById('eventId').value;
        var title = document.getElementById('eventTitle').value;
        var body = document.getElementById('eventBody').value;

        if (!title || !body) {
            alert('모든 필드를 입력해주세요.');
            return;
        }

        $.ajax({
            url: '/usr/swimming/calender/doModify',
            method: 'POST',
            data: {
                id: eventId,
                title: title,
                body: body
            },
            success: function(response) {
                alert('일정이 수정되었습니다.');
                window.location.href = "/usr/swimming/calender";
            },
            error: function() {
                alert('일정 수정 중 오류가 발생했습니다.');
            }
        });
    });

    // 일정 완료
    document.getElementById('completeEventButton').addEventListener('click', function() {
        var eventId = document.getElementById('eventId').value;

        // 완료된 일정이면 아무 동작도 하지 않도록 설정
        if (this.classList.contains('btn-disabled')) {
            alert('이미 완료된 일정입니다.');
            return;
        }

        var confirmComplete = confirm("이 일정을 완료 처리하시겠습니까?");

        if (confirmComplete) {
            $.ajax({
                url: '/usr/swimming/calender/markComplete',
                method: 'POST',
                data: {
                    eventId: eventId
                },
                success: function(response) {
                    alert('일정이 완료되었습니다.');
                    window.location.href = "/usr/swimming/calender";
                },
                error: function() {
                    alert('일정 완료 처리 중 오류가 발생했습니다.');
                }
            });
        }
    });

    // 일정 삭제
    document.getElementById('deleteEventButton').addEventListener('click', function() {
        var eventId = document.getElementById('eventId').value;
        var confirmDelete = confirm("이 일정을 삭제하시겠습니까?");

        if (confirmDelete) {
            $.ajax({
                url: '/usr/swimming/calender/doDelete',
                method: 'POST',
                data: {
                    id: eventId
                },
                success: function(response) {
                    alert('일정이 삭제되었습니다.');
                    window.location.href = "/usr/swimming/calender";
                },
                error: function() {
                    alert('일정 삭제 중 오류가 발생했습니다.');
                }
            });
        }
    });
</script>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>
