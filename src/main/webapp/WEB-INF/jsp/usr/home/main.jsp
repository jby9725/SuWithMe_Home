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

.side-panel {
	position: absolute;
	top: 0;
	width: 33.33vw;
	height: 100vh;
	background-color: lightblue;
	transition: transform 0.5s ease;
}

/* 왼쪽은 살짝만 보여줌 */
.left-panel {
	left: -30vw;
}

/* 오른쪽은 살짝만 보여줌 */
.right-panel {
	right: -30vw;
}

/* 마우스 호버 시 왼쪽 패널은 오른쪽으로 나타남 */
.left-panel:hover {
	transform: translateX(30vw);
}

/* 마우스 호버 시 오른쪽 패널은 왼쪽으로 나타남 */
.right-panel:hover {
	transform: translateX(-30vw);
}

.side-panel a {
	display: block;
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	text-align: center;
	width: 100%;
	font-size: 1.5rem;
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

</head>

<body class="relative min-h-screen flex flex-col justify-between">

	<div id="background"></div>

	<!-- 상단 우측 로그인/회원가입/마이페이지 -->
	<header class="w-full flex justify-center py-4">
		<ul class="flex space-x-4 text-2xl">
			<!-- 텍스트 크기를 두 배로 키움 -->
			<c:if test="${!rq.isLogined() }">
				<li><a class="" href="../member/login">로그인</a></li>
				<li><a class="" href="../member/join">회원가입</a></li>
			</c:if>
			<c:if test="${rq.isLogined() }">
				<li><a class="" href="../member/myPage">마이페이지</a></li>
				<li><a onclick="if(confirm('로그아웃 하시겠습니까?') == false) return false;" class="" href="../member/doLogout">로그아웃</a></li>
			</c:if>
		</ul>
		</div>
	</header>

	<!-- 중앙 정렬된 로고 및 환영 메시지 -->
	<div class="flex-grow flex items-center justify-center flex-col">
		<a href="/"> <img src="/resource/LOGO_black.png" alt="logo" class="h-20 mb-4">
		</a>
		<div class="text-2xl">환영합니다.</div>
	</div>

	<div>
		<a href="../pool/main">실내 수영</a>
	</div>
	<div>
		<a href="../beach/main">야외 수영</a>
	</div>
	<div>
		<a href="../article/list?boardId=1">공지사항</a>
	</div>
	<div>
		<a href="../article/list?boardId=2">자유게시판</a>
	</div>
	<div>
		<a href="../article/list?boardId=3">실내 수영 위드미 게시판</a>
	</div>
	<div>
		<a href="../article/list?boardId=4">야외 수영 위드미 게시판</a>
	</div>
	<div>
		<a href="../beach/map">해수욕장</a>
	</div>
	<div>
		<a href="../pool/map">수영장 지도</a>
	</div>
	<div>
		<a href="../swimming/calender">수영 일정 관리</a>
	</div>


	<!-- 	<!-- 좌측 실내 수영 패널 -->
	-->
	<!-- 	<div class="side-panel left-panel"> -->
	<!-- 		<a href="../pool/main">실내 수영</a> -->
	<!-- 	</div> -->

	<!-- 	<!-- 우측 야외 수영 패널 -->
	-->
	<!-- 	<div class="side-panel right-panel"> -->
	<!-- 		<a href="../beach/main">야외 수영</a> -->
	<!-- 	</div> -->

</body>

</html>