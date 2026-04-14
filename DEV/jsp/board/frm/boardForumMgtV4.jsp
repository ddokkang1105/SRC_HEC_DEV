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
	
	// cmm
	var s_itemID = "${s_itemID}";
	var noticType = "${noticType}";
	var emailCode = "${emailCode}";
	var mailRcvListSQL = "${mailRcvListSQL}";
	var myBoard = "${myBoard}";
	var projectID = "${projectID}";
	var BoardMgtID = "${BoardMgtID}";
	var boardID = "${boardID}";
	var boardType = "${boardType}";
	var goDetailOpt = "${goDetailOpt}";
	
	// sr
	var srID = "${srID}";
	
	// cs
	var showItemInfo = "${showItemInfo}";
	var dueDateMgt = "${dueDateMgt}";
	var replyMailOption = "${replyMailOption}";
	var forumMailOption = "${forumMailOption}";
	var showReplyDT = "${showReplyDT}";
	var openDetailSearch = "${openDetailSearch}";
	var showAuthorInfo = "${showAuthorInfo}";
	var showItemVersionInfo = "${showItemVersionInfo}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	
</script>
<script type="text/javascript">

$(document).ready(function(){
	
	// 화면 높이 조정
	var screenHeight = setWindowHeight();
	if ("-1" == "${s_itemID}") {
		screenHeight = setWindowHeight() + 50;
	}
	
	// 경로 설정
	let url = "boardForumListV4.do";
	let requestData = { s_itemID, languageID, myBoard, noticType, BoardMgtID, mailRcvListSQL, emailCode};
	
	if(boardType == 'cs') {
		url = "csForumListV4.do";
		requestData = {
				...requestData,
				showItemInfo, replyMailOption, forumMailOption, showReplyDT, openDetailSearch, dueDateMgt, showAuthorInfo, showItemVersionInfo
		}
	}
	if(boardType == 'sr') {
		url = "srForumListV4.do";
		requestData = {
				...requestData,
				srID
		}
	}
	
	// popup에서 바로  상세화면으로 이동
	if (goDetailOpt == "Y") {
		if(boardID != ""){
			requestData = {
					...requestData,
					NEW : 'N',
					noticType : '101',
					boardID : boardID,
					ItemID : s_itemID
			}
			url = "viewForumPost.do";
		}
	}
	if(s_itemID != '' && goDetailOpt != 'Y'){ 
		requestData = {
				...requestData,
				listType : '1'
		}
	}
	
	const params = new URLSearchParams(requestData).toString();
	
	var target = "help_content";
	ajaxPage(url, params, target);
	
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
