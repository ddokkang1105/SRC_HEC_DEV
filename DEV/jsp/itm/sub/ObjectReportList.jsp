<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00031" var="CM00031"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00032" var="CM00032"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00045" var="CM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00046" var="CM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00161" var="WM00161"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00069" var="CM00069"/>
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

<script type="text/javascript">
var CM00032 = "${CM00032}";
var CM00042 = "${CM00042}";
var CM00045 = "${CM00045}";
var CM00046 = "${CM00046}";
var CM00031 = "${CM00031}";
var CM00069 = "${CM00069}";
var timer = null;
	function objectExport(avg, rptType, rptUrl, varFilter, actionType, pWidth, pHeight, rptMsg){
		$("#reportCode").val(rptType);
		var outputType = "";
		if (null != avg) {outputType = avg.replace(/^\s+|\s+$/g, '');}
	
		if(rptMsg != null && rptMsg != '') {
			if(confirm(rptMsg)){
				divReportPop(rptUrl,rptType,outputType, varFilter, actionType, pWidth, pHeight);
			}
		}
		else {
			divReportPop(rptUrl,rptType,outputType, varFilter, actionType, pWidth, pHeight);
		}
	}
	
	function divReportPop(rptUrl, rptType, outputType, varFilter, actionType, pWidth, pHeight) {		
		var url = rptUrl;
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=${s_itemID}&ArcCode=${option}&rptType="+rptType+"&defDimValueID=${defDimValueID}&udfSTR=${udfSTR}";
		var target = "";
		
		$("#isReportDetail").val("Y");

		if (actionType == "POP") {
			if (outputType == "doc") { 
				wordDiv(url, varFilter, outputType);
			} else {
				url = url+"?itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"+varFilter+"&ArcCode="+$("#ArcCode").val();
				itmInfoPopup(url,pWidth,pHeight);
			}
		} else if (actionType == "EXE") {
			 if (outputType == "doc") { 
				url = url+"?"+data+varFilter; 
				ajaxSubmit(document.objectInfoFrm, url, "blankFrame");
				return false;
			 } else if (outputType == "scrn"){
				target = "reportDetailDiv";
				data += "&screenMode='rpt'"+varFilter+"&accMode=${accMode}";
				$("#original").remove();
				$("#filename").remove();
				$("#scrnType").remove();
			} else{
				$('#fileDownLoading').removeClass('file_down_off');
				$('#fileDownLoading').addClass('file_down_on');				
				target = "blankFrame";
				data += "&kbn=${kbn}&s_itemID=${s_itemID}"+varFilter+"&scrnType=${scrnType}&strItemID=${strItemID}&mstItemID=${mstItemID}&structureID=${structureID}";
			}
			 
			ajaxPage(url, data, target);	
			
		} else if (actionType == "LPOP") { // Consolidation, rptType == "RP00013"
			data = "itemID=${s_itemID}"; 
			fnOpenLayerPopup(url,data,doCallBack,pWidth,pHeight);
// 			window.open(url+"?"+data, "", "width="+pWidth+", height="+pHeight+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		} 
		
		// insertVisitLog
		url = "setVisitLog.do";
		target = "blankFrame";
		data = "ActionType=RPT&MenuID="+rptType+"&ItemId=${s_itemID}";
		ajaxPage(url, data, target);
	}
		
	function wordDiv(url, varFilter, outputType) {
		var data = "?s_itemID=${s_itemID}"+varFilter+"&outputType="+outputType;    	
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
			var data = "itemID=${s_itemID}&confirmYN=Y&mdlType="+mdlType+"&dbFuncCode="+dbFuncCode;
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
		var data = "itemTypeCode="+CNTypeCode+"&s_itemID=${s_itemID}";
		ajaxPage(url, data, target);
	}
	
	function fnDownloadCNCount(CNTypeCode, itemClassCode, attrTypeCode, treeItemTypeCode){		
	
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		
		var url = "downloadCNCount.do";
		var target = "objectInfoDiv";
		var data = "itemTypeCode="+CNTypeCode+"&s_itemID=${s_itemID}&itemClassCode="+itemClassCode+"&attrTypeCode="+attrTypeCode+"&treeItemTypeCode="+treeItemTypeCode;
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
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${option}"/>
	<input type="hidden" id="isReportDetail" name="isReportDetail"  value="" />
	<input type="hidden" id="URL" name="URL" value="" />
	<input type="hidden" id="reportCode" name="reportCode" value="" />
	<input type="hidden" id="docDownFlg" name="docDownFlg" value="N" />
	
	<input type="hidden" id="original" name="original" value="" />
	<input type="hidden" id="filename" name="filename" value="" />
	<input type="hidden" id="downfile" name="downfile" value="" />
	<input type="hidden" id="scrnType" name="scrnType" value="" />
	<input type="hidden" id="accMode" name="accMode" value="${accMode}"/>
	<input type="hidden" id="classCodeList" name="classCodeList"/>
	
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:100%;">	
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
		
		<div id ="reportDetailDiv">
			<ul class="flex report">
				<c:forEach var="i" items="${getList}" varStatus="iStatus">
				<li onclick="objectExport('${i.OutputType}','${i.ReportCode}','${i.ReportURL}','${i.VarFilter}','${i.ActionType}','${i.PWidth}','${i.PHeight}',${i.MessageCode})">
					<div class="wrapper">
						<div class="icon">
							<c:choose>
								<c:when test="${i.Icon eq 'xls' || i.Icon eq 'doc' }">
									<c:if test="${i.Icon eq 'xls'}"><span class="flex align-center justify-center" style="background:#058534;"><i class='mdi mdi-file-excel-outline'></c:if>
									<c:if test="${i.Icon eq 'doc'}"><span class="flex align-center justify-center" style="background:#1464BF;"><i class='mdi mdi-file-word-outline'></c:if>
									</i></span>
								</c:when>
								<c:when test="${i.Icon eq 'scrn'}">
									<span class="flex align-center justify-center" style="background:#8FA4AC;"><i class='mdi mdi-dock-window'></i></span>
								</c:when>
								<c:otherwise>
									<span class="flex align-center justify-center" style="background:#8FA4AC;"><i class='mdi mdi-dock-top'></i></span>
								</c:otherwise>
							</c:choose>
							<div class="authority">${menu.LN00149}:
								<c:choose>
									<c:when test="${i.IsPublic eq '1' }">ALL</c:when>
									<c:otherwise>
										<c:if test="${i.Authority eq '1' }">${menu.LN00246}</c:if>
										<c:if test="${i.Authority ne '1' }">${menu.LN00004}</c:if>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="name">${i.Name}</div>
						<div class="desc">${i.Description}</div>
						<div class="exe flex align-center">
							<c:choose>
								<c:when test="${not empty i.OutputType &&  i.Icon ne 'scrn' }">
									<i class='mdi mdi-tray-arrow-down'></i><span>Download</span>
								</c:when>
								<c:otherwise>
									<i class='mdi mdi-play-circle-outline'></i><span>Execute</span>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</li>
				</c:forEach>
				<c:if test="${empty getList }">
					No report is allocated.
				</c:if>
				
			</ul>
		</div>
				
		<div>
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'>
			</iframe>
		</div>
	</div>	
		
</form>
