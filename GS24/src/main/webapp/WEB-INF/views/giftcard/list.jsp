<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기프트카드 리스트</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script type="text/javascript">
    $(document).ready(function() {
        let currentPage = 1;

        $("input[name='choice']").change(function() {
            const selectedChoice = $("input[name='choice']:checked").val();
            fetchGiftCardList(selectedChoice, 1);
        });

        $(document).on("click", ".pagination a", function(event) {
            event.preventDefault();
            const pageNum = $(this).data("page");
            currentPage = pageNum;
            const selectedChoice = $("input[name='choice']:checked").val();
            fetchGiftCardList(selectedChoice, pageNum);
        });

        function formatDate(timestamp) {
            const date = new Date(timestamp);
            const year = date.getFullYear().toString().slice(-2);
            const month = ('0' + (date.getMonth() + 1)).slice(-2);
            const day = ('0' + date.getDate()).slice(-2);
            let hours = date.getHours();
            const minutes = ('0' + date.getMinutes()).slice(-2);
            const period = hours >= 12 ? '오후' : '오전';
            hours = hours % 12 || 12;
            return year + '.' + month + '.' + day + ' ' + period + ' ' + hours + ':' + minutes;
        }

        function fetchGiftCardList(choice, pageNum) {
            $.ajax({
                url: 'list-' + choice,
                type: 'GET',
                data: { pageNum: pageNum },
                dataType: 'json',
                success: function(response) {
                    let now = new Date();
                    let giftCardList = response.giftCardList;
                    let pageMaker = response.pageMaker;
                    let giftCardHtml = '';
                    
                    giftCardList.forEach(function(giftCardVO) {
                        let imagePath = '';
                        let statusText = '';
                        if (now < giftCardVO.giftCardExpiredDate && giftCardVO.isUsed == 0) {
                            imagePath = '../resources/images/giftCard/giftCard.png';
                            statusText = '사용 가능';
                        } else if (giftCardVO.isUsed == 1) {
                            imagePath = '../resources/images/giftCard/usedGiftCard.png';
                            statusText = '사용 불가(이미 사용된 기프트카드)';
                        } else {
                            imagePath = '../resources/images/giftCard/expiredGiftCard.png';
                            statusText = '사용 불가(만료된 기프트카드)';
                        }

                        giftCardHtml += '<div class="giftCard-item" style="display: flex; justify-content: center; align-items: center;">';
                        giftCardHtml += '<table style="width: 100%; text-align: center; vertical-align: middle;">';
                        giftCardHtml += '<tr>';
                        giftCardHtml += '<td style="width: 40%; text-align: center;"><a href="detail?giftCardId=' + giftCardVO.giftCardId + '"><img src="' + imagePath + '" alt="GiftCard" /></a></td>';
                        giftCardHtml += '<td style="width: 60%; vertical-align: middle; text-align: center;">';
                        giftCardHtml += '<strong>' + giftCardVO.giftCardName + '</strong><br>';
                        giftCardHtml += formatDate(giftCardVO.giftCardGrantDate) + '<br>~ <strong>' + formatDate(giftCardVO.giftCardExpiredDate) + '</strong><br>';
                        giftCardHtml += '<strong>' + statusText + '</strong></td>';
                        giftCardHtml += '</tr>';
                        giftCardHtml += '</table>';
                        giftCardHtml += '</div>';
                    });
                    
                    if (giftCardList.length == 0){
                    	giftCardHtml += '<br>쿠폰이 없습니다.';
                    }

                    $(".giftCard-list").html(giftCardHtml);
                    updatePagination(pageMaker, choice);
                },
                error: function(xhr, status, error) {
                    console.error('AJAX request failed: ' + error);
                }
            });
        }

        function updatePagination(pageMaker, choice) {
            let paginationHtml = '';
            if (pageMaker.isPrev) {
                paginationHtml += '<li><a href="#" data-page="' + (pageMaker.startNum - 1) + '">이전</a></li>';
            }
            for (let num = pageMaker.startNum; num <= pageMaker.endNum; num++) {
                const activeClass = num === currentPage ? 'active' : '';
                paginationHtml += '<li class="' + activeClass + '"><a href="#" data-page="' + num + '">' + num + '</a></li>';
            }
            if (pageMaker.isNext) {
                paginationHtml += '<li><a href="#" data-page="' + (pageMaker.endNum + 1) + '">다음</a></li>';
            }
            $(".pagination").html(paginationHtml);
        }

        fetchGiftCardList('available', 1);

        $('#btnGrantGiftCard').click(function() {
            window.location.href = 'grant';
        });
    });
</script>

<style>
    body {
        font-family: Arial, sans-serif;
    }

    .giftCard-list {
        margin-top: 20px;
    }

    .giftCard-item {
        border: 2px solid #ccc;
        border-radius: 5px;
        padding: 10px;
        margin-bottom: 10px;
        transition: border-color 0.3s;
        display: block;
    }

    .giftCard-item:hover {
        border-color: #ccc;
    }

    .giftCard-item table {
        width: 100%;
        border-spacing: 0;
        table-layout: fixed;
    }

    .giftCard-item table td {
        padding: 8px;
    }

    .giftCard-item img {
        max-width: 100%;
        height: auto;
        border-radius: 5px;
    }

    ul {
    	position: fixed; /* 화면 하단에 고정 */
    	bottom: 10px; /* 하단에서의 거리 설정 */
    	left: 50%; /* 화면 가로 중앙 정렬 */
    	transform: translateX(-50%); /* 중앙 정렬 보정 */
    	z-index: 100; /* 다른 요소보다 위에 표시 */
        list-style-type: none;
        padding: 0;
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 20px;
    }

    ul li {
        display: inline-block;
        padding: 5px 10px;
        cursor: pointer;
    }

    ul li.active {
        font-weight: bold;
        color: #007bff;
    }

    ul li.disabled {
        color: #ccc;
        cursor: not-allowed;
    }

    ul li a {
        text-decoration: none;
        color: inherit;
    }

    ul li a:hover {
        color: inherit;
    }

    
</style>
</head>
<body>

    <h2>${memberVO.memberId}님의 기프트카드함</h2>
    <p>만료일 이후 일주일이 경과한 기프트카드는 자동 삭제됩니다.</p>

    <label><input type="radio" name="choice" value="available" checked>사용 가능</label>
    <label><input type="radio" name="choice" value="all">전체</label>
    <label><input type="radio" name="choice" value="expired">만료됨</label>
    <label><input type="radio" name="choice" value="used">사용됨</label>

    <div class="giftCard-list"></div>

    <div class="fixed-buttons">
        <c:if test="${memberVO.memberRole == 2}"> 
            <button id="btnGrantGiftCard">개별 기프트카드 제공</button> 
        </c:if><br>
        <a href="../member/mypage"><button>마이페이지</button></a>
    </div>

    <ul class="pagination"></ul>

</body>
</html>
