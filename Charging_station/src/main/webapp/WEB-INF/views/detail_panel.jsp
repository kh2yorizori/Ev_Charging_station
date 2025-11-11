<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 닫기 버튼 */
    .close-btn {
        position: absolute;
        top: 20px;
        right: 20px;
        width: 36px;
        height: 36px;
        font-size: 24px;
        font-weight: 300;
        color: #666;
        background: rgba(0, 0, 0, 0.05);
        border: none;
        border-radius: 50%;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10;
        line-height: 1;
    }
    .close-btn:hover {
        background: rgba(0, 0, 0, 0.1);
        color: #333;
        transform: rotate(90deg);
    }

    /* 패널 전체 */
    #detail-panel {
        font-family: 'Noto Sans KR', 'Malgun Gothic', '맑은 고딕', sans-serif;
        background: white;
        padding: 0;
        overflow-y: auto;
    }

    /* 헤더 영역 (그라데이션 배경) */
    .detail-header {
        /* map_kakao.jsp와 일관된 녹색 계열 그라데이션 사용 */
        background: linear-gradient(135deg, #52c41a 0%, #95de64 100%);
        padding: 32px 24px 24px;
        position: relative;
    }

    /* 충전소 이름 */
    #detail-panel #station-name {
        font-size: 22px;
        font-weight: 700;
        color: white;
        margin: 0 0 12px 0;
        padding-right: 50px;
        line-height: 1.4;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    /* 주소 */
    #detail-panel #station-address {
        font-size: 14px;
        color: rgba(255, 255, 255, 0.95);
        margin: 0;
        line-height: 1.6;
        padding-right: 50px;
    }

    /* 🌟 즐겨찾기 버튼 위치 수정 */
    #favorite-btn {
        position: absolute; 
        top: 60px; /* 닫기 버튼 (36px) 아래로 내림 */
        right: 20px;
        background: none;
        border: none;
        font-size: 28px; 
        color: white; 
        cursor: pointer;
        padding: 0;
        line-height: 1;
        transition: color 0.2s, transform 0.2s;
    }
    #favorite-btn:hover {
        color: #fff;
    }
    
    /* 🌟 상태별 스타일 관리 */
    
    /* 1. 등록 가능 (unfavorited) */
    #favorite-btn[data-status="unfavorited"] {
        color: rgba(255, 255, 255, 0.6); /* 빈 별 (헤더 배경색에 맞춰 밝게) */
        font-family: Arial, sans-serif; /* 폰트 충돌 방지를 위해 별 기호는 기본 폰트로 */
        font-size: 32px;
    }
    #favorite-btn[data-status="unfavorited"]:hover {
        color: #ffc107; /* 호버 시 노란색 별 */
        transform: scale(1.2);
    }

    /* 2. 등록됨 (favorited) */
    #favorite-btn[data-status="favorited"] {
        color: #ffc107; /* 꽉 찬 노란 별 */
        font-family: Arial, sans-serif;
        font-size: 32px;
    }
    #favorite-btn[data-status="favorited"]:hover {
        color: #e0a800; /* 호버 시 색상 어둡게 (삭제 의도) */
    }
    
    /* 3. 로그인 필요 (logged-out) */
    #favorite-btn[data-status="logged-out"] {
        color: rgba(255, 255, 255, 0.4);
        cursor: not-allowed;
        font-family: Arial, sans-serif;
        font-size: 32px;
    }
    
    /* 컨텐츠 영역 */
    .detail-content {
        padding: 24px;
    }

    /* 섹션 타이틀 */
    .section-title {
        font-size: 15px;
        font-weight: 700;
        color: #333;
        margin: 0 0 16px 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .section-title::before {
        content: '';
        width: 4px;
        height: 18px;
        /* 섹션 타이틀 리드선 색상 유지 */
        background: linear-gradient(135deg, #52c41a 0%, #95de64 100%); 
        border-radius: 2px;
    }

    /* 운영 정보 섹션 */
    .info-section {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .info-section p {
        font-size: 14px;
        color: #555;
        margin: 0 0 12px 0;
        line-height: 1.6;
        display: flex;
        align-items: flex-start;
    }

    .info-section p:last-child {
        margin-bottom: 0;
    }

    .info-label {
        font-weight: 600;
        color: #333;
        min-width: 110px;
        flex-shrink: 0;
    }

    .info-value {
        color: #666;
        flex: 1;
    }

    /* 충전기 현황 섹션 */
    .status-section {
        margin-bottom: 20px;
    }

    .charger-cards {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
        margin-top: 16px;
    }

    .charger-card {
        background: white;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        padding: 20px 16px;
        text-align: center;
        transition: all 0.3s ease;
    }

    .charger-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    .charger-card.fast {
        border-color: #e3f2fd;
        background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
    }

    .charger-card.slow {
        border-color: #e8f5e9;
        background: linear-gradient(135deg, #ffffff 0%, #f1f8f4 100%);
    }

    .charger-icon {
        font-size: 28px;
        margin-bottom: 8px;
        display: block;
    }

    .charger-type {
        font-size: 11px;
        font-weight: 600;
        color: #999;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 4px;
    }

    .charger-card.fast .charger-type {
        color: #2196F3;
    }

    .charger-card.slow .charger-type {
        color: #4CAF50;
    }

    .charger-count {
        font-size: 22px;
        font-weight: 700;
        color: #333;
        margin-bottom: 4px;
    }

    .charger-label {
        font-size: 12px;
        color: #666;
    }

    /* 이용 제한 뱃지 */
    .restriction-badge {
        display: inline-block;
        padding: 6px 12px;
        background: linear-gradient(135deg, rgba(82, 196, 26, 0.1) 0%, rgba(149, 222, 100, 0.1) 100%);
        border: 1px solid rgba(82, 196, 26, 0.3);
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        color: #52c41a;
        margin-top: 8px;
    }

    /* 구분선 */
    .divider {
        height: 1px;
        background: #e9ecef;
        margin: 24px 0;
    }

    /* 스크롤바 커스텀 */
    #detail-panel::-webkit-scrollbar {
        width: 6px;
    }

    #detail-panel::-webkit-scrollbar-track {
        background: transparent;
    }

    #detail-panel::-webkit-scrollbar-thumb {
        background: rgba(0, 0, 0, 0.2);
        border-radius: 10px;
    }

    #detail-panel::-webkit-scrollbar-thumb:hover {
        background: rgba(0, 0, 0, 0.3);
    }

    /* 숨김 처리 */
    #charger_model_small,
    #fast_charge_capacity,
    #charger_type {
        display: none;
    }



    /* 길찾기 버튼 스타일 */
#detail-panel .action-buttons {
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #f0f0f0;
        
        /* 💡 [추가] 버튼 2개를 가로/중앙으로 배치 */
        display: flex;
        justify-content: center;
        gap: 12px; /* 버튼 사이 간격 */
    }
    #detail-panel .navi-btn {
        display: inline-block;
        padding: 10px 20px;
        background-color: #FEE500;
        color: #181600;
        font-size: 1em;
        font-weight: bold;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.2s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    #detail-panel .navi-btn:hover {
        background-color: #F7E000;
    }

    /* 💡 [추가] 로드뷰 버튼 스타일 (navi-btn과 유사하게) */
    #detail-panel .roadview-btn {
        display: inline-block;
        padding: 10px 20px;
        background-color: #007bff; /* 카카오맵과 비슷한 파란색 계열 */
        color: white;
        font-size: 1em;
        font-weight: bold;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.2s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    #detail-panel .roadview-btn:hover {
        background-color: #0056b3;
    }



/* 💡 [수정] 새로운 카드 디자인에 클릭/호버 효과 적용 */
.charger-card.clickable {
    cursor: pointer;
    /* transition은 이미 .charger-card에 있습니다 */
}
.charger-card.clickable:hover {
    /* 이미 :hover 스타일이 있지만, 클릭 가능하다는 것을 강조하기 위해 border 색상 변경 */
    border-color: #52c41a; 
}

/* 💡 [수정] 상세 충전기 목록 스타일 (카드 내부에 맞게) */
.charger-details-list {
    display: none; /* 💡 평소엔 숨김 */
    list-style: none;
    padding: 12px 0 0 0;
    margin: 12px 0 0 0;
    border-top: 1px solid #e9ecef; /* 카드 내부 구분선 */
    font-size: 14px;
    text-align: left; /* 💡 카드(center)와 달리 좌측 정렬 */
}
.charger-details-list li {
    display: flex;
    justify-content: space-between;
    padding: 5px 0; /* 💡 좌우 패딩 제거 (카드 패딩 사용) */
}
.charger-details-list li span:first-child {
    color: #555; /* 타입 이름 */
}
.charger-details-list li span:last-child {
    font-weight: 600; /* 개수 */
    color: #333;
}

/* 💡 [추가] 노란색 뱃지 (이용자제한) */
.restriction-badge.badge-yellow {
    background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 213, 79, 0.1) 100%);
    border-color: rgba(255, 193, 7, 0.3);
    color: #e6a800;
}

/* 💡 [추가] 빨간색 뱃지 (비공개) */
.restriction-badge.badge-red {
    background: linear-gradient(135deg, rgba(244, 67, 54, 0.1) 0%, rgba(255, 138, 128, 0.1) 100%);
    border-color: rgba(244, 67, 54, 0.3);
    color: #d93025;
}
</style>

<div id="detail-panel">
    <button id="close-btn" class="close-btn" title="닫기">&times;</button>

    <div class="detail-header">
        <h3 id="station-name">충전소 이름 로딩 중...</h3>
        <p id="station-address">주소 로딩 중...</p>
        
        <c:if test="${not empty sessionScope.id}">
            <button id="favorite-btn" data-status="unfavorited" title="즐겨찾기 추가/삭제">☆</button> 
        </c:if>
    </div>

    <div class="detail-content">
        
<div class="status-section">
        <div class="section-title">⚡ 충전기 현황</div>
        <div class="charger-cards">
            
            <div class="charger-card fast clickable" id="fast-charger-toggle" data-target="#fast-details-list">
                <span class="charger-icon">⚡</span>
                <div class="charger-type">급속</div>
                <div id="fast-charger-count" class="charger-count">0</div>
                <div class="charger-label">대</div>
                
                <ul class="charger-details-list" id="fast-details-list">
                    </ul>
            </div>
            
            <div class="charger-card slow clickable" id="slow-charger-toggle" data-target="#slow-details-list">
                <span class="charger-icon">🔌</span>
                <div class="charger-type">완속</div>
                <div id="slow-charger-count" class="charger-count">0</div>
                <div class="charger-label">대</div>
                
                <ul class="charger-details-list" id="slow-details-list">
                    </ul>
            </div>
        </div>
    </div>

        <div class="divider"></div>

        <div class="info-section">
            <div class="section-title">📋 운영 정보</div>
            <p>
                <span class="info-label">운영기관</span>
                <span id="operator_large" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">운영기관(상세)</span>
                <span id="operator_small" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">시설 구분</span>
                <span id="facility_type_large" class="info-value">-</span>
            </p>
            <p style="display: block; margin: 0;">
                <span class="info-label">이용 제한</span>
                <span id="user_restriction" class="restriction-badge">정보 없음</span>
            </p>
        </div>

    </div>

    <p id="charger_model_small" style="display:none;"></p>
    <p id="fast_charge_capacity" style="display:none;"></p>
    <p id="charger_type" style="display:none;"></p>
    
    <input type="hidden" id="current-station-id" value=""> 

    <div id="other-details"></div>

    <div class="action-buttons">
        <a id="navi-link" href="#" target="_blank" class="navi-btn">
            카카오맵으로 길찾기
        </a>

        <a id="roadview-link" href="#" target="_blank" class="roadview-btn">
            로드뷰 보기
        </a>
    </div>
    
</div>

<script>
    // 🌟 JSTL을 사용하여 로그인 상태를 JavaScript 변수로 저장
    const IS_LOGGED_IN = <c:out value="${not empty sessionScope.id}" default="false"/>;
    
    const favoriteBtn = document.getElementById('favorite-btn');
    const stationIdInput = document.getElementById('current-station-id');

    /**
     * 즐겨찾기 버튼의 UI 상태를 업데이트하는 함수
     * @param {string} status - 'logged-out', 'unfavorited', 'favorited' 중 하나
     */
    function updateFavoriteButton(status) {
        if (!favoriteBtn) return;
        
        favoriteBtn.setAttribute('data-status', status);
        
        if (status === 'logged-out') {
            favoriteBtn.textContent = '🔒'; // 자물쇠 아이콘
            favoriteBtn.title = '로그인 후 이용 가능';
            favoriteBtn.disabled = true;
        } else if (status === 'favorited') {
            favoriteBtn.textContent = '★'; // 꽉 찬 별
            favoriteBtn.title = '즐겨찾기에 등록됨 (클릭 시 삭제)';
            favoriteBtn.disabled = false;
        } else { // unfavorited
            favoriteBtn.textContent = '☆'; // 빈 별
            favoriteBtn.title = '즐겨찾기에 추가';
            favoriteBtn.disabled = false;
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        // 초기 로드 시 로그인 상태에 따라 버튼을 즉시 설정
        if (!IS_LOGGED_IN) {
            updateFavoriteButton('logged-out');
        } else {
            updateFavoriteButton('unfavorited');
        }

        if (favoriteBtn) {
            favoriteBtn.addEventListener('click', async function() {
                
                const currentStatus = favoriteBtn.getAttribute('data-status');
                
                // 로그인 필요 상태라면 클릭 무시
                if (currentStatus === 'logged-out') {
                    alert('로그인 후 이용 가능합니다.');
                    return;
                }

                const stationId = stationIdInput.value;
                
                if (!stationId) {
                    alert('충전소 정보가 올바르지 않습니다. 다시 시도해 주세요.');
                    return;
                }

                let endpoint = '';
                let successStatus = '';
                let successMessage = '';
                
                if (currentStatus === 'favorited') {
                    // 💡 삭제 로직
                    endpoint = '${pageContext.request.contextPath}/favorite/delete';
                    successStatus = 'unfavorited';
                    successMessage = '즐겨찾기에서 삭제되었습니다.';
                } else { 
                    // 💡 추가 로직 (unfavorited 상태일 때)
                    endpoint = '${pageContext.request.contextPath}/favorite/add';
                    successStatus = 'favorited';
                    successMessage = '⭐ 즐겨찾기에 성공적으로 추가되었습니다.';
                }

                // AJAX 요청
                try {
                    const response = await fetch(endpoint, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'stationId=' + encodeURIComponent(stationId)
                    });

                    const data = await response.json();
                    
                    if (data.success) {
                        // 성공 시 상태 전환
                        updateFavoriteButton(successStatus); 
                        
                        // 🌟 [추가된 로직] 삭제 성공 시 즐겨찾기 목록을 즉시 갱신
                        if (successStatus === 'unfavorited') { 
                            if (typeof fetchFavoriteStations === 'function') {
                                // map_kakao.jsp에 정의된 전역 함수 호출
                                fetchFavoriteStations(); 
                            }
                        }
                        
                    } else {
                        alert(data.message);
                        // 서버 오류 메시지 처리 (재확인)
                        checkFavoriteStatus(stationId); 
                    }
                } catch (error) {
                    console.error('Error processing favorite:', error);
                    alert('서버 통신 중 오류가 발생했습니다.');
                    checkFavoriteStatus(stationId); 
                }
            });
        }
    });

    /**
     * Main_Map.jsp에서 충전소 ID를 설정하고 상태를 체크하도록 호출하는 함수. (외부 노출)
     * @param {string | number} id - 현재 클릭된 충전소의 station_id
     */
    function setStationIdAndCheckFavorite(id) {
        // 1. 숨겨진 필드에 ID 설정
        document.getElementById('current-station-id').value = id;
        
        // 2. 로그인 상태가 아니면 즉시 UI 갱신 후 종료
        if (!IS_LOGGED_IN) {
            updateFavoriteButton('logged-out');
            return;
        }
        
        // 3. 로그인 상태면 서버에 상태 체크를 요청 (새 마커 클릭 시마다 실행)
        checkFavoriteStatus(id);
    }
    
    /**
     * 서버에 즐겨찾기 상태를 확인하는 AJAX 함수
     * @param {string | number} stationId - 확인할 충전소 ID
     */
    async function checkFavoriteStatus(stationId) {
        
        // 상태 확인 전, 잠시 버튼을 기본 상태로 리셋
        updateFavoriteButton('unfavorited'); 

        try {
            const url = '${pageContext.request.contextPath}/favorite/checkStatus';
            
            const response = await fetch(url, {
                method: 'POST', 
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'stationId=' + encodeURIComponent(stationId) 
            });
            
            const data = await response.json();
            
            // isFavorited 결과로 버튼 상태 업데이트
            if (data.isFavorited) {
                updateFavoriteButton('favorited');
            } else {
                updateFavoriteButton('unfavorited');
            }

        } catch (error) {
            console.error('Failed to check favorite status:', error);
            updateFavoriteButton('unfavorited'); 
        }
    }
</script>