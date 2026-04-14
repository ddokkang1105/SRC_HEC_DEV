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
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&menuCat=WF";
		fnSelect('menuID', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		fnSelect('category', '&Category=DOCCAT', 'dictionyCode',  '${resultMap.Category}', 'Select');
		fnSelect('mandatoryGRID', '&wfadmin=Y&active=0', 'getUserGroupList', '${resultMap.MandatoryGRID}', 'Select');
		fnSelect('endGRID', '&wfadmin=Y&active=0', 'getUserGroupList', '${resultMap.EndGRID}', 'Select');
		
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
				var url = "updateWorkFlow.do";
				ajaxSubmit(document.workFlowViewFrm, url, "blankFrame");
			}
		}
	}
	
	// [List] click
	function goBack() {
		var url = "workFlowType.do";
		var data = "pageNum=${pageNum}";
		var target = "workFlowTypeDiv";
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
		var chk1 = document.getElementsByName("agreementYN");
		if(chk1[0].checked == true) {
			$("#objAgreementYN").val("Y");
		} else {
			$("#objAgreementYN").val("N");
		}
	}
	
	
	// [언어 선택 ] event
	function thisReload(){
		var url = "workFlowDetailView.do"; // 요청이 날라가는 주소
		var data = "WFID="+$("#objWFID").val()
				+ "&languageID="+$("#getLanguageID").val()
				+ "&pageNum=" + $("#currPage").val();
		var target = "workFlowTypeDiv";
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
	
	function fnAllocMenu(){
		var url = "wfAllocationMenu.do";
		var data ="wfID="+$("#objWFID").val();
		var target = "workFlowViewFrm";
		ajaxPage(url, data, target);
	}
	
</script>


<form name="workFlowViewFrm" id="workFlowViewFrm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="objWFID" name="objWFID" value="${resultMap.WFID}"> 
	<input type="hidden" id="objDeactivated" name="objDeactivated" value="${resultMap.Deactivated}"> 
	<input type="hidden" id="objAgreementYN" name="objAgreementYN" value="${resultMap.AgreementYN}"> 
	<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Work Flow</li>
		<li class="floatR pdR20 pdT10">
			<select id="getLanguageID" name="getLanguageID"onchange="thisReload()"></select>
		</li>
	</div><br>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="12%">
			<col width="18%">
			<col width="12%">
			<col width="18%">
			<col width="12%">
			<col width="18%">
			<col width="12%">
			<col width="18%">
		</colgroup>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>
			<td class="viewtop">${resultMap.WFID}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop"><input type="text" class="text" id="objName" name="objName" value="${resultMap.Name}" /></td>
			<th class="viewtop">${menu.LN00033}</th>
			<td class="viewtop"><select id="category" Name="category" style="width:100%"></select></td>
			<th class="viewtop">Deactivated</th>
			<td class="viewtop last">
			<input type="checkbox" name="check1" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}" onclick="CheckBox1()">
			</td>			
		</tr>
		<tr>
			<th>URL</th>
			<td><input type="text" class="text" id="wfURL" name="wfURL" value="${resultMap.WFURL}" /></td>
			<th>Post Processing</th>
			<td><input type="text" class="text" id="postProcessing" name="postProcessing" value="${resultMap.PostProcessing}" /></td>
			<th >Ext. Service Code</th>
			<td><input type="text" class="text" id="serviceCode" name="serviceCode" value="${resultMap.ServiceCode}" /></td>
			<th>Agreement Y/N</th>
			<td class="last">
			<input type="checkbox" name="agreementYN" <c:if test="${resultMap.AgreementYN == 'Y'}">checked="checked"</c:if> value="${resultMap.AgreementYN}" onclick="CheckBox2()">
			</td>
		</tr>
		<tr>
			<th>Management GR.</th>
			<td><select id="mandatoryGRID" name="mandatoryGRID" style="width:100%"></select></td>
			<th>Final approval GR.</th>
			<td><select id="endGRID" name="endGRID" style="width:100%"></select></td>
			<th>${menu.LN00105}</th>
			<td>${resultMap.LastUserName}</td>
			<th>${menu.LN00070}</th>
			<td>${resultMap.LastUpdated}</td>
		</tr>
		<tr>
			<td colspan="8" style="height:180px;" class="tit last">
			<textarea id="objDescription" name="objDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"><span class="allocation"></span><input value="Allocation" type="submit" onclick="fnAllocMenu()"></span>
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack();"></span>
					<span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="updateWorkFlow();"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>

<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none;" frameborder="0" scrolling='no'></iframe>
</div>

