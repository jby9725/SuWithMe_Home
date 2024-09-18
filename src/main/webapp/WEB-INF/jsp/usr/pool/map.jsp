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


	<div id="map" class="" style="width: 100%; height: 100%;"></div>

</section>

<script>
	var IMG_PATH = '/resource/32-icon.png';

	var map = new naver.maps.Map('map', {
		center : new naver.maps.LatLng(36.3504396, 127.3849508), // 대전 시청의 위도/경도
		zoom : 12
	});

	// InfoWindow 객체 생성
	var infoWindow = new naver.maps.InfoWindow({
		anchorSkew : true
	});

	// 풀 목록의 위도/경도 데이터를 JSP에서 JavaScript로 전달
	var pools = [];
	<c:forEach var="pool" items="${pools}">
	pools.push({
		//         	id: ${pool.id}, // 고유 ID 추가
		name : "<c:out value='${pool.name}'/>", // 수영장 이름
		latitude : "${pool.latitude}",
		longitude : "${pool.longitude}"
	});
	</c:forEach>

	// 데이터가 제대로 들어왔는지 콘솔에서 확인
	console.log("Pools 데이터: ", pools);

	// 위도/경도 데이터를 기반으로 마커 생성
	pools.forEach(function(pool) {
		var marker = new naver.maps.Marker({
			position : new naver.maps.LatLng(pool.latitude, pool.longitude),
			map : map,
			icon : {
				url : IMG_PATH,
				size : new naver.maps.Size(50, 52),
				origin : new naver.maps.Point(0, 0),
				anchor : new naver.maps.Point(25, 26)
			}
		});

		// 마커 클릭 시 InfoWindow에 수영장 이름을 표시
		naver.maps.Event.addListener(marker, 'click', function(e) {
			// InfoWindow가 열려 있으면 닫고, 열려 있지 않으면 열기
			if (infoWindow.getMap()) {
				infoWindow.close(); // InfoWindow가 열려 있으면 닫기
			} else {
				var contentString = '<div style="padding:10px;">' + pool.name
						+ '</div>';
				infoWindow.setContent(contentString); // InfoWindow 내용 설정
				infoWindow.open(map, marker); // InfoWindow를 마커 위치에 열기
			}
		});
	});
</script>

<!-- 여기서부터 내용 끝 -->
<%@ include file="../common/foot.jspf"%>