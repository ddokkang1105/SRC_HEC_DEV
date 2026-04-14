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

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>


<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00187" var="WM00187"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03220" arguments="${menu.ZLN0035}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00024" arguments="${menu.ZLN0036}"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT09006" arguments="${menu.ZLN0038}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03020" arguments="${menu.ZLN0039}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT09005" arguments="${menu.ZLN0040}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03030" arguments="${menu.ZLN0041}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03040" arguments="${menu.ZLN0042}"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03050" arguments="${menu.ZLN0043}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03060" arguments="${menu.ZLN0045}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03070" arguments="${menu.ZLN0043}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03080" arguments="${menu.ZLN0046}"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03140" arguments="${menu.ZLN0052}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03150" arguments="${menu.ZLN0052}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03160" arguments="${menu.ZLN0052}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03170" arguments="${menu.ZLN0052}"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03180" arguments="${menu.ZLN0057}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03190" arguments="${menu.ZLN0058}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03200" arguments="${menu.ZLN0059}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_ZAT03210" arguments="${menu.ZLN0060}"/>
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
		$('#ZAT03230, #ZAT03240, #ZAT03250').timepicker({
            timeFormat: 'H:i',
            minTime : '00:00am',
            maxTime : '11:59pm',
        });
		
		let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		updateCheckboxes();
		getLevelName(2, "L2Name");
		 

	});
	
   function updateCheckboxes() {     
        var mlovValueName = "${attrMap.ZAT03090}".split("/").map(function(value) {
        	return value.trim();  
      	});
        
        var checkboxes = document.querySelectorAll('input[type="checkbox"][name="ZAT03090"]');
        
        checkboxes.forEach(function(checkbox) {
            var label = document.querySelector('label[for="' + checkbox.id + '"]');
            if (!label) return;

            var labelText = label.innerText.trim();

            if (mlovValueName.includes(labelText)) {
                checkbox.checked = true;
            } else {
                checkbox.checked = false;
            }
        });  	 
	}
   	
 	// 콜백 
	function fnEditItemInfo(itemID) {
	
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/mtr/editMTRInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defDimValueID ="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"; 

		var target = "editItemInfo";
		ajaxPage(url, data, target); 
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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

		if(setAllCondition()) {
			if(confirm("${CM00001}")){
				
				const filteredAttrTypeCodeList = attrTypeCodeList.filter(code => code !== 'ZAT03090');
				
				var attrTypeCodesInput = document.createElement('input');
				attrTypeCodesInput.type = 'hidden';
				attrTypeCodesInput.name = 'attrTypeCodes'; 
				attrTypeCodesInput.value = filteredAttrTypeCodeList.join(','); 
			
				
	            var selectedZAT03090s = checkZAT03090();
	            if (selectedZAT03090s.length > 0) {
	                attrTypeCodesInput.value += ',ZAT03090:' + selectedZAT03090s.join('$$');
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
 				+"&itemViewPage=custom/sk/skon/item/mtr/viewMTRInfo&screenMode=pop&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	
	// callback TSD 상세 조회
	function fnItemMenuReload() {

	  //  url = "zSKON_searchTsdItemList.do";
	  //	data = "s_itemID=103109&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&screenOption=Y";

		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/mtr/viewMTRInfo"
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
		var data = "&itemEditPage=custom/sk/skon/item/mtr/editMTRInfo&accMode=DEV&scrnMode=N&option=${option}";	
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
			+"&url=/custom/sk/skon/item/mtr/viewMTRInfo"
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
		/* if ($("#AT00001").val() == "" ) { 
			alert("문서명을 입력하여 주십시오.");
			return false;
		} */
		return true;
	}
	
	function getAttrLovList(avg, avg2, avg3){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "Select";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}

	 
	// 체크된 기인 - 원인 코드 찾기 
	function checkZAT03090() {
	    let ZAT03090s = document.querySelectorAll('input[type="checkbox"][name="ZAT03090"]:checked');
	    let values = [];  

	    ZAT03090s.forEach(function(checkbox) {
	    	values.push(checkbox.value);
	    });
	    
	    return values;  
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
	
	// [Check in] COMPLETE 03A Click 
		function fnCheckInItem() {
		
		//  첨부파일 체크
		fetch("/getFileCount.do?changeSetID=${itemInfo.CurChangeSet}&docCategory=ITM")
		.then((res) => res.json())
		.then((data) => {
			var status = "${itemInfo.Status}";			 
			if(status != "DEL1"){
				 if (${empty attrMap.ZAT03220}) {
				    alert("${WM00034_ZAT03220}"); // 작성자(검출)을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.AT00024}) { 
				    alert("${WM00034_AT00024}"); // 작성자(기인)을 입력하여 주십시오.
				    return false;
				}
				
				//
				
				else if (${empty attrMap.ZAT09006}) {
				    alert("${WM00034_ZAT09006}"); // Line을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03020}) {
				    alert("${WM00034_ZAT03020}"); // 호기를 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT09005}) {
				    alert("${WM00034_ZAT09005}"); // Model 을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03030}) {
				    alert("${WM00034_ZAT03030}"); // 불량위치를 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03040}) {
				    alert("${WM00034_ZAT03040}"); // 세부현상을 입력하여 주십시오.
				    return false;
				}
				
				//
				
				else if (${empty attrMap.ZAT03050}) {
				    alert("${WM00034_ZAT03050}"); // 공정을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03060}) {
				    alert("${WM00034_ZAT03060}"); // 방법을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03070}) {
				    alert("${WM00034_ZAT03070}"); // 공정을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03080}) {
				    alert("${WM00034_ZAT03080}"); // 기구부를 입력하여 주십시오.
				    return false;
				}
				
				//
				
				else if (${empty attrMap.ZAT03140}) {
				    alert("${WM00034_ZAT03140}"); // 발생량을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03150}) {
				    alert("${WM00034_ZAT03150}"); // 발생량을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03160}) {
				    alert("${WM00034_ZAT03160}"); // 발생량을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03170}) {
				    alert("${WM00034_ZAT03170}"); // 발생량을 입력하여 주십시오.
				    return false;
				}
				
				//
				
				else if (${empty attrMap.ZAT03180}) {
				    alert("${WM00034_ZAT03180}"); // 현상을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03190}) {
				    alert("${WM00034_ZAT03190}"); // 조치내용을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03200}) {
				    alert("${WM00034_ZAT03200}"); // 원인 및 재발방지대책을 입력하여 주십시오.
				    return false;
				}
				
				else if (${empty attrMap.ZAT03210}) {
				    alert("${WM00034_ZAT03210}"); // 이상품 처리방안 (Risk 범위산정 및 검증)을 입력하여 주십시오.
				    return false;
				}
				
				//

				else  {
				    dhx.confirm({
				        text: "${CM00042}",
				        buttons: ["No", "Yes"],
				        css: "align-center"
				    }).then(function (result) {
				    	if(result){
				    		var items = "${itemID}";
							var cngts = "${itemInfo.CurChangeSet}";
							var pjtIds = "${itemInfo.ProjectID}";
							var url = "checkInMgt.do";
							var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
							var target = "saveFrame";
							ajaxPage(url, data, target);
						}
				    });
				}
			}

			if(status == "DEL1"){					
			    dhx.confirm({
			        text: "${CM00042}",
			        buttons: ["No", "Yes"],
			        css: "align-center"
			    }).then(function (result) {
			    	if(result){
			    		var items = "${itemID}";
						var cngts = "${itemInfo.CurChangeSet}";
						var pjtIds = "${itemInfo.ProjectID}";
						var url = "checkInMgt.do";
						var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
						var target = "saveFrame";
						ajaxPage(url, data, target);
					}
			    });
			}

		});
	}
	
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
		
		
// 		var url = "wfDocMgt.do?";
// 		//var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfDocType=CS";
// 		var data="isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&docSubClass=${itemInfo.ClassCode}";
// 		var w = 1200;
// 		var h = 750; 
// 		itmInfoPopup(url+data,w,h);

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
			+"&url=/custom/sk/skon/item/mtr/viewMTRInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	function getLevelName(level, el) {
		fetch("getItemNameListByHier.do?level="+level+"&itemID=${itemID}&itemTypeCode=OJ00001&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(data => document.getElementById(el).insertAdjacentHTML("beforeend", data.data.NAME));
	}
	
	function getSKONAttr() {
		
		fetch("/getSKONAttr.do?itemID=${itemID}&accMode=${accMode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(data => {
		attrTypeCodeList = data.list.map(item => item.AttrTypeCode); 
		
		let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
	   	lovData = data.list.find(e => e.AttrTypeCode === "ZAT03011");
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03011'}">
					const zat03010Value = document.getElementById("ZAT03010").value;
					getAttrLovList("ZAT03011", lovInfo);
				</c:if>
			</c:forEach>
	    }
	    
	    lovData = data.list.find(e => e.AttrTypeCode === "ZAT03130");
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03130'}">
					getAttrLovList("ZAT03130", lovInfo);
				</c:if>
			</c:forEach>
	    }
	    
	    lovData = data.list.find(e => e.AttrTypeCode === "ZAT03131");
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03131'}">
					getAttrLovList("ZAT03131", lovInfo);
				</c:if>
			</c:forEach>
	    }
	    
	    lovData = data.list.find(e => e.AttrTypeCode === "ZAT03132");
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03132'}">
					getAttrLovList("ZAT03132", lovInfo);
				</c:if>
			</c:forEach>
	    }
	    
	    lovData = data.list.find(e => e.AttrTypeCode === "ZAT03133");
	    if (lovData) {
	    	lovInfo = lovData.LovCode;

		    <c:forEach var="i" items="${attrList}">
				<c:if test="${i.AttrTypeCode eq 'ZAT03133'}">
					getAttrLovList("ZAT03133", lovInfo);
				</c:if>
			</c:forEach>
	    }
	});
	}
	
	function goList(){
		var url = "zSKON_searchPrcList.do";
		var data = "&url=/custom/sk/skon/item/mtr/searchMTRList&defClassList=CL12003&screenOption=Y"
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
<input type="hidden" id="scrnMode" name="scrnMode" value="E" />
<input type="hidden" id="defDimValueID" name="defDimValueID"  value="${defDimValueID}" />
<input type="hidden" id="curChangeSet" name="curChangeSet" value="${itemInfo.CurChangeSet}"/>
<input type="hidden" id="ZAT03011_VAL" value="${attrMap.ZAT03011}" />
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
						   <!--	<button class="cmm-btn mgR5" style="height: 30px; margin-left:1px;" onclick="fnCheckInItem()" value="Approval Req.">Approval Req.</button> -->	
					   	</c:if>
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
					<td  colspan="3" class="alignL pdL10 pdR10 last" >	${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>  
				</tr>
				
				<!-- 불량등급 / 불량유형 / 작성자(검출) / 작성자(기인)  -->
				<tr>
					<th class="last">${menu.ZLN0033}</th>
					<td id="ZAT03010" colspan="2" class="alignL pdL10 pdR10 last">${attrMap.ZAT03010}</td> <!-- 불량등급 -->
					<th class="last">${menu.ZLN0034}</th>
					<td colspan="2" class="alignL pdL10" >
					    <select id="ZAT03011" name="ZAT03011" class="sel">
					    <option value="" selected></option>
					    </select>							    
					</td>
					<th class="last">${menu.ZLN0035}</th>
				    <td class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03220" name="ZAT03220" value="${attrMap.ZAT03220}" class="text" maxLength="100" >
					</td>
				    <th class="last">${menu.ZLN0036}</th>
				    <td class="alignL pdL10 pdR10 last">
						<input type="text" id="AT00024" name="AT00024" value="${attrMap.AT00024}" class="text" maxLength="100" >
					</td>
				</tr>
				
				<!-- 1.개요 -->	
				<tr>
					<th colspan="10" class="alignL pdL10 last">1. ${menu.LN00035}</th>
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
				
				<!-- Site / Line / 호기 / Model / 불량위치 / 세부현상 -->
				<tr>
				   	<td class="alignL pdL10 pdR10 last">${dimResultMap.dimValueNames}</td> <!-- Site -->
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
						<input type="text" id="ZAT03030" name="ZAT03030" value="${attrMap.ZAT03030}" class="text" maxLength="100" >
					</td> <!-- 세부현상 -->	
					<td colspan="3" class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03040" name="ZAT03040" value="${attrMap.ZAT03040}" class="text" maxLength="100" >
					</td> <!-- 발생강도 -->	 	
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
						<input type="text" id="ZAT03140" name="ZAT03140" value="${attrMap.ZAT03140}" class="text" maxLength="100" >
					</td>
				 	<td class="alignL pdL10 pdR10" >
					    <select id="ZAT03130" name="ZAT03130" class="sel"><option value="" selected></option></select>
					</td>
				 </tr>
				 
				 <!-- 기인 (공정) / 조치일시 / 보류 / 발생량 / 단위  -->
				 <tr>
				 	<th rowspan="3">${menu.ZLN0061}</th>
				 	<th>${menu.ZLN0044}</th>
				 	<td colspan="2" class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03070" name="ZAT03070" value="${attrMap.ZAT03070}" class="text" maxLength="100" >
					</td>
			    	<th>${menu.ZLN0049}</th>
	   				<td colspan="2">
						<input type="text" id="ZAT03110" name="ZAT03110" value="${attrMap.ZAT03110}"	class="alignC input_off datePicker stext" size="8"
							style="width: calc(60% - 6px);" onchange="this.value = makeDateType(this.value);" maxlength="10">
						
						<input name="ZAT03240" id="ZAT03240" value="${attrMap.ZAT03240}" class="alignC timePicker stext" style="width: 60px;">
	   				</td> 
			    	<td class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03150" name="ZAT03150" value="${attrMap.ZAT03150}" class="text" maxLength="100" >
					</td>
			    	<td class="alignL pdL10 pdR10" >
					    <select id="ZAT03131" name="ZAT03131" class="sel"><option value="" selected></option></select>
					</td>
				 </tr>
				 
				 <!-- 기인 (기구부) / 재가동일시 / 폐기 / 발생량 / 단위  -->
				 <tr>
				 	<th>${menu.ZLN0046}</th>
				 	<td colspan="2" class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03080" name="ZAT03080" value="${attrMap.ZAT03080}" class="text" maxLength="100" >
					</td>
			    	<th>${menu.ZLN0050}</th>
	   				<td colspan="2">
						<input type="text" id="ZAT03120" name="ZAT03120" value="${attrMap.ZAT03120}"	class="alignC input_off datePicker stext" size="8"
							style="width: calc(60% - 6px);" onchange="this.value = makeDateType(this.value);" maxlength="10">
						
						<input name="ZAT03250" id="ZAT03250" value="${attrMap.ZAT03250}" class="alignC timePicker stext" style="width: 60px;">
	   				</td> 
			    	<th rowspan="2">${menu.ZLN0055}</th>
			    	<td class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03160" name="ZAT03160" value="${attrMap.ZAT03160}" class="text" maxLength="100" >
					</td>
			    	<td class="alignL pdL10 pdR10" >
					    <select id="ZAT03132" name="ZAT03132" class="sel"><option value="" selected></option></select>
					</td>
			    	
				 </tr>
				 
				 <!-- 기인 (원인) / 폐기 / 발생량 / 단위  -->
				 <tr>
				 	<th>${menu.ZLN0047}</th>
				 	<td style="" class="alignL pdL10 pdR10" >
				 		<input type="checkbox" name="ZAT03090" id="ZLV309001" value="ZLV309001">
						<label for="ZLV309001" class="mgR10">${menu.ZLN0062}</label>
					</td>
					<td style="" class="alignL pdL10 pdR10" >
						<input type="checkbox" name="ZAT03090" id="ZLV309002" value="ZLV309002">
						<label for="ZLV309002" class="mgR10">${menu.ZLN0063}</label>
					</td>
					<td style="" class="alignL pdL10 pdR10" >
						<input type="checkbox" name="ZAT03090" id="ZLV309003" value="ZLV309003">
						<label for="ZLV309003" class="mgR10">${menu.ZLN0064}</label>
					</td>
					<td style="" class="alignL pdL10 pdR10" >
						<input type="checkbox" name="ZAT03090" id="ZLV309004" value="ZLV309004">
						<label for="ZLV309004" class="mgR10">${menu.ZLN0065}</label>
					</td>
					<td style="" class="alignL pdL10 pdR10" >
						<input type="checkbox" name="ZAT03090" id="ZLV309005" value="ZLV309005">
						<label for="ZLV309005" class="mgR10">${menu.ZLN0066}</label>
					</td>
			    	<td class="alignL pdL10 pdR10 last">
						<input type="text" id="ZAT03170" name="ZAT03170" value="${attrMap.ZAT03170}" class="text" maxLength="100" >
					</td>
			    	<td class="alignL pdL10 pdR10" >
					    <select id="ZAT03133" name="ZAT03133" class="sel"><option value="" selected></option></select>
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
				
				<!-- 3.조치내용 -->	
				<tr>
					<th colspan="10" class="alignL pdL10 last">3. ${menu.ZLN0058}</th>
				</tr>

				<tr>			
					<td class="alignL" colspan="10">
						<textarea class="tinymceText" style="width:100%;height:150px;" id="ZAT03190" name="ZAT03190">${attrMap.ZAT03190}</textarea>
					</td>
				</tr>
				
				<!-- 4.원인 및 재발방지대책 -->	
				<tr>
					<th colspan="10" class="alignL pdL10 last">4. ${menu.ZLN0059}</th>
				</tr>

				<tr>			
					<td class="alignL" colspan="10">
						<textarea class="tinymceText" style="width:100%;height:150px;" id="ZAT03200" name="ZAT03200">${attrMap.ZAT03200}</textarea>
					</td>
				</tr>
				
				<!-- 5.이상품 처리방안 (Risk 범위산정 및 검증) -->	
				<tr>
					<th colspan="10" class="alignL pdL10 last">5. ${menu.ZLN0060}</th>
				</tr>

				<tr>			
					<td class="alignL" colspan="10">
						<textarea class="tinymceText" style="width:100%;height:150px;" id="ZAT03210" name="ZAT03210">${attrMap.ZAT03210}</textarea>
					</td>
				</tr>
				
				<!-- 첨부문서 -->		
				<tr>
					<th>${menu.LN00019}</th>
					<td class="alignL pdL10 alignT" colspan="9" style="width:100%;height:200px;" id="fileList">
				</tr>

				
			</table>				
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

<script>
	let type = "";
	let fltpCode = "";
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(e){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		type = e;
		if(type === "ITM") fltpCode = "FLTP012";
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
			$("#fltpCode").val("FLTP012");
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
	