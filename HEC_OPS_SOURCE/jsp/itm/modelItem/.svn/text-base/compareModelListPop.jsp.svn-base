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
		pp_grid1 = fnNewInitGridMultirowHeader("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setIconPath("${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/");
		fnSetColType(pp_grid1, 2, "img");
		fnSetColType(pp_grid1, 5, "img");
		pp_grid1.setColumnHidden(0,true);
		pp_grid1.setColumnHidden(9,true);
		pp_grid1.setColumnHidden(10,true);
		pp_grid1.setColumnHidden(11,true);
		pp_grid1.setColumnHidden(12,true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		pp_grid1.attachEvent("onHeaderClick", function(id,ind){gridHeaderSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "model_SQL.getTobeBasModelList";
		result.header = "${menu.LN00024},${menu.LN00016},${model1},#cspan,#cspan,${model2},#cspan,#cspan,${menu.LN00022},ObjectID1,ObjectID2,ElementID1,ElementID2";
		result.attachHeader1 = "${menu.LN00024},#rspan,${menu.LN00169},#cspan,${menu.LN00028},${menu.LN00169},#cspan,${menu.LN00028},#rspan,ObjectID1,ObjectID2,ElementID1,ElementID2";
		result.cols = "ClassName|SymbolIconBAS|SymbolBAS|PlainTextBAS|SymbolIconTOBE|SymbolTOBE|PlainTextTOBE|ChangeMode|ObjectID1|ObjectID2|ElementID1|ElementID2";
		result.widths = "30,80,40,80,238,40,80,238,80,50,50,50,50";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,center,center,center,center,left,center,center,center";
		result.data = "ModelIDTobe=${ModelIDTobe}&ModelIDBas=${ModelIDBas}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function gridHeaderSelect(id,ind){
		var modelID1 = "${ModelID1}";
		var modelID2 = "${ModelID2}";
		var modelName1 = "${ModelName1}";
		var modelName2 = "${ModelName2}";
		var modelTypeName1 = "${ModelTypeName1}"
		var modelTypeName2 = "${ModelTypeName2}"
		
		if(id == 2){
			var delElementIDs = fnGetDelElements();	
			var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=${itemID1}"
				 + "&s_itemID=${itemID1}&modelID="+modelID1+"&scrnType=view&MTCategory=${MTCategory1}"
				 + "&modelName="+encodeURIComponent(modelName1)
				 + "&modelTypeName="+encodeURIComponent(modelTypeName1)
				 + "&delElementIDs="+delElementIDs; 
		}else if(id == 5){
			var newElementIDs = fnGetNewElements();			
			var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=${itemID2}"
				 + "&s_itemID=${itemID2}&modelID="+modelID2+"&scrnType=view&MTCategory=${MTCategory2}"
				 + "&modelName="+encodeURIComponent(modelName2)
				 + "&modelTypeName="+encodeURIComponent(modelTypeName2)
				 + "&newElementIDs="+newElementIDs;
		}else{
			return;
		}
		var w = 1200;
		var h = 900;
	    window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnGetNewElements(){
		var rowsNum  = pp_grid1.getRowsNum();
		var chagneMode = "";
		var elementIDs = new Array();
		var index = 0;
		for(var i=0; i<rowsNum; i++){
			changeMode = pp_grid1.cells2(i,8).getValue();
			if(changeMode == "N"){
				elementIDs[index] = pp_grid1.cells2(i,12).getValue();
				index++;
			}
		}
		return elementIDs;
	}
	
	function fnGetDelElements(){
		var rowsNum  = pp_grid1.getRowsNum();
		var chagneMode = "";
		var elementIDs = new Array();
		var index = 0;
		for(var i=0; i<rowsNum; i++){
			changeMode = pp_grid1.cells2(i,8).getValue();
			if(changeMode == "D"){
				elementIDs[index] = pp_grid1.cells2(i,11).getValue();
				index++;
			}
		}
		return elementIDs;
	}

	function gridOnRowSelect(id,ind){
		var itemID = pp_grid1.cells(id,9).getValue();
		var changeMode = pp_grid1.cells(id,8).getValue();
		if(changeMode == "N"){
			itemID = pp_grid1.cells(id,10).getValue();
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);		
	}
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00175}</p>
	</div>
    <div id="grdPAArea" style="width:100%;height:500px;"></div>	
    <div class="countList">
        <li class="mgT10 mgL10">- New : <span id="New">${New}</span> - Deleted : <span id="Deleted">${Deleted}</span> - No Change : <span id="NoChange">${NoChange}</span></li>
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>