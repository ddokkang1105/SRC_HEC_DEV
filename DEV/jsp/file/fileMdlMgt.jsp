<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/olmJsInc.jsp"%>
<script type="text/javascript">
	var noticType;var menuIndex = "1 2 3 4";	
	$(document).ready(function(){
		
		setSubFrame();	
	});
	
	function setSubFrame(){
	
		var url = "goFileMdlList.do";		
		var target = "subBFrame";
		var itemId = $('#itemId').val();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemId="+itemId
				+ "&pageNum=" + $("#currPage").val();
		ajaxPage(url, data, target);
	}

	function goFileDetail(isNew,fileSeq,fileName,fltpCode,creationTime,writeUserNM,sysFile,fltpName,itemId){ 
		if(isNew=="Y"){
			itemId = $('#itemId').val();
		}
		var url = "goFileMdlDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isNEW="+isNew+"&fileSeq="+fileSeq+"&fileName="+fileName+"&fltpCode="+fltpCode+"&creationTime="+creationTime+"&writeUserNM="+writeUserNM+"&sysFile="+sysFile+"&fltpName="+fltpName+"&itemId="+itemId;
		var target = "subBFrame";

		ajaxPage(url, data, target);		
	}
	
</script>
</head>
<body>
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="fileSeq" name="fileSeq" value="">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden"   id="option" name="option" value="${option}">
	<input type="hidden" id="currPage" name="currPage" value=""></input>
	
</form>
	<div id="subBFrame" name="subBFrame" width="100%" height="80%"></div>
</body>
</html>