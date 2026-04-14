<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	$(document).ready(function() {
		var data = "&languageID=${languageID}&menuCat=ATR";
		fnSelect('link', data, 'getMenuType', '${Link}', 'Select');
	});
	
	function SaveSortNum(){
		if(confirm("${CM00001}")){	
			var url = "SaveSortNum.do";
			ajaxSubmit(document.SubSortNumList, url,"ArcFrame");
		}
	}
	
	function SubAttrReload(){
		console.log("succsess!");
		var url = "SubAttributeTypeAllocation.do";
		var data = "&languageID=${languageID}&s_itemID=${ItemClassCode}&ClassName=${ClassName}"
			+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		var target = "SubAttrTypeList"
	 	ajaxPage(url,data,target);
	}
	 
	function checkMandatory(){
		var chk = document.getElementsByName("chk1");
		if(chk[0].checked == true){
			$("#objMandatory").val("1");
		} else {
			$("#objMandatory").val("0");
		}
	}
	
	function checkInvisible(){
		var chk = document.getElementsByName("chk2");
		if(chk[0].checked == true){
			$("#objInvisible").val("1");
		} else {
			$("#objInvisible").val("0");
		}
	}

</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="SubSortNumList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
		<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${ItemClassCode}">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode" value="${AttrTypeCode}">
		<input type="hidden" id="objMandatory" name="objMandatory" value="${Mandatory}">
		<input type="hidden" id="objInvisible" name="objInvisible" value="${Invisible}">
	    <div class="mgT10">
		<table id="newObject" class="tbl_blue01" width="100%" border="0" >
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="7.5%">
				<col width="5%">		
				<col width="7.5%">
				<col width="5%">				
			</colgroup>
			<tr>
				<th class="viewtop">Link</th>
				<td class="viewtop"><select id="link" name="link" style="width:100%;" ></select></td>
				<th class="viewtop">VarFilter</th>
				<td class="viewtop"><input type="text" class="text" id="varFilter" name="varFilter" value="${varFilter}"/></td>
				<th class="viewtop">Allocation</th>
				<td class="viewtop">
					<select id="allocationType" name="allocationType" style="width:100%;" >
						<option value="">Select</option>
						<option value="MST" <c:if test="${allocationType == 'MST'}">selected</c:if>>Master</option>
						<option value="REF" <c:if test="${allocationType == 'REF'}">selected</c:if>>Reference</option>
					</select>
				</td>
				<th class="viewtop">Mandatory</th>
				<td class="viewtop"><input type="checkbox" id="chk1" name="chk1"
					<c:if test="${Mandatory == '1'}">
						checked="checked"
					</c:if> 
					value="${Mandatory}" onclick="checkMandatory()">
				</td>
				<th class="viewtop">Invisible</th>
				<td class="viewtop last"><input type="checkbox" id="chk2" name="chk2"
					<c:if test="${Invisible == '1'}">
						checked="checked"
					</c:if> 
					value="${Invisible}" onclick="checkInvisible()">
				</td>
			</tr>
			<tr>
				<th>Sort No.</th>
				<td><input type="text" class="text" id="objsortNum" name="objsortNum" value="${SortNum}"/></td>
				<th>RowNum</th>
				<td><input type="text" class="text" id="rowNum" name="rowNum" value="${rowNum}"/></td>
				<th>ColumnNum</th>
				<td><input type="text" class="text" id="columnNum" name="columnNum" value="${columnNum}"/></td>
				<th colspan="2">Height</th>
				<td colspan="2" class="last"><input type="text" class="text" id="areaHeight" name="areaHeight" value="${areaHeight}"/></td>
			</tr>
		</table>	
	</div>
	<div class="alignBTN">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="SaveSortNum()"></span>
		</c:if>
	</div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</div>
</html>