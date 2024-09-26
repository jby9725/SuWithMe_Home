<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="BEACH MAP"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<%@ include file="../common/sidebar.jspf"%>

<!-- 네이버 지도 API -->
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ecu9lnpu4v"></script>
<script>
    var IMG_PATH = '/resource/32-beach-icon.png'; // 마커 아이콘 경로
</script>

<!-- 지도 초기화 및 마커 설정 -->
<script>
    document.addEventListener('DOMContentLoaded', function() { // 페이지 로드 후에 초기화
        console.log("DOMContentLoaded 이벤트가 실행되었습니다.");

        var map = new naver.maps.Map('map', {
            center: new naver.maps.LatLng(36.3504396, 127.3849508), // 대전 시청 좌표
            zoom: 8
        });

        // 해수욕장 좌표 데이터를 서버에서 받아와 마커 표시
        var beaches = [];
        <c:forEach var="beach" items="${beaches}">
        beaches.push({
            id: '<c:out value="${beach.id}" />',
            name: '<c:out value="${beach.name}" />',
            latitude: parseFloat('<c:out value="${beach.latitude}" />'), // parseFloat를 사용하여 숫자형으로 변환
            longitude: parseFloat('<c:out value="${beach.longitude}" />'), // parseFloat를 사용하여 숫자형으로 변환
            nx: parseInt('<c:out value="${beach.nx}" />'), // parseInt를 사용하여 숫자형으로 변환
            ny: parseInt('<c:out value="${beach.ny}" />')  // parseInt를 사용하여 숫자형으로 변환
        });
        </c:forEach>

        // 확인용: 전달된 beaches 데이터 확인
        console.log("Beaches 데이터:", beaches);

        // 마커 생성 및 클릭 이벤트 등록
        beaches.forEach(function(beach) {
            if (!beach.latitude || !beach.longitude || !beach.nx || !beach.ny) {
                console.error("해수욕장의 좌표 정보가 부족합니다. 데이터 확인:", beach);
                return;
            }

            var marker = new naver.maps.Marker({
                position: new naver.maps.LatLng(beach.latitude, beach.longitude),
                map: map,
                icon: {
                    url: IMG_PATH,
                    size: new naver.maps.Size(50, 52),
                    origin: new naver.maps.Point(0, 0),
                    anchor: new naver.maps.Point(25, 26)
                }
            });

            // 마커 클릭 시 날씨 정보 요청
            naver.maps.Event.addListener(marker, 'click', function(e) {
                console.log("Clicked beach:", beach); // 클릭한 마커의 데이터 확인

                var nx = beach.nx;
                var ny = beach.ny;

                console.log("nx:", nx, "ny:", ny);

                if (!nx || !ny) {
                    alert("해당 해수욕장의 좌표 정보가 없습니다. nx, ny 값이 비어 있습니다.");
                    return;
                }

                // 날씨 데이터를 불러와서 모달 창에 표시
                getWeatherData(nx, ny, beach.name);
            });
        });
    });

 // 날씨 데이터 요청 및 모달 창 표시 함수
    function getWeatherData(nx, ny, beachName) {
        console.log("getWeatherData nx : ", nx);
        console.log("getWeatherData ny : ", ny);

        if (!nx || !ny) {
            console.error("nx 또는 ny 값이 비어 있습니다:", nx, ny);
            alert("해당 해수욕장의 좌표 정보가 없습니다. 다시 시도해 주세요.");
            return;
        }

        const requestUrl = `/usr/beach/weather?nx=\${nx}&ny=\${ny}&numOfRows=10`;
        console.log("요청 URL:", requestUrl);

        fetch(requestUrl)
        .then(response => response.json())
        .then(data => {
            console.log("Weather Data 서버 응답 데이터:", data);

            if (Object.keys(data).length === 0) {
                alert("날씨 정보를 가져오는 데 실패했습니다.");
            } else {
                // 데이터가 성공적으로 받아진 경우
                showWeatherPopup(beachName, data);
            }
        })
        .catch(error => {
            console.error("날씨 정보를 가져오는 중 오류 발생:", error);
            alert("날씨 정보를 가져오는 데 실패했습니다: " + error.message);
        });
    }

    // 날씨 정보를 팝업에 표시하는 함수
    function showWeatherPopup(beachName, weatherDataMap) {
        console.log("받아온 데이터 확인: ", weatherDataMap);

        // 여러 시간대의 날씨 정보를 표시하기 위한 코드
        let popupContent = `<div>
            <h4>\${beachName}</h4>
            <h4>기준 시간별 날씨 정보</h4>
        `;

        for (const baseTime in weatherDataMap) {
            const weatherInfo = weatherDataMap[baseTime];
            popupContent += `
                <h5>기준 시간: \${weatherInfo.baseTime}</h5>
                <p>기온: \${weatherInfo.temperature}</p>
                <p>강수 형태: \${weatherInfo.precipitationType}</p>
                <p>강수 확률: \${weatherInfo.precipitationProbability}</p>
                <hr>
            `;
        }

        popupContent += `<button onclick="closeModal()">닫기</button></div>`;
        const popup = document.getElementById('weatherPopup');
        if (popup) {
            popup.innerHTML = popupContent;
            popup.style.display = 'block';
        } else {
            console.error("weatherPopup 요소를 찾을 수 없습니다. HTML의 ID를 확인하세요.");
        }
    }

    // 모달 닫기
    function closeModal() {
        const popup = document.getElementById('weatherPopup');
        if (popup) {
            popup.style.display = 'none';
        } else {
            console.error("weatherPopup 요소를 찾을 수 없습니다. HTML의 ID를 확인하세요.");
        }
    }
</script>

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">
    <div id="map" style="width: 100%; height: 75vh;"></div>
</section>

<!-- 모달 창 -->
<div id="weatherPopup" style="display: none; background: white; border: 1px solid black; padding: 10px; position: absolute; z-index: 100; top: 50%; left: 50%; transform: translate(-50%, -50%);" class="fixed bg-white border border-black p-4 rounded-lg shadow-lg w-96 max-w-full">
</div>

<%@ include file="../common/foot.jspf"%>
