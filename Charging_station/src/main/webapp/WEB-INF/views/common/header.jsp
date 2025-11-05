<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
</head>
<body>
    <nav id="nav3">
        
		<a href="#" class="logo">
		            <img class="nav-icon" src="../image/EV.png">EV충전소
		        </a>
		        
		        <ul class="main-nav">
		            <li><a href="main"><img class="nav-icon" src="../image/home.png">홈</a></li>
		            <li><a href="map_kakao"><img class="nav-icon" src="../image/charging.png">충전소 찾기</a></li> 
						<li><a href="#"><img class="nav-icon" src="../image/notificaiton.png">공지사항</a></li>
			            <li><a href="#"><img class="nav-icon" src="../image/board.png">자유게시판</a></li>
		        </ul>
        
		<ul class="user-nav">
		            <c:choose>
									
		                <c:when test="${empty sessionScope.id}"> 
		                    <li> <button type="button" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button></li>
		                    <li><button type="button" onclick="location.href='${pageContext.request.contextPath}/register'">회원가입</button></li>
		                </c:when>
		                
		                <c:otherwise>
		            	    <li><a href="#"><img class="nav-icon" src="../image/favourite.png">즐겨찾기</a></li>
                            
<li class="user-dropdown-container">
                                
                                <button type="button" id="userMenuTrigger" class="user-menu-trigger">
                                    <span>${sessionScope.name}님!</span>
                                    <i class="fas fa-chevron-down"></i> </button>
                                
                                <div id="userMenuDropdown" class="user-dropdown-menu">
                                    <ul>
										<c:if test="${sessionScope.admin == 1}">
											<li>
												<form method="get" action="role" style="margin: 0;">
											       <button type="submit">관리자페이지</button>
											   </form>
										   </li>
										</c:if>
                                        
                                        <li><a href="${pageContext.request.contextPath}/list">마이페이지</a></li>
                                        <li>
                                            <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;">
                                              <button type="submit">로그아웃</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </li>
		                </c:otherwise>
		                
		            </c:choose>
		        </ul>

    </nav>

    <script>
        // 페이지 로드가 완료되면 스크립트 실행
        document.addEventListener("DOMContentLoaded", function() {
            
            // 버튼과 메뉴 요소를 가져옵니다. (로그인 했을 때만 존재)
            var trigger = document.getElementById("userMenuTrigger");
            var dropdown = document.getElementById("userMenuDropdown");

            // 해당 요소들이 페이지에 존재할 때만 이벤트 리스너 추가
            if (trigger && dropdown) {
                
                // 1. 환영 메시지 버튼 클릭 시
                trigger.addEventListener("click", function(event) {
                    event.stopPropagation(); // 다른 곳으로 클릭 이벤트가 퍼지는 것을 방지
                    dropdown.classList.toggle("show"); // 'show' 클래스를 추가/제거
                });

                // 2. 페이지의 다른 곳을 클릭 시
                window.addEventListener("click", function(event) {
                    // 드롭다운이 열려있고, 클릭한 곳이 트리거 버튼이 아니라면
                    if (dropdown.classList.contains("show") && !trigger.contains(event.target)) {
                        dropdown.classList.remove("show"); // 드롭다운 닫기
                    }
                });
            }
        });
    </script>
	
	</body>
</html>