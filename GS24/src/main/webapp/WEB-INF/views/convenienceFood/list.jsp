<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>${convenienceId}호점</title>
<style>
	body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
    }
    h1 {
        text-align: center;
        margin-top: 20px;
    }
   .food_box {
      display: flex;
      flex-wrap: wrap;
      justify-content: center; /* Center horizontally */
      align-items: flex-start; /* Align items to the top */
      gap: 20px; /* Space between items */
      padding: 20px;
      list-style-type: none; /* Remove bullets from list */
      margin: 0; /* Remove default margin from list */
   }

   /* Style individual list items */
   .food_box .List {
      width: 250px; /* Set a fixed width for each item */
      text-align: center; /* Center text inside each item */
      border: 1px solid #ddd; /* Add a border around each item */
      padding: 10px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      background-color: #fff;
      transition: box-shadow 0.3s ease-in-out;
   }

   .image-item img {
      width: 100%; /* Make the image fill the container */
      height: auto;
      border-radius: 4px;
      cursor: pointer;
   }

   .button-container button {
      margin-top: 10px;
      padding: 10px 20px;
      border-radius: 4px;
      border: none;
      background-color: #ddd;
      color: black;
      cursor: pointer;
      font-size: 14px;
   }

   .button-container button:hover {
      background-color: #bbb;
   }
</style>
</head>
<body>
<c:if test="${not empty message}">
        <script type="text/javascript">
            alert("${message}");
        </script>
    </c:if>
    <%@ include file="../common/header.jsp" %>
    
   <h1>${convenienceId}호점 식품 리스트</h1>
   <!-- 
      <input id="bottomPrice" type="text" value="${pageMaker.pagination.bottomPrice }">원 ~<input id="topPrice" type="text" value="${pageMaker.pagination.topPrice }">원 <button id="priceSearch">검색</button><br>
   <input class="searchFoodName" type="text" placeholder="식품 이름 검색" value="${pageMaker.pagination.keyword }">
   <button class="search">검색</button>
   <ul class="searchList">
      <li>전체</li>
      <li>최신등록순</li>
      <li>낮은가격순</li>
      <li>높은가격순</li>
   </ul>
    -->

   <ul class="food_box">
    <c:forEach var="FoodVO" items="${FoodList}">
    <sec:authorize access="hasRole('ROLE_MEMBER') or !isAuthenticated()">
    <c:if test="${FoodVO.showStatus == 1 }">
        <li class="List">
            <input type="hidden" class="foodId" value="${FoodVO.foodId }">
            <div class="image-item">
                <input type="hidden" class="path" value="${FoodVO.imgPath }">
                <a onclick="location.href='detail?foodId=${FoodVO.foodId}&convenienceId=${FoodVO.convenienceId }'">
                    <img src="../image/foodThumnail?foodId=${FoodVO.foodId }">
                </a>
            </div>
            <p>${FoodVO.foodType}</p>
            <p>${FoodVO.foodName}</p>
            <p>재고 ${FoodVO.foodAmount}개 / ${FoodVO.foodPrice}원</p>
            <p>평점 ${FoodVO.foodAvgRating }점 / 리뷰 ${FoodVO.foodReviewCnt }개</p>
                <div class="button-container">
                    <button onclick='location.href="../preorder/create?foodId=${FoodVO.foodId }&convenienceId=${FoodVO.convenienceId }"'>예약하기</button>
                    <c:choose>
                        <c:when test="${isAddedMap[FoodVO.foodId] == 1}">
                            <button class="deleteFavorites" data-foodId="${FoodVO.foodId}"
                                data-convenienceId="${FoodVO.convenienceId }">찜 해제하기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="addFavorites" data-foodId="${FoodVO.foodId}"
                                data-convenienceId="${FoodVO.convenienceId }">찜하기</button>
                        </c:otherwise>
                    </c:choose>
                </div>
        </li>
    </c:if>
    </sec:authorize>
   	<sec:authorize access="hasRole('ROLE_OWNER')">
   		<li class="List">
            <input type="hidden" class="foodId" value="${FoodVO.foodId }">
            <div class="image-item">
                <input type="hidden" class="path" value="${FoodVO.imgPath }">
                <a onclick="location.href='detail?foodId=${FoodVO.foodId}&convenienceId=${FoodVO.convenienceId }'">
                    <img src="../image/foodThumnail?foodId=${FoodVO.foodId }">
                </a>
            </div>
            <p>${FoodVO.foodType}</p>
            <p>${FoodVO.foodName}</p>
            <p>재고 ${FoodVO.foodAmount}개 / ${FoodVO.foodPrice}원</p>
            <p>평점 ${FoodVO.foodAvgRating }점 / 리뷰 ${FoodVO.foodReviewCnt }개</p>
            <div class="button-container">
            	<c:if test="${FoodVO.showStatus == 1}">
	   				<button class="HideFood">식품 숨기기</button>
            	</c:if>
            	<c:if test="${FoodVO.showStatus == 0 }">
            		<button class="HideFood">식품 보이기</button>
            	</c:if>
            </div>
        </li>
    </sec:authorize>
    </c:forEach>
</ul>
   <!-- 실제 controller로 데이터를 전송해주는 form -->
   <form id="searchForm" action="list" method="GET">
      <input type="hidden" name="pageNum">
      <input type="hidden" name="pageSize">
      <input type="hidden" name="type">
      <input type="hidden" name="keyword">
      <input type="hidden" name="sortType">
      <input type="hidden" name="bottomPrice">
      <input type="hidden" name="topPrice">
   </form>
   
   <form id="listForm" action="list" method="GET">
      <input type="hidden" name="pageNum">
      <input type="hidden" name="pageSize">
      <input type="hidden" name="type">
      <input type="hidden" name="keyword">
      <input type="hidden" name="sortType">
      <input type="hidden" name="bottomPrice">
      <input type="hidden" name="topPrice">
   </form>
   
   <!-- 
   <ul id="paginationList">
         <c:if test="${pageMaker.isPrev() }">
            <li class="pagination_button"><a href="${pageMaker.startNum - 1}">이전</a></li>
         </c:if>
         <c:forEach begin="${pageMaker.startNum }"
            end="${pageMaker.endNum }" var="num">
            <li class="pagination_button"><a href="${num }">●</a></li>
         </c:forEach>
         <c:if test="${pageMaker.isNext() }">
            <li class="pagination_button"><a href="${pageMaker.endNum + 1}">다음</a></li>
         </c:if>
   </ul>
    -->
</body>

<script type="text/javascript">
   $(document).ready(function(){
	   $(document).ajaxSend(function(e, xhr, opt){
	        var token = $("meta[name='_csrf']").attr("content");
	        var header = $("meta[name='_csrf_header']").attr("content");
	        
	        xhr.setRequestHeader(header, token);
	     });
	   
	   $(document).on('click', '.addFavorites', function(event) {
		    let memberId = '${memberId}';
		    let foodId = $(this).data('foodid');
		    let convenienceId = $(this).data('convenienceid');

		    if (memberId === '') {
		        alert('찜하시려면 로그인해주세요');
		        return;
		    }

		    $.ajax({
		        url: '../favorites/add',
		        type: 'POST',
		        data: {
		            memberId: memberId,
		            foodId: foodId,
		            convenienceId: convenienceId
		        },
		        success: function(response) {
		            alert("찜 목록에 추가되었습니다");

		            let button = $("button[data-foodid='" + foodId + "']");
		            
		            button.removeClass('addFavorites')
		                  .addClass('deleteFavorites')
		                  .text('찜 해제하기')
		        },
		        error: function(xhr, status, error) {
		            let responseText = xhr.responseText;
		            if (responseText == 0) {
		                alert("찜 목록 추가에 실패했습니다");
		            }
		        }
		    });
		});

		
	   $(document).on('click', '.deleteFavorites', function(event) {
		    let memberId = '${memberId}';
		    let foodId = $(this).data('foodid');
		    let convenienceId = $(this).data('convenienceid');

		    $.ajax({
		        url: '../favorites/delete',
		        type: 'POST',
		        data: {
		            memberId: memberId,
		            foodId: foodId,
		            convenienceId: convenienceId
		        },
		        success: function(response) {
		            alert("찜 목록에서 삭제되었습니다");

		            let button = $("button[data-foodid='" + foodId + "']");

		            button.removeClass('deleteFavorites')
		                  .addClass('addFavorites')
		                  .text('찜하기')
		        },
		        error: function(xhr, status, error) {
		            let responseText = xhr.responseText;
		            if (responseText == 0) {
		                alert("찜 목록 삭제에 실패했습니다");
		            }
		        }
		    });
		});


      
      $("#searchForm button").on("click", function(e){
         var searchForm = $("#searchForm");
         e.preventDefault(); // a 태그 이벤트 방지
         
         var keywordVal = searchForm.find("input[name='keyword']").val();
         console.log(keywordVal);
         if(keywordVal == '') {
            alert('검색 내용을 입력하세요.');
            return;
         }
         
         var pageNum = 1; // 검색 후 1페이지로 고정
         // 현재 페이지 사이즈값 저장
         var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
          
         // 페이지 번호를 input name='pageNum' 값으로 적용
         searchForm.find("input[name='pageNum']").val(pageNum);
         // 선택된 옵션 값을 input name='pageSize' 값으로 적용
         searchForm.find("input[name='pageSize']").val(pageSize);
         searchForm.submit(); // form 전송
      }); // end on()
      
      $(".pagination_button a").on("click", function(e){
         var listForm = $("#listForm"); // form 객체 참조
         e.preventDefault(); // a 태그 이벤트 방지
      
         var pageNum = $(this).attr("href"); // a태그의 href 값 저장
         // 현재 페이지 사이즈값 저장
         var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
         var type = "<c:out value='${pageMaker.pagination.type }' />";
         var keyword = "<c:out value='${pageMaker.pagination.keyword }' />";
         var sortType = "<c:out value='${pageMaker.pagination.sortType}' />";
         var bottomPrice = "<c:out value='${pageMaker.pagination.bottomPrice}' />";
         var topPrice = "<c:out value='${pageMaker.pagination.topPrice}' />";
          
         // 페이지 번호를 input name='pageNum' 값으로 적용
         listForm.find("input[name='pageNum']").val(pageNum);
         // 선택된 옵션 값을 input name='pageSize' 값으로 적용
         listForm.find("input[name='pageSize']").val(pageSize);
         // type 값을 적용
         listForm.find("input[name='type']").val(type);
         // keyword 값을 적용
         listForm.find("input[name='keyword']").val(keyword);
         listForm.find("input[name='sortType']").val(sortType);
         listForm.find("input[name='bottomPrice']").val(bottomPrice);
         listForm.find("input[name='topPrice']").val(topPrice);
         listForm.submit(); // form 전송
      }); // end on()
      
      $(".searchList").on("click", "li", function(e){
         let optionType = $(this).text();
         console.log("optionType : " + optionType);
         let searchForm = $("#searchForm");
         if(optionType=="전체"){
            searchForm.find("input[name='sortType']").val("All");
            var pageNum = 1; // 검색 후 1페이지로 고정
            // 현재 페이지 사이즈값 저장
            var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
            // 페이지 번호를 input name='pageNum' 값으로 적용
            searchForm.find("input[name='pageNum']").val(pageNum);
            // 선택된 옵션 값을 input name='pageSize' 값으로 적용
            searchForm.find("input[name='pageSize']").val(pageSize);
            searchForm.find("input[name='type']").val("");
            searchForm.find("input[name='keyword']").val("");
            searchForm.submit(); // form 전송
            return;
         } else if(optionType == "최신등록순"){
            searchForm.find("input[name='sortType']").val("recentRegist");
         } else if(optionType == "낮은가격순"){
            searchForm.find("input[name='sortType']").val("rowPrice");
         } else if(optionType == "높은가격순"){
            searchForm.find("input[name='sortType']").val("topPrice");
         }
         
         console.log(searchForm.find("input[name='sortType']").val());
         
         var pageNum = 1; // 검색 후 1페이지로 고정
         // 현재 페이지 사이즈값 저장
         var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
         var type = "<c:out value='${pageMaker.pagination.type }' />";
         var keyword = "<c:out value='${pageMaker.pagination.keyword }' />";
         var bottomPrice = "<c:out value='${pageMaker.pagination.bottomPrice }' />";
         var topPrice = "<c:out value='${pageMaker.pagination.topPrice }' />";
          
         // 페이지 번호를 input name='pageNum' 값으로 적용
         searchForm.find("input[name='pageNum']").val(pageNum);
         // 선택된 옵션 값을 input name='pageSize' 값으로 적용
         searchForm.find("input[name='pageSize']").val(pageSize);
         searchForm.find("input[name='type']").val(type);
         searchForm.find("input[name='keyword']").val(keyword);
         searchForm.find("input[name='bottomPrice']").val(bottomPrice);
         searchForm.find("input[name='topPrice']").val(topPrice);
         searchForm.submit(); // form 전송
      });
      
      $(".search").click(function(e){
         e.preventDefault(); // a 태그 이벤트 방지
         
         let searchFoodName = $(".searchFoodName").val();
         let searchForm = $("#searchForm");
         console.log("검색어 : " + searchFoodName);
         
         if(searchFoodName == ""){
            alert("검색할 단어를 입력해 주십시오.");
            return;
         }
         
         searchForm.find("input[name='type']").val("name");
         searchForm.find("input[name='keyword']").val(searchFoodName);
         
         
         var keywordVal = searchForm.find("input[name='keyword']").val();
         console.log(keywordVal);
         
         var pageNum = 1; // 검색 후 1페이지로 고정
         // 현재 페이지 사이즈값 저장
         var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
         var sortType = "<c:out value='${pageMaker.pagination.sortType }' />";
          
         // 페이지 번호를 input name='pageNum' 값으로 적용
         searchForm.find("input[name='pageNum']").val(pageNum);
         // 선택된 옵션 값을 input name='pageSize' 값으로 적용
         searchForm.find("input[name='pageSize']").val(pageSize);
         searchForm.find("input[name='sortType']").val(sortType);

         searchForm.submit(); // form 전송
      });
      
      $("#priceSearch").click(function(e){
         e.preventDefault(); // a 태그 이벤트 방지
         
         let searchForm = $("#searchForm");
         
         searchForm.find("input[name='type']").val("price");
         
         var bottomPrice = $("#bottomPrice").val();
         var topPrice = $("#topPrice").val();
         
         if(bottomPrice == ''){
        	 //bottomPrice가 입력되지 않은 경우
        	 bottomPrice = 0;
         } else if(topPrice == ''){
        	 //topPrice가 입력되지 않은 경우 쿼리문에서 FOOD테이블에서 FOOD_PRICE가 가장 큰 값으로 검색
        	 
         } else if(bottomPrice > topPrice){
        	 //bottomPrice 가 topPrice보다 클 경우
        	 var temp = topPrice;
        	 topPrice = bottomPrice;
        	 bottomPrice = temp;
         }
         
         searchForm.find("input[name='bottomPrice']").val(bottomPrice);
         searchForm.find("input[name='topPrice']").val(topPrice);
         
         var pageNum = 1; // 검색 후 1페이지로 고정
         // 현재 페이지 사이즈값 저장
         var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
         var sortType = "<c:out value='${pageMaker.pagination.sortType }' />";
          
         // 페이지 번호를 input name='pageNum' 값으로 적용
         searchForm.find("input[name='pageNum']").val(pageNum);
         // 선택된 옵션 값을 input name='pageSize' 값으로 적용
         searchForm.find("input[name='pageSize']").val(pageSize);
         searchForm.find("input[name='sortType']").val(sortType);
         searchForm.submit(); // form 전송
      });
      
      $(".food_box").on('click','.List .HideFood',function(){
    	  let foodId = $(this).parent().siblings().eq(0).val();
    	  console.log(foodId);
    	  let convenienceId = ${param.convenienceId};
    	  console.log(convenienceId);
    	  
    	  location.href="updateShowStatus?foodId=" + foodId + "&convenienceId=" + convenienceId;
      });
   });
</script>
<%@ include file="../common/footer.jsp"%>
</html>
