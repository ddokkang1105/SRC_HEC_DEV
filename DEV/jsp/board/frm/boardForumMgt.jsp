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
	
	var s_itemID = "${s_itemID}";
	var url = "boardForumList.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}"
				+ "&myBoard=${myBoard}&noticType=${noticType}&BoardMgtID=${BoardMgtID}&srID=${srID}&mailRcvListSQL=${mailRcvListSQL}&emailCode=${emailCode}&showItemInfo=${showItemInfo}&replyMailOption=${replyMailOption}&forumMailOption=${forumMailOption}&showReplyDT=${showReplyDT}&openDetailSearch=${openDetailSearch}"
				+"&dueDateMgt=${dueDateMgt}&showAuthorInfo=${showAuthorInfo}&showItemVersionInfo=${showItemVersionInfo}";
	if(instanceNo != ""){
		data += "&instanceNo="+instanceNo+"&projectID="+projectID+"&isProcInst="+isProcInst;
	}
	if(changeSetID != ""){
		data += "&changeSetID="+changeSetID;
	}
	
	// popup에서 바로  상세화면으로 이동
	var goDetailOpt = "${goDetailOpt}";
	if (goDetailOpt == "Y") {
		var boardID = "${boardID}";
		if(boardID != ""){
			data += "NEW=N&noticType=101&boardID="+boardID+"&ItemID="+s_itemID;
			url = "viewForumPost.do";
		}
	}	
	
	var target = "help_content";
	
	if(s_itemID != '' && goDetailOpt != 'Y'){ 
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
});

function goNewItemInfo() {
	var url = "NewItemInfoMain.do";
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
 	ajaxPage(url, data, target);
}

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


function fnEditforum(){
	var actionUrl =  "editForumPost.do";
	var target = "help_content";
	var data = "";
	ajaxPage(actionUrl, data, target);
}

</script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="forumMgtDiv" style="overflow-x:hidden;overflow-y:auto;height: 100%;">
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;"></form>
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
	<c:if test="${isItem == 'Y' }" >
	<div id="help_content" name="help_content" style="overflow-x:hidden;overflow-y:auto;height:100%;"></div>
	</c:if>
	<c:if test="${isItem == 'N' }" >
	<div id="help_content" name="help_content" style="overflow-x:hidden;overflow-y:auto;margin:0 auto;"></div>
	</c:if>
</div>

</body>
</html>
