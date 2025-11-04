<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        /* login.jsp와 동일한 스타일 적용 */
        body {
            background-color: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            width: 380px;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-box .btn-primary {
            width: 100%;
        }
        .back-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>비밀번호 찾기</h2>
    <p style="text-align: center; color: #666; margin-bottom: 25px;">
        가입 시 사용한 아이디와 이메일을 입력하세요.<br>
        인증 메일이 발송됩니다.
    </p>

    <form action="findPasswordAction" method="post">
        <div class="mb-3">
            <label for="MEMBER_ID" class="form-label">아이디</label>
            <input type="text" class="form-control" id="MEMBER_ID" name="MEMBER_ID" placeholder="아이디 입력" required>
        </div>

        <div class="mb-3">
            <label for="MEMBER_EMAIL" class="form-label">이메일</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="이메일 입력 (예: user@example.com)" required>
        </div>

        <button type="submit" class="btn btn-primary">인증 메일 발송</button>
    </form>

    <div class="back-link">
        <p><a href="login">로그인 페이지로 돌아가기</a></p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>