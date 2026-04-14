<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<style>
	.dhx_navbar {
		border-bottom: 1px solid #777;
		padding-bottom: 15px;
	}
	.dhx_window-content {
		color: #000;
	}
</style>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";

	
	jQuery(document).ready(function() {		
		if("${isPopup}" == "Y") $("body").css("overflow-y","scroll");
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer_photo');
		$('#authorInfo').click(function(){
			var pos = $('#authorInfo').position();  
			LayerPopupView('authorInfo', 'layerPopup', pos.top);
			layerWindow.addClass('open');
			// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
			document.getElementById("viewSRDIV").onscroll = function() {
				// 본문 레이어 팝업
				layerWindow.removeClass('open');
			};
		});
		
		// 레이어 팝업 닫기
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
	});
	
	/*** SR callback function start ***/
	
	function doCallBack(){}
	
	function fnCallBackSR(){ 
		var url = "processRFCP.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}&multiComp=${multiComp}&companyID=${companyID}"
					+"&srMode=${srMode}&esType=${esType}&srType=${srType}&scrnType=${scrnType}&srID=${srInfoMap.SRID}"
					+"&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&projectID=${projectID}&itemID=${itemID}&searchStatus=${searchStatus}&srStatus=${srStatus}";
		var target = "mainLayer";
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		} 
		ajaxPage(url, data, target);
	}
	
	function fnReload(){
		fnCallBackSR();
	}

	function fnCallBack(){
		fnCallBackSR();
	}
	
	/*** SR callback function end ***/
	
	/*** SR Button function start ***/
	// [List]
	function fnGoSRList(){ 
		var url = "espList.do";
		var data = "esType=${esType}&srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
			+ "&pageNum=${pageNum}&projectID=${projectID}&srStatus=${srStatus}"					
			+ "&category=${category}"
			+ "&subCategory=${subCategory}"
			+ "&srArea1=${srArea1}"
			+ "&srArea2=${srArea2}"
			+ "&subject=${subject}"
			+ "&status=${status}"
			+ "&receiptUser=${receiptUser}"
			+ "&requestUser=${requestUser}"
			+ "&requestTeam=${requestTeam}"
			+ "&regStartDate=${regStartDate}"
			+ "&regEndDate=${regEndDate}"
			+ "&stSRDueDate=${stSRDueDate}" 
			+ "&endSRDueDate=${endSRDueDate}" 
			+ "&searchSrCode=${searchSrCode}"
			+ "&searchStatus=${searchStatus}"
			+ "&multiComp=${multiComp}"
			+ "&reqCompany=${companyID}";
	
		var target = "mainLayer"; 
		if("${fromSRID}" != null &&"${fromSRID}" != ''){
			target = "esrListDIv";
		}
		ajaxPage(url, data, target);
	}
	
	// [Complete]
	function fnCompletion(url,varFilter){		
		if(!confirm("${CM00054}")){ return;}
		url  += "?" + "${srInfoMap.SRNextSpePgrVarFilter}";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Log Link] -- TODO
	function fnOpenDocument(PID,url,varFilter,ActID,procSeq){
		if(varFilter == "CSR"){
			var url = url+"?ProjectID="+PID+"&screenMode=V";
		}else if(varFilter == "SCR"){
			var url = url+"?srID=${srInfoMap.SRID}&scrID="+PID+"&screenMode=V";	
		}else if(varFilter == "WF"){
			var url = url+"?srID=${srInfoMap.SRID}&documentID=${srInfoMap.SRID}&wfInstanceID="+PID+"&isPop=Y&isMulti=N&actionType=view&docCategory=SR";	
		}else{
			url = url +"?PID="+PID+"&activityID="+ActID+"&procSeq="+procSeq;
		}
		window.open(url,'window','width=1200, height=714, scrollbars=yes, top=100,left=100,toolbar=no,status=yes,resizable=yes');
	}
	
	// [Scr Detail Popup]
	function fnViewScrDetail(scrID){
		var screenMode = "V";
		//var url = "viewScrDetail.do";
		var url = "viewRFCPSCRDetail.do";
		var data = "scrID="+scrID+"&screenMode="+screenMode+"&srID=${srInfoMap.SRID}"; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		fnCallBackSR();
	}
	
	// [Evaluation - V : View / E : Edit]
	function fnEvaluation(screenType,status){
		var url = "viewEvSheet.do?srID=${srInfoMap.SRID}&screenType="+screenType+"&srType="+"${srInfoMap.SRType}&status=" + status;
		var w = 600;
		var h = 780;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Request Evaluation]
	function fnRequestEvaluation(url,varFilter){
		if(!confirm("${CM00063}")){ return;}
		url += "?srID=${srInfoMap.SRID}&status=${srInfoMap.Status}" + varFilter;
		var w = 800;
		var h = 450;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Register SCR]
	function fnRegisterSCR(url,varFilter){
		url += "?srID=${srInfoMap.SRID}" + varFilter;
		var w = 1100;
		var h = 650;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Review / PGR00003]
	function fnReqITSApproval(url,varFilter,status){
		url += "?srID=${srInfoMap.SRID}&docSubClass=${srType}"
				+ "&WFDocURL=${WFDocURL}&ProjectID=${srInfoMap.ProjectID}"
				+ "&srArea1=${srInfoMap.SRArea1}"
				+ "&srArea2=${srInfoMap.SRArea2}"
				+ "&srRequestUserID=${srInfoMap.RequestUserID}"
				+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
				+ "&speCode=" + status + varFilter;
		window.open(url,'window','width=1000, height=700, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [SRUpdateMaster / PGR00007]
	function fnSRUpdateMaster(url, varFilter){
		url += "?srID=${srInfoMap.SRID}" + varFilter;
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Self Checkout]
	function fnSelfCheckOut(){		
		if(!confirm("${CM00054}")){ return;}
		var url  = "selfCheckOutESP.do?srID=${srID}";
		$("#srMode").val("N");
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	/*** SR Button function end ***/
	
</script>
</head>
<body>
<div id="viewSRDIV" <c:if test="${isPopup eq 'Y'}" >class="mgL10 mgR10 mgB10"</c:if>> 
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<c:if test="${scrnType != 'ITSP003' }" >
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00281}</h3>
		</div>
	</c:if>
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="9%">
		    <col width="26%">
		 	<col width="9%">
		    <col width="26%">
		 	<col width="9%">
		    <col width="21%">
		</colgroup>	
		
		<tr>		
			<!-- SR status -->		
			<th class="alignL pdL10">${menu.LN00065}</th>
			<td colspan="6" class="sline tit last alignL " >
				<c:choose>
					<c:when test="${fn:length(procStatusList) > 0}">
						<c:forEach var="list" items="${procStatusList}" varStatus="statusList">	
						<c:choose>					
								<c:when test="${list.TypeCode == srInfoMap.Status && list.RNUM == prSeq }">
									<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
								</c:when>
								<c:otherwise>				
									<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
								</c:otherwise>				  
						</c:choose>	
						<c:if test="${statusList.last != true}">
							>&nbsp;
						</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						${srInfoMap.SRStatusName}
					</c:otherwise>
				</c:choose>
			</td>	
		</tr>
		<tr>
		  <th class="alignL pdL10" >${menu.LN00025}</th>
			<td class="sline tit" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})</td>
			<!-- 담당자 -->
			<th class="alignL pdL10">ITS&nbsp;${menu.LN00219}</th>			
			<td class="sline tit" id="authorInfo" style="cursor:pointer;_cursor:hand ;color:blue;">${srInfoMap.ReceiptName}(${srInfoMap.ReceiptTeamName})</td>
			<!-- 티켓 ID  -->
			<th class="alignL pdL10">${menu.LN00396}</th>
			<td class="sline tit last">${srInfoMap.SRCode}</td>
		</tr>
		<tr>
		<!-- 도메인 -->
		<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
		<td class="sline tit last" >${srInfoMap.SRArea1Name}</td>
		<!-- 시스템 -->
		<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
		<c:if test="${srInfoMap.RoleType == 'A'}" >
			<td class="sline tit last">${srInfoMap.SRArea2Name} (${menu.LN00219} : ${srInfoMap.Area2RManager}/${srInfoMap.Area2RTeamName})</td>		
		</c:if>
		<c:if test="${srInfoMap.RoleType != 'A'}" >
			<td class="sline tit last">${srInfoMap.SRArea2Name}</td>		
		</c:if>	

	    	<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}</th>
			<td class="sline tit last" >${srInfoMap.ReqDueDate}&nbsp;${srInfoMap.ReqDueDateTime}</td>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}</th>
			<td class="sline tit last">${srInfoMap.CategoryName}</td>
			<!-- 서브카테고리 -->
			<th class="alignL pdL10">${menu.LN00273}</th>
			<td class="sline tit last">${srInfoMap.SubCategoryName}</td>
			<!-- 완료예정일 -->
			<th class="alignL pdL10">${menu.LN00221}</th>
			<c:if test="${srInfoMap.DueDate == null}" >
				<td class="sline tit  last" >N/A</td>	
			</c:if>
			<c:if test="${srInfoMap.DueDate !=  null}" >
				<td class="sline tit  last" >${srInfoMap.DueDate}&nbsp;${srInfoMap.DueDateTime}</td>	
			</c:if>	
		</tr>	
		<tr>				
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit last" colspan="5" id="subject" name="subject">${srInfoMap.Subject}</td>
		</tr>
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td colspan="6" class="tit last">
				<div style="height:285px; overflow: auto;" >
					<div style="width:100%;height:280px;">
						<textarea class="tinymceText" id="description" name="description" >${srInfoMap.Description}</textarea>
					</div>
				</div>
			</td>
		</tr>		
	</table>
	<div id="srCatAttrArea"></div>
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
			<col width="10%">
			<col>
		</colgroup>	
		<tr>
			<!-- 첨부문서 -->
			<th style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${SRFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${SRFiles}" varStatus="status">
				<div id="divDownFile${fileList.Seq}"  class="mm"  name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>				
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		<!-- 참조 -->
		<tr>
			<%-- LF 반영 시 주석해제 --%>
			<th>${menu.LN00245}<%--/추가 승인 --%></th>
			<td colspan="3" style="height:25px;" class="tit last">${sharerNames}</td>
		</tr>
	</table>
	<table class="tbl_brd mgT5 mgR5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		  	<th class="alignC pdL10">Comment<img class="mgL8" src="${root}cmm/common/images/detail.png" id="popup" style="width:12px; cursor:pointer;" alt="새창열기"></th>
			<td class="tit last" Valign="Top" id="comment"><div style="height:100px; overflow: auto;" >${srInfoMap.Comment}</div></td>
		</tr>	
		
		<tr id="itemListTR" style="display:none;">			
			<th class=" alignL pdL10 ">Item's</th>
			<td class="alignL pdL10 last">		
				<div id="gridCngtDiv" style="width:100%;height:160px;" class="clear">
					<div id="grdGridArea" style="width:100%;height:150px;"></div>
				</div>		
			</td>
		</tr>
	</table>
	<div class="alignBTN">		
	<c:if test="${isPopup ne 'Y'}" >
		<!-- ** EVENT BUTTON -->
		<c:if test="${checkOutYN eq 'Y'}">
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="self CheckOut" type="submit" onclick="fnSelfCheckOut()"></span>
		</c:if>
		<c:forEach var="statusList" items="${nextStatusList}" varStatus="status">
			<!-- [self CheckOut] :: 그룹원이 접수 -->
			<c:if test="${srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId && statusList.SRNextSpePgrID eq 'PGR00004' }" >
				<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluate" type="submit" onclick="fnEvaluation('E','${statusList.SRNextStatus}');"></span>
			</c:if>
			<c:if test="${srInfoMap.EvalSheetID != '' && srInfoMap.EvalSheetID != null}" >	
				<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluation sheet" type="submit" onclick="fnEvaluation('V','${statusList.SRNextStatus}');"></span>	
			</c:if>	
			<c:if test="${srInfoMap.Blocked eq 1&& srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId && statusList.SRNextSpePgrID eq 'PGR00004'}" >
				<span class="btn_pack medium icon"><span class="list"></span><input value="Complete" type="submit" onclick="fnRequestEvaluation('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}');"></span>			
			</c:if>
			<!-- [Complete/완료] ::: 다음 단계의 프로그램 ID = PG00002 (ITS 조치완료) && 상태 != 완료   -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00002' && srInfoMap.SvcCompl eq 'N' && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletion('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
			</c:if>
			
			<!-- [Create SCR/SCR 생성] ::: 다음 단계의 프로그램 ID = PG00005 -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00005' && appBtn eq 'Y' && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId}" >
				<span class="btn_pack medium icon"><span class="add"></span><input value="Create SCR" type="submit"  onclick="fnRegisterSCR('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}');" style="cursor:hand;"></span>	
			</c:if>
			
			<!-- [Review/일반 심의] 다음 단계의 프로그램 ID = PG00003 && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00003' && statusList.SRNextStatus ne srInfoMap.LastSpeCode && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Review" type="submit" onclick="fnReqITSApproval('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}','${statusList.SRNextStatus}')"></span>		
			</c:if>
			
			<!-- [PGR00007/다음 단계] 다음 단계의 프로그램 ID = PG00007 && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00007' && statusList.SRNextStatus ne srInfoMap.LastSpeCode && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId }" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Next" type="submit" onclick="fnSRUpdateMaster('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>		
			</c:if>
		</c:forEach>
	   
		<c:if test="${scrnType ne 'cust' }" >
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span>
		</c:if>
	</c:if>	
	</div>
	
	<!-- 담당자 레이어 팝업 -->	
	<div class="item_layer_photo" id="layerPopup" style="line-height:initial;">
		<div>
		<div class="child_search_head_blue" style="border:0px;">
			<li class="floatL"><p style="cursor: default;">Employee information</p></li>
			<li class="floatR mgT5 mgR10">
				<img class="popup_closeBtn" id="popup_close_btn"  style="cursor: pointer;" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close" >
			</li>
		</div>	 
		<table class="tbl_blue01 mgT5" style="width:100%;height:85%;table-layout:fixed;border:0px;">
				<colgroup>
					<col width="30%">
					<col width="70%">
				
				<tr>
					<td  style="border:0px;" >
						<c:if test="${authorInfoMap.Photo == 'blank_photo.png' }" >
							<img src='<%=GlobalVal.HTML_IMG_DIR%>${authorInfoMap.Photo}' style="width:60px;height:60px;">
						</c:if>
						<c:if test="${authorInfoMap.Photo != 'blank_photo.png' }" >
							<img src='<%=GlobalVal.EMP_PHOTO_URL%>${authorInfoMap.Photo}' style="width:60px;height:60px;">
						</c:if>
					</td>
					<td class="alignL last pdl10" style="border:0px;"><span style="font-weight:bold;font-size:12px;">${authorInfoMap.MemberName}</span>
					  &nbsp;(${authorInfoMap.EmployeeNum})<br>${authorInfoMap.UserNameEN}<br>${authorInfoMap.OwnerTeamName} 
					   <c:if test="${authorInfoMap.City != '' }" >
							(${authorInfoMap.City})
						</c:if></td>
				</tr>				
				<tr>
					<td colspan = "2"  class="alignL pdl10" >
						<div class="floatL" style="width:30%;font-weight:bold;">${menu.LN00104}</div>
						<div class="floatR"" style="width:70%">${authorInfoMap.TeamName}</div>
					</td>
				</tr>
				<tr>
					<td colspan = "2"  class="alignL pdl10" style="border:0px;">
						<div class="floatL" style="width:30%;font-weight:bold;">E-mail</div>
						<div class="floatR" style="width:70%;">${authorInfoMap.Email}</div>
					</td>
				</tr>
				<tr>
					<td colspan = "2"  class="alignL pdl10" style="border:0px;">
						<div class="floatL" style="width:30%;font-weight:bold;">Tel</div>
						<div class="floatR" style="width:70%">${authorInfoMap.TelNum}</div>
					</td>
				</tr>
				<tr>
					<td  colspan = "2" class="alignL pdl10" style="border:0px;">
						<div class="floatL" style="width:30%;font-weight:bold;">Mobile</div>
						<div class="floatR" style="width:70%">${authorInfoMap.MTelNum}</div>
					</td>
				</tr>
			</table> 
		</div>
	</div> 
	</form>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
<script>
	var popup = document.getElementById("popup");
	popup.addEventListener("click", fnPopDesc);
	var comment = document.getElementById("comment");
	
	var commentWindow = new dhx.Window({
		title:"Comment",
	    width: 1000,
	    height: 600,
	    modal: true,
	    movable: true,
	    resizable: true,
	    html: comment.innerHTML.replace("height:100px;","")
	});
	
	function fnPopDesc() {
		commentWindow.show();
	}
	
	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("viewSRDIV").scrollTop;
		var nTop = 80;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft - 30) + "px";
	} 
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=SR&browserType="+browserType+"&fltpCode=SRDOC";
		//fnOpenLayerPopup(url,data,"",400,400);
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	function fnDeleteSRFile(srID, seq, fileName, filePath){
		var url = "deleteSRFile.do";
		var data = "srID="+srID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).hide();
	}
	
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();		
	}
	
	function fnAttacthFileHtml(seq, fileName){ 
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
			'	<br>'+
			'</div>';		
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
	}
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}

		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	}	
</script>
</body>
</html>