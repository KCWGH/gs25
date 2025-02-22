<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <title>공지사항</title>


</head>
<style>
/* 전체 페이지 스타일 */
body {
	margin: 0;
	padding: 15px;
	background-color: #f8f9fa;
	text-align: center;
}

/* 제목 스타일 */
h1, h2 {
	color: #333;
}

/* 테이블 스타일 */
table {
	width: 100%;
	margin-top: 20px;
	border-collapse: collapse;
	text-align: center;
}

th, td {
	border: 1px solid #ccc;
	padding: 10px;
	font-size: 14px;
}

th {
	background-color: #f1f1f1;
	color: #555;
}

/* 버튼 스타일 */
button, input[type="button"] {
	background: #ddd;
	color: black;
	padding: 5px 10px;
	border-radius: 5px;
	border: none;
	cursor: pointer;
}

button:hover, input[type="button"]:hover {
	background: #bbb;
}

/* 검색 폼 스타일 */
#searchForm {
	margin-top: 10px;
}

/* 페이징 스타일 */
.pagination_button {
	display: inline-block;
	margin: 5px;
}

.pagination_button a {
	text-decoration: none;
	padding: 5px 10px;
	background: #ddd;
	border-radius: 5px;
}

.pagination_button a:hover {
	background: #bbb;
}
/* 글 작성 버튼 컨테이너 */
.button-container {
	text-align: right;
	margin-bottom: 10px;
}
</style>
<body>
<%@ include file="../common/header.jsp" %>

    <h1>공지사항</h1>
    <h2>GS24의 새로운 소식을 전해 드립니다.</h2>

    <!-- 글 작성 버튼 (관리자만 보이도록) -->
	<sec:authorize access="hasRole('ROLE_ADMIN')">
    	<div class="button-container">
        	<a href="register"><input type="button" value="글 작성"></a>
    	</div>
	</sec:authorize>

    <!-- 공지사항 목록 -->
    <table>
        <thead>
            <tr>
                <th style="width: 60px">번호</th>
                <th style="width: 700px">제목</th>
                <th style="width: 100px">작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="NoticeVO" items="${noticeList}">
                <c:choose>
                    <c:when test="${NoticeVO.noticeType == 0}">
                        <tr>
                            <td>${NoticeVO.noticeId}</td>
                            <td><a href="detail?noticeId=${NoticeVO.noticeId}">${NoticeVO.noticeTitle}</a></td>
                            <fmt:formatDate value="${NoticeVO.noticeDateCreated}" pattern="yyyy-MM-dd HH:mm" var="noticeDateCreated" />
                            <td>${noticeDateCreated}</td>
                        </tr>
                    </c:when>
                    <c:when test="${NoticeVO.noticeType == 1}">
                        <sec:authorize access="hasRole('ROLE_OWNER') or hasRole('ROLE_ADMIN')">
                            <tr>
                                <td>${NoticeVO.noticeId}</td>
                                <td><a href="detail?noticeId=${NoticeVO.noticeId}">${NoticeVO.noticeTitle}</a></td>
                                <fmt:formatDate value="${NoticeVO.noticeDateCreated}" pattern="yyyy-MM-dd HH:mm" var="noticeDateCreated" />
                                <td>${noticeDateCreated}</td>
                            </tr>
                        </sec:authorize>
                    </c:when>
                </c:choose>
            </c:forEach>
        </tbody>
    </table>
 <!-- 검색 폼 -->
    <form id="searchForm" action="list" method="get">
        <input type="hidden" name="pageNum">
        <input type="hidden" name="pageSize">
        <select name="type">
            <option value="title">제목</option>
            <option value="content">내용</option>
        </select>
        <input type="text" name="keyword">
        <button>검색</button>
    </form>

    <!-- 페이징 처리 -->
    <ul>
        <c:if test="${pageMaker.isPrev()}">
            <li class="pagination_button"><a href="${pageMaker.startNum - 1}">이전</a></li>
        </c:if>
        <c:forEach begin="${pageMaker.startNum}" end="${pageMaker.endNum}" var="num">
            <li class="pagination_button"><a href="${num}">${num}</a></li>
        </c:forEach>
        <c:if test="${pageMaker.isNext()}">
            <li class="pagination_button"><a href="${pageMaker.endNum + 1}">다음</a></li>
        </c:if>
    </ul>

    <script>
        $(document).ready(function() {
            // 페이징 버튼 클릭 시 폼 전송
            $(".pagination_button a").on("click", function(e) {
                e.preventDefault();
                var listForm = $("#listForm");
                var pageNum = $(this).attr("href");
                listForm.find("input[name='pageNum']").val(pageNum);
                listForm.submit();
            });

            // 검색 폼 제출
            $("#searchForm button").on("click", function(e) {
                e.preventDefault();
                var searchForm = $("#searchForm");
                var keywordVal = searchForm.find("input[name='keyword']").val();
                if (keywordVal.trim() === '') {
                    alert('검색 내용을 입력하세요.');
                    return;
                }
                searchForm.find("input[name='pageNum']").val(1);
                searchForm.submit();
            });
        });
    </script>

<%@ include file="../common/footer.jsp"%>
</body>
</html>
