<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<head>

<script type="text/javascript">
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		var ItemTypeCode = "${ItemTypeCode}";
		var data = "&ItemTypeCode="+ItemTypeCode;
		
		fnSelectNone('MTCTypeCode', '', 'MTCTypeCode', '${modelInfo.MTCategory}');
		$("#MTCTypeCode").disabled=true;
		
		fnSelect('MdlStatus', '&Category=MDLSTS', 'CategroyTypeCode', '${modelInfo.Status}');
		
	});
	
	function updateModel(){	
		if(confirm("${CM00001}")){
			doBlockedChecked();
			doIsPublicChecked();
			doIsModelChecked();
			var url  = "updateModel.do";
			ajaxSubmit(document.objectInfoFrm, url,"subFrame");
		}
	}
	
	function reloadModel(){
		fnGoModelInfo('view');	
	}
		
	function doBlockedChecked(){		
		if ($("input:checkbox[id='Blocked']").is(":checked") == true){
			$("#Blocked").val(1);
		}else{
			$("#Blocked").val(0);
		}
	}
	
	function doIsPublicChecked(){		
		if ($("input:checkbox[id='IsPublic']").is(":checked") == true){
			$("#IsPublic").val(1);
		}else{
			$("#IsPublic").val(0);
		}
	}
	
	function doIsModelChecked(){		
		var selectedValue = $("#IsModel").val();
	}

	
	function fnpopupMaterMdlEdt() {
		var url = "popupMasterMdlEdt.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID=${s_itemID}"
			+"&modelID=${modelInfo.RefModelID}"
			+"&scrnType=view";
			
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
</script>
</head>
<body >	
	<form name="objectInfoFrm" id="objectInfoFrm" action="saveObjectInfo.do" method="post" onsubmit="return false;">
	<div id="objectInfoDiv" class="hidden" style="padding:0 10px;">
		<table class="tbl_blue01 mgT10" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="20%">
				<col width="8%">
				<col width="14%">	
			</colgroup>		
			<tr>
				<th>${menu.LN00367}</th>
				<td>
					<input type="text" id="Name" name="Name" value="${modelInfo.ModelName}"  class="text"  style="width:99%;margin-left=0px;">	
					<input type="hidden" id="ModelID" name="ModelID" value="${modelInfo.ModelID}"  class="text">	
				</td>
				<th>${menu.LN00032}</th>
				<td>${modelInfo.ModelTypeName}</td>
				<th>${menu.LN00033}</th>
				<td>
					<select id="MTCTypeCode" name="MTCTypeCode" class="sel" style="width:100%;margin-left=5px;"></select>
				</td>
				<th>${menu.LN00027}</th>
		     	<td class="last">
					<select id="MdlStatus" name="MdlStatus" class="sel" style="width:100%;margin-left=5px;"></select>
				</td>
			</tr>			
			<tr>
				<th>Version</th>
				<td>${modelInfo.Version}</td>
				<th>${menu.LN00368}</th>
				<td <c:if test="${modelInfo.RefModelName ne 'N/A'}"> style="text-decoration: underline; cursor:pointer;" onClick="fnpopupMaterMdlEdt()"</c:if>>
					${modelInfo.RefModelName}
				</td>
				<th>Valid From/To</th>
				<td>
					<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
					 <input type="text" id="ValidFrom" name="ValidFrom" value="${modelInfo.ValidFrom}"	class="text datePicker" size="8"
							style="width: 90px; margin-right: 10px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
										
					 <input type="text" id="ValidTo"	name="ValidTo" value="${modelInfo.ValidTo}"	class="text datePicker" size="8"
							style="width: 90px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
				</td>
				<th>Is Model</th>
				<td class="last">
				  <select id="IsModel" name="IsModel">
				    <option value="0" <c:if test="${modelInfo.IsModel == '0'}">selected="selected"</c:if>>N</option>
				    <option value="1" <c:if test="${modelInfo.IsModel == '1'}">selected="selected"</c:if>>Y</option>
				    <option value="2" <c:if test="${modelInfo.IsModel == '2'}">selected="selected"</c:if>>2</option>
				  </select>
				</td>
			</tr>
				<tr>
				<th>${menu.LN00105}</th>
				<td>${modelInfo.LastUserNm}</td>
				<th>${menu.LN00070}</th>
				<td>${modelInfo.LastUpdated}</td>
				<th>${menu.LN00200}</th>
				<td>${modelInfo.CreatorNm}</td>
				<th>${menu.LN00013}</th>
				<td  class="last">${modelInfo.CreationTime}</td>
			</tr>
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="7" class="last">
					<textarea class="edit" id='description' name='description' style="width:100%;height:112px;">${modelInfo.Description}</textarea>
				</td>
			</tr>
		</table>
		<div class="alignBTN" id="divUpdateModel" >
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="updateModel()"  type="submit"></span>			
			<span class="btn_pack medium icon"><span  class="cancel"></span><input value="Cancel" onclick="reloadModel()"  type="submit"></span>			
		</div>
	
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</div>
</body>
</html>