<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
 
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${srAreaLabelNM1}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${srAreaLabelNM2}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00072}"/> <!-- 사용자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="요청 목적 및 사유"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" />
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var p_gridArea;
	var propItemList = "";
	var srArea1ListSQL = "${srArea1ListSQL}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data + "&itemTypeCode=${itemTypeCode}", srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
		fnSelect('category',data+"&level=1", 'getESMSRCategory', '', 'Select', 'esm_SQL');
		
		$('#reqDueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
		
// 		if("${itemProposal}" == "Y") {
			$("#itemListTR").attr("style","padding-top:10px;display:done;");
			
// 			doSearchList();
			changeClassCode("${stItemType}"); // 속성 option 초기화
// 		}
		
	});
	
	function changeClassCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "classCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	

	function itemTypeCodeTreePop() {
		var url = "itemTypeCodeTreePop.do";
		var data = "openMode=add&ItemTypeCode=${stItemType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option=${option}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var srArea1 = $("#srArea1").val();
		var srArea2 = $("#srArea2").val();
		var category = $("#category").val();
		var subject = $("#subject").val();
		var opinion = $("#opinion").val();
		var description = tinyMCE.get('description').getContent();
		$("#description").val(description);
		
		var reqdueDate = $("#reqdueDate").val().replaceAll("-","");
		var currDate = "${thisYmd}";
		var requestUser = $("#requestUserID").val();
		
		if(requestUser == "" || requestUser == null ){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(srArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(srArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(reqdueDate == ""){alert("${WM00034_5}"); isCheck = false; return isCheck;}
// 		if(opinion == ""){alert("${WM00034_6}"); isCheck = false; return isCheck;}
		
		if(parseInt(reqdueDate) < parseInt(currDate) ){ 	
			alert("${WM00014}"); isCheck = false; return isCheck;
		} 
	 
		return isCheck;
	}
	
	function fnSaveSR(){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		setItemIDs();
		var url  = "createESRMst.do";
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}
	
	function doDelete(){
		if(confirm("${CM00002}")){
			var url = "deleteBoard.do";
			ajaxSubmit(document.boardFrm, url,"saveFrame");
		}
	}	

	function fnGoSRList(){ 
		var fromSRID = $("#fromSRID").val();
		if(fromSRID == null || fromSRID == ''){
			var url = "itspList.do";
			var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
					+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
					+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"; 
			var target = "mainLayer";
		} else {
			var url = "esrList.do";
			var data = "fromSRID="+fromSRID;
			var target = "tabFrame";
		}
		
		ajaxPage(url, data, target);
	}
	
	//browser detect
	var browser = (function() {
	  var s = navigator.userAgent.toLowerCase();
	  var match = /(webkit)[ \/](\w.]+)/.exec(s) ||

	              /(opera)(?:.*version)?[ \/](\w.]+)/.exec(s) ||

	              /(msie) ([\w.]+)/.exec(s) ||               

	              /(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) ||

	             [];
	  return { name: match[1] || "", version: match[2] || "0" };
	}());

	//************** addFilePop V4 설정 START ************************//
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR&fltpCode=SRDOC";
		openPopup(url+"?"+data,490,450, "Attach File");
	} 
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	function fnAttacthFileHtmlV4(fileID, fileName){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID);
		fileNameMapV4.set(fileID,fileName);
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
	}
	
	function fnDisplayTempFileV4(){				
		display_scripts=$("#tmp_file_items").html(); 
		fileIDMapV4.forEach(function(fileID) {			  
			  display_scripts = display_scripts+
				'<div id="'+fileID+'"  class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+')">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){		
		var fileName = document.getElementById(fileID).innerText;		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
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
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}	
	
	function fnCheckRequest(){
		var checkObj = document.all("self");
		if( checkObj.checked == true){ 
			$("#searchRequestBtn").attr('style', 'display: none');
			$("#ReqUserNM").val("${sessionScope.loginInfo.sessionUserNm}");
			$("#requestUserID").val("${sessionScope.loginInfo.sessionUserId}");
		} else {
			$("#searchRequestBtn").attr('style', 'display: done');
			$("#ReqUserNM").val("");
			$("#requestUserID").val("");
		}
	}
	
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
		fnSelect('srArea2', data, 'getSrArea2', '', 'Select');
	}
	
	function searchPopupWf(avg){
		var searchValue = $("#ReqUserNM").val();
		if(searchValue == ""){
			alert("${WM00034_3}");
			return;
		}
		var url = avg + "&searchValue=" + encodeURIComponent($('#ReqUserNM').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3){
		// window.opener.setSearchNameWf(avg1, avg2, avg3, $('#objId').val(), $('#objName').val());
		$("#ReqUserNM").val(avg2+"("+avg3+")");
		$("#requestUserID").val(avg1);
	}

	function fnCreateItem(){	
		$("#addNewItem").removeAttr('style', 'display: none');
		
		
		$("#divTapItemAdd").removeAttr('style', 'display: none');
		$("#transDiv").attr('style', 'display: none');
		$("#moveOrg").attr('style', 'display: none');		
		$("#newIdentifier").focus();
		
	}
	

	function setItemIDs() {
		var items = "";
		if(grid != undefined) {
			items = grid.data.getInitialData().filter(e => e.checkbox).map(e => e.ItemID).join(",");
		}
		
		$("#itemIDs").val(items);
	}
	

	function newItemInsert(addYN){
		// 입력 필수 체크 : 계층, 명칭, CSR 입력 필수
		if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
		var newItemName = encodeURIComponent($("#newItemName").val());
		
		if(confirm("${CM00009}")){		
		
			var url = "createItemForSR.do";
			var data = "s_itemID="+$("#parentID").val()+"&option=${option}&authorID=${sessionScope.loginInfo.sessionUserId}"
						+"&itemClassCode="+$("#classCode").val()
						+"&itemTypeCode=${stItemType}"
						+"&newIdentifier="+$("#newIdentifier").val()
						+"&newItemName="+newItemName
						+"&projectID=${projectID}"
						+"&srID=${getMap.SRID}"
						+"&addYN="+addYN;
						
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function doReturnInsert(addYN, itemID){
			
		setPropItemList(itemID);
		
		$("#newIdentifier").val("");
		$("#newItemName").val("");
		$("#parentNM").val("");
		$("#parentID").val("");
		
		if(addYN == "Y"){	
			$("#addNewItem").attr('style', 'display: done');	
			$("#divTapItemAdd").attr('style', 'display: done');
		}else{	
			$("#addNewItem").attr('style', 'display: none');	
			$("#divTapItemAdd").attr('style', 'display: none');
			
		}
		
		doSearchList();
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doCallBack(){}
	
	// After [Add -> Assign]
	function setParentItem(parentItemId, parentItemPath){
		$("#parentID").val(parentItemId);
		$("#parentNM").val(parentItemPath);
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}	
	
	function fnAssignItem(){
		
		$("#newItemArea").attr("style", "display:none;");
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		
		var connectionType = "To";
		var s_itemID = $("#srArea2").val();
		
		if(s_itemID == "" || s_itemID == undefined){
			alert("${srAreaLabelNM2} Select");
		}
		else {
			var url = "itemTypeCodeTreePop.do";
			var data = "openMode=assign&ItemTypeCode=${stItemType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&tFilterCode=PRM"
						+"&rootItemID="+s_itemID+"&connectionType=" + connectionType;
						
			fnOpenLayerPopup(url,data,doCallBack,617,436);
		}
	
	}

	//After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		
		setPropItemList(checkedItems);
		
		doSearchList();
		$(".popup_div").hide();
		$("#mask").hide();	
		
	}
	
	function setPropItemList(avg) {
		if(propItemList == "") {
			propItemList = avg;
		}
		else {
			propItemList = propItemList + "," + avg;
		}
	}
	
	function searchPopupWf(avg){
		var searchValue = $("#ReqUserNM").val();
		if(searchValue == ""){
			alert("${WM00034_3}");
			return;
		}
		var url = avg + "&searchValue=" + encodeURIComponent($('#ReqUserNM').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3){
		// window.opener.setSearchNameWf(avg1, avg2, avg3, $('#objId').val(), $('#objName').val());
		$("#ReqUserNM").val(avg2+"("+avg3+")");
		$("#requestUserID").val(avg1);
	}
	
	function addSharer(){
		var sharers = $("#sharers").val();
		

		var url = "selectMemberPop.do?mbrRoleType=R&projectID=${projectID}&s_memberIDs="+sharers;
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	
	function addApprover(){
		var approvers = $("#approvers").val();
		
		var url = "selectMemberPop.do?mbrRoleType=APRV&projectId=${projectID}&s_memberIDs="+approvers
				+"&addApprover=Y&notInRoleCat=SRRoleTP";
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
	}
	
	function setApprovers(memberIds,memberNames) {
		$("#approvers").val(memberIds);
		$("#approverNames").val(memberNames);
	}

	function fnMSClear(){
		//input[type=text]::-ms-clear
		//$("#Identifier").attr('disabled',true);
	}
	
	function fnChangeCategory(SRCatID){
		$.ajax({
			url: "getSRCatAttrList.do",
			type: 'post',
			data: "&SRCatID="+SRCatID,
			error: function(xhr, status, error) { 
			},
			success: function(obj){			
				$("#srCatAttrData").val(obj);
				var jsonObj = JSON.parse(obj); 
				
				var attrTypeCodes = new Array(); var i=0;
				var catAttrAreaHtml = "";	
				if(jsonObj != ""){
					catAttrAreaHtml = "<table class='tbl_brd mgT5' style='table-layout:fixed;' width='100%'  cellpadding='0' cellspacing='0'>";
					catAttrAreaHtml	+= "<colgroup><col width='15%'><col><col width='15%'><col></colgroup>";	
					jsonObj.forEach(function (data) {	
						attrTypeCodes[i] = data.AttrTypeCode; i++;
						var dataType = data.DataType;
						var HTML = data.HTML;
						if(dataType == "Text"){
							if(HTML == "1"){
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
								if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
								catAttrAreaHtml += "</th><td class='last sline tit pdR10' colspan=3 style='height:"+data.AreaHeight+"px;'>";
								catAttrAreaHtml += "<textarea class='tinymceText' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' style='width:100%;height:"+data.AreaHeight+"px;'></textarea>";
							}else{
								catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
								if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
								catAttrAreaHtml += "</th><td class='sline tit last' colspan=3>";
								catAttrAreaHtml += "<input type='text' class='text' id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"' value='' placeholder='"+data.DefaultValue+"' onfocus=this.placeholder='' onblur=this.placeholder='' style='ime-mode:active;' />";
							}
						}else if(dataType == "LOV"){							
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>" + data.AttrTypeName;
							if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
							catAttrAreaHtml += "</th><td class='sline tit last' colspan=3>";							
							catAttrAreaHtml += "<select id='"+data.AttrTypeCode+"' name='"+data.AttrTypeCode+"'  class='sel' OnChange=fnGetSubAttrTypeCode('"+data.AttrTypeCode+"','"+data.SubAttrTypeCode+"',this.value); >";
							catAttrAreaHtml += "<option value=''>Select</option>";  
							data.lovList.forEach(function (lovData) {	
								catAttrAreaHtml += "<option value='"+lovData.CODE+"'>" + lovData.NAME + "</option>";  
							});
							catAttrAreaHtml += "</select>";
							
						}else if(dataType == "MLOV"){
							catAttrAreaHtml += "<tr><th class='alignL pdL10'>"+ data.AttrTypeName;
							if(data.Mandatory == "1") catAttrAreaHtml += "<p style='display:inline;color:#FF0000;'>&nbsp;*</p>";
							catAttrAreaHtml += "</th><td class='sline tit last' colspan=3>";							
							data.MLovList.forEach(function (MLovData) {	
								catAttrAreaHtml += "<input type='checkbox' id='"+data.AttrTypeCode + MLovData.CODE+"' name='"+data.AttrTypeCode + MLovData.CODE+"' value='"+MLovData.CODE+"' >"; 
								catAttrAreaHtml += "&nbsp;&nbsp;" + MLovData.NAME +"&nbsp;&nbsp;&nbsp;&nbsp;";
							});
						}
						catAttrAreaHtml += "</td></tr>";
					});
					catAttrAreaHtml	+= "</table>";
					$("#attrTypeCodes").val(attrTypeCodes);
					
				}else{
					$("#attrTypeCodes").val("");
				}
				$('#srCatAttrArea').html(catAttrAreaHtml);
				
				jsonObj.forEach(function (data) {				
					var dataType = data.DataType;
					var HTML = data.HTML;
					if(HTML == "1"){
						tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, data.AttrTypeCode);
						tinyMCE.EditorManager.execCommand('mceAddEditor', false, data.AttrTypeCode);
					}
				});
			}
		});	
	}
	
	function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
		if(subAttrCode != "" && subAttrCode != null){			
			var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
			fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
		}
	}
	
	function fnCheckSRCatAttr(){
		var attrChecked = true;
		var SRCatID = $("#category").val();
		var checkedMLOV = 0;
		var srCatAttrData = $("#srCatAttrData").val();		
		var jsonObj = JSON.parse(srCatAttrData); 

		if(jsonObj != ""){					
			jsonObj.forEach(function (data) {	
				var mandatory = data.Mandatory;
				var dataType = data.DataType;						
				var attrTypeName = data.AttrTypeName;
				if(mandatory == "1"){
					if(dataType == "MLOV"){
						data.MLovList.forEach(function (MLovData) {	
							if(document.all(data.AttrTypeCode + MLovData.CODE).checked == true){
								checkedMLOV = checkedMLOV + 1;
							}
						});
						if(checkedMLOV == 0){
							attrChecked = false; 									
							alert("<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00007' arguments='"+data.AttrTypeName+"' />");									
							return false;
						}else{
							attrChecked = true;
							return false;
						}
					}else{
						if($("#"+data.AttrTypeCode).val() == ""){								
							alert("<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00007' arguments='"+data.AttrTypeName+"' />");
							attrChecked = false; 
							return false;
						}else{
							attrChecked = true;
							return false;
						}
					}
				}
			});
		} 
		return attrChecked;
	}
	
	
</script>
</head>

<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
</style>

<body>
<div>
	<form name="srFrm" id="srFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}" />
	<input type="hidden" id="proposal" name="proposal" value="${proposal}" />
	<input type="hidden" id="itemIDs" name="itemIDs" value="" />
	<input type="hidden" id="fromSRID" name="fromSRID" value="${fromSRID}" />
	<div class="cop_hdtitle mgT">
		<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00280}</h3>
	</div>
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>		
		<c:if test="${fromSRID == '' || fromSRID == null }">
		<tr>
		    <th class="alignL pdL10" style="height:15px;">${menu.LN00025}(&nbsp;self : <input type="checkbox" id="self" name="self" OnClick="fnCheckRequest()" checked>&nbsp;) </th>
		  	<td class="sline tit last" >
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${sessionScope.loginInfo.sessionUserNm}" style="ime-mode:active;width:250px;" />
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<input type="image" class="image" id="searchRequestBtn" name="searchRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL')" value="검색">
			</td>
			<th class="alignL pdL10">${menu.LN00212}</th>
			<td class="sline tit last">${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})</td>
		</tr>
		</c:if>
		<!-- 등록자 -->
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10">${srAreaLabelNM1}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:250px">
	       			<option value=''>Select</option>
	     	  	</select>
			</td>
			<!-- 시스템 -->
			 <th class="alignL pdL10">${srAreaLabelNM2}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="srArea2" Name="srArea2" style="width:250px">
         		   <option value=''>Select</option>
         		  </select>
			</td>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;" onchange="fnChangeCategory(this.value);"></select>
			</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input type="text" id="reqDueDateTime" name="reqDueDateTime" class="input_off text" size="8" style="width:20%; text-align: center;" maxlength="10" value="18:00:00">
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">요청 목적 및 사유</th>
			<td class="sline tit last" colspan="3" >
				<input type="text" class="text" id="opinion" name="opinion" value="" style="ime-mode:active;" placeholder="※ 현재 업무 대비 영향도 및 요청자의 요청 의도를 정확히 확인하기 위해 꼭 기입해주시기 바랍니다."/>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th><!-- 제목 -->
			<td class="sline tit last" colspan="3" >
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active; " />
			</td>
		</tr>		
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td style="height:300px; width:100%;" class="tit last">
				<textarea class="tinymceText" id="description" name="description" ></textarea>					
			</td>
		</tr>	
	</table>
	<div id="srCatAttrArea"></div>
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>	
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10" style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items" style="display:none;"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${itemFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
					<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></c:if>
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="sharerNames" name="sharerNames" />			
				<input type="hidden" class="text" id="sharers" name="sharers" size="10"/>
			</td>
		</tr>	
		<%-- LF 반영 시 주석해제 --%>
		<%-- <tr>
			<th class="alignL pdL10"><a onclick="addApprover();">추가 승인자 설정<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="approverNames" name="approverNames" placeholder="기본 승인자는 LF 조직정보 기준으로 요청자의 상위자(ex.팀장)로 자동설정됩니다. 추가 승인자가 필요할 경우 등록하세요." readonly/>			
				<input type="hidden" class="text" id="approvers" name="approvers" size="10"/>
			</td>
		</tr> --%>
	</table>
	
	<div id="itemListTR" style="display:none;padding-top:10px;">		
		<li class="org_title">
           <h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Item List</h3>
        </li>		
		<li class="floatR" style="padding-bottom:5px;">	
			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="fnCreateItem()" ></a></span>&nbsp;
			<span class="btn_pack small icon"><span class="add"></span><input value="Assign" type="submit" id="newButton1"  onclick="fnAssignItem()" ></a></span>&nbsp;
		</li>		
		<li>
			<div id="layout" style="width:100%;height:200px;"></div>
		</li>
	</div>
	<div id="divTapItemAdd" class="ddoverlap mgB5" style="display: none;">
		<ul>
			<li class="selected" ><a><span>${menu.LN00096}</span></a></li>
		</ul>
	</div>
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<th>${menu.LN00015}</th>
			<th>${menu.LN00028}</th>
			<th>${menu.LN00016}</th>
			<th class="last">Parent Code</th>
		</tr>
		<tr>
			<td style="width:15%"><input type="text" class="text" id="newIdentifier" name="newIdentifier"  value=""/></td>
			<td><input type="text" class="text" id="newItemName" name="newItemName"  value=""/></td>	
			
            <td>
            	<select id="classCode" name="classCode" style="width:100%;" >
                    <option value="">Select</option>    
				</select>
			</td>		
			<td class="last" style="width:30%">
				<input type="text" class="text" id="parentNM" name="parentNM"  value="" onClick="itemTypeCodeTreePop()" readonly="readonly"/>
				<input type="hidden"  id="parentID" name="parentID"  value=""/>
			</td>
		</tr>	
		<tr>
			<td colspan="4" class="last" align="right">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert()"  type="submit"></span>&nbsp;
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save and Add" onclick="newItemInsert('Y')"  type="submit"></span>&nbsp;
			</td>
		</tr>						
	</table>
	
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">	
	<tr> 
		 <th class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="4"  style="vertical-align:middle;" >
			<!-- span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span -->
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="fnSaveSR()"></span>&nbsp;&nbsp;
		 </th>		 
	</tr>
	</table>
	<div class="alignR pdL10">${menu.LN00291}</div>

	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center" },
	        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}", align:"center" }], align:"center"},
	        { width: 200, id: "ItemNM", header: [{text: "${menu.LN00028}", align:"center"}]},
	        { width: 300, id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }], align:"center"},
	        { width: 80, id: "StatusNM", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center"},
	        { width: 80, id: "AuthorName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
	        { width: 100, id: "LastUpdated", header: [{ text: "ITO ${menu.LN00070}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	layout.getCell("a").attach(grid);
	
	function doSearchList(){
		var sqlID = "esm_SQL.getSrItemList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&authorID=${sessionScope.loginInfo.sessionUserId}&isNew=Y"
			+ "&itemTypeCode=${stItemType}"
			+ "&itemIDs=" + propItemList
			+ "&status=REL"
			+ "&sqlID="+sqlID;
			
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox") {
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ItemID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,row.ItemID);
		}
	});
</script>
</body>
</html>
