<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
	
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    
    <style>
        /* --- 1. 페이지 레이아웃 (헤더/푸터 분리) --- */
        body {
            /* (배경 이미지는 EV 컨셉에 맞는 다른 이미지로 변경하셔도 좋습니다) */
            background-image: url('https://images.unsplash.com/photo-1593941707882-65c6405f5a24?q=80&w=1974&auto=format&fit=crop');
            background-size: cover; /* 화면에 꽉 차게 */
            background-position: center center; /* 중앙 정렬 */
            background-attachment: fixed; /* 스크롤해도 배경 고정 */
            
            display: flex;
            flex-direction: column; /* 헤더, main, 푸터를 세로로 쌓음 */
            min-height: 100vh; /* 최소 높이를 화면 100%로 설정 */
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        /* --- 2. 로그인 컨테이너 (중앙 정렬 담당) --- */
        .login-container {
            flex-grow: 1; /* 헤더/푸터 제외 남은 공간 모두 차지 */
            display	: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        /* --- 3. 로그인 박스 (반투명 스타일) --- */
        .login-box {
            width: 400px;
            max-width: 100%;
            
            /* 반투명 유리(Frosted Glass) 효과 */
            background-color: rgba(255, 255, 255, 0.9); /* 흰색 배경 (90% 불투명) */
            backdrop-filter: blur(10px); /* 배경 흐림 효과 (핵심) */
            -webkit-backdrop-filter: blur(10px); /* Safari 호환성 */
            
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15); /* 은은한 그림자 */
            border: 1px solid rgba(255, 255, 255, 0.18); /* 얇은 테두리 */
        }
        
        .login-box h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #222;
        }
        
        .login-box .btn-primary {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: 500;
            background-color: #07db71; /* 로고와 동일한 파란색 */
            border: none;
        }
        .login-box .btn-primary:hover {
            background-color: #04723b;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            text-decoration: underline;
        }

        /* --- 4. 기타 스타일 (유지) --- */
        .divider {
            text-align: center;
            margin: 20px 0;
            line-height: 0.1em;
            border-bottom: 1px solid #ddd;
        }
        .divider span {
            background: rgba(255, 255, 255, 0.9); /* 박스 배경색과 동일하게 */
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
            background-color: #fff; /* 구글 버튼은 흰색 유지 */
            color: #555;
            text-decoration: none;
            font-weight: 500;
            font-size: 1em;
            transition: box-shadow 0.2s ease;
        }
        .google-login-btn:hover {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .google-login-btn img {
            width: 20px;
            height: 20px;
            margin-right: 12px;
        }

        div.main { position: relative; }
        div.main input { width: 100%; height: 38px; padding-right: 40px; text-indent: 10px; }
        div.main i { position: absolute; right: 10px; top: 8px; color: #999; cursor: pointer; }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="login-container">
        <div class="login-box">
            <h2>로그인</h2>
        
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
        
			<a href="https://accounts.google.com/o/oauth2/v2/auth?client_id=461483322193-krdf6oc8alee5hsnqlcp9tca8nr8qql2.apps.googleusercontent.com&redirect_uri=http://localhost:8484/login/oauth2/code/google&response_type=code&scope=profile email openid" 
 
               class="google-login-btn">
                <img src="https://img1.daumcdn.net/thumb/R1280x0.fwebp/?fname=http://t1.daumcdn.net/brunch/service/user/5rH/image/LHUiJV1nog0BqnOJ8Mtj5UbNTjQ" alt="Google logo">
                <span>Google 계정으로 로그인</span>
            </a>
        
            <div class="register-link">
                    <p style="margin-bottom: 8px;"><a href="findPassword">비밀번호를 잊으셨나요?</a></p>
                    <p>계정이 없으신가요? <a href="register">회원가입</a></p>
            </div>
        </div>
    </main> <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

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
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>