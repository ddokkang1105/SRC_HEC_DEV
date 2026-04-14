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

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00181" var="WM00181" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00182" var="WM00182" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00183" var="WM00183" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00184" var="WM00184" />
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

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00001" arguments="${menu.LN00101}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_AT00040" arguments="${menu.ZLN0114}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01040" arguments="${menu.ZLN0085}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01051" arguments="${menu.ZLN0067}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00003" arguments="${menu.ZLN0142}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00187" var="WM00187"/>

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<%-- <script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script> --%>
<script type="text/javascript">
var isWf = "";
var checkOutFlag = "N";
var delList = [];
const defSiteCode = "${defSiteCode}";
const defDimValueID = "${defDimValueID}";
const hqSiteCodes = ["SKO1", "SKO2"];// 본사 사이트 코드
let nctInfo="";
let attrTypeCodeList="";
let isDeclared ="";//수출입 신고여부 
getSKONAttr();

	$(document).ready(function(){
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
	

		
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		//적용site 관련로직 
		let siteCodes="${dimInfotMap}";		
		siteCodes = siteCodes.replace(/[{}]/g, "").trim();
		let entries = siteCodes.split(", ");
		let siteCodeValues = entries.map(entry => entry.split("=")[1]);
	

		checkBoxValue(siteCodeValues);
		
	
	 
	});

	function getSKONAttr() {
	
		fetch("/getSKONAttr.do?itemID=${itemID}&accMode=${accMode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(data => {
		attrTypeCodeList = data.list.map(item => item.AttrTypeCode); //attr리스트
		
	
			let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			let docType="";
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01010").length) {
				document.getElementById("ZAT01010Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01010")[0].PlainText)
				document.getElementById("ZAT01010").value = data.list.filter(e => e.AttrTypeCode === "ZAT01010")[0].LovCode;
			}
			
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01030").length) {
				document.getElementById("ZAT01030Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01030")[0].PlainText)
				document.getElementById("ZAT01030").value = data.list.filter(e => e.AttrTypeCode === "ZAT01030")[0].LovCode;
			}
			if (data.list.some(e => e.AttrTypeCode === "ZAT01060" )) {
				// 값 삽입
				document.getElementById("ZAT01060Value").insertAdjacentHTML("beforeend",data.list.find(e => e.AttrTypeCode === "ZAT01060").PlainText);
				
				document.getElementById("ZAT01060").value = data.list.find(e => e.AttrTypeCode === "ZAT01060").LovCode;

				docType = data.list.find(e => e.AttrTypeCode === "ZAT01060").LovCode;
				//document.getElementById("ZAT09007Value").style.display = "";
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01040").length) {
				document.getElementById("ZAT01040Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01040")[0].PlainText);
				document.getElementById("ZAT01040").value = data.list.filter(e => e.AttrTypeCode === "ZAT01040")[0].LovCode;
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01020").length) {
				document.getElementById("ZAT01020Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01020")[0].PlainText);
				document.getElementById("ZAT01020").value = data.list.filter(e => e.AttrTypeCode === "ZAT01020")[0].LovCode;
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01050").length) {
				document.getElementById("ZAT01050Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01050")[0].PlainText)
				document.getElementById("ZAT01050").value = data.list.filter(e => e.AttrTypeCode === "ZAT01050")[0].LovCode;
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT01051").length) {
				document.getElementById("ZAT01051Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01051")[0].PlainText);
				document.getElementById("ZAT01051").value = data.list.filter(e => e.AttrTypeCode === "ZAT01051")[0].LovCode;
			}
		
			if(data.list.filter(e => e.AttrTypeCode === "ZAT09005").length){
				document.getElementById("ZAT09005Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT09005")[0].PlainText)
				document.getElementById("ZAT09005").value = document.getElementById("ZAT09005Value").innerText.trim();
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT09006").length){
				document.getElementById("ZAT09006Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT09006")[0].PlainText)
				document.getElementById("ZAT09006").value = document.getElementById("ZAT09006Value").innerText.trim();
			}
			if(data.list.filter(e => e.AttrTypeCode === "ZAT09007").length){
				if(docType =="CP"){
					//console.log(docType);
					document.getElementById("prodCode").style.display="";
					document.getElementById("ZAT09007Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT09007")[0].PlainText)
					document.getElementById("ZAT09007").value = document.getElementById("ZAT09007Value").innerText.trim();
				}
				
				
			}
			
		
			   const at00040Data = data.list.find(e => e.AttrTypeCode === "AT00040");
			    if (at00040Data) {
			    
			      nctInfo = at00040Data.LovCode;
			      nctVal = at00040Data.PlainText
			  
				 let ZAT01050val="";
				 let ZAT01060Value ="";
				    <c:forEach var="i" items="${attrList}">
				    	<c:if test="${i.AttrTypeCode eq 'ZAT01050'}">
				    		ZAT01050val= "${i.LovCode}";
				
				    	</c:if>
						<c:if test="${i.AttrTypeCode eq 'ZAT01060'}">
							 ZAT01060Value = "${i.LovCode}";
							
					    </c:if>
					    
					    <c:if test="${i.AttrTypeCode eq 'ZAT09007'}">
					     ZAT09007Value = "${i.LovCode}";
				    	</c:if>
						
						</c:forEach>
			
							if(ZAT01060Value === "FO" || ZAT01060Value === "TE" ||ZAT01060Value === "DW") { // 양식(체크시트), 기술표준서 //도면 
								fnSelect('AT00040', datas+"&attrTypeCode=AT00040", 'getAttrTypeLov', nctInfo, 'Select');
								}
						 	
							else if(ZAT01060Value === "MS" ||ZAT01060Value === "WS"||ZAT01060Value === "WI"||ZAT01050val==="005"){
								$("#AT00040 option[value='']").remove();
						
						
								$("#AT00040").append("<option value=\""+at00040Data.LovCode+"\">"+at00040Data.PlainText+"</option>");
								
								
							} 
							else {
						
								$("#AT00040 option[value='']").remove();
								$("#AT00040").append("<option value=\""+at00040Data.LovCode+"\">"+at00040Data.PlainText+"</option>");
					
							
							} 
				
			    }
			    const zat01090Data = data.list.find(e => e.AttrTypeCode === "ZAT01090");
			    if (zat01090Data) {
			
			    	isDeclared = zat01090Data.LovCode;
			      fnZAT01090Change(nctInfo,zat01090Data.LovCode,datas);
			    
			    }
		});
	}
	
	
	//콜백 
	function fnEditItemInfo(itemID) {
	
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo"
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
	
	var inProgress = false;
	function saveObjInfoMain(){	
		
		if(inProgress) {
			alert("${WM00003}");
		} else {
			if(confirm("${CM00001}")){	
			
				if(setAllCondition()) {
					if(delList.length > 0) {
						// 임시로 삭제된 파일 데이터에서 삭제하기
						var url = "deleteFileFromLst.do";
					 	var data = "&displayMsg=N&seq="+delList;
						var target = "blankFrame";
					 	ajaxPage(url, data, target);	
					}
					
					var selectedSiteCodes = checkSiteCode();  
					var siteCodesInput = document.createElement('input');  
					siteCodesInput.type = 'hidden';
					siteCodesInput.name = 'siteCodes';
					siteCodesInput.value = selectedSiteCodes.join(',');  
					
			
					
					var frm = document.getElementById('editFrm');
					frm.appendChild(siteCodesInput);  
					
					var attrTypeCodesInput = document.createElement('input');
					attrTypeCodesInput.type = 'hidden';
					attrTypeCodesInput.name = 'attrTypeCodes'; // 서버에서 이 이름으로 받음
					attrTypeCodesInput.value = attrTypeCodeList.join(','); // 쉼표로 구분된 문자열
	
				
					frm.appendChild(attrTypeCodesInput);
	
					var url = "zskon_saveItemInfo.do";
		
					inProgress = true;
		            $('#loading').fadeIn(150);
	 				ajaxSubmitNoAdd(frm, url);
				}
			}
		}
	}
	
	// callback - deleteFileFromLst
	function doSearchList() {
		
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
 				+"&itemViewPage=custom/sk/skon/item/tsd/viewTSDInfo&screenMode=pop&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
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
			+"&url=/custom/sk/skon/item/tsd/viewTSDInfo"
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
		var data = "&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo&accMode=DEV&scrnMode=N&option=${option}";	
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
			+"&url=/custom/sk/skon/item/tsd/viewTSDInfo"
			+"&scrnOption=Y"
			+"&itemOption=Y"
			+"&defDimValueID=${defDimValueID}&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
			//var target = frontFrm
		ajaxPage(url, data, "editFrm");

	}
	
	
	function goList(){
		var url = "zSKON_searchTsdItemList.do";
		var data = "&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&screenOption=Y"
					+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
					
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
		if ($("#AT00040").val()==""){
			alert("${WM00025_AT00040}");		// NCT대상을 선택하여 주십시오.
			return false;
		}
		
		if ($("#ZAT01040").val() == "") {
			alert("${WM00025_ZAT01040}");		// 문서분야를 선택하여 주십시오.
			return false;
		} 
		if ($("#ZAT01051").val() == "") {
			alert("${WM00025_ZAT01051}");		// 상세공정을 선택하여 주십시오.
			return false;
		}
	
		if ($("#AT00003").val() == "") {
			alert("${WM00034_AT00003}");		// 문서내용을 입력하여 주십시오.
			return false;
		} 
		
		if ($("#AT00040").val()=="01"){ // NCY가 Y일떄 
			
            //NCT 수출입신고여부 validation
			var siteList = checkSiteCode();
			// 본사,서산이 아닌 코드가 포함되어 있다면
			var hasNonHQSite = siteList.some(code => !hqSiteCodes.includes(code));

			if (hasNonHQSite) {
			    alert("${WM00181}\n${WM00182}");
				return true ;
			}
	     
		}
		
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
		var isAll  = "";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}

	// 체크박스 이벤트 
	function checkBoxValue(siteCodes) {
	
	    // 모든 체크박스를 가져옴
	    let checkBoxes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]');
	

	    checkBoxes.forEach(function(checkbox) {
	    	
	
	    	if(defDimValueID ==="SKO1"){
	  	         checkbox.disabled = false;
	    		 if (siteCodes.includes(checkbox.id)) {
	  	            checkbox.checked = true;
	  	            if(checkbox.id === "SKO1"){
	  	            	checkbox.disabled = true; 
	  	            }
	  	    	
	  	        }
	    	}else{
	    		 checkbox.disabled = true;
	    		 if (siteCodes.includes(checkbox.id)) {
		  	            checkbox.checked = true;
		  	        }
	    	}
	       
	    });
	    
	    
	
	}
	 // 공통 체크박스 선택 및 해제 시 디폴트사이트코드 제외  나머지 전부 체크 및 해제 
    document.getElementById('cmm').addEventListener('change', function() {
     let check = document.querySelectorAll('input[name="siteCode"]');
      check.forEach(function(checkbox) {
    	  if(checkbox.id != "SKO1"){
    		   checkbox.checked = document.getElementById('cmm').checked;
    	  }
      });
    });
	 
	// 체크된 사이트 코드 찾기 
	function checkSiteCode() {
	    let siteCodes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]:checked');
	    let values = [];  

	    siteCodes.forEach(function(checkbox) {

	        	values.push(checkbox.id);  
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
			var siteList = checkSiteCode();// 선택한 배포사이트 코드 

			var hasHQSite = siteList.some(code => hqSiteCodes.includes(code));// siteList 에 있는 코드중 하나라도  hqSiteCodes에 있는지
	        var allHQSite = siteList.every(code => hqSiteCodes.includes(code)); // siteList 에 있는 모든코드가 hqSiteCodes 에 있는지 
			var hasNonHQSite = siteList.some(code => !hqSiteCodes.includes(code));  // 본사,서산이 아닌 코드가 포함되어 있다면
	        var status = "${itemInfo.Status}";			 
			if(status != "DEL1"){
				if(data.count == "0") {
					alert("${WM00187}");	// 문서를 첨부하여 주십시오.
					return false;
				}
			
				else {
					
					 if(nctInfo == "01"){ // NCT 여부가 Y 
						 if(isDeclared ==""){ //수출입 신고여부 미선택 	 
							    if(hasHQSite&&allHQSite){//본사, 서산 
									alert("${WM00184}");
									return false;
								}else{ // 다른 해외 사이트 코드 포함
									alert("${WM00181}\n${WM00184}");
									return false;
								}
							
						 } 
						 if( isDeclared =="LOV02"){ // 수출입 신고여부 N 	 
							  if(hasNonHQSite){ //다른 해외 사이트 포함
									alert("${WM00181}\n${WM00183}");
									return false;
								}
							
						 } 

					 }
					
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
			+"&url=/custom/sk/skon/item/tsd/viewTSDInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	function fnZAT01090Change(val1,val2,val3){
		
		if(val1==="01"){ //nct y일때
	
		 	const AT00040td = document.getElementById("AT00040td");
			AT00040td.setAttribute("colspan","1");
		 	AT00040td.style.visibility = "visible";
			const ZAT01090th = document.getElementById("ZAT01090th");
			ZAT01090th.style.display = "table-cell";
			const ZAT01090td = document.getElementById("ZAT01090td");
			ZAT01090td.style.display = "table-cell"; 
		 
			
			fnSelect('ZAT01090', val3+"&attrTypeCode=ZAT01090", 'getAttrTypeLov', val2, 'Select');
		}
		else { //nct N일때
			AT00040td.setAttribute("colspan","4");
			AT00040td.style.visibility = "visible";
			ZAT01090th.style.display = "none";
			ZAT01090td.style.display = "none";  
		
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
<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP009" />
			
	<div style="width:100%;height:800px;overflow-y:auto;overflow-x:hidden;">
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
				<!-- 기본정보 편집 -->			
				<p class="cont_title">${menu.LN00005} ${menu.LN00046}</p>
				<div class="alignR">
				
				 	<span class="btn_pack medium icon">
	    			<span class="pre"></span>
	    				<input value="Cancel" type="button" onclick="goView('${itemID}')"> 
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
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">
					 	<col width="9%">					
					</colgroup>
							
					<!-- Attr 속성값 -->
					<tr>
						<!-- 문서번호 -->
						<th>${menu.ZLN0068}</th>
						<td colspan="1" class="alignL pdL10">${itemInfo.Identifier}</td>
						<!-- 문서명 -->
						<th ><span style="color: red;">*</span>${menu.LN00101}</th>					
						<td colspan="3" class="alignL pdL10">
							<input type="text" id="AT00001" name="AT00001" value="${itemInfo.ItemName}" class="text" maxLength="100" >
						</td>
						<!-- 개정번호 -->
						<th>${menu.LN00356}</th>
					    <td  colspan="4" class="alignL pdL10" >	${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>  
					</tr>
					<tr>
						<!-- 담당Site -->
					    <th>${menu.ZLN0089}</th>
						<td  class="alignL pdL10" id="ZAT01010Value">
						   <input type="hidden" id="ZAT01010" name="ZAT01010" class="text" >
						</td>
						<!-- 담당부서 -->				
						<th>${menu.ZLN0074}</th>
						<td  colspan="1" class="alignL pdL10" >	${itemInfo.OwnerTeamName}</td>
						<!-- 담당자 -->
						<th>${menu.LN00004}</th>
						<td  class="alignL pdL10">${itemInfo.AuthorName}</td>
						<!-- NCT대상 -->
						<th><span style="color: red;">*</span>${menu.ZLN0114}</th>
						<td id = "AT00040td" colspan="4" class="alignL pdL10" style="visibility: hidden;">
						    <select id="AT00040" name="AT00040" class="sel" onchange="fnZAT01090Change(this.value)">
						    <option value="" selected></option></select>
						</td>
						<!-- 수출입신고여부  -->
						<th id ="ZAT01090th" style="display:none;" ><span style="color: red;">*</span>${menu.ZLN0032}</th>
						<td id="ZAT01090td" style="display:none;" colspan="2" class="alignL pdL10" >
							<select id="ZAT01090" name="ZAT01090" class="sel">
								<option value=""></option>
							</select>
						</td>	
					</tr>

				 	<tr>
				 		<!-- 영역 -->
				    	<th>${menu.ZLN0072}</th>		
						<td colspan="1" class="alignL pdL10" id="ZAT01030Value">
						<input type="hidden" id="ZAT01030" name="ZAT01030" class="text" >
						</td>
						<!-- 문서유형 -->
						<th>${menu.LN00091}</th>
						<td class="alignL pdL10" id="ZAT01060Value">
						<input type="hidden" id="ZAT01060" name="ZAT01060" class="text" >
						</td>
						<!-- 문서분야 -->					
						<th>${menu.ZLN0085}</th>
						<td class="alignL pdL10" id="ZAT01040Value">
							<input type="hidden" id="ZAT01040" name="ZAT01040" class="text" >
						</td>				
					    <!-- 문서레벨 -->
						<th>${menu.ZLN0075}</th>
						<td colspan="4" class="alignL pdL10" id="ZAT01020Value">
					   		<input type="hidden" id="ZAT01020" name="ZAT01020" class="text" > 
						</td>
					</tr>

					<tr>
						<!-- 공정 -->
						<th>${menu.ZLN0044}</th>
						<td  colspan="1" class="alignL pdL10" id="ZAT01050Value">
							<input type="hidden" id="ZAT01050" name="ZAT01050" class="text" >
						</td>
						<!-- 상세공정 -->
						<th>${menu.ZLN0067}</th>
						<td class="alignL pdL10" colspan="1" id="ZAT01051Value">
							<input type="hidden" id="ZAT01051" name="ZAT01051" class="text" >
						</td>	
						<!-- 모델 -->
					    <th>${menu.LN00125}</th>
						<td class="alignL pdL10" colspan="1" id="ZAT09005Value">
						 <input type="hidden" id="ZAT09005" name="ZAT09005" value ="" class="text" > 
						</td>
						<!-- 라인 -->
						<th>${menu.ZLN0113}</th>
					    <td colspan="4" class="alignL pdL10" colspan="1" id="ZAT09006Value">	
					 		<input type="hidden" id="ZAT09006" name="ZAT09006" value ="" class="text" >  				    	
					    </td>					
					</tr>

					<tr style="">
						<!-- 배포Site -->
					    <th>${menu.ZLN0031}</th>
						<td style="">
							<input type="checkbox"name="siteCode" id="cmm" value="cmm"> 
							<label for="cmm">${menu.ZLN0028}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox" name="siteCode" id="SKO1" value="SKO1"> 
							<label for="SKO1">${menu.ZLN0029}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKO2" value="SKO2"> 
							<label for="SKO2">${menu.ZLN0030}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKBA" value="SKBA">
							<label for="SKBA">${menu.ZLN0079}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKOH1" value="SKOH1">
							<label for="SKOH1">${menu.ZLN0080}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKOH2" value="SKOH2">
							<label for="SKOH2">${menu.ZLN0081}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKBM" value="SKBM"> 
							<label for="SKBM">${menu.ZLN0082}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							<input type="checkbox"name="siteCode" id="SKOJ" value="SKOJ"> 
							<label for="SKOJ">${menu.ZLN0083}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							 <input type="checkbox"name="siteCode" id="SKOY" value="SKOY"> 
							 <label for="SKOY">${menu.ZLN0084}</label>
						</td>
						<td style="border-left: 1px solid #ccc; width: 80px;">
							 <input type="checkbox"name="siteCode" id="SKOS" value="SKOS"> 
							 <label for="SKOS">${menu.ZLN0150}</label>
						</td>		
					</tr>

					<!-- 문서개요<br>(목적, 설명) -->
					<tr>
						<th><span style="color: red;">*</span>${menu.ZLN0094}<br>(${menu.LN00386}, ${menu.ZLN0116})</th>
						<td class="alignL pdL10" colspan="10" >
						<textarea class="edit" id="AT00003" name="AT00003"  style="width:100%;height:100px;">${prcList.Description}</textarea>
						</td>
					</tr>
					<!-- 주요개정사항 -->
					<tr>
						<th>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Description" name="Description" style="width:100%;height:100px;">${csInfo.Description}</textarea> 
						</td>						
					</tr>
					<!-- 제품코드라인 -->
					<tr id = "prodCode" style="display:none;">
						<th>${menu.ZLN0120}</th>
						<td class="alignL pdL10" colspan="10" id="ZAT09007Value">
						<input type="hidden" id="ZAT09007" name="ZAT09007" class="text">
						</td>
					</tr>
					<!-- 키워드 -->
					<tr>
						<th>${menu.ZLN0070}</th>
						<td class="alignL pdL10" colspan="10">
						<input type="text" id="AT01007" name="AT01007" value="${attrMap.AT01007}" class="text" maxLength="100" style="width: 100%;" >
						</td>
					</tr>
					<!-- 첨부문서 --> 
					<tr>
						<th><span style="color:red;">*</span>${menu.LN00019}</th>
						<td class="alignL pdL10 alignt" colspan="10" style="width:100%;height:200px;">							
							<c:if test="${itemInfo.Status ne 'DEL1' }" >
								<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
							</c:if>
							<div class="tmp_file_wrapper mgT10" id="tmp_file_wrapper">
								<table class="tbl_preview"  id="tmp_file_items" name="tmp_file_items">
									<colgroup>
										<col width="5%">
										<col width="15%">
										<col width="60%">
										<col width="10%">
										<col width="10%">
									</colgroup>	
									<tr>
										<!-- 문서유형 / 문서명 / 작성자 / 등록일 -->
										<th></th>
										<th>${menu.LN00091}</th>
										<th>${menu.LN00101}</th>
										<th>${menu.LN00060}</th>
										<th>${menu.LN00078}</th>
									</tr>
									<tbody name="file-list">
									<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
										<tr id="${fileList.Seq}">
									<td><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFile('${fileList.Seq}')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>
											<td>${fileList.FltpName}</td>
											<td class="alignL pdL10 flex align-center">
													<span class="btn_pack small icon mgR20"  <%-- onclick="fileNameClick('${fileList.Seq}'); "--%>>
													<c:set var="FileFormat" value="${fileList.FileFormat}" />
														<span class="
																<c:choose>
																	<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
																	<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
																	<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
																	<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
																	<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
																	<c:otherwise>log</c:otherwise>
																</c:choose>
																		"></span>
													</span>
													<span style="cursor:pointer;margin-left: 10px;" <%-- onclick="fileNameClick('${fileList.Seq}');" --%>>${fileList.FileRealName}</span>
													(<span id="fileSize">${fileList.FileSize}</span>)
											</td> 
											<td>${fileList.WriteUserNM}</td>
											<td>${fileList.CreationTime}</td>
										</tr>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</td>	
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
				<div id="layout1" style="width: 100%; height:300px;"></div>				
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

<script>
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
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		
		var url="addFilePopV4.do";
		var data="scrnType=CS&fltpCode=FLTP009";
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
			  '<td>${menu.LN00371}</td>'+
			  '<td class="alignL pdL10 flex align-center" name="fileInfo"><span class="btn_pack icon small"></span><span name="fileName">'+ fileNameMapV4.get(fileID)+'</span>(<span id="fileSize">'+getFileSize(fileSizeMapV4.get(fileID))+'</span>)</td>'+
			  '<td></td>'+
			  '<td></td>'+
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
		var fileName = document.getElementById(fileID).children.namedItem("fileInfo").children.namedItem("fileName").innerHTML
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
// 		if(confirm("${CM00002}")){
// 			var url  = "deleteFile.do?Seq="+seq;
// 			ajaxSubmit(document.editFrm, url,"saveFrame");
			$("#"+seq).remove();
			// 임시로 delete list 가지고 있음
			delList.push(seq);
// 		}
	}
	
	let classCode = "";
	let CXNItemTypeCode = "";
	let CXNClassCode = "";
	let itemTypeCode = "";
	
	function fncxnItemListPop(e){
		itemTypeCode = e;
		classCode = "CL01005,CL01005A,CL01006A,CL01006B,CL16004"
		
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
	
	function setCheckedItems(checkedItems) {
		itemTypeCode = [...new Set(checkedItems.map(e => e.ItemTypeCode))][0];
			
		if(itemTypeCode === "OJ00001") {
			CXNItemTypeCode = "CN01601";
			CXNClassCode = "CNL1601";
		}
		if(itemTypeCode === "OJ00016") {
			CXNItemTypeCode = "CN01616";
			CXNClassCode = "CNL1616";
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
		if(itemTypeCode === "OJ00001" || itemTypeCode === "OJ00016") {
			CXNItemTypeCode = "'CN00121','CN01616'";
		}
		
		fetch("/zSKON_cxnItemList.do?itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cxnTypeList="+CXNItemTypeCode)
		.then((res) => res.json())
		.then((data) => {
			data.list.map(e => delete e.id);
			grid1.data.parse(data.list.filter(e => e.ItemTypeCode == "OJ00001" || e.ItemTypeCode == "OJ00016"));
			
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
	
/* 	function popStandardTemrs() {
		window.open("standardTermsSch.do?csr=9&mgt=Y",'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	} */
	

</script>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
