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
<script type="text/javascript">
var CM00032 = "${CM00032}";
var CM00042 = "${CM00042}";
var CM00045 = "${CM00045}";
var CM00046 = "${CM00046}";
var CM00031 = "${CM00031}";
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
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=${s_itemID}&ArcCode=${option}";
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
				url = url+"?"+varFilter; 
				ajaxSubmit(document.objectInfoFrm, url, "blankFrame");
				return false;
			 } else if (outputType == "scrn"){ 
				target = "reportDetailDiv";
				data += "&screenMode='rpt'"+varFilter;
				$("input[type=hidden]:not(#isReportDetail)").remove();
			} else{
				$('#fileDownLoading').removeClass('file_down_off');
				$('#fileDownLoading').addClass('file_down_on');				
				target = "blankFrame";
				data += "&kbn=${kbn}&s_itemID=${s_itemID}"+varFilter;
			}
			 			
			ajaxPage(url, data, target);	
			
		} else if (actionType == "LPOP") { // Consolidation, rptType == "RP00013"
			data = "itemID=${s_itemID}"; 
			fnOpenLayerPopup(url,data,doCallBack,pWidth,pHeight);
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
	
	function fnConfirm(mdlType){
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
	
		if(confirm("${WM00161}")){ 
			var url = "baseModelInitial.do";
			var target = "blankFrame";
			var data = "itemID=${s_itemID}&confirmYN=Y&mdlType="+mdlType;
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
		
		ajaxSubmitNoAlert(document.objectInfoFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}

</script>
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>
<form name="objectInfoFrm" id="objectInfoFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${option}"/>
	<input type="hidden" id="onlyMap" name="onlyMap"  value="" />
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="isReportDetail" name="isReportDetail"  value="" />
	<input type="hidden" id="URL" name="URL" value="" />
	<input type="hidden" id="reportCode" name="reportCode" value="" />
	<input type="hidden" id="delItemsYN" name="delItemsYN" value="" />
	<input type="hidden" id="MTCategory" name="MTCategory" value="" />
	<input type="hidden" id="docDownFlg" name="docDownFlg" value="N" />
	<input type="hidden" id="outputType" name="outputType" value="" />
	
	<input type="hidden" id="original" name="original" value="" />
	<input type="hidden" id="filename" name="filename" value="" />
	<input type="hidden" id="scrnType" name="scrnType" value="" />
	<input type="hidden" id="accMode" name="accMode" value="${accMode}"/>
	<input type="hidden" id="classCodeList" name="classCodeList"/>
	
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:90%;">	
		<!-- 개요 화면에서 본 화면을 표시 한 경우 개요 화면으로 돌아가는 버튼을 화면에 표시 함 -->
		<c:if test="${kbn == 'newItemInfo'}">		
			<div class="child_search" id="child_info">
			<ul>
				<li class="shortcut">
			 	 <img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"></img>&nbsp;&nbsp;<b>${menu.LN00040}</b>
				</li>
			</ul>
			</div>	
		</c:if>
		
		<div id ="reportDetailDiv">	
			<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th width="5%">${menu.LN00024}</td>
					<th width="22%">${menu.LN00028}</td>
					<th width="8%" class="alignL">Output</th>	
					<th width="40%" class="alignC">${menu.LN00035}</th>	
					<th width="10%" class="alignL last">Execute</th>	
				</tr>				
				<c:forEach var="i" items="${getList}" varStatus="iStatus">
					<c:choose>
						<c:when test="${(iStatus.count % 2) eq 0}"> 
							<tr style="background-color:#f2f2f2" >
						</c:when>
						<c:otherwise> 
							<tr>
						</c:otherwise>
					</c:choose>
					<td>${i.RNUM}</td>
					<td class="alignC">${i.Name}</td>
					<td class="alignL">
						<c:if test="${i.Icon != null }">
						<span class="btn_pack small icon"><span class="${i.Icon}"></span></span>
						</c:if>
						<c:if test="${i.Icon == null }">
						&nbsp;&nbsp;-
						</c:if>
					</td>	
					<td class="alignL">${i.Description}</td>
					<td class="alignL last"><span class="btn_pack small icon"><span class="EXE" onclick="objectExport('${i.OutputType}','${i.ReportCode}','${i.ReportURL}','${i.VarFilter}','${i.ActionType}','${i.PWidth}','${i.PHeight}',${i.MessageCode})" ></span></span></td>
				</tr>
				</c:forEach>
			</table>
		</div>
				
		<div>
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'>
			</iframe>
		</div>
	</div>	
		
</form>
