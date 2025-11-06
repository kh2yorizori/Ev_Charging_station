<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

    <style>
        body {
            background-color: #f5f5f5;
        }
        .notice-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }
        .notice-header {
            margin-bottom: 30px;
        }
        .notice-item {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s;
        }
        .notice-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        .category-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            margin-right: 10px;
        }
        .category-운영 { background-color: #007bff; color: white; }
        .category-신규 { background-color: #28a745; color: white; }
        .category-점검 { background-color: #ffc107; color: black; }
        .category-요금 { background-color: #dc3545; color: white; }
        .category-혜택 { background-color: #e83e8c; color: white; }
        .category-안내 { background-color: #6c757d; color: white; }
        .fixed-badge {
            background-color: #dc3545;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            margin-left: 5px;
        }
        .search-box {
            margin-bottom: 20px;
        }
		.title_n{
			font-weight: bold;
			font-size:20px;
		}
		
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="notice-container">
        <div class="notice-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>공지사항</h1>
                <!-- 관리자만 작성 버튼 표시 -->
                <c:choose>
                    <c:when test="${(sessionScope.admin != null && sessionScope.admin == 1) || (adminCheck != null && adminCheck == 1)}">
                        <a href="/notice/write" class="btn btn-primary btn-lg">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16" style="margin-right: 8px; vertical-align: middle;">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                            </svg>
                            공지사항 작성
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- 디버깅 정보 (개발 중에만 사용) -->
                        <!-- <small class="text-muted">관리자가 아닙니다. (admin: ${sessionScope.admin}, adminCheck: ${adminCheck})</small> -->
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="search-box">
                <form action="/notice" method="get" class="d-flex">
                    <input type="text" name="keyword" class="form-control me-2" 
                           placeholder="검색어를 입력하세요" value="${param.keyword}">
                    <button type="submit" class="btn btn-primary">검색</button>
                </form>
            </div>
        </div>

        <!-- 고정 공지사항 -->
        <c:if test="${not empty fixedNotices}">
            <h3 class="mb-3">📌 고정 공지사항</h3>
            <c:forEach var="notice" items="${fixedNotices}">
                <div class="notice-item" onclick="location.href='/notice/detail?noticeId=${notice.noticeId}'">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <span class="category-badge category-${notice.category}">${notice.category}</span>
<!--                            <span class="fixed-badge">고정</span>-->
                            <strong  class ="title_n">${notice.title}</strong>
<!--                            <p class="text-muted mb-0 mt-2">${notice.content}</p>-->
                        </div>
                        <div class="text-end">
                            <small class="text-muted">${notice.createdAt}</small>
                            <br>
                            <small class="text-muted">조회수: ${notice.viewCount}</small>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <!-- 일반 공지사항 -->
        <h3 class="mb-3 mt-4">📋 공지사항</h3>
        <c:choose>
            <c:when test="${not empty notices}">
                <c:forEach var="notice" items="${notices}">
                    <div class="notice-item" onclick="location.href='/notice/detail?noticeId=${notice.noticeId}'">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="flex-grow-1">
                                <span class="category-badge category-${notice.category}">${notice.category}</span>
                                <c:if test="${notice.isFixed == 1}">
<!--                                    <span class="fixed-badge">고정</span>-->
                                </c:if>
                            		<strong class ="title_n" >${notice.title}</strong>
<!--                                <p class="text-muted mb-0 mt-2">${notice.content}</p>-->
                            </div>
                            <div class="text-end">
                                <small class="text-muted">${notice.createdAt}</small>
                                <br>
                                <small class="text-muted">조회수: ${notice.viewCount}</small>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">
                    공지사항이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
	
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

