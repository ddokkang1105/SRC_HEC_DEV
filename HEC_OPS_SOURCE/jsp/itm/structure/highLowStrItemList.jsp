<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<style>
	.grid_hover {
		background-color:f2f8ff;
		font-size:20px;
	}
</style>

<script>
	var tc_gridArea;				//그리드 전역변수
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		};
			
		gridTcInit();		
		doTcSearchList('');
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
		gridTcInit();		
		doTcSearchList('');
	}
	
	function doTcSearchList(highLow){
		var tcd = setTcGridData(highLow);fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false);
	}
	
	function gridTcInit(){	
		var tcd = setTcGridData();
		tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");
			
		tc_gridArea.enableRowsHover(true,'grid_hover');
		tc_gridArea.enableMultiselect(true);
		tc_gridArea.setColumnHidden(3, true);
	
		tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function fnOnCheck(rowId,cellInd,state){
		if(state){
			tc_gridArea.setRowColor(rowId, "#f2f8ff");
		}else{
			tc_gridArea.setRowColor(rowId, "#ffffff");
		}
	}
	
	function setTcGridData(highLow){
		var tcResult = new Object();
		tcResult.title = "${title}";
		tcResult.key = "item_SQL.getHighLowStrItemList";
		tcResult.header = "${menu.LN00024},${menu.LN00042},${menu.LN00043},ItemID";
		tcResult.cols = "HighLow|Path|ItemID";
		tcResult.widths = "30,160,*,110";
		tcResult.sorting = "int,str,str";
		tcResult.aligns = "center,center,left,center";
		tcResult.data = "strItemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
			        + "&s_itemID=${toItemID}&highLow="+highLow;
			        
		
		return tcResult;
	}
	
	function gridOnRowSelect(id, ind){
		var strItemID = tc_gridArea.cells(id, 3).getValue();
		// parent.fnRefreshPage('${option}', strItemID);
		parent.fnRefreshTree(strItemID, true);
	}
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		 <div class="countList">
              <li class="pdL20 floatL">
				 <input type="radio" name="highLow" value="1" checked onClick="doTcSearchList('');">&nbsp;&nbsp;All
	   		&nbsp;&nbsp;<input type="radio" name="highLow" value="2" onClick="doTcSearchList('Higher');">&nbsp;&nbsp;Higher
	   		&nbsp;&nbsp;<input type="radio" name="highLow" value="3" onClick="doTcSearchList('Lower');">&nbsp;&nbsp;Lower				
			  </li>
		</div>	
		<div class="countList">
            <li class="pdL20 floatL" >
				<span style="color:blue"> All : ${AllCNT} &nbsp;&nbsp;Higher : ${HigherCNT} &nbsp;&nbsp;Lower : ${LowerCNT} </span>				
			</li>
		</div>	
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdChildGridArea" style="width:100%"></div>
		</div>
		</div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>