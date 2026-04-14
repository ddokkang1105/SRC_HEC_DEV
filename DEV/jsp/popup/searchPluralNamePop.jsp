<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<% request.setCharacterEncoding("euc-kr"); %> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00060} Search</title>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00072}"/>

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
	var listSize = "${listSize}";
	if(listSize == 1){
		var memberID = "${firstRowData.MemberID}";
		var userName = "${firstRowData.UserName}";
		var teamName = "${firstRowData.TeamName}";
		var teamID = "${firstRowData.TeamID}";
		var teamPath = "${firstRowData.TeamPath}";
		var clientID = "${firstRowData.ClientID}";
		var companyName = "${firstRowData.CompanyName}";
		setInfo(memberID,userName,teamName,teamID,teamPath,clientID,companyName);
	}
});

function searchFrom(){
	var url = "searchPluralNamePop.do";
	var searchValue = $("#searchValue").val();
	if(searchValue == ""){alert("${WM00034}");$("#itemName").focus();return false;}
	
	var data = "objId=" + $('#objId').val() + "&objName=" + $('#objName').val()
				+"&searchValue="+$("#searchValue").val()+"&UserLevel=${UserLevel}"
				+"&searchKey="+$("#searchKey").val()
				+"&teamID=${teamID}&clientID=${clientID}&searchOption=${searchOption}";
	var target ="processList";
	ajaxPage(url, data, target);
}


function setInfo(avg1,avg2,avg3,avg4,avg5,avg6,avg7){
	window.opener.setSearchNameWf(avg1, avg2, avg3, avg4, $('#objId').val(), $('#objName').val(),avg5,avg6,avg7);
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
    };
}
</script>
</head>

<body>
    <!-- BEGIN :: BOARD_ADMIN_FORM -->
    <form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
    <input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
    <div id="processListDiv" class="hidden" style="width:100%;height:100%;">
    
    <input type="hidden" id="objId" name="objId" value="${objId}">
    <input type="hidden" id="objName" name="objName" value="${objName}">
        <div class="child_search_head">
              <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;Search user</p>
            </div>
           <div class="child_search_form">
	        <div class="child_search mgT5">
	             <li> ${menu.LN00060}</li>
	             <li>
               		<select id="searchKey" name="searchKey" style="height:25px;">
						<option value="Name">Name</option>
						<option value="ID" 
							<c:if test="${!empty searchID}">selected="selected"
							</c:if>	
						>ID</option>
					</select>
	             	<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:120px;height:25px;ime-mode:active;"/>
	               	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="searchFrom()" value="검색">
	             </li>
	        </div>
	        <div style="height: calc(100% - 80px); overflow-y:scroll;">
			    <table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
			        <tr>
			            <th class="viewtop">${menu.LN00060}</th>
			            <c:if test="${empty loginInfo.sessionSecuLvl}">
			            <th class="viewtop">${menu.LN00148}</th>
			            </c:if>
			            <th class="viewtop last">${menu.LN00104}</th>
			        </tr>
					<c:forEach var="i" items="${getList}" varStatus="listStatus">
		            <tr class="sem001">
		                <td onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}','${i.ClientID}','${i.CompanyName}')">${i.UserName}</td>
		                <c:if test="${empty loginInfo.sessionSecuLvl}">
		                <td onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}','${i.ClientID}','${i.CompanyName}')">${i.EmployeeNum}</td>
		                </c:if>
		                <td class="tit" onclick="setInfo('${i.MemberID}','${i.UserName}','${i.TeamName}','${i.TeamID}','${i.TeamPath}','${i.ClientID}','${i.CompanyName}')">${i.TeamName}</td>
		            </tr>
					</c:forEach>
			     </table>
		     </div>
        </div>
    </div>
    </form>
</body>
</html>