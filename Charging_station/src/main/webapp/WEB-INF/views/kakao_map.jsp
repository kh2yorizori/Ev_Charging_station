<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>다음 지도 API</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
</head>
<body>
    
    <%-- ▼▼▼ 3. HTML 본문 (검색 UI 유지) ▼▼▼ --%>
    
    <jsp:include page="common/header.jsp"/>

    <jsp:include page="detail_panel.jsp"/>
    
    <%-- 검색 UI 추가 --%>
    <div id="search-container">
        <input type="text" id="keyword" placeholder="충전소 검색 지역을 입력하세요 (예: 강남구)">
        <button id="search-btn">검색</button>
    </div>

    <%-- 목록을 표시할 패널 추가 --%>
    <div id="stations-list-panel">
        <h3 style="margin-top: 0;">🔎 검색 결과</h3>
        <div id="stations-list">
        </div>
    </div>

    <%-- 지도를 표시할 div --%>
    <div id="map" style="width:100vw; height:100vh;"></div>

    <%-- ▼▼▼ 4. JavaScript (안정화된 코드) ▼▼▼ --%>

    <%-- 카카오맵 SDK 로드 (HTTPS 명시) --%>
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=[카카오 키]"></script>
    
    <script>
        // 💡 안정성을 위해 window.onload로 감싸는 구조를 사용해야 합니다.
        window.onload = function() {
            
            // 4-1. 지도 생성 (기존 유지)
            var mapContainer = document.getElementById('map'), 
                mapOption = {
                    center: new kakao.maps.LatLng(37.56790, 126.97668), // 서울시청
                    level: 7
                }; 
            var map = new kakao.maps.Map(mapContainer, mapOption); 

            // 4-2. 지도 컨트롤 추가 (기존 유지)
            var mapTypeControl = new kakao.maps.MapTypeControl();
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            var zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 4-3. 전역 변수 선언
            var geocoder = new kakao.maps.services.Geocoder(); // 주소-좌표 변환 객체
            var markers = []; // 마커를 담을 배열

            // 4-4. DOM 요소
            var keywordEl = document.getElementById('keyword');
            var searchBtn = document.getElementById('search-btn');
            var stationsListPanel = document.getElementById('stations-list-panel');
            var stationsListEl = document.getElementById('stations-list');
            
            // 상세 패널 DOM 요소 (기존 유지)
            var panel = document.getElementById('detail-panel');
            var closeBtn = document.getElementById('close-btn');
            var stationNameEl = document.getElementById('station-name');
            var stationAddressEl = document.getElementById('station-address');
            // var stationTypeEl = document.getElementById('station-type');
            var facility_type_large = document.getElementById('facility_type_large');
            var charger_model_small = document.getElementById('charger_model_small');
            var operator_large = document.getElementById('operator_large');
            var operator_small = document.getElementById('operator_small');
            var fast_charge_capacity = document.getElementById('fast_charge_capacity');
            var charger_type = document.getElementById('charger_type');
            var user_restriction = document.getElementById('user_restriction');
            
            var charger_count = document.getElementById('charger_count');
            var count_dc_combo = document.getElementById('count_dc_combo');
            var count_ac3 = document.getElementById('count_ac3');
            var count_multi = document.getElementById('count_multi');

            // 4-5. 패널 닫기 버튼 이벤트 (기존 유지)
            closeBtn.addEventListener('click', function() {
                panel.style.display = 'none';
            });

            // 4-6. 검색 버튼 이벤트 리스너
            searchBtn.addEventListener('click', function() {
                var keyword = keywordEl.value.trim();
                if (!keyword) {
                    alert("검색할 지역을 입력해 주세요.");
                    return;
                }
                // 주소-좌표 변환 요청
                geocoder.addressSearch(keyword, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                        map.setCenter(coords);
                        map.setLevel(4); // 확대 레벨 조정

                        // 검색된 좌표를 기반으로 서버에 데이터 요청
                        fetchStationsData(coords.getLat(), coords.getLng());

                    } else {
                        alert('검색한 위치를 찾을 수 없습니다.');
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>검색 결과가 없습니다.</p>';
                        stationsListPanel.style.display = 'block'; // 목록 패널 표시
                    }
                });
            });

            // 4-7. 마커 제거 함수
            function clearMarkers() {
                for (var i = 0; i < markers.length; i++) {
                    markers[i].setMap(null);
                }
                markers = [];
            }

            // 4-8. 서버에서 충전소 데이터를 비동기적으로 가져오는 함수 (⭐Controller 통신 로직)
            function fetchStationsData(latitude, longitude) {
                // 이 URL은 실제 Controller의 매핑 경로로 변경해야 합니다.
                var url = '/searchStations?lat=' + latitude + '&lng=' + longitude + '&radius=5000'; 
                
                // Controller에서 반경 내 충전소 데이터를 JSON으로 반환해야 합니다.
                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('네트워크 응답 오류: ' + response.statusText);
                        }
                        return response.json();
                    })
                    .then(stations => {
                        if (stations && stations.length > 0) {
                            displayStations(stations); // 마커 및 목록 표시
                        } else {
                            alert("검색된 지역 주변에 충전소가 없습니다.");
                            clearMarkers();
                            stationsListEl.innerHTML = '<p>검색된 충전소가 없습니다.</p>';
                        }
                        stationsListPanel.style.display = 'block'; // 목록 패널 표시
                    })
                    .catch(error => {
                        console.error('데이터를 가져오는 중 오류 발생:', error);
                        alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                        stationsListPanel.style.display = 'block'; // 목록 패널 표시
                    });
            }

            // 4-9. 마커와 목록을 지도에 표시하는 핵심 함수
            function displayStations(stations) {
                clearMarkers(); // 이전 마커 제거
                stationsListEl.innerHTML = ''; // 이전 목록 내용 초기화
                var bounds = new kakao.maps.LatLngBounds(); // 지도의 영역을 재설정할 객체

                console.log('stationsListEl 변수:', stationsListEl);
                console.log('첫 번째 데이터 이름:', stations[0].station_name);

                stations.forEach(function(station, index) { // 💡 index 추가 (안정성 강화)
                    
                    var markerPosition  = new kakao.maps.LatLng(station.latitude, station.longitude); 
                    var marker = new kakao.maps.Marker({
                        position: markerPosition
                    });
                    
                    marker.setMap(map);
                    markers.push(marker); // 배열에 추가

                    // 영역 확장
                    bounds.extend(markerPosition);

                    // 4-10. 마커 클릭 이벤트
                    kakao.maps.event.addListener(marker, 'click', function() {
                        // 패널 내용 채우기 (기존 로직)
                        stationNameEl.textContent = station.station_name;
                        stationAddressEl.textContent = station.address;
                        // stationTypeEl.textContent = '타입: ' + station.charger_type;
                        facility_type_large.textContent = station.facility_type_large;
                        charger_model_small.textContent = station.charger_model_small;
                        operator_large.textContent = station.operator_large;
                        operator_small.textContent = station.operator_small;
                        fast_charge_capacity.textContent = station.fast_charge_capacity;
                        charger_type.textContent = station.charger_type;
                        user_restriction.textContent = station.user_restriction;

                        charger_count.textContent = '총 충전기 개수: ' + station.charger_count + '개';
                        count_dc_combo.textContent = 'DC콤보 타입 충전기 개수 : ' +station.count_dc_combo + '개';
                        count_multi.textContent = '3in1(멀티) 타입 충전기 개수' + station.count_multi + '개';


                        panel.style.display = 'block';
                        map.panTo(markerPosition); // 클릭한 마커로 지도를 이동
                    });

// 4-11. 목록 항목 생성 (innerHTML 대신 '안전한 DOM 생성 방식'으로 변경)
                    var item = document.createElement('div');
                    item.className = 'station-item';

                    // 1. <strong> 태그를 별도로 생성
                    var nameEl = document.createElement('strong');
                    // 2. .textContent를 사용해 안전하게 텍스트 삽입
                    nameEl.textContent = station.station_name; 

                    // 3. <span> 태그도 별도로 생성
                     var addressEl = document.createElement('span');
                    // 4. .textContent로 주소 삽입
                    addressEl.textContent = station.address;

                    // 5. 생성된 <strong>과 <span>을 <div class="station-item">에 추가
                    item.appendChild(nameEl);
                    item.appendChild(addressEl);

                    // 목록 항목 클릭 시 해당 마커로 이동 (이 코드는 기존에 있었습니다)
                    item.addEventListener('click', function() {
                        kakao.maps.event.trigger(marker, 'click'); // 마커 클릭 이벤트 호출
                    });

                    stationsListEl.appendChild(item);
                }); // --- 반복문 끝 ---
                    

                // 검색된 충전소가 지도 화면에 모두 보이도록 영역 재설정
                if (stations.length > 0) {
                    map.setBounds(bounds);
                }
            }
        }; // 💡 window.onload 함수 끝
        
    </script>
	<jsp:include page="common/footer.jsp"/>
	
</body>
</html>