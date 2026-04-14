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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		doPSearchList();
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setIconPath("${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/");
		fnSetColType(pp_grid1, 1, "ch");
		fnSetColType(pp_grid1, 3, "img");
		
		pp_grid1.setColumnHidden(1,true);
		pp_grid1.setColumnHidden(5,true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "model_SQL.getSymbolList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00016},${menu.LN00176},${menu.LN00169},${menu.LN00169}";
		result.cols = "CHK|ClassName|SybolIcon|SymTypeName|SymTypeCode";
		result.widths = "30,30,80,80,*,80";
		result.sorting = "str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "ItemID=${ItemID}&ClassCode=${ClassCode}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ItemTypeCode=${ItemTypeCode}";
		return result;
	}

	function gridOnRowSelect(id, ind){
		var SymTypeCode = pp_grid1.cells(id, 5).getValue();
		$("#SymTypeCode").val(SymTypeCode);	
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function doSetSymbol(){	
		var SymTypeCode = $("#SymTypeCode").val();
		if(SymTypeCode == ""){
			alert("${WM00020}"); return;
		}
		if(confirm("${CM00001}")){
			var url = "updateSymbol.do";
			var target = "saveFrame";
			ajaxSubmit(document.symbolFrm, url);
		}
	}
	
	function fnClickedCheckBox(){
		if ($("input:checkbox[id='defSymSizeCheck']").is(":checked") == true) {
			$("#defSymSize").val("Y");
		}else{
			$("#defSymSize").val("N");
		}
	}
	
	function doReturnDiagram(){
		opener.location.reload();
		self.close();
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID" value="${ModelID}" >
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
	
		<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Replace symbol</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="doSetSymbol()" ></span>
		</div>
    <div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
    </div>
    <div id="grdPAArea" style="width:100%;height:180px;"></div>	
    <div id="defaultSize" style="width:100%;height:50px;">
    	<input type="hidden" id="defSymSize" name="defSymSize" value="Y" >&nbsp;
    	<input type="checkbox" id="defSymSizeCheck" name="defSymSizeCheck" onclick="fnClickedCheckBox()" checked>&nbsp;Default symbol size&nbsp;&nbsp;
    </div>	
    </div>
     
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>