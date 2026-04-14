﻿<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />

<head>
<style>

	.noticeTab02{margin-top:-15px;}
	.noticeTab02 > input{display:none;}
	.noticeTab02 > label{display:inline-block;margin:0 0 -1px; padding:15px 0; font-weight:700;text-align:center;color:#999999;width:62px;}
	.noticeTab02 > section {display: none;padding: 20px 0 0;}
	.noticeTab02 > input:checked+label{color:#333333;border-bottom:3px solid #008bd5;}
/* 	#tab_01:checked ~ #Con_01,#tab_02:checked ~ #Con_02{display: block;} */
	#itemDiv > div {
		padding : 0 10px;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
	border: 1px solid #ccc;
	width:100%;
	}
	#maintext th{
	    text-align: left;
    padding: 10px;
        color: #000;
    font-weight: bold;
	}
	#maintext td{
	 width: 97%;
    border: 1px solid #ccc;
    display: block;
    padding-top: 10px;
    padding-left: 10px;
    margin: 0px auto 15px;
    overflow-x: auto;
    line-height: 18px;
	}
	#maintext  textarea {
	width: 100%;
	resize:none;
	}
   .btn_pack.nobg a.upload {
		background-position: -170px -96px;
	}
	
	#menuDiv {
    margin: 0 10px;
    border-top: 1px solid #ddd;
}

#itemNameAndPath, #functions {
    display: inline;
    line-height: 23px;
    
}


</style>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_Description" arguments="${menu.LN00360}"/>

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var isWf = "";
var checkOutFlag = "N";
var delList = [];
const defSiteCode = "${defSiteCode}";
const defDimValueID = "${defDimValueID}";

getFileList();
getCSFileList();
	
	//콜백 
	function fnEditItemInfo(itemID) {
	
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/rule/editRuleInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&defDimValueID ="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"; 

		//var target = parent.document.getElementById("frontFrm");
		var target = "editItemInfo";
		ajaxPage(url, data, target); 
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
	}
	
	function reload(){
		var titleViewOption= "${titleViewOption}";
		var mdlOption= "${revViewOption}";
		if(itemPropURL != "" || itemPropURL != null){
			var itemPropURL = "${url}";
			var avg4 = itemPropURL+","+titleViewOption;
			if(mdlOption != null && mdlOption != ""){
				avg4 += ","+mdlOption;
			}
			setActFrame("viewItemProperty", '', '', avg4,'');
		} else {
			var itemPropURL = "${itemPropURL}";
			parent.fnSetItemClassMenu("viewItemProperty", "${itemID}", "&mdlOption="+mdlOption+"&itemPropURL="+itemPropURL+"&scrnType=clsMain");
		}
	}
	

	function saveObjInfoMain(){
		document.getElementById("showSaveAlert").value = "Y";
		if(setAllCondition()) {
			if(confirm("${CM00001}")){
				
// 				if(delList.length > 0) {
// 					// 임시로 삭제된 파일 데이터에서 삭제하기
// 					var url = "deleteFileFromLst.do";
// 				 	var data = "&displayMsg=N&seq=" + delList;
// 					var target = "blankFrame";
// 				 	ajaxPage(url, data, target);	
// 				}
				
				var frm = document.getElementById('editFrm');
				var url = "zskon_saveItemInfo.do";
 				ajaxSubmitNoAdd(frm, url);
			}
		}
		
		
	}

	function saveObjFile() {
		document.getElementById("showSaveAlert").value = "N";
		if(delList.length > 0) {
			// 임시로 삭제된 파일 데이터에서 삭제하기
			var url = "deleteFileFromLst.do";
		 	var data = "&displayMsg=N&seq="+delList;
			var target = "blankFrame";
		 	ajaxPage(url, data, target);	
		}
		
		var frm = document.getElementById('editFrm');
		var url = "zskon_saveItemInfo.do";
			ajaxSubmitNoAdd(frm, url);

	}
	
	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&hiddenClassList='CL05003','CL16004'";

		fnOpenLayerPopup(url,data,doCallBackItem,617,436);
	}
	
	function doCallBackItem() {
		
	}
	
	function doCallBackTeam(orgID,orgNames) {
		$("#orgIDs").val(orgID);
		$("#orgNames").val(orgNames);
		
	}
	
	function setParentItem(pID,avg){
		$("#parentID").val(pID);
		$("#parentPath").val(avg);
		$(".popup01").hide();
		$("#mask").hide();
		$("#popupDiv").hide();
	}

	
	function fnRefreshTree(itemId,isReload){ 

	}
	function fnCreateRefreshTree(itemId,isReload){ 
		fnRefreshPage("${option}",itemId);
	}

	
	function fnGetItemClassMenuURL(itemID){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID;
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID){
		var temp = itemID.split("&");
		
		var url = menuURL+".do";
		var data = "&itemID="+s_itemID+"&itemClassMenuUrl="+menuURL+"&scrnMode=E";
		
		for(var i=0; i<temp.length; i++) {
			var temp2 = temp[i].split("=");

			if(temp2.length > 1 && scrnMode == "E" && temp2[0] != "itemViewPage") {                            
				data += "&" + temp2[0] + "=" + temp2[1];
			}
			else if(temp2.length > 1 && scrnMode != "E" && temp2[0] != "itemEditPage") {
				data += "&" + temp2[0] + "=" + temp2[1];
			}
		}
		
		var target = "myItemList";
		ajaxPage(url, data, target);
	}

	function openPreviewPop(){

		var url = "processItemInfo.do?"
				+"s_itemID=${itemID}"
 				+"&scrnMode=V&accMode=DEV"+"&itemID=${itemID}"
 				+"&itemViewPage=custom/sk/skon/item/rule/viewRuleInfo&screenMode=pop&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	

	
	// callback TSD 상세 조회
	function fnItemMenuReload() {
	  	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/rule/viewRuleInfo"
			+"&itemOption=Y&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}";
		ajaxPage(url, data, "editFrm");

	}
		
	function fnEditCallBack(avg) {
		if(isWf == "Y" && avg != "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack("${itemID}");
		}
		else if (isWf == "Y" && avg == "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack("${itemID}");
		} else {
			goBack("${itemID}");
		}
	}

    function setInfoFrame(avg){
    	var url = "";
    	var data = "";
    	
    	if(avg == "1") {

	        $("#Con_01").show();
	        $("#Con_02").hide();
	        $("#Con_03").hide();
    	}
    	if(avg == "2") { 
	        $("#Con_01").hide();
	        $("#Con_02").show();   	
	        $("#Con_03").hide();   	
	        url = "cxnItemTreeMgt.do";   
	        data = "s_itemID=${itemID}&varFilter=CN00105&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame";
	
	        ajaxPage(url, data, "subRelFrame");
    	}
    	if(avg == "3") { 
    		  $("#Con_01").hide();
  	        $("#Con_02").hide();   	
  	        $("#Con_03").show();   	
  	        
  	  		var url = "forumMgt.do";
  	  		var target = "itemDescriptionDIV";
  	  		var data = "&s_itemID=${itemID}&BoardMgtID=4";
  	  		
  	  		ajaxPage(url, data, "csFrame");
    	}
    }
    
	function saveMainText(){	
		
		if(confirm("${CM00001}")){	
			
			//var url = "zhec_saveMainText.do";	
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm,url, "saveFrame");
		}
	}
	
	function fnRefreshPage(option, itemID,scrnMode){
		//parent.fnRefreshPageCall(option, itemID,scrnMode);
		
		var url = "zSKON_ProcessItemInfo.do";
		var data = "&itemEditPage=custom/sk/skon/item/rule/editRuleInfo&accMode=DEV&scrnMode=N&option=${option}";	
		var target = "m";
		ajaxPage(url, data, target);
		
	}
	
   // 관리부서 지정 시 사용 >> SKON 미사용
	function fnGoOrgTreePop(){
		var url = "orgTeamTreePop.do";
		var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}&option=NoP";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function fnTeamRoleCallBack(){
	}
	
	function doCallBack(){}
	
	function goView(itemID){
		var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/rule/viewRuleInfo"
			+"&scrnOption=Y"
			+"&itemOption=Y"
			+"&defDimValueID=${defDimValueID}&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
			//var target = frontFrm
		ajaxPage(url, data, "editFrm");

	}
	
	
	function selfClose(){
		goBack("${itemID}");
	}
	

	function setAllCondition() {
		if ($("#Description").val() == "" ) { 
			alert("${WM00034_Description}");	// 주요개정사항을 입력하여 주십시오.
			return false;
		}
		
		/* else if ($("#fileAttach1").val() == "" ) { 
			alert("사규문서를 첨부하여 주십시오.");
			return false;
		} */
		return true;
	}
	
	
/**** 결재 관련*** */
// 기존 check in 실행 함수 
	
	function fnEditChangeSetClsMn(){
		var url = "editItemChangeInfo.do"
		var data = "?changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y&scrnType=${scrnType}"
			+ "&checkInOption=${itemInfo.CheckInOption}";
		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
			

		
// [Rework] click
	function rework() {
		if (confirm("${CM00059}")) {
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}"; 
			
			$.ajax({
				url: url,
				type: 'post',
				data: data,
				async: true,
				success: function(data){
					fnItemMenuReload();
				}
			});
		}
	}
	
	
	//check in 후 콜백 
	function fnCallBack(checkInOption){
		
		if(checkInOption == "03" || checkInOption == "03A" || checkInOption == "03B"){
		    dhx.confirm({
		        text: "${CM00061}",
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
		    	if(result){
					goApprovalPop();
				}
				fnItemMenuReload();	
		    });
		}else{
			fnItemMenuReload();	
		}
	}
	
	//complet check in 함수
	function goApprovalPop() {
		
		
		var url = "wfDocMgt.do?";
		//var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfDocType=CS";
		var data="isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&docSubClass=${itemInfo.ClassCode}";
	
		var w = 1200;
		var h = 750; 
		itmInfoPopup(url+data,w,h);
	}

	function fnViewReload() {
		
  		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/rule/viewRuleInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	// 작성부서
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchTeam(teamID,teamName){
		$('#ZAT04002').val(teamName);
		$('#ZAT04002_TEXT').text(teamName);
	}

	async function getFileList() {
	    document.querySelector("#fileList").innerHTML = '';

	    const res = await fetch("/getFileList.do?documentID=${itemID}&docCategory=ITM&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}");
	    const data = await res.json();
	    
	    let html = "";
	    
	    if(data !== undefined && data !== null && data !== '') {
	    	// 문서유형 / 문서명 / 작성자 / 등록일
			html += '<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4(\'ITM\')"></span>';
			html += '<div class="tmp_file_wrapper mgT10" id="tmp_file_wrapper">';
			html += '<table class="tbl_preview"  id="tmp_file_items" name="tmp_file_items">';
			html += '<colgroup><col width="5%"><col width="15%">	<col width="60%"><col width="10%"><col width="10%"></colgroup>';
			html += '<tr><th></th><th>${menu.LN00091}</th><th>${menu.LN00101}</th><th>${menu.LN00060}</th><th>${menu.LN00078}</th></tr>';
			html += '<tbody name="file-list">';
			for(var i = 0; i < data.data.length; i++) {
				html += '<tr id="'+data.data[i].Seq+'">';
				html += '<td><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFile('+data.data[i].Seq+',\'ITM\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>';
				html += '<td>' + data.data[i].FltpName + '</td>';
				html += '<td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR20"  onclick="fileNameClick('+data.data[i].Seq+')">';
				html += '<span class="';
				if(data.data[i].FileFormat.includes("doc")) html += 'doc';
				else if(data.data[i].FileFormat.includes("xl")) html += 'xls';
				else if(data.data[i].FileFormat.includes("pdf")) html += 'pdf';
				else if(data.data[i].FileFormat.includes("hw")) html += 'hwp'
				else if(data.data[i].FileFormat.includes("pp")) html += 'ppt';
				else html += "log";
				html += '"></span></span><span style="cursor:pointer;margin-left: 10px;" onclick="fileNameClick('+data.data[i].Seq+');">'+data.data[i].FileRealName+'</span>(<span id="fileSize">'+data.data[i].FileSize+'</span>)</td>';
				html += '<td>'+data.data[i].WriteUserNM+'</td>';
				html += '<td>'+data.data[i].CreationTime+'</td>';
				html += '</tr>';
			}
			html += '</tbody>';
			html += '</table>';
			html += '</div>';			
			document.querySelector("#fileList").insertAdjacentHTML("beforeend", html);
	    }
	}
	
	async function getCSFileList() {
	    document.querySelector("#csfileList").innerHTML = '';

	    const res = await fetch("/getFileList.do?documentID=${changeSetID}&docCategory=CS&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}");
	    const data = await res.json();
	    
	    let html = "";
	    
	    if(data !== undefined && data !== null && data !== '') {
	    	// 문서유형 / 문서명 / 작성자 / 등록일
			html += '<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4(\'CS\')"></span>';
			html += '<div class="tmp_file_wrapper mgT10" id="tmp_file_wrapper">';
			html += '<table class="tbl_preview"  id="tmp_file_items" name="tmp_file_items">';
			html += '<colgroup><col width="5%"><col width="15%">	<col width="60%"><col width="10%"><col width="10%"></colgroup>';
			html += '<tr><th></th><th>${menu.LN00091}</th><th>${menu.LN00101}</th><th>${menu.LN00060}</th><th>${menu.LN00078}</th></tr>';
			html += '<tbody name="file-list">';
			for(var i = 0; i < data.data.length; i++) {
				html += '<tr id="'+data.data[i].Seq+'">';
				html += '<td><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFile('+data.data[i].Seq+',\'CS\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>';
				html += '<td>' + data.data[i].FltpName + '</td>';
				html += '<td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR20"  onclick="fileNameClick('+data.data[i].Seq+')">';
				html += '<span class="';
				if(data.data[i].FileFormat.includes("doc")) html += 'doc';
				else if(data.data[i].FileFormat.includes("xl")) html += 'xls';
				else if(data.data[i].FileFormat.includes("pdf")) html += 'pdf';
				else if(data.data[i].FileFormat.includes("hw")) html += 'hwp'
				else if(data.data[i].FileFormat.includes("pp")) html += 'ppt';
				else html += "log";		
				html += '"></span></span><span style="cursor:pointer;margin-left:10px;" onclick="fileNameClick('+data.data[i].Seq+');">'+data.data[i].FileRealName+'</span>(<span id="fileSize">'+data.data[i].FileSize+'</span>)</td>';
				html += '<td>'+data.data[i].WriteUserNM+'</td>';
				html += '<td>'+data.data[i].LastUpdated+'</td>';
				html += '</tr>';
			}
			html += '</tbody>';
			html += '</table>';
			html += '</div>';			
			document.querySelector("#csfileList").insertAdjacentHTML("beforeend", html);
	    }
	}
	</script>
</head>
<!-- BIGIN :: -->
<body>
<form name="editFrm" id="editFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
<div id="editItemInfo">
<input type="hidden" id="updateOnly" name="updateOnly"  value="Y" />
<input type="hidden" id="scrnMode" name="scrnMode"  value="E" />
<input type="hidden" id="s_itemID" name="s_itemID"  value="${itemID}" />
<input type="hidden" id="option" name="option"  value="${option}" />		
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />			
<input type="hidden" id="sub" name="sub" value="${sub}" />
<input type="hidden" id="function" name="function" value="saveObjInfoMain">
<input type="hidden" id="projectId" name="projectId" value="${itemInfo.projectID}" />
<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
<input type="hidden" id="scrnMode" name="scrnMode" value="E" />
<input type="hidden" id="showSaveAlert" name="showSaveAlert" value="${showSaveAlert}" />
<input type="hidden" id="defDimValueID" name="defDimValueID"  value="${defDimValueID}" />
<input type="hidden" id="curChangeSet" name="curChangeSet" value="${itemInfo.CurChangeSet}"/>
	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB10">
				<div class="align-center flex justify-between pdB5 pdL10 pdT15">			
				<p class="cont_title">${menu.LN00005} ${menu.LN00046}</p>
				<div class="alignR">
				
				 	<span class="btn_pack medium icon">
	    			<span class="pre"></span>
	    				<input value="Cancel" type="button" onclick="goView('${itemID}')"> 
	    			</span>
	    			<c:if test="${itemInfo.Status ne 'DEL1' }" >
						 <span class="btn_pack small icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit" ></span>
						<!--<button class="cmm-btn2 mgR5" style="height: 30px; margin-bottom:5px;margin-left:3px;" onclick="saveObjInfoMain()" value="Save">Save</button>-->
					</c:if>
				</div>		
			</div>
				<table class="tbl_preview mgB10">
					<colgroup>
				 	<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
					</colgroup>

					<tr>
						<!-- 사규번호 -->
						<th>${menu.ZLN0133}</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>	
						<!-- 개정번호 -->				
						<th><span style="color: red;">*</span>${menu.LN00356}</th>
						<td class="alignL pdL10">${prcList.Version}</td>
					</tr>
					
					<tr>
						<!-- 규정명 -->
						<th>${menu.ZLN0134}</th>
						<td class="alignL pdL10">${itemInfo.ItemName}</td>
						<!-- 작성부서 -->		
						<th><span style="color: red;">*</span>${menu.LN01008}</th>
						<td class="alignL pdL10">
						  <span id="ZAT04002_TEXT">${attrMap.ZAT04002}</span>&nbsp;&nbsp;
						  <input type="hidden" id="ZAT04002" name="ZAT04002" value="${attrMap.ZAT04002}" />
						  <img src="${root}${HTML_IMG_DIR}/btn_view_en.png"
						       onclick="searchPopup('searchTeamPop.do?teamTypeYN=Y')" style="cursor:pointer;">
						</td>					
					</tr>

					<!-- 주요개정사항 -->
					<tr>
						<th><span style="color: red;">*</span>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="3">						
						<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;">${csInfo.Description}</textarea> 
						</td>						
					</tr>
					
					<!-- 첨부문서 -->
					<tr>
						<th><span id="fileAttach" style="color: red;">*</span>${menu.LN00019}</th>
						<td class="alignL pdL10 alignT" colspan="3" style="width:100%;height:200px;" id="fileList">
					</tr>
					
					<!-- 품의서 -->
					<tr>
						<th>${menu.ZLN0135}</th>
						<td class="alignL pdL10 alignT" colspan="3" style="width:100%;height:200px;" id="csfileList"></td>
					</tr>
				</table>

		</div>
	</div>
</div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
<form name ="uploadFrm" >
	<input type="hidden" id="id" name="id" value="">
	<input type="hidden" id="fltpCode" name="fltpCode" value="" />
	<input type="hidden" id="fileMgt" name="fileMgt" value="" />
	<input type="hidden" id="usrId" name="usrId" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="docCategory" name="docCategory" value="">
	<input type="hidden" id="changeSetID" name="changeSetID" value="">
	<input type="hidden" id="projectID" name="projectID" value="">
</form>
<script>

	let type = "";
	let fltpCode = "";
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(e){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		type = e;
		if(type === "ITM") fltpCode = "FLTP007";
		if(type === "CS") fltpCode = "";
		
		var url="addFilePopV4.do";
		var data="scrnType=CS&fltpCode="+fltpCode;
		openPopup(url+"?"+data,490,450, "Attach File");
		
		
	} 
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	
	// cs용 첨부파일
	var fileIDMapV4_2 = new Map();
	var fileNameMapV4_2 = new Map();
	var fileSizeMapV4_2 = new Map();
	
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize){ 
		fileID = fileID.replace("u","");
		if(type == "ITM") {
			fileIDMapV4.set(fileID,fileID,fileSize);
			fileNameMapV4.set(fileID,fileName);
			fileSizeMapV4.set(fileID,fileSize);
		}
		if(type == "CS") {
			fileIDMapV4_2.set(fileID,fileID,fileSize);
			fileNameMapV4_2.set(fileID,fileName);
			fileSizeMapV4_2.set(fileID,fileSize);
		}
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		if(type == "ITM") {
			fileIDMapV4.delete(String(fileID));
			fileNameMapV4.delete(String(fileID));
			fileSizeMapV4.delete(String(fileID));
			if(fileIDMapV4.size === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
		}
		if(type == "CS") {
			fileIDMapV4_2.delete(String(fileID));
			fileNameMapV4_2.delete(String(fileID));
			fileSizeMapV4_2.delete(String(fileID));
			if(fileIDMapV4_2.size === 0) $(".tmp_file_wrapper2").attr('style', 'display: none');
		}
	}
	
	function fnDisplayTempFileV4(){
		console.log(type)
	//		if(type == "ITM") {
	//			display_scripts = document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML;
	//			fileIDMapV4.forEach(function(fileID) {
	//				  display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
	//				  '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
	//				  '<td>프로세스 매뉴얼</td>'+
	//				  '<td class="alignL pdL10 flex align-center" name="fileInfo"><span class="btn_pack icon small"></span><span name="fileName">'+ fileNameMapV4.get(fileID)+'</span>(<span id="fileSize">'+getFileSize(fileSizeMapV4.get(fileID))+'</span>)</td>'+
	//				  '<td></td>'+
	//				  '<td></td>'+
	//				  '</tr>';
	//			});
	//		}
	//		if(type == "CS") {
	//			display_scripts = document.querySelector("#tmp_file_items2").children.namedItem("file-list").innerHTML;
	//			fileIDMapV4_2.forEach(function(fileID) {
	//				  display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
	//				  '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
	//				  '<td class="alignL pdL10 flex align-center" name="fileInfo"><span class="btn_pack icon small"></span><span name="fileName">'+ fileNameMapV4_2.get(fileID)+'</span>(<span id="fileSize">'+getFileSize(fileSizeMapV4_2.get(fileID))+'</span>)</td>'+
	//				  '<td></td>'+
	//				  '<td></td>'+
	//				  '</tr>';
	//			});
	//		}
		
	//		if(type == "ITM") {
	//			document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML = display_scripts;
	//			$(".tmp_file_wrapper").attr('style', 'display: block');
			
	//			fileIDMapV4 = new Map();
	//			fileNameMapV4 = new Map();
	//			fileSizeMapV4 = new Map();
	//		}
	//		if(type == "CS") {
	//			document.querySelector("#tmp_file_items2").children.namedItem("file-list").innerHTML = display_scripts;
	//			$(".tmp_file_wrapper2").attr('style', 'display: block');
			
	//			fileIDMapV4_2 = new Map();
	//			fileNameMapV4_2 = new Map();
	//			fileSizeMapV4_2 = new Map();
	//		}
		
		if(type == "ITM") {
			$("#id").val("${itemID}");
			$("#fltpCode").val("FLTP007");
			$("#docCategory").val("ITM");
			$("#changeSetID").val("${itemInfo.CurChangeSet}");
			$("#projectID").val("${itemInfo.ProjectID}");
		}
		if(type == "CS") {
			$("#id").val("${itemInfo.CurChangeSet}");
			$("#fltpCode").val("CSDOC");
			$("#docCategory").val("CS");
			document.uploadFrm.changeSetID.value = "${itemInfo.CurChangeSet}";
			$("#projectID").val("${itemInfo.ProjectID}");
		}
		
		var url  = "saveMultiFile.do";
		ajaxSubmit(document.uploadFrm, url,"saveFrame");
	}
	
	function viewMessage(){
		alert("${WM00067}");
		if(type == "ITM") getFileList();
		if(type == "CS") getCSFileList();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		var fileName = document.getElementById(fileID).children.namedItem("fileInfo").children.namedItem("fileName").innerHTML;
		if(type == "ITM") {
			fileIDMapV4.delete(String(fileID));
			fileNameMapV4.delete(String(fileID));
			fileSizeMapV4.delete(String(fileID));
		}
		if(type == "CS") {
			fileIDMapV4_2.delete(String(fileID));
			fileNameMapV4_2.delete(String(fileID));
			fileSizeMapV4_2.delete(String(fileID));
		}
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}
		
		if(type == "ITM") if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
		if(type == "CS") if(document.querySelector("#tmp_file_items2").children.namedItem("file-list").children.length === 0) $(".tmp_file_wrapper2").attr('style', 'display: none');
	} 
	//************** addFilePop V4 설정 END ************************//
	
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
		
		let scrnType = "";
		if(type == "ITM") scrnType = "ITM";
		if(type == "CS") scrnType = "CS";
		
		var url  = "fileDownload.do?seq="+seq+"&scrnType="+scrnType;
		//alert(url);
		ajaxSubmitNoAdd(document.saveFrame, url,"saveFrame");
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
		let scrnType = "";
		if(type == "ITM") scrnType = "ITM";
		if(type == "CS") scrnType = "CS";
		var url  = "fileDownload.do?seq="+seq+"&scrnType="+scrnType;
		ajaxSubmitNoAdd(document.editFrm, url,"saveFrame");
	}
	
	function fnDeleteFile(seq, e){
		type = e;
		if(confirm("${CM00002}")){
			var url = "deleteFileFromLst.do";
		 	var data = "&seq="+seq;
			var target = "blankFrame";
		 	ajaxPage(url, data, target);	
		}
	}
	
	// callback - fnDeleteFile
	function doSearchList() {
		if(type == "ITM") getFileList();
		if(type == "CS") getCSFileList();
	}
</script>

</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
