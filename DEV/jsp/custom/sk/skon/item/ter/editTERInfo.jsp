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
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>


<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00187" var="WM00187"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00001"  arguments="${menu.ZLN0151}"/>
<!--<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT01080"  arguments="${menu.ZLN0037}"/>  Site -->
<!-- <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03260"  arguments="${menu.ZLN0044}"/> -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT04006"  arguments="${menu.ZLN0157}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT04003"  arguments="${menu.ZLN0152}"/>

<head>
<style>

	.noticeTab02{margin-top:-15px;}
	.noticeTab02 > input{display:none;}
	.noticeTab02 > label{display:inline-block;margin:0 0 -1px; padding:15px 0; font-weight:700;text-align:center;color:#999999;width:62px;}
	.noticeTab02 > section {display: none;padding: 20px 0 0;}
	.noticeTab02 > input:checked+label{color:#333333;border-bottom:3px solid #008bd5;}

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
	
	/*  스크롤바  */
	html, body {
	  height: 100%;
	  overflow-y: auto; 
	}
	
	iframe, textarea {
	  overflow-y: scroll; 
	}
	
	#ZAT04003, #ZAT04006{
		width:100%;
	}
	
	.info{
		  width: 10px;              
		  height: 10px;
		  background-image: "/cmm/sf/images/img_count.png"; 
		  background-repeat: no-repeat; 
		  background-position: center;   
		  background-size: 18px 18px;    
		  border: none;
		  background-color: transparent;
		  cursor: pointer;
	}
    

</style>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
	var isWf = "";
	var checkOutFlag = "N";
	var delList = [];
	let attrTypeCodeList="";
	getSKONAttr();
	
	getFileList();
	
		$(document).ready(function(){
			$("input:checkbox:not(:checked)").each(function(){
				$("#"+$(this).attr("name")).css('display','none');
			});
			
			$("input.datePicker").each(generateDatePicker);

			
			let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
					
			$('.popup_closeBtn').click(function(){
				layerWindow.removeClass('open');
			});
			
			//updateCheckboxes();
			//getLevelName(2, "L2Name");
			
			
			$('#ZAT04003').SumoSelect({
			  placeholder: 'Select',
			  okCancelInMulti: true,
			  csvDispCount: 2,
			  maxHeight: 200,
			  forceCustomRendering: true,
			  parentWidth: 90
			});
			
			$('#ZAT04006').SumoSelect({
			  placeholder: 'Select',
			  okCancelInMulti: true,
			  csvDispCount: 2,
			  maxHeight: 200,
			  forceCustomRendering: true,
			  parentWidth: 90
			});
			 
	
		});
		
	//    function updateCheckboxes() {     
	//         var mlovValueName = "${attrMap.ZAT03090}".split("/").map(function(value) {
	//         	return value.trim();  
	//       	});
	        
	//         var checkboxes = document.querySelectorAll('input[type="checkbox"][name="ZAT03090"]');
	        
	//         checkboxes.forEach(function(checkbox) {
	//             var label = document.querySelector('label[for="' + checkbox.id + '"]');
	//             if (!label) return;
	
	//             var labelText = label.innerText.trim();
	
	//             if (mlovValueName.includes(labelText)) {
	//                 checkbox.checked = true;
	//             } else {
	//                 checkbox.checked = false;
	//             }
	//         });  	 
	// 	}
   	
 	// 콜백 
	function fnEditItemInfo(itemID) {
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/ter/editTERInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defDimValueID ="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"; 

		var target = "editItemInfo";
		ajaxPage(url, data, target); 
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
// 	function modelView(){
// 		var browserType="";
		
// 		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
// 		if(IS_IE11){browserType="IE11";}
// 		var url = "newDiagramViewer.do";
// 		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
// 					+"&s_itemID=${itemID}"
// 					+"&width="+$("#model2").width()
// 					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
// 					+"&userID=${sessionScope.loginInfo.sessionUserId}"
// 					+"&varFilter=${revViewOption}"
// 					+"&displayRightBar=none";
// 		var src = url +"?" + data+"&browserType="+browserType;
//  		document.getElementById('model2').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
// 		$("#model2").attr("style", "display:block;height:600px;border: 0;");
// 	}
	
	// Model 팝업
// 	function clickModelEvent(trObj) {
// 		var url = "popupMasterMdlEdt.do?"
// 				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
//  				+"&s_itemID=${itemID}"
// 				+"&modelID="+$(trObj).find("#ModelID").text()
// 				+"&scrnType=view"
//  				+"&MTCategory="+$(trObj).find("#MTCategory").text()
// 				+"&modelName="+encodeURIComponent($(trObj).find("#ModelName").text())
// 			    +"&modelTypeName="+encodeURIComponent($(trObj).find("#modelTypeName").text())
// 				+"&menuUrl="+$(trObj).find("#ModelURL").text()
// 				+"&changeSetID="+$(trObj).find("#ModelCSID").text()
// 				+"&selectedTreeID=${itemID}";
// 		var w = 1200;
// 		var h = 900;
// 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
// 	}
	
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
	

	function getMultiSelectValues(attrTypeCode) {
	    return $('#' + attrTypeCode).val() || [];  
	}
		
	//저장
	function saveObjInfoMain(){	
		if(setAllCondition()) {
			if(confirm("${CM00001}")){
				const filteredAttrTypeCodeList = attrTypeCodeList.filter(code => code !== 'ZAT04003' && code !== 'ZAT04006');				
				var attrTypeCodesInput = document.createElement('input');
				attrTypeCodesInput.type = 'hidden';
				attrTypeCodesInput.name = 'attrTypeCodes'; 
				attrTypeCodesInput.value = filteredAttrTypeCodeList.join(','); 
				
				// 문서목적 
				const selectedZAT04003s = getMultiSelectValues("ZAT04003");
				if (selectedZAT04003s.length > 0) {
					attrTypeCodesInput.value += ',ZAT04003:' + selectedZAT04003s.join('$$');
				}

				// 적용모델 
				const selectedZAT04006s = getMultiSelectValues("ZAT04006");
				if (selectedZAT04006s.length > 0) {
					attrTypeCodesInput.value += ',ZAT04006:' + selectedZAT04006s.join('$$');
				}
				
				var frm = document.getElementById('editFrm');	 
				frm.appendChild(attrTypeCodesInput);
 
				var url = "zskon_saveItemInfo.do";
				inProgress = true;
	            $('#loading').fadeIn(150);
	            
				ajaxSubmitNoAdd(frm, url);
			}
		}
	}
	
	
	
	/* // callback - deleteFileFromLst
	function doSearchList() {
		
	} */

	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&hiddenClassList='CL05003','CL16004'"; 

		fnOpenLayerPopup(url,data,doCallBackItem,617,436);
	}
	
// 	function doCallBackItem() {
		
// 	}
	
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
	
// 	function fnRefreshTree(itemId,isReload){ 

// 	}

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
 				+"&itemViewPage=custom/sk/skon/item/ter/viewTERInfo&screenMode=pop&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	
	// callback 상세 조회
	function fnItemMenuReload() {
		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/ter/viewTERInfo"
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
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm,url, "saveFrame");
		}
	}
	
	function fnRefreshPage(option, itemID,scrnMode){
		var url = "zSKON_ProcessItemInfo.do";
		var data = "&itemEditPage=custom/sk/skon/item/ter/editTERInfo&accMode=DEV&scrnMode=N&option=${option}";	
		var target = "m";
		ajaxPage(url, data, target);
		
	}
	
	// 관리부서 지정 시 사용 >> SKON 미사용
	function fnGoOrgTreePop(){
		var url = "orgTeamTreePop.do";
		var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}&option=NoP";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
// 	function fnTeamRoleCallBack(){
// 	}
	
	function doCallBack(){}

	function fnSaveTeamRole(teamIDs,teamNames){
		$("#orgNames").val(teamNames);
		$("#orgTeamIDs").val(teamIDs);
	}
	
	function goView(itemID){
		var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/ter/viewTERInfo"
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
	 	if ($("#AT00001").val() == "" ) { 
			alert("${WM00034_AT00001}");		// 문서명을 입력하여 주십시오.
			return false;
		}
		if (${empty attrMap.ZAT04006}) {
		    alert("${WM00034_ZAT04006}"); // Model을 입력하여 주십시오.
		    return false;
		}
	
		if (${empty attrMap.ZAT04003}) { 
		    alert("${WM00034_ZAT04003}"); // 문서 목적을 입력하여 주십시오.
		    return false;
		}
		
		return true; 
	}
	
	async function getAttrLovList(attrTypeCode, selectedValues){		
		let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+"&sqlID=attr_SQL.selectAttrLovOption"
							+"&attrTypeCode="+attrTypeCode;
		
		fetch("/olmapi/getLovValue/?"+param)	
		.then(res => res.json())
		.then(res => {
			let lovHtml = "";
			lovHtml += "<option value=''>Select</option>"
			for(var i=0; i < res.data.length; i++) {
				const code = res.data[i].CODE;
				const name = res.data[i].NAME;
				
				let selected = "";

				if (Array.isArray(selectedValues)) {
					if (selectedValues.includes(code)) {
						selected = " selected";
					}
				} else if (selectedValues === code) {
					selected = " selected";
				}

				lovHtml += '<option value="' + code + '"' + selected + '>' + name + '</option>';
			}
			
			const selectEl = document.querySelector("#" + attrTypeCode);
			selectEl.innerHTML = lovHtml;
			
			if (selectEl.sumo) {
				selectEl.sumo.unload(); // 제거
			}

			$('#' + attrTypeCode).SumoSelect({
				placeholder: 'Select',
				okCancelInMulti: true,
				csvDispCount: 2,
				maxHeight: 200,
				forceCustomRendering: true,
				parentWidth: 90
			});
			
		});
	}

	

	/**** 결재 관련*** */
	// 기존 check in 실행 함수 	
// 	function fnEditChangeSetClsMn(){
// 		var url = "editItemChangeInfo.do"
// 		var data = "?changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
// 			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
// 			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
// 			+ "&isItemInfo=Y&screenMode=edit"
// 			+ "&isMyTask=Y&scrnType=${scrnType}"
// 			+ "&checkInOption=${itemInfo.CheckInOption}";
// 		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
// 	}
	
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
	
	// [Check in] COMPLETE 03A Click 
		function fnCheckInItem() {
		
		//  첨부파일 체크 - 메세지 프로퍼티스 필요
		fetch("/getFileCount.do?changeSetID=${itemInfo.CurChangeSet}&docCategory=ITM")
		.then((res) => res.json())
		.then((data) => {
			var status = "${itemInfo.Status}";			 
			if(status != "DEL1"){
				if(data.count == "0") {
					alert("${WM00187}");	// 문서를 첨부하여 주십시오.
					return false;
				}else {
				
					if (${empty attrMap.ZAT04006}) {
					    alert("${WM00034_ZAT04006}"); // Model 을 입력하여 주십시오.
					    return false;
					}
					 
					else if (${empty attrMap.ZAT04003}) { 
					    alert("${WM00034_ZAT04003}"); // 문서 목적을 입력하여 주십시오.
					    return false;
					}
					else if (${empty attrMap.AT00001}) {
					    alert("${WM00034_AT00001}"); // 보고제목을 입력하여 주십시오.
					    return false;
					}
					else  {
						
					 	dhtmlx.confirm({
							ok: "Yes", cancel: "No",
							text: "${CM00042}",
							width: "310px",
							callback: function(result){
								if(result){
									var items = "${itemID}";
									var cngts = "${itemInfo.CurChangeSet}";
									var pjtIds = "${itemInfo.ProjectID}";
									var url = "checkInMgt.do";
									var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
									var target = "saveFrame";
									ajaxPage(url, data, target);
									}
								}		
							}); 
						}
				}
			}

			if(status == "DEL1"){				
					dhtmlx.confirm({
						ok: "Yes", cancel: "No",
						text: "${CM00042}",
						width: "310px",
						callback: function(result){
							if(result){
								var items = "${itemID}";
								var cngts = "${itemInfo.CurChangeSet}";
								var pjtIds = "${itemInfo.ProjectID}";
								var url = "checkInMgt.do";
								var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
								var target = "saveFrame";
								ajaxPage(url, data, target);
							}
						}		
				});				
			}

		});
	}
	
	
	// 01 Check In 함수
// 	function fnEditChangeSetClsMn() {
// 		//  첨부파일 체크 - 메세지 프로퍼티스 필요
// 		fetch("/getFileCount.do?changeSetID=${itemInfo.CurChangeSet}&docCategory=ITM")
// 		.then((res) => res.json())
// 		.then((data) => {
// 			var status = "${itemInfo.Status}";
// 			if (status !== "DEL1" && data.count == "0") {
// 				alert("${WM00187}"); // 문서를 첨부하여 주십시오.
// 				return;
// 			}
// 			else {
// 				if (${empty attrMap.ZAT04006}) {
// 					alert("${WM00034_ZAT04006}"); // Model을 입력하여 주십시오.
// 					return;
// 				}
// 				if (${empty attrMap.ZAT04003}) {
// 					alert("${WM00034_ZAT04003}"); // 문서 목적을 입력하여 주십시오.
// 					return;
// 				}
// 				if (${empty attrMap.AT00001}) {
// 					alert("${WM00034_AT00001}"); // 보고제목을 입력하여 주십시오.
// 					return;
// 				}

// 				var url = "editItemChangeInfo.do";
// 				var data = "?changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
// 					+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
// 					+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
// 					+ "&isItemInfo=Y&screenMode=edit"
// 					+ "&isMyTask=Y&scrnType=${scrnType}"
// 					+ "&checkInOption=${itemInfo.CheckInOption}";

// 				window.open(url + data, '', 'width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
// 			}
// 		});
// 	}

	
	//check in 후 콜백 
	function fnCallBack(checkInOption){
		if(checkInOption == "03" || checkInOption == "03A" || checkInOption == "03B"){

			//dhtmlx.confirm({
			//	ok: "Yes", cancel: "No",
			//	text: "${CM00061}",
			//	width: "310px",
			//	callback: function(result){					
			//		if(result){
						goApprovalPop();
			//		}
					fnItemMenuReload();	
			//	}		
			//});
		}else{
			
			fnItemMenuReload();	
		}
	}
	
	//complet check in 함수
	function goApprovalPop() {
		 var wfFrame = document.wfFrame;
		 var url = "${wfURL}.do";
		 window.open("" ,"${wfURL}", "width=1200, height=750, left=400, top=200"); 
		 wfFrame.action =url;
		 wfFrame.method="post";
		 wfFrame.target="${wfURL}";
		 wfFrame.isPop.value = "Y";
		 wfFrame.changeSetID.value = "${itemInfo.CurChangeSet}";
		 wfFrame.isMulti.value = "N";
		 wfFrame.wfInstanceID.value = "${itemInfo.WFInstanceID}";
		 wfFrame.wfDocType.value = "CS";
		 wfFrame.ProjectID.value = "${itemInfo.ProjectID}";
		 wfFrame.docSubClass.value = "${itemInfo.ClassCode}";
		 wfFrame.submit();
	}

	function fnViewReload() {
  		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/ter/viewTERInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
// 	function getLevelName(level, el) {
// 		fetch("getItemNameListByHier.do?level="+level+"&itemID=${itemID}&itemTypeCode=OJ00001&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
// 		.then(res => res.json())
// 		.then(data => document.getElementById(el).insertAdjacentHTML("beforeend", data.data.NAME));
// 	}
	
	function getSKONAttr() { //기존 속성값 가져오기
		fetch("/getSKONAttr.do?itemID=${itemID}&accMode=${accMode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(data => {
			console.log(data);
		attrTypeCodeList = data.list.map(item => item.AttrTypeCode); 
		
		let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
    
	    lovData = data.list.find(e => e.AttrTypeCode === "ZAT03260"); //공정(기술문서)
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03260'}">
					getAttrLovList("ZAT03260", lovInfo);
				</c:if>
			</c:forEach>
	    }
	    
		lovData = data.list.filter(e => e.AttrTypeCode === "ZAT04003");
		if (lovData && lovData.length > 0) {
			const selectedCodes = [...new Set(lovData.map(e => e.LovCode))]; 
			getAttrLovList("ZAT04003", selectedCodes);
		}
		
		lovData = data.list.filter(e => e.AttrTypeCode === "ZAT04006");
		if (lovData && lovData.length > 0) {
			const selectedCodes = [...new Set(lovData.map(e => e.LovCode))];
			getAttrLovList("ZAT04006", selectedCodes);
		}
	    
	    
	});
	}
	
	function goList(){
		var url = "zSKON_searchPrcList.do";
		var data = "&url=/custom/sk/skon/item/ter/searchTERList&defClassList=CL12007&screenOption=Y"
					+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
					
		ajaxPage(url, data, "editFrm");
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
				html += '<td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR20"';
				// html += ' onclick="fileNameClick('+data.data[i].Seq+')"'; // fileDownload 기능 주석처리
				html += '>';
				
				html += '<span class="';
				if(data.data[i].FileFormat.includes("doc")) html += 'doc';
				else if(data.data[i].FileFormat.includes("xl")) html += 'xls';
				else if(data.data[i].FileFormat.includes("pdf")) html += 'pdf';
				else if(data.data[i].FileFormat.includes("hw")) html += 'hwp'
				else if(data.data[i].FileFormat.includes("pp")) html += 'ppt';
				else html += "log";
				html += '"></span></span><span style="cursor:pointer;margin-left:10px;" '
					//html += onclick="fileNameClick('+data.data[i].Seq+');"  
				html +=	'>'+data.data[i].FileRealName+'</span>(<span id="fileSize">'+data.data[i].FileSize+'</span>)</td>';
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
	
	$.ajax({
        url: "/getItemCSInfo.do", 
        type: "GET",
        data: {
        	itemID: ${itemID},
        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
        },
        dataType: "json",
        success: function (response) {
        	csListData = response.list; 
        	updateCSTable();
        },
    });
	
	function updateCSTable() { //변경일자
		let tableContent = "";
		csListData.forEach((item) => {	    
	        if (item.ChangeStsCode !== 'MOD') {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickHistoryItemEvent('${"${item.ChangeSetID}"}','${"${item.ItemID}"}')">
	            	<td >${"${item.ChangeSts}"}</td> //구분
	            	<td >${"${item.Version}"}</td>   //개정번호
	            	<td >${"${item.RequestUserName}"}</td> //성명
	            	<td >${"${item.RequestUserTeamName}"}</td>  //부서
	            	<td >${"${item.RequestDate}"}</td> //변경일자
	            	<td >${"${item.Description}"}</td> //변경사유 
	            </tr>`;
	       }
	    });
	    $("#itemCSTable").html(tableContent);
	   } 
	
	
	function openImagePopup() {
	    fetch("/setPopupToken.do")
	      .then(() => {
	        let w = 1100, h = 700;
	        window.open("zSKON_TER2openImagePopup.do", "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	      });
	}
	
	
	</script>
</head>
<!-- BIGIN :: -->
<body>
<form name ="wfFrame" >
	<input type="hidden" id="isPop" name="isPop" value="">
	<input type="hidden" id="changeSetID" name="changeSetID" value="" />
	<input type="hidden" id="isMulti" name="isMulti" value="" />
	<input type="hidden" id="wfInstanceID" name="wfInstanceID" value="" />
	<input type="hidden" id="wfDocType" name="wfDocType" value="" />
	<input type="hidden" id="ProjectID" name="ProjectID" value="" />
	<input type="hidden" id="docSubClass" name="docSubClass" value="" />
</form>
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
<input type="hidden" id="defDimValueID" name="defDimValueID"  value="${defDimValueID}" />
<input type="hidden" id="curChangeSet" name="curChangeSet" value="${itemInfo.CurChangeSet}"/>
<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
<!-- <input type="hidden" id="ZAT04003" value="" /> -->
<!-- <input type="hidden" id="ZAT04006" value="" /> -->

	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<!-- 헤더부분  -->
		<div id="cont_HeaderItem" >	
		<div class="pdL10 pdT10 pdB10" id="titWrap" style="width:99%;">
			<ul style="display: inline-block;">
				<li>
				<div id="itemNameAndPath">					
				   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;">
						  	<font color="#3333FF"><b style="font-size:13px;">${itemInfo.Identifier}&nbsp;${itemInfo.ItemName}</b></font>&nbsp;						  		   	
							<c:forEach var="path" items="${itemPath}" varStatus="status">							
								<c:choose>
									<c:when test="${status.first}">(${path.PlainText}</c:when>
									<c:when test="${status.last}">>&nbsp;${path.PlainText})	</c:when>
									<c:otherwise>>&nbsp;${path.PlainText}</c:otherwise>
								</c:choose>	
							</c:forEach>		  
				</div>&nbsp;
				
			    <div id="functions">				 
				
					 <span class="btn_pack medium icon"><span class="pre"></span><input value="List" type="button" onclick="goList()"></span> 
						<!--<button class="cmm-btn mgR5" style="height: 30px; margin-left:1px;" onclick="goList()" value="List">List</button>	-->
					
					<c:if test="${accMode ne 'OPS'}" >			
				   		<!-- Check In  >> 결재상신  -->
						<c:if test="${itemInfo.Blocked ne '2' && (itemInfo.Status eq 'NEW1' || itemInfo.Status eq 'MOD1' || itemInfo.Status eq 'DEL1')}" >
						   		 <span class="btn_pack small icon"><span class="checkin"></span><input value="Approval Req." type="button" onclick="fnCheckInItem()"></span>
					   	</c:if>
					   	<!-- Check In  Only Check In Option = 01 , 02, 03 03B -->
						<!--<c:if test="${itemInfo.Blocked eq '0' && itemInfo.CheckInOption ne '03A' && itemInfo.CheckInOption ne '00'}" >
			   		 		<span class="btn_pack small icon"><span class="checkin"></span><input value="Check In" type="button" onclick="fnEditChangeSetClsMn()"></span>
				   		</c:if>	-->
					   	<!-- 변경 담당자   Rework -->				       
		                 <!-- CS 결재 상신 전인 경우 -->
		                <c:if test="${itemInfo.CSStatus == 'CMP'}" >
		                <!-- <button class="cmm-btn mgR5" style="height: 30px; margin-left:1px;" onclick="rework()" value="Rework">Rework</button>	-->
			              &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>  
		        		</c:if>	
		        		<!-- CS 결재반려된 경우 -->
		        		<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus != '0' && itemInfo.CSStatus == 'HOLD'}" >
		        		 <span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span> 
		        		  <!--  &nbsp;<button class="cmm-btn mgR5" style="height: 30px; margin-left:1px;" onclick="rework()" value="Rework">Rework</button>	-->
		        		</c:if> 
			        </c:if>
			    </div>&nbsp;
			   	</li>
			</ul>
			
			<c:if test="${sessionScope.loginInfo.sessionAuthLev eq '1'}" >
				<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
			</c:if> 
		</div>
	</div>
		
	<div id="menuDiv" style="margin:0 10px;">
		<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
		</div>
	</div>
			
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
	    					<%--<button class="cmm-btn floatL " style="height: 30px; margin-bottom:5px;margin-left:3px;"  value="Cancel" onClick="goView('${itemID}');">Cancel</button> --%>
	    			<c:if test="${itemInfo.Status ne 'DEL1' }" >
						 <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span> 
					</c:if>
				</div>		
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
				</colgroup>
				
				<!-- 문서번호 / Rev / 작성자 / 작성자 소속  -->
				<tr>
					<th class="last">${menu.ZLN0068}</th> <!-- 문서번호 -->
					<td colspan="1" class="alignL pdL10">${itemInfo.Identifier}</td>
					<th>${menu.ZLN0154}</th> <!-- Rev -->
					<td  class="alignL pdL10 pdR10 last" >	${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>  
					<th class="last">${menu.LN00060}</th> <!-- 작성자 -->	
				    <td class="alignL pdL10 pdR10 last">${itemInfo.AuthorName}</td> 
				    <th class="last">${menu.ZLN0155}</th> <!-- 작성자 소속 -->
				    <td class="alignL pdL10 pdR10 last">${itemInfo.OwnerTeamName}</td> 	
				</tr>
				
				<!-- Site / 공정 / 적용 모델 / 문서목적 -->
				<tr>
					<th class="last"><span style="color: red;">*</span>${menu.ZLN0037}</th>  <!-- Site -->
					<td class="alignL pdL10 pdR10 last">${dimResultMap.dimValueNames}</td> 
				    <th class="last"><span style="color: red;">*</span>${menu.ZLN0044}</th> <!-- 공정 -->
				   	<td class="alignL pdL10 pdR10 last">${attrMap.ZAT03260}</td> 	
				    <th class="last"><span style="color: red;">*</span>${menu.ZLN0157}</th> <!-- 적용 모델 -->
				   	<td class="alignL pdL10 pdR10 last">
				   		<select id="ZAT04006" name="ZAT04006"  multiple="multiple">
					    <option value="" selected></option>
					    </select>
				   	</td> 	
				    <th class="last">
				    	<span style="color: red;">*</span>${menu.ZLN0152}
				    	&nbsp;<span class="info"><input  type="submit" id="add" onClick="openImagePopup()"></span>
				    </th> <!-- 문서목적 -->	
				   	<td class="alignL pdL10 pdR10 last">
				   		<select id="ZAT04003" name="ZAT04003"  multiple="multiple">
					    <option value="" selected></option>
					    </select>
				   	</td> 
				</tr>
				
				<!-- 보고제목 -->	
				<tr>
					<th ><span style="color: red;">*</span>${menu.ZLN0151}</th>					
					<td colspan="3" class="alignL pdL10">
						<input type="text" id="AT00001" name="AT00001" value="${itemInfo.ItemName}" class="text" maxLength="100" >
<%-- 						<input type="text" id="AT00001" name="AT00001" value="${attrMap.AT00001}" class="text" maxLength="100" > --%>
					</td>
				</tr>
				
				<!-- 키워드 -->
				<tr>
					<th>${menu.ZLN0070}</th>
					<td class="alignL pdL10" colspan="10">
					<input type="text" id="AT01007" name="AT01007" value="${attrMap.AT01007}" class="text" maxLength="100" style="width: 100%;" >
					</td>
				</tr>
				 	
				<!-- 변경사유 -->
				<tr>
					<th>${menu.LN00023}</th>
					<td class="alignL pdL10" colspan="10">						
					<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;">${csInfo.Description}</textarea> 
					</td>						
				</tr>
					
				<!-- 첨부문서 -->		
				<tr>
					<th><span style="color: red;">*</span>${menu.LN00019}</th>
					<td class="alignL pdL10 alignT" colspan="9" style="width:100%;height:200px;" id="fileList">
				</tr>
			</table>
			
			
			<!-- 연관문서 -->
			<div class="align-center flex justify-between pdB5 pdL10 pdT15">
				<p class="cont_title">${menu.ZLN0086}</p>
				<div class="alignR">
					<c:if test="${itemInfo.Status ne 'DEL1' }" >
						<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="fncxnItemListPop('OJ00001')"></span>
						<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fncxnItemDelete('OJ00001')"></span>
					</c:if>
				</div>
			</div>		
			<div id="layout1" style="width: 100%; height:300px; margin-bottom: 30px;"></div>		
			
			<!-- 변경이력-->	
			<c:if test="${scrnType ne 'pop' }">
			<div id="history" class="mgB10">
		  		<p class="cont_title mgB10">${menu.LN00012}</p>
			    <div id="cxn">
			        <table class="tbl_preview mgB10">
			            <colgroup>
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
						</colgroup>
			            <thead>
			                <tr>
								<!-- 구분 / 개정번호 / 성명 / 부서 / 변경일자 / 변경사유 -->
								<th>${menu.LN00042}</th>
								<th>${menu.LN00356}</th>
								<th>${menu.ZLN0158}</th>
								<th>${menu.LN00104}</th>
								<th>${menu.ZLN0159}</th>
								<th>${menu.LN00023}</th>
			                </tr>
			            </thead>
			            <tbody id="itemCSTable">
			            </tbody>
			        </table>    
			    </div>    
			</div>
			</c:if>
			
	</div>
</div>
</div>
</div>
</form>

</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<form name ="uploadFrm" >
	<input type="hidden" id="id" name="id" value="">
	<input type="hidden" id="fltpCode" name="fltpCode" value="" />
	<input type="hidden" id="fileMgt" name="fileMgt" value="" />
	<input type="hidden" id="usrId" name="usrId" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="docCategory" name="docCategory" value="">
	<input type="hidden" id="changeSetID" name="changeSetID" value="">
	<input type="hidden" id="projectID" name="projectID" value="">
</form>
<form name ="cxnItemListMgt" >
	<input type="hidden" name="itemID" />
	<input type="hidden" name="classCodes" />
	<input type="hidden" name="itemTypeCode" />
	<input type="hidden" name="items" />
	<input type="hidden" name="initSearch" />
	<input type="hidden" name="callBackData" />
</form>

<script>
//***연관문서 시작**************************************************************************************************************************
let cxnItemList = "";

const layout1 = new dhx.Layout("layout1", {rows: [{id: "a" }]});

const grid1 = new dhx.Grid("", {
    columns: [
    	// No / 0 / 문서레벨 / 문서유형 / 문서경로 / 문서명 / 문서번호
        { hidden:true,width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk1(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
        { width: 100, id: "DocLevValue", header: [{ text: "${menu.ZLN0075}" , align: "center" }], align: "center" },
        { width: 100, id: "DocTypeValue", header: [{ text: "${menu.LN00091}" , align: "center" }], align: "center" },
        { width: 600, id: "path", header: [{ text: "${menu.LN00102}" , align: "center" }], align: "center" },
        { id: "ItemName", header: [{ text: "${menu.LN00101}" , align: "center" }], align: "left" },
        { width: 200, id: "Identifier", header: [{ text: "${menu.ZLN0068}" , align: "center"}], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
});
layout1.getCell("a").attach(grid1);

function fnMasterChk1(state) {
    event.stopPropagation();
    grid1.data.forEach(function(row) {
        grid1.data.update(row.id, {
            "checkbox": state
        })
    })
}

// 관련항목 팝업
	function clickItemEvent(row) {
	var url = "popupMasterItem.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&id="+row.ItemID
			+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
}



let classCode = "";
let CXNItemTypeCode = "";
let CXNClassCode = "";
let itemTypeCode = "";

function fncxnItemListPop(e){
	itemTypeCode = e;
	classCode = "CL01005,CL01005A,CL01006A,CL01006B,CL16004,CL07004" //사규추가
	
	 var popupForm = document.cxnItemListMgt;
	 var url = "zSKON_searchItemListPop.do";
	 window.open("" ,"zSKON_searchItemListPop", "width=1200, height=500, left=400, top=200"); 
	 popupForm.action =url; 
	 popupForm.method="post";
	 popupForm.target="zSKON_searchItemListPop";
	 popupForm.itemID.value = "${itemID}";
	 popupForm.classCodes.value = classCode;
	 popupForm.itemTypeCode.value = itemTypeCode;
	 popupForm.items.value = cxnItemList.map(e => e.ItemID).toString();
	 popupForm.initSearch.value = "N";
	 popupForm.callBackData.value = "ALL";
	 popupForm.submit();
}

function setCheckedItems(checkedItems) { //기술문서 CN 3개 (Process,Tsd,사규)
	itemTypeCode = [...new Set(checkedItems.map(e => e.ItemTypeCode))][0];
		
	if(itemTypeCode === "OJ00001") {
		CXNItemTypeCode = "CN01201";
		CXNClassCode = "CNL1201";
	}
	if(itemTypeCode === "OJ00016") {
		CXNItemTypeCode = "CN01216";
		CXNClassCode = "CNL1216";
	}
	if(itemTypeCode === "OJ00007") { 
		CXNItemTypeCode = "CN01207";
		CXNClassCode = "CNL1207";
	}
		
	var url = "createCxnItem.do";
	var data = "s_itemID=${itemID}&cxnItemType="+CXNItemTypeCode+"&cxnTypeCode="+CXNItemTypeCode+"&items="+checkedItems.map(e => e.ItemID).toString()+"&cxnClassCode="+CXNClassCode;
	var target = "blankFrame";
	ajaxPage(url, data, target);
}

// callback - createCxnItem.do
function thisReload() {
	getCxnItemList();
}

// 기등록된 연관항목
function getCxnItemList() {
	if(itemTypeCode === "OJ00001" || itemTypeCode === "OJ00016" || itemTypeCode === "OJ00007") {
		CXNItemTypeCode = "'CN01201','CN01216','CN01207'";
	}
	
	fetch("/zSKON_cxnItemList.do?itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cxnTypeList="+CXNItemTypeCode)
	.then((res) => res.json())
	.then((data) => {
		data.list.map(e => delete e.id);
		grid1.data.parse(data.list.filter(e => e.ItemTypeCode == "OJ00001" || e.ItemTypeCode == "OJ00016" || e.ItemTypeCode == "OJ00007"));
		
		cxnItemList = data.list;
	});
	
}

// 연관항목 삭제
function fncxnItemDelete(itemTypeCode) {
	var selectedCell = "";
	if(itemTypeCode === "OJ00001") {
		selectedCell = grid1.data.getRawData().filter(e => e.checkbox);
		for(idx in selectedCell){
			grid1.data.remove(selectedCell[idx].id);
		};
	}
	
	if(!selectedCell.length){
		alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
	}else{
		if (confirm("${CM00004}")) {
			
			var items = new Array();	
			for(idx in selectedCell){
				items.push(selectedCell[idx].ItemID);
				var findIndex = cxnItemList.findIndex(e => e.s_itemID == selectedCell[idx].ItemID);
				cxnItemList.splice(findIndex,1);
			};
							
			if (items != "") {
				var url = "DELCNItems.do"; 
				var data = "&s_itemID=${itemID}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
}

getCxnItemList();

//------------------------------------------------------------------------------------------------------------------------------------
	//첨부파일 시작
	let type = "";
	let fltpCode = "";
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(e){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		type = e;
		if(type === "ITM") fltpCode = "FLTP001"; //기술문서 FLTP로 따로 뺼지 고민해보기
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

		if(type == "ITM") {
			$("#id").val("${itemID}");
			$("#fltpCode").val("FLTP001");
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
	