<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%> 
</head>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00021}"/>

<script type="text/javascript">

	$(document).ready(function(){	
		var data = "&itemTypeCode=${itemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cxnTypeCodes=${cxnTypeCodes}";
		fnSelect('itemTypeCode', data, 'getItemTypeCodeFromCXN', '', 'Select');
	});
	
	function fnAutoComplete(itemTypeCode){		
		autoComplete("searchValue", "AT00001", itemTypeCode, "", "${sessionScope.loginInfo.sessionCurrLangType}", 5, "top");
	}
	
	function fnOnChangeItemType(itemTypeCode){
		fnAutoComplete(itemTypeCode);
		var data="itemTypeCode="+itemTypeCode+"&s_itemID=${itemID}";
		var url = "getItemClassCode.do";
		var target = "blankFrame";
		ajaxPage(url, data, target);	
	}
	
	function fnSetClassCode(itemClassCode){
		$("#selectClassCode").attr('style', 'display: none');	
		$("#classCode").val(itemClassCode);
	}
	
	function fnSelectClassCodeList(itemTypeCode, cxnTypeCode){
		$("#selectClassCode").attr('style', 'display: done');	
		$("#classCode").val("");
		var data = "&option="+cxnTypeCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('itemClassCode', data, 'classCodeOption', '', 'Select');
	}
	
	function fnOpenItemTreePop(){ 	
		var itemClassCode = "";
		if($("#classCode").val() != ""){
			itemClassCode = $("#classCode").val();
		}else{
			itemClassCode = $("#itemClassCode").val();
		}
		var itemTypeCode = $("#itemTypeCode").val();
		var searchValue = $("#searchValue").val();
		if(itemTypeCode == ""){
			alert("${WM00025}"); return false;
		}
		opener.fnOpenItemTree(itemTypeCode, searchValue, itemClassCode);
		
		self.close();
	}

</script>
<body>
	
<div class="pdL10 pdR10">
	<input type="hidden" id="classCode" name="classCode">
	<input type="hidden" id="itemClassCodeCnt" name="itemClassCodeCnt">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Select</p>
	</div>
	<table class="tbl_blue01 mgT10">
		<colgroup>
			<col width="30%">
			<col width="70%">
		</colgroup>
		<tr>
			<th class="viewline">${menu.LN00021}</th>
			<td class="alignL last">
				<select id="itemTypeCode" name="itemTypeCode" class="sel" style="width:250px;margin-left=5px;" OnChange="fnOnChangeItemType(this.value);"></select>
			</td>
		</tr>
		<tr id="selectClassCode" style="display:none;">
			<th class="viewline">${menu.LN00314}</th>
			<td class="alignL last">
				<select id="itemClassCode" name="itemClassCode" class="sel" style="width:250px;margin-left=5px;"></select>
			</td>
		</tr>
		<tr>
			<th class="viewline">${menu.LN00028}</th>				
			<td class="alignL last" >
				<input type="text" id="searchValue" name="searchValue" value="" class="text" style="width:250px;ime-mode:active;">
			</td>
		</tr>
	</table>
	<div class="alignBTN">	
	<span class="btn_pack medium icon"><span class="next"></span>
		<input value="Next" type="button" onclick="fnOpenItemTreePop()"></span>
	</div>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</body>
</html>