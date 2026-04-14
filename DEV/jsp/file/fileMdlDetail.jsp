<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00096" var="WM00096"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00097" var="WM00097"/>

<script type="text/javascript">
	
	$(document).ready(function(){

		$("input.datePicker").each(generateDatePicker);
		$('#fltpCode').val("${resultMap.fltpCode}");
		var data = "&itemClassCode="+$('#itemClassCode').val();
		var fltpName = $('#fltpName').val();
		fnSelectNone('fltpCode', data, 'fltpCode', fltpName); 
	});
	
	function fnSave(){
		//if(!confirm("저장하겠습니까?")){ return;}
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		var url  = "saveFileDetail.do";
		ajaxSubmit(document.fileDetailFrm, url,"subFrame");
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		 if($('#fltpCode').val() == ""){
			alert("${WM00096}");
			return false;
		} 
		if($('#uploadFile').val() == ""){
			alert("${WM00097}");
			return false;
		}
			
		return isCheck;
	}
	
	// 삭제 
	function fnDelete(){
		if(confirm("${CM00002}")){
			var url = "deleteFile.do";
			ajaxSubmit(document.fileDetailFrm, url,"subFrame");
		}
	}
	
	// 목록
	function fnGoList(){		
		var url = "goFileMdlMgt.do";
		var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target="subFrame";
		ajaxPage(url, data, target);
	}
	
</script>

<!-- BEGIN :: DETAIL -->
<div>
	<!-- BEGIN :: BOARD_FORM -->
	<form name="fileDetailFrm" id="fileDetailFrm" action="" enctype="multipart/form-data" method="post">
		<input type="hidden" id="userId" 		name="userId" 		value="${sessionScope.loginInfo.sessionUserId}">
		<input type="hidden" id="fileSeq" 		name="fileSeq" 		value="${resultMap.fileSeq}">
		<input type="hidden" id="usergroupId" 	name="usergroupId" 	value="${resultMap.usergroupId}">
		<input type="hidden" id="isNew" 		name="isNew" 		value="${resultMap.isNEW}">
		<input type="hidden" id="SysFile" 		name="SysFile" 		value="${resultMap.sysFile}" >
		<input type="hidden" id="ItemID" 		name="ItemID" 		value="${resultMap.itemID}">
		<input type="hidden" id="fltpName" 		name="fltpName" 	value="${resultMap.fltpName}">
		<input type="hidden" id="itemClassCode" name="itemClassCode" value="${resultMap.itemClassCode}">
		<input type="hidden" id="fileMgt" 		name="fileMgt" 		value="ITM">

	<div id="boardDiv" class="hidden" style="width:100%;height:400px;">
		<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="25%">
				<col>
				<col width="25%">
				<col>
			</colgroup>		
			<c:if test="${isNEW == 'N'}">
			<tr>
				<th  class="sline">${menu.LN00060}</th>
				<td id="TD_WRITE_USER_NM">
					${resultMap.WriteUserNM}
				</td>
			</tr>
			<tr>
				<th  class="sline">${LN00013}</th>
				<td class="tdend" style="width:25%; padding:5px;" align="left" >${resultMap.creationTime}
				</td>
			</tr>
			</c:if>
			<tr style="height:100px">
				<th>${menu.LN00101}</th>
				<td class="sline tit">
					<input type="file" name='uploadFile' id='uploadFile' OnChange="fnSetFileName()">
				</td>
			</tr>
			<tr>
				<th>${menu.LN00091}</th>
				<td class="sline tit">
					<select id="fltpCode" name="fltpCode" style="width:180px;" ></select>
					<input type="hidden" class="text" id="fileType" name="fileType" value="${resultMap.fltpCode}" size="60" />
				</td>
			</tr>
		</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN">
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="button" onclick="fnSave()"></span>&nbsp;&nbsp;
			<c:if test="${isNEW == 'N'}">
				<span id="viewDel"  class="btn_pack medium icon"><span class="delete"></span><input value="Del" type="button" onclick="fnDelete()"></span>&nbsp;&nbsp;
			</c:if>
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="button"  onclick="fnGoList(true)"></span>
		</div>
	<!-- END :: Button -->
	</div>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>