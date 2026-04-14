<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	
	// 게시글에 이미 첨부되어있던 파일들 정보
	var previousAddedBoardFilesRaw = "${itemFiles}";
	
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
	
	var scrnType = "BRD";
	// 고정값. 이걸로써야함
	
	var docCategory = "BRD";
	var mgtId = "${resultMap.BoardMgtID}";
	var boardId = "${resultMap.BoardID}";
	
	var itemClassCode = "";
	
	var documentId = "";
	
	var projectId = "";
	
	var changeSetId ="";
	
</script>
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<style>
.new-form .tmp_file_wrapper td {
    padding: 8px 10px;
}

.new-form input[type=checkbox]+label {
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    color: #222;
    display: inline-block;
    line-height: 20px;
    min-height: 20px;
    padding-left: 22px;
    position: relative;
    vertical-align: top;
    margin-right: 16px;
    padding-right: 0
}

.new-form input[type=checkbox]+label:before {
	    content: "";
	    display: inline-block;
	    width: 16px;
	    height: 16px;
	    left: 0;
	    position: absolute;
	    top: 2px;
	    border: 1px solid #ddd;
	    box-sizing: border-box;
}
</style>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var ClosingDT = "${resultMap.ClosingDT}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
	//	jQuery("#Subject").focus();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		//fnSelect('project', data, 'getPjtMbrRl', templProjectID, 'Select');
		fnSelect('project', data, 'getPjtMbrRl', '${resultMap.ProjectID}', 'Select');
		fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
		
		if( ClosingDT != "" && ClosingDT != null){
			var checkObj = document.all("noticeYN");
			checkObj.checked=true;
			$("#closingCalDp").attr('style', 'display: inline-block');	
			$("#noticeYN").val("Y");
		}
	});
	function doSave(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		var url  = "saveBoard.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}

	function doLike(likeInfo){
		if(likeInfo == 'N'){
			if(!confirm("${CM00001}")){ return;}
		}
		else if(likeInfo == 'Y') {
			if(!confirm("Do you really cancel Like ?")){ return;}
		}
		var url  = "saveBoardLike.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		if(isNotEmptyById("Subject", true)==false){return false;}
		//if(!fnTypingCheck("Content", 5000)){ return false;} 
		return isCheck;
	}
	function doDelete(){
		//$add("BoardID", "${resultMap.BoardID}", boardFrm);
		if(confirm("${CM00002}")){
			var url = "deleteBoard.do";
			ajaxSubmit(document.boardFrm, url,"blankFrame");
		}
	}	
	
	function doReturn(BoardMgtID, screenType){ 	
		var url = "boardList.do";
		var data = "pageNum=${pageNum}&url=${url}&screenType=${screenType}&s_itemID=${projectID}"; 
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnGoList(){
		var back = "&scStartDt=${scStartDt}"
					+"&searchKey=${searchKey}"
					+"&searchValue=${searchValue}"
					+"&scEndDt=${scEndDt}"
					+"&projectCategory=${projectCategory}";
					
		if(screenType == "Admin"){
			goList(false, screenType, "${projectID}","${category}","${categoryIndex}","${categoryCnt}",back);
		}else{
			var url = "boardList.do";
			var data = "BoardMgtID=${BoardMgtID}&pageNum=${pageNum}"
						+"&url=${url}&screenType=${screenType}"
						+"&s_itemID=${projectID}&defBoardMgtID=${defBoardMgtID}" 
						+"&category=${category}"
						+back
						+"&categoryIndex=${categoryIndex}"
						+"&categpryCnt=${categoryCnt}"; 
			var target = "help_content";
			ajaxPage(url, data, target);
		}
	}
	
	function fnRealod(){
		var isNew="N"; var boardMgtID=$("#BoardMgtID").val(); var boardID=$('#BoardID').val();
		goDetail(isNew,boardMgtID, boardID);
		//document.location.reload();
	}
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		//fnOpenLayerPopup(url,data,"",400,400);
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	// 기존 파일 삭제
	function fnDeleteItemFile(BoardID, seq){
		$("#"+seq).remove();
		
        fileObjArray = removeBySeqInPlace(fileObjArray, seq);
        previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);
		
		var url = "boardFileDelete.do";
		var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");		
		
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0)
			document.querySelector("#tmp_file_wrapper").style.display = "none";
	}
	
	//*************** addFilePop 설정 **************************//
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=BRD&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		openPopup(url+"?"+data,480,450, "Attach File");

	}
	
	function openDhxVaultModal(){		
		// dhtmlx 윈도우로 vault 띄우기
		newFileWindow.show();
	}
		
	//************** addFilePop V4 설정 START ************************//	
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
		let display_scripts = "";
		fileIDMapV4.forEach(function(fileID) {
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+', true)" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
				'<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
				'<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
				'</tr>';
			}
		});
		
		document.querySelector("#tmp_file_items").children.namedItem("file-list").insertAdjacentHTML("beforeend",display_scripts);
		document.querySelector("#tmp_file_wrapper").style.display = "block";
	}
	
	//  임시파일 삭제
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){
		
		// doDeleteFromVault : vault에서도 지우세요~!
		// editboard에서 함수 호출 시 => vault에서도 지워주도록 하는 용도
		// vault에서 직접 afterRemove로 호출될 시 false로 넘겨서 editboard에서 제거 후, vault에서도 제거 중복해 시도되는 것 방지
	
		var fileName = document.getElementById(fileID)?.children.namedItem("fileName").innerHTML;

		console.log("fnDeleteFileHtmlV4 실행: ", fileID, fileName, doDeleteFromVault);
		
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
							// console.log("vault에서 제거: ", vaultFileId);				
							vault.data.remove(vaultFileId);
						}
					} catch(e) {
						console.error("Vault에서 파일 삭제 중 오류:", e);
					}
				} else {
					console.error("Vault 모달이 존재하지 않음");
					console.log(vault);
				}
			}
		}
		
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0)
			document.querySelector("#tmp_file_wrapper").style.display = "none";
	}
	//************** addFilePop V4 설정 END ************************//
	
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
	
	function fnCheckNoticeYN(){
		var checkObj = document.all("noticeYN");
		if( checkObj.checked == true){ 
			$("#closingCalDp").attr('style', 'display: inline-block; position: relative;');	
			$("#noticeYN").val("Y");
		} else {
			$("#closingDT").val("");
			$("#closingCalDp").attr('style', 'display: none');
			$("#noticeYN").val("N");
		}
	}
</script>
<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10">
	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${resultMap.BoardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${resultMap.BoardID}">
		<input type="hidden" id="screenType" name="screenType" value="${screenType}">
		<input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${defBoardMgtID}" >
		<input type="hidden" id="likeInfo" name="likeInfo" value="${resultMap.LikeInfo}" >
		<input type="hidden" id="RegUserID" name="RegUserID" value="${resultMap.RegUserID}" >
		<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${boardMgtName}&nbsp;${menu.LN00108}</h3>
		</div>
		<div id="boardDiv" class="hidden" style="width:100%;height:500px;">
		<table class="form-column-8 new-form" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>		
			<tr>
				<th>${menu.LN00002}</th>
				<td class="sline tit last" >
					<input type="text" class="text" id="Subject" name="Subject" value="${resultMap.Subject}" size="60"  />
				</td>
				<th>${menu.LN00131}</th>
				<td class="sline tit last">
					<select id="project" name="project" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>		
			</tr>			
			<!-- 신규 등록 일때, 작성자 등록일 화면 표시 안함 -->
			<c:if test="${NEW == 'N'}">
				<tr>
					<th class="sline" style="height:20px;">${menu.LN00212}</th>
					<td id="TD_WRITE_USER_NM" class="alignL pdL10 " >
						${resultMap.WriteUserNM}
					</td>
					<th class="sline">${menu.LN00070}</th>
					<td class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
						${resultMap.ModDT}
					</td>
				</tr>
			</c:if>
			<c:if test="${CategoryYN == 'Y'}">
				<tr>				
					<th style="height:20px;">${menu.LN00033}</th>
					<td class="sline tit last">	
						<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
					</td>
					
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last btns">
						Yes&nbsp;
						<input type="checkbox" id="noticeYN" name="noticeYN" value="" onClick="fnCheckNoticeYN();" >&nbsp;
						<span id="closingCalDp" style="display:none;">
						Expiration date&nbsp;&nbsp;
							<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
							style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
						</span>
						 -->
					</td>	
				</tr>
			</c:if>
			<c:if test="${CategoryYN != 'Y'}">
				<tr>				
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last" colspan="3">
						<span class="flex align-center">
							<input type="checkbox" name="noticeYN" value="" id="noticeYN" onclick="fnCheckNoticeYN();" />
		       				<label for="noticeYN">Yes</label>
							<span id="closingCalDp" style="display:none;">
								<span style="position: relative;top: 2px;">Expiration date</span>
								<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
								style="width: 95px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							</span>
						</span>
					</td>	
				</tr>
			</c:if>
			<tr>
				<!-- 첨부문서 -->
				<th>${menu.LN00111}</th>
				<td colspan="3">
					<div id="tmp_file_wrapper" class="tmp_file_wrapper btns" style="width:50%; <c:if test="${empty itemFiles}">display:none;</c:if>">
						<table id="tmp_file_items" name="tmp_file_items" width="100%">
							<colgroup>
							<col width="40px">
							<col width="">
							<col width="70px">
							</colgroup>
							<tbody name="file-list">
								<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
									 <tr id="${fileList.Seq}" name="${fileList.Seq}">
										<td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>
										<td name="fileName" onclick="fileNameClick('${fileList.Seq}');" style="cursor: pointer;">${fileList.FileRealName}</td>
<!-- 										<td class="alignR"><script>getFileSize(fileSizeMapV4.get(fileID))</script></td> -->
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- 
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
					 -->
				</td>
			</tr>
			</table>
			<table width="100%"  cellpadding="0"  cellspacing="0">
			<tr>
				<td colspan="4" style="height: 400px;" align="center" class="tit last">
					<div style="width:100%;height:400px">
						<textarea class="tinymceText" id="Content" name="Content" >
							<c:choose>
								<c:when test="${NEW eq 'Y'}">${dicInfo.Description}</c:when>
								<c:otherwise>${resultMap.Content}</c:otherwise>
							</c:choose>
						</textarea>
					</div>
				</td>
			</tr>			
			</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN">
			<c:if test="${NEW == 'N' && LikeYN == 'Y'}">
				<span id="saveLike" style="float:left;">
					<img src="${root}${HTML_IMG_DIR}/Like${resultMap.LikeInfo}.png" onclick="doLike('${resultMap.LikeInfo}')" style="width:25px;height:25px;cursor:pointer;">
				</span>
				<span style="float:left;padding-top:5px;">(${likeCNT})</span>
			</c:if>&nbsp;&nbsp;			
			<span id="viewFile" class="btn_pack medium icon">
				<span class="upload"></span>
				<input value="Attach" type="submit" onclick="openDhxVaultModal()">
			</span>&nbsp;&nbsp;
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="doSave()"></span>&nbsp;&nbsp;
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
		</div>
	<!-- END :: Button -->
	</div>

	</form>

</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>