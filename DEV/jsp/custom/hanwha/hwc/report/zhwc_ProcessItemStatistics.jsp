<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<script>
var tc_gridArea;				//그리드 전역변수
$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 390)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 390)+"px;");
	};
	
	$("#excel").click(function(){tc_gridArea.toExcel("${root}excelGenerate");});

	gridTcInit();		
	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


//===============================================================================
// BEGIN ::: GRID
function doTcSearchList(){
	var d = setTcGridData();
	fnLoadDhtmlxGridJson(tc_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
}

function gridTcInit(){	
	var d = setTcGridData();
	tc_gridArea = fnNewInitGrid("grdChildGridArea", d);
	tc_gridArea.setColumnHidden(0, true);
	fnLoadDhtmlxGridJson(tc_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	//tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
}
function setTcGridData(){
	var tcResult = new Object();
	tcResult.title = "${title}";
	tcResult.key = "custom_SQL.zhwc_getProcessCnt";
	tcResult.header = "No,L1,L2,L3,L4,L5,L4 Task 기준,#cspan,#cspan";
	tcResult.attachHeader = "#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,L4Mod,L4Rel,L4Del";
	tcResult.cols = "L1Name|L2Cnt|L3Cnt|L4Cnt|L5Cnt|L4MOD|L4REL|L4DEL";
	tcResult.widths = "10,200,50,50,50,50,50,50,50";
	tcResult.sorting = "int,str,int,int,int,int,int,int,int";
	tcResult.aligns = "left,center,center,center,center,center,center,center,center";
	tcResult.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	return tcResult;
}
/*
function gridOnRowSelect(id, ind){if(ind != 1){doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());}else{tranSearchCheck = false;}}
function doDetail(avg1, avg2){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}
*/

</script>	
<div style="padding:0 200px;">
	<div id="processListDiv" class="hidden" style="float:left;height:100%;">
		<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
			
			<div class="cop_hdtitle mgT5" style="border-bottom:1px solid #ccc">
				<h2 style="padding-top:6px;">
					<img src="/cmm/common/images/statistics.png" style="margin-top:-11px;">&nbsp;&nbsp;Hanwha Rule & Process Statistics&nbsp;</h2>
			</div>
			
			<h3 style="font-size:12px;">규정 <span>| RULE</span></h3>
			<table class="tbl_blue01 mgT5" style="table-layout:fixed;" width="50%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
				<tr>
					<!-- CSR 코드 -->
					<th class="viewtop alignC pdL10">규정/지침/세칙</th>
					<!-- 문서유형 -->
					<th class="viewtop alignC pdL10">SHEC전사규정</th>			
					<!-- 담당자 -->
					<th class="viewtop alignC pdL10">품질 전사규정</th>
					<th class="viewtop alignC pdL10 last">위임 전결규정</th>
				</tr>	
				 <tr>		
					<td class=" alignC pdL10" >${nomalRuleCnt}</td>				
					<td class="alignC pdL10">${shecRuleCnt}</td>				
					<td class="alignC pdL10">${qRuleCnt}</td>
					<td class="alignC pdL10 last">${rRuleCnt}</td>
				</tr>
		    </table>
			
			<h3 style="font-size:12px;">공통 프로세스 <span>| COMMON PROCESS</span></h3>
			<div id="gridDiv" class="mgB10 clear">
				<div id="grdChildGridArea" style="width:50%"></div>
			</div>
			
			<h3 style="font-size:12px;">사업장 프로세스(요령) <span>| PLACE OF BUSINESS PROCESS</span></h3>
			<table class="tbl_blue01 mgT5" style="table-layout:fixed;" width="50%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
			</colgroup>
				<tr>
					<!-- CSR 코드 -->
					<th class="viewtop alignC pdL10">여수 사업장</th>
					<th class="viewtop alignC pdL10">보은1 사업장</th>		
					<th class="viewtop alignC pdL10">보은2 사업장</th>	
					<th class="viewtop alignC pdL10">대전 사업장</th>
					<th class="viewtop alignC pdL10">구미 사업장</th>
					<th class="viewtop alignC pdL10 last">종합 연구소</th>
				</tr>	
				 <tr>		
					<td class="alignC pdL10" >${yProcessCnt}</td>				
					<td class="alignC pdL10">${b1ProcessCnt}</td>				
					<td class="alignC pdL10">${b2ProcessCnt}</td>				
					<td class="alignC pdL10">${dProcessCnt}</td>	
					<td class="alignC pdL10">${gProcessCnt}</td>
					<td class="alignC pdL10 last">${rProcessCnt}</td>
				</tr>
		    </table>
		</div>

	</div>
	</div>