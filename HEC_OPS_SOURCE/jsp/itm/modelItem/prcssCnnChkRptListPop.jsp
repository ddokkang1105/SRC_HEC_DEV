<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
	var pp_grid2;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		doPSearchList();
		
		$("#excel").click(function(){
			doExcel();
		});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '${DefDimTypeID}', 'Select');
		
		if("${DefDimTypeID}" != null && "${DefDimTypeID}" != '') {
			fnGetDimValue("${DefDimTypeID}");
		}
		
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGridMultirowHeader("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setColumnHidden(7, true);
		pp_grid1.setColumnHidden(8, true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var dimValueID = $("#dimValueID").val();
		var rptType = fnGetRadioValue(); 
		var sqlName = "model_SQL.selectPrcssCnnChkList";
		if(rptType==1){
			sqlName = "model_SQL.selectPrcssCnnChkList";
		}else{
			sqlName = "model_SQL.selectPrcssCnnChkInBndList";
		}
		var result = new Object();
		result.title = "${title}";
		result.key = sqlName;
		result.header = "${menu.LN00024},Process,#cspan,${menu.LN00178} Process,#cspan,${menu.LN00178},Result,ItemID,ObjectID";
		result.attachHeader1 = "#rspan,ID,Name,ID,Name,#rspan,#rspan,ItemID,ObjectID";
		result.cols = "Identifier2|itemName|Identifier|prePstItemName|KBN|VrfctnLink|ItemID|ObjectID";
		result.widths = "40,100,250,100,250,65,60,0,0";
		result.sorting = "str,str,str,str,str,str,str";
		result.aligns = "center,left,left,left,left,center,center";
		result.data = "ItemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";		
		if("${DefDimValueID}" != "" && dimValueID == "") {
			result.data += "&dimValueID=${DefDimValueID}";
		}
		else if(dimValueID != ""){
			result.data += "&dimValueID="+dimValueID;
		}
		
		return result;
	}

	function gridOnRowSelect(id, ind){
		var ItemID = "";
		if(ind == 2){
			ItemID = pp_grid1.cells(id, 7).getValue();
		}else if(ind == 4){
			ItemID = pp_grid1.cells(id, 8).getValue();
		}else{
			return;
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function doExcel() {
		pp_grid1.toExcel("${root}excelGenerate");
	}
	
	function fnGetRadioValue() {
		var radioObj = document.all("rptType");
		
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
	}
	
	function fnGetDimValue(dimTypeID){
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
		fnSelect('dimValueID', data, 'getDimTypeValueId', '${DefDimValueID}', 'Select');
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body align="center" style="width:100%;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp; Consistency check of process connections</p>
	</div>
	 <div class="child_search" >
	   <li>
	   		 <input type="radio" name="rptType" value="1" checked >&nbsp;&nbsp;Outbound Check
	   		&nbsp;&nbsp;<input type="radio" name="rptType" value="2" >&nbsp;&nbsp;Inbound Check
	   		<c:if test="${classCode == 'CL01001'}">
	   		&nbsp;* Dimension&nbsp;
	   		<select id="dimTypeID" name="dimTypeID" style="width:120px;"  OnChange=fnGetDimValue(this.value);></select>
	   		<select id="dimValueID" name="dimValueID" style="width:120px;"><option value="">Select</option></select>	   		
	   		</c:if>&nbsp;&nbsp;&nbsp;&nbsp;
	   		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doPSearchList()" value=Search />
	   		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	   	</li>	
	</div>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridMLDiv" class="mgB10 clear" align="center">
    <div id="grdPAArea" style="width:98%;height:700px;"></div>	
    </div>
   <iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</body>
</html>