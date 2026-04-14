<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		var data = "&category=OJ";
		fnSelect('fromItemTypeCode', data, 'itemTypeCode', '${resultMap.FromItemTypeCode}', 'Select'); 
		fnSelect('toItemTypeCode', data, 'itemTypeCode', '${resultMap.ToItemTypeCode}', 'Select'); 
	});
	
	function editConnectionType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}
	
			if(checkConfirm) {
				var url = "editConnectionType.do";
				ajaxSubmit(document.conTypeViewList, url, "blankFrame");
			}
		}
	
	}

	// [List] click
	function goBack() {
		var url = "DefineConnectionType.do";
		var data =   "&pageNum=" + $("#currPage").val();
		var target = "connectionTypeDiv";
		ajaxPage(url, data, target);
	}


function CheckBox1(){
	var chk1 = document.getElementsByName("check1");
	
	if(chk1[0].checked == true){
		$("#conDeactivated").val("1");
	} else {
		$("#conDeactivated").val("0");
	}
}

function thisReload(){
	var url = "connectionTypeView.do";
	var data   = "LanguageID="+$("#getLanguageID").val()
				+ "&ItemTypeCode="+$("#ItemTypeCode").val() 
				+ "&pageNum=" + $("#currPage").val();
	var target = "connectionTypeDiv";
	ajaxPage(url,data,target);
}

</script>

<form name="conTypeViewList" id="conTypeViewList" action="*" method="post" onsubmit="return false;">	
	<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
		<input type="hidden" id="conDeactivated" name="conDeactivated" value="${resultMap.Deactivated}">
		<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${resultMap.ItemTypeCode}">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
	</div>
			
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Connection Type</li>
		<li class="floatR pdR20 pdT10">
		  <select id="getLanguageID" name="getLanguageID" onchange="thisReload();"></select>
		</li>
	</div><br>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="9%">
			<col width="16%">
			<col width="9%">
			<col width="16%">
			<col width="9%">
			<col width="16%">
			<col width="9%">
			<col width="16%">
		</colgroup>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>
			<td class="viewtop">${resultMap.ItemTypeCode}</td>

			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop" colspan="3">
			<input type="text" class="text" id="conName" name="conName" value="${resultMap.Name}" maxlength="255" /></td>

			<th class="viewtop">
				<c:if test="${!empty resultMap.Icon}"><img src="${root}${HTML_IMG_DIR}/${resultMap.IconImg}"/></c:if>
				<c:if test="${empty resultMap.Icon}">Icon</c:if>
			</th>
			<td class="viewtop last">
				<input type="text" class="text" id="conIcon" name="conIcon" value="${resultMap.Icon}" />
			</td>
			
		</tr>

		<tr>
			<th> FromItemType</th>
			<td>
				<select id="fromItemTypeCode" name="fromItemTypeCode" class="sel" /> 
			</td>
			
			<th>ToItemType</th>
			<td>
				<select id="toItemTypeCode" name="toItemTypeCode" class="sel" /> 
			</td>
			
			<th>RootItemID</th>
			<td class="last"><input type="text" class="text" id="conRootItemId" name="conRootItemId" value="${resultMap.RootItemID}" style="ime-mode:disabled"/></td>
			
			<th>Deactivated</th>
			<td><input type="checkbox" name="check1" 
				<c:if test="${resultMap.Deactivated == '1'}">
					checked="checked"
				</c:if>
				value="${resultMap.Deactivated}" onclick="CheckBox1()"></td>
		</tr>
		<tr>	
			<th>DefArc</th>
			<td><input type="text" class="text" id="conDefArc" name="conDefArc" value="${resultMap.DefArc}"/></td>
				
			<th>${menu.LN00060}</th>
			<td>${resultMap.CreateName}</td>

			<th>${menu.LN00013}</th>
			<td class="last" colspan="3">${resultMap.CreationTime}</td>
		<tr>
			<!--  <th></th>-->
			<td colspan="8" style="height:180px;" class="tit last">
			<textarea id="conDescription" name="conDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack();"></span>
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="editConnectionType();"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

