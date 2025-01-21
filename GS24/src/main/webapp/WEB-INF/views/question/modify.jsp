<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- css 파일 불러오기 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/questionAttach.css">
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<title>${questionDTO.questionTitle }</title>
</head>
<body>
	<h2>글 수정 페이지</h2>
	<form id="modifyForm" action="modify" method="POST">
		<div>
			<p>번호 : <input type="text" name="questionId" value="${questionDTO.questionId }" readonly></p>	
		</div>
		<div>
			<p>제목 : <input type="text" name="questionTitle" placeholder="제목 입력" maxlength="20" value="${questionDTO.questionTitle }" required></p>	
				
		</div>
		<div>
            <p>식품 : <input type="text" name="foodName" placeholder="식품 입력" maxlength="20" value="${questionDTO.foodName }" required></p>
            
        </div>
		<div>
			<p>작성자 : ${questionDTO.memberId} </p>	
			<input type="hidden" name="memberId" value="${questionDTO.memberId}">
		</div>
		<div>
			<p>내용 : </p>
			<textarea rows="20" cols="120" name="questionContent" placeholder="내용 입력" maxlength="300" required>${questionDTO.questionContent }</textarea>
		</div>
		<!-- 기존 첨부 파일 리스트 데이터 구성 -->
		<c:forEach var="questionAttachDTO" items="${questionDTO.questionAttachList}" varStatus="status">
    	<input type="hidden" class="input-questionAttach-list" name="questionAttachList[${status.index }].questionAttachPath" value="${questionAttachDTO.questionAttachPath }">
    	<input type="hidden" class="input-questionAttach-list" name="questionAttachList[${status.index }].questionAttachRealName" value="${questionAttachDTO.questionAttachRealName }">
    	<input type="hidden" class="input-questionAttach-list" name="questionAttachList[${status.index }].questionAttachChgName" value="${questionAttachDTO.questionAttachChgName }">
    	<input type="hidden" class="input-questionAttach-list" name="questionAttachList[${status.index }].questionAttachExtension" value="${questionAttachDTO.questionAttachExtension }">
		</c:forEach>

	</form>
	
	<hr>
	
	<button id="change-upload">파일 변경</button>
	
	<!-- 첨부 파일 영역 -->
	<div class="questionAttach-upload">
		<div class="questionAttach-view">
			<h2>첨부 파일 리스트</h2>
			<div class="questionAttach-list">
			<c:forEach var="questionAttachDTO" items="${questionDTO.questionAttachList}">
		 		<c:if test="${not (questionAttachDTO.questionAttachExtension eq 'jpg' or 
			    			  questionAttachDTO.questionAttachExtension eq 'jpeg' or 
			    			  questionAttachDTO.questionAttachExtension eq 'png' or 
			    			  questionAttachDTO.questionAttachExtension eq 'gif')}">
			    	<div class="questionAttach_item">
			    	<p><a href="../questionAttach/download?questionAttachId=${questionAttachDTO.questionAttachId }">
			    	${questionAttachDTO.questionAttachRealName }.${questionAttachDTO.questionAttachExtension }</a></p>
			    	</div>
			    </c:if>
			</c:forEach>		
			</div>
		</div>
		<div class="questionAttach-modify" style="display : none;">
			<h2>첨부 파일 업로드</h2>
			<p>* 첨부 파일은 최대 3개까지 가능합니다.</p>
			<p>* 최대 용량은 10MB 입니다.</p>
			<input type="file" id="questionAttachInput" name="files" multiple="multiple"><br>
			<h2>선택한 첨부 파일 정보 :</h2>
			<div class="questionAttach-list"></div>
		</div>
	</div>
	
	<div class="questionAttachDTOFile-list">
	</div>
	
	<button id="modifyQuestion">등록</button>
	
	<script	src="${pageContext.request.contextPath }/resources/js/questionAttach.js"></script>
	
	<script>
	
	$(document).ready(function(){
    	var questionAttachDTO;
	    // 파일 변경 버튼 클릭 시
	    $('#change-upload').click(function(){
	    	if(!confirm('기존에 업로드 파일들은 삭제됩니다. 계속 하시겠습니까?')){
	    		return;
	    	}
	        $('.questionAttach-modify').show();
	        $('.questionAttach-view').hide();
	        $('.input-questionAttach-list').remove(); // input-questionAttach-list 삭제
	    });
	
	 // modifyForm 데이터 전송
	    $('#modifyQuestion').click(function() {

	        event.preventDefault();
	        // form 객체 참조
	        var modifyForm = $('#modifyForm');
	        
	        // attachDTOFile-list의 각 input 태그 접근
	        var i = 0;

	        $('.questionAttachDTOFile-list input[name="questionAttachDTO"]').each(function() {
	            
	        	questionAttachDTO = JSON.parse($(this).val());
	        	
	        	questionAttachDTO.questionId = ${questionDTO.questionId};

	            var inputPath = $('<input>').attr('type', 'hidden')
	                .attr('name', 'questionAttachList[' + i + '].questionAttachPath')
	                inputPath.val(questionAttachDTO.questionAttachPath);

	            var inputRealName = $('<input>').attr('type', 'hidden')
	                .attr('name', 'questionAttachList[' + i + '].questionAttachRealName')
	                inputRealName.val(questionAttachDTO.questionAttachRealName);

	            var inputChgName = $('<input>').attr('type', 'hidden')
	                .attr('name', 'questionAttachList[' + i + '].questionAttachChgName')
	                inputChgName.val(questionAttachDTO.questionAttachChgName);

	            var inputExtension = $('<input>').attr('type', 'hidden')
	                .attr('name', 'questionAttachList[' + i + '].questionAttachExtension')
	                inputExtension.val(questionAttachDTO.questionAttachExtension);

	            modifyForm.append(inputPath);
	            modifyForm.append(inputRealName);
	            modifyForm.append(inputChgName);
	            modifyForm.append(inputExtension);

	            i++;
	        });
	        modifyForm.submit();
	    });
	});

</script>
		
</body>
</html>