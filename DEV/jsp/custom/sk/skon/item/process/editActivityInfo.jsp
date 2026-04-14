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

	#itemDiv > div {
		padding : 0 10px;
	}
	#refresh:hover {
		cursor:pointer;
	}

	 .link {
	color: #193598;
	text-decoration: underline;
	cursor:pointer;
	}  
}
</style>

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var delList = [];

	$(document).ready(function(){
		getFileList();
		getRnRList();
			
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});

	});
	
	function getRnRList() {
		$.ajax({
	        url: "/zSKON_DELcxnRnrList.do",
	        type: "GET",
	        data: {
	        	itemID: ${s_itemID},
	        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
	        },
	        dataType: "json",
	        success: function (response) {
	  			
	        	itemListData = response.list;
	        	r_text = response.r_text;
	        	a_text = response.a_text;
	        	s_text = response.s_text;
	        	i_text = response.i_text;
	        	c_text = response.c_text;
	        	
	        	updateTable();
	        },
	    }); 
		}

	//콜백 
	function fnEditItemInfo(itemID) {
		getRnRList();
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function updateTable() {
	    let tableContent = "";
	    itemListData.forEach((item) => {	    
            tableContent = `
            	<td class="alignC last pdL10">${"${r_text}"}</td>
            	<td class="alignC last pdL10">${"${a_text}"}</td>
            	<td class="alignC last pdL10">${"${s_text}"}</td>
            	<td class="alignC last pdL10">${"${i_text}"}</td>`; 
    	});
	    $("#itemTable").html(tableContent);
	}

	function editPopup(id){
		$("#items").val(id);
		var url = "editAttrOfItemsPop.do?items="+id+"&attrCode='ZAT02028'";
	    var w = 940;
		var h = 700;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
	}
	
	function modelView(){
		var browserType="";
		
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = "newDiagramViewer.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${itemID}"
					+"&width="+$("#model2").width()
					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&varFilter=${revViewOption}"
					+"&displayRightBar=none";
		var src = url +"?" + data+"&browserType="+browserType;
 		document.getElementById('model2').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
		$("#model2").attr("style", "display:block;height:600px;border: 0;");
	}
	// Model 팝업
	function clickModelEvent(trObj) {
		var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID=${itemID}"
				+"&modelID="+$(trObj).find("#ModelID").text()
				+"&scrnType=view"
 				+"&MTCategory="+$(trObj).find("#MTCategory").text()
				+"&modelName="+encodeURIComponent($(trObj).find("#ModelName").text())
			    +"&modelTypeName="+encodeURIComponent($(trObj).find("#modelTypeName").text())
				+"&menuUrl="+$(trObj).find("#ModelURL").text()
				+"&changeSetID="+$(trObj).find("#ModelCSID").text()
				+"&selectedTreeID=${itemID}";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 관련항목 팝업
	function clickItemEvent(trObj) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+trObj
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 변경이력 팝업
	function clickChangeHistoryEvent(trObj) {
		var url = "viewItemChangeInfo.do?"
				+"changeSetID="+$(trObj).find("#ChangeSetID").text()
 				+"&StatusCode="+$(trObj).find("#ChangeStsCode").text()
				+"&ProjectID"+$(trObj).find("#ChangeStsCode").text()
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&isItemInfo=Y&seletedTreeId=${itemID}&isStsCell=Y";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
	function fnChangeMenu(menuID,menuName) {
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		$("#viewPageBtn").css('display','block');
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}else if(menuID == "file"){
			var url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}"; 
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);
		}else if(menuID == "report"){
			var url = "objectReportList.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);
		}else if(menuID == "changeSet"){
			var url = "itemHistory.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N&myItem=${myItem}&itemStatus=${itemStatus}";
		 	ajaxPage(url, data, target);
		}else if(menuID == "dimension"){
			var url = "dimListForItemInfo.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&backBtnYN=N";
		 	ajaxPage(url, data, target);
		}
	}
	
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
		if(confirm("${CM00001}")){	
			var frm = document.getElementById('editFrm');
			var url = "zskon_saveItemInfo.do";
			ajaxSubmitNoAdd(frm, url);
		}
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

	function searchOrgPopUp(){
		
		var url = "orgUserTreePop.do";
		var data = "s_itemID=${s_itemID}&openMode=assignOwnerTeam&btnName=Assign&btnStyle=assign";
		fnOpenLayerPopup(url,data,doCallBackTeam,617,436);
		
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
 				+"&itemViewPage=custom/sk/skon/item/process/activityOverview&screenMode=pop&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	

	
	// callback TSD 상세 조회
	function fnItemMenuReload() {
	  console.log("fnItemMenuReload");
	  //  url = "zSKON_searchTsdItemList.do";
	  //	data = "s_itemID=103109&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&screenOption=Y";

		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/process/activityOverview"
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
		var data = "&itemEditPage=custom/sk/skon/item/process/editActivityInfo&accMode=DEV&scrnMode=N&option=${option}";	
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
	
	function fnSaveTeamRole(teamIDs,teamNames){
		$("#orgNames").val(teamNames);
		$("#orgTeamIDs").val(teamIDs);
	}
	

	function goView(itemID){
		var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/process/activityOverview"
			+"&scrnOption=Y"
			+"&itemOption=Y"
			+"&defDimValueID=${defDimValueID}&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "editFrm");

	}

	function getAttrLovList(avg, avg2, avg3){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}

	let cxnClassCode = "";
	function assignProcess(e){
		console.log(e.getAttribute("id"));
		if(e.getAttribute("id") === "ZAT02007") cxnClassCode = "CNL0201A";
		if(e.getAttribute("id") === "ZAT02008") cxnClassCode = "CNL0201B";
		if(e.getAttribute("id") === "ZAT02009") cxnClassCode = "CNL0201C";
		if(e.getAttribute("id") === "ZAT02010") cxnClassCode = "CNL0201D";
		if(e.getAttribute("id") === "ZAT02013") cxnClassCode = "CNL0201E";

		 fnOpenItemTree();
	}

	function fnOpenItemTree(){
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode=OJ00002&openMode=assign&s_itemID=${itemID}";

		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	//After fnOpenItemTree
	function setCheckedItems(checkedItems){
		var cxnTypeCode = "OJ00002";
		var url = "createCxnItem.do";
		var data = "s_itemID=${itemID}&cxnTypeCode=CN00201&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		fnEditItemInfo();
	}
	
	// Delete Cxn
	function delConnection(activityItemID, itemID){		
		if(confirm("${CM00004}")){
			var url = "DELCNItems.do";
			var data = "isOrg=Y&s_itemID="+itemID+"&items="+activityItemID;
			var target = "blankFrame";
			
			ajaxPage(url, data, target);
		}
	}
	
	//[Delete] 이벤트 후 Reload
	function urlReload(){
		fnEditItemInfo();
	}
	
	// RASI - A 승인 담당 후 Reload
	function selfClose(){
		fnEditItemInfo();
	} 
	
	async function getFileList() {
	    document.querySelector("#fileList").innerHTML = '';

	    const res = await fetch("/getFileList.do?documentID=${itemID}&docCategory=ITM&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}&hideBlocked=N");
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
	</script>
</head>
<!-- BIGIN :: -->
<body>
<form name="editFrm" id="editFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
<div id="editItemInfo">
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
<input type="hidden" id="defDimValueID" name="defDimValueID"  value="${defDimValueID}" />
<input type="hidden" id="items" name="items" value="">
	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB10">
				<div class="align-center flex justify-between pdB5 pdL10 pdT15">			
				<p class="cont_title">기본정보 ${menu.LN00046}</p>
				<div class="alignR">
				
				 	<span class="btn_pack medium icon">
	    			<span class="pre"></span>
	    				<input value="Back" type="button" onclick="goView('${itemID}')"> 
	    			</span>
	    					<%--<button class="cmm-btn floatL " style="height: 30px; margin-bottom:5px;margin-left:3px;"  value="Cancel" onClick="goView('${itemID}');">Cancel</button> --%>
	    			<c:if test="${itemInfo.Status ne 'DEL1' }" >
						 <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span> 
						<!--<button class="cmm-btn2 mgR5" style="height: 30px; margin-bottom:5px;margin-left:3px;" onclick="saveObjInfoMain()" value="Save">Save</button>-->
					</c:if>
				</div>		
			</div>
				<table class="tbl_preview mgB10">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col>
				</colgroup>
							
					<!-- Activity명 -->
					<tr>
						<th>${menu.ZLN0109}</th>
						<td colspan="3" class="alignL pdL10">
							<input type="text" id="AT00001" name="AT00001" value="${itemInfo.ItemName}" class="text" maxLength="100" >
						</td>
					</tr>	
					<tr>			
						<td class="alignL pdL10" colspan="4" >
							<textarea class="tinymceText" style="width:100%;height:600px;" id="AT00003" name="AT00003">${attrMap.AT00003}</textarea>
						</td>
					</tr>
					<!-- R / A / S / I -->			
					<tr>
						<th class="alignC last">${menu.ZLN0126}</th>
						<th class="alignC last">${menu.ZLN0127}</th>
						<th class="alignC last">${menu.ZLN0128}</th>
						<th class="alignC last">${menu.ZLN0129}</th>
					</tr>
					<tr>
						<td class="alignC last">
						  <img id="ZAT02007" src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess(this)">
						</td>
						<td class="alignC last">
						  <img id="ZAT02008" src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess(this)">
						</td>
						<td class="alignC last">
						  <img id="ZAT02009" src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess(this)">
						</td>
						<td class="alignC last">
						  <img id="ZAT02010" src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess(this)">
						</td>
					</tr>	
					<tr id="itemTable">
					</tr>
					<!-- 입력물 -->
					<tr>
						<th>${menu.ZLN0110}</th>
						<td class="alignL pdL10" colspan="3">
							<input type="text" id="AT00015" name="AT00015" class="text" maxLength="500" style="width: 100%;" value="${attrMap.AT00015}">
						</td>
					</tr>
					<!-- 출력물 -->
					<tr>
						<th>${menu.ZLN0111}</th>
						<td class="alignL pdL10" colspan="3">
							<input type="text" id="AT00016" name="AT00016" class="text" maxLength="500" style="width: 100%;" value="${attrMap.AT00016}">
						</td>
					</tr>
					<!-- 수행 시스템 -->
					<tr>
						<th>${menu.ZLN0112}</th>
						<td class="alignL pdL10" colspan="3">
							<input type="text" id="ZAT02015" name="ZAT02015" class="text" maxLength="100" style="width: 100%;" value="${attrMap.ZAT02015}">
						</td>
					</tr>
					<!-- 첨부문서 -->
					<tr>
						<th>${menu.LN00019}</th>
						<td class="alignL pdL10 alignT last" colspan="3" style="width:100%;height:200px;" id="fileList"></td>	
					</tr>
				</table>
				
				
		</div>
	</div>
</div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
<form name ="cxnItemListMgt" >
	<input type="hidden" name="itemID" />
	<input type="hidden" name="classCodes" />
	<input type="hidden" name="itemTypeCode" />
	<input type="hidden" name="items" />
	<input type="hidden" name="initSearch" />
	<input type="hidden" name="callBackData" />
</form>
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

let fltpCode = "";
//************** addFilePop V4 설정 START ************************//
function doAttachFileV4(e){
	fileIDMapV4 = new Map();
	fileNameMapV4 = new Map();
	fileSizeMapV4 = new Map();
	fltpCode = "FLTP002";
	
	var url="addFilePopV4.do";
	var data="scrnType=CS&fltpCode="+fltpCode;
	openPopup(url+"?"+data,490,450, "Attach File");
	
	
} 

var fileIDMapV4 = new Map();
var fileNameMapV4 = new Map();
var fileSizeMapV4 = new Map();

function fnAttacthFileHtmlV4(fileID, fileName, fileSize){ 
	fileID = fileID.replace("u","");
	fileIDMapV4.set(fileID,fileID,fileSize);
	fileNameMapV4.set(fileID,fileName);
	fileSizeMapV4.set(fileID,fileSize);
}

// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
function fnDeleteFileMapV4(fileID){ 
	fileID = fileID.replace("u","");
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
	fileSizeMapV4.delete(String(fileID));
	if(fileIDMapV4.size === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
}

function fnDisplayTempFileV4(){	
	$("#id").val("${itemID}");
	$("#fltpCode").val("FLTP002");
	$("#docCategory").val("ITM");
	$("#changeSetID").val("${itemInfo.CurChangeSet}");
	$("#projectID").val("${itemInfo.ProjectID}");
	
	var url  = "saveMultiFile.do";
	ajaxSubmit(document.uploadFrm, url,"saveFrame");
}

function viewMessage(){
	alert("${WM00067}");
	getFileList();
}
 
//  dhtmlx v 4.0 delete file  
function fnDeleteFileHtmlV4(fileID){
	var fileName = document.getElementById(fileID).children.namedItem("fileInfo").children.namedItem("fileName").innerHTML;
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
	fileSizeMapV4.delete(String(fileID));
	
	if(fileName != "" && fileName != null && fileName != undefined){
		$("#"+fileID).remove();
		var url  = "removeFile.do";
		var data = "fileName="+fileName;	
		ajaxPage(url,data,"blankFrame");
	}
	
	if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ITM";
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ITM";
		ajaxSubmitNoAdd(document.editFrm, url,"saveFrame");
	}
	
	function fnDeleteFile(seq){
		if(confirm("${CM00002}")){
			var url = "deleteFileFromLst.do";
			var data = "&seq="+seq;
			var target = "blankFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	// callback - fnDeleteFile
	function doSearchList() {
		getFileList();
	}

</script>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
