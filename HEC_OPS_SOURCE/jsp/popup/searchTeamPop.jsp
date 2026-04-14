<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00018} Search</title>

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
	$("#processList").attr("action","searchTeamPop.do?teamTypeYN=${teamTypeYN}").submit();
}


function setInfo(avg,avg2){
//	alert(avg+" // "+avg2)
	window.opener.setSearchTeam(avg,avg2);
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
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="teamTypeYN" name="teamTypeYN" value="${teamTypeYN}" /> 
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	
		<div class="child_search_head">
          <p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Search Team </p>
        </div>
      
         <div class="child_search_form"> 
    		<div class="child_search mgT5">
				<li>${menu.LN00104}</li>
				<li>
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:120px;ime-mode:active;"/>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="searchFrom()" value="Search">
				</li>
			</div>
			<div>
					<table class="tbl_blue01 mgT5" width="100%" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
								<col width="60%">
								<col width="30%">
								<col width="10%">			
							</colgroup>
							<tr>
								<th class="viewtop last">${menu.LN00162}</th>								
								<th class="viewtop last">${menu.LN00104}</th>
								<th class="viewtop">${menu.LN00106}</th>
							</tr>
				<c:forEach var="i" items="${getList}" varStatus="listStatus">
							<tr class="sem001">
								<td class="tit last"  onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.ParentName} </td>								
								<td class="tit last" onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.TeamName} </td>
								<td onclick="setInfo('${i.TeamID}','${i.ParentName} - ${i.TeamName}')"> ${i.TeamID} </td>
							</tr>
				</c:forEach>			
						</table>
				</div>
		</div>
	</div>
	</form>
</body>
</html>