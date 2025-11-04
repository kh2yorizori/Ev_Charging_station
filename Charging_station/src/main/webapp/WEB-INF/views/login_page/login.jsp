<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- 부트스트랩 -->
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
            width: 380px; /* 너비 살짝 조정 */
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-box .btn-primary { /* 기본 로그인 버튼 */
            width: 100%;
        }
        .register-link {
            text-align: center;
            margin-top: 15px;
        }
        
        /* --- 소셜 로그인 버튼 스타일 추가 --- */
        .divider {
            text-align: center;
            margin: 20px 0;
            line-height: 0.1em;
            border-bottom: 1px solid #ddd;
        }
        .divider span {
            background: #fff;
            padding: 0 10px;
            color: #888;
            font-size: 0.9em;
        }
        .google-login-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
            color: #555;
            text-decoration: none;
            font-weight: 500;
            font-size: 1em;
            transition: box-shadow 0.2s ease;
        }
        .google-login-btn:hover {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            color: #333;
        }
        .google-login-btn img {
            width: 20px;
            height: 20px;
            margin-right: 12px;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>로그인</h2>

    <!-- 1. 일반 로그인 폼 -->
    <form action="login_yn" method="post">
        <div class="mb-3">
            <label for="MEMBER_ID" class="form-label">아이디</label>
            <input type="text" class="form-control" id="MEMBER_ID" name="MEMBER_ID" required>
        </div>
        <div class="mb-3">
            <label for="PASSWORD" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="PASSWORD" name="PASSWORD" required>
        </div>

        <!-- 
          [삭제] "관리자 로그인" 체크박스 제거
          -> MemController의 login_yn 로직에서 DB의 adminck 값을 사용하도록 수정했기 때문에
             이 체크박스는 더 이상 필요 없으며, 보안상 제거하는 것이 올바른 방향입니다.
        -->

        <button type="submit" class="btn btn-primary">로그인</button>
    </form>

    <!-- 2. 소셜 로그인 (구분선) -->
    <div class="divider"><span>OR</span></div>

    <!-- 
      🔴 중요! 🔴
      아래 href 링크의 [YOUR_CLIENT_ID]와 [YOUR_REDIRECT_URI]를
      반드시 본인의 구글 클라우드 콘솔 값으로 변경해야 합니다!
    -->
	<a href="https://accounts.google.com/o/oauth2/v2/auth?client_id=[YOUR_CLIENT_ID]&redirect_uri=[YOUR_REDIRECT_URI]&response_type=code&scope=profile email openid" 
	       class="google-login-btn">
	        <!-- 구글 로고 SVG 아이콘 -->
	        <img src="https://img1.daumcdn.net/thumb/R1280x0.fwebp/?fname=http://t1.daumcdn.net/brunch/service/user/5rH/image/LHUiJV1nog0BqnOJ8Mtj5UbNTjQ" alt="Google logo">
	        <span>Google 계정으로 로그인</span>
	 </a>

    <!-- 3. 회원가입 링크 -->
    <div class="register-link">
        <p>계정이 없으신가요? <a href="register">회원가입</a></p>
    </div>
</div>

<!-- 부트스트랩 JS (선택 사항) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
