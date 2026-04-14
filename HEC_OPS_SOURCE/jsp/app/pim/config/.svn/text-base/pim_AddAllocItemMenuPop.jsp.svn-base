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
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Menu"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용
	
	$(document).ready(function() {
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select');
		
	});	
	
	function fnOpenMenuListPop(){
		var url = "pim_menuListPop.do?languageID=${languageID}&menuCat=ITM&s_itemID=${s_itemID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		$("#menuId").val(menuId);
		$("#menuName").val(menuName);
	}
	
	function fnSaveMenu(){
		if(confirm("${CM00012}")){
			var menuId = $("#menuId").val();
			var sortNum = $("#sortNum").val();
			var dicCode = $("#dicCode").val();
			var varFilter = $("#varFilter").val().replace(/&/gi,"%26");
			var sortNum = $("#sortNum").val();
			var itemMenuID = $("#itemMenuID").val();
			var menuType = $("#menuType").val();
			var viewType = "N";
			
			if ($("#menuId").val() == "") {
				alert("${WM00034}");
				return false;
			}
			var url = "pim_SaveAllocItemMenu.do";
			var data = "&menuId="+menuId + "&s_itemID=${s_itemID}"
					+"&sortNum="+sortNum+"&dicCode="+dicCode + "&menuType=" + menuType
					+"&varFilter="+varFilter+"&viewType="+viewType+"&itemMenuID="+itemMenuID; 
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	// [save] 이벤트 후 처리
	function fnCallback() {
		opener.fnCallBack();
		self.close();
	}

</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	
	<form name="fileTypePopList" id="fileTypePopList" action="#" method="post" onsubmit="return false;">
		<div class="mgT5 mgL5 mgR5">
			<table id="newObject" class="tbl_blue01" width="100%;">
				<colgroup>
					<col width="25%">
					<col>
				</colgroup>
			
				<!-- ID -->			
				<tr>
					<th class="viewtop">Menu</th>
					<td class="last viewtop">
						<input type="text" id="menuId" name="menuId" OnClick="fnOpenMenuListPop()" class="text" >
					</td>
				</tr>
				<!-- 명칭 -->
				<tr>
					<th>Menu name</th>
					<td class="last">
						<select id="dicCode" name="dicCode"  OnChange="fnGetDicCode()" class="sel" ></select>
					</td>
				</tr>
				<!-- 개요 -->
				<tr>
					<th>Menu type</th>
					<td class="last">
						<select id="menuType" name="menuType" class="sel">
							<option value="">Select</option>
							<option value="M">Main</option>
							<option value="S">Sub</option>
							<option value="P">Post</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>VarFilter</th>
					<td class="last"><input type="text" id="varFilter" name="varFilter"  class="text"  value=""/></td>
				</tr>
				<tr>
					<th>Sort No.</th>
					<td class="last"><input type="number" style="text-align:center;" id="sortNum" name="sortNum"  class="text"  value=""/></td>
				</tr>
			</table>
		</div>
		<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveMenu()"></span>
			</c:if>
		</div>

	</form>
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>
