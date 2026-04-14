<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<% request.setCharacterEncoding("euc-kr"); %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00060} Search</title>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
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
	fnSelect('selTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}','selectPjtRelTeam','${teamID}', 'Select');
});

$(window).load(function(){
	$("#searchValue").focus();
	var listSize = "${listSize}";
	if(listSize == 1){
		var memberID = "${firstRowData.MemberID}";
		var userName = "${firstRowData.UserName}";
		var teamName = "${firstRowData.TeamName}";
		var teamID = "${firstRowData.TeamID}";
		var teamPath = "${firstRowData.TeamPath}";
		setInfo(memberID,userName,teamName,teamID,teamPath);
	}
	
	fnSelect('selTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}','selectPjtRelTeam','${teamID}', 'Select');
});

function searchFrom(){
	var url = "searchPjtMemberPop.do?projectID=${projectID}&searchKey="+$("#searchKey").val()
			+"&searchValue="+encodeURIComponent($("#searchValue").val())+"&teamID="+$("#selTeam").val();
// 	$("#processList").attr("action", url).submit();
	document.getElementById('processList').action = url;
	document.getElementById("processList").submit();
}


function setInfo(avg1,avg2,avg3,avg4){ 
	if(confirm("${CM00001}")){
// 		window.opener.setSearchMember(avg1);
		setSearchMember(avg1);
	}
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
    };
}
</script>
</head>

<body>
    <!-- BEGIN :: BOARD_ADMIN_FORM -->
    <form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
    <div id="processListDiv" class="hidden" style="width:100%;height:100%;">
        <div class="child_search_head">
              <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;Search user</p>
            </div>
           <div class="child_search_form">
	        <div class="child_search mgT5">      
		        <li>&nbsp;&nbsp;${menu.LN00247}&nbsp;
					<select id="selTeam" name="selTeam" style="width:120px;"></select>
					<select id="searchKey" name="searchKey" class="pdL5">
						<option value="Name">Name</option>
						<option value="ID">ID</option>
					</select>
	             	<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;"/>
	               	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="searchFrom()" value="검색">
	             </li>
	        </div>
		    <table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		            <th class="viewtop">${menu.LN00060}</th>
		            <th class="viewtop">${menu.LN00148}</th>
		            <th class="viewtop last">${menu.LN00104}</th>
		        </tr>
				<c:forEach var="i" items="${getList}" varStatus="listStatus">
	            <tr class="sem001">
	                <td onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}')">${i.UserName}</td>
	                <td onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}')">${i.EmployeeNum}</td>
	                <td class="tit" onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}')">${i.TeamName}</td>
	            </tr>
				</c:forEach>
		     </table>
        </div>
    </div>
    </form>
</body>
</html>