<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script src="<c:url value='/cmm/js/tinymce_v4.3/tinymce.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
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
</style>
<script type="text/javascript">
var isWf = "";

	$(document).ready(function(){				
		
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
// 		var height = setWindowHeight();
// 		document.getElementById("htmlReport").style.height = (height - 95)+"px";
// 		window.onresize = function() {
// 			height = setWindowHeight();
// 			document.getElementById("htmlReport").style.height = (height - 95)+"px";	
// 		};
		

		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		setInfoFrame('2');
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function modelView(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
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
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=SOP&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id=${itemID}&fltpCode=FLTP1601";
		//fnOpenLayerPopup(url,data,"",400,400);
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,360,360, "Attach File");}
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=CS";
		//alert(url);
		ajaxSubmitNoAdd(document.editSTPFrm, url,"saveFrame");
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SOP";
		ajaxSubmitNoAdd(document.editSTPFrm, url,"saveFrame");
	}

	function fnDeleteItemFile(seq){
		var url = "changeSetFileDelete.do";
		var data = "&delType=1&fltpCode=FLTP003&seq="+seq;
		ajaxPage(url, data, "saveFrame");
		
		fnDeleteFileHtml(seq);
	}
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).remove();
		
		//$('#divFileImg').hide();
		
	}

	function setSubFrame() {
		
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
 				+"&id="+$(trObj).find("#ItemID").text()
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
			
			if(setAllCondition()) {
			
			var url = "zhec_saveItemInfo.do";	
			var frm = document.getElementById('editSTPFrm');
			ajaxSubmitNoAdd(frm, url);
			}
		}
	}
	

	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&option=AR010100&hiddenClassList='CL05003','CL16004'";

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

			if(temp2.length > 1 && scrnMode == "E" && temp2[0] != "viewScrn") {                            
				data += "&" + temp2[0] + "=" + temp2[1];
			}
			else if(temp2.length > 1 && scrnMode != "E" && temp2[0] != "editScrn") {
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
 				+"&viewScrn=custom/hyundai/hec/item/viewSOPInfo&screenMode=pop"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	

	function goApprovalPop() {
		

		if(confirm("${CM00001}") && setAllCondition()){		
			isWf = "Y";
			var url = "zhec_saveItemInfo.do";	
			ajaxSubmitNoAdd(document.editSTPFrm, url);
			
		}
		
	}
	function fnItemDelete() {

		if(confirm("폐기를 진행 하시겠습니까?") && setAllCondition()){		
			isWf = "Y";
			$("#scrnMode").val("D");
			
			var url = "zhec_saveItemInfo.do";	
			var frm = document.getElementById('editSTPFrm');
			ajaxSubmitNoAdd(frm, url);			
		}
		
	}
	

	function fnEditCallBack(avg) {
		if(isWf == "Y" && avg != "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack();
		}
		else if (isWf == "Y" && avg == "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack();
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
	        data = "s_itemID=${itemID}&varFilter=CN00116&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame";
	
	        ajaxPage(url, data, "subRelFrame");
    	}
    	if(avg == "3") { 
  		  $("#Con_01").hide();
	        $("#Con_02").hide();   	
	        $("#Con_03").show();   	
	        url = "itemHistory.do";   
	        data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&backBtnYN=N";
	
	        ajaxPage(url, data, "csFrame");
  	}
    }
    
	function saveMainText(){	
		
		if(confirm("${CM00001}")){	
			
			//var url = "zhec_saveMainText.do";	
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('editSTPFrm');
			ajaxSubmitNoAdd(frm, url, "saveFrame");
		}
	}
	
	function fnRefreshPage(option, itemID,scrnMode){
		parent.fnRefreshPageCall(option, itemID,scrnMode);
	}
	

	function fnGoOrgTreePop(){
		var url = "orgTeamTreePop.do";
		var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function fnTeamRoleCallBack(){
	}
	
	function doCallBack(){}
	
	function fnSaveTeamRole(teamIDs,teamNames){
		$("#orgNames").val(teamNames);
		$("#orgTeamIDs").val(teamIDs);
	}
	
	
	// [Back] click
	function goBack() {
		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&editScrn=${editScrn}&viewScrn=${viewScrn}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}";
		ajaxPage(url, data, "processItemInfo");
	}
	
	function selfClose(){
		goBack();
	}
	

	function setAllCondition() {
		
		if("${sessionScope.loginInfo.sessionAuthLev}" == "1") {
			return true;
		}		
		
		if ($("#parentID").val() == "" ) {
			alert("분류체계를 선택하여 주십시오.");
			return false;
		}
		if ($("#AT00001").val() == "" ) { 
			alert("표준명을 입력하여 주십시오.");
			return false;
		}
		if ($("#Description").val() == "" ) {
			alert("제/개정/폐기 사유를 입력하여 주십시오.");
			return false;
		}
		if ($("#Reason").val() == ""  ) {
			alert("주요 개정 사항을 입력하여 주십시오.");
			return false;
		}

		return true;
	}
	
</script>
</head>
<!-- BIGIN :: -->
<body>
<form name="editSTPFrm" id="editSTPFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
<div id="processItemInfo">
<input type="hidden" id="s_itemID" name="s_itemID"  value="${itemID}" />
<input type="hidden" id="option" name="option"  value="${option}" />		
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />			
<input type="hidden" id="sub" name="sub" value="${sub}" />
<input type="hidden" id="function" name="function" value="saveObjInfoMain">
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
<input type="hidden" id="projectId" name="projectId" value="${itemInfo.projectID}" />
<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />

	<div id="htmlReport" style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
				
		<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>
				
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB10">
				<div class="pdL10 pdT15 pdB5" style="width:98%;">
				<c:if test="${scrnMode eq 'N' }">
				<p class="cont_title">표준 신규 등록</p>
				</c:if>
				<c:if test="${scrnMode eq 'E' }">
				<p class="cont_title">표준 편집</p>
				</c:if>
				</div>
				<table class="tbl_preview mgB10">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>표준 유형</th>
						<td class="alignL pdL10">
						<c:if test="${scrnMode eq 'N' }">
						<select id="itemTypeCode" name="itemTypeCode" class="sel">
						<option value="OJ00005">SOP</option>
						<option value="OJ00016">STP</option>
						</select>
						
						<th>분류체계</th>
						<td class="alignL pdL10">
						<input type="text" id="parentPath" name="parentPath" value="${itemInfo.Path}" class="text" onClick="fnOpenItemTree()">
						<input type="hidden" id="parentID" name="parentID" />
						</td>
						</c:if>						
						<c:if test="${scrnMode eq 'E' }">
						${itemInfo.ItemTypeName}
						<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${itemInfo.ItemTypeCode}">
						<input type="hidden" id="classCode" name="classCode" value="${itemInfo.ClassCode}">
						</td>
						
						<th>분류체계</th>
						<td class="alignL pdL10">${itemInfo.Path}
						</td>
						</c:if>
					</tr>
					<c:if test="${scrnMode eq 'N' }">
					<tr>
						<th>명칭</th>
						<td class="alignL pdL10">
						<input type="text" id="AT00001" name="AT00001" value="" class="text" maxLength="100">
						</td>
						<th>유관조직</th>
						<td class="alignL pdL10">
						<input type="text" id="orgNames" name="orgNames" value="" class="text" onClick="fnGoOrgTreePop()">
						</td>
					</tr>
					</c:if>
					<c:if test="${scrnMode eq 'E' }">
					<tr>
						<th>Stp No.</th>
						<td class="alignL pdL10">
						${itemInfo.Identifier}
						</td>
						<th>명칭</th>
						<td class="alignL pdL10">
						<input type="text" id="AT00001" name="AT00001" value="${itemInfo.ItemName}" class="text" maxLength="100">
						</td>
					</tr>
					<tr>
						<th>주관조직</th>
						<td class="alignL pdL10">
						${itemInfo.OwnerTeamName}						
						</td>
						<th>유관조직</th>
						<td class="alignL pdL10">
						
						
						<input type="text" id="orgNames" name="orgNames" value="<c:set value="1" var="no"/><c:forEach var="list" items="${roleList}"><c:if test="${list.TeamRoletype eq 'REL'}"><c:if test="${no ne 1}">&#44; </c:if>${list.TeamNM}<c:set var="no" value="${no+1}"/></c:if></c:forEach>" class="text" onClick="fnGoOrgTreePop()">
						</td>
					</tr>
					</c:if>
					<tr>
						<th>제/개정 사유</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;">${itemInfo.ChangeSetDec}</textarea> 
						</td>						
					</tr>
					<tr>
						<th>주요 개정 사항</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Reason" name="Reason" style="width:100%;height:40px;">${itemInfo.Reason}</textarea>
						</td>						
					</tr>
					<c:if test="${scrnMode eq 'E' }">	
					<tr>
						<th>첨부문서</th>
						<td class="alignL pdL10" colspan="3">
						<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
							<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
								<c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID || sessionScope.loginInfo.sessionAuthLev eq 1}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('${fileList.Seq}')"></c:if>
								<br>
							</div>
						</c:forEach>
						</div>
					</tr>
					</c:if>
				</table>
			</div>
			
			<div class="alignR">
				<c:if test="${scrnMode eq 'N' }">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
				</c:if>
				<c:if test="${scrnMode eq 'E' }">			
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="button" onclick="goBack()"></span>
				<span class="btn_pack medium icon"><span class="upload"></span><input value="${menu.LN00019}" type="button" onclick="doAttachFile()"></span>&nbsp;&nbsp;		
				<span class="btn_pack medium icon"><span class="search"></span><input value="Preview" onclick="openPreviewPop()" type="submit"></span>
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
				<c:if test="${itemInfo.Status ne 'NEW1'}">
				<span class="btn_pack medium icon"><span class="del"></span><input value="폐기" onclick="fnItemDelete()" type="submit"></span>
				</c:if>
				<span class="btn_pack medium icon"><span class="save"></span><input value="${menu.LN00211}" onclick="goApprovalPop()" type="submit"></span>
				</c:if>
			</div>
			
			<c:if test="${scrnMode eq 'E' }">
				
				<div class="noticeTab02">
					<input id="tab_02" type="radio" name="notice02" checked>
					<label for="tab_02" id="pli5" onclick="setInfoFrame('2');"><h5>연관 항목</h5></label>
					<input id="tab_03" type="radio" name="notice02">
					<label for="tab_03" id="pli6" onclick="setInfoFrame('3');"><h5>${menu.LN00215}</h5></label>
					<div id="Con_02">
						<div id="subRelFrame"  name="subRelFrame" style="width:100%;"></div>
					</div>
					<div id="Con_03">
						<div id="csFrame"  name="csFrame" style="width:100%;"></div>
					</div>
				</div>	
			</c:if>
			
		</div>
	</div>
</div>
</form>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
