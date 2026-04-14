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
<script src="${root}cmm/js/dhtmlx/dhtmlxSlider/codebase/dhtmlxcommon.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxSlider/codebase/dhtmlxslider.js"></script>

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>

<style>
		#sliderObj {
			height: 30px;
		}
</style>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var srType = "${srType}";
	var mySlider;
	
	jQuery(document).ready(function() {		
		if(document.getElementById('viewSRDIV')!=null&&document.getElementById('viewSRDIV')!=undefined){
			document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";			
			window.onresize = function() {
				document.getElementById('viewSRDIV').style.height = (setWindowHeight() - 80)+"px";	
			};
		}
		

		fnSelect('status', "&category=SRSTS", 'getDictionaryOrdStnm', '${srInfoMap.Status}', 'Select');
	
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
		
		mySlider = new dhtmlXSlider("sliderObj");

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

	function fnGoSRList(){
		var url = "srList.do";
		var data = "srType=${srType}&screenType=${screenType}&srMode=${srMode}"
					+ "&pageNum=${pageNum}&projectID=${projectID}&srStatus=${srStatus}&itemID=${itemID}" 
					+ "&status=${status}&category=${category}&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}"
					+ "&receiptUser=${receiptUser}&requestUser=${requestUser}"
					+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&dueDate=${dueDate}";
					
		var target = "help_content"; 
		if("${screenType}"=="ITM"){
			target = "viewSRDIV";
		}
		ajaxPage(url, data, target);
	}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		//if($.browser.mozilla){browserType="MZL";}else if($.browser.mozilla){browserType="MZL";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
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
		var url  = "fileDownload.do?&seq="+seq+"&scrnType=SR";
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
	
	function fileNameClick(avg1, avg2, avg3, avg4){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
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
		var url = "goTransferSRPop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=1000, height=320, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [Create CSR] 버튼 이벤트
	function addNewCsrPjt(avg) {
		//var isNew ="Y";		
		//var url = "csrDetailPop.do?isNew="+ isNew + "&btn=" + avg + "&mainMenu=${mainMenu}&s_itemID=${s_itemID}&screenType=${screenType}&srID=${srInfoMap.SRID}&fromSR=Y";
		var url = "registerCSR.do?&mainMenu=${mainMenu}&s_itemID=${s_itemID}&screenType=${screenType}&srID=${srInfoMap.SRID}&fromSR=Y";
		var w = 1100;
		var h = 420;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Create CR] 버튼 이벤트
	function fnCreateCR() {		
		var url = "addNewCr.do?crMode=SR"
					+ "&ProjectID=${srInfoMap.ProjectID}"
					+ "&isCrEdit=N"
					+ "&srID=${srInfoMap.SRID}" ;			
		var w = 1100;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	} 
	
	function fnCompletion(){		
			if(!confirm("${CM00054}")){ return;}
			//if(!fnCheckValidation()){return;}
			var url  = "completionSR.do";
			ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	function fnOnMouseOverCmt(id, comment){ 
	    document.getElementById(id).innerHTML = comment;
	}
	
	function fnOnMouseOutCmt(id, comment){
	    document.getElementById(id).innerHTML = comment;
	}
	
	function fnInsertFAQ(){
		if(!confirm("${CM00001}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "insertFAQFromSR.do";
		var data = "srID="+srID;
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	// SR Prog
	function fnOpenApproveSRPop(){
		var url = "goApproveSRPop.do?srID=${srInfoMap.SRID}&srType=${srType}";
		window.open(url,'window','width=1000, height=320, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
</script>
</head>
<body>
<c:if test="${isPopup != 'Y' }" >
<div id="viewSRDIV" style="width:99%;"> 
</c:if>
<c:if test="${isPopup == 'Y' }" >
<div id="viewSRDIV"style="padding: 0 6px 6px 6px; height:700px; overflow:scroll;overflow-y;overflow-x:hidden;"> 
</c:if>
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="screenType" name="screenType" value="${screenType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<c:if test="${screenType != 'CSR' }" >
		<div class="cop_hdtitle pgB10" style="border-bottom:1px solid #ccc">
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
			<td colspan = 3 class="sline tit last alignL " >
				<div id="sliderObj" min="-10" max="150" step="1" value="5" vertical="false" size="150"></div>
				<c:if test="${srInfoMap.ProcessType == '1' || srInfoMap.ProcessType == '0' }" >
						<c:forEach var="list" items="${srStatusList}" varStatus="statusList">		
							<c:if test="${list.SRCase == '1'}" >	
								<c:choose>					
										<c:when test="${list.TypeCode == srInfoMap.Status }">
											<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
										</c:when>
										<c:otherwise>				
											<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
										</c:otherwise>				  
								</c:choose>	
							</c:if>	
						</c:forEach>
				</c:if>	
				
				<c:if test="${srInfoMap.ProcessType == '2'}" >
					<c:forEach var="list" items="${srStatusList}" varStatus="statusList">		
						<c:if test="${list.SRCase == '1' || list.SRCase == '2'}" >	
							<c:choose>					
									<c:when test="${list.TypeCode == srInfoMap.Status }">
										<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
									</c:when>
									<c:otherwise>				
										<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
									</c:otherwise>				  
							</c:choose>	
						</c:if>	
					</c:forEach>
				</c:if>	
								
				<c:if test="${srInfoMap.ProcessType == '3'}" >
					<c:forEach var="list" items="${srStatusList}" varStatus="statusList">	
						<c:if test="${list.SRCase != '4' }" >			
							<c:choose>					
									<c:when test="${list.TypeCode == srInfoMap.Status }">
										<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
									</c:when>
									<c:otherwise>				
										<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
									</c:otherwise>				  
							</c:choose>
						</c:if>		
					</c:forEach>
				</c:if>
								
				<c:if test="${srInfoMap.ProcessType == '4'}" >
					<c:forEach var="list" items="${srStatusList}" varStatus="statusList">			
						<c:choose>					
								<c:when test="${list.TypeCode == srInfoMap.Status }">
									<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
								</c:when>
								<c:otherwise>				
									<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
								</c:otherwise>				  
						</c:choose>		
					</c:forEach>
				</c:if>
			</td>	
			<th class="alignL pdL10">${menu.LN00014}</th>
			<td class="sline tit  last" >${srInfoMap.CompanyName}</td>	
		</tr>
		<tr>
		  <th class="alignL pdL10" >${menu.LN00025}</th>
			<td class="sline tit last" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM})</td>
			<!-- 담당자 -->
			<th class="alignL pdL10">SR&nbsp;${menu.LN00004}</th>
			<td class="sline tit last" id="authorInfo" style="cursor:pointer;_cursor:hand ;color:blue;">${srInfoMap.ReceiptName}(${srInfoMap.ReceiptTeamName})</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}</th>
			<td class="sline tit  last" >${srInfoMap.ReqDueDate}</td>	
		</tr>
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10">${menu.LN00274}</th>
			<td class="sline tit last" >${srInfoMap.SRArea1Name}</td>
			<!-- 시스템 -->
			<th class="alignL pdL10">${menu.LN00185}</th>
			<c:if test="${srInfoMap.RoleType == 'A'}" >
				<td class="sline tit last">${srInfoMap.SRArea2Name} (${menu.LN00004} : ${srInfoMap.Area2RManager}/${srInfoMap.Area2RTeamName})</td>		
			</c:if>
			<c:if test="${srInfoMap.RoleType != 'A'}" >
				<td class="sline tit last">${srInfoMap.SRArea2Name}</td>		
			</c:if>			
				<!-- 완료예정일 -->
			<th class="alignL pdL10">${menu.LN00221}</th>
			<c:if test="${srInfoMap.DueDate == null}" >
				<td class="sline tit  last" >N/A</td>	
			</c:if>
			<c:if test="${srInfoMap.DueDate !=  null}" >
				<td class="sline tit  last" >${srInfoMap.DueDate}</td>	
			</c:if>			
			
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}</th>
			<td class="sline tit last">${srInfoMap.CategoryName}</td>
			<!-- 서브카테고리 -->
			<th class="alignL pdL10">${menu.LN00273}</th>
			<td class="sline tit last">${srInfoMap.SubCategoryName}</td>
			<!-- 우선순위  -->
			<th class="alignL pdL10">${menu.LN00067}</th>
			<td class="sline tit last" colspan="3">${srInfoMap.PriorityName}</td>
					
		</tr>			
		<tr>	
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit " colspan="3">${srInfoMap.Subject}</td>
			<!-- SR No -->
			<th class="alignL pdL10">SR No.</th>
			<td class="sline tit last" >${srInfoMap.SRCode}</td>	
		</tr>
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td colspan="4" style="height:200px;" class="tit last">
				<div style="width:100%;height:200px;">
					<textarea class="tinymceText" id="description" name="description" >${srInfoMap.Description}</textarea>					
				</div>
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
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}');">${fileList.FileRealName}</span>				
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
			<td style="height:100px;" class="tit last">${viewcomment}</td>
		</tr>			
	</table>
	
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
			<tr style="height:26px;">
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
	<c:if test="${srInfoMap.Status == 'CLS'}" >
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
	<div class="alignBTN">
		<c:if test="${screenType != 'CSR' && isPopup != 'Y' }" >
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span>
			<c:if test="${srInfoMap.Status == 'CMP' && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.processType != 0}" >
				&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Comfirm" type="submit" onclick="fnConfirmSR();"></span>
			</c:if>
			<c:if test="${srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId && srInfoMap.Status == 'MRV'}" >
				<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span>
					<input value="Approve SR" type="submit" onclick="fnOpenApproveSRPop()">
				</span>
			</c:if>
			<c:if test="${crCnt == 0}">
				<c:if test="${srInfoMap.ReceiptTeamID == sessionScope.loginInfo.sessionTeamId}" >
					<c:if test="${srInfoMap.Status == 'REQ' || srInfoMap.Status == 'RCV'}" >
						<span id="viewSave" class="btn_pack medium icon"><span class="gov"></span>
							<input value="Transfer" type="submit" onclick="fnOpenTransferPop();">
						</span>
					 </c:if>
				</c:if>
			</c:if>
			<c:if test="${(srInfoMap.Status == 'CSR' || srInfoMap.Status == 'CNG') && sessionScope.loginInfo.sessionAuthLev < 3 && srInfoMap.ProcessType == 3 && srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId  && csrBtn == 'Y'}" >
				<span id="viewSave" class="btn_pack medium icon"><span class="add"></span>
					<input value="Create CSR" type="submit" onclick="addNewCsrPjt('add')">
				</span>&nbsp;&nbsp;
		    </c:if>	
		     <c:if test="${srInfoMap.ProcessType == '2' && csrBtn == 'Y' && srInfoMap.Status == 'CNG'}" > 
					<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span>
						<input value="Complete" type="submit" onclick="fnCompletion()">
					</span>&nbsp;&nbsp;
				</c:if>	
		   <c:if test="${srInfoMap.Status == 'CLS'  && sessionScope.loginInfo.sessionAuthLev < 3 && csrBtn == 'Y'}" >
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span>
				<input value="Register FAQ" type="submit" onclick="fnInsertFAQ()">
			</span>
			</c:if>
		</c:if>
	 </div>
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