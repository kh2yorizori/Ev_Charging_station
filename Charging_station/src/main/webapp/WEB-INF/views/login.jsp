<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- 부트스트랩 (선택 사항) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            width: 360px;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-box button {
            width: 100%;
        }
        .register-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>로그인</h2>

    <!-- 로그인 폼 -->
    <form action="login_yn" method="post">
        <div class="mb-3">
            <label for="MEMBER_ID" class="form-label">아이디</label>
            <input type="text" class="form-control" id="MEMBER_ID" name="MEMBER_ID" required>
        </div>
        <div class="mb-3">
            <label for="PASSWORD" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="PASSWORD" name="PASSWORD" required>
        </div>

        <div class="form-check mb-3">
            <input type="checkbox" class="form-check-input" id="admin_ck" name="admin_ck" value="Y">
            <label class="form-check-label" for="admin_ck">관리자 로그인</label>
        </div>

        <button type="submit" class="btn btn-primary">로그인</button>
    </form>

    <div class="register-link">
        <p>계정이 없으신가요? <a href="register">회원가입</a></p>
    </div>
</div>

<!-- 부트스트랩 JS (선택 사항) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
