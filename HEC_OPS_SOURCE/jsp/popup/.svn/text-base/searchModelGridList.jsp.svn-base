<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00087" var="WM00087"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>


<!-- 2. Script -->
<script type="text/javascript">
	
	var pp_grid1;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	
	$(document).ready(function() {	
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		fnSelect('MTCTypeCode', '', 'MTCTypeCode', '', 'Select');
		PgridInit();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		
		pp_grid1.setColumnHidden(8, true);
		pp_grid1.setColumnHidden(9, true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getModelList"; // model_SQL.getModelList
		result.header = "${menu.LN00024},Model No.,${menu.LN00028},${menu.LN00043},${menu.LN00032},${menu.LN00004},${menu.LN00070},${menu.LN00027},id,ModelID";
		result.cols = "ModelID|Name|Path|ModelTypeName|Creator|LastUpdated|StatusName|ItemID|ModelID";
		result.widths = "30,70,200,226,90,90,90,80,90,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&MTCategory=" + $("#MTCTypeCode").val()
			        + "&searchValue=" + setSpecialChar($("#searchValue").val())
					+ "&AttrCodeEscape=" + $("#isSpecial").val();

		return result;
	}
	
	//조회
	function doPSearchList(){
		if($("#searchValue").val() != "" && $("#MTCTypeCode").val() != ""){
			var d = setPGridData();
			fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
		}
	}	
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){	
		opener.doSetModelID(pp_grid1.cells(id, 9).getValue(), pp_grid1.cells(id, 2).getValue());
		self.close();
	}
	
	function setSpecialChar(avg) {
		var result = avg;
		var strArray =  result.split("[");
		
		if (strArray.length > 1) {
			result = result.split("[").join("[[]");
		}
		
		strArray =  result.split("%");
		if (strArray.length > 1) {
			result = result.split("%").join("!%");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("_");
		if (strArray.length > 1) {
			result = result.split("_").join("!_");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("@");
		if (strArray.length > 1) {
			result = result.split("@").join("!@");
			$("#isSpecial").val("Y");
		}
		
		return result;
	}
		
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="allItemFrm" id="allItemFrm" action="checkOutItem.do" method="post" onsubmit="return false;">
	
	<input type="hidden" id="itemId" name="itemId"  value="" />
	<input type="hidden" id="identifier" name="identifier"  value="" />
	<input type="hidden" id="path" name="path"  value="" />
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
		<div class="child_search" style="height:32px;">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<colgroup>
            		<col width="20%">
            		<col width="30%">
            		<col width="50%">
            	</colgroup>
	            	<tr>
	               		<td class="mgL10">${menu.LN00033}</td>
	               		<td><select id="MTCTypeCode" name="MTCTypeCode" class="sel"></select></td>
	               		<td class="pdT3">
	               			${menu.LN00028}
							<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="stext" style="width:150px;ime-mode:active;">
							<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search">&nbsp;
						</td>
	               	</tr>
       			</table>
       		</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="mgL10 mgR10">
  			<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT"></span></p>
			</div>
		    <div id="grdPAArea" style="width:100%;height:250px;"></div>
		    <div class="alignR mgT5 mgB5 mgR5">	
				<span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="doSetModelID()" ></span>
			</div>
  		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->

</body>
</html>