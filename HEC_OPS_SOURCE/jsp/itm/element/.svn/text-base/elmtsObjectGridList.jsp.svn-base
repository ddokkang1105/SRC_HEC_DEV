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
		
		PgridInit();
		doPSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setIconPath("${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/");
		fnSetColType(pp_grid1, 1, "ch");
		fnSetColType(pp_grid1, 2, "img");
		pp_grid1.setColumnHidden(6, true);	
		pp_grid1.setColumnHidden(7, true);		
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getElmtsObjectList"; 
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00176},Identifier,Item,${menu.LN00016},ItemID,ElementID";
		result.cols = "CHK|SymbolIcon|Identifier|PlainText|ClassName|ItemID|ElementID";
		result.widths = "30,30,80,70,216,70,80,50";
		result.sorting = "int,int,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&refModelID=${refModelID}";
					
		return result;
	}
		
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function fnAddObject(){
		if(pp_grid1.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");	
				var elementID = new Array(); 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					elementID[i] =  pp_grid1.cells(checkedRows[i], 7).getValue();
				}
				
				opener.$("#checkElmts").val(elementID);
				self.close();
			}
		} 
		
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="allItemFrm" id="allItemFrm" action="checkOutItem.do" method="post" onsubmit="return false;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div class="mgL10 mgR10">
		<div class="alignL mgT5 mgB5">	
		<p style="color:#1141a1;">Total  <span id="TOT_CNT"></span></p>
	</div>
    <div id="grdPAArea" style="width:100%;height:250px;"></div>
    <div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddObject()" ></span>
	</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->

</body>
</html>