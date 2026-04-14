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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="2 Models"/>


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
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(pp_grid1, 1, "ch");
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "model_SQL.selectCompareModelList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00106},${menu.LN00028},${menu.LN00033}";
		result.cols = "CHK|ModelID|Name|MTCategory";
		result.widths = "30,30,80,*,80";
		result.sorting = "str,str,str,str,str";
		result.aligns = "center,center,center,center,center";
		result.data = "ItemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	function gridOnRowSelect(id, ind){
		var SymTypeCode = pp_grid1.cells(id, 4).getValue();
		$("#SymTypeCode").val(SymTypeCode);	
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function doGetCompareModelList(){
		var ModelIDS = new Array;
		var checkedRows = pp_grid1.getCheckedRows(1).split(",");
		if(checkedRows.length != 2){	
			alert("${WM00025}");
			return;
		} else{
					ModelID1 = pp_grid1.cells(checkedRows[1], 2).getValue();					
					ModelID2 = pp_grid1.cells(checkedRows[0], 2).getValue();
				var url = "compareModel.do?s_itemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+"&modelID1="+ModelID1+"&modelID2="+ModelID2;
				var w = 1000;
				var h = 600;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}
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
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doGetCompareModelList()" ></span>
		
		</div>
    <div id="grdPAArea" style="width:100%;height:280px;"></div>	
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>