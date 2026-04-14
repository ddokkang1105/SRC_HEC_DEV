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

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script  -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {	
		fnSelect('getLanguageID', '', 'langType', '${LanguageID}','Select');
		fnSelect('objItemTypeCode', '', 'itemTypeCode', '','Select');
		
	});

	function saveModelFlow(){		
		if(confirm("${CM00001}")){			
			var checkConfirm = false;							
			if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
				alert("${WM00065}");
				checkConfirm = false;
			}	
			else{ checkConfirm = true;}			
			if(checkConfirm){				
				var url = "saveModelType.do";
				ajaxSubmit(document.ModelFlowPopList, url, "WorkFlowSaveFrame");
			}
		}
	}

	function selfClose() {		
		//var opener = window.dialogArguments;
		opener.urlReload();
		self.close();
	}
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="ModelFlowPopList" id="WorkFlowList" action="saveWorkFlowType.do" method="post" onsubmit="return false;">
		
		 <input type="hidden" id="orgTypeCode" name="orgTypeCode" />  
		 <input type="hidden" id="SaveType" name="SaveType" value="New" />
		 <input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}"/>
		 <input type="hidden" id="LanguageID" name="LanguageID" value="${LanguageID}"/>
		  <div class="mgT5 mgL5 mgR5">		 
			<table id="newObject" class="tbl_blue01" width="100%;">	
				<colgroup>
					<col width="25%">
					<col>
				</colgroup>			
			<!-- ID -->							
				<tr>
					<th class="viewtop">${menu.LN00015}</th>
					<td  class="last viewtop">
						<input type="text" class="text" id="objWFID"
						name="objMaxModelTypeCode" value="${MaxModelTypeCode}"/>
					</td>
				</tr>			
			<!-- ItemTypeCode -->
				<tr>
					<th>ItemTypeCode</th>
					<td  class="last">
						<select id="objItemTypeCode" name="objItemTypeCode" style="width:100%;"></select>
					</td>
				</tr>				
			<!-- 명칭 -->
				<tr>
					<th>${menu.LN00028}</th>
					<td  class="last">
						<input type="text" class="text" id="objName" name="objName" />
					</td>
				</tr>				
				<!-- 개요 -->	
				<tr>
					<th>${menu.LN00035}</th>
					<td  class="last">
						<input type="text" class="text" id="objDescription" name="objDescription">
					</td>
				</tr>
				<!-- ArisTypeNum -->	
				<tr>
					<th>ArisTypeNum</th>
					<td  class="last">
						<input type="text" class="text" id="objArisTypeNum" name="objArisTypeNum">
					</td>
				</tr>
				<!-- 언어 -->
				<tr>
					<th>LanguageID</th>
					<td  class="last">
						<select id="getLanguageID" name="getLanguageID" disabled="disabled" style="width:100%;"> 
						</select>
					</td>
				</tr>
				<!-- ZoomOption -->
				<tr>
					<th>ZoomOption</th>
					<td  class="last">
						<select id="zoomOption" name="zoomOption" style="width:100%;" >
							<option value=''>Select</option>
							<option value="FTW">Fit To Window</option>
							<option value="FTP">Fit To Page</option>
						</select>
					</td>
				</tr>
				
			</table>
			</div>
			<div class="alignBTN">
				&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input
					value="Save" type="submit" onclick="saveModelFlow()"></span>
			</div>
		</form>
	<iframe name="WorkFlowSaveFrame" id="WorkFlowSaveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>