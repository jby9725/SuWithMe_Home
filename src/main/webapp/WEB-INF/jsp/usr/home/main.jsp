<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>수위드미</title>
<link rel="stylesheet" href="/resource/common.css" />
<script src="/resource/common.js" defer="defer"></script>
<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<!-- 테일윈드 -->
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2/dist/tailwind.min.css" rel="stylesheet" type="text/css" />

<!-- vanta.js 적용 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r121/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vanta/dist/vanta.waves.min.js"></script>

<style>
body {
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}

#background {
	position: absolute;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	z-index: -1;
}

/* 좌측 패널 호버 트리거 */
.hover-area-left {
	position: fixed;
	top: 0;
	left: 0;
	width: 50px; /* 호버 트리거 넓이 */
	height: 100vh;
	z-index: 50;
	cursor: pointer;
}

/* 좌측 패널 */
/* .side-panel.left-panel { */
/* 	transform: translateX(-90%); /* 초기 위치를 화면 밖으로 설정, 90%가 숨겨짐 */ */
/* 	transition: transform 0.5s ease; /* 패널이 부드럽게 이동하도록 설정 */ */
/* } */

/* 호버 시 패널이 나타나도록 설정 */
/* .hover-area-left:hover ~ .side-panel.left-panel, */
/* .side-panel.left-panel:hover { */
/* 	transform: translateX(0); /* 호버 시 패널이 완전히 나타남 */ */
/* } */

/* 좌측 패널 호버 트리거 */
.hover-area-left {
	position: fixed;
	top: 0;
	left: 0;
	width: 20px; /* 호버 트리거 넓이 */
	height: 100vh;
	z-index: 50;
	cursor: pointer;
}

/* 좌측 패널 */
.side-panel.left-panel {
	transform: translateX(-95%); /* 초기 위치를 화면 밖으로 설정, 95%가 숨겨짐 */
	transition: transform 0.5s ease; /* 패널이 부드럽게 이동하도록 설정 */
}

/* 호버 시 패널이 나타나도록 설정 */
.hover-area-left:hover ~ .side-panel.left-panel,
.side-panel.left-panel:hover {
	transform: translateX(0); /* 호버 시 패널이 완전히 나타남 */
}

/* 1차 메뉴 스타일 */
.menu-item {
	cursor: pointer;
}

/* 2차 메뉴 스타일 */
.sub-menu {
	display: none; /* 기본적으로 숨김 */
	margin-left: 20px; /* 들여쓰기 효과 */
}

/* 1차 메뉴 클릭 시 2차 메뉴 표시 */
.menu-item.active + .sub-menu {
	display: block;
}

</style>

<script>
	document.addEventListener('DOMContentLoaded', function() {
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
		});
	});
</script>

<script>
document.addEventListener('DOMContentLoaded', function () {
	// 1차 메뉴 클릭 시 2차 메뉴 표시/숨김
	const menuItems = document.querySelectorAll('.menu-item');

	menuItems.forEach(function (item) {
		item.addEventListener('click', function () {
			// 모든 메뉴 아이템의 active 클래스 제거
			menuItems.forEach(function (menuItem) {
				menuItem.classList.remove('active');
				const subMenu = menuItem.nextElementSibling;
				if (subMenu && subMenu.classList.contains('sub-menu')) {
					subMenu.style.display = 'none';
				}
			});
			
			// 클릭한 메뉴 아이템에 active 클래스 추가 및 2차 메뉴 표시
			item.classList.add('active');
			const subMenu = item.nextElementSibling;
			if (subMenu && subMenu.classList.contains('sub-menu')) {
				subMenu.style.display = 'block';
			}
		});
	});
});
</script>

</head>

<body class="relative min-h-screen flex flex-col justify-between bg-white">

	<div id="background"></div>

	<!-- 상단 우측 로그인/회원가입/마이페이지 -->
	<header class="w-full flex justify-center py-4">
		<ul class="flex space-x-4 text-2xl">
			<c:if test="${!rq.isLogined() }">
				<li>
					<a class="hover:text-blue-500" href="../member/login">로그인</a>
				</li>
				<li>
					<a class="hover:text-blue-500" href="../member/join">회원가입</a>
				</li>
			</c:if>
			<c:if test="${rq.isLogined() }">
				<li>
					<a class="hover:text-blue-500" href="../member/myPage">마이페이지</a>
				</li>
				<li>
					<a onclick="if(confirm('로그아웃 하시겠습니까?') == false) return false;" class="hover:text-blue-500" href="../member/doLogout">로그아웃</a>
				</li>
			</c:if>
		</ul>
	</header>

	<!-- 중앙 정렬된 로고 및 환영 메시지 -->
	<div class="flex-grow flex items-center justify-center flex-col text-center">
		<a href="/">
			<img src="/resource/LOGO_black.png" alt="logo" class="h-20 mb-4">
		</a>
		<div class="text-2xl text-gray-800">환영합니다.</div>
	</div>

	<!-- 좌측 실내 수영 패널 -->
	<!-- 좌측 패널 호버 영역 -->
	<div class="hover-area-left"></div> <!-- 호버 트리거 영역 -->
	<div class="side-panel left-panel absolute top-0 left-0 w-1/6 h-screen bg-white flex flex-col items-start space-y-4 py-8 pl-6 shadow-lg border-r border-gray-200">
		<!-- 1차 메뉴 -->
		<div class="menu-item text-xl font-semibold text-gray-800 hover:text-blue-500">실내 수영</div>
		<!-- 2차 메뉴 -->
		<div class="sub-menu flex flex-col space-y-2">
		<div><a href="../article/list?boardId=1" class="text-lg font-normal text-gray-700 hover:text-blue-500">공지사항</a></div>
			<div><a href="../article/list?boardId=2" class="text-lg font-normal text-gray-700 hover:text-blue-500">자유게시판</a></div>
			<div><a href="../article/list?boardId=3" class="text-lg font-normal text-gray-700 hover:text-blue-500">실내 수영 위드미 게시판</a></div>
			<div><a href="../pool/map" class="text-lg font-normal text-gray-700 hover:text-blue-500">수영장 지도</a></div>
			<div><a href="../swimming/calender" class="text-lg font-normal text-gray-700 hover:text-blue-500">수영 일정 관리</a></div>
		</div>

		<!-- 1차 메뉴 -->
		<div class="menu-item text-xl font-semibold text-gray-800 hover:text-blue-500">야외 수영</div>
		<!-- 2차 메뉴 -->
		<div class="sub-menu flex flex-col space-y-2">
			<div><a href="../article/list?boardId=1" class="text-lg font-normal text-gray-700 hover:text-blue-500">공지사항</a></div>
			<div><a href="../article/list?boardId=2" class="text-lg font-normal text-gray-700 hover:text-blue-500">자유게시판</a></div>
			<div><a href="../article/list?boardId=4" class="text-lg font-normal text-gray-700 hover:text-blue-500">야외 수영 위드미 게시판</a></div>
			<div><a href="../beach/map" class="text-lg font-normal text-gray-700 hover:text-blue-500">해수욕장</a></div>
		</div>
	</div>

</body>

</html>
