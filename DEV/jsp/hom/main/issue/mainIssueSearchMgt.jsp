<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">

$(document).ready(function(){
	goIssueSearch();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
function goIssueSearch() {
	var url = "issueSearchList.do";
	var target = "help_content";
	var data = "issueMode=Admin";
	ajaxPage(url, data, target);
}

</script>

</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<div id="help_content" name="help_content" style="padding:0 0 0 20px;width:80%;height:90%;margin:0 auto;"></div>
</form>
</body>
</html>
