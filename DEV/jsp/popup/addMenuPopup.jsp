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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00081" var="WM00081" arguments="DB" />

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	
	$(document).ready(function() {
		fnSelect('menuType', '', 'getMenuCat', '', 'Select');
	});
	
	// [Save] Click
	function saveNewMenu() { 
		if ($("input:checkbox[id='deActivatedCheck']").is(":checked") == true ) {
			$("#menuDeactivated").val("1");
		} else {
			$("#menuDeactivated").val("0");
		}
		if(confirm("${CM00001}")){	
			var url = "admin/saveNewMenu.do";		
			ajaxSubmit(document.addMenuFrm, url);
		}
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.urlReload();
		self.close();
	}
	
	function fnDuplicatedID(){
		alert("${WM00081}");
		$("#menuID").focus();
	}

	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="addMenuFrm" id="addMenuFrm" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="menuDeactivated" name="menuDeactivated" value="${resultMap.Deactivated}">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
		 
		<div class="mgT5 mgL5 mgR5">
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="20%">
				<col width="8%">
				<col width="20%">
			</colgroup>
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
				<td class="viewtop"><input type="text" class="text" id="menuID" name="menuID" style="ime-mode:disabled;" maxlength="255"   onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/></td>

				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop last">
					<input type="text" class="text" id="menuName" name="menuName" style="ime-mode:disabled;" maxlength="255" />
				</td>
			</tr>
			<tr>
				<th>Category</th>
				<td>
					<select id="menuType" name="menuType"  class="sel"></select>
				</td>

				<th>Level</th>
				<td  class="last">
					<select id="menuMnlvl" name="menuMnlvl"  class="sel">
						<option value="">Select</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
					</select>
				</td>
			</tr>

			<tr>
				<th>URL</th>
				<td>
					<input type="text" class="text" id="menuUrl" name="menuUrl" value="" maxlength="255" />
				</td>
				
				<th>VarFilter</th>
				<td  class="last">
					<input type="text" class="text" id="menuVarFilter" name="menuVarFilter" value="" maxlength="255" />
				</td>
			</tr>
			<tr>
				<th>Icon</th>
				<td>
					<input type="text" class="text" id="menuIcon" name="menuIcon" value="${resultMap.Icon}">
				</td>
				
				<th>Deactivated</th>
				<td  class="last">
					<input type="checkbox" id="deActivatedCheck" value="">
				</td>
				
		</table>
</div>
		<div class="alignBTN">
			&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveNewMenu()"></span>
		</div>

	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>