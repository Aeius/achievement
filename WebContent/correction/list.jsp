<%@page import="com.bit.model.CorrectionDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/mycss.css" rel="stylesheet">
<style type="text/css">
#search{
	width: 500px;
	margin:10px auto;
	text-align: center;
}
#search>a{
	width: 200px;
	height: 90px;
	border-bottom: 2px solid gray;
	border-right: 2px solid gray;
}
</style>
<script type="text/javascript" src="../js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min.js"></script>
</head>
<body>
<%@ include file="../template/header.jsp" %>
<%@ include file="../template/menu2.jsp" %>
<script type="text/javascript">
var page = 1;
var count = 0;
var start = 0 + 5 * ((page-1)/5);
var end = start + 5;
$(function(){
	getList(1);
});
function prev(){
	if(page != 1){
		page = start -1;
	}
	getList(page);
}
function next(){
	if(count > page * 10){
		page = end+1;
	}
	getList(page);
}
function getList(pageNum){
	page = pageNum;
	var select = $('.select').val();
	var input = $('#search-input').val();
	$.get('<%=root%>/correction/list.do', {page:page, select: select, input:input}, function(data){
		// json parsing
		var json = JSON.parse(data);
		// 테이블 비우기
		$('tbody').html("");
		// 게시글
		var correction = json.correction;
		// 총 게시글 수 획득
		count = json.count;
		// 게시글 출력
		for(i = 0; i < correction.length; i++){
			var values = $('<tr/>').html(
				'<td><a href="detail.do?num='+correction[i].num+'">'+correction[i].num+'</a></td>'+		
				'<td><a href="detail.do?num='+correction[i].num+'">'+correction[i].title+'</a></td>'+		
				'<td><a href="detail.do?num='+correction[i].num+'">'+correction[i].userName+'</a></td>'+		
				'<td><a href="detail.do?num='+correction[i].num+'">'+correction[i].date+'</a></td>'+		
				'<td><a href="detail.do?num='+correction[i].num+'">'+correction[i].cnt+'</a></td>'		
			);                                
			$('tbody').append(values);
		}
		// 이전, 다음, 페이지
		start = 0 + 5 * Math.floor(((page-1)/5));
		end = start + 5;
		if(end * 10 == count){
			end = Math.floor(count/10);
		} else if(end * 10 > count){
			end = Math.floor(count/10+1);
		}
		// 페이지 div 초기화
		$('#pagination').html("");
		// 페이지 번호
		for(j = start; j < end; j++){
			var values = $('<button/>')
			.attr('type','button')
			.attr('onclick','getList('+(j+1)+')')
			.text(j+1);
			$('#pagination').append(values);
		}
		// 이전 버튼
		if(start!=0){
			var prev = $('<button/>')
						.attr('type', 'button')
						.attr('onclick', 'prev()')
						.text("이전");
			$('#pagination').prepend(prev)
		}
		// 다음 버튼
		if(end * 10 < count){
			var next = $('<button/>')
						.attr('type', 'button')
						.attr('onclick', 'next()')
						.text("이후");
			$('#pagination').append(next);
		}
		$('#pagination>button').css('margin','0px 3px');
	})
}

</script>
<div class="content">
<h1>학생 성적 관리 웹사이트(ver 0.7.0)</h1>
<h2>정정 요청 게시판</h2>
<table class="board">
	<thead>
		<tr>
			<th>글번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>날짜</th>
			<th>조회수</th>
		</tr>
	</thead>
    <tbody>
   
    </tbody>
</table>
	<div id="pagination">
  	
  	</div>
  	<div id="search">
  		<select class="select">
  			<option value="title">제목</option>
  			<option value="content">내용</option>
  		</select>
  		<input type="text" name="search" id="search-input">
  		<button type="submit">검색</button>
  		<%
  		if(userNum!="null"){
  		%>
  		<a href="write.jsp">글작성</a>
  		<%
  		}
  		%>
    </div>
</div>
<%@ include file="../template/footer.jsp"%>
</body>
</html>