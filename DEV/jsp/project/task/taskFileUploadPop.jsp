<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script>
	var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll txt";    
	
	$(document).ready(function() {
		
		 $('#uploadFile').change(function(){  
		        var upfile = $(this).val();
		        
		    	var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
		    	var isCheck = false;
		    	var imgKinds = imgKind.split(' ');
		    	for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
		    	
		    	if(isCheck){
		    		$('#uploadFile').val("");
		    	}
		    	
		        
		 });
	});

	function saveTaskFile() {
		if (!confirm("${CM00001}")) {
			return;
		}
		var url = "saveTaskFile.do";
		ajaxSubmit(document.taskFileUploadFrm, url, "blankFrame");
	}

	function fnCallBack() {
		self.close();
	}
</script>
</head>

<body>
	<form name="taskFileUploadFrm" id="taskFileUploadFrm" action=""	enctype="multipart/form-data" method="post">
		<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}">
		<input type="hidden" id="taskTypeCode" name="taskTypeCode" value="${taskTypeCode}">
		<input type="hidden" id="fltpCode" name="fltpCode" value="${fltpCode}">
		<input type="hidden" id="sysFile" name="sysFile" value="${sysFile}">
		<input type="hidden" id="fileID" name="fileID" value="${fileID}">
		<input type="hidden" id="itemID" name="itemID" value="${itemID}">
		<input type="hidden" id="taskID" name="taskID" value="${taskID}">
		<input type="hidden" id="projectID" name="projectID" value="${projectID}">
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Upload	Task File</p>
		</div>
		<div id="objectInfoDiv"	style="width: 100%; overflow: auto; overflow-x: hidden;">
			<table class="tbl_blue01 mgT2" width="80%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th width="30%" style="word-break: break-all">FileUpload</th>
					<td width="70%" align="left" class="last"><input type="file" name='uploadFile' id='uploadFile'></td>
				</tr>
			</table>
		</div>
		<div class="alignBTN" id="divUpdateModel">
			<span class="btn_pack medium icon"><span class="save"></span><input	value="Save" type="submit" OnClick="saveTaskFile()"></span>
		</div>
		<iframe name="blankFrame" id="blankFrame" src="about:blank"	style="display: none" frameborder="0"></iframe>
	</form>
</body>
</html>