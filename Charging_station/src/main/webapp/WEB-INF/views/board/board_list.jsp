<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자유게시판</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

    <style>
        body {
            background-color: #f5f5f5;
        }
        .board-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }
        .board-header {
            margin-bottom: 30px;
        }
        .board-item {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s;
        }
        .board-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        .search-box {
            margin-bottom: 20px;
        }
        .board-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .board-meta {
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="board-container">
        <div class="board-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>자유게시판</h1>
                <!-- 로그인한 사용자만 작성 버튼 표시 -->
                <c:if test="${not empty sessionScope.id}">
                    <a href="${pageContext.request.contextPath}/board/write" class="btn btn-primary btn-lg">
                        <i class="fa fa-pencil"></i> 글쓰기
                    </a>
                </c:if>
            </div>
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/board" method="get" class="d-flex">
                    <input type="text" name="keyword" class="form-control me-2" 
                           placeholder="검색어를 입력하세요" value="${param.keyword}">
                    <button type="submit" class="btn btn-primary">검색</button>
                </form>
            </div>
        </div>

        <!-- 게시글 목록 -->
        <c:choose>
            <c:when test="${not empty boards}">
                <c:forEach var="board" items="${boards}">
                    <div class="board-item" onclick="location.href='${pageContext.request.contextPath}/board/detail?boardId=${board.boardId}'">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="flex-grow-1">
                                <div class="board-title">${board.title}</div>
                                <div class="board-meta">
                                    작성자: ${board.nickname} | 작성일: ${board.createdAt} | 조회수: ${board.viewCount}
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">
                    게시글이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
	
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

