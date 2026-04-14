<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00065" var="WM00065"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Object"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="From Type"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="To Type"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		$('#fromTypeCode').change(function(){changeFromToType();});
		$('#toTypeCode').change(function(){changeFromToType();});
		
	});
	
	function changeFromToType() {
		var fromType = $("#fromTypeCode").val();
		var toType = $("#toTypeCode").val();
		var fromTypeText = $("#fromTypeCode option:selected").text();
		var toTypeText = $("#toTypeCode option:selected").text();
		
		if (fromType != '' && toType != '') {
			fromType = fromType.substring(5,7);
			toType = toType.substring(5,7);
			$("#connectionTypeId").val("CN0" + fromType + toType);
			$("#connectionTypeName").val(fromTypeText + " - " + toTypeText);
		}
		
	}

	function saveConType() {
		// [필수 체크]
		if($("#fromTypeCode").val() == ""){
			alert("${WM00025_1}");
			return false;
		}
		if($("#toTypeCode").val() == ""){
			alert("${WM00025_2}");
			return false;
		}
		
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){
			var url = "saveConType.do";
			ajaxSubmit(document.addConnectionFrm, url, "saveFrame");
		}	
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.urlReload();
		self.close();
	}
	
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="addConnectionFrm" id="addConnectionFrm" action="#" method="post" onsubmit="return false;">
	    <div class="mgT5 mgL5 mgR5">	 
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="38%">
			</colgroup>
			<!-- 항목유형 -->
			<tr>
				<th class="viewtop">From Type</th>
				<td class="viewtop">
					<select id="fromTypeCode" name="fromTypeCode" style="margin-left:5px;">
						<option value="">Select</option>
						<c:forEach var="i" items="${itemTypeCodeList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>				
					</select>
				</td>
				<th class="viewtop">To Type</th>
				<td class="last viewtop">
					<select id="toTypeCode" name="toTypeCode" style="margin-left:5px;">
						<option value="">Select</option>
						<c:forEach var="i" items="${itemTypeCodeList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>				
					</select>
				</td>
			</tr>
			<!-- ID -->		
			<tr>
				<th>${menu.LN00015}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="connectionTypeId" name="connectionTypeId" maxlength="10" readonly="readonly"/>
				</td>
			</tr>
			<!-- 명칭 -->
			<tr>
				<th>${menu.LN00028}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="connectionTypeName" name="connectionTypeName" />
				</td>
			</tr>
			<!-- 개요 -->
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="description" name="description">
				</td>
			</tr>
		</table>
    </div>

		<div class="alignBTN">
			&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveConType()"></span>
		</div>

	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>