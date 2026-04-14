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
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003" />

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
		
		$("input.datePicker").each(generateDatePicker);
		$('#ZAT03230, #ZAT03240, #ZAT03250').timepicker({
            timeFormat: 'H:i',
            minTime : '00:00am',
            maxTime : '11:59pm',
        });
		
		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		 
		 setParentItem('${curItemID}','${itemInfo.Path}')
	     checkBoxValue(defDimValueID);
		 
		 $('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		 $.ajax({
			 url: "/getItemAttrLovCode.do",
		     type: "GET",
		     data: {
		    	itemID: "${curItemID}",
		        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
		        attrTypeCode: "ZAT03010"
		     },
		     dataType: "text",
		     success: function(result) {
		    	document.getElementById("ZAT03010").value = result;
		 		fnSelect('ZAT03011', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+result, 'getSubLovList', '', 'Select');
		  
		     },
		     error: function() {
		         console.error("에러 발생");
		     }
		 });
		  
		 getAttrLovList("ZAT03130");
		 getAttrLovList("ZAT03131");
		 getAttrLovList("ZAT03132");
		 getAttrLovList("ZAT03133");

	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=SOP&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id=${itemID}&fltpCode=FLTP012";
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
		ajaxSubmitNoAdd(document.createMTRForm, url,"saveFrame");
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
		ajaxSubmitNoAdd(document.createMTRForm, url,"saveFrame");
	}

	function fnDeleteItemFile(seq){
		var url = "changeSetFileDelete.do";
		var data = "&delType=1&fltpCode=FLTP012&seq="+seq;
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
			var frm = document.getElementById('createMTRForm');
			ajaxSubmitNoAdd(frm,url, "saveFrame");
		}
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
			+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "processItemInfo");
	} 


	// Call Back After Create
	function fnEditItemInfo(itemID) {
		  
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/mtr/editMTRInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&wfOption=E"
		+"&defDimValueID="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "processItemInfo"); 
		
	}
	
	// Call Back After Edit-Save
	function fnCllbackEdit(itemID) {
	
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/mtr/editMTRInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defDimValueID="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		var target = "processItemInfo";
		ajaxPage(url, data, target); 
	}

	function selfClose(){
		goBack();
	}
	

	function setAllCondition() {	
		return true;
	}
	


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

    values.push(defDimValueID);

    siteCodes.forEach(function(checkbox) {
        if(checkbox.value !== defDimValueID){
        	values.push(checkbox.value);
        }
     
    });
 
    return values;  
}

function appendZAT03090Values() {
	const selected = [];
	document.querySelectorAll('input[type="checkbox"][name="ZAT03090"]:checked').forEach(cb => {
		selected.push(cb.value);
	});
	
	const multiValueInput = document.createElement('input');
	multiValueInput.type = 'hidden';
	multiValueInput.name = 'ZAT03090';
	multiValueInput.value = selected.join('$$');

	document.getElementById('createMTRForm').appendChild(multiValueInput);
}


/* //체크된 기인 - 원인 코드 찾기 
function checkZAT03090() {
    let ZAT03090s = document.querySelectorAll('input[type="checkbox"][name="ZAT03090"]:checked');
    let values = [];  

    ZAT03090s.forEach(function(checkbox) {
    	values.push(checkbox.value);
    });
    
    return values;  
} */


//저장
var inProgress = false;
function saveObjInfoMain() {	
 
	if(inProgress) {
		alert("${WM00003}");
	} else {
	    if(setAllCondition()) {	
	    	if(confirm("${CM00001}")) {
	    		$('#loading').fadeIn(150);
	    		
	    		appendZAT03090Values();
	    		
	            var selectedSiteCodes = checkSiteCode();  
	            var siteCodesInput = document.createElement('input');  
	            siteCodesInput.type = 'hidden';
	            siteCodesInput.name = 'siteCodes';
	            siteCodesInput.value = selectedSiteCodes.join(',');  

	            var frm = document.getElementById('createMTRForm');
	            frm.appendChild(siteCodesInput);  
	            
	            var url = "zSKON_createMTRInfo.do";
	            inProgress = true;
	            $('#loading').fadeIn(150);
	            
	            ajaxSubmitNoAdd(frm, url);
	      }
	    }
	}
}


function goList(){
	var url = "zSKON_searchPrcList.do";
	var data = "&url=/custom/sk/skon/item/mtr/searchMTRList&defClassList=CL12003&screenOption=Y"
				+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
				
	ajaxPage(url, data, "createMTRForm");
}

async function getAttrLovList(attrTypeCode){		
	let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+"&sqlID=attr_SQL.selectAttrLovOption"
						+"&attrTypeCode="+attrTypeCode;

	fetch("/olmapi/getLovValue/?"+param)	
	.then(res => res.json())
	.then(res => {
		let lovHtml = "";
		lovHtml += "<option value=''>Select</option>"
		for(var i=0; i < res.data.length; i++) {
			lovHtml += '<option value="'+res.data[i].CODE+'">'+res.data[i].NAME+'</option>';
		}
		
		document.querySelector("#"+attrTypeCode).innerHTML = lovHtml;
	});
}

</script>
</head>
<!-- BIGIN :: -->
<body>
	<form name="createMTRForm" id="createMTRForm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;">
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
			<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="OJ00012" />
			<input type="hidden" id="classCode" name="classCode" value="CL12003" />
			<input type="hidden" id="parentID" name="parentID" value="${curItemID}" />
			<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP012" />
			<input type="hidden" id="ZAT03010" name="ZAT03010" />

			<!-- 상단 헤더값  -->
			<div class="cop_hdtitle" id="cop_hdtitle" style="border-bottom: 1px solid #ccc; padding: 10px 0 6px 0;">
				<h3 style="display: inline-block">
					<img src="${root}${HTML_IMG_DIR}/icon_search_title.png" style="margin-right: 5px;"> ${menu.ZLN0140} - ${menu.ZLN0100}
					<c:if test="${scrnType ne 'pop' }">
						<span class="btn_pack medium icon" style="margin-left: 10px;"><span class="pre"></span> <input value="List" type="button" onclick="goList()"></span>
					</c:if>
				</h3>
			</div>

			<div id="htmlReport" style="width: 100%; height: 100%; overflow-y: auto; overflow-x: hidden;">
				<div id="itemDiv">
					<div id="process" class="mgB10 pdT15">
						<div class="alignR">
							<p class="cont_title mgb1"></p>
							<span class="btn_pack medium icon"><span class="save"></span> <input value="Save" onclick="saveObjInfoMain()" type="submit"> </span>
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
							
							<!-- 문서명 / 개정번호 -->
							<tr>
								<th class="last">${menu.LN00101}</th>
							    <td colspan="7" class="alignL pdL10 pdR10 last">
									<input type="text" id="AT00001" name="AT00001" value="${attrMap.AT00001}" class="text" maxLength="100" >
								</td>
								<th>${menu.LN00356}</th>
								<td class="alignL pdL10 pdR10 last">0 <span style="font-weight:bold; margin-left:5px;">(${menu.ZLN0103})</span> <!-- (작성중) -->
								<input type="hidden"
									id="" name="" value="" class="text" maxLength="100" disabled>
								</td> 
							</tr>
							<!-- 불량등급 / 불량유형 / 작성자(검출) / 작성자(기인)  -->
							<tr>
								<th class="last">${menu.ZLN0033}</th>
								<td colspan="2" class="alignL pdL10 pdR10">
									<c:choose>
										<c:when test="${!empty defaultAttr.L2Name}">${defaultAttr.L2Name}
										<input type="hidden" id="ZAT03010" name="ZAT03010" value="L3Name" class="text" >
										</c:when>
										<c:otherwise>${defaultAttr.L3Name}
										<input type="hidden" id="ZAT03010" name="ZAT03010" value="L3Name" class="text" >
										</c:otherwise>
									</c:choose>
								</td>
								<th class="last">${menu.ZLN0034}</th>
								<td colspan="2" class="alignL pdL10 pdR10">
									<select id="ZAT03011" name="ZAT03011" class="sel"></select>
								</td>
								<th class="last">${menu.ZLN0035}</th>
							    <td class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03220" name="ZAT03220" value="${attrMap.ZAT03220}" class="text" maxLength="100" >
								</td>
							    <th class="last">${menu.ZLN0036}</th>
							    <td class="alignL pdL10 pdR10 last">
									<input type="text" id="AT00024" name="AT00024" value="${attrMap.AT00024}" class="text" maxLength="100" disabled >
								</td>
							</tr>
							
							<!-- 1.개요 -->	
							<tr>
								<th colspan="10" class="alignL pdL10 pdR10 last">${menu.ZLN0056}</th>
							</tr>
							
							<!-- Site / Line / 호기 / Model / 불량위치 / 세부현상 -->
							<tr>
							    <th class="last">${menu.ZLN0037}</th>
							    <th class="last">${menu.ZLN0038}</th>
							    <th colspan="2" class="last">${menu.ZLN0039}</th>
							    <th class="last">${menu.ZLN0040}</th>
							    <th colspan="2" class="last">${menu.ZLN0041}</th>
							    <th colspan="3" class="last">${menu.ZLN0042}</th>
							</tr>
					
							<!-- Site / Line / 호기 / Model / 불량위치 / 불량현상 -->
							<tr>
							   	<td class="alignL pdL10">${SiteInfo.siteNM}
									<input type="hidden" id="ZAT01010" name="ZAT01010" value="${SiteInfo.CODE}" class="text">
									<input type="hidden" id="docSiteVal" name="docSiteVal" value="${docSiteInfo.Value}" class="text">
									<input type="hidden" id="ZAT01080" name="ZAT01080" value="${docSiteInfo.LovCode}" class="text">
								</td>
								<td class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT09006" name="ZAT09006" value="${attrMap.ZAT09006}" class="text" maxLength="100" >
								</td> <!-- Line -->	
								<td colspan="2" class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03020" name="ZAT03020" value="${attrMap.ZAT03020}" class="text" maxLength="100" >
								</td> <!-- 호기 -->	
								<td class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT09005" name="ZAT09005" value="${attrMap.ZAT09005}" class="text" maxLength="100" >
								</td> <!-- Model -->	
								<td colspan="2" class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03030" name="ZAT03030" value="${attrMap.ZAT03030}" class="text" maxLength="100" disabled >
								</td> <!-- 불량위치 -->	
								<td colspan="3" class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03040" name="ZAT03040" value="${attrMap.ZAT03040}" class="text" maxLength="100" disabled >
								</td> <!-- 불량현상 -->	 	
							</tr>
							
							<!-- 검출 (공정) / 발견일시 / Loss / 발생량 / 단위  -->
							<tr>	
						    	<th rowspan="2">${menu.ZLN0043}</th>
						    	<th>${menu.ZLN0044}</th>
						    	<td colspan="2" class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03050" name="ZAT03050" value="${attrMap.ZAT03050}" class="text" maxLength="100" >
								</td>
						    	<th rowspan="2">${menu.ZLN0048}</th>
						    	<td colspan="2" rowspan="2">
									<input type="text" id="ZAT03100" name="ZAT03100" value="${attrMap.ZAT03100}"	class="alignC input_off datePicker stext" size="8"
										style="width: calc(60% - 6px);" onchange="this.value = makeDateType(this.value);" maxlength="10">
									
									<input name="ZAT03230" id="ZAT03230" value="${attrMap.ZAT03230}" class="alignC timePicker stext" style="width: 60px;">
				   				</td>
							    <th>${menu.ZLN0051}</th>
							    <th>${menu.ZLN0052}</th>
							    <th>${menu.ZLN0053}</th>
							 </tr>
							 
							 <!-- 검출 (방법) / 발견일시 / 보류 / 발생량 / 단위 -->
							 <tr>
							 	<th>${menu.ZLN0045}</th>
							 	<td colspan="2" class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03060" name="ZAT03060" value="${attrMap.ZAT03060}" class="text" maxLength="100" >
								</td>
							 	<th rowspan="2">${menu.ZLN0054}</th>
							 	<td class="alignL pdL10 pdR10 last">
									<input type="text" id="ZAT03140" name="ZAT03140" value="${attrMap.ZAT03140}" class="text" maxLength="100" disabled >
								</td>
							 	<td class="alignL pdL10 pdR10" >
							 		<input type="text" id="ZAT03130" name="ZAT03130" value="${attrMap.ZAT03140}" class="text" maxLength="100" disabled >
								</td>
							 </tr>
					
							<!-- 기인 (공정) / 조치일시 / 보류 / 발생량 / 단위  -->
							 <tr>
							 	<th rowspan="3">${menu.ZLN0061}</th>
							 	<th>${menu.ZLN0044}</th>
							 	<td colspan="2" class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03070" name="ZAT03070" value="${attrMap.ZAT03070}" class="text" maxLength="100" disabled >
								</td>
						    	<th>${menu.ZLN0049}</th>
						    	<td colspan="2">
									<input type="text" id="ZAT03110" name="ZAT03110" value="${attrMap.ZAT03110}"	class="alignC input_off datePicker stext" size="8"
										style="width: calc(60% - 6px); background: #fafafa !important;" onchange="this.value = makeDateType(this.value);" maxlength="10" disabled >
									
									<input name="ZAT03240" id="ZAT03240" value="${attrMap.ZAT03240}" class="alignC timePicker stext" style="width: 60px;" disabled >
				   				</td>
						    	<td class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03150" name="ZAT03150" value="${attrMap.ZAT03150}" class="text" maxLength="100" disabled >
								</td>
						    	<td class="alignC pdL10 pdR10" >
								    <input type="text" id="ZAT03131" name="ZAT03131" value="${attrMap.ZAT03131}" class="text" maxLength="100" disabled >
								</td>
							 </tr>
							 
							 <!-- 기인 (기구부) / 재가동일시 / 폐기 / 발생량 / 단위  -->
							 <tr>
							 	<th>${menu.ZLN0046}</th>
							 	<td colspan="2" class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03080" name="ZAT03080" value="${attrMap.ZAT03080}" class="text" maxLength="100" disabled >
								</td>
						    	<th>${menu.ZLN0050}</th>
						    	<td colspan="2">
									<input type="text" id="ZAT03120" name="ZAT03120" value="${attrMap.ZAT03120}"	class="alignC input_off datePicker stext" size="8"
										style="width: calc(60% - 6px); background: #fafafa !important;" onchange="this.value = makeDateType(this.value);" maxlength="10" disabled >
									
									<input name="ZAT03250" id="ZAT03250" value="${attrMap.ZAT03250}" class="alignC timePicker stext" style="width: 60px;" disabled >
				   				</td>
						    	<th rowspan="2">${menu.ZLN0055}</th>
						    	<td class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03160" name="ZAT03160" value="${attrMap.ZAT03160}" class="text" maxLength="100" disabled >
								</td>
						    	<td class="alignC pdL10 pdR10" >
								   	<input type="text" id="ZAT03132" name="ZAT03132" value="${attrMap.ZAT03132}" class="text" maxLength="100" disabled >
								</td>
						    	
							 </tr>
							 
							 <!-- 기인 (원인) / 폐기 / 발생량 / 단위  -->
							 <tr>
							 	<th>${menu.ZLN0047}</th>
							 	<td style="" class="alignC pdL10 pdR10" >
							 		<input type="checkbox" name="ZAT03090" id="ZLV309001" value="ZLV309001" disabled >
									<label for="ZLV309001" class="mgR10">${menu.ZLN0062}</label>
								</td>
								<td style="" class="alignC pdL10 pdR10" >
									<input type="checkbox" name="ZAT03090" id="ZLV309002" value="ZLV309002" disabled >
									<label for="ZLV309002" class="mgR10">${menu.ZLN0063}</label>
								</td>
								<td style="" class="alignC pdL10 pdR10" >
									<input type="checkbox" name="ZAT03090" id="ZLV309003" value="ZLV309003" disabled >
									<label for="ZLV309003" class="mgR10">${menu.ZLN0064}</label>
								</td>
								<td style="" class="alignC pdL10 pdR10" >
									<input type="checkbox" name="ZAT03090" id="ZLV309004" value="ZLV309004" disabled >
									<label for="ZLV309004" class="mgR10">${menu.ZLN0065}</label>
								</td>
								<td style="" class="alignC pdL10 pdR10" >
									<input type="checkbox" name="ZAT03090" id="ZLV309005" value="ZLV309005" disabled >
									<label for="ZLV309005" class="mgR10">${menu.ZLN0066}</label>
								</td>
						    	<td class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03170" name="ZAT03170" value="${attrMap.ZAT03170}" class="text" maxLength="100" disabled >
								</td>
								<td class="alignC pdL10 pdR10 last">
									<input type="text" id="ZAT03133" name="ZAT03133" value="${attrMap.ZAT03133}" class="text" maxLength="100" disabled >
								</td>
							 </tr>
							<!-- 2.현상 (사진 또는 도면, 설명도) -->	
							<tr>
								<th colspan="10" class="alignL pdL10 last">2. ${menu.ZLN0057} (${menu.ZLN0147})</th>
							</tr>
							<tr>	
								<td class="alignL" colspan="10">
									<textarea class="tinymceText" id="ZAT03180" name="ZAT03180" style="width: 100%; height: 150px;">${attrMap.ZAT03180}</textarea>
								</td>		
							</tr>
							
							<!-- 첨부문서 -->	
							<tr>
								<th>${menu.LN00019}</th>
								<td class="alignL pdL10 alignt" colspan="9"
									style="width: 100%; height: 200px;"><span id="viewFile"
									class="btn_pack medium icon"><span class="upload"></span>
										<input value="Attach" type="submit" onclick="doAttachFileV4()"
										style="margin-bottom: 5%;"></span>
									<div class="tmp_file_wrapper mgT15" style="display: none;">
										<table id="tmp_file_items" name="tmp_file_items" width="100%">
											<colgroup>
												<col width="40px">
												<col width="">
												<col width="70px">
											</colgroup>
											<thead>
												<tr class="header-row">
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
		var data="scrnType=CS&fltpCode=FLTP012";
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
