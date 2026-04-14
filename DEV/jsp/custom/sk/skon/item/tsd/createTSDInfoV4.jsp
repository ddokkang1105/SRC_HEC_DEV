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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<link rel="stylesheet" type="text/css"
	href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001"	var="CM00001" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095"	var="WM00095" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003"	var="WM00003" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00184"	var="WM00184" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00181"	var="WM00181" />
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00182"	var="WM00182" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00001" arguments="${menu.LN00101}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_AT00040" arguments="${menu.ZLN0114}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01040" arguments="${menu.ZLN0085}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_ZAT01051" arguments="${menu.ZLN0067}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_AT00003" arguments="${menu.ZLN0142}"/>

<head>
<style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        overflow: auto; /* 또는 overflow-y: scroll; */
    }
    
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

input.text{
	height : 30px !important;
}

</style>
<script type="text/javascript">
	var chkReadOnly = true;	
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var NEW = "N";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
  	var fltpCode = 'FLTP009';

  // 게시글에 이미 첨부되어있던 파일들 정보
  var previousAddedBoardFilesRaw = "${attachFileList}";
  var fileObjArray = javaObjToArr(previousAddedBoardFilesRaw);

  var previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);

  var scrnType = "ITM";
  var docCategory = "ITM";
  var s_itemID = "${s_itemID}"
</script>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>
<script src="<c:url value='/cmm/js/tinymce_v5/tinymce.min.js'/>"	type="text/javascript"></script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>"	type="text/javascript"></script>
<script type="text/javascript"	src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var isWf = "";
const defSiteCode = "${SiteInfo.CODE}";
const defDimValueID = "${defDimValueID}";
const hqSiteCodes = ["SKO1", "SKO2"];// 본사 사이트 코드

	$(document).ready(function(){	

	
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
	
		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		 fnSelect('ZAT01040', data+"&attrTypeCode=ZAT01040", 'getAttrTypeLov', '', 'Select');
		 
		 if("${docProcessLov.LovCode}" ==="005") { // 제조공정 - 모듈
			 $("#AT00040 option[value='']").remove();
			 $("#AT00040").append("<option value=\"02\">N</option>");
			 fnZAT01090Change("02");
		 }
		 else  if("${docTypeLov.LovCode}" === "FO") { // 양식(체크시트), 기술표준서 일 경우, default = N
			 fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '02', 'Select');
			 fnZAT01090Change("02");
		 } else if("${docTypeLov.LovCode}" === "TE") {
			 fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '02', 'Select');
			 fnZAT01090Change("02");
		 }else if("${docTypeLov.LovCode}" === "MS"){
				$("#AT00040 option[value='']").remove();
		 		$("#AT00040").append("<option value=\"02\">N</option>");
		 		 fnZAT01090Change("02");
		 }else if("${docTypeLov.LovCode}" === "DW") {
			 fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '01', 'Select');
			 fnZAT01090Change("01");
		 
		 }
		 
		 else if("${docTypeLov.LovCode}" === "WS"||"${docTypeLov.LovCode}" === "WI"){
				$("#AT00040 option[value='']").remove();
		 		$("#AT00040").append("<option value=\"02\">N</option>");
		 		 fnZAT01090Change("02");
		 } 
		 else {
			 $("#AT00040 option[value='']").remove();
			 $("#AT00040").append("<option value=\"01\">Y</option>");
			 fnZAT01090Change("01");
			
		 }		    
		 
		 setParentItem('${itemID}','${itemInfo.Path}')
	     checkBoxValue(defDimValueID);
		 
		 $('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		 
		 getDefSKONAttr();

				
	});
	
	//아이템 생성전 attr 속성 리스트 API 
	function getDefSKONAttr(){
		
			fetch("/zSKON_getDefSKONAttr.do?itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&defDimValueID=${defDimValueID}"
					+"&curItemID=${itemID}")
			.then(res => res.json())
			.then(data => {
			
			    let defAttrInfoList = data.defAttrInfo;//속성
			
		        // "siteNM"이 있는 객체 찾기
		        let siteInfo = defAttrInfoList.find(e => e.hasOwnProperty("siteNM"));
		        if (siteInfo) { //담당site명
		            document.getElementById("siteName").innerText = siteInfo.siteNM;
		            document.getElementById("ZAT01010").value = siteInfo.CODE;//담당 site 코드 
		            document.getElementById("ZAT01080").value = siteInfo.CODE;// 문서 채번용 사이트코드 
		        }
		       
		        let ZAT01030val= defAttrInfoList.find(e => e.AttrTypeCode === "ZAT01030"); //영역 
		  
		        if(ZAT01030val){
		        	document.getElementById("ZAT01030VAL").innerText = ZAT01030val.PlainText;
		        	document.getElementById("ZAT01030").value = ZAT01030val.LovCode;
		        	}
		        let ZAT01020val = defAttrInfoList.find(e => e.AttrTypeCode  === "ZAT01020"); //문서레벨 
		
		         if(ZAT01020val){
		        	 document.getElementById("ZAT01020VAL").innerText = ZAT01020val.PlainText;
		        	 document.getElementById("ZAT01020").value= ZAT01020val.LovCode;
		         }
		        
		         //문서유형 
		        let ZAT01060VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01060"); 
		        if(ZAT01060VAL){
		        	 document.getElementById("ZAT01060VAL").innerText = ZAT01060VAL.PlainText;
		        	 document.getElementById("ZAT01060").value= ZAT01060VAL.LovCode;
		         }
		        //공정 
		        let ZAT01050VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01050"); 
		        if(ZAT01050VAL){
		        	 document.getElementById("ZAT01050VAL").innerText = ZAT01050VAL.PlainText;
		        	 document.getElementById("ZAT01050").value= ZAT01050VAL.LovCode;
		        	 
		        	 fnZAT01051Change(ZAT01050VAL.LovCode);
		         }
	
	
			});
		
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
		ajaxSubmitNoAdd(document.createTSDForm, url,"saveFrame");
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
		ajaxSubmitNoAdd(document.createTSDForm, url,"saveFrame");
	}

	function fnDeleteItemFile(seq){
		var url = "changeSetFileDelete.do";
		var data = "&delType=1&fltpCode=FLTP009&seq="+seq;
		ajaxPage(url, data, "saveFrame");
		
		fnDeleteFileHtml(seq);
	}
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).remove();
		
		//$('#divFileImg').hide();
		
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
	
/* 	function fnChangeMenu(menuID,menuName) {
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
	 */
	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
	}
	
/* 	function reload(){
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
	 */



/* 	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&hiddenClassList='CL05003','CL16004'";

		fnOpenLayerPopup(url,data,doCallBackItem,617,436);
	} */
	
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
	
	function saveMainText(){	
		
		if(confirm("${CM00001}")){	
			
	
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('createTSDForm');
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
			+"&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&itemInfoRptUrl=/custom/sk/skon/report/subItemInfoReport"
			+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "processItemInfo");
	} 


	//edit버튼 클릭시
	

	function fnEditItemInfo(itemID) {
	  
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&wfOption=E"
		+"&defDimValueID="+defDimValueID
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		ajaxPage(url, data, "processItemInfo"); 
	}
	
	//편집 저장후 콜백
	function fnCllbackEdit(itemID) {
	
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo"
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
 

    // 추출한 값을 반환합니다.
    return values;  
}




//저장
var inProgress = false;
function saveObjInfoMain() {	
	if(inProgress) {
		alert("${WM00003}");
	} else {
	    if (confirm("${CM00001}")) {	
	    	if(setAllCondition()) {
	    		
	            var selectedSiteCodes = checkSiteCode(); //SKO1,SKO2 

	            var siteCodesInput = document.createElement('input');  
	            siteCodesInput.type = 'hidden';
	            siteCodesInput.name = 'siteCodes';
	            siteCodesInput.value = selectedSiteCodes.join(',');  //SKO1,SKO2
	  
	      
	            var frm = document.getElementById('createTSDForm');
	            frm.appendChild(siteCodesInput);  
	            
	    
	           var url = "zskon_saveItemInfo.do";
	            inProgress = true;
	            $('#loading').fadeIn(150);
	            
	       
	            ajaxSubmitNoAdd(frm, url);  
	      }
	    }
	}
}
	function fnZAT01090Change(value){
		
		if(value==="01"){
		
			const AT00040td = document.getElementById("AT00040td");
			AT00040td.setAttribute("colspan","1");
			const ZAT01090th = document.getElementById("ZAT01090th");
			ZAT01090th.style.display = "table-cell";
			const ZAT01090td = document.getElementById("ZAT01090td");
			ZAT01090td.style.display = "table-cell";
			fnSelect('ZAT01090', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+value, 'getSubLovList', '', 'Select');
		}
		else {
			AT00040td.setAttribute("colspan","4");
			ZAT01090th.style.display = "none";
			ZAT01090td.style.display = "none";
			// fnSelect('ZAT01090', data+"&attrTypeCode=ZAT01090", 'getAttrTypeLov', '', 'Select');
		}
	}

	function fnZAT01051Change(value){
		
		fnSelect('ZAT01051', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+value, 'getSubLovList', '', 'Select');
		
	}
function goList(){
	var url = "zSKON_searchTsdItemList.do";
	var data = "&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&screenOption=Y"
				+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
				
	ajaxPage(url, data, "createTSDForm");
}

/* function ZAT01040Change(val) {
	if("${docTypeLov.LovCode}" == "TE") {
		if(val == "VA") {
			$("#AT00040").val("01");
		} else {
			$("#AT00040").val("02");
		}
	}
} 
*/
</script>
</head>
<!-- BIGIN :: -->
<body>
	<form name="createTSDForm" id="createTSDForm" action="#" method="post"
		enctype="multipart/form-data" onsubmit="return false;">
		<div id="processItemInfo">

			<input type="hidden" id="s_itemID" name="s_itemID"	value="${itemID}" /> 
			<input type="hidden" id="option"name="option" value="${option}" /> 
			<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" /> 
			<input type="hidden" id="languageID" name="languageID"	value="${sessionScope.loginInfo.sessionCurrLangType}" /> 
			<input type="hidden" id="AuthorID" name="AuthorID"	value="${getList.AuthorID}" /> 
			<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" /> 
			<input type="hidden" id="sub" name="sub" value="${sub}" /> 
			<input type="hidden" id="function" name="function" value="saveObjInfoMain"> 
			<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
			<input type="hidden" id="projectId" name="projectId" value="${itemInfo.projectID}" /> 
			<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" /> 
			<input type="hidden" id="defSiteCode" name="defSiteCode" value="${SiteInfo.CODE}" /> 
			<input type="hidden" id="defDimValueID"	name="defDimValueID" value="${defDimValueID}" />				
			<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="OJ00016" /> 
			<input type="hidden" id="parentID"	name="parentID" value="${parentID}" />		
			<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP009" />
			<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
	
			<!-- 상단 헤더값  -->
			<div class="cop_hdtitle" id="cop_hdtitle"	style="border-bottom: 1px solid #ccc; padding: 10px 0 6px 0;">
				<h3 style="display: inline-block">	<img src="${root}${HTML_IMG_DIR}/icon_search_title.png" style="margin-right: 5px;">
					 <!-- Tech. Standard - 신규등록 -->
					 ${menu.ZLN0119} - ${menu.ZLN0100}
					<c:if test="${scrnType ne 'pop' }">
							 <span class="btn_pack medium icon" style="margin-left: 10px;"><span
							class="pre"></span><input value="List" type="button"
							onclick="goList()"></span> 				
					</c:if>
				</h3>
			</div>
				
			<div id="htmlReport" style="width: 100%; height: 100%; overflow-y: auto; overflow-x: hidden;">
				<div id="itemDiv">
					<div id="process" class="mgB10 pdT15">		
						<div class="alignR">
							<p class="cont_title mgb1"></p>						
						<span class="btn_pack medium icon"><span class="save"></span>
							<input value="Save" onclick="saveObjInfoMain()" type="submit">
							</span>											
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
								<td colspan="1" class="alignL pdL10"><input type="text"
									id="" name="" value="" class="text" maxLength="100" disabled>
								</td>
								<!-- 문서명 -->
								<th><span style="color: red;">*</span>${menu.LN00101}</th>
								<td colspan="3" class="alignL pdL10"><input type="text"
									id="AT00001" name="AT00001" value="" class="text"
									maxLength="100">
								</td>
								<!-- 개정번호 -->
								<th>${menu.LN00356}</th>
								<td colspan="4" class="alignL pdL10">0 <span style="font-weight:bold; margin-left:5px;">(${menu.ZLN0103})</span> <!-- (작성중) -->
								<input type="hidden"
									id="" name="" value="" class="text" maxLength="100" disabled>
								</td> 
							</tr>
							<tr>
								<!-- 담당Site -->
					    		<th>${menu.ZLN0089}</th>
								<td colspan="1" class="alignL pdL10"> 
									<span id="siteName"></span>
									<input type="hidden" id="ZAT01010" name="ZAT01010" value="" class="text"> <!-- 관리site -->	
							 		<input type="hidden" id="ZAT01080" name="ZAT01080" value="" class="text"> <!-- 문서채번 code  -->
								</td>
								<!-- 담당부서 -->				
								<th>${menu.ZLN0074}</th>
								<td class="alignL pdL10">${sessionScope.loginInfo.sessionTeamName}</td>
								<!-- 담당자 -->
								<th>${menu.LN00004}</th>
								<td class="alignL pdL10">${sessionScope.loginInfo.sessionUserNm}</td>
								<!-- NCT대상 -->
								<th><span style="color: red;">*</span>${menu.ZLN0114}</th>
								<td  id = "AT00040td" colspan="1" class="alignL pdL10" id = "AT00040td">
									<select id="AT00040" name="AT00040" class="sel" onchange="fnZAT01090Change(this.value)">
										<option value=""></option>
									</select>
								</td>
								<!-- 수출입신고여부  -->
								<th id ="ZAT01090th" style="display:none;"><span style="color: red;">*</span>${menu.ZLN0032}</th>
								<td id="ZAT01090td" style="display:none;" colspan="2" class="alignL pdL10" >
									<select id="ZAT01090" name="ZAT01090" class="sel">
											<option value=""></option>
									</select>
								</td>	
							</tr>
							
							<tr>
								<!-- 영역 -->
				    			<th>${menu.ZLN0072}</th>	
								<td colspan="1" class="alignL pdL10"><span id="ZAT01030VAL"></span>
									<input type="hidden" id="ZAT01030" name="ZAT01030" value="" class="text" onClick="">
								</td>
								<!-- 문서유형 -->
								<th>${menu.LN00091}</th>
								<td class="alignL pdL10"><span id="ZAT01060VAL"></span>
									<input type="hidden" id="ZAT01060" name="ZAT01060" value="" class="text">
								</td>
								<!-- 문서분야 -->	
								<th><span style="color: red;">*</span>${menu.ZLN0085}</th>
								<td colspan="1" class="alignL pdL10">
									<select id="ZAT01040" name="ZAT01040" class="sel" >
										<option value=""></option>
									</select>
								</td>
								<!-- 문서레벨 -->
								<th>문서레벨</th>
								<td colspan="4" class="alignL pdL10"><span id = "ZAT01020VAL"></span>
									<input type="hidden" id="ZAT01020" name="ZAT01020" value="" class="text">
								</td>
							</tr>
							<tr>
								<!-- 공정 -->
								<th>${menu.ZLN0044}</th>
								<td colspan="1" class="alignL pdL10"><span id="ZAT01050VAL"></span>
									<input type="hidden" id="ZAT01050" name="ZAT01050" value="" class="text" onchange="fnZAT01051Change(this.value)">
								</td>
								<!-- 상세공정 -->
								<th><span style="color: red;">*</span>${menu.ZLN0067}</th>
								<td class="alignL pdL10">
									<select id="ZAT01051" name="ZAT01051" class="sel">
										<option value=""></option>
									</select>
								</td>
								<!-- 모델 -->
					    		<th>${menu.LN00125}</th>
								<td class="alignL pdL10"><input type="text" id="" name="" value="" class="text" disabled>
								</td>
								<!-- 라인 -->
								<th>${menu.ZLN0113}</th>
								<td class="alignL pdL10" colspan="4">
									<input type="text" id="" name="" value="" class="text" disabled>
								</td>
							</tr>
							
							<tr style="">
								<!-- 배포Site -->
					   			<th>${menu.ZLN0031}</th>
								<td style="">
									<input type="checkbox" name="siteCode" id="cmm" value="cmm">
									<label for="cmm">${menu.ZLN0028}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKO1" value="SKO1">
									<label for="SKO1">${menu.ZLN0029}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKO2" value="SKO2">
									<label for="SKO2">${menu.ZLN0030}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKBA" value="SKBA">
									<label for="SKBA">${menu.ZLN0079}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKOH1" value="SKOH1">
									<label for="SKOH1">${menu.ZLN0080}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKOH2" value="SKOH2">
									<label for="SKOH2">${menu.ZLN0081}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKBM" value="SKBM">
									<label for="SKBM">${menu.ZLN0082}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKOJ" value="SKOJ">
									<label for="SKOJ">${menu.ZLN0083}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKOY" value="SKOY">
									<label for="SKOY">${menu.ZLN0084}</label>
								</td>
								<td style="border-left: 1px solid #ccc; width: 80px; height:43px;">
									<input type="checkbox" name="siteCode" id="SKOS" value="SKOS">
									<label for="SKOS">${menu.ZLN0150}</label>
								</td>
							</tr>

							<!-- 문서개요<br>(목적, 설명) -->
							<tr>
								<th><span style="color: red;">*</span>${menu.ZLN0094}<br>(${menu.LN00386}, ${menu.ZLN0116})</th>
								<td class="alignL pdL10" colspan="10">
								<textarea class="edit" id="AT00003" name="AT00003" style="width: 100%; height: 100px;">${prcList.Description}</textarea>
								</td>
							</tr>
							<!-- 주요개정사항 -->
							<tr>
								<th>${menu.LN00360}</th>
								<td class="alignL pdL10" colspan="10">						
								<textarea class="edit" id="Description" name="Description" style="width:100%;height:100px;"></textarea> 
								</td>	
							</tr>
							<!-- 키워드 -->
							<tr>
								<th>${menu.ZLN0070}</th>
								<td class="alignL pdL10" colspan="10"><input type="text" id="AT01007" name="AT01007" value="" class="text" maxLength="100" style="width: 100%;"></td>
							</tr>
							<!-- 첨부문서 --> 
							<tr>
								<th><span style="color: red;">*</span>${menu.LN00019}</th>
								<td class="alignL pdL10 alignt" colspan="10" style="width: 100%; height: 200px;">
									<span id="viewFile" class="btn_pack medium icon">
										<span class="upload"></span>
										<input value="Attach" type="submit" onclick="openDhxVaultModal()" style="margin-bottom: 5%;">
									</span>
									<div class="tmp_file_wrapper mgT15" id="tmp_file_wrapper" style="display: none;">
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
	
	function openDhxVaultModal(){		
		// dhtmlx 윈도우로 vault 띄우기
		newFileWindow.show();
	}
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID);
		fileNameMapV4.set(fileID,fileName);
		fileSizeMapV4.set(fileID,fileSize);
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
	}
	
	function fnDisplayTempFileV4(){
	    // "첨부된 파일이 없습니다." 문구 제거
	    $("#emptyAttachPlaceholder").remove();

	    let display_scripts = "";
	    fileIDMapV4.forEach(function(fileID) {			  
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+',true)" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
				'<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
				'<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
				'</tr>';
			}
	    });

	    document.querySelector("#tmp_file_items").children.namedItem("file-list").insertAdjacentHTML("beforeend",display_scripts);
	    document.querySelector("#tmp_file_wrapper").style.display = "";
	    document.querySelector("#tmp_file_wrapper").style.border = "0";
	    document.querySelector("#tmp_file_wrapper").style.padding = "0";
	    
	    fileIDMapV4 = new Map();
	    fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){		
		var fileName = document.getElementById(fileID)?.innerText;
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			if (doDeleteFromVault){
				// vault 모달이 존재하고 vault 객체가 초기화되어 있으면 해당 파일 삭제
				if(typeof vault !== 'undefined' && vault !== null){
					try {
						// fileID에서 숫자만 추출 (vault 내 파일 id에는 불필요한 u가 붙어있었음)
						var vaultFileId = "u" + fileID;
						var vaultFile = vault.data.getItem(vaultFileId);
						if(vaultFile){			
							vault.data.remove(vaultFileId);
						}
					} catch(e) {
						console.error("Vault에서 파일 삭제 중 오류:", e);
					}
				} else {
					console.error("Vault 모달이 존재하지 않음");
				}
			}
		}
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
</body>
<iframe id="saveFrame" name="saveFrame" style="display: none"
	frameborder="0"></iframe>
</html>
