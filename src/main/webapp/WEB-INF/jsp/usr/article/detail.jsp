<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="DETAIL"></c:set>
<%@ include file="../common/head_Option.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<%@ include file="../common/sidebar.jspf"%>

<!-- <iframe src="http://localhost:8080/usr/article/doIncreaseHitCount?id=757" frameborder="0"></iframe> -->
<!-- 변수 -->
<script>
	const params = {};
	params.id = parseInt('${param.id}');
	
	params.memberId = parseInt('${loginedMemberId}')
	
	console.log(params);
	console.log(params.id);
	console.log(params.memberId);
	
// 	var isAlreadyAddGoodRp = ${isAlreadyAddGoodRp ? 'true' : 'false'};
//  var isAlreadyAddBadRp = ${isAlreadyAddBadRp ? 'true' : 'false'};
	var isAlreadyAddGoodRp = $
	{
		isAlreadyAddGoodRp
	};
	var isAlreadyAddBadRp = $
	{
		isAlreadyAddBadRp
	};
</script>

<script>
	// 조회수
	function ArticleDetail__doIncreaseHitCount() {

		// 사용자가 처음 들어오는 게시물인지 확인하는 작업.
		// 브라우저 내 로컬 저장소에 있는 정보를 토대로 조회수를 증가/방치 한다.  
		const localStorageKey = 'article__' + params.id + '__alreadyOnView';

		if (localStorage.getItem(localStorageKey)) {
			return;
		}

		localStorage.setItem(localStorageKey, true);

		// 조회수 증가(부분 새로고침으로)
		$.get('../article/doIncreaseHitCountRd', {
			id : params.id,
			ajaxMode : 'Y'
		}, function(data) {
			console.log(data);
			console.log(data.data1);
			$('.article-detail__hit-count').empty().html(data.data1);
		}, 'json')
	}

	$(function() {
		// 		ArticleDetail__doIncreaseHitCount();
		setTimeout(ArticleDetail__doIncreaseHitCount, 1000);
	})
</script>

<!-- 좋아요 싫어요 버튼	-->
<script>
	function checkRP() {
		if (isAlreadyAddGoodRp == true) {
			$('#likeButton').toggleClass('btn-outline');
		} else if (isAlreadyAddBadRp == true) {
			$('#DislikeButton').toggleClass('btn-outline');
		} else {
			return;
		}
	}
function doGoodReaction(articleId) {
	if(isNaN(params.memberId) == true){
		if(confirm('로그인 창으로 이동하시겠습니까??')){
				console.log(window.location.href);
				console.log(encodeURIComponent(window.location.href));
			var currentUri = encodeURIComponent(window.location.href);
			window.location.href = '../member/login?afterLoginUri=' + currentUri;
		}
		return;
	}
	
		$.ajax({
			url: '/usr/reactionPoint/doGoodReaction',
			type: 'POST',
			data: {relTypeCode: 'article', relId: articleId},
			dataType: 'json',
			success: function(data){
				console.log(data);
				console.log('data.data1Name : ' + data.data1Name);
				console.log('data.data1 : ' + data.data1);
				console.log('data.data2Name : ' + data.data2Name);
				console.log('data.data2 : ' + data.data2);
				if(data.resultCode.startsWith('S-')){
					var likeButton = $('#likeButton');
					var likeCount = $('#likeCount');
					var likeCountC = $('.likeCount');
					var DislikeButton = $('#DislikeButton');
					var DislikeCount = $('#DislikeCount');
					var DislikeCountC = $('.DislikeCount');
					
					if(data.resultCode == 'S-1'){
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					}else if(data.resultCode == 'S-2'){
						DislikeButton.toggleClass('btn-outline');
						DislikeCount.text(data.data2);
						DislikeCountC.text(data.data2);
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					}else {
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					}
					
				}else {
					alert(data.msg);
				}
		
			},
			error: function(jqXHR,textStatus,errorThrown) {
				alert('좋아요 오류 발생 : ' + textStatus);
			}
			
		});
	}
function doBadReaction(articleId) {
	
	if(isNaN(params.memberId) == true){
		if(confirm('로그인 창으로 이동하시겠습니까?')){
				console.log(window.location.href);
				console.log(encodeURIComponent(window.location.href));
			var currentUri = encodeURIComponent(window.location.href);
			window.location.href = '../member/login?afterLoginUri=' + currentUri;
			// 로그인 페이지에 원래 페이지의 정보를 포함시켜서 보냄
		}
		return;
	}
	
	 $.ajax({
			url: '/usr/reactionPoint/doBadReaction',
			type: 'POST',
			data: {relTypeCode: 'article', relId: articleId},
			dataType: 'json',
			success: function(data){
				console.log(data);
				console.log('data.data1Name : ' + data.data1Name);
				console.log('data.data1 : ' + data.data1);
				console.log('data.data2Name : ' + data.data2Name);
				console.log('data.data2 : ' + data.data2);
				if(data.resultCode.startsWith('S-')){
					var likeButton = $('#likeButton');
					var likeCount = $('#likeCount');
					var likeCountC = $('.likeCount');
					var DislikeButton = $('#DislikeButton');
					var DislikeCount = $('#DislikeCount');
					var DislikeCountC = $('.DislikeCount');
					
					if(data.resultCode == 'S-1'){
						DislikeButton.toggleClass('btn-outline');
						DislikeCount.text(data.data2);
						DislikeCountC.text(data.data2);
						
					}else if(data.resultCode == 'S-2'){
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
						DislikeButton.toggleClass('btn-outline');
						DislikeCount.text(data.data2);
						DislikeCountC.text(data.data2);
		
					}else {
						DislikeButton.toggleClass('btn-outline');
						DislikeCount.text(data.data2);
						DislikeCountC.text(data.data2);
					}
			
				}else {
					alert(data.msg);
				}
			},
			error: function(jqXHR,textStatus,errorThrown) {
				alert('싫어요 오류 발생 : ' + textStatus);
			}
			
		});
	}
	$(function() {
		checkRP();
	});
</script>


<script>
	function ReplyWrite__submit(form) {
		console.log(form.body.value);
		
		form.body.value = form.body.value.trim();
		
		if(form.body.value.length < 3){
			alert('3글자 이상 입력해주세요.');
			form.body.focus();
			return;
		}
		
		form.submit();
	}
</script>

<!-- 댓글 수정 -->
<script>
function toggleModifybtn(replyId) {
	
	console.log(replyId);
	
	$('#modify-btn-'+replyId).hide();
	$('#save-btn-'+replyId).show();
	$('#reply-'+replyId).hide();
	$('#modify-form-'+replyId).show();
}
function doModifyReply(replyId) {
	 console.log(replyId); // 디버깅을 위해 replyId를 콘솔에 출력
	    
	    // form 요소를 정확하게 선택
	    var form = $('#modify-form-' + replyId);
	    console.log(form); // 디버깅을 위해 form을 콘솔에 출력
	    // form 내의 input 요소의 값을 가져옵니다
	    var text = form.find('input[name="reply-text-' + replyId + '"]').val();
	    console.log(text); // 디버깅을 위해 text를 콘솔에 출력
	    // form의 action 속성 값을 가져옵니다
	    var action = form.attr('action');
	    console.log(action); // 디버깅을 위해 action을 콘솔에 출력
	
    $.post({
    	url: '/usr/reply/doModify', // 수정된 URL
        type: 'POST', // GET에서 POST로 변경
        data: { id: replyId, body: text }, // 서버에 전송할 데이터
        success: function(data) {
        	$('#modify-form-'+replyId).hide();
        	$('#reply-'+replyId).text(data);
        	$('#reply-'+replyId).show();
        	$('#save-btn-'+replyId).hide();
        	$('#modify-btn-'+replyId).show();
        },
        error: function(xhr, status, error) {
            alert('댓글 수정에 실패했습니다: ' + error);
        }
	})
}
</script>

<!-- 배경 -->
<div id="background" style="position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1;"></div>

<!-- 중앙 정렬된 하얀색 박스 (화면의 절반 크기) -->
<section class="con flex-grow flex-col justify-center items-center m-16 bg-white rounded-lg">

	<!-- 이제부터 내용.. -->
	<table border="1" cellspacing="0" cellpadding="5">
		<tr>
			<th>번호</th>
			<td>${article.id}</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${article.title}</td>
		</tr>
		<!-- 	<tr> -->
		<!-- 		<th style="text-align: center;">Attached Image</th> -->
		<!-- 		<td style="text-align: center;"> -->
		<!-- 			<div style="text-align: center;"> -->
		<%-- 				<img class="mx-auto rounded-xl" src="${rq.getImgUri(article.id)}" onerror="${rq.profileFallbackImgOnErrorHtml}" --%>
		<!-- 					alt="" /> -->
		<!-- 			</div> -->
		<%-- 			<div>${rq.getImgUri(article.id)}</div> --%>
		<!-- 		</td> -->
		<!-- 	</tr> -->
		<tr>
			<th>작성일자</th>
			<td>${article.regDate}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${article.extra__writer}</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>
				<span class="article-detail__hit-count">${article.hit}</span>
			</td>
		</tr>
		<tr>
			<th>좋아요</th>
			<td id="likeCount" style="text-align: center;">${article.goodReactionPoint}</td>
		</tr>
		<tr>
			<th>싫어요</th>
			<td id="DislikeCount" style="text-align: center;">${article.badReactionPoint}</td>
		</tr>
		<!-- 	<tr> -->
		<!-- 		<th>좋아요 / 싫어요</th> -->
		<%-- 		<td>LIKE ${article.goodReactionPoint} / DISLIKE ${article.badReactionPoint}</td> --%>
		<!-- 	</tr> -->
		<tr>
			<th>게시판 번호</th>
			<td>${article.boardId}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>
				<div class="toast-ui-viewer">
					<script type="text/x-template">${article.body}</script>
				</div>
			</td>
		</tr>
	</table>

	<div class="btns flex flex-col space-y-4">
		<!-- 좋아요와 싫어요 버튼을 한 줄에 배치 -->

		<div class="flex justyfy-center space-x-4">

			<button id="likeButton" class="btn btn-outline btn-success" onclick="doGoodReaction(${param.id})">
				👍 LIKE
				<span class="likeCount">${article.goodReactionPoint}</span>
			</button>
			<button id="DislikeButton" class="btn btn-outline btn-error" onclick="doBadReaction(${param.id})">
				👎 DISLIKE
				<span class="DislikeCount">${article.badReactionPoint}</span>
			</button>

		</div>

		<!-- 	<div class="flex justify-center space-x-4"> -->

		<!-- 		<button type="button" class="btn btn-outline btn-success article-detail__like-count" -->
		<%-- 			onclick="window.location.href='/usr/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.currentUri}'"> --%>
		<%-- 			👍(●'◡'●) ${article.goodReactionPoint}</button> --%>

		<%-- 		<%-- 		<a href="/usr/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.currentUri}" --%>

		<%-- 		<%-- 			class="btn btn-outline btn-success"> 👍(●'◡'●) ${article.goodReactionPoint}</a> --%>

		<%-- 		<a href="/usr/reactionPoint/doBadReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.currentUri}" --%>
		<%-- 			class="btn btn-outline btn-error">👎(╬▔皿▔)╯ ${article.badReactionPoint}</a> --%>

		<!-- 	</div> -->

		<!-- 뒤로 가기, 수정, 삭제 버튼들 -->
		<div class="flex justify-center space-x-4 mt-4">
			<button class="btn" type="button" onclick="history.back()">뒤로 가기</button>
			<c:if test="${article.userCanModify }">
				<a class="btn" href="../article/modify?id=${article.id }">수정</a>
			</c:if>
			<c:if test="${article.userCanDelete }">
				<a class="btn" href="../article/doDelete?id=${article.id }">삭제</a>
			</c:if>
		</div>
	</div>


	<!-- 댓글 -->
	<section class="mt-24 text-xl px-4">

		<c:if test="${rq.isLogined() }">
			<form action="../reply/doWrite" method="POST" onsubmit="ReplyWrite__submit(this); return false;" )>
				<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
					<input type="hidden" name="relTypeCode" value="article" />
					<input type="hidden" name="relId" value="${article.id }" />
					<tbody>

						<tr>
							<th>댓글 내용 입력</th>
							<td style="text-align: center;">
								<textarea class="input input-bordered input-sm w-full max-w-xs" name="body" autocomplete="off" type="text"
									placeholder="내용을 입력해주세요."></textarea>
							</td>

						</tr>
						<tr>
							<th></th>
							<td style="text-align: center;">
								<button class="btn btn-outline">작성</button>
							</td>

						</tr>
					</tbody>
				</table>
			</form>
		</c:if>

		<c:if test="${!rq.isLogined() }">
			<!-- 댓글 작성을 위해 <a class="btn btn-outline btn-primary btn-sm" href="../member/login">로그인</a>이 필요합니다 -->
	댓글 작성을 위해 <a class="btn btn-sm btn-outline btn-primary" href="${rq.loginUri }">로그인</a>이 필요합니다.
	</c:if>

		<!-- 	댓글 리스트 -->
		<div class="mx-auto">
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<thead>
					<tr>
						<th style="text-align: center;">Registration Date</th>
						<th style="text-align: center;">Writer</th>
						<th style="text-align: center;">Body</th>
						<th style="text-align: center;">Like</th>
						<th style="text-align: center;">Dislike</th>
						<th style="text-align: center;">Edit</th>
						<th style="text-align: center;">Delete</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="reply" items="${replies}">
						<tr class="hover">
							<td style="text-align: center;">${reply.regDate.substring(0,10)}</td>
							<td style="text-align: center;">${reply.extra__writer}</td>
							<%-- <td style="text-align: center;">${reply.body}</td> --%>
							<td style="text-align: center;">
								<span id="reply-${reply.id }">${reply.body}</span>
								<form method="POST" id="modify-form-${reply.id }" style="display: none;" action="/usr/reply/doModify">
									<input type="text" value="${reply.body }" name="reply-text-${reply.id }" />
								</form>
							</td>
							<td style="text-align: center;">${reply.goodReactionPoint}</td>
							<td style="text-align: center;">${reply.badReactionPoint}</td>
							<td style="text-align: center;">
								<c:if test="${reply.userCanModify }">
									<%-- <a class="btn btn-outline btn-xs btn-success" href="../reply/modify?id=${reply.id }">수정</a> --%>
									<button onclick="toggleModifybtn('${reply.id}');" id="modify-btn-${reply.id }" style="white-space: nowrap;"
										class="btn btn-outline btn-xs btn-success">수정</button>
									<button onclick="doModifyReply('${reply.id}');" style="white-space: nowrap; display: none;"
										id="save-btn-${reply.id }" class="btn btn-outline btn-xs">저장</button>
								</c:if>
							</td>
							<td style="text-align: center;">
								<c:if test="${reply.userCanDelete }">
									<a class="btn btn-outline btn-xs btn-error" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;"
										href="../reply/doDelete?id=${reply.id }">삭제</a>
								</c:if>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty replies}">
						<tr>
							<td colspan="4" style="text-align: center;">댓글이 없습니다</td>
						</tr>
					</c:if>
				</tbody>
			</table>

		</div>
	</section>

</section>

<%@ include file="../common/foot.jspf"%>