<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00004} Delete</title>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">

$(document).ready(function() {
	
	// 체크 박스 모두 체크 / 모두 해제
	$("#deleteAll").change(function() {
		$("input[name=delete]:checkbox").each(function() {
			if ($(this).attr("checked") == false) {
				$(this).attr("checked", true);
			} else {
				$(this).attr("checked", false);
			}
		});
	 });

	
});


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

function delClose() {
	// check된 checkbox 값 가져오기
	var checkedValue = "";
	var checkedName = "";
	$("input[name=delete]:checked").each(function() {
		if (checkedValue == "") {
			checkedValue = $(this).val();
			checkedName = $('#' + $(this).val()).val();
		} else {
			checkedValue = checkedValue + "," + $(this).val();
			checkedName = checkedName + "," + $('#' + $(this).val()).val();
		}
	});
	window.opener.setDeleteName(checkedValue, checkedName);
	self.close();
}

</script>
</head>

<body>

    <!-- BEGIN :: BOARD_ADMIN_FORM -->
    <form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
    <input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
    <div id="processListDiv" class="hidden" style="width:100%;height:100%;">
        
	        <div class="child_search_head">
	              <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;${menu.LN00004} Delete</p>
	            </div>
            <div class="child_search_form">
		        
			    <table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
			        <tr>
			        	<th class="viewtop"><input type="checkbox" name="deleteAll" id="deleteAll" onchange=""></th>
			            <th class="viewtop">이름</th>
			            <th class="viewtop">ID</th>
			            <th class="viewtop last">부서</th>
			        </tr>
					<c:forEach var="i" items="${getList}" varStatus="listStatus">
			            <tr class="sem001">
			            	<td><input type="checkbox" value="${i.MemberID}" name="delete"></td>
			                <td>${i.UserName}</td>
			                <td>${i.MemberID}</td>
			                <td class="tit">${i.TeamName}</td>
			            </tr>
			            <input type="hidden" id="${i.MemberID}" name="${i.MemberID}" value="${i.UserName}">
					</c:forEach>
			        </table>
		
			<div class="alignBTN">
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delClose()"></span>
			</div>
        </div>
        
        
    </div>
    
    
	
    </form>
</body>
</html>