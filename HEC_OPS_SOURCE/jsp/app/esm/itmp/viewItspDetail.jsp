<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html">
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


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";

	
	jQuery(document).ready(function() {		
		if(document.getElementById('viewSRDIV')!=null&&document.getElementById('viewSRDIV')!=undefined){
			document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";			
			window.onresize = function() {
				document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";	
			};
		}
			
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
		

		//if("${itemProposal}" == "Y") 
			$("#itemListTR").attr("style","display:done;");		
		
		gridCSListInit();
		
		
	});
	
	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("viewSRDIV").scrollTop;
		var nTop = 80;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft - 30) + "px";
	} 
	
	function fnSaveReceiveSRInfo(){
		if(!confirm("${CM00001}")){ return;}
	//	if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		var url  = "saveReceiveSRInfo.do";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	function fnCheckValidation(){
		var isCheck = true;
		if(isNotEmptyById("Subject", true)==false){return false;}
		//if(!fnTypingCheck("Content", 5000)){ return false;} 
		return isCheck;
	}
	function doDelete(){
		if(confirm("${CM00002}")){
			var url = "deleteBoard.do";
			ajaxSubmit(document.boardFrm, url,"saveFrame");
		}
	}	
	
	function fnCallBackSR(){ 
		var url = "processItsp.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}"
					+"&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&srID=${srInfoMap.SRID}"
					+"&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&projectID=${projectID}&itemID=${itemID}";
		var target = "help_content";
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		} 
		ajaxPage(url, data, target);
	}
	
	function fnGoSRList(){ 
		var url = "itspList.do";
		/* var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
					+ "&pageNum=${pageNum}&projectID=${projectID}&srStatus=${srStatus}&itemID=${itemID}" 
					+ "&status=${status}&category=${category}&subCategory=${subCategory}"
					+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}"
					+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
					+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}"
					+ "&stSRDueDate=${stSRDueDate}&endSRDueDate=${endSRDueDate}&stCRDueDate=${stCRDueDate}&endCRDueDate=${endCRDueDate}"
					+ "&searchSrCode=${searchSrCode}"
					+ "&srReceiptTeam=${srReceiptTeam}&crReceiptTeam=${crReceiptTeam}&itemProposal=${itemProposal}"; */
		var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
			+ "&pageNum=${pageNum}&projectID=${projectID}&srStatus=${srStatus}";

		var target = "help_content"; 
		if("${scrnType}"=="ITM"){
			target = "viewSRDIV";
		}
		ajaxPage(url, data, target);
	}
	
	function doAttachFile(){
		var browserType="";
		if($.browser.msie){browserType="IE";}
		//if($.browser.mozilla){browserType="MZL";}else if($.browser.mozilla){browserType="MZL";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		//fnOpenLayerPopup(url,data,"",400,400);
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,360,360, "Attach File");}
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

	function fnConfirmSR(){	
		var url = "confirmSR.do?srID=${srInfoMap.SRID}";
		var w = 500;
		var h = 380;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// SR 이관 
	function fnOpenTransferPop(){
		var url = "goTransferItspPop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=1100, height=320, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnCompletion(){		
			if(!confirm("${CM00054}")){ return;}
			var url  = "completionItsp.do?speCode=SPE012";
			ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
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
	
	
	function fnUpdateProposal(){
		if(!confirm("${CM00056}")){ return;}
		var url  = "updateProposal.do";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
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
		var target = "receiptSRFrm";
		ajaxPage(url, data, target);
	}
	

	function gridCSListInit(){
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
				
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);		
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";

		result.key = "esm_SQL.getSrItemList";
		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00027},${menu.LN00004},${menu.LN00070},1,2";
		result.cols = "CHK|Identifier|ItemNM|Path|StatusNM|AuthorName|LastUpdated|ItemID|Status";
		result.widths = "30,30,100,200,300,80,80,100,10,10";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&authorID=${sessionScope.loginInfo.sessionUserId}"
					+ "&itemTypeCode=${stItemType}"
					+ "&srID=${srInfoMap.SRID}";					
					
		return result;
	}
	
	// 그리드ROW선택시
	function gridOnRowSelect(id, ind){
		
		var itemId = p_gridArea.cells(id, 8).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
		
	}
	
	function fnEditItspDueDatePop(){
		var url = "editSRDueDuatePop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=500, height=220, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnEvaluation(screenType){
		var url = "viewEvSheet.do?srID=${srInfoMap.SRID}&screenType="+screenType+"&srType="+"${srInfoMap.SRType}";
		var w = 600;
		var h = 780;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnRegistSCR(){
		var url = "registerSCR.do?srID=${srInfoMap.SRID}";
		var w = 1100;
		var h = 650;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnViewScrDetail(scrID){
		var screenMode = "V";
		var url = "viewScrDetail.do";
		var data = "scrID="+scrID+"&screenMode="+screenMode+"&srID=${srInfoMap.SRID}"; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		fnCallBackSR();
	}
	
	/* function fnRequestEvaluation(){
		if(!confirm("${CM00063}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "updateESRStatus.do";
		var data = "srID="+srID+"&status=SPE012";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	} */
	
	function fnRequestEvaluation(){
		if(!confirm("${CM00063}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "requestEvaluationPop.do?srID="+srID+"&status=SPE012&speCode=SPE012";
		var w = 800;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
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

</script>
</head>
<body>
<div id="viewSRDIV" class="mgL5" style="width:99%;"> 
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<c:if test="${scrnType != 'ITSP003' }" >
		<div class="cop_hdtitle pgB10 mgB10" style="border-bottom:1px solid #ccc">
			<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00281}</h3>
		</div>
	</c:if>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
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
			<td colspan="5" class="sline tit last alignL " >
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
		</tr>
		<tr>
		  <th class="alignL pdL10" >${menu.LN00025}</th>
		    <c:if test="${MULTI_COMPANY != 'Y'}" >
				<td class="sline tit" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM})</td>
			</c:if>
			<c:if test="${MULTI_COMPANY == 'Y'}" >
				<td class="sline tit" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})</td>
			</c:if>
			<!-- 담당자 -->
			<th class="alignL pdL10">ITS&nbsp;${menu.LN00004}</th>			
			<td class="sline tit" id="authorInfo" style="cursor:pointer;_cursor:hand ;color:blue;">${srInfoMap.ReceiptName}(${srInfoMap.ReceiptTeamName})</td>
			<!-- Proposal status -->
			<th class="alignL pdL10">${menu.LN00245}</th>
			<td class="sline tit last">${sharerNames}</td>	
		</tr>
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
			<td class="sline tit last" >${srInfoMap.SRArea1Name}</td>
			<!-- 시스템 -->
			<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
			<c:if test="${srInfoMap.RoleType == 'A'}" >
				<td class="sline tit last">${srInfoMap.SRArea2Name} (${menu.LN00004} : ${srInfoMap.Area2RManager}/${srInfoMap.Area2RTeamName})</td>		
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
			<td class="sline tit " colspan="3">${srInfoMap.Subject}</td>
			<th class="alignL pdL10">SR No.</th>
			<td class="sline tit last">${srInfoMap.SRCode}</td>
		</tr>
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td colspan="4" style="height:200px;" class="tit last">
				<textarea class="tinymceText" id="description" name="description" style="width:100%;height:200px;">${srInfoMap.Description}</textarea>					
			</td>
		</tr>		
	</table>
	
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
	</table>
	<table class="tbl_brd mgT5 mgR5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		  	<th class="alignC pdL10">Comment</th>
			<td style="height:100px;" class="tit last" Valign="Top">${srInfoMap.Comment}</td>
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
		<c:if test="${srInfoMap.Status eq 'SPE004' && SPE005YN eq 'N' && srInfoMap.ReceiptUserID eq sessionScope.loginInfo.sessionUserId}" >				
			 <span class="btn_pack medium icon"><span class="edit"></span><input value="Request due date change" type="submit" onclick="fnRequestDueDate();"></span>
		</c:if>
		<c:if test="${srInfoMap.SRNextStatus eq 'SPE012' && srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId && scrCLSYN eq 'Y'}" >
			<span class="btn_pack medium icon"><span class="list"></span><input value="Request Evaluation" type="submit" onclick="fnRequestEvaluation();"></span>			
		</c:if>
		<c:if test="${srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.Status eq 'SPE012' && srInfoMap.SRNextStatus eq 'SPE013'}" >
			<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluate" type="submit" onclick="fnEvaluation('E');"></span>
		</c:if>		
		<c:if test="${srInfoMap.EvalSheetID != '' && srInfoMap.EvalSheetID != null}" >	
			<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluation Result" type="submit" onclick="fnEvaluation('V');"></span>	
		</c:if>	
		<c:if test="${(srInfoMap.Status eq 'SPE004' ||  srInfoMap.Status eq 'SPE005') && srInfoMap.ReceiptUserID eq sessionScope.loginInfo.sessionUserId && SPE005YN eq 'Y'}" >
			<span class="btn_pack medium icon"><span class="add"></span><input value="Create SCR" type="submit"  onclick="fnRegistSCR();" style="cursor:hand;"></span>	
		</c:if>
		
		<c:if test="${srInfoMap.ReceiptTeamID == sessionScope.loginInfo.sessionTeamId && (srInfoMap.Status == 'SPE001' || srInfoMap.Status == 'SPE002')}" >
		  <span id="viewSave" class="btn_pack medium icon"><span class="gov"></span><input value="Transfer" type="submit" onclick="fnOpenTransferPop();"></span>
		</c:if>		
	   
		<c:if test="${scrnType ne 'cust' }" >
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span>
		</c:if>
	</c:if>	
	</div>
	* Status history
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
		    <col width="20%">
		 	<col width="10%">
		    <col width="20%">
		 	<col width="30%">
		</colgroup>		
		<tr>
		  <th class="alignC pdL10">${menu.LN00132}</th> <!-- 진행단계 -->
		  <th class="alignC pdL10">${menu.LN00104}</th> <!-- 담당조직 -->
		  <th class="alignC pdL10">${menu.LN00004}</th> <!-- 담당자 -->
		  <th class="alignC pdL10">Time</th>
		  <th class="alignC pdL10">Comment</th>
		</tr>
		<c:forEach var="list" items="${prLgInfoList}" varStatus="status">
			<c:if test="${list.Link != ''}" ><tr style="height:26px;cursor:pointer;" OnClick="fnOpenDocument('${list.ActionID}','${list.Link}','${list.VarFilter}','${list.ActivityID}','${list.SEQ}');"></c:if>  
			<c:if test="${list.Link == ''}" ><tr style="height:26px;"></c:if>
				<c:choose>
				<c:when test="${status.last}">
					<td class="sline tit last alignL " style="font-weight:bold;color:blue;"> * ${list.ActivityName}</td>
					<td class="sline tit last alignC " style="font-weight:bold;color:blue;">${list.TeamName}</td>
					<td class="sline tit last alignC " style="font-weight:bold;color:blue;">${list.ActorName}</td>
					<td class="sline tit last alignC " style="font-weight:bold;color:blue;">${list.EndTime}</td>
					<td class="sline tit last alignL " style="font-weight:bold;color:blue;" id="historyCmt${status.count}"><span title="${list.Comment}">${list.CommentFiltered}</span></td>
				</c:when>
				<c:otherwise>
					<td class="sline tit last alignL " >${list.ActivityName}</td>
					<td class="sline tit last alignC " >${list.TeamName}</td>
					<td class="sline tit last alignC " >${list.ActorName}</td>
					<td class="sline tit last alignC " >${list.EndTime}</td>
					<td class="sline tit last alignL " id="historyCmt${status.count}"><span title="${list.Comment}">${list.CommentFiltered}</span></td>	</c:otherwise>
				</c:choose>
		</tr>
		</c:forEach>
	</table>
	<c:if test="${srInfoMap.Status == 'ITSP008'}" >
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		    <th class="alignC pdL10">Point</th>
			<td class="sline tit last">${srInfoMap.Spoint}</td>			
			<th class="alignC pdL10">Opinion</th>
			<td class="sline tit  last" >${srInfoMap.Opinion}</td>		
		</tr>
	</table>
	</c:if>
	
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
	</form>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>