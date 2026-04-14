<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00032" var="CM00032"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095"/>

<script type="text/javascript">
var imgKind = "jpg gif png bmp jpeg";
function doSave(){
	var strFile = fileFrm.fileUpload.value;
	if(strFile==""){alert("${WM00095}");return ;}
	var strKind=strFile.substring(strFile.lastIndexOf(".")+1).toLowerCase();
	var isCheck = false;
	var imgKinds = imgKind.split(' ');
	for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
	if(isCheck){var url  = "uploadImgFile.do";	ajaxSubmit(document.fileFrm, url);
	}else{alert("${WM00032}"); return ;}
}
function doReturn(fileStr, dir){
	if (!window.opener.closed){
		window.opener.editorImgUploadComplete(fileStr,dir);
	}
	self.close();
}

</script>

</head>

<body>
<div class="view_box">
	<div class="guide"><span class="tl"></span><span class="tr"></span></div>
	<div class="cont">
		<form name="fileFrm" id="fileFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
			<li class="mgT5 pdL20"><b>Select image file</b></li>
			<li><input type="file" name="fileUpload" id="fileUpload" class="fileup" /> </li>
			<li><span class="btn_pack medium icon"><span class="upload"></span><input value="upload" type="submit" onclick="doSave();"></span></li>
		</form>
	</div>
	<div class="guide"><span class="lb"></span><span class="rb"></span></div>
</div>
		
		

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>    