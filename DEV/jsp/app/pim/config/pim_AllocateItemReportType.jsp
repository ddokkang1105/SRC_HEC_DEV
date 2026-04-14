<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용



$(document).ready(function() {	

	//Grid 초기화
	gridOTInit();
	doOTSearchList();
	//fnSelect('getLanguageID', '', 'langType', '${languageID}', '언어 선택');
	
});	


//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	
	p_gridArea = fnNewInitGrid("grdGridArea", d);	
	fnSetColType(p_gridArea, 1, "ch");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	
}

function setOTGridData(){

	var result = new Object();
	result.title = "${title}";
	
	result.key = "procConfig_SQL.getAllocateItemReport";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},Report Type,OutPut Type,${menu.LN00028},${menu.LN00035}";	//8z
	// #master_checkbox =  check box 전체선택
	
	result.cols = "CHK|ReportCode|ReportType|OutputType|Name|Description"; //8-1
	
	result.widths = "50,50,150,80,100,130,350"; //8
	result.sorting = "int,int,str,str,str,str,str"; //8
	result.aligns = "center,center,center,center,center,center,center"; //8
	
	result.data =  "s_itemID=${s_itemID}"	
		 		+ "&LanguageID=${languageID}";
	 		
	//alert(result.data);
	return result;

}

function setSearchTeam(teamID,teamName){
	$('#ownerTeamCode').val(teamID);
	$('#teamName').val(teamName);
}

// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}


function AddReportTypeTab(){
	var url = "pim_AddAllocItemReportCode.do";
	var data = "&s_itemID=${s_itemID}" + 
				"&languageID=${languageID}";
	url += "?" + data;
	var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

function DeleteReportType(){
	
	if (p_gridArea.getCheckedRows(1).length == 0){
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
	
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
	
			for ( var i = 0; i < checkedRows.length; i++) {
				
				var url = "pim_DeleteAllocItemReport.do";

				var data = "&ReportCode=" + p_gridArea.cells(checkedRows[i], 2).getValue() 
								+ "&ItemID=${s_itemID}";
				
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ArcFrame";
		
				ajaxPage(url, data, target);	
				
			}
		}
	}
		
}

function urlReload(){
	var url = "pim_AllocateItemReportType.do";
	var data = "&languageID=${languageID}&s_itemID=${s_itemID}&pageNum=${pageNum}";
	var target = "ArcFrame";
	
	ajaxPage(url, data, target);
}
</script>
<body>
	<form name="SubReportTypeList" id="SubReportTypeList" action="*" method="post" onsubmit="return false;">
		<div class="child_search">	
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">		
					<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddReportTypeTab()"></span>
					<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteReportType()"></span>			
				</c:if>
			</li>
		</div>
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="height:130px; width:100%"></div>
		</div>
		
	</form>
	
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
	
</html>