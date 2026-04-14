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
			var url  = "updateModel.do";
			ajaxSubmit(document.objectInfoFrm, url,"subFrame");
		}
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
	
</script>
</head>
<body >	
	<form name="objectInfoFrm" id="objectInfoFrm" action="saveObjectInfo.do" method="post" onsubmit="return false;">
	<div id="objectInfoDiv" class="hidden" style="width:98%;height:220px;padding:0 10px 0 10px;">
		<table class="tbl_blue01 mgT10" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">	
				<col width="15%">			
			</colgroup>		
			<tr>
				<th width="10%" >${menu.LN00028}</th>
				<td width="15%" align="left">
					<input type="text" id="Name" name="Name" value="${modelInfo.ModelName}"  class="text"  style="width:99%;margin-left=0px;">	
					<input type="hidden" id="ModelID" name="ModelID" value="${modelInfo.ModelID}"  class="text">	
				</td>
				<th width="10%" style="word-break:break-all">${menu.LN00032}</th>
				<td width="15%" align="left">${modelInfo.ModelTypeName}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00033}</th>
				<td width="15%" align="left"  >
					<select id="MTCTypeCode" name="MTCTypeCode" class="sel" style="width:100%;margin-left=5px;"></select>
				</td>
				<th width="10%" style="word-break:break-all">${menu.LN00027}</th>
				<td width="15%" align="left" class="last">
					<select id="MdlStatus" name="MdlStatus" class="sel" style="width:100%;margin-left=5px;"></select>
				</td>
			</tr>
			<tr>
				<th width="10%" style="word-break:break-all">${menu.LN00060}</th>
				<td width="15%" align="left">${modelInfo.CreatorNm}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00013}</th>
				<td width="15%" align="left">${modelInfo.CreationTime}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00105}</th>
				<td width="15%" align="left">${modelInfo.LastUserNm}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00070}</th>
				<td width="15%" align="left"  class="last">${modelInfo.LastUpdated}</td>
			</tr>			
			<tr>
				<th width="10%" style="word-break:break-all">Valid From</th>
				<td width="15%" align="left">
					<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<font> <input type="text" id="ValidFrom" name="ValidFrom" value="${modelInfo.ValidFrom}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>					
				</td>
				<th width="10%" style="word-break:break-all">Valid To</th>
				<td width="15%" align="left">
					<font> <input type="text" id="ValidTo"	name="ValidTo" value="${modelInfo.ValidTo}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
				</td>
				<th width="10%" style="word-break:break-all">Blocked</th>
				<td width="15%" align="left">
					<input type="checkbox" id="Blocked" name="Blocked" value="${modelInfo.ModelBlocked}"
					<c:if test="${modelInfo.ModelBlocked == '1'}">
							checked="checked"
						</c:if> disabled></td>
				<th width="10%" style="word-break:break-all">Public</th>
				<td width="15%" align="left"  class="last">
					<input type="checkbox" id="IsPublic" name="IsPublic" value="${modelInfo.IsPublic}"
					<c:if test="${modelInfo.IsPublic == '1'}">
							checked="checked"
						</c:if>  onclick="doIsPublicChecked()">
				</td>
			</tr>
			<tr>
				<th width="10%">${menu.LN00035}</th>
				<td width="90%" colspan="7" class="last">
					<textarea class="edit" id='description' name='description' style="width:100%;height:112px;">${modelInfo.Description}</textarea>
				</td>
			</tr>
		</table>
		<div class="alignBTN" id="divUpdateModel" >
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="updateModel()"  type="submit"></span>			
		</div>
	
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</div>
</body>
</html>