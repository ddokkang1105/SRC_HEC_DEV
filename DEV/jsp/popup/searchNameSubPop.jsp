<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00060} Search</title>

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
	});
});

$(window).load(function(){
	$("#searchValue").focus();
	
});

function searchFrom(){
	document.getElementById("processList").action = "searchNameSubPop.do";
	document.getElementById("processList").submit();
}


function setInfo(avg,avg2){
//	alert(avg+" // "+avg2)
	window.opener.setSubSearchName(avg,avg2);
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
	              <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;${menu.LN00060} Search</p>
	            </div>
            <div class="child_search_form">
		        <div class="child_search pdL20">
		                <select id="searchKey" name="searchKey">
								<option value="Name">Name</option>
								<option value="ID" 
									<c:if test="${!empty searchID}">selected="selected"
									</c:if>	
								>ID</option>
						</select>&nbsp;&nbsp;
		                <input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;"/>
		                <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchFrom()" value="검색">
		        </div>
			    <table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
			        <tr>
			            <th class="viewtop">${menu.LN00060}</th>
			            <th class="viewtop">${menu.LN00106}</th>
			            <th class="viewtop last">${menu.LN00104}</th>
			        </tr>
			<c:forEach var="i" items="${getList}" varStatus="listStatus">
			            <tr class="sem001">
			                <td onclick="setInfo('${i.MemberID}','${i.UserName}')">${i.UserName}</td>
			                <td onclick="setInfo('${i.MemberID}','${i.UserName}')">${i.MemberID}</td>
			                <td class="tit" onclick="setInfo('${i.MemberID}','${i.UserName}')">${i.TeamName}</td>
			            </tr>
			</c:forEach>
			        </table>
        </div>
    </div>
    </form>
</body>
</html>