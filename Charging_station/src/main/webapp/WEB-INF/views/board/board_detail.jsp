<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .board-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 20px;
        }
        .board-detail {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .content-area {
            min-height: 200px;
            padding: 20px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
            margin: 20px 0;
            white-space: pre-wrap;
        }
        .comment-area {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #eee;
        }
        .comment-item {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 5px;
        }
        .comment-item.reply {
            margin-left: 40px;
            background: #e9ecef;
        }
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .comment-meta {
            font-size: 0.85rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>    
    <div class="board-container">
        <div class="board-detail">
            <h2 class="mb-3">${board.title}</h2>
            
            <div class="text-muted mb-4">
                <small>작성자: ${board.nickname}</small> | 
                <small>작성일: ${board.createdAt}</small> | 
                <small>조회수: ${board.viewCount}</small>
                <c:if test="${board.updatedAt != board.createdAt}">
                    | <small>수정일: ${board.updatedAt}</small>
                </c:if>
            </div>
            
            <div class="content-area">
${board.content}
            </div>
            
            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/board" class="btn btn-secondary">목록으로</a>
                
                <!-- 작성자만 수정/삭제 버튼 표시 -->
                <c:if test="${memberId == board.memberId}">
                    <div>
                        <a href="${pageContext.request.contextPath}/board/modify?boardId=${board.boardId}" class="btn btn-warning">수정</a>
                        <button onclick="deleteBoard(${board.boardId})" class="btn btn-danger">삭제</button>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 댓글 영역 -->
        <div class="comment-area">
            <h4>댓글 (${comments.size()})</h4>
            
            <!-- 댓글 목록 -->
            <c:forEach var="comment" items="${comments}">
                <div class="comment-item <c:if test="${comment.depth == 1}">reply</c:if>">
                    <div class="comment-header">
                        <div>
                            <strong>${comment.nickname}</strong>
                            <span class="comment-meta">${comment.createdAt}</span>
                        </div>
                        <c:if test="${memberId == comment.memberId}">
                            <div>
                                <button onclick="editComment(${comment.commentId}, '${comment.content}', ${board.boardId})" class="btn btn-sm btn-outline-warning">수정</button>
                                <button onclick="deleteComment(${comment.commentId}, ${board.boardId})" class="btn btn-sm btn-outline-danger">삭제</button>
                            </div>
                        </c:if>
                    </div>
                    <div class="comment-content" id="comment-content-${comment.commentId}">
                        ${comment.content}
                    </div>
                    <c:if test="${comment.depth == 0 && not empty memberId}">
                        <button onclick="showReplyForm(${comment.commentId})" class="btn btn-sm btn-outline-primary mt-2">답글</button>
                    </c:if>
                </div>
                
                <!-- 대댓글 작성 폼 (숨김) -->
                <c:if test="${comment.depth == 0 && not empty memberId}">
                    <div id="reply-form-${comment.commentId}" style="display: none; margin-left: 40px; margin-bottom: 10px;">
                        <form action="${pageContext.request.contextPath}/board/comment/write" method="post" class="d-flex">
                            <input type="hidden" name="board_id" value="${board.boardId}">
                            <input type="hidden" name="parent_comment_id" value="${comment.commentId}">
                            <input type="text" name="content" class="form-control me-2" placeholder="답글을 입력하세요" required>
                            <button type="submit" class="btn btn-primary btn-sm">등록</button>
                            <button type="button" onclick="hideReplyForm(${comment.commentId})" class="btn btn-secondary btn-sm ms-2">취소</button>
                        </form>
                    </div>
                </c:if>
            </c:forEach>
            
            <!-- 댓글 작성 폼 -->
            <c:if test="${not empty memberId}">
                <div class="mt-4">
                    <h5>댓글 작성</h5>
                    <form action="${pageContext.request.contextPath}/board/comment/write" method="post">
                        <input type="hidden" name="board_id" value="${board.boardId}">
                        <div class="d-flex">
                            <textarea name="content" class="form-control me-2" rows="3" placeholder="댓글을 입력하세요" required></textarea>
                            <button type="submit" class="btn btn-primary">등록</button>
                        </div>
                    </form>
                </div>
            </c:if>
            <c:if test="${empty memberId}">
                <div class="alert alert-info mt-3">
                    댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login">로그인</a>이 필요합니다.
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteBoard(boardId) {
            if (confirm('정말 삭제하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/board/delete';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'boardId';
                input.value = boardId;
                form.appendChild(input);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        function showReplyForm(commentId) {
            document.getElementById('reply-form-' + commentId).style.display = 'block';
        }

        function hideReplyForm(commentId) {
            document.getElementById('reply-form-' + commentId).style.display = 'none';
        }

        function editComment(commentId, content, boardId) {
            var contentDiv = document.getElementById('comment-content-' + commentId);
            var editForm = '<form action="${pageContext.request.contextPath}/board/comment/modify" method="post" class="d-flex mt-2">' +
                '<input type="hidden" name="comment_id" value="' + commentId + '">' +
                '<input type="hidden" name="board_id" value="' + boardId + '">' +
                '<input type="text" name="content" class="form-control me-2" value="' + content.replace(/"/g, '&quot;') + '" required>' +
                '<button type="submit" class="btn btn-primary btn-sm">수정</button>' +
                '<button type="button" onclick="location.reload()" class="btn btn-secondary btn-sm ms-2">취소</button>' +
                '</form>';
            contentDiv.innerHTML = editForm;
        }

        function deleteComment(commentId, boardId) {
            if (confirm('정말 삭제하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/board/comment/delete';
                
                var input1 = document.createElement('input');
                input1.type = 'hidden';
                input1.name = 'commentId';
                input1.value = commentId;
                form.appendChild(input1);
                
                var input2 = document.createElement('input');
                input2.type = 'hidden';
                input2.name = 'boardId';
                input2.value = boardId;
                form.appendChild(input2);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

