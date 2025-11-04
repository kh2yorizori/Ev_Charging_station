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

        <form action="delete" method="post" style="margin-top:10px;">
            <input type="hidden" name="memberId" value="${user.memberId}" />
            <input type="submit" class="btn btn-danger" value="회원 탈퇴" onclick="return confirm('정말 탈퇴하시겠습니까?');" />
        </form>
    </div>
</body>
</html>
