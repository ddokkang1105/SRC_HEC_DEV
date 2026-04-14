<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001"	var="CM00001" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095"	var="WM00095" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003"	var="WM00003" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00184"	var="WM00184" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00181"	var="WM00181" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00182"	var="WM00182" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00001" arguments="${menu.LN00101}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_parentID" arguments="${menu.ZLN0102}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01040" arguments="${menu.ZLN0085}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01050" arguments="${menu.ZLN0044}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01051" arguments="${menu.ZLN0067}"/>


<style>
.noticeTab02 {
	margin-top: -15px;
}

.noticeTab02>input {
	display: none;
}

.noticeTab02>label {
	display: inline-block;
	margin: 0 0 -1px;
	padding: 15px 0;
	font-weight: 700;
	text-align: center;
	color: #999999;
	width: 62px;
}

.noticeTab02>section {
	display: none;
	padding: 20px 0 0;
}

.noticeTab02>input:checked+label {
	color: #333333;
	border-bottom: 3px solid #008bd5;
}
/* 	#tab_01:checked ~ #Con_01,#tab_02:checked ~ #Con_02{display: block;} */
#itemDiv>div {
	padding: 0 10px;
}

#refresh:hover {
	cursor: pointer;
}

.tdhidden {
	display: none;
}

#maintext table {
	border: 1px solid #ccc;
	width: 100%;
}

#maintext th {
	text-align: left;
	padding: 10px;
	color: #000;
	font-weight: bold;
}

#maintext td {
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
	resize: none;
}

.btn_pack.nobg a.upload {
	background-position: -170px -96px;
}

input.text {
	height: 28px !important;
}
</style>
<script type="text/javascript">
var isWf = "";
const defSiteCode = "${SiteInfo.CODE}";
const defDimValueID = "${defDimValueID}";


	$(document).ready(function(){	

		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		getAttrByClass(document.getElementById("classCode").value);
	
		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		 
		 setParentItem('${curItemID}','${itemInfo.Path}')
	     checkBoxValue(defDimValueID);
		 
		 $('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		 fnSelect('ZAT01050', data+"&attrTypeCode=ZAT01050", 'getAttrTypeLov', '', '');
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=SOP&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id=${itemID}&fltpCode=FLTP003";
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
		ajaxSubmitNoAdd(document.createProcForm, url,"saveFrame");
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
		ajaxSubmitNoAdd(document.createProcForm, url,"saveFrame");
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
	
	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
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
 				+"&itemViewPage=custom/hyundai/hec/item/viewSOPInfo&screenMode=pop"
 				+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	
    
	function saveMainText(){	
		
		if(confirm("${CM00001}")){	
			
	
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('createProcForm');
			ajaxSubmitNoAdd(frm,url, "saveFrame");
		}
	}
	
	function fnRefreshPage(option, itemID,scrnMode){

		
		var url = "zSKON_ProcessItemInfo.do";
		var data = "&itemEditPage=custom/sk/skon/item/zSKON_editTSDInfo&accMode=DEV&scrnMode=N&option=${option}";	
		var target = "m";
		ajaxPage(url, data, target);
		
	}
	

	

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
	
	
	// [Back] click
 	function goBack(itemID) {
	
		var url = "processItemInfo.do";
		
		var data = "itemID="+itemID+"&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&itemInfoRptUrl=/custom/sk/skon/report/subItemInfoReport"
			+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "processItemInfo");
	} 


	//edit버튼 클릭시
	

	function fnEditItemInfo(itemID) {
        $('#loading').fadeOut(150);
// 	    console.log("callback: "+"${defDimValueID}");
// 	 	var url = "processItemInfo.do";
// 		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
// 		+"&itemEditPage=custom/sk/skon/item/zSKON_editTSDInfo"
// 		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
// 		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
// 		+"&defSiteCode="+defSiteCode
// 		+"&wfOption=E"
// 		+"&defDimValueID="+defDimValueID
// 		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
// 		ajaxPage(url, data, "processItemInfo"); 
		parent.fnRefreshTree(itemID,true);
	}
	
	//편집 저장후 콜백
	function fnCllbackEdit(itemID) {
		
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/zSKON_editTSDInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&defDimValueID="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		var target = "processItemInfo";
		ajaxPage(url, data, target); 
	}
	
	
	function selfClose(){
		goBack();
	}
	

	function setAllCondition() {
		const classCode = $("#classCode").val();
		
		if ($("#AT00001").val() == "" ) { 
			alert("${WM00034_AT00001}"); // 문서명을 입력하여 주십시오.
			return false;
		}
		
		if(classCode == "CL01006A" || classCode == "CL01006B") {
			if ($("#parentID").val() == "") {
				alert("${WM00025_parentID}"); // 상위문서를 선택하여 주십시오.
				return false;
			}
			
			if ($("#ZAT01040").val() == "") {
				alert("${WM00025_ZAT01040}"); // 문서분야를 선택하여 주십시오.
				return false;
			}
			
			if ($("#ZAT01050").val() == "") {
				alert("${WM00025_ZAT01050}");	// 공정을 선택하여 주십시오.
				return false;
			}
			
			if ($("#ZAT01051").val() == "") {
				alert("${WM00025_ZAT01051}");	// 상세공정을 선택하여 주십시오.
				return false;
			}
		}
		
		return true;
	}
	


// 공통 체크박스 선택 및 해제 시 나머지 전부 체크 및 해제 
document.getElementById('cmm').addEventListener('change', function() {
 let check = document.querySelectorAll('input[name="siteCode"]');
  check.forEach(function(checkbox) {
	  if(checkbox.value != defDimValueID){
		   checkbox.checked = document.getElementById('cmm').checked;
	  }
  });
});


//체크박스 이벤트 
function checkBoxValue(defDimValueID){
	
	
	let checkBoxes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]');
	
	checkBoxes.forEach(function(checkbox){
		if(defDimValueID!=="SKO1"){
			checkbox.disabled = true; 			
		}
		
		if(checkbox.id === defDimValueID){
			checkbox.checked = true;
			checkbox.disabled = true;
		
			
		}
	})
}


function checkSiteCode() {

    
    let siteCodes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]:checked');
    let values = [];  

    //디폴트값 먼저 추가 
     values.push(defDimValueID);

    siteCodes.forEach(function(checkbox) {
        // 체크된 항목의 값을 배열에 추가 디폴트값 제외
        if(checkbox.value !== defDimValueID){
        	
        values.push(checkbox.value);
        }
     
    });
 

    return values;  
}




//저장
var inProgress = false;
function saveObjInfoMain() {	
 
	if(inProgress) {
		alert("${WM00003}");
	} else {
	    if(setAllCondition()) {	
	    	if(confirm("${CM00001}")) {
	    		$('#loading').fadeIn(150);
	            var selectedSiteCodes = checkSiteCode();  
	            var siteCodesInput = document.createElement('input');  
	            siteCodesInput.type = 'hidden';
	            siteCodesInput.name = 'siteCodes';
	            siteCodesInput.value = selectedSiteCodes.join(',');  
	            
	       
	            var frm = document.getElementById('createProcForm');
	            frm.appendChild(siteCodesInput);  
	            
	            var url = "zskon_createProcessInfo.do";
	            inProgress = true;
	            $('#loading').fadeIn(150);
	            
	            ajaxSubmitNoAdd(frm, url);
	      }
	    }
	}
}


function goList(){
	var url = "zSKON_searchPrcList.do";
	var data = "&url=/custom/sk/skon/item/process/searchProcessList&defClassList=CL01005,CL01005A,CL01006A,CL01006B&screenOption=Y"
				+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
				
	ajaxPage(url, data, "createProcForm");
}

function getAttrByClass(classCode) {
	const attrs = document.getElementsByClassName("attr");
	for(attr of attrs) {
		if(classCode == "CL01005" || classCode == "CL01006A") {
			if(attr.getAttribute("name") === "a") attr.style.display = "table-row";
			else attr.style.display = "none";
		}
		if(classCode == "CL01005A" || classCode == "CL01006B") {
			if(attr.getAttribute("name") === "b") attr.style.display = "table-row";
			else attr.style.display = "none";
		}
	}
	
	if(classCode == "CL01005" || classCode == "CL01005A") {
		var options = document.querySelectorAll('#ZAT01040 option');
	    options.forEach(o => o.remove());
		ZAT01040.style.display = "none";
		ZAT01040.parentElement.previousElementSibling.childNodes[0].style.display = "none";
		document.getElementById("parentID").value = "${curItemID}";
		document.getElementById("ZAT01020").value = "3";
		document.getElementById("ZAT01020Value").innerText = "Lv3";
		document.getElementById("ZAT01060").value = "GP";
		document.getElementById("ZAT01060Value").innerText = "${menu.ZLN0090}"; // 업무절차서
		document.getElementById("L3Item").innerHTML = "";
		document.querySelectorAll(".L4show").forEach(e => e.style.display = "none");
		document.querySelectorAll(".L4hidden").forEach(e => e.style.display = "table-cell");
	}
	
	// L4
	if(classCode == "CL01006A" || classCode == "CL01006B") {
		if(ZAT01040.options.length == 0)fnSelect('ZAT01040', data+"&attrTypeCode=ZAT01040", 'getAttrTypeLov', '', '');
		ZAT01040.style.display = "block";
		ZAT01040.parentElement.previousElementSibling.childNodes[0].style.display = "inline-block";
		document.getElementById("parentID").value = "";
		document.getElementById("ZAT01020").value = "4";
		document.getElementById("ZAT01020Value").innerText = "Lv4";
		document.getElementById("ZAT01060").value = "GU";
		document.getElementById("ZAT01060Value").innerText = "${menu.ZLN0098}"; // 업무지침서
		fnSelect('L3Item',"&classCodeList='CL01005','CL01005A'&itemTypeCode=OJ00001&L2ItemID=${curItemID}&dimTypeID=100001&dimValueID=${defDimValueID}",'getItemNameListByHier','', 'Select');
		document.querySelectorAll(".L4show").forEach(e => e.style.display = "table-cell");
		document.querySelectorAll(".L4hidden").forEach(e => e.style.display = "none");
	}
}

function fnL3ItemChange(L3Item) {
	document.getElementById("parentID").value = L3Item;
}

function ZAT01050change(value){
	if(value) fnSelect('ZAT01051', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+value, 'getSubLovList', '', 'Select');
	else fnSelect('ZAT01051', data+"&attrTypeCode=ZAT01051", 'getAttrTypeLov', '', 'Select');
}
</script>
</head>
<!-- BIGIN :: -->
<body>
	<form name="createProcForm" id="createProcForm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;">
		<div id="processItemInfo">

			<input type="hidden" id="s_itemID" name="s_itemID" value="${curItemID}" />
			<input type="hidden" id="option" name="option" value="${option}" />
			<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
			<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
			<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
			<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />
			<input type="hidden" id="sub" name="sub" value="${sub}" />
			<input type="hidden" id="function" name="function" value="saveObjInfoMain">
			<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
			<input type="hidden" id="projectId" name="projectId" value="${itemInfo.projectID}" />
			<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
			<input type="hidden" id="defSiteCode" name="defSiteCode" value="${SiteInfo.CODE}" />
			<input type="hidden" id="defDimValueID" name="defDimValueID" value="${defDimValueID}" />
			<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="OJ00001" />
			<input type="hidden" id="parentID" name="parentID" value="${curItemID}" />
			<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP002" />
			
			<input type="hidden" id="ZAT01020" name="ZAT01020" value="3" class="text">
			<input type="hidden" id="ZAT01060" name="ZAT01060" value="GP" />

			<!-- 상단 헤더값  -->
			<div class="cop_hdtitle" id="cop_hdtitle" style="border-bottom: 1px solid #ccc; padding: 10px 0 6px 0;">
				<h3 style="display: inline-block">
					<img src="${root}${HTML_IMG_DIR}/icon_search_title.png" style="margin-right: 5px;"> ${menu.ZLN0099} - ${menu.ZLN0100} <!-- Process - 신규등록 -->
					<c:if test="${scrnType ne 'pop' }">
						<span class="btn_pack medium icon" style="margin-left: 10px;"><span class="pre"></span> <input value="List" type="button" onclick="goList()"></span>
						<!--<button class="cmm-btn mgR5" style="height: 30px; margin-left: 5px;" onclick="goList()" value="List">List</button>-->
					</c:if>
				</h3>
			</div>

			<div id="htmlReport" style="width: 100%; height: 100%; overflow-y: auto; overflow-x: hidden;">
				<div id="itemDiv">
					<div id="process" class="mgB10 pdT15">
						<div class="alignR">
							<p class="cont_title mgb1"></p>
							<span class="btn_pack medium icon"><span class="save"></span> <input value="Save" onclick="saveObjInfoMain()" type="submit"> </span>
							<!--<button class="cmm-btn2 mgR5" style="height: 30px; margin-bottom:5px;" onclick="saveObjInfoMain()" value="Save">Save</button> -->
						</div>

						<table class="tbl_preview mgB10">
							<colgroup>
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>

							<!-- Attr 속성값 -->
							<tr style="height:41px;">
								<!-- 문서구분 -->
								<th>${menu.ZLN0101}</th>
								<td colspan="2" class="alignL pdL10">
									<select id="classCode" name="classCode" class="sel" onchange="getAttrByClass(this.value)">
										<option value="CL01005">Process (L3)</option>
										<option value="CL01005A">Process (L3)_file</option>
										<option value="CL01006A">Process (L4)</option>
										<option value="CL01006B">Process (L4)_file</option>
									</select>
								</td>
								<!-- 상위문서 -->
								<th class="L4show" style="display:none;"><span style="color: red;">*</span>${menu.ZLN0102}</th>
								<td class="L4show" style="display:none;">
									<select id="L3Item" name="L3Item"style="width: 100%;display: inline-block;" onchange="fnL3ItemChange(this.value)">
										<option value=''></option>
									</select>
								</td>
								<td class="L4hidden"></td>
								<td class="L4hidden"></td>
								<!-- 문서명 -->
								<th><span style="color: red;">*</span>${menu.LN00101}</th>
								<td colspan="2" class="alignL pdL10">
									<input type="text" id="AT00001" name="AT00001" value="" class="text" maxLength="100">
								</td>
								<!-- 개정번호 -->
								<th>${menu.LN00356}</th>
								<!-- (작성중) -->
								<td colspan="2" class="alignL pdL10">
									0 <span style="font-weight: bold; margin-left: 5px;">(${menu.ZLN0103})</span>
									<input type="hidden" id="" name="" value="" class="text" maxLength="100" disabled>
								</td>
							</tr>
							
							<tr style="height:41px;">
								<!-- 담당Site -->
								<th>${menu.ZLN0089}</th>
								<td colspan="2" class="alignL pdL10">${SiteInfo.siteNM}
									<input type="hidden" id="ZAT01010" name="ZAT01010" value="${SiteInfo.CODE}" class="text">
									<input type="hidden" id="docSiteVal" name="docSiteVal" value="${docSiteInfo.Value}" class="text">
									<input type="hidden" id="ZAT01080" name="ZAT01080" value="${docSiteInfo.LovCode}" class="text">
								</td>
								<!-- 담당부서 -->
								<th>${menu.ZLN0074}</th>
								<td class="alignL pdL10">${TeamName}</td>
								<!-- 담당자 -->
								<th>${menu.LN00004}</th>
								<td class="alignL pdL10" colspan="2">${sessionScope.loginInfo.sessionUserNm}</td>
								<!-- 문서레벨 -->
								<th>${menu.ZLN0075}</th>
								<td class="alignL pdL10" id="ZAT01020Value">Lv3</td>
							</tr>
							<tr style="height:41px;">
								<!-- 영역 -->
								<th>${menu.ZLN0072}</th>
								<td colspan="2" class="alignL pdL10">${defaultAttr.L1Name}
								<input type="hidden" id="ZAT01030" name="ZAT01030" value="${docAreaLov.LovCode}" class="text" onClick="">
								</td>
								<!-- 상세영역 -->
								<th>${menu.ZLN0073}</th>
								<td class="alignL pdL10">
									<c:choose>
										<c:when test="${!empty defaultAttr.L2Name}">${defaultAttr.L2Name}
										<input type="hidden" id="ZAT02022" name="ZAT02022" value="${docDetailAreaLov.LovCode}" class="text" ></c:when>
										<c:otherwise>${defaultAttr.L3Name}
										<input type="hidden" id="ZAT02022" name="ZAT02022" value="${docDetailAreaLov.LovCode}" class="text" >
										</c:otherwise>
										
									</c:choose>
								</td>
								<!-- 문서유형  -->
								<th>${menu.LN00091}</th>
								<!-- 업무절차서 -->
								<td class="alignL pdL10" colspan="2" id="ZAT01060Value">${menu.ZLN0090}</td>
								<!-- 문서분야 -->
								<th><span style="color: red;">*</span>${menu.ZLN0085}</th>
								<td colspan="2" class="alignL pdL10">
									<select id="ZAT01040" name="ZAT01040" class="sel" style="display:none;"></select>
								</td>
							</tr>
						
							<tr style="height:43px;">
								<!-- 배포Site -->
								<th>${menu.ZLN0031}</th>
								<td style="" colspan=4 class="alignL pdL10" >
									<input type="checkbox" name="siteCode" id="cmm" value="cmm">
									<label for="cmm" class="mgR10">${menu.ZLN0028}</label>
									<input type="checkbox" name="siteCode" id="SKO1" value="SKO1">
									<label for="SKO" class="mgR10">${menu.ZLN0029}</label>
									<input type="checkbox" name="siteCode" id="SKO2" value="SKO2">
									<label for="SKO2" class="mgR10">${menu.ZLN0030}</label>
									<input type="checkbox" name="siteCode" id="SKBA" value="SKBA">
									<label for="SKBA" class="mgR10">${menu.ZLN0079}</label>
									<input type="checkbox" name="siteCode" id="SKOH1" value="SKOH1">
									<label for="SKOH1" class="mgR10">${menu.ZLN0080}</label>
									<input type="checkbox" name="siteCode" id="SKOH2" value="SKOH2">
									<label for="SKOH2" class="mgR10">${menu.ZLN0081}</label>
									<input type="checkbox" name="siteCode" id="SKBM" value="SKBM">
									<label for="SKBM" class="mgR10">${menu.ZLN0082}</label>
									<input type="checkbox" name="siteCode" id="SKOJ" value="SKOJ">
									<label for="SKOJ" class="mgR10">${menu.ZLN0083}</label>
									<input type="checkbox" name="siteCode" id="SKOY" value="SKOY">
									<label for="SKOY" class="mgR10">${menu.ZLN0084}</label>
									<input type="checkbox" name="siteCode" id="SKOS" value="SKOS">
									<label for="SKOS">${menu.ZLN0150}</label>
								</td>
								<!-- 공정 -->
								<th class="L4show"><span style="color: red;">*</span>${menu.ZLN0044}</th>
								<td colspan="2" class="alignL pdL10 L4show">
									<select id="ZAT01050" name="ZAT01050" class="sel" onchange="ZAT01050change(this.value)"></select>
								</td>
								<!-- 상세공정 -->
								<th class="L4show"><span style="color: red;">*</span>${menu.ZLN0067}</th>
								<td class="alignL pdL10 L4show">
									<select id="ZAT01051" name="ZAT01051" class="sel"></select>
								</td>								
								<td class="L4hidden"></td>
								<td class="L4hidden"></td>
								<td class="L4hidden"></td>
								<td class="L4hidden"></td>
								<td class="L4hidden"></td>
							</tr>
							<!-- 목적 -->
							<tr name="a" class="attr">
								<th>${menu.LN00386}</th>
								<td class="alignL pdL10" colspan="10">
									<textarea class="edit" id="AT00803" name="AT00803" style="width:100%;height:40px;"></textarea> 
								</td>
							</tr>
							<!-- 적용범위 -->
							<tr name="a" class="attr">
								<th>${menu.ZLN0091}</th>
								<td class="alignL pdL10" colspan="10">
									<textarea class="edit" id="ZAT02016" name="ZAT02016" style="width:100%;height:40px;"></textarea> 
								</td>
							</tr>
							<!-- 책임과 권한 -->
							<tr name="a" class="attr">
								<th>${menu.ZLN0092}</th>
								<td class="alignL pdL10" colspan="13">
									<textarea class="tinymceText" id="ZAT02017" name="ZAT02017" style="width: 100%; height: 450px;">
									<table border="1" style="border-collapse: collapse; width: 100%; height: 67px;">
									  <thead>
									    <tr>
									      <!-- Role 구분 / 책임과권한  -->
									      <th style="text-align: center; width: 20%;">${menu.ZLN0104} ${menu.LN00042}</th>
									      <th style="text-align: center; width: 80%;">${menu.ZLN0092}</th>
									    </tr>
									  </thead>
									  <tbody>
									    <tr>
									      <td></td>
									      <td></td>
									    </tr>
									  </tbody>
									</table>
									</textarea>
								</td>
							</tr>
							<!-- 기록 및 보관 -->
							<tr name="a" class="attr">
								<th>${menu.ZLN0093}</th>
								<td class="alignL pdL10" colspan="13">
									<textarea class="tinymceText" id="ZAT02020" name="ZAT02020" style="width: 100%; height: 450px;">
										<table border="1" style="border-collapse: collapse; width: 100%;">
										  <thead>
										    <tr>
										      <!-- 문서명 / 표준양식 / 주관 / 보관장소 / 보관기간 -->
										      <th style="text-align: center; width: 20%;">${menu.LN00101}</th>
										      <th style="text-align: center; width: 20%;">${menu.ZLN0105}</th>
										      <th style="text-align: center; width: 20%;">${menu.ZLN0106}</th>
										      <th style="text-align: center; width: 20%;">${menu.ZLN0107}</th>
										      <th style="text-align: center; width: 20%;">${menu.ZLN0108}</th>
										    </tr>
										  </thead>
										  <tbody>
										    <tr>
										      <td></td>
										      <td style="text-align: center;">Y/N</td>
										      <td></td>
										      <td></td>
										      <td></td>
										    </tr>
										    <tr>
										      <td></td>
										      <td style="text-align: center;">Y/N</td>
										      <td></td>
										      <td></td>
										      <td></td>
										    </tr>
										    <tr>
										      <td></td>
										      <td style="text-align: center;">Y/N</td>
										      <td></td>
										      <td></td>
										      <td></td>
										    </tr>
										  </tbody>
										</table>
									</textarea>
								</td>
							</tr>
							<!-- 문서개요 -->
							<tr name="b" class="attr">
								<th>${menu.ZLN0094}</th>
								<td class="alignL pdL10" colspan="13">
									<textarea class="tinymceText" id="AT00003" name="AT00003" style="width: 100%; height: 270px;"></textarea>
								</td>
							</tr>
							<!-- 키워드 -->
							<tr>
								<th>${menu.ZLN0070}</th>
								<td class="alignL pdL10" colspan="13">
									<input type="text" id="AT01007" name="AT01007" value="" class="text" maxLength="100" style="width: 100%;">
								</td>
							</tr>
							<!-- 주요개정사항 -->
							<tr>
								<th>${menu.LN00360}</th>
								<td class="alignL pdL10" colspan="10">
									<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;"></textarea> 
								</td>
							</tr>
							<!-- 첨부문서 -->
							<tr>
								<th>${menu.LN00019}</th>
								<td class="alignL pdL10 alignT" colspan="10" style="width: 100%; height: 200px;">
									<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span> <input value="Attach" type="submit" onclick="doAttachFileV4()" style="margin-bottom: 5%;"></span>
									<div class="tmp_file_wrapper mgT15" style="display: none;">
										<table id="tmp_file_items" name="tmp_file_items" width="100%">
											<colgroup>
												<col width="40px">
												<col width="">
												<col width="70px">
											</colgroup>
											<thead>
												<tr class="header-row">
													<!-- Name / Size -->
													<th></th>
													<th class="pdL10">Name</th>
													<th class="alignC">Size</th>
												</tr>
											</thead>
											<tbody name="file-list"></tbody>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</form>
	<script>
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		
		var url="addFilePopV4.do";
		var data="scrnType=CS&fltpCode=FLTP002";
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
		display_scripts = document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML;
		fileIDMapV4.forEach(function(fileID) {
			  display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
			  '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
			  '<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
			  '<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
			  '</tr>';
		});
		document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML = display_scripts;		
		$(".tmp_file_wrapper").attr('style', 'display: block');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		var fileName = document.getElementById(fileID).children.namedItem("fileName").innerHTML;
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
		//alert(url);
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
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
	function backToList(){
		window.history.back();
	}
</script>
<iframe id="saveFrame" name="saveFrame" style="display: none" frameborder="0"></iframe>
</body>
</html>
