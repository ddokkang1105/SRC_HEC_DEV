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

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";

	
	jQuery(document).ready(function() {
// 		if(document.getElementById('viewSRDIV')!=null&&document.getElementById('viewSRDIV')!=undefined){
// 			document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";			
// 			window.onresize = function() {
// 				document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";	
// 			};
// 		}
		
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer');
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
		$('.closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		if("${itemID}" != null && "${itemID}" != ""){
			$("#actFrame").css("overflow-y","auto");
		}
		
		$('#ispItem').click(function(){
			var itemId = "${srInfoMap.SRArea3}";
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		});
		
		fnLoadSRAttr('${srInfoMap.Category}'); // SR ATTR
		// 탭메뉴 로딩
		//fnClickedSubTab(2);
	});
	
	function doCallBack(){}

	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName)  {
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("viewSRDIV").scrollTop;
		var nTop = 80;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft - 30) + "px";
	} 
	
	function fnCallBackSR(){
		var url = "processISP.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}"
					+"&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&projectID=${projectID}"
					+"&itemID=${itemID}&varFilter=${varFilter}";
		if( "${itemID}" == "" ) {
			if( "${projectID}" == "" ) var target = "mainLayer";
			else var target = "tabFrame";
		} else {
			var target = "actFrame";
		}
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		} 
		ajaxPage(url, data, target);
	}
	
	function fnGoISPList(){
		var url = "ispList.do";
		var scrnType = "${scrnType}";		
		var data = "srType=${srType}&scrnType="+scrnType+"&srMode=${srMode}&pageNum=${pageNum}&projectID=${projectID}"
						+"&varFilter=${varFilter}&itemID=${itemID}&multiComp=${multiComp}&itemTypeCode=${itemTypeCode}"
						+"&srStatus=${srStatus}&status=${status}&searchStatus=${searchStatus}&category=${category}&subCategory=${subCategory}"
						+ "&srArea1=${srArea1}"
						+ "&srArea2=${srArea2}"
						+ "&defCategory=${defCategory}"
						+ "&subject=${subject}&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}&srReceiptTeam=${srReceiptTeam}"
						+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}";

		if( "${itemID}" == "" ) {
			if( "${projectID}" == "" ) {var target = "mainLayer";}
			else {var target = "tabFrame";}
		} else {
			var target = "actFrame";
		}
		if("${scrnType}"=="ITM"){
			var target = "viewSRDIV";
		}
		ajaxPage(url, data, target);
	}
	
	// SR 이관 
	function fnOpenTransferPop(){
		var url = "goTransferItspPop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=1100, height=320, left=300, top=300,scrollbar=yes,resizble=0');
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
		ajaxSubmitNoAdd(document.receiptICPFrm, url,"saveFrame");
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
		ajaxSubmitNoAdd(document.receiptICPFrm, url,"saveFrame");
	}
			
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
	
	function fnReload(){
		fnCallBackSR();
	}

	function fnCallBack(){
		fnCallBackSR();
	}

	// [Approval Request] click : 변경오더 조회 화면 일때
	function goSetWfStepInfo() {
		var url = "createWFDocCSR.do";
		var data = "ProjectID=${srInfoMap.ProjectID}&isNew=Y&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
				+"&s_itemID=${s_itemID}&scrnType=${scrnType}&fromSR=${fromSR}&srID=${srInfoMap.SRID}&wfDocType=SR";
		var target = "receiptICPFrm";
		ajaxPage(url, data, target);
	}
		
	function fnEditItspDueDatePop(){
		var url = "editSRDueDuatePop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=500, height=220, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnRequestDueDate(){
		if(!confirm("${CM00005}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "reqSRDueDateChange.do";
		var data = "srID="+srID+"&srType=${srInfoMap.SRType}";	
		var w = 600;
		var h = 310; 
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnCheckOutItem(){
		var url = "cngCheckOutPop.do?srID=${srInfoMap.SRID}&ownerType=editor&blockSR=Y&speCode=SPE024";
		var w = 400;
		var h = 350;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function selectCheckOutItem(csrID) {
		var url = "checkOutItem.do";		
		var data = "projectID="+csrID+"&itemIds=${srInfoMap.SRArea3}&srID=${srInfoMap.SRID}";
		var target="blankFrame";			
		ajaxPage(url, data, target);
	}
	
	function thisReload(){
		fnItemMenuReload();
	}
	
	function fnUpdateStatus(speCode){
		var srID = "${srInfoMap.SRID}"; 
		var url = "updateESRStatus.do";
		var data = "srID="+srID+"&status="+speCode;
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnSaveReceiveItspInfo(){
		if(!confirm("${CM00001}")){ return;}
		$('#srMode').val('N');
		var url  = "updateESRInfo.do";
		ajaxSubmit(document.receiptICPFrm, url,"saveFrame");
	}
	
	function fnRequestEvaluation(){
		if(!confirm("${CM00063}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "requestEvaluationPop.do?srID="+srID+"&status=ISP007";
		var w = 800;
		var h = 350;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnEvaluation(screenType){
		var url = "viewEvSheet.do?srID=${srInfoMap.SRID}&screenType="+screenType+"&srType="+"${srInfoMap.SRType}&status=ISP008";
		var w = 600;
		var h = 780;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnClickedSubTab(avg) {
		var data = "srID=${srInfoMap.SRID}&srType=${srType}";
		var target = "ispTabFrame";
		
		if(avg == 1){ // 스케줄
			var url = "goSchdlList.do";
			data = data + "&documentID=${srInfoMap.SRID}&docCategory=SR&docNo=${srInfoMap.SRCode}&refPjtID=${srInfoMap.ProjectID}&searchViewFlag=T";
			ajaxPage(url, data, target);
		}else if(avg == 2){ // 게시판
			var url = "forumMgt.do";
			data = data + "&varFilter=${srInfoMap.BoardMgtID}&s_itemID=${srInfoMap.SRArea3}&BoardMgtID=${srInfoMap.BoardMgtID}&srID=${srInfoMap.SRID}";
			ajaxPage(url, data, target);
			
			$("#ispTabFrame").css('display', 'block');
		}else if(avg == 3){ // 로그
			var procLog = $("#procLog").html();
			$("#ispTabFrame").html(procLog);
			$("#ispTabFrame").css('display', 'block');
		} else if(avg == 4){	//연관 SR
			var url = "esrList.do";
			data = "&fromSRID=${srInfoMap.SRID}";
			ajaxPage(url, data, target);
		}
				
	/* 	var realMenuIndex = "1 2 3 4".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#subtabs" + realMenuIndex[i]).addClass("on");
			} else {
				$("#subtabs" + realMenuIndex[i]).removeClass("on");
			}
		} */
		$("#receiptICPFrm").height($("#bottomView").height());
	}
	
	function fnHideTable() {
		var tempSrc = $("#fitWindow").attr("src");
		if($("#fitWindow").hasClass("frame_show")) {
			var height = $("#wrapView").height();
			
			$("#wrapView").attr("style","display:none");
// 			$("#bottomView").attr("style","position:relative;top:-" + height + "px;");
			$("#bottomView > .subtabs").css("margin-top","0");
			$("#viewSRDIV").scrollTop(0);
			$("#fitWindow").attr("class","frame_hide");
			$("#fitWindow").attr("alt","${WM00159}");
			$("#actFrame").animate({scrollTop: 0}, 200);
			$("#mainLayer").animate({scrollTop: 0}, 200);
		}
		else {
			$("#wrapView").removeAttr("style");
			$("#bottomView").attr("style","position:relative;top:" + height + "px;");
			$("#bottomView > .subtabs").removeAttr("style");
			$("#fitWindow").attr("class","frame_show");
			$("#fitWindow").attr("alt","${WM00158}");
		}
	}
	
	function fnGoSRList(){
		fnGoISPList();
	}
	
	function fnCompletion(){		
		if(!confirm("${CM00054}")){ return;}
		var url  = "completeESR.do?speCode=SPE024&svcCompl=Y&blockSR=Y";
		ajaxSubmit(document.receiptICPFrm, url,"saveFrame");
	}
	

	function fnLoadSRAttr(SRCatID){
		$.ajax({
			url: "getSRCatAttrList.do",
			type: 'post',
			data: "&srID=${srInfoMap.SRID}&SRCatID="+SRCatID,
			error: function(xhr, status, error) { 
			},
			success: function(obj){					
				var jsonObj = JSON.parse(obj); 
				var attrTypeCodes = new Array(); var i=0;
				var catAttrAreaHtml = "";	
				if(jsonObj != ""){
					catAttrAreaHtml = "<table class='tbl_brd mgT5' style='table-layout:fixed;' width='100%'  cellpadding='0' cellspacing='0'>";
					catAttrAreaHtml	+= "<colgroup><col width='10%'><col><col width='10%'><col><col width='10%'><col></colgroup>";	
					jsonObj.forEach(function (data) {	
						attrTypeCodes[i] = data.AttrTypeCode; i++;
						var dataType = data.DataType;
						var HTML = data.HTML;
						if(dataType == "Text"){
							if(HTML == "1"){
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>";
								catAttrAreaHtml += data.AttrTypeName +"</th>";
								catAttrAreaHtml += "<td class='sline tit last' colspan=5 style='height:"+data.AreaHeight+"px;'>";
								catAttrAreaHtml += "<textarea class='tinymceText' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' style='width:98%;height:"+data.AreaHeight+"px;'>";
								catAttrAreaHtml += "<div class='mceNonEditable'>"+data.Value+"</div></textarea>";
							}else{
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>";
								catAttrAreaHtml += data.AttrTypeName +"</th>";
								catAttrAreaHtml += "<td class='sline tit last' colspan=5>";
								catAttrAreaHtml += "<input type='text' class='text' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' value='"+data.Value+"' style='ime-mode:active;' readOnly=true />";
							}
						}else if(dataType == "LOV"){							
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>";
							catAttrAreaHtml += data.AttrTypeName +"</th>";
							catAttrAreaHtml += "<td class='sline tit last' colspan=5>";							
							catAttrAreaHtml += "<select id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' class='sel' OnChange=fnGetSubAttrTypeCode('"+data.AttrTypeCode+"','"+data.SubAttrTypeCode+"',this.value); disabled=true >";
							data.lovList.forEach(function (lovData) {	
								if(data.Value == lovData.CODE){
									catAttrAreaHtml += "<option value='"+lovData.CODE+"' selected>" + lovData.NAME + "</option>";  
								}else{
									catAttrAreaHtml += "<option value='"+lovData.CODE+"'>" + lovData.NAME + "</option>";  
								}
							});
							catAttrAreaHtml += "</select>";
							
						}else if(dataType == "MLOV"){
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>";
							catAttrAreaHtml += data.AttrTypeName +"</th>";
							catAttrAreaHtml += "<td class='sline tit last' colspan=3>";							
							data.MLovList.forEach(function (MLovData) {	
								if(MLovData.CODE == MLovData.LovCode){
									catAttrAreaHtml += "<input type='checkbox' id='"+data.AttrTypeCode + MLovData.CODE+"' name='"+data.AttrTypeCode + MLovData.CODE+"' value='"+MLovData.CODE+"' checked disabled =true >"; 
								}else{
									catAttrAreaHtml += "<input type='checkbox' id='"+data.AttrTypeCode + MLovData.CODE+"' name='"+data.AttrTypeCode + MLovData.CODE+"' value='"+MLovData.CODE+"' disabled =true >";
								}
								catAttrAreaHtml += "&nbsp;&nbsp;" + MLovData.NAME +"&nbsp;&nbsp;&nbsp;&nbsp;";
							});
						}
						catAttrAreaHtml += "</td></tr>";
					});
					catAttrAreaHtml	+= "</table>";
					$("#attrTypeCodes").val(attrTypeCodes);
					
				}else{
					$("#attrTypeCodes").val("");
				}
				$('#srCatAttrArea').html(catAttrAreaHtml);
				
				jsonObj.forEach(function (data) {				
					var dataType = data.DataType;
					var HTML = data.HTML;
					if(HTML == "1"){
						tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, data.AttrTypeCode);
						tinyMCE.EditorManager.execCommand('mceAddEditor', false, data.AttrTypeCode);
					}
				});
			}
		});	
	}
	
	function fnFormList(){
		var boardTitle = "(${srInfoMap.SRCode}) ${srInfoMap.Subject}";
		var url = "boardForumList.do";
		var data = "BoardMgtID=${srInfoMap.BoardMgtID}&boardTypeCD=MN161&url=boardLForumist" 
				+ "&srID=${srInfoMap.SRID}&scrnType=${scrnType}&showItemInfo=N"
				+ "&srType=${srType}&boardTitle="+encodeURIComponent(boardTitle)+"&defCategory=${defCategory}"	
				+ "&srCategory=${category}&subject=${subject}"
				+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}"
				+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
				+ "&srReceiptTeam=${srReceiptTeam}&searchStatus=${searchStatus}"
				+ "&srArea1=${srArea1}&srMode=${srMode}";
		var target = "viewSRDIV";
		ajaxPage(url, data, target);
	}
	 
	function fnModifySR(status){
		if(status == "ISP001") {
		// 제안
		var url = "modifyISP.do";
		var data = "srType=${srType}"
				+ "&srMode=${srMode}"
				+ "&scrnType=${scrnType}"
				+ "&itemID="+itemID
				+ "&srID=${srInfoMap.SRID}"
				+ "&srCode=${srInfoMap.srCode}"
				+ "&defCategory=${defCategory}";
			
		} else {
		// 완료
			var url = "processISP.do";
			var data = "srCode=${srInfoMap.srCode}&srID=${srInfoMap.SRID}" 
			+ "&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}"
			+ "&projectID=${projectID}"
			+ "&itemID="+itemID + "&varFilter=${varFilter}&itemTypeCode=${itemTypeCode}"
			+ "&multiComp=${multiComp}"
			+ "&srStatus=${srStatus}&status=${status}"
			+ "&defCategory=${defCategory}&category=${category}&subCategory=${subCategory}"
			+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}"
			+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
			+ "&srReceiptTeam=${srReceiptTeam}&searchStatus=${searchStatus}"
			+ "&srArea1=${srArea1}&srArea2=${srArea2}"
			+ "&subject=${subject}"
			+ "&option=modifyCMP";
		}
		var target = "viewSRDIV";
		ajaxPage(url, data, target);
	}
</script>
</head>
<body>
<div id="viewSRDIV"> 
	<form name="receiptICPFrm" id="receiptICPFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="projectID" name="projectID" value="${projectID}">
	<c:choose>
		<c:when test="${itemID eq '' || itemID eq null }">
			<div class="cop_hdtitle" style="line-height:25px;">
				<li class="floatL pdR20">	
					<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00281}</h3>
				</li>				
			</div>
		</c:when>
		<c:otherwise>
			<span class="flex-column mgB10 mgT8">
				<div class="align-center flex">
					<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
					<span style="font-weight: bold;">${srInfoMap.Subject}</span>
				</div>
				<div class="mgL35 mgT5">
					${srInfoMap.srArea3Path}
				</div>
			</span>
			
		</c:otherwise>
	</c:choose>
	
	<div id="wrapView">
		<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="9%">
			    <col width="26%">
			 	<col width="9%">
			    <col width="26%">
			 	<col width="9%">
			    <col width="21%">
			</colgroup>	
			
			<c:if test="${itemID ne '' && itemID ne null}">
			
				<tr>
					<!-- Item Type Code -->
					<th class="alignL pdL10">${menu.LN00021}</th>
					<c:if test="${srInfoMap.ItemTypeCodeNM == null}" >
						<td class="sline tit  last">N/A</td>	
					</c:if>
					<c:if test="${srInfoMap.ItemTypeCodeNM != null}" >
						<td class="sline tit last">${srInfoMap.ItemTypeCodeNM}</td>
					</c:if>
					<!-- 항목 -->
					<th class="alignL pdL10">${menu.LN00087}</th>
					<c:if test="${srInfoMap.SRArea3Code == null}" >
						<td class="sline tit  last"  colspan=3>N/A</td>	
					</c:if>
					<c:if test="${srInfoMap.SRArea3Code !=  null}" >
					<td class="sline tit last" colspan=3  id="ispItem" style="cursor:pointer;"><span style="color:blue;">${srInfoMap.SRArea3Code}&nbsp;${srInfoMap.SRArea3Name}</span>&nbsp;(&nbsp;${srInfoMap.srArea3Path}&nbsp;)</td>
					</c:if>
				</tr>
			
			</c:if>
			<tr>		
			<!-- SR status -->		
				<th class="alignL pdL10">${menu.LN00065}</th>
				<td colspan="3" class="sline tit last alignL " >
					<c:forEach var="list" items="${procStatusList}" varStatus="statusList">	
							<c:choose>					
									<c:when test="${list.TypeCode == srInfoMap.Status }">
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
				</td>
				
				<!-- SR No.  -->				
			    <th class="alignL pdL10">Issue No.</th>
				<td class="sline tit last">${srInfoMap.SRCode}</td>
			</tr>
			
			<tr>
				<!-- 요청자 -->
				<th class="alignL pdL10" >${menu.LN00025}</th>
				<td class="sline tit" >
					<c:if test="${MULTI_COMPANY ne 'Y'}" >
					${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM})
					</c:if>
					<c:if test="${MULTI_COMPANY eq 'Y'}" >
					${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})
					</c:if>
				</td>
				<!-- 담당자 -->
				<th class="alignL pdL10">${menu.LN00004}</th>			
				<td class="sline tit last" id="authorInfo" style="cursor:pointer;_cursor:hand ;color:blue;">${srInfoMap.ReceiptName}(${srInfoMap.ReceiptTeamName})</td>
					
				<!-- 요청일 / 완료일 -->
				<c:if test="${srInfoMap.SvcCompl eq 'N'}" >	
					<th class="alignL pdL10">${menu.LN00093}</th>
					<td class="sline tit  last" >${srInfoMap.RegDate}</td>	
				</c:if>
				<c:if test="${srInfoMap.SvcCompl eq 'Y'}" >	
					<th class="alignL pdL10">${menu.LN00064}</th>
					<td class="sline tit  last" >${srInfoMap.CompletionDT}</td>	
				</c:if>
							
			
				
			</tr>
			<tr>
				
				<!-- SRARea 1 -->
				<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
				<c:if test="${srInfoMap.SRArea1Name == null}" >
					<td class="sline tit  last" >N/A</td>	
				</c:if>
				<c:if test="${srInfoMap.SRArea1Name !=  null}" >
					<td class="sline tit last" >${srInfoMap.SRArea1Name}</td>
				</c:if>
				
				<!-- 본부 -->
				<!-- 
				<th class="alignL pdL10">본부</th>
				<td class="sline tit last" >${srInfoMap.ResponseTeamName}</td>
				 -->
				 
				<!-- SR Reason -->
				<th class="alignL pdL10"> 주요원인 / IT 지원 </th>
				<td class="sline tit last" colspan="3">${srInfoMap.SRReasonNM} / ${srInfoMap.ITSMIF}</td>
			
				
				
			</tr>						
			<tr>				
				<th class="alignL pdL10">${menu.LN00002}</th>
				<td class="sline tit last" colspan="5" id="subject" name="subject">${srInfoMap.Subject}</td>
			</tr>
		</table>
		<table  width="100%"  cellpadding="0"  cellspacing="0">
			<tr>
				<td colspan="6" class="tit last">
					<div style="width:100%;height:280px;">
						<textarea class="tinymceText" id="description" name="description" >${srInfoMap.Description}</textarea>
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
				<th class="alignC pdL10" style="height:53px;">${menu.LN00111}</th>
				<td colspan="6" style="height:53px;" class="alignL pdL5 last">
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
			<tr>
				<th class="alignC pdL10">${menu.LN00245}</th>
				<td class="sline tit last" colspan="6">${sharerNames}</td>
			</tr>
		</table>
		
		<table class="tbl_brd mgT5 mgR5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col>
			</colgroup>		
			<tr>
			  	<th class="alignC pdL10">Comment<img class="mgL8" src="${root}cmm/common/images/detail.png" id="popup" style="width:12px; cursor:pointer;" alt="New window"></th>
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
	     
	    <div class="cop_hdtitle" style="line-height:25px;">
				
				<li class="floatR pdT10">	
					<span class="btn_pack medium icon"><span class="list"></span><input value="Talk" type="submit"  onclick="fnFormList();"></span>
					
					<!-- [Transfer] ::: 로그인유저의 teamID가 접수자 TeamID 이며 제안 단계 , 접수 단계 , 진행 중 단계 일 때 [담당자 변경] 가능  -->
					<c:if test="${srInfoMap.ReceiptTeamID == sessionScope.loginInfo.sessionTeamId && (srInfoMap.Status == 'ISP001' || srInfoMap.Status == 'ISP002' || srInfoMap.Status == 'ISP004')}" >
			  			<span id="viewSave" class="btn_pack medium icon"><span class="gov"></span><input value="Transfer" type="submit" onclick="fnOpenTransferPop();"></span>
					</c:if>
					
					<!-- [Modify] ::: 로그인유저가 요청자 이며 제안 단계 일 때 혹은 로그인유저가 접수자 이며 완료 단계 일 때 [수정] 가능  -->
					<c:if test="${(srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.Status == 'ISP001')
									|| (srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.Status == 'ISP006' && scrnType ne 'srRqst')}" >
			  			<span id="viewSave" class="btn_pack medium icon"><span class="edit2"></span><input value="Modify" type="submit" onclick="fnModifySR('${srInfoMap.Status}');"></span>
					</c:if>
					
					<!-- [Request Evaluation] ::: 로그인유저가 접수자 이며 다음단계가 만족도 평가 요청 단계 일 때 [만족도 조사 평가 요청] 가능  -->
					<c:if test="${srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.SRNextStatus eq 'ISP007' }" >
						<span class="btn_pack medium icon"><span class="confirm"></span><input value="Request Evaluation" type="submit" onclick="fnRequestEvaluation()"></span>
					</c:if>
					
					<!-- [Evaluate] ::: 로그인유저가 요청자 이며 다음단계가 마지막 단계 일 때 [만족도 조사 평가] 가능  -->
					<c:if test="${srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.SRNextStatus eq srInfoMap.LastSpeCode }" >
						<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluate" type="submit" onclick="fnEvaluation('E');"></span>
					</c:if>
					
					<!-- [Evaluation sheet] ::: 만족도 평가 ID가 존재할 때 [만족도 조사 결과 보기] 가능  -->
					<c:if test="${srInfoMap.EvalSheetID != '' && srInfoMap.EvalSheetID != null}" >	
						<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluation sheet" type="submit" onclick="fnEvaluation('V');"></span>	
					</c:if>	
					
					<c:if test="${scrnType ne 'cust' }" >
						<span class="btn_pack medium icon"><span class="pre" style="filter: grayscale(100%); opacity:88%;"></span><input value="Back" type="submit"  onclick="fnGoSRList();"></span>
					</c:if>
				</li>
			</div>
	</div>
	<div id="bottomView" class="pdB15">
		<div id="ispTabFrame" style="width:100%;" class="mgT20"></div>	
	</div>
	
	<!-- 담당자 레이어 팝업 -->	
	<div class="item_layer" id="layerPopup">
		<div class="mgT10 mgB10 mgL5 mgR5">	 
		<table class="tbl_blue01 mgT5" style="width:100%;height:99%;table-layout:fixed;">
				<colgroup>
					<col width="20%">
					<col>
				</colgroup>
				<tr>
					<th class="alignL last">${menu.LN00028}</th>
					<td class="alignL last">${authorInfoMap.UserName}</td>
				</tr>
				<tr>	
					<th class="alignL last">${menu.LN00202}</th>
					<td class="alignL last">${authorInfoMap.TeamPath}</td>
				</tr>
				<!--tr>
					<th class="alignL last">${menu.LN00014}</th>
					<td class="alignL last">${authorInfoMap.OwnerTeamName}</td>
				</tr-->
				<tr>
					<th class="alignL last">Position</th>
					<td class="alignL last">${authorInfoMap.Position}</td>
				</tr>
				<tr>
					<th class="alignL last">E-mail</th>
					<td class="alignL last">${authorInfoMap.Email}</td>
				</tr>
				<tr>
					<th class="alignL last">Tel</th>
					<td class="alignL last">${authorInfoMap.TelNum}</td>	
				</tr>
			</table> 
		</div>
		<span class="closeBtn">
			<span style="cursor:pointer;_cursor:hand;position:absolute;right:10px;">Close</span>
		</span> 
		</div>
		
	</form>
	</div>
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
</script>
</body>
</html>