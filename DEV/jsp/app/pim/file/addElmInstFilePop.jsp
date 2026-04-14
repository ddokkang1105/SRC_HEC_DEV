<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00144}"/>

<script type="text/javascript">
	var elmInstNo = "${elmInstNo}";
	var elmItemID = "${elmItemID}";
	var instanceClass = "${instanceClass}";
	var refFileID = "${seq}";
	var FltpCode = "${FltpCode}";

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
		
		$("#send").click(function() {
			doFileUpload();
		});
	});

	// [upload] 버튼 클릭
	function doFileUpload(){
		if( $('#txtFilePath').val() == '') {
			//alert('파일을 선택해 주세요');
			alert('${WM00041_1}');
			return false;
		}
		if (confirm("${CM00001}")) {
			var url  = "saveElmInstFile.do?elmInstNo="+elmInstNo+"&elmItemID="+elmItemID+"&instanceClass="+instanceClass+"&refFileID="+refFileID+"&FltpCode="+FltpCode;
			ajaxSubmit(document.uploadFrm, url,"subFrame");
		}
	}
	
	function selfClose(){
		opener.fnCallBack();
		self.close();
	}
</script>
<form name="uploadFrm" id="uploadFrm" action="saveScrFile.do" enctype="multipart/form-data" method="post" onsubmit="return false;">
	<div id="objectInfoDiv" class="hidden" style="width:100%;">
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png"><span>&nbsp;&nbsp;Upload File</span></p>
		</div>
		<ul id="breadcrumb">
	        <li><span>Select file</span></li>
	    </ul>
		<div id="editArea" style="width:95%;" >
			<table class="tbl_preview mgL10 mgR10" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="25%">
					<col width="75%">
				</colgroup>
				<tr>
					<%-- <th>${menu.LN00076}</th> --%>
					<th>Comment</th>
					<td>
						<textarea class="txt_file_upload" name="comment" style="width:416px;height:100px;resize: none;">${Description}</textarea>
					</td>
				</tr>
				<tr>
					<th>${menu.LN00144}</th>
					<td>
						<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload mgR5" style="width:395px;height:25px;"/>
						<span style="vertical-align:middle; position:relative; width:13px; height:13px; overflow:hidden; cursor:pointer; background:url('${root}${HTML_IMG_DIR}/btn_file_attach.png') 0 4px no-repeat;">
							<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2">
						</span>			
						<input type="hidden" id="FILE_NM" name="FILE_NM"/>
					</td>
				</tr>
			</table>
			<div id="btnSave" class="alignBTN" >
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="send"></span>
			</div>
		</div>
	</div>
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>