<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>마이페이지 - 요리조리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .mypage-box {
            width: 400px;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .mypage-box h2 {
            text-align: center;
            margin-bottom: 30px;
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
        
        /* 긴 텍스트 처리를 위한 CSS */
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
        <button type="button" class="btn btn-secondary" onclick="location.href='myrecipe?member_Id=${user.memberId}'">내 게시물 보기</button>

        <!-- ✅ [추가] 관리자(admin == 1)일 때만 "회원 관리" 버튼 표시 -->
        <c:if test="${sessionScope.admin == 1}">
            <button type="button" class="btn btn-warning" onclick="location.href='role'">회원 관리</button>
        </c:if>

        <!-- ✅ [수정] 회원 탈퇴 버튼 (모달 트리거) -->
        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal" style="margin-top:10px; width:100%;">
            회원 탈퇴
        </button>
    </div>

    <!-- 
      ✅ [추가] 회원 탈퇴 확인 모달 (Modal)
      confirm()을 대체합니다.
    -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
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
                    <!-- "탈퇴" 버튼 클릭 시 실제 폼 전송 -->
                    <form action="delete" method="post" style="margin:0;">
                        <input type="hidden" name="memberId" value="${user.memberId}" />
                        <button type="submit" class="btn btn-danger">회원 탈퇴</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 부트스트랩 JS (모달 작동을 위해 필수) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

