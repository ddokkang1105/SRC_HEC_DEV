<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<!-- 1. Include CSS/JS -->

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;width:95%;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00144}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00145}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="${menu.LN00146}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_4" arguments="${menu.LN00147}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_5" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00071" var="WM00071"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00020" var="CM00020"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00021" var="CM00021"/>


<script type="text/javascript">
	var p_excelGrid;				//그리드 전역변수
	var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll txt";    
	
	$(document).ready(function(){
		
		$("#send").click(function() {
			doFileUpload();
		});
		
		$("#save").click(function() {
			doSave();
		});
		
		 $('#FD_FILE_PATH').change(function(){
		     var upfile = $(this).val();
	        
	    	 var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
	    	 var isCheck = false;
	    	 var imgKinds = imgKind.split(' ');
	    	 for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
	    	
	    	 if(isCheck){
	    	 	 $('#txtFilePath').val(""); $('#FD_FILE_PATH').val("");
	    	 }else{
	    		 $('#txtFilePath').val( upfile );
	    	 }
		    	
		 });
		 
		 $('#reportLanguage').change(function(){
			 changeLanguage($(this).val());
		 });
		 
		 //fnSelect('language', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select'); 
	});
	
	//function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//그리드 초기화
	function gridInit(){
		var d = setGridDataForAdd();
		
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");
	}
	
	function setGridDataForAdd(){
		var result = new Object();
		result.title = "${title}";
		result.key = "aa";
		result.header = "${menu.LN00024},itemID,attrTypeCode,languageID,targetText,revisionNo";
		result.cols = "itemID|attrTypeCode|languageID|targetText|revisionNo";
		result.widths = "50,80,80,80,80,80,80";
		result.sorting = "str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";

		return result;
	}
	
	//타겟 데이타 업로드
	function doFileUpload() { 
		var url = "tranAttrExcelUpload.do";		
		if( confirm('${CM00020}') ) {
			ajaxSubmitNoAdd(document.commandMap, url, "saveFrame");
		}
	}
	
	function doCntReturn(tCnt, vCnt, fileId, result, errMsgYN, fileName, downFile){ 
		$("#divSave").attr("style", "display:done");
		$("#TOT_CNT").val(tCnt);
		
		if(errMsgYN=="Y"){ 
			$('#original').val(fileName);
			$('#filename').val(fileName);
			$('#downFile').val(downFile);
			$('#errMsgYN').val(errMsgYN);
		}
		if(result.length > 0){	 
			gridInit();
			p_excelGrid.clearAll();
			var result = eval('(' + result + ')');
			p_excelGrid.parse(result,"json");
		}
	}
	
	function doSave(){		
		fnFetchSelectedCol(p_excelGrid, 0, document.commandMap);
		var url = "saveTranAttrExcel.do";
		if( confirm("${WM00071}" + "${CM00021}")) {
			ajaxSubmitNoAdd(document.commandMap, url);	
		}		
	}
	
	function doFileDown(){
		var url = "${root}dsFileDown.do";
		ajaxSubmitNoAdd(document.fileDown, url);
	}
	
	
	function errorTxtDown(fileName, downFile) {
		var url = "fileDown.do";		
		/* $('#original').val(fileName);
		$('#filename').val(fileName);
		$('#downFile').val(downFile);	 */	
		ajaxSubmitNoAlert(document.commandMap, url);
	}
	
	function fnCallBack(){ 
		var errMsgYN = $("#errMsgYN").val();		
		if(errMsgYN=="Y"){	errorTxtDown(); 
		}else{		
			opener.doSearchList();
			self.close();
		}
	}
	
</script>
<body>
<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Select excel file</p>
	</div>
<form name="commandMap" id="commandMap" enctype="multipart/form-data" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="original" name="original" value="">
<input type="hidden" id="filename" name="filename" value="">
<input type="hidden" id="downFile" name="downFile" value="">
<input type="hidden" id="attrList" name="attrList" value="">
<input type="hidden" id="jsonObject" name="jsonObject" value="">
<input type="hidden" id="errMsgYN" name="errMsgYN" value="" >
<input type="hidden" id="scrnType" name="scrnType" value="excel" >
	<div id="framecontent" class="mgT10">	
		<table width="100%" border="0" cellspacing="10" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>		
			<tr>
				<th class="pdB5 pdT5" style="text-align:left;">Select File</th>
			    <td class="pdB5 pdT5">
					<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload" style="width:270px;"/>
					<span style="vertical-align:middle; position:relative; width:13px; height:13px; overflow:hidden; cursor:pointer; background:url('${root}${HTML_IMG_DIR}/btn_file_attach.png') no-repeat;">
						<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2">
					</span>	
					<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="submit" id="send"></span>
					<input type="hidden" id="FILE_NM" name="FILE_NM"/>
				</td>
			</tr>
			<tr>
				<th style="text-align:left;">Total Count</th>
				<td>
					<input type="text" class="text" readonly onfocus="this.blur()" id="TOT_CNT" name="TOT_CNT" style="width:100px;"/>
					
				</td>
			</tr>
		</table>
	</div>
	<div id="divSave" class="alignBTN" style="display:none">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="save"></span>
	</div>
	<div class="file_search_list" style="display:none;">
		<div id="excelGridArea" style="height:190px;width:100%"></div>
	</div>
	
</form>	
</body>	
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
 </html>
 