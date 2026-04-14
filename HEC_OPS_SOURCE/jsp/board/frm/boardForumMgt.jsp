<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%
String noticType = request.getParameter("noticType") == null ? "1" : request.getParameter("noticType");
%>   
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>

<script src="<c:url value='/cmm/js/jquery/jquery.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	var chkReadOnly = false;
	var instanceNo = "${instanceNo}";
	var changeSetID = "${changeSetID}";
	var isProcInst = "${isProcInst}";	
	var projectID = "${projectID}";
</script>
<script type="text/javascript">

$(document).ready(function(){
// 	$("#actFrame").attr("style", "display:block;");
	var screenHeight = setWindowHeight();
	if ("-1" == "${s_itemID}") {
		screenHeight = setWindowHeight() + 50;
	} 
// 	$("#forumMgtDiv").attr("style","height:"+screenHeight+"px;");
// 	// 화면 크기 조정
// 	window.onresize = function() {
// 		$("#forumMgtDiv").attr("style","height:"+screenHeight+"px;");
// 	};
	
	var s_itemID = "${s_itemID}";
	var url = "boardForumList.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}"
				+ "&myBoard=${myBoard}&noticType=${noticType}&BoardMgtID=${BoardMgtID}&srID=${srID}";
	if(instanceNo != ""){
		data += "&instanceNo="+instanceNo+"&projectID="+projectID+"&isProcInst="+isProcInst;
	}
	if(changeSetID != ""){
		data += "&changeSetID="+changeSetID;
	}
	
	var target = "help_content";
	
	if(s_itemID != ''){ 
		data = data + "&listType=1";
	}
	ajaxPage(url, data, target);
	
	$("#searchButton").click(function(){
		var url = "boardForumSearch.do";
		var data ="option="+$('#search option:selected').val()
				+ "&searchValue="+$('#searchValue').val()
				+ "&s_itemID="+$('#s_itemID').val()
				+ "&BoardMgtID="+$('#BoardMgtID').val()
				+ "&itemTypeCode="+$('#itemTypeCode').val()+"&srID=${srID}";
		if(instanceNo != ""){
			data += "&instanceNo="+instanceNo+"&projectID="+projectID+"&isProcInst="+isProcInst;
		}
		if(changeSetID != ""){
			data += "&changeSetID="+changeSetID;
		}
		var target = "help_content";
		
		ajaxPage(url, data, target);
		
	});
	
	$('#searchValue').trigger('focus');
	$('#searchValue').live('keypress', function(e) {
		if (e.which == 13) 
		{
			$('#searchButton').click();
		}
	});
	
});

function goNewItemInfo() {
	var url = "NewItemInfoMain.do";
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
 	ajaxPage(url, data, target);
}

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


function fnEditforum(){
	var actionUrl =  "editForumDetail.do";
	var target = "help_content";
	var data = "";
	ajaxPage(actionUrl, data, target);
}

</script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="forumMgtDiv" style="overflow-x:hidden;overflow-y:auto;">
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;"></form>
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
	<c:if test="${isItem == 'Y' }" >
	<div id="help_content" name="help_content" style="overflow-x:hidden;overflow-y:auto;"></div>
	</c:if>
	<c:if test="${isItem == 'N' }" >
	<div id="help_content" name="help_content" style="overflow-x:hidden;overflow-y:auto;margin:0 auto;"></div>
	</c:if>
</div>

</body>
</html>
