<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- 부트스트랩 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome (아이콘용) -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

    <style>
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
        .register-link {
            text-align: center;
            margin-top: 15px;
        }

        /* --- 소셜 로그인 버튼 --- */
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

        /* --- 비밀번호 보기/숨기기 --- */
        h1, div.main {
            width: 100%;
            margin: 0 auto;
        }
        div.main {
            position: relative;
        }
        div.main input {
            width: 100%;
            height: 38px;
            padding-right: 40px;
            text-indent: 10px;
        }
        div.main i {
            position: absolute;
            right: 10px;
            top: 8px;
            color: #999;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>로그인</h2>

    <!-- 일반 로그인 폼 -->
    <form action="login_yn" method="post">
        <div class="mb-3">
            <label for="MEMBER_ID" class="form-label">아이디</label>
            <input type="text" class="form-control" id="MEMBER_ID" name="MEMBER_ID" required>
        </div>

        <div class="mb-3">
            <label for="PASSWORD" class="form-label">비밀번호</label>
            <div class="main">
                <input type="password" class="form-control" id="PASSWORD" name="PASSWORD" required>
                <i class="fa fa-eye fa-lg"></i>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">로그인</button>
    </form>

    <div class="divider"><span>OR</span></div>

    <!-- 구글 로그인 -->
    <a href="https://accounts.google.com/o/oauth2/v2/auth?client_id=[클라이언트 id]&redirect_uri=[클라이언트uri]&scope=profile email openid" 
       class="google-login-btn">
        <img src="https://img1.daumcdn.net/thumb/R1280x0.fwebp/?fname=http://t1.daumcdn.net/brunch/service/user/5rH/image/LHUiJV1nog0BqnOJ8Mtj5UbNTjQ" alt="Google logo">
        <span>Google 계정으로 로그인</span>
    </a>

	<div class="register-link">
	        <p style="margin-bottom: 8px;"><a href="findPassword">비밀번호를 잊으셨나요?</a></p>
	        <p>계정이 없으신가요? <a href="register">회원가입</a></p>
	    </div>
	</div>
</div>

<!-- jQuery (필수) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- 부트스트랩 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 비밀번호 보기/숨기기 스크립트 -->
<script>
$(document).ready(function(){
    $('.main i').on('click',function(){
        let input = $(this).prev('input');
        input.toggleClass('active');
        if(input.hasClass('active')){
            $(this).attr('class',"fa fa-eye-slash fa-lg");
            input.attr('type',"text");
        }else{
            $(this).attr('class',"fa fa-eye fa-lg");
            input.attr('type','password');
        }
    });
});
</script>

</body>
</html>
