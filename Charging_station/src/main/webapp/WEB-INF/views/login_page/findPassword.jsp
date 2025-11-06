<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
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
        .login-container { /* login.jsp의 CSS와 클래스 이름 통일 */
            flex-grow: 1; /* 헤더/푸터 제외 남은 공간 모두 차지 */
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        /* --- 3. 로그인 박스 (반투명 스타일) --- */
        .login-box {
            width: 400px; /* (기존 380px보다 조금 넓게) */
            max-width: 100%;
            
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px; /* (간격 살짝 조절) */
            font-weight: 700;
            color: #222;
        }
        
        .login-box .btn-primary {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: 500;
            background-color: #007bff;
            border: none;
        }
        .login-box .btn-primary:hover {
            background-color: #0056b3;
        }

        /* --- 4. 하단 링크 (login.jsp와 스타일 통일) --- */
        .register-link { /* (back-link 대신 register-link 클래스 사용) */
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
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="login-container">
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
        
            <div class="register-link">
                <p><a href="login">로그인 페이지로 돌아가기</a></p>
            </div>
        </div>
    </main> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>