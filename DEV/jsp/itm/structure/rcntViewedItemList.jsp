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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<style>
body {background:url("${root}${HTML_IMG_DIR}/blank.png")}
.DimensionTd .SumoSelect{
	float:left;
	margin-right:7px;
}
.objbox{
	overflow-x:hidden!important;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수

	var screenType = "${screenType}";
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");doExcel();});
		$('#btnSearch').click(function(){
			$("#currPage").val("");
			doSearchList();
			return false;
		});
		
		getClassCodeList();

		gridInit();
		doSearchList();

		$("#Status").SumoSelect({csvDispCount: 3});
		$("#classCode").SumoSelect({csvDispCount: 3});
		
	});	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(19, true);
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 2, "img");	
		fnSetColType(p_gridArea, 11, "img");
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		p_gridArea.enablePaging(true,100,100,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getRcntViewedItemList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},Report,ItemID,ClassCode,DefArc,ArcStyle,ArcIcon,ArcURL,MenuVar,ArcVar";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|LastUpdated|Report|ItemID|ClassCode|DefArc|ArcStyle|ArcIcon|ArcURL|MenuVar|ArcVar";
		result.widths = "50,50,50,100,100,220,*,120,120,70,70,60,0,0,0,0,0,0,0,0"; // base 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&memberID=${sessionScope.loginInfo.sessionUserId}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
					+ "&CategoryCode=OJ"
		 			+ "&pageNum=" + $("#currPage").val()
					+ "&idExist=${idExist}";
		 			
		result.data = result.data+ setAllCondition();
		
		result.data = result.data+ "&ClassCode=" + $("#classCode").val();

		return result;
	}
	
	function setAllCondition() {
		var condition = "";
		if ($("#detailID").val() != "" ) { 
			condition = condition+ "&detailID=" + setSpecialChar($("#detailID").val());
		}
		if ($("#detailNm").val() != "" ) { 
			condition = condition+ "&detailNm=" + setSpecialChar($("#detailNm").val());
		}
		if ($("#LV_STR_DT").val() != "" && $("#LV_END_DT").val() != "" ) { 
			condition = condition+ "&lvStartDt=" + $("#LV_STR_DT").val();
			condition = condition+ "&lvEndDt=" + $("#LV_END_DT").val();
		}
		if ($("#Status").val() != "" ) { 
			condition = condition+ "&Status=" + $("#Status").val();
		}
		return condition;
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
	
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			var ArcCode = p_gridArea.cells(id,14).getValue();
			var ArcStyle = p_gridArea.cells(id,15).getValue();
			var ArcIcon = p_gridArea.cells(id,16).getValue();
			var ArcURL = p_gridArea.cells(id,17).getValue();
			var MenuVar = p_gridArea.cells(id,18).getValue();
			var ArcVar = p_gridArea.cells(id,19).getValue();
			var itemID = p_gridArea.cells(id,12).getValue();
			
			goArcMenu(ArcCode, ArcIcon,ArcStyle, ArcURL+".do?"+MenuVar+ArcVar+"&nodeID="+itemID);
		}
	}
	
	function doSearchList(){
		if ($('#ItemTypeCode').val() == "") {
			alert("${WM00041}");
			return false;
		}
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}
	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	function getClassCodeList(){
		var url    = "ajaxCodeSelect.do";
		var data   = "menuId=classCodeMgtOption&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "classCode";
		var defaultValue = "${classCode}";
		var isAll  = "select";
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendClassOption,1000);
	}
	
	function appendClassOption(){

		$("#classCode")[0].sumo.reload();
	}
	
	function clearSearchCon() {
		$("#detailID").val('');
		$("#detailNm").val('');
		$("#LV_STR_DT").val('');
		$("#LV_END_DT").val('');	
		
		$("#classCode")[0].sumo.selectItem(0);
		$("#Status")[0].sumo.selectItem(0);
		
	}

    function goArcMenu(avg,avg2,avg3,avg4) {
    	if(avg != "")
    		parent.clickMainMenu(avg,'',avg2, '',avg3,avg3,avg4);
    }
    
		
</script>

</head>
<body >
<div class="pdL10 pdR10">
	<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	
	<div class="cop_hdtitle">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;List of recently viewed items</h3>
	</div>
	
	<!-- <div align="center">  -->
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="10%">
		    <col width="7%">
		    <col width="10%">
		    <col width="7%">
		    <col width="15%">
		    <col width="7%">
		    <col width="10%">
		    <col width="7%">
		    <col width="10%">
	    </colgroup>
	    
	    <!-- 항목유형, 계층, ID -->
	    <tr>
            <!-- [계층] -->
            <th class="viewtop">${menu.LN00021}</th>
            <td  class="viewtop">
            	<select id="classCode" name="classCode" style="width:120px;" >
                    <option value="">Select</option>    
				</select>
			</td>
			
            <!-- [상태] -->
            <th class="viewtop">${menu.LN00027}</th>
            <td class="viewtop">
            	<select id="Status" name="Status" style="width:150px;">
            	<option value="">Select</option>
            	<c:forEach var="i" items="${statusList}">
						<option value="${i.CODE}">${i.NAME}</option>
            	</c:forEach>
            	</select>
            </td>	
            
	    	<th class="viewtop">${menu.LN00152}</th>    
            <td class="viewtop" >
                <input type="text" id="LV_STR_DT" name="LV_STR_DT" value="" class="input_off datePicker stext" size="8"
                style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
                ~
                <input type="text" id="LV_END_DT"  name="LV_END_DT" value="" class="input_off datePicker stext" size="8"
                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
            </td>
            
			<th  class="viewtop">ID</th>
            <td  class="viewtop last"><input type="text" id="detailID" name="detailID" value="" class="stext" style="width:150px"></td>
            
	    	<th  class="viewtop">${menu.LN00028}</th>
            <td  class="viewtop last"><input type="text" id="detailNm" name="detailNm" value="" class="stext" style="width:90%"></td>
	    </tr>
	</table>
	
	<li class="mgT5" >
		<div align="center">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="display:inline-block;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">
		</div>
	</li>
	
	<div class="countList" >
        <li class="count"><input type="image" id="frame_sh" class="frame_show" title="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
       	 <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
   </div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
</body>
</html>