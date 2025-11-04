<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ▼▼▼ 1. Java 클래스 import (필수) ▼▼▼ --%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>다음 지도 API</title>
    <style>
        /* ▼▼▼ 2. CSS 스타일 ▼▼▼ */
        html, body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }

        /* 왼쪽 상세 패널 스타일 */
        #detail-panel {
            position: absolute;
            top: 50px; 
            left: 0;
            width: 300px; 
            height: calc(100vh - 50px); 
            background-color: white;
            z-index: 1000; 
            display: none; /* 처음에는 숨김 */
            padding: 20px;
            box-shadow: 3px 0 5px rgba(0,0,0,0.2); 
            box-sizing: border-box; 
            overflow-y: auto; 
        }

        /* 닫기 버튼 (detail_panel.jsp 안에 있는 버튼에 적용) */
        #close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 20px;
            font-weight: bold;
            color: #555;
            background: none;
            border: none;
            cursor: pointer;
        }
        #close-btn:hover {
            color: #000;
        }

        /* 내비게이션 바 스타일 (navigation_bar.jsp 안에 있는 ul에 적용) */
        ul.main-nav { 
            list-style: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #333;
			height: 50px;
			box-sizing: border-box;
        }

        ul.main-nav li {
            float: left;
        }

        ul.main-nav li a {
            display: block;
            color: white;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }

        ul.main-nav li a:hover {
            background-color: #111;
        }
    </style>
</head>
<body>
    <%-- ▼▼▼ 3. HTML 본문 ▼▼▼ --%>
    
    <%-- navigation_bar.jsp의 HTML 조각을 포함 --%>
    <jsp:include page="navigation_bar.jsp"/>

    <%-- detail_panel.jsp의 HTML 조각을 포함 --%>
    <jsp:include page="detail_panel.jsp"/>

    <%-- 지도를 표시할 div --%>
    <div id="map" style="width:100vw; height:100vh;"></div>

    <%-- ▼▼▼ 4. JavaScript ▼▼▼ --%>

    <%-- 카카오맵 SDK 로드 (appkey는 본인 것으로 사용) --%>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4b26cec5fc8b30c5ca0df35da2c88030"></script>
    
    <script>
        // 4-1. 지도 생성
        var mapContainer = document.getElementById('map'), 
            mapOption = {
                center: new kakao.maps.LatLng(37.56790, 126.97668), // 초기 중심좌표 (서울시청)
                level: 4 // 초기 확대 레벨
            }; 
        var map = new kakao.maps.Map(mapContainer, mapOption); 

        // 4-2. 지도 컨트롤 추가
        var mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        
        <%-- ▼▼▼ 5. [핵심] Java List -> JavaScript Array 변환 ▼▼▼ --%>
        <%
            // 5-1. try 블록 밖에서 변수 선언 (스코프 문제 해결)
            //      오류 발생 시 기본값으로 빈 배열 "[]"을 할당 (JS 오류 방지)
            String jsonStations = "[]"; 
        
            try {
                // 5-2. Controller가 보낸 model 데이터를 꺼냅니다.
                ArrayList<ElecDTO> elec_charge = (ArrayList<ElecDTO>) request.getAttribute("elec_charge");
                
                // 5-3. 데이터가 null이 아닐 때만 JSON 변환을 시도합니다.
                if (elec_charge != null && !elec_charge.isEmpty()) {
                    ObjectMapper mapper = new ObjectMapper();
                    
                    // 5-4. [오류 원인] 이 메서드는 '체크 예외'를 발생시키므로 try-catch가 필수입니다.
                    jsonStations = mapper.writeValueAsString(elec_charge);
                }

            } catch (Exception e) {
                // 5-5. 예외 발생 시, jsonStations는 기본값 "[]"을 유지합니다.
                e.printStackTrace(); // 서버 로그에 오류를 남깁니다.
            }
        %>
        <%-- ▲▲▲ Java 코드 끝 ▲▲▲ --%>


        // 6. JavaScript 변수 'stations'에 안전하게 데이터 할당
        //    (성공 시: "[{...}, {...}]", 실패 시: "[]")
        var stations = <%= jsonStations %>;

        // 7. 상세 패널 DOM 요소 찾기
        var panel = document.getElementById('detail-panel');
        var closeBtn = document.getElementById('close-btn');
        var stationNameEl = document.getElementById('station-name');
        var stationAddressEl = document.getElementById('station-address');
        var stationTypeEl = document.getElementById('station-type');
		var facility_type_large = document.getElementById('facility_type_large');
		var charger_model_small = document.getElementById('charger_model_small');
		var operator_large = document.getElementById('operator_large');
		var operator_small = document.getElementById('operator_small');
		var fast_charge_capacity = document.getElementById('fast_charge_capacity');
		var charger_type = document.getElementById('charger_type');
		var user_restriction = document.getElementById('user_restriction');
        // 8. 패널 닫기 버튼 이벤트
        closeBtn.addEventListener('click', function() {
            panel.style.display = 'none';
        });

        // 9. [핵심] 'forEach' 반복문으로 마커 생성
        stations.forEach(function(station) {
            
            // 9-1. 마커 위치 (DB에서 가져온 위도, 경도 사용)
            var markerPosition  = new kakao.maps.LatLng(station.latitude, station.longitude); 

            // 9-2. 마커 생성
            var marker = new kakao.maps.Marker({
                position: markerPosition
            });

            // 9-3. 마커를 지도에 표시
            marker.setMap(map);
            
            // 9-4. 각 마커에 클릭 이벤트 등록
            kakao.maps.event.addListener(marker, 'click', function() {
                
                // 클릭된 마커의 'station' 정보로 패널 내용 채우기
                stationNameEl.textContent = station.station_name;
                stationAddressEl.textContent = station.address;
                stationTypeEl.textContent = '타입: ' + station.charger_type;
				facility_type_large.textContent = station.facility_type_large;
				charger_model_small.textContent = station.charger_model_small;
				operator_large.textContent = station.operator_large;
				operator_small.textContent = station.operator_small;
				fast_charge_capacity.textContent = station.fast_charge_capacity;
				charger_type.textContent = station.charger_type;
				user_restriction.textContent = station.user_restriction;
                
                // (다른 DTO 정보도 여기에 채워넣으세요)
                // 예: document.getElementById('op-time').textContent = station.operator_large;

                // 패널 보여주기
                panel.style.display = 'block';
            });
        }); // --- 반복문 끝 ---
        
    </script>
</body>
</html>