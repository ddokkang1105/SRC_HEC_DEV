<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/" var="root"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	
	// 게시글에 이미 첨부되어있던 파일들 정보 >> 작업 필요
	var previousAddedBoardFilesRaw = "${attachFileList}";
	
	// JSON이 아니라서 변경 필요함... 키=값 형식을 "키":"값" 형식으로 변환
	function javaObjToArr(str) {
    
	    if (str == "") return [];
	    
	    // 키=값 형식을 "키":"값" 형식으로 변환
	    let jsonStr = str.replace(/(\w+)=/g, '"$1":');
	    
	    // 빈 값 먼저 처리
	    jsonStr = jsonStr.replace(/:\s*([,\}\]])/g, ':""$1');
	    
	    // 값을 따옴표로 감싸기 (숫자 제외)
	    jsonStr = jsonStr.replace(/:([^,\}\]]+)/g, (match, value) => {
	        value = value.trim();
	        
	        // 이미 빈 문자열로 처리된 경우
	        if (value === '""') {
	            return ':' + value;
	        }
	        
	        // 숫자인지 확인 (정수 또는 소수)
	        if (!isNaN(value) && value !== '') {
	            return ':' + value;
	        }
	        
	        // 이미 따옴표가 있는지 확인
	        if (value.startsWith('"') && value.endsWith('"')) {
	            return ':' + value;
	        }
	        
	        return ':"' + value + '"';
	    });
	    
	    return JSON.parse(jsonStr);
	}
	
	var fileObjArray = javaObjToArr(previousAddedBoardFilesRaw);
	
	// FileRealName만 추출하여 Set으로 반환
	function extractFileRealNamesToSet(str) {
		if (str == []) return new Set();
	
		return new Set(str.map(item => item.FileRealName));
	}
	
	function removeBySeqInPlace(arr, seqValue) {	
		const index = arr.findIndex(item => item.Seq == seqValue);
		if (index !== -1) {
		  arr.splice(index, 1);
		}
		return arr;
	}

	// 파일명만 Set으로 저장
	var previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);

	var screenType = "${screenType}";
	// Admin으로 넘어옴 > 안씀
	
	var scrnType = "CS";
	// 고정값. 이걸로써야함
	
	var docCategory = "CS";
	var mgtId = "${resultMap.BoardMgtID}";
	var boardId = "${resultMap.BoardID}";
	
	var itemClassCode = "";
	
	var documentId = "";
	
	var projectId = "${getData.ProjectID}";
	
	var changeSetId ="${getData.ChangeSetID}";
	
</script>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_1" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_2" arguments="${menu.LN00023}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00023" var="CM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00024" var="CM00024" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_3" arguments="${menu.LN00290}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_4" arguments="${menu.LN00017}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_5" arguments="${menu.LN00022}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_6" arguments="${menu.LN00296}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00172" var="WM00172" />

<script type="text/javascript">

 	var revListSize = "${revisionList.size()}";
 	var nOdListSize = "${nOdList.size()}";
 	var changeType = "${getData.ChangeTypeCode}";

	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
				
		$('#saveChangeSetInfo').click(function(e){
			saveChangeSetInfo();
		});
		
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		fnSelect('changeType', data+"&category=CNGT1", 'getDictionaryOrdStnm', '${getData.ChangeTypeCode}', 'Select');	
		
		if(document.getElementById('itemListBox')!=null&&document.getElementById('itemListBox')!=undefined){
			document.getElementById('itemListBox').style.height = (setWindowHeight() - 460)+"px";			
			window.onresize = function() {
				document.getElementById('itemListBox').style.height = (setWindowHeight() - 480)+"px";	
			};
		}
		var desHeight = 150;
		
		if(revListSize < 1) {
			desHeight += 40;
		}
		
		if(nOdListSize < 1) {
			desHeight += 40;
		}

		$("#description").attr("style","width:100%;height:"+desHeight+"px;");
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// [List] click
	function goBack() {
		var isItemInfo = "${isItemInfo}";
		var isStsCell = "${isStsCell}";
		var isMyTask = "${isMyTask}";
		var url = "changeInfoList.do"; // 변경항목 목록으로 이동
		var target = "help_content";
		var data = "ProjectID=${ProjectID}&mainMenu=${mainMenu}&screenMode=${screenMode}" 
			+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isNew=${isNew}"
			+ "&currPageA=${currPageA}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}"
			+ "&isMyTask=${isMyTask}";
			
		if (isItemInfo == "Y" && isStsCell == "Y") {
			url = "itemHistory.do"; // 변경이력
			data = "s_itemID=${seletedTreeId}";
		}
		if (isMyTask == "Y") {
			url = "myChangeSet.do";
		}
		
		ajaxPage(url, data, target);
	}
	
	// [Save] click
	function saveChangeSetInfo() {

		var changeType = $("#changeType").val();		
		if(changeType == ""){
			alert("${WM00085_5}"); return;
		}
		if(confirm("${CM00023}")){ 			
			var url = "admin/saveNewChangeSet.do";
			ajaxSubmit(document.changeInfoEditFrm, url);
		}
	}
	
	function fnCallBack(checkInOption){
		let scrnType = "${scrnType}";
		if(checkInOption == "03" || checkInOption == "03B"){			
		    dhx.confirm({
		        text: "${CM00061}",
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
				if(result){
					window.goApprovalPop();
				}
				var isItemInfo = "${isItemInfo}";
				if(isItemInfo == "Y"){
					if(scrnType == "pop"){
						window.fnItemMenuReload();
					}else{
						window.parent.olm.getMenuUrl('${s_itemID}');
					}
				}else{
					window.doSearchCngtList();
				}
				if (window.currentDhxModal) {
				    window.currentDhxModal.close();
				}
		    });
		}else{
			var isItemInfo = "${isItemInfo}";
			if(isItemInfo == "Y"){
				if(scrnType == "pop"){
					window.fnItemMenuReload();
				}else{ window.parent.olm.getMenuUrl('${s_itemID}'); }
			}else if($.isFunction(window.doSearchCngtList)){ window.doSearchCngtList(); 
			}else {window.doSearchList();}
			if (window.currentDhxModal) {
			    window.currentDhxModal.close();
			}
		}
	}
	
	function fnEvaluation(){ 
		$("#evDiv").attr("style","visibility:visible");
	}
	
	function fnSaveEvaluation(){
		if (confirm("${CM00001}")) {
			var url = "saveEVSore.do";			
			ajaxSubmit(document.changeInfoEditFrm, url, "saveFrame");
		}
	}
	
	function fnSetEvScore(evScore,attrTypeCode,lovCode){
		$("#evScore"+attrTypeCode).val(evScore);
		$("#lovCode"+attrTypeCode).val(lovCode);
	}

	function fnCallBackAppr(){
		var url = "viewItemChangeInfo.do"
		var data = "changeSetID=${getData.ChangeSetID}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=${mainMenu}&seletedTreeId=${seletedTreeId}"
			+ "&screenMode=view&isMyTask=Y&isItemInfo=${isItemInfo}";
		var target = "changeInfoEditFrm";
		
		ajaxPage(url, data, target);
	}
	
	function fnCallBackSave(){
		var url = "editItemChangeInfo.do"
		var data = "changeSetID=${getData.ChangeSetID}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=${mainMenu}&seletedTreeId=${seletedTreeId}"
			+ "&screenMode=edit&isMyTask=Y&isItemInfo=${isItemInfo}";
		var target = "changeInfoEditFrm";
		
		ajaxPage(url, data, target);
	}
	
	// 최신 changeSet 이전 changSet 정보 
	function fnOpenViewVersionItemInfo(changeSetID){
		var projectID = "${ProjectID}";
		var authorID = "${getData.AuthorID}";
		var status = "${StatusCode}"
		var version = "${getData.Version}";
		var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}"
					+"&changeSetID="+changeSetID
					+"&projectID="+projectID
					+"&authorID="+authorID
					+"&status="+status
					+"&version="+version;
		window.open(url,'window','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
	}
		
	// [Item] click
	function goItemPopUp(avg1) {
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	
	// [Check in] Click 
	function fnCheckInItem() {
		var description = $("#description").val();
		var version = $("#version").val();		
		var validFrom = $("#ValidFrom").val().replace(/(^\s*)|(\s*$)/gi, "");
		var changeType = $("#changeType").val();
		var checkInOption = "${checkInOption}";
		var changeReviewCnt = "${changeReviewCnt}";
		
		if(confirm("${CM00049}")){	
			if(version == ""){
				alert("${WM00085_4}"); return;
			}else if(description == ""){
				alert("${WM00085_3}"); return;
			}else if(validFrom == null || validFrom == ""){
				alert("${WM00085_6}"); return;
			}else if ((checkInOption == "01B" || checkInOption == "03B") && changeReviewCnt == "0")
				if(confirm("${WM00172}") == false) return;
			
			var items = "${getData.ItemID}";
			var cngts = "${getData.ChangeSetID}";
			var pjtIds = "${getData.ProjectID}";
			var uploadToken = "${uploadToken}";
			
			var url = "checkInMgt.do";
			var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds + "&description="+encodeURIComponent(description)+"&version="+version+"&validFrom="+validFrom
						+"&changeType="+changeType+"&checkInOption="+checkInOption+"&uploadToken="+uploadToken;
			var target = "saveFrame";
			
			ajaxPage(url, data, target);
		}
	}

	function goApprovalPop() {
		var url = "${wfURL}.do?";
		var data = "isPop=Y&changeSetID=${getData.ChangeSetID}&isMulti=N&wfDocType=CS&ProjectID=${getData.ProjectID}&docSubClass=${getData.ItemClassCode}";
				
		var w = 1200;
		var h = 700; 
		itmInfoPopup(url+data,w,h);
		
	}
	
	function goWfStepInfo(wfDocType,wfUrl,wfInstanceID) {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = wfUrl;
		var data = "isNew=Y&wfDocType="+wfDocType+"&isMulti=Y&isPop=Y&categoryCnt=1&changeSetID=${getData.ChangeSetID}&wfInstanceID="+wfInstanceID;
				
		ajaxPage(url,data,"changeInfoEditFrm");
	}

	function setSubFrame() {
		
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
		ajaxSubmitNoAdd(document.changeInfoEditFrm, url,"saveFrame");
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=CS";
		ajaxSubmitNoAdd(document.changeInfoEditFrm, url,"saveFrame");
	}

	function fnDeleteItemFile(seq){
	
		fileObjArray = removeBySeqInPlace(fileObjArray, seq);
		previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);
	    
		var url = "changeSetFileDelete.do";
		var data = "&delType=1&fltpCode=CSDOC&seq="+seq;
		ajaxPage(url, data, "saveFrame");

		var divId = "divDownFile"+seq;
		$('#'+divId).remove();
		
	}

	function setChsFrame(avg){
		
		for(var i=1; i < 4; i++) {
			if(i == avg) {
				$("#tabList"+i).attr("style","display:block;");
				$("#pliOM"+i).addClass("on");
			}
			else {
				$("#tabList"+i).attr("style","display:none;");
				$("#pliOM"+i).removeClass("on");
			}
		}
		
	}
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=CS&id=${getData.ChangeSetID}&docCategory=CS&fltpCode=CSDOC&projectID=${getData.ProjectID}";
		openPopup(url+"?"+data,490,450, "Attach File");
	} 
	
	function openDhxVaultModal(){		
		// dhtmlx 윈도우로 vault 띄우기
		newFileWindow.show();
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
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+', true)">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){		
		var fileName = document.getElementById(fileID)?.innerText;
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));

		
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
	
</script>

<form name="changeInfoEditFrm" id="changeInfoEditFrm" enctype="multipart/form-data" action="#" method="post" onsubmit="return false;">
<div id="changeInfoEditDiv" class="hidden" style="overflow:auto; overflow-x:hidden; padding: 6px 6px 6px 6px;" >
	<!-- SKON CSRF 보안 조치 -->
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />

	<input type="hidden" id="LanguageID" name="LanguageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="itemId" name="itemId" value="${getData.ItemID}">
	<input type="hidden" id="AuthorID" name="AuthorID" value="${getData.AuthorID}" />
	<input type="hidden" id="ProjectID" name="ProjectID" value="${getData.ProjectID}" />
	<input type="hidden" id="ChangeSetID" name="ChangeSetID" value="${getData.ChangeSetID}" />
	<input type="hidden" id="screenMode" name="screenMode" value="${screenMode}" />
	<input type="hidden" id="StatusCode" name="StatusCode" value="${StatusCode}" />
	<input type="hidden" id="StatusCode" name="CSRStatusCode" value="${CSRStatusCode}" />
	<input type="hidden" id="item" name="item" value="" />
	<input type="hidden" id="cngt" name="cngt" value="" />
	<input type="hidden" id="pjtId" name="pjtId" value="" />
	<input type="hidden" id="evaluationClassCode" name="evaluationClassCode" value="${evaluationClassCode}" />
	<input type="hidden" id="attrTypeCodeList" name="attrTypeCodeList" value="${attrTypeCodeList}" />
	<input type="hidden" id="dataTypeList" name="dataTypeList" value="${dataTypeList}" />
	<input type="hidden" id="evType" name="evType" value="${evType}" />
	<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
	
	<!-- 화면 타이틀 : view - 변경항목 상세 조회, edit - 변경항목 상세 내역 편집 -->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 6px">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
				${menu.LN00207}
		</h3>
	</div>
	<div id="tblChangeSet" style="width:99%">	

	<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<table style="table-layout:fixed;" class="tbl_blue01 mgT10">
			<colgroup>
				<col width="10%"/>
				<col width="22%"/>
				<col width="10%"/>
				<col width="22%"/>
				<col width="10%"/>
				<col width="23%"/>			
			</colgroup>
			<tr>
				
				<!-- ID -->
				<th  class="viewtop alignL pdL10">${menu.LN00106}</th>
				<td  class="viewtop">${getData.Identifier}</td>
				<!-- 명칭 -->
				<th  class="viewtop alignL pdL10">${menu.LN00028}</th>
				<td  class="viewtop">${getData.ItemName}	</td>
				<!-- Version -->
				<th  class="viewtop alignL pdL10">${menu.LN00017}</th>
				<td  class="viewtop last">
						<input type="text" id="version" name="version" value="${getData.Version}" class="text" style="width:100%">
				</td>
			
	         <tr>				
				<!-- 담당자 -->				
				<th  class="alignL pdL10">${menu.LN00004}</th>
				<td>${getData.AuthorName}</td>
				<!-- 상태 -->
				<th  class="alignL pdL10">${menu.LN00027}</th>
				<td>${getData.StatusName}</td>
				<!-- 변경구분 -->
				<th class="alignL pdL10">${menu.LN00022}</th> 
					<td class="last">
						<select id="changeType" name="changeType" style="width:100%"></select>						
					</td>
			
			</tr>				
			<tr>	
				<!-- 생성일/완료일 -->				
				<th  class="alignL pdL10">${menu.LN00013}/${menu.LN00064}</th>
				<td>${getData.CreationTime} ${getData.CompletionDTYNMark} ${getData.CompletionDT}</td>	
				
				<!-- 승인일 -->				
				<th  class="alignL pdL10">${menu.LN00095}</th>
				<td>${getData.ApproveDate}</td>
				
				<!-- 시행일 -->				
				<th class="alignL pdL10">${menu.LN00296}</th>
				<td class="last alignL">
				 <input type="text" id="ValidFrom" name="ValidFrom" value="${fn:trim(getData.ValidFrom)}"	class="input_off datePicker stext" size="8"
						style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
				</td>
			</tr>
			
			<tr>
				<!-- 참조문서 -->
				<th class="alignL pdL10">${menu.LN00122}</th>
				<td colspan="5" style="height:53px;" class="alignL pdL5 last">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
							<c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID && fileList.DocCategory != 'ITM'}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('${fileList.Seq}')"></c:if>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			<tr>
				<!-- 개요 -->
				<th  class="alignL pdL10">${menu.LN00290}</th>
					<td colspan="5" class="last alignL pdL5">
					  <textarea class="edit" id="description" name="description" style="width:100%;height:150px;">${getData.Description}</textarea>
					</td>
			</tr>
			<tr>
	           <td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9" >  		
	           		<c:if test="${fileTypeCount >= 1}">
						<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp;
		        	</c:if>
		        	<span class="btn_pack medium icon"><span class="save"></span><input id="saveChangeSetInfo" value="Save" type="submit"></span>
	        		<span class="btn_pack medium icon"><span class="confirm"></span><input value="Check in" onclick="fnCheckInItem()" type="submit"></span> 
        	   </td>
      		</tr>
		</table>
				
		<c:if test="${revisionList.size() > 0}">	
   			<span class="cop_hdtitle">＊ ${menu.LN00205}</span>
     		<div style="width:100%;height:150px;overflow:auto;">
			<table class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" border="0">
				<colgroup>
					<col width="11%">
					<col width="30%">
					<col width="11%">
					<col width="67%">
				</colgroup>
				<tr>
					<th class="last">${menu.LN00106}</th>
					<th class="last">${menu.LN00028}</th>
					<th class="last">${menu.LN00016}</th>
					<th class="last">${menu.LN00290}</th>
				</tr>	
				<c:forEach var="rList" items="${revisionList}" varStatus="status">
				<tr>
					<td class="alignC pdL5 last">
						${rList.Identifier}
					</td>
					
					<td class="alignC pdL5 last">
						${rList.ItemName}
					</td>
					<td class="alignC pdL5 last">
						${rList.ClassName}
					</td>
					<td class="alignC pdL5 last" style="cursor:pointer;" onClick="goItemPopUp('${rList.ItemID}')">
						${rList.Description}
					</td>
				</tr>												
				</c:forEach>	
			</table>
		</div>
		</c:if>
		<c:if test="${nOdList.size() > 0 && getData.ChangeTypeCode == 'MOD' }">	
	   		<span class="cop_hdtitle">＊ New / Deleted Item list</span>
	     	<div id="itemListBox" style="width:100%;overflow:auto;">
			<table class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" border="0">				
				<colgroup>
					<col width="10%">
					<col width="30%">
					<col width="10%">
					<col width="40%">
					<col width="10%">
				</colgroup>
				<tr>
					<th class="last">${menu.LN00106}</th>
					<th class="last">${menu.LN00028}</th>
					<th class="last">${menu.LN00042}</th>
					<th class="last">${menu.LN00043}</th>
					<th class="last">${menu.LN00013}</th>
				</tr>
				<c:forEach var="list" items="${nOdList}" varStatus="status">
				<tr>
					<td class="alignC pdL5 last">
						${list.Identifier}
					</td>
					<td class="alignC pdL5 last">
						${list.ItemName}
					</td>
					<td class="alignC pdL5 last">
						${list.StatusName}
					</td>
					<td class="alignC pdL5 last">
						${list.Path}
					</td>
					<td class="alignC pdL5 last">
						${list.CreationTime}
					</td>
				</tr>												
				</c:forEach>	
			</table>
			</div>
		</c:if>    
	</table>
	</div>
</div>
</form>

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
