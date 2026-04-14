<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00031" var="CM00031"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00032" var="CM00032"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00045" var="CM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00046" var="CM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00161" var="WM00161"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00069" var="CM00069"/>
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<style>
.dhx_window-header {
    padding-bottom: 0px !important;
}

.dhx_window .dhx_window-header .dhx_toolbar .dhx_navbar {
    padding-top: 0px !important;
}

</style>


<script type="text/javascript">

// 전역변수 처리 ================================
var itemId = "${s_itemID}";
var sessionCurrLangType = "${sessionScope.loginInfo.sessionCurrLangType}";
var arcCodeOption = "${option}";
var defDimValueId = "${defDimValueID}";
var udfSTR = "${udfSTR}";
var accMode = "${accMode}";
var kbn = "${kbn}";
var scrnType = "${scrnType}"
var strItemId = "${strItemID}";
// ===================================================================


var CM00032 = "${CM00032}";
var CM00042 = "${CM00042}";
var CM00045 = "${CM00045}";
var CM00046 = "${CM00046}";
var CM00031 = "${CM00031}";
var CM00069 = "${CM00069}";
var timer = null;

function executeReportAction(outputTypeRaw, rptType, rptUrl, varFilter, actionType, pWidth, pHeight, rptMsg) {
    
    $("#reportCode").val(rptType);

    var outputType = "";
    if (outputTypeRaw != null) { outputType = outputTypeRaw.replace(/^\s+|\s+$/g, ''); }

    // 실제 리포트 실행 함수
    function proceedReportExecution() {
        var url = rptUrl;
        var data = "languageID="+ sessionCurrLangType + "&itemID=" + itemId + "&ArcCode=" + arcCodeOption + "&rptType=" + rptType
        + "&defDimValueID=" + defDimValueId + "&udfSTR=" + udfSTR;
        var target = "";
            
        $("#isReportDetail").val("Y");

        var reportTitle = "";
        
        if (actionType == "POP") {
            if (outputType == "doc") {
            	// ★★★ outputType이 doc인 리포트 현재 unit process에는 할당 안됨. 추후 진행.
                wordDiv(url, varFilter, outputType);
            } else {
            	// Model comparison report, L4 Process connection check, Comparison report of attribute change, Compare item attribute version
            	// 기존 팝업 띄우던 리포트 4개
				url = url + "?itemID=" + itemId + "&languageID=" + sessionCurrLangType + varFilter + "&ArcCode=" + $("#ArcCode").val();			
				openUrlWithDhxModal(url, data, reportTitle, pWidth, pHeight)
            }
        } else if (actionType == "EXE") {
            if (outputType == "doc") {
            	// ★★★ outputType이 doc인 리포트 현재 unit process에는 할당 안됨. 추후 진행.
                url = url + "?" + data + varFilter; 
                ajaxSubmit(document.objectInfoFrm, url, "blankFrame");
                return false;
            } else if (outputType == "scrn") {
            	// 프로세스 정의서 출력, Download sub item list 등 (화면이동 리포트)
                target = "reportDetailDiv";
                data += "&screenMode='rpt'" + varFilter + "&accMode=" + accMode;
                $("#original").remove();
                $("#filename").remove();
                $("#scrnType").remove();
                
                openUrlWithDhxModal(url, data, reportTitle, pWidth, pHeight)
            } else {
            	// Delete Item Master, Create Base Flowchart (íë©´ì´ë ìì´ ì¦ì ì¤íëë ë¦¬í¬í¸)
                $('#fileDownLoading').removeClass('file_down_off');
                $('#fileDownLoading').addClass('file_down_on');				
                target = "blankFrame";
                data += "&kbn=" + kbn + "&s_itemID=" + itemId + varFilter + "&scrnType=" + scrnType + "&strItemID=" + strItemId
                +"&mstItemID=${mstItemID}&structureID=${structureID}";
                
             	ajaxPage(url, data, target);	
            }
     
        } else if (actionType == "LPOP") {
        	// Consolidation, rptType == "RP00013"
        	// 일단 뜨긴 하는데, 원래도 좀 이상하게 떴었고 그대로 이상하게 뜸
        	// (원래 방식 자체도 윈도우 팝업은 아니었음)
            data = "itemID=" + itemId; 
            
            // 원래 방식
            // fnOpenLayerPopup(url, data, doCallBack, pWidth, pHeight);
            
            openUrlWithDhxModal(url, data, reportTitle, pWidth, pHeight)
            doCallBack();
        } 
            
        // insertVisitLog 처리
        url = "setVisitLog.do";
        target = "blankFrame";
        data = "ActionType=RPT&MenuID=" + rptType + "&ItemId=" + itemId;
        ajaxPage(url, data, target);
    }
    
    // 실제 리포트 함수 실행 함수에 대한 전처리 및 호출 ==> rptMsg 값 유효하면 dhx alert로 확인
    if (rptMsg != null && rptMsg !== '') {
    	showDhxConfirm(rptMsg, proceedReportExecution)
    } 
    // rptMsg 없으면 리포트 즉시 실행	
    else {
        proceedReportExecution();
    }
}

		
function wordDiv(url, varFilter, outputType) {
	var data = "?s_itemID="+itemId+varFilter+"&outputType="+outputType;    	
   	var w = "380px";
   	var h = "240px";
   	itmInfoPopup(url+data,w,h);
}

function wordReport(avg1, avg2, avg3, avg4, avg5, avg6) {
	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	timer = setTimeout(function() {checkDocDownCom();}, 1000);
	var url = "wordReport.do";	
	$('#onlyMap').val(avg1);
	$('#paperSize').val(avg2);
	$('#URL').val(avg3); 
	$('#delItemsYN').val(avg4); 
	$('#MTCategory').val(avg5);
	$('#outputType').val(avg6);
	ajaxSubmitNoAdd(document.objectInfoFrm, url, "blankFrame");
}

function subItemInfoRpt(URL, classCodeList, outputType) {
	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	timer = setTimeout(function() {checkDocDownCom();}, 1000);
	var url = "subItemInfoReportEXE.do";	
	$('#URL').val(URL); 
	$('#classCodeList').val(classCodeList);
	$('#outputType').val(outputType);
	ajaxSubmitNoAdd(document.objectInfoFrm, url, "blankFrame");
}

function afterWordReport() {  
	$('#fileDownLoading').removeClass('file_down_on');
	$('#fileDownLoading').addClass('file_down_off');
}

function doCallBack(){
	$('#fileDownLoading').removeClass('file_down_on');
	$('#fileDownLoading').addClass('file_down_off');		
} 

function fnConfirm(mdlType, dbFuncCode){
	$('#fileDownLoading').removeClass('file_down_on');
	$('#fileDownLoading').addClass('file_down_off');

	if(confirm("${WM00161}")){ 
		var url = "baseModelInitial.do";
		var target = "blankFrame";
		var data = "itemID="+itemId+"&confirmYN=Y&mdlType="+mdlType+"&dbFuncCode="+dbFuncCode;
		ajaxPage(url, data, target);	
	}else{
		return;
	}
	
} 
	
function checkDocDownCom(){
	$.ajax({
		url: "checkDocDownComplete.do",
		type: 'post',
		data: "",
		error: function(xhr, status, error) { 
		},
		success: function(data){
			data = data.replace("<script>","").replace(";<\/script>","");
		
			if(data == "Y") {
				afterWordReport();
				clearTimeout(timer);
			}
			else {
				clearTimeout(timer);				
				timer = setTimeout(function() {checkDocDownCom();}, 1000);
			}
		}
	});	
}

function fnDownloadCNList(CNTypeCode){

	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');

	var url = "downloadCNList.do";
	var target = "reportDetailDiv";
	var data = "itemTypeCode="+CNTypeCode+"&s_itemID="+itemId;
	ajaxPage(url, data, target);
}

function fnDownloadCNCount(CNTypeCode, itemClassCode, attrTypeCode, treeItemTypeCode){		

	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	
	var url = "downloadCNCount.do";
	var target = "objectInfoDiv";
	var data = "itemTypeCode="+CNTypeCode+"&s_itemID="+itemId+"&itemClassCode="+itemClassCode+"&attrTypeCode="+attrTypeCode+"&treeItemTypeCode="+treeItemTypeCode;
	ajaxPage(url, data, target);
}

function doFileDown(avg1, avg2) {
	var url = "fileDown.do";
	$('#original').val(avg1);
	$('#filename').val(avg1);
	$('#scrnType').val(avg2);
	
	ajaxSubmitNoAlert(document.objectInfoFrm, url, "blankFrame");
	$('#fileDownLoading').addClass('file_down_off');
	$('#fileDownLoading').removeClass('file_down_on');
}

function fnCallbackWithErrLog(errMsg, fileName, downFile) {
	$('#fileDownLoading').removeClass('file_down_on');
	$('#fileDownLoading').addClass('file_down_off');		
	
	if(errMsg == "Y"){ 
		$('#original').val(fileName);
		$('#filename').val(fileName);
		$('#downFile').val(downFile);
		
		var url = "fileDown.do?scrnType=excel";
		ajaxSubmitNoAlert(document.objectInfoFrm, url);
	}
}
	
</script>
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>
<form name="objectInfoFrm" id="objectInfoFrm" action="#" method="post" onsubmit="return false;" style="height:100%;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value=itemId />
	<input type="hidden" id="ArcCode" name="ArcCode" value=arcCodeOption/>
	<input type="hidden" id="isReportDetail" name="isReportDetail"  value="" />
	<input type="hidden" id="URL" name="URL" value="" />
	<input type="hidden" id="reportCode" name="reportCode" value="" />
	<input type="hidden" id="docDownFlg" name="docDownFlg" value="N" />
	
	<input type="hidden" id="original" name="original" value="" />
	<input type="hidden" id="filename" name="filename" value="" />
	<input type="hidden" id="downfile" name="downfile" value="" />
	<input type="hidden" id="scrnType" name="scrnType" value="" />
	<input type="hidden" id="accMode" name="accMode" value=accMode/>
	<input type="hidden" id="classCodeList" name="classCodeList"/>
	
	<div id="objectInfoDiv" style="width:100%;height:100%;">
		<!-- 개요 화면에서 본 화면을 표시 한 경우 개요 화면으로 돌아가는 버튼을 화면에 표시 함 -->
		<c:if test="${kbn == 'newItemInfo'}">		
			<div class="child_search01 mgT10" id="child_info">
			<ul>
				<li class="shortcut">
			 	 <b style="font-size: 15px;">${menu.LN00287}</b>
				</li>
			</ul>
			</div>	
		</c:if>
		
		<div id ="reportDetailDiv" class="pdT10">
			<ul class="new-list">
				<c:forEach var="i" items="${getList}" varStatus="iStatus">
				<li onclick="executeReportAction('${i.OutputType}','${i.ReportCode}','${i.ReportURL}','${i.VarFilter}','${i.ActionType}','${i.PWidth}','${i.PHeight}',${i.MessageCode})">
					<div class="wrapper">
						<div class="icon w-60 mgL20">
							<c:if test="${i.Icon eq 'xls'}"><span class="flex align-center justify-center" style="background:#058534;"><i class='mdi mdi-file-excel-outline'></i></span></c:if>
							<c:if test="${i.Icon eq 'doc'}"><span class="flex align-center justify-center" style="background:#1464BF;"><i class='mdi mdi-file-word-outline'></i></span></c:if>
						</div>
						<div class="name fw-600 w-400">${i.Name}</div>
							
						<div class="authority w-200">
							<c:choose>
								<c:when test="${i.IsPublic eq '1' }"><span class="bg-color-blue  bd-rounded-12  pdT5 pdB5 pdL20 pdR20">ALL</span></c:when>
								<c:otherwise>
									<c:if test="${i.Authority eq '1' }"><span class="bg-color-pink bd-rounded-12  pdT5 pdB5 pdL20 pdR20">${menu.LN00246}</span></c:if>
									<c:if test="${i.Authority ne '1' }"><span class="bg-color-yellow  bd-rounded-12  pdT5 pdB5 pdL20 pdR20">${menu.LN00004}</span></c:if>
								</c:otherwise>
							</c:choose>
						</div>
						
						<div class="desc">${i.Description}</div>
					</div>
				</li>
				</c:forEach>				
			</ul>
		</div>
				
		<div>
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'>
			</iframe>
		</div>
	</div>	
		
</form>
