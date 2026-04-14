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
<style>
.countList ul {
    display: flex;
   
    align-items: center; /* 세로 중앙 정렬 */
    padding: 0;
    margin: 0;
}



.wfDoc {
    /* 결재대상문서 항목을 오른쪽으로 이동 */
    margin-right: auto; /* 오른쪽 끝으로 밀어주는 속성 */
    color: #1141a1;
}

#TOT_CNT {
    margin-left: 10px; /* remove 와 간격 추가 */
}


	 
</style>
<script type="text/javascript">
	var categoryCnt = "${categoryCnt}";
	var p_gridArea;
	var defWFID = "${defWFID}";
	var pathFlg = "${pathFlg}";
	
	getCSFileList();
	getDictionary();
	
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
		
		// 자동결재선 생성
		if(pathFlg == "Y" && defWFID != "" && defWFID != "WF000") {
			$("#wfList").html("${wfStepInfo}");
			fnGetWFStepPath();
		}
		
		gridWFInit("${wfDocType}");
		
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 자동 결재선 생성
	function fnGetWFStepPath(){ 
		$("#wfStepInfo").val("${wfStepInfo}");
		$("#wfStepMemberIDs").val("${memberIDs}");
		$("#wfStepRoleTypes").val("${roleTypes}");
	}
	
	// 결재선 설명 불러오기
	function fnGetWFDescription(){ 
		var wfID = $('input:radio[name="wfID"]:checked').val();
		var url = "getWFDescription.do";
		var target = "saveFrame";
		var data = "&wfID="+wfID+"&category=WF";
		ajaxPage(url, data, target);
	}
	// 결재선 설명 셋팅
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
	
	// 주관조직 담당자 없으면 hide 처리
	function fnSetGRDiv() {
		if($("#wfMGT option").size() < 1) {
			$("#grDIV").attr("style","display:none");
		}
	}
	
	// 주관조직 담당자 setting
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
	
	// step info 셋팅
	function fnSetWFStepInfo(wfStepInfo,memberIDs,roleTypes,agrCnt,agrYN){
		$("#wfStepInfo").val(wfStepInfo);
		$("#wfStepMemberIDs").val(memberIDs);
		$("#wfStepRoleTypes").val(roleTypes);
		$("#agrCnt").val(agrCnt);
		$("#agrYN").val(agrYN);
	}
	// step info 셋팅
	function fnSetWFStepInfo2(wfStepRefIDs,wfStepRefInfo,wfStepRecIDs,wfStepRecInfo,wfStepRecTeamIDs){
		$("#wfStepRefMemberIDs").val(wfStepRefIDs);
		$("#wfStepRefInfo").val(wfStepRefInfo);
		$("#wfStepRecMemberIDs").val(wfStepRecIDs);
		$("#wfStepRecInfo").val(wfStepRecInfo);
		$("#wfStepRecTeamIDs").val(wfStepRecTeamIDs);
	}
	
	// 결재경로 수동 생성
	function fnCreateWF(flg){
		let clientID = "";
		clientID = "${sessionScope.loginInfo.sessionClientId}";
		if(clientID.includes("SKOH")) clientID = "SKOH";
		else if(clientID.includes("SKO")) clientID = "SKO";
				
		if(flg == "C") { 
			var wfStepMemberIDs = $("#wfStepMemberIDs").val();
			var wfStepRoleTypes = $("#wfStepRoleTypes").val();
			if(wfStepMemberIDs == "${sessionScope.loginInfo.sessionUserId}") wfStepMemberIDs = "";
			if(wfStepRoleTypes == "AREQ") wfStepMemberIDs = "";
			var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&wfID=" + defWFID + "&agrYN=N&flg="+flg+"&SelectMember="+wfStepMemberIDs+"&tmpSelSHR="+wfStepRoleTypes+"&clientID="+clientID;
			var w = 900;
			var h = 700;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		}
		else {
			var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&flg="+flg+"&clientID="+clientID;
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
	/* 	else {  
			{alert("${WM00155}"); return;}
		} */
		
		 
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
	/*	else {  
			{alert("${WM00155}"); return;}
		} */
		
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
		 	opener.fnViewReload();
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
		
		result.header = "${menu.LN00024},#master_checkbox,${menu.ZLN0068},${menu.ZLN0101},${menu.LN00002},${menu.LN00004},${menu.LN00027},${menu.LN00070},${menu.LN00022},,,,${menu.LN00017}";
		result.cols = "CHK|CODE|ClassName|Subject|AuthorName|StatusName|CompletionDT|ProjectID|ItemID|ChangeSetID|SRID|Version";
		result.widths = "30,30,100,120,*,80,80,80,30,30,30,30,50";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center";
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
	
	async function getCSFileList() {
	    const res = await fetch("/getFileList.do?documentID=${changeSetID}&docCategory=CS&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}");
	    const data = await res.json();
	    
	    let html = "";
	    
	    if(data !== undefined && data !== null && data !== '') {
	    	if(data.data.length > 0) {
	    		// No / 문서유형 / 문서명 / 개정번호 / 작성자 / 등록일
				html += '<table class="tbl_preview"  id="tmp_file_items" name="tmp_file_items">';
				html += '<colgroup><col width="5%"><col width="15%"><col width="50%"><col width="10%"><col width="10%"><col width="10%"></colgroup>';
				html += '<tr><th>${menu.LN00024}</th><th>${menu.LN00091}</th><th>${menu.LN00101}</th><th>${menu.LN00356}</th><th>${menu.LN00060}</th><th>${menu.LN00078}</th></tr>';
				html += '<tbody name="file-list">';
				for(var i = 0; i < data.data.length; i++) {
					html += '<tr>';
					html += '<td>'+data.data[i].RNUM+'</td>';
					html += '<td>' + data.data[i].FltpName + '</td>';
					html += '<td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR20"  onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\''+data.data[i].fileOption+'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')">';
					html += '<span class="';
					if(data.data[i].FileFormat.includes("doc")) html += 'doc';
					else if(data.data[i].FileFormat.includes("xl")) html += 'xls';
					else if(data.data[i].FileFormat.includes("pdf")) html += 'pdf';
					else if(data.data[i].FileFormat.includes("hw")) html += 'hwp'
					else if(data.data[i].FileFormat.includes("pp")) html += 'ppt';
					else html += "log";
					html += '"></span></span><span style="cursor:pointer;margin-left: 10px;" onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\''+data.data[i].fileOption+'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')">'+data.data[i].FileRealName+'</span>&nbsp;&nbsp;';
					html += '&nbsp;&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')" style="cursor:pointer;">';
					html += '</td>';
					html += '<td>'+data.data[i].Version+'</td>';
					html += '<td>'+data.data[i].WriteUserNM+'</td>';
					html += '<td>'+data.data[i].LastUpdated+'</td>';
					html += '</tr>';
				}
				html += '</tbody>';
				html += '</table>';
	    	}
			document.querySelector("#csfileList").insertAdjacentHTML("beforeend", html);
	    }
	}
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			 var viewerForm = document.viewerForm;
			 var url = "openViewerPop.do";
			 window.open("" ,"viewerForm", "width="+screen.width+", height="+screen.height); 
			 viewerForm.action =url;
			 viewerForm.method="post";
			 viewerForm.target="viewerForm";
			 viewerForm.seq.value = +seq[0];
//			var url = "openViewerPop.do?seq="+seq[0];
//			var w = screen.width;
//			var h = screen.height;
			
			if(avg5 != "") { 
				viewerForm.isNew.value = "N";
//				url = url + "&isNew=N";
			}
			else {
				viewerForm.isNew.value = "Y";
//				url = url + "&isNew=Y";
			}
//			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
//			//window.open(url,1316,h); 
			
			 viewerForm.submit();
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.wfInstInfoFrm, url, "blankFrame");
		}
	}
	
	async function getDictionary() {
		const res = await fetch("/getDictionary.do?category=FLTP&typeCode=CSDOC&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
	    const data = await res.json();
	    
	    if(data !== undefined && data !== null && data !== '') {
	    	document.querySelector("#csdoc_label").innerText = data.data.LABEL_NM;
	    }
	}
</script>
</head>
<body>
<form name ="viewerForm" >
	<input type="hidden" id="seq" name="seq" value="">
	<input type="hidden" id="isNew" name="isNew" value="">
</form>
<form name="wfInstInfoFrm" id="wfInstInfoFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<div id="wfStepInfoDiv" style="padding: 0 6px 6px 6px;height: 100vh;overflow: scroll;"> 
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
				<!-- 결재 상신 -->
				<h3 style="padding: 6px 0 6px 0">
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00211}
				</h3>
			</li>
	        <li class="floatR mgT10">  
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
			
			<!-- 결재선 생성 -->
			<c:choose>
				<c:when test="${defWFID eq 'WF000'}">
					<!-- 수동결재 -->
					<tr>
						<!-- 결재 경로 -->
						<th class="viewtop alignL pdL10" rowspan="2" >${menu.LN00140}</th>
						<td class="viewtop alignL last">
							<div id="wfList" class="floatL"></div>
							&nbsp;&nbsp;
							<span class="btn_pack small icon" id="createWFStepInst">
								<span class="add"></span><input value="Create" type="button" OnClick="fnCreateWF('C');">
							</span>
							&nbsp;
							<span id="wfDescription" style="width:50%;"></span>
						</td>
					</tr>
					<tr>
						<td class="last alignL" >
							<input type="text" id="wfStepInfo" name="wfStepInfo" value="" style="border:0px;width:100%;" />
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<!-- 자동결재 -->
					<tr>
					<!-- 결재 경로 -->
						<th class="viewtop alignL pdL10">${menu.LN00140}
							<span class="btn_pack nobg plus" style="float:right;padding-right:10px;" id="createPath">
								<a class="reference"onclick="fnCreateWF('C');" title="Add"></a>
							</span>
						</th>
						<td class="viewtop last alignL" >
							<input type="text" id="wfStepInfo" name="wfStepInfo" value="" style="border:0px;width:100%;" readonly />
						</td>
					</tr>
				</c:otherwise>
			</c:choose>

			<tr>
				<!-- 참조 -->
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
					${menu.ZLN0068} <!-- 문서번호 -->
				</th>
				<td class="viewtop alignL pdL10 ">
				   ${getPJTMap.Identifier}<%-- 	${newWFInstanceID} --%>
				</td>
				<!-- 문서유형 -->
				<th class="viewtop alignL pdL10">${menu.LN00022}</th> <!-- 변경구분 -->
				<td class="viewtop alignL pdL10 ">${getPJTMap.ChangeType}</td>	
			<%-- 	<td class="viewtop alignL pdL10 ">${wfDocName}</td>		 --%>		
				<!-- 담당자 -->
				<th class="viewtop alignL pdL10">${menu.ZLN0138} ${menu.LN00004}</th> <!-- 결재대상문서 담당자 -->
				<td class="viewtop alignL pdL10 last">
					${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})
				</td>
			</tr>	
			<tr>
				<!-- 제목  -->
				<th class=" alignL pdL10">${menu.ZLN0139}</th>	<!-- 결재문서명 -->
				<td class=" alignL pdL10 last"  colspan = 5 >
					<input type="text" class="text" id="subject" name="subject" value="${getPJTMap.ItemName}" style="width:100%;">
				</td>				
			</tr>	
		 	<tr>
				<th class="alignL pdL10">${menu.LN00290}</th>	<!-- 변경개요 -->
			 	<td class="alignL pdL10 last" colspan="5" style="width:100%;height:160px;">		
					<textarea class="tinymceText" id="description" name="description" style="width:100%;height:150px">${getPJTMap.Description}</textarea>	
				</td>
			</tr>
			<tr>
				<th  class="alignL pdL10" id="csdoc_label"></th>
				<td class="alignL pdL10 alignT last" colspan="5" style="width:100%;" id="csfileList"></td>
			</tr>
		</table>
		</div>	
		
	    <div class="countList pdT10">
	     	<ul>
	     	<li class="wfDoc">${menu.ZLN0138}<span id=""></span></li> <!-- 결재대상문서 -->
<!-- 		    <li class="alignR"><span class="btn_pack small icon"><span class="edit"></span>
		   <input value="Remove" type="button" OnClick="fnSetNoViewIDs();"></span></li> -->
		   <li class="count">Total<span id="TOT_CNT"></span></li> 
	 		</ul>
	 		
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