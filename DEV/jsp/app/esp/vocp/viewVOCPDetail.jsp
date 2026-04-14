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
		
		// LOG LIST TEST
	    var url = "viewActivityLog.do";   
	    var target = "logList";
	    var data = "srID=${srInfoMap.SRID}";
	    ajaxPage(url, data, target);  
		
	});
	
	/*** SR Button function start ***/
	// [Request Evaluation]
	function fnRequestEvaluation(url,varFilter){
		if(!confirm("${CM00063}")){ return;}
		url += "?srID=${srInfoMap.SRID}&status=${srInfoMap.Status}" + varFilter;
		var w = 800;
		var h = 450;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Evaluation - V : View / E : Edit]
	function fnEvaluation(screenType,status){
		var url = "viewEvSheet.do?srID=${srInfoMap.SRID}&screenType="+screenType+"&srType="+"${srInfoMap.SRType}&status=" + status;
		var w = 600;
		var h = 780;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Self - CheckOut]
	function fnSelfCheckOut(url,varFilter){		
		if(!confirm("${CM00054}")){ return;}
		url += "?srID=${srID}"  + varFilter; 
		ajaxSubmit(document.receiptICPFrm, url,"saveFrame");
	}
	
	// [Back]
	function fnGoSRList(){
		fnGoVOCPList();
	}
	/*** SR Button function end ***/
	
	/*** SR callback function start ***/
	function doCallBack(){}
	
	function fnCallBackSR(){
		var url = "processVOCP.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}&srMode=${srMode}&srType=${srType}&esType=${esType}&scrnType=${scrnType}"
					+"&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&srStatus=${srStatus}&projectID=${projectID}"
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
	
	function fnGoVOCPList(){
		var url = "vocpList.do";
		var scrnType = "${scrnType}";		
		var data = "esType=${esType}&srType=${srType}&scrnType="+scrnType+"&srMode=${srMode}&pageNum=${pageNum}&projectID=${projectID}"
						+"&varFilter=${varFilter}&itemID=${itemID}&multiComp=${multiComp}&itemTypeCode=${itemTypeCode}"
						+"&srStatus=${srStatus}&status=${status}&searchStatus=${searchStatus}&category=${category}&subCategory=${subCategory}"
						+ "&srArea1=${srArea1}"
						+ "&srArea2=${srArea2}"
						+ "&defCategory=${defCategory}"
						+ "&subject=${subject}&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}&srReceiptTeam=${srReceiptTeam}"
						+ "&regStartDate=${regStartDate}&regEndDate=${regEndDate}&searchSrCode=${searchSrCode}&customerNo=${customerNo}";

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
	
	function fnReload(){
		fnCallBackSR();
	}

	function fnCallBack(){
		fnCallBackSR();
	}

	function thisReload(){
		fnItemMenuReload();
	}
	/*** SR callback function end ***/
	
	
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
			
			<tr>
				<!-- SR No -->
				<th class="alignL pdL10">${menu.LN00396}</th>
				<td colspan="5" class="sline tit last">${srInfoMap.SRCode}</td>	
			</tr>
			<tr>
				<th class="alignL pdL10">프로세스 명</th>
				<td class="sline tit last">${srInfoMap.SRTypeName}</td>	
				<!-- SR status -->		
				<th class="alignL pdL10">${menu.LN00065}</th>
				<td colspan="6" class="sline tit last alignL " >
					<c:choose>
						<c:when test="${fn:length(procStatusList) > 0}">
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
						</c:when>
						<c:otherwise>
							${srInfoMap.SRStatusName}
						</c:otherwise>
					</c:choose>
					
				</td>
			</tr>
			<tr>
				<!-- 요청자 -->
				<th class="alignL pdL10" >${menu.LN00025}</th>
				<td class="sline tit" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})</td>
				<!-- 담당자 -->
				<th class="alignL pdL10">${menu.LN00219}</th>			
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
				<td class="sline tit last" >${srInfoMap.SRArea1Name eq null ? 'N/A' : srInfoMap.SRArea1Name}</td>
				<!-- SR Area 2 -->
				<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
				<td class="sline tit last" >${srInfoMap.SRArea2Name eq null ? 'N/A' : srInfoMap.SRArea2Name}</td>
				<!-- 완료예정일 -->
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="sline tit last" >
					${srInfoMap.DueDate eq null ? 'N/A' : srInfoMap.DueDate} ${srInfoMap.DueDateTime}
				</td>
			</tr>
			<tr>
				<!-- 카테고리 -->
				<th class="alignL pdL10">${menu.LN00272}</th>
				<td class="sline tit last">${srInfoMap.CategoryName eq null ? 'N/A' : srInfoMap.CategoryName}</td>
				<!-- 서브카테고리 -->
				<th class="alignL pdL10">${menu.LN00273}</th>
				<td class="sline tit last">${srInfoMap.SubCategoryName eq null ? 'N/A' : srInfoMap.SubCategoryName}</td>
				<!-- 완료 요청일 -->
				<th class="alignL pdL10">완료요청일 </th>
				<td class="sline tit last" colspan="3">${srInfoMap.ReqDueDate eq null ? 'N/A' : srInfoMap.ReqDueDate} ${srInfoMap.ReqDueDateTime}</td>	
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
				<td class="sline tit last" colspan="6">${srSharerName}</td>
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
				<!-- ** EVENT BUTTON -->
				<c:forEach var="statusList" items="${nextStatusList}" varStatus="status">
					<!-- [self CheckOut] :: 2선 이관 후 그룹원이 접수 시 -->
					<c:if test="${statusList.SRNextSpePgrID eq 'PGR00012' && checkOutYN eq 'Y'}">
						<span class="btn_pack medium icon"><span class="confirm"></span><input value="self CheckOut" type="submit" onclick="fnSelfCheckOut('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
					</c:if>
					<!-- [Request Evaluation] ::: 로그인유저가 접수자 이며 다음단계가 만족도 평가 요청 단계 일 때 [만족도 조사 평가 요청] 가능  -->
					<c:if test="${statusList.SRNextSpePgrID eq 'PGR00004' && srInfoMap.Blocked eq 1 && srInfoMap.ReceiptUserID == sessionScope.loginInfo.sessionUserId }" >
						<span class="btn_pack medium icon"><span class="confirm"></span><input value="Request Evaluation" type="submit" onclick="fnRequestEvaluation('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
					</c:if>
					
					<!-- [Evaluate] ::: 로그인유저가 요청자 이며 다음단계가 마지막 단계 일 때 [만족도 조사 평가] 가능  -->
					<c:if test="${statusList.SRNextSpePgrID eq 'PGR00004' && srInfoMap.RequestUserID == sessionScope.loginInfo.sessionUserId}" >
						<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluate" type="submit" onclick="fnEvaluation('E','${statusList.SRNextStatus}');"></span>
					</c:if>
		   		</c:forEach>	
					
					<!-- ** BASIC BUTTON -->
					<!-- [Evaluation sheet] ::: 만족도 평가 ID가 존재할 때 [만족도 조사 결과 보기] 가능  -->
					<c:if test="${srInfoMap.EvalSheetID != '' && srInfoMap.EvalSheetID != null}" >	
						<span class="btn_pack medium icon"><span class="list"></span><input value="Evaluation sheet" type="submit" onclick="fnEvaluation('V','${statusList.SRNextStatus}');"></span>	
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
	
	<div id="logList"></div>
	
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
	
	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName)  {
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("viewSRDIV").scrollTop;
		var nTop = 80;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft - 30) + "px";
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
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	}
	//************** addFilePop V4 설정 START ************************//
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR&fltpCode=SRDOC";
		openPopup(url+"?"+data,490,450, "Attach File");
	}
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	function fnAttacthFileHtmlV4(fileID, fileName){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID);
		fileNameMapV4.set(fileID,fileName);
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
	}
	
	function fnDisplayTempFileV4(){				
		display_scripts=$("#tmp_file_items").html(); 
		fileIDMapV4.forEach(function(fileID) {			  
			  display_scripts = display_scripts+
				'<div id="'+fileID+'"  class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+')">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){		
		var fileName = document.getElementById(fileID).innerText;		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}
	} 
	//************** addFilePop V4 설정 END ************************//
</script>
</body>
</html>