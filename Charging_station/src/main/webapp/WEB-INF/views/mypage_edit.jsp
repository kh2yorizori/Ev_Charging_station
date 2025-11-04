<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>정보 수정 - 요리조리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin-top: 80px; /* 상단 여백 */
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* --- mypage_edit.jsp 고유 스타일 --- */
        .container h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .container button, .container input[type="submit"] {
            width: 100%;
            margin-top: 10px;
        }
        .form-label {
            margin-bottom: .25rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>정보 수정</h2>
        
        <form action="modify" method="post">
            <input type="hidden" name="memberId" value="${user.memberId}" />

            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname}">
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">이름</label>
                <input type="text" class="form-control" id="name" name="name" value="${user.name}">
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email" value="${user.email}">
            </div>

            <div class="mb-3">
                <label for="phoneNumber" class="form-label">전화번호</label>
                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
            </div>
            
            <div class="mb-3">
                <label for="birthdate" class="form-label">생년월일</label>
                <input type="date" class="form-control" id="birthdate" name="birthdate" 
                       value="<fmt:formatDate value="${user.birthdate}" pattern="yyyy-MM-dd"/>
            </div>

            <input type="submit" class="btn btn-primary" value="수정 완료" />
            
            <button type="button" class="btn btn-secondary" onclick="location.href='list'">취소</button>
        </form>
    </div>
</body>
</html>