<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="POOL MAP"></c:set>
<%@ include file="../common/head_Option.jspf"%>

<%@ include file="../common/sidebar.jspf"%>

<!-- 네이버 지도 API -->
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ecu9lnpu4v"></script>

<!-- 네이버 검색 API 키 설정 -->
<script>
    var CLIENT_ID = 'tZ8PAfL1CjFknwH_rWcD'; // 발급받은 Client ID
    var CLIENT_SECRET = 'DXtbtb6Jpo'; // 발급받은 Client Secret
</script>

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 모달 -->
<div id="poolInfoModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
	<div class="bg-white p-6 rounded-lg shadow-lg max-w-lg w-full relative">
		<span class="close absolute top-3 right-3 text-gray-500 text-xl cursor-pointer">&times;</span>
		<h2 id="modalPoolName" class="text-2xl font-bold mb-4"></h2>
		<p>
			<strong>전화번호:</strong> <span id="modalCallNumber"></span>
		</p>
		<p>
			<strong>지번 주소:</strong> <span id="modalPostalCodeStreet"></span>
		</p>
		<p>
			<strong>도로명 주소:</strong> <span id="modalAddressLocation"></span>
		</p>
		<div id="modalImages" style="display: flex; justify-content: space-around;"></div>
		<!-- 이미지들을 가로로 나란히 배치 -->
	</div>
</div>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">
	<div id="map" class="" style="width: 100%; height: 75vh;"></div>
</section>

<script>
    var IMG_PATH = '/resource/32-pool-icon.png'; // 마커 아이콘 경로
    var defaultImageUrl = "https://via.placeholder.com/100";  // 기본 이미지 URL

    // 네이버 지도 생성
    var map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(36.3504396, 127.3849508), // 대전 시청 좌표
        zoom: 12
    });

    // 풀 목록의 위도/경도 데이터를 JSP에서 JavaScript로 전달
    var pools = [];
    <c:forEach var="pool" items="${pools}">
    pools.push({
        id: ${pool.id}, 
        name: "<c:out value='${pool.name}'/>", 
        callNumber: "<c:out value='${pool.callNumber}'/>", 
        postalCodeStreet: "<c:out value='${pool.postalCodeStreet}'/>", 
        addressLocation: "<c:out value='${pool.addressLocation}'/>", 
        latitude: "${pool.latitude}", 
        longitude: "${pool.longitude}" 
    });
    </c:forEach>

    console.log("Pools 데이터: ", pools);

    // 모달을 열어 수영장 정보를 표시하는 함수
    function openModal(poolName, callNumber, postalCodeStreet, addressLocation, imageSrcArray) {
        var modal = document.getElementById("poolInfoModal");

        // 모달 내용 설정
        document.getElementById("modalPoolName").innerText = poolName;
        document.getElementById("modalCallNumber").innerText = callNumber;
        document.getElementById("modalPostalCodeStreet").innerText = postalCodeStreet;
        document.getElementById("modalAddressLocation").innerText = addressLocation;

        // 이미지가 있으면 최대 3개 표시, 없으면 기본 이미지 표시
        var modalImages = document.getElementById("modalImages");
        modalImages.innerHTML = ''; // 기존 이미지 초기화
        for (var i = 0; i < 3; i++) {
            var imgSrc = imageSrcArray[i] ? imageSrcArray[i] : defaultImageUrl;
            modalImages.innerHTML += '<img src="' + imgSrc + '" style="width:100px; height:100px; margin:5px;">';
        }

        // 모달 표시
        modal.classList.remove('hidden');
    }

    // 모달 닫기 기능
    var closeBtn = document.getElementsByClassName("close")[0];
    closeBtn.onclick = function() {
        document.getElementById("poolInfoModal").classList.add('hidden');
    }

    // 모달 밖을 클릭했을 때 닫기
    window.onclick = function(event) {
        var modal = document.getElementById("poolInfoModal");
        if (event.target == modal) {
            modal.classList.add('hidden');
        }
    }

    // 네이버 이미지 검색 API를 사용하여 관련된 첫 번째 이미지를 가져오는 함수
    function fetchFirstImagesFromNaver(poolName, callback) {
        fetch('/proxy/search/image?query=' + encodeURIComponent(poolName))  // 네이버 이미지 검색 API 호출
            .then(response => response.json())
            .then(data => {
                if (data && data.items && data.items.length > 0) {
                    // 첫 번째, 두 번째, 세 번째 이미지 URL 가져오기
                    var imageSrcArray = [];
                    for (var i = 0; i < Math.min(3, data.items.length); i++) {
                        imageSrcArray.push(data.items[i].link); // 이미지 링크 배열에 추가
                    }
                    callback(imageSrcArray);
                } else {
                    console.log("이미지가 없습니다.");
                    callback([null, null, null]);  // 이미지가 없을 경우 기본 이미지로 대체
                }
            })
            .catch(error => {
                console.error('Error fetching images from Naver:', error);
                callback([null, null, null]);  // 에러 발생 시 기본 이미지로 대체
            });
    }

    // 마커 클릭 시 모달에 수영장 정보 및 3개의 이미지 표시
    function searchImagesAndBlogs(pool) {
        fetchFirstImagesFromNaver(pool.name, function(imageSrcArray) {
            // 모달 열기 (모든 수영장 정보 및 이미지 배열 전달)
            openModal(pool.name, pool.callNumber, pool.postalCodeStreet, pool.addressLocation, imageSrcArray);
        });
    }

    // 마커 생성 및 클릭 이벤트 등록
    pools.forEach(function(pool) {
        var marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(pool.latitude, pool.longitude),
            map: map,
            icon: {
                url: IMG_PATH,
                size: new naver.maps.Size(50, 52),
                origin: new naver.maps.Point(0, 0),
                anchor: new naver.maps.Point(25, 26)
            }
        });

        // 마커 클릭 시 InfoWindow 대신 모달에 수영장 정보 및 이미지 표시
        naver.maps.Event.addListener(marker, 'click', function(e) {
            searchImagesAndBlogs(pool);
        });
    });
</script>

<%@ include file="../common/foot.jspf"%>
