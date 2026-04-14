<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">
$(document).ready(function(){		
	$("input.datePicker").each(generateDatePicker);
	document.getElementById('editArea').style.height = (setWindowHeight() - 45)+"px";	
	//var paramArray = window.opener.dialogArguments;
	//$('#items').val(paramArray[0]);
	$("#items").val(opener.$("#items").val());
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function changeItemTypeCode(avg, avg2){
	var url    = "getSelectOption.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들
				+"&s_itemID="+avg
				+"&itemID=${s_itemID}";
	var target = avg; // avg;             // selectBox id
	var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
	var isAll  = "";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	ajaxSelect(url, data, target, defaultValue, isAll);
}

function saveObjAttrInfo(){
	if(confirm("${CM00001}")){
		fnSetMLovValue();
		ajaxSubmit(document.childFrm, "saveCheckedObjAttr.do");
	}
}

function fnSetMLovValue(){
	var mLovCode = "";
	var AttrTypeValue;
	var mLovCodeValue;
	var k;
	var dataType = "";
	<c:forEach var="i" items="${getList}" varStatus="iStatus">
	    AttrTypeValue = new Array;
	    mLovCodeValue = new Array;
	    k=0;
	    dataType = "${i.DataType}"; 
		<c:if test="${i.DataType == 'MLOV'}" >
			<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
				mLovCode = "${mLovList.AttrTypeCode}"+"${mLovList.CODE}";
				var checkObj = document.all(mLovCode);
				if (checkObj.checked) {
					AttrTypeValue[k] = $("#"+mLovCode).val();
					mLovCodeValue[k] = $("#"+mLovCode).val();
					k++;
				}				
			</c:forEach>
			$("#"+"${i.AttrTypeCode}").val(mLovCodeValue);
		</c:if>
	</c:forEach>
}

function actionComplet() {
	window.close();
	window.opener.selfClose();
}

function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
	if(subAttrCode != "" && subAttrCode != null){			
		var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
		fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
	}
}

</script>
<form name="childFrm" id="childFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="items" name="items"  value="" />
	<input type="hidden" id="attrCode" name="attrCode"  value="${attrCode}" />
	<input type="hidden" id="classCodes" name="classCodes"  value="${classCodes}" />
	
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:300px;">	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00031}</p>
	</div>
	<div id="editArea" style="overflow:auto;margin-bottom:5px;overflow-x:hidden;padding:0 0 0 20px;">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;width:98%;" >
			<colgroup>
				<col width="15%">
				<col>
			</colgroup>
			<!-- AttrList is null -->
			<c:if test="${fn:length(getList) eq 0 }">
				<tr>
					<td class="viewtop alignC" colspan = 2> 
					</td>
				</tr>
			</c:if>
			<!-- AttrList is not null -->
			<!-- First Attr Value-->			
			<c:forEach var="i" items="${getList}" varStatus="iStatus">
			<tr>			
			<c:choose>
			<c:when test="${iStatus.count eq 1 }">					
				<th class="alignC viewline">${i.Name}</th>
				<td class="alignL pdL10 last">
			</c:when>
			<c:when test="${iStatus.count ne 1 }">					
				<th class="alignC line">${i.Name}</th>
				<td class="tit last" >
			</c:when>					
			</c:choose>					

<!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
<!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT -->	
<c:choose>
<c:when test="${i.DataType eq 'Text'}">	
	<c:choose>
		<c:when test="${i.HTML eq '1'}">
							<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:40px;"></textarea>
		</c:when>
		<c:when test="${i.HTML ne '1'}">
							<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="" class="text">
		</c:when>
	</c:choose>
</c:when>
<c:when test="${i.DataType eq ''}">	
	<c:choose>
		<c:when test="${i.HTML eq '1'}">
						<textarea class="textgrow" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:40px;"></textarea>
		</c:when>
		<c:when test="${i.HTML ne '1'}">
						<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="" class="text">
		</c:when>
	</c:choose>
</c:when>
<c:when test="${i.DataType eq 'LOV'}">					
					 <select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="sel" OnChange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);">
					 </select>
<script>
changeItemTypeCode('${i.AttrTypeCode}','${i.LovCode}');
</script>					 
</c:when>					
<c:when test="${i.DataType eq 'URL'}">
	<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="" class="text">
</c:when>
<c:when test="${i.DataType eq 'Date'}">
<!-- 2013-11-15 Datapicker확인중 -->
	<ul>
		<li>
			<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
			<font> <input type="text" id=SC_END_DT	name="SC_END_DT" value=""	class="text datePicker" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
		</li>
	</ul>
</c:when>
<c:when test="${i.DataType eq 'MLOV'}">
	<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >
	<c:forEach var="list" items="${i.mLovList}" varStatus="status">		
		<input type="checkbox" id="${i.AttrTypeCode}${list.CODE}" name="${i.AttrTypeCode}${list.CODE}" value="${list.CODE}"> &nbsp;${list.NAME} &nbsp;&nbsp; 
	</c:forEach>
</c:when>
</c:choose>					
				</td>				
			</tr>
</c:forEach>

		</table>
		<div class="alignBTN mgR10">
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjAttrInfo()" type="submit"></span>
		</div>
	</div>			
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>