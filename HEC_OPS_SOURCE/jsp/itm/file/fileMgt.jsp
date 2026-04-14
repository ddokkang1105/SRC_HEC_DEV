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
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var noticType;var menuIndex = "1 2 3 4";	
	$(document).ready(function(){
		
		setSubFrame();	
	});
	
	function setSubFrame(){
	
		var url = "goFileList.do";		
		var target = "subBFrame";
		var fileOption = "${fileOption}";
		var DocumentID = $('#DocumentID').val();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&DocCategory=ITM&DocumentID="+DocumentID+"&fileOption="+fileOption
				+ "&pageNum=" + $("#currPage").val()+"&itemBlocked=${itemBlocked}&backBtnYN=${backBtnYN}";
		ajaxPage(url, data, target);
	}

	function goFileDetail(isNew,itemClassCode){ 
	
		var DocumentID = $('#itemId').val();
		var itemAthId = $('#itemAthId').val();
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var Blocked = $('#Blocked').val();
		var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
		var LockOwner = $('#LockOwner').val();
		
		if(itemAthId == userId || LockOwner == userId || Authority == "1"){
			var url  = "fileDetail.do";
			var data ="&isNew="+isNew+"&DocumentID="+itemId+"&pageNum=" + $("#currPage").val()+"&itemClassCode="+itemClassCode; 
			var target = "subBFrame";
			ajaxPage(url,data,target); 
		
		}else{ 
			alert("${WM00040}");
			return;
		}
	 
	}
	
	// dextUpload : MultiUpload 
	function goMultiUpload(){
		var itemId = $('#itemId').val();
		var url  = "goMultiUploadFl.do";
		var data ="&DocumentID="+itemId; 
		var target = "subBFrame";
		ajaxPage(url,data,target); 
	}
	
</script>
</head>
<body>
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="fileSeq" name="fileSeq" value="">
	<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="fileOption" name="fileOption" value="${fileOption}">
	<input type="hidden" id="currPage" name="currPage" value=""></input>
	<input type="hidden" id="itemBlocked" name="itemBlocked" value="${itemBlocked}"/>
	
</form>
	<div id="subBFrame" name="subBFrame" width="100%" height="80%"></div>
</body>
</html>