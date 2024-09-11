<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="POOL MAP"></c:set>
<%@ include file="../common/head_Option.jspf"%>
<!-- 여기서부터 내용 -->

<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ecu9lnpu4v"></script>
<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">


	<div id="map" class="" style="width: 800px; height: 700px;"></div>

</section>

<script>
	var IMG_PATH = '/resource/32-icon.png';
	var position = new naver.maps.LatLng(37.3849483, 127.1229117);

	var map = new naver.maps.Map('map', {
		center : position,
		zoom : 19
	});

	var markerOptions = {
		position : position.destinationPoint(90, 15),
		map : map,
		icon : {
			url : IMG_PATH,
			size : new naver.maps.Size(50, 52),
			origin : new naver.maps.Point(0, 0),
			anchor : new naver.maps.Point(25, 26)
		}
	};

	var marker = new naver.maps.Marker(markerOptions);

	naver.maps.Event.addListener(map, 'click', function(e) {
		marker.setPosition(e.coord); // e.coord : 지도를 클릭할 때 그 클릭한 위치의 좌표를 의미
	});
</script>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>