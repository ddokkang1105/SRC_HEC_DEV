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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00047" var="CM00047" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	gridOTInit();
	doOTSearchList();		
});	


//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	
	p_gridArea = fnNewInitGrid("grdGridArea", d);
	
	fnSetColType(p_gridArea, 1, "ch");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		if(ind != 1) {
			gridOnRowPSelect(id,ind);
		}
	});
}

function setOTGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.workFlowStepRelList";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},WFStepID,PreStepID,${menu.LN00028},${menu.LN00035},Category,SortNum,Deactivated"; 
	result.cols = "CHK|WFID|WFStepID|PreStepID|Name|Description|Cateogory|SortNum|Deactivated"; 
	result.widths = "50,50,100,100,100,120,*,100,100,100"; 
	result.sorting = "int,int,str,str,str,str,str,str,str,str"; 
	result.aligns = "center,center,center,center,center,center,center,center,center,center"; 
	result.data = "LanguageID=${languageID}"+"&WFID=${WFID}";
	return result;
}

// END ::: GRID	
//===============================================================================
	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

// 그리드ROW선택시
function gridOnRowPSelect(id, ind) {
	var url = "addWorkFlowStepPop.do?";
	var data = 	"WFID="+ p_gridArea.cells(id,2).getValue()
				+ "&WFStepID="+ p_gridArea.cells(id,3).getValue()
				+ "&LanguageID=${languageID}"
				+ "&wfName=${wfName}";
	var option = "dialogWidth:400px; dialogHeight:250px; scroll:yes";
    window.showModalDialog(url+data, self, option);
}

// [Add] Click
function addWorkStep(){
	var url = "addWorkFlowStepPop.do?";
	var data = "WFID=${WFID}&LanguageID=${languageID}&wfName=${wfName}";
	var option = "dialogWidth:400px; dialogHeight:250px; scroll:yes";
    window.showModalDialog(url+data, self, option);
}

// [Del] Click
function delWorkFlowRel(){
	if (p_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
	} else {
		if (confirm("${CM00047}")) {	
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			var minSortNum = "";
			for ( var i = 0; i < checkedRows.length; i++) {
				if (minSortNum == "") {
					minSortNum = p_gridArea.cells(checkedRows[i], 8).getValue();
				} else{ 
					if (minSortNum > p_gridArea.cells(checkedRows[i], 8).getValue()) {
						minSortNum = p_gridArea.cells(checkedRows[i], 8).getValue();
					}
				}
			}
			var url = "delWorkFlowRel.do";
			var data = "wfId=${WFID}&minSortNum=" + minSortNum;
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
}

// [Back] Click
function goBack(){
	var url = "workFlowDetailView.do";
	var data = "WFID=${WFID}&languageID=${languageID}&pageNum=${pageNum}"; 
	var target = "workFlowTypeDiv";
	ajaxPage(url,data,target);	
}

function urlReload() {
	doOTSearchList();
}

</script>
<body>
	<form name="WorkFlowRelList" id="WorkFlowRelList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
		<input type="hidden" id="WFID" name="WFID" value="${WFID}">
		<div class="cfg">
			<li class="floatL pdL20 pdR20 pdB10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${wfName}</li>
			<li class="floatR pdR20 pdB10">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">			
					<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="goBack();"></span>
					<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addWorkStep();"></span>
					<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delWorkFlowRel();"></span>
				</c:if>
			</li>
		<div class="mgL10 mgR10"><div id="grdGridArea" style="height:300px; width:100%"></div></div>
		</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>