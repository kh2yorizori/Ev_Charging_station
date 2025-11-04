<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 전체 회원 목록 - 요리조리</title>
    <!-- 부트스트랩 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 부트스트랩 아이콘 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <style>
        /* 간단한 추가 스타일 */
        body {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-12">
            
            <h2 class="mb-4">
                <i class="bi bi-people-fill" style="margin-right: 10px;"></i> 전체 회원 목록
            </h2>

            <div class="card shadow-sm">
                <div class="card-body">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>회원 ID</th>
                                <th>닉네임</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>전화번호</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                           <c:forEach var="user" items="${userData}">
                                <tr>
                                    <td>${user.memberId}</td> 
                                    <td>${user.nickname}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phoneNumber}</td>
                                    <td>${user.joinDate}</td> <!-- 생년월일보다 가입일이 더 유용할 수 있습니다. -->
                                    <td>
                                        <!-- ✅ [수정] 모달을 띄우는 버튼 -->
                                        <button type="button" class="btn btn-sm btn-danger delete-btn" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#deleteModal"
                                                data-bs-id="${user.memberId}"
                                                data-bs-name="${user.nickname}">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                           </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- 
  ✅ [추가] 회원 삭제 확인 모달
  confirm()을 대체하며, JavaScript로 대상 ID를 전달받습니다.
-->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel">회원 삭제 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- JavaScript에 의해 내용이 채워집니다 -->
                <p id="deleteModalText">정말 삭제하시겠습니까?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <!-- 삭제를 실행할 폼 -->
                <form action="delete2" method="post" style="margin:0;">
                    <input type="hidden" id="deleteMemberId" name="memberId" value="" />
                    <button type="submit" class="btn btn-danger">삭제 실행</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- 부트스트랩 JS (모달 작동을 위해 필수) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- ✅ [추가] 모달에 삭제할 ID를 전달하는 스크립트 -->
<script>
