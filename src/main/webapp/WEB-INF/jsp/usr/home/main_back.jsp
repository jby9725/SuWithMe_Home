<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
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
        }

        #background {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: -1;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            VANTA.WAVES({
                el: "#background",
                mouseControls: true,
                touchControls: true,
                gyroControls: false,
                minHeight: 200.00,
                minWidth: 200.00,
                scale: 1.00,
                scaleMobile: 1.00,
                color: 0x1d549b
            });
        });
    </script>

</head>

<body class="relative min-h-screen flex flex-col justify-between">

    <div id="background"></div>

    <!-- 상단 우측 로그인/회원가입/마이페이지 -->
    <header class="w-full flex justify-end py-4 px-8">
        <ul class="flex space-x-4 text-2xl"> <!-- 텍스트 크기를 두 배로 키움 -->
            <c:if test="${!rq.isLogined() }">
                <li><a class="hover:underline" href="../member/login">로그인</a></li>
                <li><a class="hover:underline" href="../member/join">회원가입</a></li>
            </c:if>
            <c:if test="${rq.isLogined() }">
                <li><a class="hover:underline" href="../member/myPage">마이페이지</a></li>
                <li><a onclick="if(confirm('로그아웃 하시겠습니까?') == false) return false;" class="hover:underline" href="../member/doLogout">로그아웃</a></li>
            </c:if>
        </ul>
    </header>

    <!-- 중앙 정렬된 로고 및 환영 메시지 -->
    <div class="flex-grow flex items-center justify-center flex-col">
        <a href="/">
            <img src="/resource/LOGO_black.png" alt="logo" class="h-20 mb-4">
        </a>
        <div class="text-2xl">환영합니다.</div>
    </div>

    <!-- 좌우 실내/야외 수영 버튼 -->
    <footer class="w-full flex justify-between px-8 py-4">
        <div>
            <a class="text-xl hover:underline" href="../pool/main">실내 수영</a>
        </div>
        <div>
            <a class="text-xl hover:underline" href="../beach/main">야외 수영</a>
        </div>
    </footer>

</body>

</html>