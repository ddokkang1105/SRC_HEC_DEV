<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>부서검색</title>

<link rel="stylesheet" type="text/css" href="${root}${HTML_CSS_DIR}/style.css"/>
<script src="<c:url value='/cmm/js/jquery/jquery.js'/>" type="text/javascript"></script>
<script src="<c:url value='/cmm/js/DSHelper.js'/>" type="text/javascript"></script>

<script>
$(function(){
	$('.sem001').click(function(){
		$('.sem001').css('background-color', '#ffffff');
		$('.sem001').attr('alt', '');
		$(this).css('background-color', '#eafafc');
		$(this).attr('alt', '1');
	}).mouseover(function(){
		$(this).css('background-color', '#eafafc');
	}).mouseout(function(){
		if($(this).attr('alt') != 1) 
			$(this).css('background-color', '#ffffff');
	});;
});

$(window).load(function(){
	$("#searchValue").focus();
	
});

function searchFrom(){
	$("#processList").attr("action","searchTeamSubPop.do").submit();
}


function setInfo(avg,avg2){
//	alert(avg+" // "+avg2)
	window.opener.setSubSearchTeam(avg,avg2);
	self.close();
}


</script>
<script type="text/javascript">
function btndown(id,loc){
    var obj = document.getElementById(id);
    var orgSrc = obj.src;
    var newSrc = loc;
    
    obj.src = newSrc;
    
    obj.onmouseout = function(){
        obj.src = orgSrc;
    }
}
</script>
</head>

<body>

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	
		<div class="child_search_head">
          <p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;부서검색</p>
        </div>
         <div class="child_search_form">
			<div class="child_search pdL20">
					부서명
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;"/>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchFrom()" value="검색">
			</div>
			<table class="tbl_blue01 mgT5" width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<th class="viewtop">상위부서</th>
						<th class="viewtop">ID</th>
						<th class="viewtop last">부서명</th>
					</tr>
		<c:forEach var="i" items="${getList}" varStatus="listStatus">
					<tr class="sem001">
						<td class="tit" onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.ParentName} </td>
						<td onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.TeamID} </td>
						<td class="tit" onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.TeamName} </td>
					</tr>
		</c:forEach>			
				</table>
		</div>
	</div>
	</form>
</body>
</html>