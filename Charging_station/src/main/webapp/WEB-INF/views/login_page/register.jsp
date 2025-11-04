<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background-color: #f8f9fa;
}
.container {
    max-width: 600px;
    margin-top: 80px;
    background: white;
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
</style>
</head>
<body>

<div class="container">
    <h2 class="text-center mb-4">회원가입</h2>
    <form action="registerOk" method="post">
        <div class="mb-3">
            <label class="form-label">아이디</label>
            <input type="text" class="form-control" name="MEMBER_ID" required>
        </div>
        <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input type="password" class="form-control" name="PASSWORD" required>
        </div>
        <div class="mb-3">
            <label class="form-label">이름</label>
            <input type="text" class="form-control" name="NAME" required>
        </div>
        <div class="mb-3">
            <label class="form-label">닉네임</label>
            <input type="text" class="form-control" name="NICKNAME" required>
        </div>
        <div class="mb-3">
            <label class="form-label">이메일</label>
            <input type="email" class="form-control" name="EMAIL" required>
        </div>
        <div class="mb-3">
            <label class="form-label">전화번호</label>
            <input type="text" class="form-control" name="PHONE_NUMBER">
        </div>
        <div class="mb-3">
            <label class="form-label">생년월일</label>
            <input type="date" class="form-control" name="BIRTHDATE">
        </div>
        
        <button type="submit" class="btn btn-success w-100">회원가입</button>
    </form>

    <div class="text-center mt-3">
        <a href="login">이미 계정이 있으신가요? 로그인</a>
    </div>
</div>

</body>
</html>
