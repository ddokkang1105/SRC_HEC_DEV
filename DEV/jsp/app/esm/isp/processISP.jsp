<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00273}"/> <!-- 서브카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00067}"/> <!-- 우선순위 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="Comment"/> <!-- Comment 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.LN00221}"/> <!-- 완료예정일  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_8" arguments="SR Classfication"/> <!-- SR Classfication  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00071" var="CM00071"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00171" var="WM00171"/>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";

	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('category', data+"&level=1", 'getESMSRCategory', '${srInfoMap.Category}', 'Select', 'esm_SQL');
		fnGetSubCategory("${srInfoMap.Category}","${srInfoMap.SubCategory}");
		fnSelect('srArea1', data, srArea1ListSQL, '${srInfoMap.SRArea1}', 'Select', 'esm_SQL');
		fnGetSRArea2('${srInfoMap.SRArea1}');
		fnSelect('itemTypeCd',data+"&level=1", 'getItemTypeListBySRType', '', 'Select', 'esm_SQL');
		fnSelect('priority', data+"&category=PRT", 'getDictionaryOrdStnm', '${srInfoMap.Priority}', 'Select');
		fnSelect('classification', data+"&category=SRCLS", 'getDictionaryOrdStnm', '${srInfoMap.Classification}', 'Select');
		fnSelect('srReason', data+"&category=SRRSN", 'getDictionaryOrdStnm', '${srInfoMap.SRReason}', 'Select');
		//fnSelect('responseTeam',data+"&teamType=3", 'getTeam', '${srInfoMap.ResponseTeamID}', 'Select');
		
		const itsmIF = document.getElementById("itsmIF");
		itsmIF.value = "${srInfoMap.ITSMIF}";
		
		if("${itemProposal}" == "Y") 
			$("#itemListTR").attr("style","display:none");		
	
		$('#dueDateTime').timepicker({
            timeFormat: 'H:i:s',
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
		
		//fnForumList();
		
		fnChangeCategory('${srInfoMap.Category}');
	});

		
	function fnSaveISPInfo(srArea3){
		if(!srArea3) {
			if(!confirm("${CM00001}")){ return;}
		}

		$("#srArea3").val(srArea3);
		//var subCategory = $("#subCategory").val();
		var comment = tinyMCE.get('comment').getContent();
		
		//if(subCategory == ""){ alert("${WM00034_4}"); return false;}
		if(comment == ""){ alert("${WM00034_6}"); return false;}
		
		$('#srMode').val('N');
		//if("${srInfoMap.SRNextStatus}" == "ISP002") $('#status').val('ISP002'); else $('#status').val('');
		var priority = $("#priority").val() ; if(priority == ""){ $("#priority").val("03")}
		var url  = "updateESRInfo.do";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// SR 이관 
	function fnOpenTransferPop(){ 	
		var url = "goTransferItspPop.do?srID=${srInfoMap.SRID}&srType=${srType}&srArea1ListSQL=${srArea1ListSQL}";
		window.open(url,'window','width=1100, height=320, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	function fnCallBackSR(){
		var url = "processISP.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}"
						+"&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&projectID=${projectID}"
						+"&itemID=${itemID}&varFilter=${varFilter}&searchStatus=${searchStatus}&srStatus=${srStatus}";
		if( "${itemID}" == "" ) {
			if( "${projectID}" == "" ) var target = "mainLayer";
			else var target = "tabFrame";
		} else {
			var target = "srListDiv";
		}
		
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		}
		ajaxPage(url, data, target);
	}
	
	function fnGetSRArea2(SRArea1ID){ 
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
		fnSelect('srArea2', data, 'getSrArea2', '${srInfoMap.SRArea2}', 'Select');
	}
	
	function fnCompletion(){		
		if(!confirm("${CM00054}")){ return;}
		if(!fnCheckValidation()){return;}
		var url  = "completeESR.do?speCode=${srInfoMap.SRNextStatus}&svcCompl=Y&blockSR=Y";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	function fnGoSRList(){
		
		if("${option}" != "modifyCMP"){
			var url = "ispList.do";
			var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}&pageNum=${pageNum}&projectID=${projectID}"
						+ "&status=${status}&category=${category}&subCategory=${subCategory}&subject=${subject}"
						+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
						+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}"
						+ "&stSRDueDate=${stSRDueDate}&endSRDueDate=${endSRDueDate}&stCRDueDate=${stCRDueDate}&endCRDueDate=${endCRDueDate}"
						+ "&srReceiptTeam=${srReceiptTeam}&crReceiptTeam=${crReceiptTeam}&searchStatus=${searchStatus}&srStatus=${srStatus}"
						+"&varFilter=${varFilter}&itemID=${itemID}&multiComp=${multiComp}&itemTypeCode=${itemTypeCode}&srArea1=${srArea1}&srArea2=${srArea2}";
		} else {
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
				+ "&option=";
		}
		
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
		var itemTypeCd = $("#itemTypeCd").val();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		
		var category = $("#category").val() ;
		var priority = $("#priority").val() ;
		var comment = tinyMCE.get('comment').getContent();
		var dueDate = $("#dueDate").val() ; 
		var classification = $("#classification").val() ;
	
		if(category == ""){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(priority == ""){ alert("${WM00034_5}"); isCheck = false; return isCheck;}
		if(comment == ""){ alert("${WM00034_6}"); isCheck = false; return isCheck;}
		if(dueDate == ""){ alert("${WM00034_7}"); isCheck = false; return isCheck;}
		if(classification == ""){ alert("${WM00034_8}"); isCheck = false; return isCheck;}
		
		return isCheck;
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
		
	function fnReqITSApproval(){
		var url = "wfDocMgt.do?actionType=create&srID=${srInfoMap.SRID}&srType=${srType}"
				+ "&WFDocURL=${WFDocURL}&wfDocType=SR&ProjectID=${srInfoMap.ProjectID}"
				+ "&srRequestUserID=${srInfoMap.RequestUserID}"
				+ "&isPop=Y&blockSR=Y&speCode=SPE023";
		window.open(url,'window','width=1000, height=700, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnUpdateStatus(speCode){
		var srID = "${srInfoMap.SRID}"; 
		var url = "updateITMStatus.do";
		var data = "srID="+srID+"&status="+speCode;
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnReject(){
		var srID = "${srInfoMap.SRID}";
		var url = "rejectISP.do";
		var data = "srID="+srID+"&blockSR=Y&svcCompl=Y";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	$("#transferItem").click(function(e){
		var itemTypeCode = "${itemTypeCode}";
		if(itemTypeCode == null || itemTypeCode == ""){
			itemTypeCode = "OJ00001";	
		}
		var url = "orgItemTreePop.do";
		var data = "ItemID=${srInfoMap.SRArea3}&ItemTypeCode="+itemTypeCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	});
	
	function doCallBack(itemID){
		if(!confirm("${CM00035}")){ return;}
		var url = "changeISPItem.do";
		var data = "itemID="+itemID
					+ "&itemTypeCode=${itemTypeCode}"
					+ "&srType=${srType}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&srID=${srInfoMap.SRID}"
					+ "&subject=${srInfoMap.Subject}";
		if( "${itemID}" == "" ) {
			var target = "mainLayer";
		} else {
			var target = "actFrame";
		}
		ajaxPage(url, data, target);
		$(".popup_div").hide();
		$("#mask").hide();
	}
	
	function thisReload(){
		fnItemMenuReload();
	}
	
	function fnCheckOut(){
		var projectNameList = "${projectNameList}";
		
		if(checkOutFlag == "N") {
			if(parseInt(projectNameList)>0){
				dhx.confirm({
					text: "${CM00042}",
					buttons: ["No", "Yes"],
					css: "align-center"
				}).then(function(result){
					if(result){
						var url = "cngCheckOutPop.do?";
						var data = "s_itemID=${srInfoMap.SRArea3}&checkType=OUT&srID=${srInfoMap.SRID}";
					 	var target = self;
					 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
					 	window.open(url+data, 'CheckOut', option);
					 	checkOutFlag = "Y";
					}
				});
			}else{
				if(confirm("${CM00057}")){
					//var url = "csrDetailPop.do?isNew=Y&quickCheckOut=Y&itemID=${s_itemID}";	
					var url = "registerCSR.do?quickCheckOut=Y&itemID=${s_itemID}&srID=${srInfoMap.SRID}";
					window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
				} 
			}			
		}
		else {
			//alert(""); --> Edit Start 진행 도중 재 클릭 하였을 시 노출 시킬 경고 메시지를 추가 할 경우 해당 주석을 제거 후 메시지 추가
		}
	}
	
	function selectCheckOutItem(csrID) {
		var url = "checkOutItem.do";		
		var data = "projectID="+csrID+"&itemIds=${srInfoMap.SRArea3}&srID=${srInfoMap.SRID}";
		var target="blankFrame";			
		ajaxPage(url, data, target);
	}
	
	function fnGoNext(){
		var srID = "${srInfoMap.SRID}";
		var url = "processNextStep.do";
		var data = "srID="+srID;
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnGetSubCategory(category,subCategory){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+category+"&level=2";
		fnSelect('subCategory', data, 'getESMSRCategory', subCategory, 'Select', 'esm_SQL');
	}
	
	function fnRequestEvaluation(){
		if(!confirm("${CM00063}")){ return;}
		var srID = "${srInfoMap.SRID}"; 
		var url = "requestEvaluationPop.do?srID="+srID+"&status=ISP006&svcCompl=Y";
		var w = 800;
		var h = 450;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
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
	
	
	function fnForumList() { 	
		var srID = "${srInfoMap.SRID}";
		var srType = "${srType}";
	 	var varFilter = "${srInfoMap.BoardMgtID}";
		var s_itemID = "${srInfoMap.SRArea3}";
		var BoardMgtID = "${srInfoMap.BoardMgtID}";
		var url = "foruMgt";
		// 데이터를 URL 파라미터 형식으로 조합
		var data = "srID=" + encodeURIComponent(srID) + "&srType=" + encodeURIComponent(srType) 
		+ "&varFilter=" + encodeURIComponent(varFilter) + "&s_itemID=" + encodeURIComponent(s_itemID) 
		+ "&BoardMgtID=" + encodeURIComponent(BoardMgtID)
		+ "&url=foruMgt";
		
		var url = "boardList.do";
		//var data = "srID=${srInfoMap.SRID}&srType=${srType}&varFilter=${srInfoMap.BoardMgtID}&s_itemID=${srInfoMap.SRArea3}&BoardMgtID=${srInfoMap.BoardMgtID}";
		var target="forumListDiv";
		ajaxPage(url, data, target);			
	}
	
	function fnChangeCategory(SRCatID){
		$.ajax({
			url: "getSRCatAttrList.do",
			type: 'post',
			data: "&srID=${srInfoMap.SRID}&SRCatID="+SRCatID,
			error: function(xhr, status, error) { 
			},
			success: function(obj){			
				$("#srCatAttrData").val(obj);
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
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
								if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
								catAttrAreaHtml += "</th><td class='sline tit last' colspan=5 style='height:"+data.AreaHeight+"px;'>";
								catAttrAreaHtml += "<textarea class='tinymceText' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' style='width:98%;height:"+data.AreaHeight+"px;'>"+data.Value+"</textarea>";
							}else{
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
								if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
								catAttrAreaHtml += "</th><td class='sline tit last' colspan=5>";
								catAttrAreaHtml += "<input type='text' class='text' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' value='"+data.Value+"' placeholder='"+data.DefaultValue+"' onfocus=this.placeholder='' onblur=this.placeholder='' style='ime-mode:active;' />";
							}
						}else if(dataType == "LOV"){							
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
							if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
							catAttrAreaHtml += "</th><td class='sline tit last' colspan=5>";							
							catAttrAreaHtml += "<select id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' class='sel' OnChange=fnGetSubAttrTypeCode('"+data.AttrTypeCode+"','"+data.SubAttrTypeCode+"',this.value); >";
							catAttrAreaHtml += "<option value=''>Select</option>";  
							data.lovList.forEach(function (lovData) {	
								if(data.Value == lovData.CODE){
									catAttrAreaHtml += "<option value='"+lovData.CODE+"' selected>" + lovData.NAME + "</option>";  
								}else{
									catAttrAreaHtml += "<option value='"+lovData.CODE+"'>" + lovData.NAME + "</option>";  
								}
							});
							catAttrAreaHtml += "</select>";
							
						}else if(dataType == "MLOV"){
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
							if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
							catAttrAreaHtml += "</th><td class='sline tit last' colspan=3>";							
							data.MLovList.forEach(function (MLovData) {	
								if(MLovData.CODE == MLovData.LovCode){
									catAttrAreaHtml += "<input type='checkbox' id='"+data.AttrTypeCode + MLovData.CODE+"' name='"+data.AttrTypeCode + MLovData.CODE+"' value='"+MLovData.CODE+"' checked >"; 
								}else{
									catAttrAreaHtml += "<input type='checkbox' id='"+data.AttrTypeCode + MLovData.CODE+"' name='"+data.AttrTypeCode + MLovData.CODE+"' value='"+MLovData.CODE+"' >";
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
	
	function fnCheckSRCatAttr(){
		var attrChecked = true;
		var SRCatID = $("#category").val();
		var checkedMLOV = 0;
		var srCatAttrData = $("#srCatAttrData").val();		
		var jsonObj = JSON.parse(srCatAttrData); 

		if(jsonObj != ""){					
			jsonObj.forEach(function (data) {	
				var mandatory = data.Mandatory;
				var dataType = data.DataType;						
				var attrTypeName = data.AttrTypeName;
				if(mandatory == "1"){
					if(dataType == "MLOV"){
						data.MLovList.forEach(function (MLovData) {	
							if(document.all(data.AttrTypeCode + MLovData.CODE).checked == true){
								checkedMLOV = checkedMLOV + 1;
							}
						});
						if(checkedMLOV == 0){
							attrChecked = false; 									
							alert("<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00007' arguments='"+data.AttrTypeName+"' />");									
							return false;
						}else{
							attrChecked = true;
							return false;
						}
					}else{
						if($("#"+data.AttrTypeCode).val() == ""){								
							alert("<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00007' arguments='"+data.AttrTypeName+"' />");
							attrChecked = false; 
							return false;
						}else{
							attrChecked = true;
							return false;
						}
					}
				}
			});
		} 
		return attrChecked;
	}
	
	
	
	function addSharer(){
		var projectID = $("#projectID").val();
		var sharers = $("#sharers").val();
		
		var url = "selectMemberPop.do?mbrRoleType=R&projectID="+projectID+"&s_memberIDs="+sharers;
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
	}
	
	function fnForumList(){
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
		var target = "processSRDIV";
		ajaxPage(url, data, target);
	}
	
	// SR 삭제
	function fnDeleteSR(){
		
		if(!confirm("${CM00002}")){
			return;
		}else {
			var url = "deleteSRMST.do";
			var data = "&srID=${srInfoMap.SRID}";
			var target = "processSRDIV";
			ajaxPage(url, data, target);
		}
	}
	
	// SR 메일 보내기
	function fnSendMailSR() {
		if(!confirm("${CM00071}")){
			return;
		}else {
			var url = "sendMailSRMST.do";
			var data = "&srID=${srInfoMap.SRID}&srType=${srType}";
			var target = "processSRDIV";
			ajaxPage(url, data, target);
		}
	}
	
</script>
</head>
<body>
<div id="processSRDIV"> 
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="crCnt" name="crCnt" value="${crCnt}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}">
	<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<input type="hidden" id="srArea3" name="srArea3" value="">
	<input type="hidden" id="status" name="status" value="">	
	<input type="hidden" id="projectID" name="projectID" value="" >
	
	
	<c:choose>
		<c:when test="${itemID eq '' || itemID eq null }">
			<div class="cop_hdtitle">
				<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00282}</h3>
			</div>
		</c:when>
		<c:otherwise>
			<div class="child_search01 pdL10">
				<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;<b>${menu.LN00282}&nbsp;SR No.${srInfoMap.SRCode}</b>
			</div>
		</c:otherwise>
	</c:choose>
	
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="24%">
		</colgroup>		
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit last" colspan="3" id="subject">${srInfoMap.Subject}</td>	
			<!-- 요청자 -->
			<th class="alignL pdL10" >${menu.LN00025}</th>
			<td class="sline tit last" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM})</td>
		</tr>	
		<tr>
			<td colspan="6" class="tit last"><div style="height:230px; overflow: auto;" >${srInfoMap.Description}</div></td>
		</tr>
		
		<tr>
			<th class="alignL pdL10">SR No.</th>
			<td class="sline tit last">${srInfoMap.SRCode}</td>	
		 
			<th class="alignL pdL10">이슈처리 프로세스</th>
				<c:if test="${(srInfoMap.Status == 'ISP001' || srInfoMap.Status == 'ISP002')}" >
					<td class="sline tit last"><select id="category" name="category" class="sel"  style="width:90%">></select></td>
				</c:if>
				<c:if test="${(srInfoMap.Status ne 'ISP001' && srInfoMap.Status ne 'ISP002')}" >
					<td class="sline tit last">${srInfoMap.CategoryName} </td>
					<input type="hidden" name="category" id="category" value="${srInfoMap.Category}" />
				</c:if>	
			
			<!-- 완료예정일 -->
			<th class="alignL pdL10">${menu.LN00221}</th>
			<td class="sline tit last" >
				<c:if test="${srInfoMap.DueDate !=  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.DueDate}"	class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.DueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
				<c:if test="${srInfoMap.DueDate ==  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.ReqDueDate}" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.ReqDueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
			</td>
			</tr>
			
		<tr>	
			<!-- SR status -->		
			<th class="alignL pdL10">${menu.LN00065}</th>
			<td colspan="6" class="sline tit last alignL " >
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
		
				
		<c:if test="${srInfoMap.SRArea3 ne '0' && srInfoMap.SRArea3 ne null }">
			<tr>
					<!-- 항목 -->
					<th class="alignL pdL10">${menu.LN00087}</th>
					<c:if test="${srInfoMap.SRArea3Code == null}" >
						<td class="sline tit last"  colspan=3>N/A</td>	
					</c:if>
					<c:if test="${srInfoMap.SRArea3Code !=  null}" >
					<td class="sline tit last" id="srArea3" style="cursor:pointer;"><span style="color:blue;">${srInfoMap.SRArea3Code}&nbsp;${srInfoMap.SRArea3Name}</span></td>
					</c:if>
			
					<!-- Path -->
					<th class="alignL pdL10">Path</th>
					<td class="sline tit" colspan=3>${srInfoMap.srArea3Path}</td>
				</tr>
			</c:if>
			<tr>
			<c:if test="${srInfoMap.SRArea3 == '0' || srInfoMap.SRArea3 == null }">
				<!-- SR Area 1 -->
				<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
				<td class="sline tit last" >
					<select id="srArea1" Name="srArea1"  style="width:90%"> <option value=''>Select</option></select>
				</td>			
			</c:if>	
			 <!-- 본부 -->
			<!--  <th class="alignL pdL10">본부</th>				
			<td class="sline tit last"><select id="responseTeam" Name="responseTeam"  style="width:90%"> <option value=''>Select</option></select></td>
			 -->
			 <!-- 이슈 원인 -->
			<th class="alignL pdL10">주요 원인</th>			
			<td class="sline tit last" colspan=3>	
				<select id="srReason" name="srReason" class="sel" style="width:35.7%;margin-left=5px;"></select>
		    </td>		
		</tr>	
		
		 <tr>	
		    <!-- IT 연계 SR_MST.itsmIF 값을 Y or N으로 출력 -->
			<th class="alignL pdL10">IT 지원</th>			
			<td class="sline tit last">	
				<select id="itsmIF" name="itsmIF" class="sel" style="width:90%;margin-left=5px;">
					<option>Select</option>
					<option value="Y">Y</option>
					<option value="N" >N</option>
				</select>
		    </td>	
	        <!-- Classification -->
			<th class="alignL pdL10">난이도</th>
			<td class="sline tit last">
				<select id="classification" name="classification" class="sel" style="width:90%;margin-left=5px;"></select>
			</td>	
			
			<!-- Priority -->
			<th class="alignL pdL10">${menu.LN00067}</th>
			<td class="sline tit last"><select id="priority" name="priority" class="sel" OnChange="fnGetSubCategory(this.value);" style="width:90%">></select></td>	
			
		</tr>		
	</table>
	

	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0">
		<colgroup>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		  	<th class="alignL pdL10">Comment</th>		  
			<td style="height:150px;" class="tit last alignL pdL5 pdR5">
				<div style="width:100%;height:150px;">
					<textarea class="tinymceText"  id="comment" name="comment" >${srInfoMap.Comment}</textarea>
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
				<th class="alignL pdL10" style="height:53px;">${menu.LN00111}</th>
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
						<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
							<c:if test="${sessionScope.loginInfo.sessionUserId == srInfoMap.RegUserID}">
							<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteSRFile('${fileList.SRID}','${fileList.Seq}','${fileList.FileName}','${srFilePath}');">
							</c:if>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			<!-- 참조 -->
			<tr>
				<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
				<td class="sline tit last" colspan="3">
					<input type="text" class="text" id="sharerNames" name="sharerNames" value="${srSharerName}" readOnly style="border:0px;"/>			
					<input type="hidden" class="text" id="sharers" name="sharers" value="${srSharerID}" size="10"/>
				</td>
			</tr>	
		</table>
	
	<div class="alignBTN">	
	   <span class="btn_pack medium icon"><span class="list"></span><input value="Talk" type="submit"  onclick="fnForumList();"></span>		
	    
	    <!-- [Attach] [Save] ::: 만족도 평가 단계가 아닐 때 가능  -->
	    <c:if test="${(srInfoMap.Status != 'ISP007' && srInfoMap.Status != 'ISP008')}" >
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4();"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveISPInfo()"></span>
		</c:if>
		
		<!-- [Transfer] ::: 제안 단계 , 접수 단계 , 진행 중 단계 일 때 [담당자 변경] 가능  -->
		<c:if test="${(srInfoMap.Status == 'ISP001' || srInfoMap.Status == 'ISP002' || srInfoMap.Status == 'ISP004')}" >
			<span class="btn_pack medium icon"><span class="gov"></span><input value="Transfer" type="submit" onclick="fnOpenTransferPop();"></span>
		</c:if>
		
		<!-- [Receive] ::: 제안 단계 이며 현재 상태의 다음 단계가 마지막 단계가 아닐 때 [접수] 처리  -->
		<c:if test="${srInfoMap.Status eq 'ISP001' && srInfoMap.SRNextStatus ne srInfoMap.LastSpeCode }" >
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Receive" type="submit" onclick="fnGoNext()"></span>		
		</c:if>	
		
		<!-- [Accept] ::: 접수 단계이며  다음 단계가 진행 중 일 때 [수락] 가능 -->
		<c:if test="${srInfoMap.Status eq 'ISP002' && srInfoMap.SRNextStatus eq 'ISP004'}" >
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Accept" type="submit" onclick="fnGoNext()"></span>		
		</c:if>	
		
		<!-- [Request Approval] :::   -->
		<c:if test="${srInfoMap.Status eq 'ISP001' && srInfoMap.SRNextStatus eq 'ISP003'}" >
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Request Approval" type="submit" onclick="fnReqITSApproval()"></span>
		</c:if>	
		
		<!-- [Reject] ::: 다음 단계가 완료 이며 그게 끝 단계 일 때 [반려] 가능   -->
		<c:if test="${srInfoMap.SRNextStatus eq 'ISP006' && srInfoMap.SRNextStatus eq srInfoMap.LastSpeCode}" >
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Reject" type="submit" onclick="fnCompletion()"></span>
		</c:if>
		
		<!-- [Reject] ::: 다음 단계가 완료 이며 그게 끝 단계가 아니며 완료 처리가 안 된 상태일 때 [완료] 가능   -->
		<c:if test="${srInfoMap.SRNextStatus eq 'ISP006' && srInfoMap.SRNextStatus ne srInfoMap.LastSpeCode && srInfoMap.SvcCompl eq 'N'}" >
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletion()"></span>
		</c:if>		
		
		<!-- [Send Mail] ::: 만족도 평가 단계가 아닐 때 [메일 보내기] 가능 ( 화면 상 내용 x , 저장된 내용으로 ) -->
		<c:if test="${(srInfoMap.Status != 'ISP007' && srInfoMap.Status != 'ISP008') && option ne 'modifyCMP'}" >
			<span class="btn_pack small icon"><span class="word"></span><input value="Send Mail" type="submit" onclick="fnSendMailSR();"></span>
		</c:if>
		
		<!-- [Delete] ::: 제안 단계 일 때 [삭제] 가능  -->
		<c:if test="${(srInfoMap.Status == 'ISP001')}" >
			<span class="btn_pack medium icon"><span class="del"></span><input value="Delete" type="submit" onclick="fnDeleteSR();"></span>
		</c:if>
		
		<!-- [Back] ::: 팝업이 아닐 때 [뒤로가기] 가능  -->
		<c:if test="${isPopup != 'Y'}" >
			<span id="viewList" class="btn_pack medium icon"><span class="pre" style="filter: grayscale(100%); opacity:88%;"></span><input value="Back" type="submit"  onclick="fnGoSRList();"></span>
		</c:if>		   
	</div>	
	<div id="forumListDiv" style="width:100%;"></div>
</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>

</body>
</html>