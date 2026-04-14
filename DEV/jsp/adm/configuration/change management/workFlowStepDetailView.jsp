<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${resultMap.LanguageID}', 'Select');
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		
	});
	
	// [Save] click
	function updateWorkFlow() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}
			if (checkConfirm) {
				var url = "admin/updateWorkFlowStep.do";
				ajaxSubmit(document.workFlowViewFrm, url, "blankFrame");
			}
		}
	}
	
	// [List] click
	function goBack() {
		var url = "workFlowStep.do";
		var data = "pageNum=${pageNum}";
		var target = "workFlowStepDiv";
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true) {
			$("#objDeactivated").val("1");
		} else {
			$("#objDeactivated").val("0");
		}
	}
	function CheckBox2(){
		var chk1 = document.getElementsByName("check2");
		if(chk1[0].checked == true) {
			$("#objTransferYN").val("Y");
		} else {
			$("#objTransferYN").val("N");
		}
	}
	
	
	// [언어 선택 ] event
	function thisReload(){
		var url = "workFlowStepDetailView.do"; // 요청이 날라가는 주소
		var data = "WFStepID="+$("#WFStepID").val()
				+ "&languageID="+$("#getLanguageID").val()
				+ "&pageNum=" + $("#currPage").val();
		var target = "workFlowStepDiv";
		ajaxPage(url,data,target);	
	}
	
	// [Rel] click
	function workFlowStepRel(){
		var url = "subTab.do"; // 요청이 날라가는 주소
		var data = "url=workFlowStepRelMenu&filter=${resultMap.WFID}"
					+ "&Name=${resultMap.Name}"
					+ "&pageNum=" + $("#CurrPageNum").val()
					+ "&languageID=" + $("#getLanguageID").val();
		var target = "workFlowTypeDiv";
		ajaxPage(url, data, target);
	}
</script>


<form name="workFlowViewFrm" id="workFlowViewFrm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<input type="hidden" id="WFStepID" name="WFStepID" value="${resultMap.WFStepID}"> 
	<input type="hidden" id="objDeactivated" name="objDeactivated" value="${resultMap.Deactivated}"> 
	<input type="hidden" id="objTransferYN" name="objTransferYN" value="${resultMap.TransferYN}"> 
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Work Flow Step</li>
		<li class="floatR pdR20 pdT10">
			<select id="getLanguageID" name="getLanguageID"onchange="thisReload()"></select>
		</li>
	</div><br>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
		</colgroup>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>
			<td class="viewtop">${resultMap.WFStepID}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop"><input type="text" class="text" id="objName" name="objName" value="${resultMap.Name}" /></td>
			<th class="viewtop">DocCategory</th>
			<td class="viewtop"><input type="text" class="text" id="docCategory" name="docCategory" value="${resultMap.DocCategory}" /></td>
			<th class="viewtop">Description</th>
			<td class="viewtop last"><input type="text" class="text" id="description" name="description" value="${resultMap.Description}" /></td>
		</tr>
		<tr>
			<th>Deactivated</th>
			<td>
				<input type="checkbox" name="check1" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}" onclick="CheckBox1()">
			</td>
			<th>TransferYN</th>
			<td>
				<input type="checkbox" name="check2" <c:if test="${resultMap.TransferYN == 'Y'}">checked="checked"</c:if> value="${resultMap.TransferYN}" onclick="CheckBox2()">
			</td>
			<th>CreationTime</th>
			<td>
				${resultMap.CreationTime}
			</td>
			<th>Creator</th>
			<td>
				${resultMap.CreatorName}
			</td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<!-- <span class="btn_pack medium icon"><span class="list"></span><input value="Allocate steps" type="submit" onclick="workFlowStepRel();"></span> -->
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="goBack()" value="List">List</button>
				    <button class="cmm-btn2 mgR5" style="height: 30px;" onclick="updateWorkFlow();"  value="Save">Save</button>	
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>

<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none;" frameborder="0" scrolling='no'></iframe>
</div>

