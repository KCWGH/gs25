<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>식품 창고</title>
<style type="text/css">
    /* 전체 페이지 스타일 */
    body {
        margin: 0;
        padding: 15px;
        background-color: #f8f9fa;
        text-align: center;
    }

    /* 제목 스타일 */
    h2 {
        color: #333;
        margin-bottom: 5px;
    }

    /* 기프트카드 리스트 스타일 */
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
        text-align: center;
    }

    th {
        background-color: #f1f1f1;
        color: #555;
    }

    td a {
        color: #007bff;
        text-decoration: none;
        font-size: 14px;
    }

    td a:hover {
        text-decoration: underline;
    }

    /* 상태별 텍스트 스타일 */
    .status-text {
        font-size: 13px;
        font-weight: bold;
        display: inline-block;
        padding: 3px 8px;
        border-radius: 5px;
    }

    /* 수정, 삭제, 발주 버튼 스타일 */
    .foodRow td a, .foodRow td .insert {
        background: #ddd;
        color: black;
        padding: 5px 10px;
        border-radius: 5px;
        text-decoration: none;
        margin: 5px;
    }

    .foodRow td a:hover, .foodRow td .insert:hover {
        background: #bbb;
    }

</style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<h1>음식 리스트</h1>
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <button id="insert" onclick='location.href="register"'>추가</button>
</sec:authorize>

<table id="foodTable">
    <thead>
        <tr>
            <th>음식ID</th>
            <th>음식 유형</th>
            <th>음식 이름</th>
            <th>음식 가격</th>
            <th>단백질 양</th>
            <th>지방 양</th>
            <th>탄수화물 양</th>
            <th>재고량</th>
            <th>상태</th>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <th colspan="3">기타</th>
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_OWNER')">
                <th colspan="1">기타</th>
                <th>발주</th>
            </sec:authorize>
        </tr>
    </thead>
    
    <tbody class="foodBody">
        <c:forEach var="foodListVO" items="${foodList}">
        <tr class="foodRow">
            <td class="foodId">${foodListVO.foodId}</td>
            <td>${foodListVO.foodType}</td>
            <td>${foodListVO.foodName}</td>
            <td>${foodListVO.foodPrice}</td>
            <td>${foodListVO.foodProtein}</td>
            <td>${foodListVO.foodFat}</td>
            <td>${foodListVO.foodCarb}</td>
            <td class="foodStock">${foodListVO.foodStock}</td>
            <c:choose>
                <c:when test="${foodListVO.isSelling == 0}"> <td class="isSelling">발주 중지</td> </c:when>
                <c:when test="${foodListVO.isSelling == 1}"> <td class="isSelling">발주 진행</td> </c:when>
                <c:when test="${foodListVO.isSelling == 2}"> <td class="isSelling">발주 준비</td> </c:when>
            </c:choose>
            <td><a href="../image/foodThumnail?foodId=${foodListVO.foodId}" target="_blank">썸네일 보기</a></td>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <td><a href="update?foodId=${foodListVO.foodId}">수정</a></td>
                <td class="delete"><a href="delete?foodId=${foodListVO.foodId}">삭제</a></td>
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_OWNER')">
                <td><input class="foodAmount" type="number"><button class="insert">발주</button></td>
            </sec:authorize>
        </tr>
        </c:forEach>
    </tbody>
</table>

<script type="text/javascript">
$(document).ready(function () {
    $(document).ajaxSend(function (e, xhr, opt) {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        xhr.setRequestHeader(header, token);
    });

    function loadOrderHistory() {
        $.ajax({
            type: 'GET',
            url: "../convenienceFood/getOrdersAllHistory",
            success: function (orderHistoryList) {
                var tableBody = $("#orderHistoryTable tbody");
                tableBody.empty();

                orderHistoryList.sort((a, b) => new Date(b.orderDateCreated) - new Date(a.orderDateCreated));

                var latestOrders = orderHistoryList.slice(0, 10);

                $.each(latestOrders, function (index, orderHistory) {
                    var orderDate = new Date(orderHistory.orderDateCreated);
                    var formattedDate = orderDate.getFullYear() + "-" +
                                        ('0' + (orderDate.getMonth() + 1)).slice(-2) + "-" +
                                        ('0' + orderDate.getDate()).slice(-2) + " " +
                                        ('0' + orderDate.getHours()).slice(-2) + ":" +
                                        ('0' + orderDate.getMinutes()).slice(-2) + ":" +
                                        ('0' + orderDate.getSeconds()).slice(-2);

                    var newRow = "<tr>";
                    newRow += "<td>" + orderHistory.foodId + "</td>";
                    newRow += "<td>" + orderHistory.orderAmount + "</td>";
                    newRow += "<td>" + orderHistory.ownerId + "</td>";
                    newRow += "<td>" + formattedDate + "</td>";
                    newRow += "</tr>";

                    tableBody.append(newRow);
                });
            },
            error: function () {
                alert("주문 내역을 불러오는 데 실패했습니다.");
            }
        });
    }

    loadOrderHistory();

    setInterval(loadOrderHistory, 600000);

    $(".foodRow").on('click', 'td .insert', function () {
        var foodAmount = $(this).prev().val();
        var foodId = $(this).parents().prevAll('.foodId').text();
        var foodStock = $(this).parents().prevAll('.foodStock').text();
        var isSelling = $(this).parents().prevAll('.isSelling').text();

        if (isSelling != '발주 진행') {
            alert("발주 진행 중인 상품이 아닙니다.");
            return;
        }

        if (foodStock - foodAmount >= 0) {
            $.ajax({
                type: 'GET',
                url: "../convenienceFood/register",  
                data: { foodId: foodId, foodAmount: foodAmount },
                success: function (result) {
                    if(result == 1){
                        loadOrderHistory();
                        alert("발주 처리에 성공했습니다.");
                    } else {
                        alert("발주 처리에 실패했습니다.");
                    }
                    location.reload();
                },
                error: function () {
                    alert("발주 처리에 실패했습니다.");
                }
            });
        } else {
            alert("재고량보다 발주량이 많습니다.");
        }
    });

    $(".foodRow").on('click','.delete',function(e){
        e.preventDefault();
        var foodId = $(this).prevAll().eq(10).html();
        var isSelling = $(this).prevAll('.isSelling').text();

        if(isSelling != '발주 중지'){
            alert("발주 중지 중인 상품이 아닙니다.");
            return;
        }

        $.ajax({
            type : 'post',
            contentType: "application/json",
            url : 'checkdelete',
            data : foodId,
            success : function(result){
                if(result == 'success'){
                    $.ajax({
                        type : 'post',
                        url : '../image/remove2',
                        data : {"foreignId" : foodId},
                        success : function(result){
                            location.href='../foodlist/delete?foodId=' + foodId;
                        },
                        error: function(){
                            alert("이미지 삭제에 실패했습니다.");
                        }
                    });
                }
            },
            error: function(){
                alert("삭제 확인에 실패했습니다.");
            }
        });
    });
});
</script>

<br>
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <h2>발주 이력</h2>
    <table id="orderHistoryTable">
        <thead>
            <tr>
                <th>음식ID</th>
                <th>주문 수량</th>
                <th>주문자 ID</th>
                <th>주문 일시</th>
            </tr>
        </thead>
        <tbody>
            <!-- 주문 내역이 여기에 추가됩니다. -->
        </tbody>
    </table>
</sec:authorize>

<%@ include file="../common/footer.jsp"%>
</body>
</html>
