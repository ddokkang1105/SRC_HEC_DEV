<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<script type="text/javascript">	

	$(document).ready(function(){
		var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll";
		
		$('#FD_FILE_PATH').change(function(){
	        var upfile = $(this).val();
	        
	    	var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
	    	var isCheck = false;
	    	var imgKinds = imgKind.split(' ');
	    	for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
	    
	    	if(isCheck){
	    		$('#txtFilePath').val(""); $('#FD_FILE_PATH').val("");
	    	}else{
	    		$('#txtFilePath').val(upfile.split("\\").reverse()[0]);
	    	}
		 });
		
	});
	
	// [upload] 버튼 클릭
	function fnRequestEvl(){
		if (confirm("${CM00001}")) {
			var url  = "requestEvaluation.do?srID=${srID}&status=${status}&svcCompl=${svcCompl}";
			ajaxSubmit(document.reqEvlFrm, url,"subFrame");
		}
	}
	
	function fnCallBack(srID){
		opener.fnCallBack(srID);
		self.close();
	}
</script>
</head>

<body>
<div style="padding: 10px;">
<form name="reqEvlFrm" id="reqEvlFrm" action="" enctype="multipart/form-data" method="post">
	<div class="cop_hdtitle mgB10">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Request Evaluation</h3>
	</div>
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col width="80%">
		</colgroup>		
		<tr>
			<th class="alignL pdL10">Comment</th>
			<td class="sline tit pdR10 last"><div style="height:120px; overflow: auto;" ><textarea class="edit" id="comment" name="comment" style="width:100%;height:120px;">${srInfo.Comment}</textarea></div></td>
		</tr>
		<tr>
			<th class="alignL pdL10"> ${menu.LN00144}</th>
			<td class="sline tit last" >
				<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload"/>
				<span style="vertical-align:middle; position:relative; width:13px; height:13px; overflow:hidden; cursor:pointer; background:url('${root}${HTML_IMG_DIR}/btn_file_attach.png') 0 4px no-repeat;">
					<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2">
				</span>			
				<input type="hidden" id="FILE_NM" name="FILE_NM"/>
			</td>
		</tr>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Request" type="submit" onclick="fnRequestEvl()"></span>&nbsp;&nbsp;
	</div>
	</form>
</div>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>
