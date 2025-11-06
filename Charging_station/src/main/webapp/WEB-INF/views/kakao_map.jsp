<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>EV Charge - 스마트 충전소 찾기</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
	
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Noto Sans KR', sans-serif;
            box-sizing: border-box;
        }
        
        html, body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            background: #f8f9fa;
        }

        /* 지도 컨테이너 */
        #map {
            width: 100vw;
            height: 100vh;
            position: relative;
        }
        
        /* 🌟 사이드바 토글 버튼 컨테이너 */
        #toggle-sidebar-btn-container {
            position: absolute;
            top: 50%; /* 수직 중앙 */
            left: 424px; /* 400px (사이드바) + 24px (간격) */
            transform: translateY(-50%); /* 정확한 중앙 정렬 */
            z-index: 1005; 
            transition: left 0.3s ease; 
        }

        #toggle-sidebar-btn {
            width: 25px; /* 폭 증가 */
            height: 70px; /* 높이 증가 */
            background: #fff;
            color: #52c41a;
            border: 1px solid #e9ecef;
            border-radius: 4px 0 0 4px; /* 왼쪽만 둥글게 */
            border-right: none; 
            cursor: pointer;
            box-shadow: -2px 0 8px rgba(0, 0, 0, 0.1); 
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px; /* 아이콘 크기 증가 */
            padding: 0 5px 0 0; 
        }

        #toggle-sidebar-btn:hover {
            background: #f8f9fa;
        }


        /* 🌟 사이드바 닫힘 상태 CSS */
        .sidebar-closed #toggle-sidebar-btn-container {
            left: 20px !important; 
        }
        
        .sidebar-closed #toggle-sidebar-btn .fa-chevron-left {
            transform: rotate(180deg); 
        }

        .sidebar-closed #toggle-sidebar-btn {
            border-radius: 0 4px 4px 0; 
            border-left: none; 
            border-right: 1px solid #e9ecef; 
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1); 
            padding: 0 0 0 5px; 
        }

        .sidebar-closed .left-sidebar {
            display: none !important; 
        }
        
        /* 💡 [추가] 토글 버튼으로 닫았을 때 상세 패널도 숨기기 */
        .sidebar-closed #detail-panel {
            display: none !important; 
        }


        /* 🌟 1. 왼쪽 사이드바 컨테이너 (검색창 + 결과 목록) */
        .left-sidebar {
            position: absolute;
            top: 60px;
            left: 20px;
            width: 400px; /* 고정 너비 */
            height: calc(100vh - 80px);
            z-index: 1000;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* 검색 입력창 */
        #search-container {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.08);
            /* z-index를 높여 상세/목록 패널 위로 오게 함 */
            z-index: 10; 
        }

        #keyword {
            flex: 1;
            padding: 10px 12px;
            border: none;
            background: transparent;
            font-size: 15px;
            outline: none;
            color: #333;
        }

        #keyword::placeholder {
            color: #999;
        }

        #search-btn {
            padding: 10px 24px;
            margin-left: 8px;
            /* 상세 패널과 일관된 그라데이션 */
            background: linear-gradient(135deg, #52c41a 0%, #95de64 100%); 
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        #search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(82, 196, 26, 0.4);
        }

        /* 🌟 검색 결과 패널 - 왼쪽 하단 */
        #stations-list-panel {
            flex: 1;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: none; /* JS에서 'flex'로 변경 */
            flex-direction: column;
            border: 1px solid rgba(0, 0, 0, 0.08);
        }

        #stations-list-panel h3 {
            margin: 0;
            padding: 20px 20px 16px;
            display: flex;
            justify-content: flex-start; /* X 버튼 제거로 수정 */
            align-items: center;
            font-size: 18px;
            font-weight: 700;
            color: #333;
            background: #f8f9fa;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
        }


        #stations-list {
            flex: 1;
            overflow-y: auto;
            padding: 8px;
        }

        /* 🌟 검색 결과 항목 스타일 (상세 패널과 비슷하게) */
        .station-item {
            padding: 16px;
            margin-bottom: 6px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.06);
        }

        .station-item:hover {
            background: #f8f9fa;
            border-color: #52c41a; /* 그라데이션 주색 */
            transform: translateX(2px);
        }

        .station-item.active {
            /* 활성화 상태 스타일 */
            background: linear-gradient(135deg, rgba(82, 196, 26, 0.1) 0%, rgba(149, 222, 100, 0.1) 100%);
            border-color: #52c41a;
        }

        .station-item strong {
            display: block;
            font-size: 15px;
            font-weight: 700;
            color: #333;
            margin-bottom: 6px;
        }

        .station-item span {
            font-size: 13px;
            color: #777;
            line-height: 1.4;
        }
        
        /* 🌟 2. 상세 패널 위치 재조정 (검색 결과 옆) */
        #detail-panel {
            position: absolute;
            top: 60px;
            /* 400px (사이드바) + 24px (간격) = 424px. 안전하게 444px */
            left: 444px; 
            width: 380px; 
            height: calc(100vh - 80px);
            z-index: 1000;
            display: none; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
            border-radius: 12px;
            animation: slideInRight 0.3s ease; /* 애니메이션 방향 변경 */
            border: 1px solid rgba(0, 0, 0, 0.08);
            transition: left 0.3s ease; 
        }
        
        /* 💡 마커 클릭 시 상세 패널 위치 (목록이 닫혔을 때) */
        .sidebar-closed #detail-panel {
            /* JS가 위치를 덮어쓰도록 함 */
        }


        @keyframes slideInRight {
            from {
                transform: translateX(20px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* 현재 위치 검색 버튼 - 오른쪽 하단 */
        #search-bounds-btn-container {
            position: absolute;
            bottom: 30px;
            right: 30px;
            z-index: 1010;
        }

        #search-bounds-btn {
            padding: 16px 28px;
            background: white;
            color: #52c41a;
            border: 2px solid #52c41a;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #search-bounds-btn:hover {
            background: linear-gradient(135deg, #52c41a 0%, #95de64 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(82, 196, 26, 0.4);
        }

        /* 빈 결과 메시지 */
        #stations-list p {
            text-align: center;
            color: #999;
            padding: 40px 20px;
            font-size: 14px;
        }

        /* 🌟 3. 반응형 (모바일 레이아웃) */
        @media (max-width: 1024px) {
            .left-sidebar {
                width: 320px;
            }
            #detail-panel {
                left: 356px; /* 320px + 24px 간격 */
                width: 320px;
            }
            #toggle-sidebar-btn-container {
                left: 340px; /* 320px + 20px 간격 */
            }
            .sidebar-closed #toggle-sidebar-btn-container {
                left: 20px !important;
            }
            
            /* 마커 클릭 시 상세 패널 위치 재조정 (모바일) */
            /* .sidebar-closed #detail-panel {
                left: 20px !important; 
                width: calc(100% - 40px);
            } */
        }

        @media (max-width: 768px) {
            /* 지도 아래쪽에 패널을 쌓음 */
            .left-sidebar, #detail-panel {
                width: calc(100% - 40px);
                left: 20px;
                height: 45vh; /* 화면의 45% 사용 */
                bottom: 20px;
                top: auto;
            }

            .left-sidebar {
                height: 45vh;
                margin-bottom: 10px; /* 상세 패널과의 간격 */
            }
            
            /* 상세 패널은 검색 결과가 닫히면 전체 화면 하단을 차지 */
            #detail-panel {
                height: 45vh;
                margin-bottom: 0;
            }
            
            /* 검색 결과 패널 위에 상세 패널이 뜨도록 z-index 조정 */
            .left-sidebar { z-index: 1000; }
            #detail-panel { z-index: 1001; }
            
            /* 현재 위치 버튼 위치 조정 */
            #search-bounds-btn-container {
                top: 70px;
                right: 20px;
                bottom: auto;
            }

            /* 모바일에서 토글 버튼 위치 변경 */
            #toggle-sidebar-btn-container {
                top: 70px;
                left: 20px;
            }
        }
    </style>
</head>
<body>
    
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <jsp:include page="detail_panel.jsp"/>
    
    <div id="toggle-sidebar-btn-container">
        <button id="toggle-sidebar-btn" title="사이드바 숨기기">
            <i class="fas fa-chevron-left"></i> </button>
    </div>
    
    <div class="left-sidebar">
        <div id="search-container">
            <input type="text" id="keyword" placeholder="🔍 충전소명, 주소 검색">
            <button id="search-btn">검색</button>
        </div>

        <div id="stations-list-panel">
            <h3>
                <span>🔎 검색 결과</span>
                </h3>
            <div id="stations-list"></div>
        </div>
    </div>

    <div id="search-bounds-btn-container">
        <button id="search-bounds-btn">
            <span></span>
            <span>현재 위치에서 찾기</span>
        </button>
    </div>

    <div id="map"></div>

    <%-- (주의) appkey는 본인의 키로, libraries=services가 포함되어야 합니다 --%>
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=[id]&libraries=services"></script>
    
    <script>
    var map; 
    var markers = []; 
    var stationsListEl; // 전역 선언
    var stationsListPanel; // 전역 선언
    var activeStationItem = null; 
    
    // 🌟 상수 정의
    const DEFAULT_TOGGLE_LEFT = '424px'; // 400px (사이드바) + 24px (간격)
    const DETAIL_OPEN_TOGGLE_LEFT = '828px'; // 444px (상세 시작) + 380px (상세 너비) + 4px (간격)

    
    // --- [전역 함수로 이동]: 마커 제거 함수 ---
    function clearMarkers() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        markers = [];
    }
    
    // --- [전역 함수로 이동]: 마커와 목록을 지도에 표시하는 함수 (즐겨찾기에서도 사용) ---
    // 🌟 [수정]: skipMapMove 인자를 추가하여 지도 이동 로직을 건너뛸지 결정합니다.
    function displayStations(stations, skipMapMove) {
        clearMarkers(); 
        stationsListEl.innerHTML = ''; 
        var bounds = new kakao.maps.LatLngBounds(); 

        // DOM 요소들을 전역에서 참조
        var panel = document.getElementById('detail-panel');
        var stationNameEl = document.getElementById('station-name');
        var stationAddressEl = document.getElementById('station-address');
        var facility_type_large = document.getElementById('facility_type_large');
        var operator_large = document.getElementById('operator_large');
        var operator_small = document.getElementById('operator_small');
        var user_restriction = document.getElementById('user_restriction');
        
        // 🌟 토글 버튼 컨테이너 참조
        var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
        var body = document.body; // body 참조 추가

        stations.forEach(function(station, index) { 
            
            var markerPosition  = new kakao.maps.LatLng(station.latitude, station.longitude); 
            var marker = new kakao.maps.Marker({ position: markerPosition });
            
            marker.setMap(map);
            markers.push(marker); 
            bounds.extend(markerPosition);
            
            // 목록 항목 생성
            var item = document.createElement('div');
            item.className = 'station-item';
            var nameEl = document.createElement('strong');
            nameEl.textContent = station.station_name; 
            var addressEl = document.createElement('span');
            addressEl.textContent = station.address;
            item.appendChild(nameEl);
            item.appendChild(addressEl);

            // 마커 클릭 이벤트 및 목록 항목 클릭 핸들러
            var clickHandler = function() {
                 // 이전 활성화 항목 스타일 제거
                if (activeStationItem) {
                    activeStationItem.classList.remove('active');
                }
                
                // 현재 항목 활성화
                item.classList.add('active');
                activeStationItem = item;

                stationNameEl.textContent = station.station_name;
                stationAddressEl.textContent = station.address;
                operator_large.textContent = (station.operator_large ? "운영기관: " : "") + (station.operator_large || '-');
                operator_small.textContent = (station.operator_small ? "운영기관(상세): " : "") + (station.operator_small || '-');
                user_restriction.textContent = (station.user_restriction ? "" : "이용 제한: ") + (station.user_restriction || '정보 없음');
                facility_type_large.textContent = (station.facility_type_large ? "시설 구분: " : "") + (station.facility_type_large || '-');

                // DTO에서 급속/완속 개수를 직접 가져옴
                var fastChargers = station.fast_charger_count || 0;
                var slowChargers = station.slow_charger_count || 0;

                var fastEl = document.getElementById('fast-charger-count');
                var slowEl = document.getElementById('slow-charger-count');
                
                if (fastEl) {
                    fastEl.textContent = fastChargers; // 숫자만 표시하도록 수정
                }
                if (slowEl) {
                    slowEl.textContent = slowChargers; // 숫자만 표시하도록 수정
                }
                
                // 즐겨찾기 ID 설정 함수 호출 (detail_panel.jsp에 정의됨)
                if (typeof setStationIdAndCheckFavorite === 'function') {
                    setStationIdAndCheckFavorite(station.id);
                } else {
                    console.error("setStationIdAndCheckFavorite 함수가 정의되지 않았습니다.");
                }

                map.setCenter(markerPosition);
                map.setLevel(5); // 레벨 5로 확대

                panel.style.display = 'block';
                
                // 🌟 [수정된 로직] 마커 클릭 시 목록 유지 및 상세 패널 옆에 위치
                
                // 1. 사이드바 상태 복원 (목록 유지)
                body.classList.remove('sidebar-closed'); 

                // 2. 상세 패널 위치를 목록 옆 위치(444px)로 복원하고, 기본 너비(380px)를 설정합니다.
                panel.style.left = '444px'; 
                panel.style.width = '380px'; 
                
                // 3. 토글 버튼을 상세 패널의 오른쪽 끝 (828px)으로 이동
                if (toggleContainer) {
                    toggleContainer.style.left = DETAIL_OPEN_TOGGLE_LEFT; // ⬅️ 828px로 이동
                    toggleContainer.title = "사이드바 숨기기"; 
                }
            };

            kakao.maps.event.addListener(marker, 'click', clickHandler);
            item.addEventListener('click', clickHandler);
            
            stationsListEl.appendChild(item);
        }); 
        
        // 🌟 [수정됨]: skipMapMove가 true가 아닐 때만 지도 범위 설정을 실행합니다. (검색 로직만 해당)
        if (!skipMapMove && stations.length > 0) {
             if (stations.length === 1) {
                // 항목이 하나일 경우
                map.setCenter(bounds.getCenter());
                map.setLevel(5); 
            } 
            else {
                 // 2개 이상이거나, 거리순 검색 결과일 경우
                 map.setBounds(bounds);
            }
        } 
    }
    
    // 🌟 [추가된 함수] 헤더의 즐겨찾기 버튼 클릭 시 호출됨 (전역으로 정의)
    function displayFavoriteStations(stations) {
        if (stations && stations.length > 0) {
            // 🌟 [수정]: 두 번째 인자로 true를 전달하여 displayStations 내부의 지도 이동 로직을 건너뜁니다.
            displayStations(stations, true); 
            stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록'; // 💡 제목 변경
            stationsListPanel.style.display = 'flex';
            
            // 🌟 [수정]: bounds 계산 및 설정 (여기서 지도 이동 처리하여 1개일 때 오류 방지)
            var bounds = new kakao.maps.LatLngBounds(); 
            markers.forEach(function(marker) {
                bounds.extend(marker.getPosition());
            });
            
            // 마커가 1개 이상 있으므로 map.setBounds는 안전합니다.
            map.setBounds(bounds); 
            
        } else {
            clearMarkers();
            stationsListEl.innerHTML = '<p>등록된 즐겨찾기가 없습니다.</p>';
            stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록'; // 💡 제목 변경
            stationsListPanel.style.display = 'flex';
        }
        
        // 상세 패널 닫기 (새로운 목록이 뜰 때 상세 패널은 초기화)
        var panel = document.getElementById('detail-panel');
        var toggleContainer = document.getElementById('toggle-sidebar-btn-container'); 
        var body = document.body; // body 참조 추가
        
        if (panel) {
            panel.style.display = 'none';
        }
        
        // 🌟 [수정] 목록이 새로 열리면 사이드바 상태 복구
        body.classList.remove('sidebar-closed'); 

        // 목록이 열렸으므로 토글 버튼 위치를 목록 옆으로 이동
        if (toggleContainer) {
            toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
        }

        if (activeStationItem) {
            activeStationItem.classList.remove('active');
            activeStationItem = null;
        }
    }
    
    // 💡 [새로 추가된 함수] 헤더 및 상세 패널에서 즐겨찾기 목록 조회를 요청하는 AJAX 함수 (전역)
    function fetchFavoriteStations() {
        
        const panel = document.getElementById('detail-panel');
        // 상세 패널 닫기 (목록을 새로 열기 위함)
        if (panel) panel.style.display = 'none';
        
        // 로그인 여부 확인 및 요청
        fetch('${pageContext.request.contextPath}/favorite/list')
            .then(response => {
                // 응답 코드가 401 Unauthorized 등 로그인 필요 응답일 수 있음
                if (response.status === 401) { 
                    alert('로그인 후 즐겨찾기 목록을 이용할 수 있습니다.');
                    return null;
                }
                if (!response.ok) {
                    throw new Error('즐겨찾기 목록을 가져오는 중 오류 발생');
                }
                return response.json();
            })
            .then(stations => {
                if (stations) {
                    displayFavoriteStations(stations); 
                }
            })
            .catch(error => {
                console.error('즐겨찾기 목록 로드 실패:', error);
                alert('즐겨찾기 목록을 가져올 수 없습니다. 서버 상태를 확인해주세요.');
                
                // 오류 발생 시 목록 패널 초기화
                if (stationsListEl && stationsListPanel) {
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록';
                }
            });
    }


    window.onload = function() {
        
        var mapContainer = document.getElementById('map'), 
            mapOption = {
                center: new kakao.maps.LatLng(35.15781570000001 , 129.0600331),
                level: 7
            }; 
        map = new kakao.maps.Map(mapContainer, mapOption); // 전역 변수 초기화

        var mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        var ps = new kakao.maps.services.Places(); 
        
        var keywordEl = document.getElementById('keyword');
        var searchBtn = document.getElementById('search-btn');
        var searchBoundsBtn = document.getElementById('search-bounds-btn'); 
        
        // 🌟 전역 변수 초기화
        stationsListPanel = document.getElementById('stations-list-panel'); 
        stationsListEl = document.getElementById('stations-list'); 
        
        var panel = document.getElementById('detail-panel');
        var closeBtn = document.getElementById('close-btn');
        
        // 🌟 사이드바 토글 로직 추가 (수정됨)
        var toggleSidebarBtn = document.getElementById('toggle-sidebar-btn');
        var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
        var body = document.body;

        if (toggleSidebarBtn && toggleContainer) {
            toggleSidebarBtn.addEventListener('click', function() {
                var isClosed = body.classList.toggle('sidebar-closed');
                
                // 🌟 추가된 로직: 상세 패널이 현재 보이는지 확인
                var isDetailPanelVisible = panel.style.display === 'block';

                if (isClosed) {
                    toggleSidebarBtn.title = "사이드바 보이기";
                    // 닫힐 때는 CSS가 처리하도록 둡니다. (left: 20px)
                } else {
                    toggleSidebarBtn.title = "사이드바 숨기기";
                    
                    // 💡 핵심 수정: 상세 패널이 열려 있다면 토글 버튼을 828px로 이동
                    if (isDetailPanelVisible) {
                        toggleContainer.style.left = DETAIL_OPEN_TOGGLE_LEFT; // ⬅️ 828px로 이동
                    } else {
                        // 상세 패널이 닫혀 있다면 기본 위치(424px)로 복원
                        toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
                    }
                    
                    // 상세 패널 위치 복원 (목록 옆)
                    panel.style.left = '444px';
                    panel.style.width = '380px';
                }
            });
        }
        // ----------------------------------


        // DOM 이벤트 리스너 설정
        closeBtn.addEventListener('click', function() {
            panel.style.display = 'none';
            if (activeStationItem) {
                activeStationItem.classList.remove('active');
                activeStationItem = null;
            }
            // 🌟 [수정] 상세 패널 닫힐 때 사이드바를 다시 보이게 함
            var body = document.body;
            body.classList.remove('sidebar-closed');

            // 토글 버튼 위치 복원
            var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }
        });


        // Enter 키로 검색
        keywordEl.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchBtn.click();
            }
        });

        // 4-6. 검색 버튼 로직
        searchBtn.addEventListener('click', function() {
            var keyword = keywordEl.value.trim();
            
            // 검색 버튼 클릭 시 목록이 열리므로 사이드바 상태 복원 및 토글 버튼 위치 초기화
            var body = document.body;
            body.classList.remove('sidebar-closed'); 

            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }
            
            // --- 1단계: 카카오 'Places' API로 좌표 변환 (장소 검색) ---
            ps.keywordSearch(keyword, function(data, status, pagination) {
                
                // --- 2단계: 분기 ---
                if (status === kakao.maps.services.Status.OK && data && data.length > 0) {
                    
                    var firstPlace = data[0];
                    var coords = new kakao.maps.LatLng(firstPlace.y, firstPlace.x); 
                    
                    map.setCenter(coords);
                    map.setLevel(4); 

                    // --- 3단계 (A): '반경'으로 DB 검색 ---
                    fetchStationsDataByRadius(coords.getLat(), coords.getLng());

                } else {
                    
                    // --- 3단계 (B): '키워드(LIKE)'로 DB 검색 ---
                    searchByKeyword(keyword);
                }
            });
        });
        
		// 💡 4-13. '현재 위치에서 찾기' 버튼 클릭 이벤트 (버튼 클릭시에만 작동)
		searchBoundsBtn.addEventListener('click', function() {
		    
		    var bounds = map.getBounds();
		    var swLatlng = bounds.getSouthWest();
		    var neLatlng = bounds.getNorthEast();

		    var minLat = swLatlng ? swLatlng.getLat() : NaN;
		    var maxLat = neLatlng ? neLatlng.getLat() : NaN;
		    var minLng = swLatlng ? swLatlng.getLng() : NaN;
		    var maxLng = neLatlng ? neLatlng.getLng() : NaN;
		    
		    if (isNaN(minLat) || isNaN(maxLat) || isNaN(minLng) || isNaN(maxLng) || (minLat == 0 && minLng == 0 && map.getLevel() < 10)) {
		        alert("지도 영역 정보를 가져올 수 없습니다. 지도를 움직이거나 확대/축소한 후 다시 시도해 주세요.");
		        console.error("Bounds check failed: Invalid coordinates detected.");
		        return; 
		    }
		    
            // 사이드바 상태 복원 및 토글 버튼 위치 초기화
            var body = document.body;
            body.classList.remove('sidebar-closed'); 
		    
            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }

		    fetchStationsDataByBounds(minLat, maxLat, minLng, maxLng);
		});
        
        // 4-8. '반경' 검색 함수
        function fetchStationsDataByRadius(latitude, longitude) {
            var radius = 2000; // 2km
            var url = '/searchByRadius?lat=' + latitude + '&lng=' + longitude + '&radius=' + radius; 
            
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('반경 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("검색된 지역 주변에 충전소가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>검색된 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('반경 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }
        
        // 4-8-2. '키워드(LIKE)' 검색 함수 
        function searchByKeyword(keyword) {
            var url = '/searchByKeyword?keyword=' + encodeURIComponent(keyword); 
            
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('키워드 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("'" + keyword + "'에 대한 검색 결과가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>검색된 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('키워드 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }
        
        // 💡 4-14. '지도 영역' 검색 함수
        function fetchStationsDataByBounds(minLat, maxLat, minLng, maxLng) {
            
            var url = "/searchByBounds?minLat=" + encodeURIComponent(minLat) + 
                      "&maxLat=" + encodeURIComponent(maxLat) + 
                      "&minLng=" + encodeURIComponent(minLng) + 
                      "&maxLng=" + encodeURIComponent(maxLng);

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('영역 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("현재 지도 영역에 충전소가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>현재 영역에 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('영역 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }

        // 4-12. 페이지 로드 시 초기 데이터 로드 (서울시청 기준)
        var initialCoords = mapOption.center; 
        fetchStationsDataByRadius(initialCoords.getLat(), initialCoords.getLng());
        
    }; // window.onload 함수 끝
    
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>