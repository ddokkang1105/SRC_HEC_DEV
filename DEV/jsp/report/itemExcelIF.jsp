<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include CSS/JS -->

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;width:95%;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

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
		$(".option").hide();
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
		 
		 fnSelect('reportLanguage', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select Language');
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===================================================================
	//타겟 데이타 업로드
	function doFileUpload() { 
		var url = "itemExcelIFUpload.do";
		// 선택된 라디오 버튼 value 취득
		fnGetRadioValue('radioUpload', 'uploadTemplate');
		fnGetRadioValue('radioOption', 'uploadOption');
		
		// 화면에서 선택된 업로드 내용, 옵션 , 파일 패스 등을 체크
		if (!checkInputValue()) {
			return;
		}
		
		if( confirm('${CM00020}') ) {
			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxSubmitNoAdd(document.commandMap, url, "blankFrame");
		}
	}
	
	function checkInputValue() {
		if( $('#txtFilePath').val() == '') {
			alert('${WM00041_1}');
			return false;
		}
		
		if($('#uploadTemplate').val() == 0) {
			alert('${WM00041_2}');
			return false;
		} else if($('#uploadTemplate').val() == 1) {
			if( $('#csrInfo').val() == "") {
				alert("${WM00041_5}");
				return false;
			}
		} else if($('#uploadTemplate').val() == 2) {
			if( $('#uploadOption').val() == 0) {
				alert('${WM00041_3}');
				return false;
			} else {
				if ($('#uploadTemplate').val() == 2 && $('#reportLanguage option:selected').text() == "Select Language") {
					alert('${WM00041_4}');
					return false;
				}
			}
		}
		
		return true;
	}

	function doCntReturn(tCnt, vCnt, aCnt, type, fileId, errMsgYN, fileName, downFile){ 
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		$("#TOT_CNT").val(tCnt);
		$("#FILE_VALD_CNT").val(vCnt);
		$("#FILE_NM").val(fileId);
		$("#ATTR_CNT").val(aCnt);
		if(errMsgYN=="Y"){ 
			$('#original').val(fileName);
			$('#filename').val(fileName);
			$('#downFile').val(downFile);
			$('#errMsgYN').val(errMsgYN);
		}
		callExcelIF();
		
	}
	
	function errorTxtDown(fileName, downFile) {
		var url = "fileDown.do";
		ajaxSubmitNoAlert(document.commandMap, url);
	}
	
	//===================================================================

	function doSaveReturn(){
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
		$("#divSave").attr("style", "display:none");
		var errMsgYN = $("#errMsgYN").val();
		
		if(errMsgYN=="Y"){
			errorTxtDown();
		}
	}
	
	//===================================================================
	//선택된 라디오 버틈 value 취득
	function fnGetRadioValue(radioName, hiddenName) {
		var radioObj = document.all(radioName);
		var isChecked = false;
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				$('#' + hiddenName).val(radioObj[i].value);
				isChecked = true;
				break;
			}
		}
		
		if (!isChecked) {
			$('#' + hiddenName).val(0);
		}
	}
	
	function radioOnChangeEvent(value) {
		if (value == 2) {
			document.getElementById("reportLanguage").disabled = false;
			$(".option").show();
		} else {
			$(".option").hide(); $("#option02").attr('checked',true);
			document.getElementById("reportLanguage").disabled = true;
		}
	}
	
	// [HR Interface] click
	function callExcelIF(){
		var url = "callExcelIF.do";
		if( confirm("${WM00071}" + "${CM00021}")) {
			$('#selectedLang').val($('#reportLanguage option:selected').val());

			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxSubmitNoAdd(document.commandMap, url, "blankFrame");	
		}		
	}

	
</script>

<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}img_circle.gif"/>
</div>
<form name="commandMap" id="commandMap" enctype="multipart/form-data" action="itemExcelSave.do" method="post" onsubmit="return false;">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
<input type="hidden" id="option" name="option" value="${option}"/>
<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
<input type="hidden" id="selectedLang" name="selectedLang" value=""/>
<input type="hidden" id="uploadTemplate" name="uploadTemplate" value=""/>
<input type="hidden" id="uploadOption" name="uploadOption" value=""/>
<input type="hidden" id="ATTR_CNT" name="ATTR_CNT" value="">

<input type="hidden" id="original" name="original" value="">
<input type="hidden" id="filename" name="filename" value="">
<input type="hidden" id="downFile" name="downFile" value="">
<input type="hidden" id="errMsgYN" name="errMsgYN" value="">
<input type="hidden" id="scrnType" name="scrnType" value="excel">
	
	<!-- start -->
	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">
			</colgroup>
			<tr>
				<!-- 업로드 내용 -->
				<th class="pdB5" style="text-align:left;">${menu.LN00145}</th>
				<td colspan="3" class="pdB5">
					<input type="radio" name="radioUpload" value=1 onchange="radioOnChangeEvent(1)">&nbsp;Create Items&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=2 onchange="radioOnChangeEvent(2)">&nbsp;Update attributes&nbsp;&nbsp;
					</td>
			</tr>
			<tr class="option">
				<!-- 업로드 Option -->
				<th class="pdB5" style="text-align:left;">${menu.LN00146}</th>
				<td class="pdB5">
					<input type="radio" name="radioOption" value=1>&nbsp;With ItemID&nbsp;&nbsp;
					<input type="radio" name="radioOption" id="option02" value=2>&nbsp;With Identifier&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<!-- 업로드 언어 -->
				<th class="pdB5" style="text-align:left;">CSR</th>
				<td class="pdB5">
					<select id="csrInfo" name="csrInfo" class="sel" style="height:22px;width:180px">
						<option value=""></option>
						<c:forEach var="i" items="${csrOption}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>				
					</select>
				</td>
				<th style="text-align:left;">${menu.LN00147}</th>
				<td>
					<select name="reportLanguage" id="reportLanguage" class="text" onchange="changeLanguage($(this).val())" style="height:22px;width:120px" disabled="disabled"></select>
				</td>
			</tr>
			<tr>
				<th class="pdB5" style="text-align:left;">Select File</th>
				<td colspan="3" class="pdB5">
					<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload"/>
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
					<input type="text" class="text" readonly onfocus="this.blur()" id="TOT_CNT" name="TOT_CNT"/>
				</td>
				<th style="text-align:left;">Valid Item Count</th>
				<td>
					<input type="text" class="text" readonly onfocus="this.blur()" id="FILE_VALD_CNT" name="FILE_VALD_CNT"/>
				</td>
			</tr>
		</table>
	</div>
	<!-- 타겟 end -->
</form>	
 
 
 <div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
 