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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
	
		fnSelect('getLanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}','Select');
		fnSelect('Category', '', 'ObjCategoryCode', '${Category}', 'Select');
		
	});

	function saveAttrribute() { 
			
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){
					
					var checkConfirm = false;
					
					/*if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
						alert("선택된 언어와 로그인된 언어가 다릅니다.");
						checkConfirm = false;
					}*/					
					if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
						//alert("선택된 언어와 로그인된 언어가 다릅니다.");
						alert("${WM00065}");
						checkConfirm = false;
					}	
					else{ 
						checkConfirm = true;
					}			
					if(checkConfirm){
						
						var url = "admin/SaveObjectType.do";
		
						ajaxSubmit(document.objTypePopList, url, "objTypePopFrame");
					}
				}

	
		//////////////////////////////////////////////
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		opener.fnCallBack();
		self.close();
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
	<form name="objTypePopList" id="objTypePopList" action="admin/SaveObjectType.do" method="post" onsubmit="return false;">
		
		 
		 <input type="hidden" id="SaveType" name="SaveType" value="New" />
		 <input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}"/>
		 <input type="hidden" id="LanguageID" name="LanguageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		
		 <div class="mgT5 mgL5 mgR5">
			<table id="newObject" class="tbl_blue01" width="100%;">
	
				<colgroup>
					<col width="25%">
					<col>
				</colgroup>
			
			<!-- ID -->
							
				<tr>
					<th class="viewtop">${menu.LN00015}</th>
					<td  class="viewtop last">
						<input type="text" class="text" id="objItemTypeCode"
						name="objItemTypeCode" value="${MaxObjectTypeCode}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
					</td>
				</tr>
				
			<!-- 명칭 -->
				<tr>
					<th>${menu.LN00028}</th>
					<td class="last">
						<input type="text" class="text" id="objName" name="objName" />
					</td>
				</tr>
				
				<!-- RootItemId -->
				<tr>
					<th>RootItemId</th>
					<td  class="last">
						<input type="text" class="text" id="objRootItemId" name="objRootItemId" />
					</td>
				</tr>
				
				<!-- Category -->
				<tr>
					<th>Category</th>
					<td  class="last">
						<select id="Category" name="Category" style="width:100%;"></select>
					</td>
				</tr>
				
				<!-- 개요 -->
				<tr>
					<th>${menu.LN00035}</th>
					<td  class="last">
						<input type="text" class="text" id="objDescription" name="objDescription">
					</td>
					
				</tr>
				<!-- 언어 -->
				<tr>
					<th>LanguageID</th>
					<td  class="last">
						<select id="getLanguageID" name="getLanguageID" style="width:100%;" disabled="disabled"></select>
					</td>
				</tr>

			</table>
</div>
			<div class="alignBTN">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input
						value="Save" type="submit" onclick="saveAttrribute()"></span>
				</c:if>
			</div>

		</form>
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="objTypePopFrame" id="objTypePopFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>