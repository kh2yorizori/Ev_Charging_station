<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>마이페이지</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
		
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    
    <style>
        /* --- 1. 페이지 레이아웃 (헤더/푸터 분리) --- */
        body {
            /* (로그인 페이지와 동일한 배경 이미지) */
            background-image: url('https://images.unsplash.com/photo-1593941707882-65c6405f5a24?q=80&w=1974&auto=format&fit=crop');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            
            display: flex;
            flex-direction: column; /* 헤더, main, 푸터를 세로로 쌓음 */
            min-height: 100vh;
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        /* --- 2. 메인 컨테이너 (중앙 정렬 담당) --- */
        .main-container { /* (login-container 대신 범용 이름 사용) */
            flex-grow: 1; /* 헤더/푸터 제외 남은 공간 모두 차지 */
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        /* --- 3. 마이페이지 박스 (반투명 스타일) --- */
        .mypage-box {
            width: 400px;
            max-width: 100%;
            
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .mypage-box h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #222;
        }
        .mypage-box button, .mypage-box input[type="submit"] {
            width: 100%;
            margin-top: 10px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        /* --- 4. 긴 텍스트 처리 (이메일 등) --- */
        .info-item span:first-child {
            font-weight: 500;
            color: #555;
            flex-shrink: 0;
            margin-right: 10px;
        }
        .info-item span:last-child {
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 250px;
            text-align: right;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="main-container">
        <div class="mypage-box">
            <h2>마이페이지</h2>
            <div class="info-list">
                <div class="info-item">
                    <span>닉네임</span>
                    <span>${user.nickname}</span>
                </div>
                <div class="info-item">
                    <span>이름</span>
                    <span>${user.name}</span>
                </div>
                <div class="info-item">
                    <span>아이디</span>
                    <span>${user.memberId}</span>
                </div>
                <div class="info-item">
                    <span>이메일</span>
                    <span>${user.email}</span>
                </div>
                <div class="info-item">
                    <span>전화번호</span>
                    <span>${user.phoneNumber}</span>
                </div>
            </div>
    
           <button type="button" class="btn btn-primary" onclick="location.href='mypage_edit?memberId=${user.memberId}'">정보 수정</button>
    
            <c:if test="${sessionScope.admin == 1}">
                <button type="button" class="btn btn-warning" onclick="location.href='role'">회원 관리</button>
            </c:if>
    
            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal" style="margin-top:10px; width:100%;">
                회원 탈퇴
            </button>
        </div>
    </main> <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">회원 탈퇴 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <form action="delete" method="post" style="margin:0;">
                        <input type="hidden" name="memberId" value="${user.memberId}" />
                        <button type="submit" class="btn btn-danger">회원 탈퇴</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>