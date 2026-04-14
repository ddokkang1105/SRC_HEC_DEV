<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${backMessage}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00036" var="WM00036" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Approval path info."/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Approval path"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00154" var="WM00154" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00154" var="WM00155" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_1" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_2" arguments="${menu.LN00290}"/>

<script type="text/javascript">
	var categoryCnt = "${categoryCnt}";
	var p_gridArea;
	var defWFID = "${defWFID}";
	
	
	$(document).ready(function(){		

		$("input.datePicker").each(generateDatePicker);
		var aprvOption = "${getMap.AprvOption}";
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 440)+"px;");
		
		fnSetAprvOption(aprvOption);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=WF&radioID=wfID&docCode=CS&docSubClass=${docSubClass}";
		
		
		$("#resultRefName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultRefName','resultRefName');
				return false;
			}			
		});	
				
		var isDisabled = "N";
		
		if(defWFID != "")
			isDisabled = "Y";

		fnRadio('wfList', data, 'wfList', defWFID,"wfID",isDisabled);
		
		if(defWFID != "") {
			changeDimValue("",defWFID);
		}
		else {
			$("#grDIV").attr("style","display:none");
		}
		
		setTimeout(function() {
			$('input[type=radio][name=wfID]').change(function() {
				fnGetWFDescription();			
				changeDimValue("",$(this).val());
				$("#grDIV").attr("style","");
			});
			
			if(defWFID != "") {
				fnGetWFDescription();
			}
		}, 1500);
		
		
		gridWFInit("${wfDocType}");
		
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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
	function changeDimValue(GRID,WFID){
		var url    = "getAprvGroupList.do"; // 요청이 날라가는 주소
		var data   = "GRID="+GRID+"&GRType=MGT&WFID="+WFID; //파라미터들
		var target = "wfMGT";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(fnSetGRDiv,1000);
	}
	
	function fnSetGRDiv() {
		if($("#wfMGT option").size() < 1) {
			$("#grDIV").attr("style","display:none");
		}
	}
	
	
	function fnGetWFStep(wfID){				
		if(wfID == ""){ alert("${WM00041}");return; }
		wfID = wfID.split("(SPLIT)");
				
		if(wfID[3] != "NULL" && wfID[3] != "0") {
			changeDimValue(wfID[3]);			
			$("#grDIV").attr("style","");
		}
		else 
			$("#grDIV").attr("style","display:none");
		
	}
	
	function fnSetWFStepInfo(wfStepInfo,memberIDs,roleTypes,agrCnt,agrYN){
		$("#wfStepInfo").val(wfStepInfo);
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

		if(flg == "C") { 
					
			var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&wfID=WF001&agrYN=N&flg="+flg;
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
		if(agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}

		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == ""){alert("${WM00034}"); return;}
				
		if($("#subject").val() == "") {alert("${WM00007_1}"); return;}
		var temp = tinyMCE.get('description').getContent();
		if(temp == "") {alert("${WM00007_2}"); return;}
		
		var wfStepRoleTypes = $("#wfStepRoleTypes").val();
		var wfStepRefMemberIDs = $("#wfStepRefMemberIDs").val();
		var wfStepRecMemberIDs = $("#wfStepRecMemberIDs").val();
		var wfStepRecTeamIDs = $("#wfStepRecTeamIDs").val();
		
		if(categoryCnt == "1")
			setWfDocumentIDs();
		
		var mgtYN = $("#wfMGT option:selected").val();
		if(mgtYN != undefined && mgtYN != null && mgtYN != "") {
		} 
		else {  
			{alert("${WM00155}"); return;}
		}
		
		
		var url = "afterSubmitCheck.do?wfStepMemberIDs="+wfStepMemberIDs+"&wfStepRoleTypes="+wfStepRoleTypes+"&wfStepRefMemberIDs="+wfStepRefMemberIDs;
		url +="&wfStepRecMemberIDs="+wfStepRecMemberIDs+"&wfStepRecTeamIDs="+wfStepRecTeamIDs;
		var w = 400;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
	}
	
	
	// Submit 상신
	function fnSubmitWfInstInfo(){				
		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == "" || wfStepMemberIDs == undefined){alert("${WM00034}"); return;}
		var agrYN = $("#agrYN").val();
		var agrCnt = $("#agrCnt").val();
		if(agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}
		
		var wfID = $("#wfID").val();
		if(wfID == "" || wfStepMemberIDs == undefined){ alert("${WM00041}");return; }
	
		var wfID2 = $(':radio[name="wfID"]:checked').val();

		
		if(defWFID != "") {
			$("#wfID2").val(defWFID);
		}
		else if(wfID2 != "" && wfID2 != null) {
			$("#wfID2").val(wfID2);
		}

		var mgtYN = $("#wfMGT option:selected").val();
		if(mgtYN != undefined && mgtYN != null && mgtYN != "") {
			var memberIDs = $("#wfStepMemberIDs").val() + "," + mgtYN;
			var roleTypes = $("#wfStepRoleTypes").val() + "," + "MGT";
			$("#wfStepMemberIDs").val(memberIDs);
			$("#wfStepRoleTypes").val(roleTypes);
		} 
		else {  
			{alert("${WM00155}"); return;}
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
		
		if("${isPop}" == "Y") {
			self.close();
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
	}
	

	
</script>
</head>
<body>
<form name="wfInstInfoFrm" id="wfInstInfoFrm" method="post" action="#" onsubmit="return false;">
<div id="wfStepInfoDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
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
	<input type="hidden" id="noViewIDs" name="noViewIDs" value="" />
	<input type="hidden" id="documentID" name="documentID" value="${getPJTMap.ChangeSetID}"/>
	<input type="hidden" id="docSubClass" name="docSubClass" value="${docSubClass}" />
	<input type="hidden" id="documentNo" name="documentNo" value="${getPJTMap.Identifier}" />

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
				<th class="viewtop alignL pdL10" rowspan="2" >${menu.LN00140}</th>
				<td class="viewtop alignL last">
					<div id="wfList" class="floatL">					
					</div>
					&nbsp;&nbsp;<span class="btn_pack small icon" id="createWFStepInst"><span class="add"></span><input value="Create" type="button" OnClick="fnCreateWF('C');"></span>&nbsp;
					<span id="wfDescription" style="width:50%;">
					</span>
				</td>		
			</tr>	
			<tr>
				<td class="last alignL" >
					<input type="text" id="wfStepInfo" name="wfStepInfo" value="" style="border:0px;width:100%;"  >
				</td>
			</tr>
			
			<tr id="grDIV">
				<!-- 주관조직 담당자 -->
				<th class="alignL pdL10" >${menu.LN00045}</th>
				<td class="alignL last">
					
				 	<select id="wfMGT" name="wfMGT" style="width:40%;"></select>
				 </td>
			</tr>
			<tr>
				<th class="alignL pdL10">${menu.LN00245}<span class="btn_pack nobg plus" style="float:right;padding-right:10px;"><a class="reference"onclick="fnCreateWF('R');" title="Add"></a></span></th>
				<td class="last alignL" >
					<input type="text" id="wfStepRefInfo" name="wfStepRefInfo" value="" style="width:55%;border:0px;" readOnly>
				</td>
			</tr>	
		</table>
		
		<div class="cop_hdtitle mgT10" style="border-bottom:1px solid #ccc"></div>
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="22%">
			</colgroup>
			<tr>
				<!-- CSR 코드 -->
				<th class="viewtop alignL pdL10">
					Document No.
				</th>
				<td class="viewtop alignL pdL10 ">
					${newWFInstanceID}
				</td>
				<!-- 문서유형 -->
				<th class="viewtop alignL pdL10">${menu.LN00091}</th>
				<td class="viewtop alignL pdL10 ">${wfDocName}</td>				
				<!-- 담당자 -->
				<th class="viewtop alignL pdL10">${menu.LN00266}</th>
				<td class="viewtop alignL pdL10 last">
					${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})
				</td>
			</tr>	
			<tr>
				<!-- 제목  -->
				<th class=" alignL pdL10">${menu.LN00002}</th>
				<td class=" alignL pdL10 last"  colspan = 5 >
					<input type="text" class="text" id="subject" name="subject" value="${getPJTMap.ItemName}" style="width:100%;">
				</td>				
			</tr>	
		 	<tr>
				<th class="alignL pdL10">${menu.LN00290}</th>
			 	<td class="alignL pdL10 last" colspan="5" style="width:100%;height:160px;">
				 	<div style="width:100%;height:150px">		
						<textarea class="tinymceText" id="description" name="description" >${getPJTMap.Description}</textarea>	
					</div>	
				</td>
			</tr>
		</table>
		</div>	
		
	    <div class="countList pdT10">
		    <li class="count">Total  <span id="TOT_CNT"></span></li>
		    <li class="alignR"><span class="btn_pack small icon"><span class="edit"></span><input value="Remove" type="button" OnClick="fnSetNoViewIDs();"></span></li>
	 	</div>
		
		<!-- GRID -->	
		<div id="gridCngtDiv" style="width:100%;" class="clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
			
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
	</form>
</body>
</html>