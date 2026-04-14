<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${backMessage}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00036" var="WM00036" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Approval path info."/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Approval path"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00154" var="WM00154" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00155" var="WM00155" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_1" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_2" arguments="${menu.LN00290}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00169" var="WM00169" arguments="1"/>
<style>

.tbl_blue01 input.text {
    border: 1px solid #c5c5c5; !important;
    padding: 3px 0px 3px 0px; !important;
  
}

.tbl_blue01 td {
    padding: 5px;!important;
    border: 1px solid #ddd;!important;
}

/* 추가 CSS */
#grdGridArea {
  max-height: 150px;        /* 넘치면 이 높이에서만 스크롤 */
  overflow-y: auto;      
  overflow-x: hidden;
  box-sizing: border-box;   
}

</style>
<script type="text/javascript">
	var categoryCnt = "${categoryCnt}";
	var p_gridArea;
	var defWFID = "${defWFID}";
	var pathFlg = "${pathFlg}";
 	//var changeType = "${getData.ChangeTypeCode}";

	$(document).ready(function(){		

		
		$("input.datePicker").each(generateDatePicker);
	
		var aprvOption = "${getMap.AprvOption}";
		// 초기 표시 화면 크기 조정 
		
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 650)+"px;");
		};
		
	
		
		fnSetAprvOption(aprvOption);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=WF&radioID=wfID&docCode=CS";
		
		fnSelect('changeType', data+"&category=CNGT1", 'getDictionaryOrdStnm', '${getPJTMap.ChangeTypeCode}', 'Select');	
		
		
		$("#resultRefName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultRefName','resultRefName');
				return false;
			}			
		});	
		
		var isDisabled = "N";
		
		if(defWFID != "")
			isDisabled = "Y";
		
		if(defWFID != "" && pathFlg != "Y") {
			changeMgtGRID("",defWFID);
		}
		else {
			$("#grDIV").attr("style","display:none");
			$("#grEndDIV").attr("style","display:none");
		}
		
		
		if(pathFlg == "Y") {
			$("#wfList").html("${wfStepInfo}");
			//$("#createPath").attr("style","display:none");
			
			fnGetWFStepPath();
		}
		else {
		}
		
		gridWFInit("${wfDocType}");
		
	
		
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function fnGetWFStepPath(){ 

		$("#wfStepInfo").val("${wfStepInfo}");
		$("#wfStepInfoText").text("${wfStepInfo}");
		$("#wfStepMemberIDs").val("${memberIDs}");
		$("#wfStepRoleTypes").val("${roleTypes}");
	}
	
	function fnGetWFDescription(){ 
		var wfID = $('input:radio[name="wfID"]:checked').val();
		var url = "getWFDescription.do";
		var target = "saveFrame";
		var data = "&wfID="+wfID+"&category=WF";
		ajaxPage(url, data, target);
	}
	
	function fnSetWFDescription(wfDescription){
		$("#wfDescription").html(wfDescription);
	}

	// [dimValue option] 설정
	function changeMgtGRID(GRID,WFID){
		var url    = "getAprvGroupList.do"; // 요청이 날라가는 주소
		var data   = "GRID="+GRID+"&GRType=MGT&WFID="+WFID; //파라미터들
		var target = "wfMGT";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout("fnSetMgtGRDiv('"+GRID+"','"+WFID+"')",1000);
	}
	
	function changeEndGRID(GRID,WFID){
		var url    = "getAprvGroupList.do"; // 요청이 날라가는 주소
		var data   = "GRID="+GRID+"&GRType=End&WFID="+WFID; //파라미터들
		var target = "wfEND";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(fnSetEndGRDiv,1000);
	}
	
	function fnSetMgtGRDiv(GRID,WFID) {		
		if($("#wfMGT option").size() < 1) {
			$("#grDIV").attr("style","display:none");
		}
		changeEndGRID(GRID,WFID);
	}
	
	function fnSetEndGRDiv() {		
		if($("#wfEND option").size() < 1) {
			$("#grEndDIV").attr("style","display:none");
		}		
	}
	
	
	function fnGetWFStep(wfID){				
		if(wfID == ""){ alert("${WM00041}");return; }
		wfID = wfID.split("(SPLIT)");
				
		if(wfID[3] != "NULL" && wfID[3] != "0") {
			changeMgtGRID(wfID[3]);			
			$("#grDIV").attr("style","");
			$("#grEndDIV").attr("style","");
		}
		else {
			$("#grDIV").attr("style","display:none");
			$("#grEndDIV").attr("style","display:none");
		}
		
	}
	
	function fnSetWFStepInfo(wfStepInfo,memberIDs,roleTypes,agrCnt,agrYN){
		$("#wfStepInfo").val(wfStepInfo);
		$("#wfStepInfoText").text(wfStepInfo);
		$("#wfStepMemberIDs").val(memberIDs);
		$("#wfStepRoleTypes").val(roleTypes);
		$("#agrCnt").val(agrCnt);
		$("#agrYN").val(agrYN);
		
	}

	function fnSetWFStepInfo2(wfStepRefIDs,wfStepRefInfo,wfStepRecIDs,wfStepRecInfo,wfStepRecTeamIDs){
		$("#wfStepRefMemberIDs").val(wfStepRefIDs);
		$("#wfStepRefInfo").val(wfStepRefInfo);
		$("#wfStepRecMemberIDs").val(wfStepRecIDs);
		$("#wfStepRecInfo").val(wfStepRecInfo);
		$("#wfStepRecTeamIDs").val(wfStepRecTeamIDs);
	}
	
	function fnCreateWF(flg){
	
	//	$("#wfDescription").html(wfID[2]);
		if(flg == "C") { 
					
			var wfStepMemberIDs = $("#wfStepMemberIDs").val();
			var wfStepRoleTypes = $("#wfStepRoleTypes").val();
			if(wfStepMemberIDs == "${sessionScope.loginInfo.sessionUserId}") wfStepMemberIDs = "";
			if(wfStepRoleTypes == "AREQ") wfStepMemberIDs = "";
			var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&wfID="+defWFID+"&agrYN=N&flg=C&SelectMember="+wfStepMemberIDs+"&tmpSelSHR="+wfStepRoleTypes;
			var w = 900;
			var h = 700;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		}
		else {
			var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&flg="+flg;
			var w = 900;
			var h = 700;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}
	}
	
	function fnSetAprvOption(aprvOption){
		$('#aprvOption').val(aprvOption);
	}
	
	
	// 임시저장
	function fnSaveWfInstInfo(){		
		if(confirm("${CM00001}")){			

			setWfDocumentIDs();
			
			var url = "saveWFInstInfo.do";
			ajaxSubmit(document.wfInstInfoFrm, url);
		}
	}
	
	// 저장 전 check
	function fnAfterCheck(){		
		

		var agrYN = $("#agrYN").val();
		var agrCnt = $("#agrCnt").val();
		//if(pathFlg != "Y" && agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}

		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == ""){alert("${WM00034}"); return;}
		
		if(pathFlg != "Y") {
			var mgtYN = $("#wfMGT option:selected").val();
			if(mgtYN != undefined && mgtYN != null && mgtYN != "") {
			} 
			else {  
				//alert("${WM00155}"); 
				//return;
			}
		}

	
		
		if($("#subject").val() == "") {alert("${WM00007_1}"); return;}
		//var temp = tinyMCE.get('description').getContent();
	    var description = $("#description").val();
		if(description == "") {alert("${WM00007_2}"); return;}

		var wfStepRoleTypes = $("#wfStepRoleTypes").val();
		var wfStepRefMemberIDs = $("#wfStepRefMemberIDs").val();
		var wfStepRecMemberIDs = $("#wfStepRecMemberIDs").val();
		var wfStepRecTeamIDs = $("#wfStepRecTeamIDs").val();
		
		if(categoryCnt == "1")
			setWfDocumentIDs();
		
		var url = "afterSubmitCheck.do?wfStepMemberIDs="+wfStepMemberIDs+"&wfStepRoleTypes="+wfStepRoleTypes+"&wfStepRefMemberIDs="+wfStepRefMemberIDs;
		url +="&wfStepRecMemberIDs="+wfStepRecMemberIDs+"&wfStepRecTeamIDs="+wfStepRecTeamIDs;

		if(pathFlg != "Y") {
			var endYN = $("#wfEND option:selected").val();
			if(endYN != undefined && endYN != null && endYN != "") {
				url += "&endGRID="+endYN;
			} 
			else {  
				//alert("${WM00155}"); 
				//return;
			}
		}
		var w = 600;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
	}
	
	
	// Submit 상신
	function fnSubmitWfInstInfo(){			
		
		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == "" || wfStepMemberIDs == undefined){alert("${WM00034}"); return;}
		var agrYN = $("#agrYN").val();
		var agrCnt = $("#agrCnt").val();
		//if(pathFlg != "Y" && agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}
		
		var wfID = $("#wfID").val();
		if(wfID == "" || wfStepMemberIDs == undefined){ alert("${WM00041}");return; }
	
		var wfID2 = $(':radio[name="wfID"]:checked').val();

		if(defWFID != "") {
			$("#wfID2").val(defWFID);
		}
		else if(wfID2 != "" && wfID2 != null) {
			$("#wfID2").val(wfID2);
		}

		if(pathFlg != "Y") {
			var endYN = $("#wfEND option:selected").val();
			if(endYN != undefined && endYN != null && endYN != "") {
				var memberIDs = $("#wfStepMemberIDs").val() + "," + endYN;
				var roleTypes = $("#wfStepRoleTypes").val() + "," + "APRV";
				$("#wfStepMemberIDs").val(memberIDs);
				$("#wfStepRoleTypes").val(roleTypes);
			} 
			else {  
				//alert("${WM00155}"); 
				//return;
			}
	
			var mgtYN = $("#wfMGT option:selected").val();
			if(mgtYN != undefined && mgtYN != null && mgtYN != "") {
				var memberIDs = $("#wfStepMemberIDs").val() + "," + mgtYN;
				var roleTypes = $("#wfStepRoleTypes").val() + "," + "MGT";
				$("#wfStepMemberIDs").val(memberIDs);
				$("#wfStepRoleTypes").val(roleTypes);
			} 
			else {  
				//alert("${WM00155}"); 
				//return;
			}
		}
		
		
		
		// 1. TinyMCE 에디터 내용 가져와서 hidden input에 넣기
		var desc = $("#description").val(); // WYSIWYG 텍스트
		document.getElementById("Description").value = desc;

		// 2. validFrom 입력창 값 복사
			var validFromVal = document.getElementById("validFrom").value.trim();
			
			if (validFromVal === "") {
			    document.getElementById("ValidFrom").value = null;
			} else {
			    document.getElementById("ValidFrom").value = validFromVal;
			}

		
		var url = "submitOLMWfInst.do";
		ajaxSubmit(document.wfInstInfoFrm, url);
		
	}
	
	// [Previous]
	function goPrevious() {		 
		 if(confirm("${CM00029}")){
			var screenType = "${screenType}";
			var url = "${backFunction}";
			var callbackData = "${callbackData}";
			var data = "screenMode=V&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}"+callbackData;
			var target = setTarget("${wfDocType}");			

			ajaxPage(url, data, target);
		} 
	}
		
	function fnCallBack(){
		goSetWfStepInfo();
	}
	
	function fnNoSubmitCallBack(grName){
		msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00153' var='WM00153' arguments='"+ grName +"'/>";
		alert("${WM00153}");
	}
	
	// Submit CallBack
	function fnCallBackSubmit() {	
		//console.log("fnCallBackSubmit");
		if("${isPop}" == "Y") {
			//self.opener = self;
			//백그라운드 화면 리프레쉬
			window.opener.fnReload(); 
			window.close();
		}
		else {
			var screenType = "${screenType}";
			var url = "${backFunction}";
			var callbackData = "${callbackData}";
			var data = "screenMode=V&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}"+callbackData;
		    var target = "wfStepInfoDiv";
		    
		    ajaxPage(url, data, target);
		}
	}
	
	function searchPopupWf(avg,type){		
		var url = avg + "&searchValue=" + encodeURIComponent($('#'+type).val()) + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}

	function setTarget(docType) {
		if(docType == "CSR" || docType == "PJT"){ return "projectInfoFrm"; }
		else if(docType == "CS"){ return  "changeInfoViewFrm"; }
		else if(docType == "SR"){ return  "receiptSRFrm"; }
		else { return "help_content"; }
	}
	
	function fnDeleteRefInfo(){
		if(confirm("${CM00002}")){
			$("#wfStepRefMemberIDs").val("");
			$("#wfStepRefInfo").val("");
			$("#resultRefName").val("");
		}
	}
	
	function fnDeleteAgrInfo(){
		if(confirm("${CM00002}")){
			$("#wfStepAgrMemberIDs").val("");
			$("#wfStepAgrInfo").val("");
			$("#resultAgrName").val("");
		}
	} 
	

	// 유저 검색 text clear
	function schResultAgrClear() {
		$('#resultAgrName').val("");
	}
	

	// 유저 검색 text clear
	function schResultRefClear() {
		$('#resultRefName').val("");
	}
	

	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function goCSRDetail(){
		var projectID = "${ProjectID}";
		
		var isNew ="R";
		var mainMenu = "${mainMenu}";
		var s_itemID = "${s_itemID}";
		var url = "csrDetailPop.do?ProjectID=" + projectID + "&isNew=" + isNew + "&mainMenu=" + mainMenu + "&s_itemID="+s_itemID;	
		
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function goWFListCheck(){
		var projectID = "${ProjectID}";
		var wfDocumentIDs = "${wfDocumentIDs}";
		
		var wfDocType = $("#wfDocType").val();
		
		if(wfDocType == "CS") 
			projectID = wfDocumentIDs;
		
		var url = "getWFApprovalCheckList.do?documentIDs=" + projectID + "&wfDocType=" + wfDocType;	
		
		var w = 1200;
		var h = 400;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	

	/* ChangeSet List */
	function gridWFInit(avg){
		var d = setGridCngtData(avg);
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);

		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);		
	}
	
	function setGridCngtData(avg){
		var result = new Object();
		result.title = "${title}";
		
		result.key = "wf_SQL.getWFChangeSetList";
		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00106},${menu.LN00016},${menu.LN00002},${menu.LN00004},${menu.LN00027},${menu.LN00070},${menu.LN00022},,,";
		result.cols = "CHK|CODE|ClassName|Subject|AuthorName|StatusName|CompletionDT|ProjectID|ItemID|ChangeSetID|SRID";
		result.widths = "30,30,100,120,*,80,80,80,30,30,30,30";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&AuthorID=${sessionScope.loginInfo.sessionUserId}"
					+ "&status='CMP'" 
					+ "&noViewIDs="+$("#noViewIDs").val()
					+ "&pageNum=" + $("#currPageA").val();
					
		if("${isMulti}" == "Y")
			result.data += "&changeSetID=${wfDocumentIDs}";
		else 		
			result.data	+= "&changeSetID=${changeSetID}";
		
		return result;
	}
	
	function setWfDocumentIDs() {
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var checkedRows = p_gridArea.getAllRowIds().split(",");	
		
		for(var i = 0 ; i < checkedRows.length; i++ ){			
			if (items == "") {
				items = p_gridArea.cells(checkedRows[i], 10).getValue();
				projectID = p_gridArea.cells(checkedRows[i], 8).getValue();
			} else {
				items = items + "," + p_gridArea.cells(checkedRows[i], 10).getValue();
			}
		}
		
		$("#wfDocumentIDs").val(items);
		$("#projectID").val(projectID);
	}

	function fnSetNoViewIDs() {
		var items = $("#noViewIDs").val();
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var allRows = p_gridArea.getAllRowIds().split(",");
		
		if(allRows.length > 1) {
		
			for(var i = 0 ; i < checkedRows.length; i++ ){			
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 10).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 10).getValue();
				}
			}
			
			$("#noViewIDs").val(items);
			
			var d = setGridCngtData("${wfDocType}");
			fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);		
		} else {
			alert("${WM00169}");
		}
	}
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=CS&id=${getPJTMap.ChangeSetID}&docCategory=CS&fltpCode=CSDOC&projectID=${ProjectID}";
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
</head>
<body>
<form name="wfInstInfoFrm" id="wfInstInfoFrm" method="post" action="#" onsubmit="return false;">
<div style="padding:0 20px;">
<div id="wfStepInfoDiv" style="padding: 0 6px 6px 6px; height:400px; width:100%;"> 
	<input type="hidden" id="projectID" name="projectID"  value="${ProjectID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="wfID2" name="wfID2" />
	<input type="hidden" id="isNew" name="isNew" value="${isNew}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>
	<input type="hidden" id="aprvOption" name="aprvOption" />
	<input type="hidden" id="srID" name="srID" value="${srID}"/>
	<input type="hidden" id="Status" name="Status" value="${getPJTMap.Status}"/>
	<input type="hidden" id="createWF" name="createWF" value=""/>
	<input type="hidden" id="wfDocType" name="wfDocType" value="${wfDocType}"/>
	<input type="hidden" id="wfInstanceID" name="wfInstanceID" value="${wfInstanceID}"/>
	<input type="hidden" id="wfStepMemberIDs" name="wfStepMemberIDs" value="${wfStepMemberIDs}"/>
	<input type="hidden" id="wfStepRoleTypes" name="wfStepRoleTypes" value="${wfStepRoleTypes}"/>
	<input type="hidden" id="wfStepRefMemberIDs" name="wfStepRefMemberIDs" value="${wfStepRefMemberIDs}" />
	<input type="hidden" id="wfStepRecMemberIDs" name="wfStepRecMemberIDs" value="" />
	<input type="hidden" id="wfStepRecTeamIDs" name="wfStepRecTeamIDs" value="" />
	<input type="hidden" id="wfStepAgrMemberIDs" name="wfStepAgrMemberIDs" value="${wfStepAgrMemberIDs}" />
	<input type="hidden" id="wfDocumentIDs" name="wfDocumentIDs" value="${wfDocumentIDs}" />
	<input type="hidden" id="isMulti" name="isMulti" value="${isMulti}" />
	<input type="hidden" id="agrYN" name="agrYN" value="${agrYN }" />
	<input type="hidden" id="agrCnt" name="agrCnt" value="${agrCnt }" />
	<input type="hidden" id="docSubClass" name="docSubClass" value="${docSubClass}" />
	<input type="hidden" id="noViewIDs" name="noViewIDs" value="" />
	<input type="hidden" id="documentID" name="documentID" value="${getPJTMap.ChangeSetID}"/>
	<input type="hidden" id="documentNo" name="documentNo" value="${getPJTMap.Identifier}"/>
	<input type="hidden" id="Description" name="Description" value=""/>
	<input type="hidden" id="ValidFrom" name="ValidFrom" value=""/>
	<!-- 화면 타이틀 : 결재경로 생성-->	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<ul>
			<li>
				<h3 style="padding: 6px 0 6px 0">
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00211}
				</h3>
			</li>
	        <li class="floatR mgT10">  
				<!-- span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveWfInstInfo()" type="button"></span> -->
				<span class="btn_pack medium icon"><span class="save"></span><input value="Submit" onclick="fnAfterCheck()" type="button"></span> 
			</li> 
		</ul>	
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
		<table class="tbl_blue01" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="88%">						
			</colgroup>
			<tr>
				<!-- 결재선 생성 -->
				<th class="viewtop alignL pdL10">${menu.LN00140}&nbsp;&nbsp;&nbsp;<span class="btn_pack nobg plus" style="float:right;padding-right:5px;" id="createPath"><a class="reference"onclick="fnCreateWF('C');" title="Add"></a></span>
					</th>
				<td class="viewtop last alignL" >
					<input type="text" id="wfStepInfo" name="wfStepInfo" value="" style="border:0px;display:none;" >
					<span id="wfStepInfoText" style=""></span>				
				</td>		
			</tr>	
			
			<tr id="grDIV">
				<!-- Management Group-->
				<th class="alignL pdL10" >${menu.LN00045}</th>
				<td class="alignL last">
					
				 	<select id="wfMGT" name="wfMGT" style="width:40%;"></select>
				 </td>
			</tr>
			<tr id="grEndDIV">
				<!-- Final Approver -->
				<th class="alignL pdL10" >${menu.LN00266}</th>
				<td class="alignL last">					
				 	<select id="wfEND" name="wfEND" style="width:40%;"></select>
				 </td>
			</tr>
			<tr>
				<th class="alignL pdL10">${menu.LN00245}<span class="btn_pack nobg plus" style="float:right;padding-right:5px;"><!-- <a class="reference"onclick="fnCreateWF('R');" title="Add"></a> --></span></th>
				<td class="last alignL" >
					<input type="text" id="wfStepRefInfo" name="wfStepRefInfo" value="" style="width:55%;border:0px;" readOnly>
				</td>
			</tr>		
			
			<tr>
				<th class="alignL pdL10">${menu.LN00117}<span class="btn_pack nobg plus" style="float:right;padding-right:5px;"><!-- <a class="reference"onclick="fnCreateWF('R');" title="Add"></a> --></span></th>
				<td class="last alignL" >
					<input type="text" id="wfStepRecInfo" name="wfStepRecInfo" value="" style="width:100%;border:0px;" readOnly>
				</td>
			</tr>			
		</table>
		
		<div class="cop_hdtitle mgT10" style="border-bottom:1px solid #ccc"></div>
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="20%">
				<col width="10%">
				<col width="20%">
				<col width="5%">
				<col width="20%">
			    <col width="5%">
			   <col width="10%"> 
			</colgroup>
			<tr>
				<!-- CSR 코드 -->
				<th class="viewtop alignL pdL10">
					Document No.
				</th>
				<td class="viewtop alignL pdL10 ">
					${newWFInstanceID}
				</td>
	
				<!-- 변경구분 -->
				<th class="alignL pdL10">${menu.LN00022}</th> 
					<td class="last">
						<select id="changeType" name="changeType" style="width:100%"></select>						
					</td>
					
				<!-- 담당자 -->
				<th class="viewtop alignL pdL10">${menu.LN00060}</th>
				<td class="viewtop alignL pdL10 last">
					${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})
				</td>
				<!-- Version -->
				<th  class="viewtop alignL pdL10">${menu.LN00017}</th>
				<td  class="viewtop last">
				${getPJTMap.Version}
					<input type="hidden" id="version" name="version" value="${getPJTMap.Version}" class="text" style="width:100%">
				</td>
			
			
			</tr>	
			<tr>
				<!-- 시행일  -->
				<th class="alignL pdL10">${menu.LN00296}</th>
				<td class="alignL pdL10 last" colspan = "7" >
				 <input type="text" id="validFrom" name="validFrom" value="${getPJTMap.ValidFrom}"	class="input_off datePicker stext" size="10"
						style="width: 150px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
				</td>
			</tr>	
			<tr>
				<!-- 참조문서 -->
				<th class="alignL pdL10">${menu.LN00122}</th>
				<td colspan="7" style="height:53px;" class="alignL pdL5 last">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
							<c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID && fileList.DocCategory != 'ITM'}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('${fileList.Seq}')"></c:if>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			<tr>
				<!-- 제목  -->
				<th class=" alignL pdL10">${menu.LN00002}</th>
				<td class=" alignL pdL10"  colspan = "7" >
					<input type="text" class="text" id="subject" name="subject" value="${getPJTMap.Identifier} ${getPJTMap.ItemName}" style="width:100%;">
				</td>				
			</tr>
			<!-- 개요 -->	
		 	<tr> 
				<th class="alignL pdL10">${menu.LN00290}</th>
			 	<td class="alignL pdL10" colspan="7" style="width:100%;height:160px;">		
			 		<div style="width:100%;height:150px">
						<%-- <textarea class="tinymceText" id="description" name="description" >${getPJTMap.Description}</textarea>	 --%>
						 <textarea class="edit" id="description" name="description" style="width:100%;height:150px;">${getPJTMap.Description}</textarea>
					</div>
				</td>
			</tr>
			<!-- attach -->
			<tr>
	           <td colspan="8" class="alignR pdR20 last" bgcolor="#f9f9f9" >  		
	           		<c:if test="${fileTypeCount >= 1}">
						<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="doAttachFileV4()"></span>&nbsp;&nbsp;
		        	</c:if>
		
        	   </td>
      		</tr>
		</table>
	</div>	
		
	    <div class="countList pdT10">
	    <ul>
		    <li class="count">Total  <span id="TOT_CNT"></span></li>
		    <li class="alignR"><span class="btn_pack small icon" ><span class="edit"></span><input value="Remove" type="button" OnClick="fnSetNoViewIDs();"></span></li>
	 	</ul>
	 	</div>
		
		<!-- GRID -->	
		<div id="gridCngtDiv" style="width:100%;height:100%;" class="clear">
			<div id="grdGridArea" style="width:100%;height:100%;"></div>
		</div>
			
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
</div>
	</form>
</body>
</html>