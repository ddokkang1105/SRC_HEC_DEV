<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var sessionLoginId="${sessionScope.loginInfo.sessionLoginId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	var screenType = "${screenType}";	
	//var tinyEditorType = "MAX";
</script><!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var ClosingDT = "${resultMap.ClosingDT}";

	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
	//	jQuery("#Subject").focus();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		//fnSelect('project', data, 'getPjtMbrRl', templProjectID, 'Select');
		//fnSelect('project', data, 'getPjtMbrRl', '${resultMap.ProjectID}', 'Select');
		fnSelect('project', data, 'getESPCustomerList', '${resultMap.ORGNZT_ID}', 'Select', 'esm_SQL');
		// fnSelect('division', data, 'getFaqType', '${resultMap.FAQ_TYPE}', 'Select', 'zDLM_SQL');
		
		if( ClosingDT != "" && ClosingDT != null){
			var checkObj = document.all("noticeYN");
			checkObj.checked=true;
			$("#closingCalDp").attr('style', 'display: done');	
			$("#noticeYN").val("Y");
		}
	});
	function doSave(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		fnCheckUrgncyYN()
		var url  = "zDlm_saveBoard.do";
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
					+"&projectCategory=${projectCategory}"
					+"&boardTypeCD=MN194";
					
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
	
	
	
	function fnDeleteItemFile(atchFileId, seq){
		var url = "zDlm_boardFileDelete.do";
		var data = "&delType=1&atchFileId="+atchFileId+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");
		
		$('#divDownFile'+seq).remove();	
	}
	
	//*************** addFilePop 설정 **************************//
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=BRD&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		openPopup(url+"?"+data,480,450, "Attach File");
	}
	
	var fileIDMap = new Map();
	var fileNameMap = new Map();

	function fnDeleteFileHtml(seq, fileName){			
		if(fileName == "" || fileName == undefined){
			try{fileName = document.getElementById(seq).innerText;}catch(e){}
		}
		
		fileIDMap.delete(String(seq));
		fileNameMap.delete(String(seq));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+seq).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}
	}
	
	function fnAttacthFileHtml(fileID, fileName){ 		
		fileIDMap.set(fileID,fileID);
		fileNameMap.set(fileID,fileName);
	}
	
	function fnDisplayTempFile(){
		var sampleTimestamp = Date.now(); //현재시간 타임스탬프 13자리 예)1599891939914
				
		display_scripts=$("#tmp_file_items").html(); 
		fileIDMap.forEach(function(fileID) {			  
			  display_scripts = display_scripts+
				'<div id="'+fileID+sampleTimestamp+'"  class="mm" name="'+fileID+sampleTimestamp+'">'+ fileNameMap.get(fileID) +
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+fileID+sampleTimestamp+')">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMap = new Map();
		fileNameMap = new Map();
	}
	//*************** addFilePop 설정 **************************//
	
	
	//************** addFilePop V4 설정 START ************************//
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
		//console.log("fnDeleteFileHtml fileID : "+fileID+" , fileName  :"+fileName); // fileID.textContent
		
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
		var url  = "zDlm_fileDownload.do?seq="+seq+"&scrnType=BRD";
		debugger;
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
		var url  = "zDlm_fileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}
	
	function fnCheckUrgncyYN(){
		var checkObj = document.all("urgncyYN");
		if( checkObj.checked == true){ 
			$("#urgncyYN").val("Y");
			checkObj.value="Y";
		} else {
			$("#urgncyYN").val("N");
			checkObj.value="N";
		}
	}
</script>
<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10">
	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="faqID" name="faqID" value="${resultMap.FAQ_ID}">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${resultMap.BoardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${resultMap.BoardID}">
		<input type="hidden" id="screenType" name="screenType" value="${screenType}">
		<input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${defBoardMgtID}" >
		<input type="hidden" id="likeInfo" name="likeInfo" value="${resultMap.LikeInfo}" >
		<input type="hidden" id="RegUserID" name="RegUserID" value="${resultMap.RegUserID}" >
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${boardMgtName}&nbsp;${menu.LN00108}</h3>
		</div>
		<div id="boardDiv" class="hidden" style="width:100%;height:500px;">
		<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>		
			<tr>
				<th>${menu.LN00002}</th>
				<td class="sline tit last" colspan="7">
					<input type="text" class="text" id="Subject" name="Subject" value="${resultMap.QESTN_SJ}" size="150" style="margin-left=5px;" />
				</td>
			</tr>			
			<tr>
				<th>${menu.LN00131}</th>
				<td class="sline tit last" colspan="2">
					<select id="project" name="project" class="sel" style="width:100%; max-width:190px;"></select>
				</td>		
				<th>${menu.ZLN0020}</th>
				<td class="sline tit last" colspan="2">
					<select id="division" name="division" class="sel" style="width:100%; max-width:190px;">
					<option value="FAQ00001" ${resultMap.FAQ_TYPE == 'FAQ00001' ? 'selected' : ''}>FAQ</option>
      				<option value="FAQ00002" ${resultMap.FAQ_TYPE == 'FAQ00002' ? 'selected' : ''}>소프트웨어자료</option>
      					 <option value="FAQ00003" ${resultMap.FAQ_TYPE == 'FAQ00003' ? 'selected' : ''}>시스템매뉴얼</option>
					</select>
				</td>
				<th>${menu.ZLN0017}</th>
				<td class="sline tit last" colspan="1">
					<input type="checkbox" id="urgncyYN" name="urgncyYN" value="Y" ${resultMap.URGNCY_YN == 'Y' ? 'checked' : ''}>&nbsp&nbsp긴급</input>
				</td>	
			</tr>
			<!-- 신규 등록 일때, 작성자 등록일 화면 표시 안함 -->
			<c:if test="${NEW == 'N'}">
				<tr>
					<th class="sline" style="height:20px;">${menu.LN00212}</th>
					<td colspan="2" id="TD_WRITE_USER_NM" class="alignL pdL10 " >
						${resultMap.FRST_REGISTER_ID}
					</td>
					<th class="sline">${menu.LN00078}</th>
					<td colspan="2" class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
						${resultMap.FRST_REGIST_PNTTM}
					</td>
					<td colspan="2" class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
					</td>
				</tr>
			</c:if>
<%-- 			<c:if test="${CategoryYN == 'Y'}">
				<tr>				
					<th style="height:20px;">${menu.LN00033}</th>
					<td class="sline tit last">	
						<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
					</td>
					
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last">Yes&nbsp;
						<input type="checkbox" id="noticeYN" name="noticeYN" value="" onClick="fnCheckNoticeYN();" >&nbsp;
						<span id="closingCalDp" style="display:none;">
						Expiration date&nbsp;&nbsp;
							<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
							style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
						
						</span>
					</td>	
				</tr>
			</c:if>
			<c:if test="${CategoryYN != 'Y'}">
				<tr>				
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last" colspan="3">Yes&nbsp;
						<input type="checkbox" id="noticeYN" name="noticeYN" value="" onClick="fnCheckNoticeYN();" >&nbsp;
						<span id="closingCalDp" style="display:none;">
							Expiration date&nbsp;&nbsp;
								<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
								style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</span>
					</td>	
				</tr>
			</c:if> --%>
			<tr>
				<!-- 첨부문서 -->
				<th style="height:53px;">${menu.LN00111}</th>
				<td colspan="7" style="height:53px;" class="alignL pdL5 last">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<div class="floatR pdR20" id="divFileImg">
					<c:if test="${itemFiles.size() > 0}">
						<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
						<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
					</c:if>
					</div>
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
						<div id="divDownFile${fileList.fileSn}"  class="mm" name="divDownFile${fileList.fileSn}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.fileSn}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.fileSn}');">${fileList.orignlFileNm}</span>
							<c:if test="${sessionScope.loginInfo.sessionLoginId == resultMap.FRST_REGISTER_ID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.atchFileId}','${fileList.fileSn}')"></c:if>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			</table>
			<table class="tbl_brd" width="100%"  cellpadding="0"  cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>	
			<tr>
				<th>${menu.LN00003}</th>
				<td colspan="4" style="height: 400px;" align="center" class="tit last">
					<div style="width:100%;height:400px">
					<textarea class="tinymceText" id="Content" name="Content" >${resultMap.QESTN_CN}</textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th>${menu.ZLN0021}</th>
		  		<td colspan="4" style="height:400px;" align="center" class="tit last">
		  			<div style="width:100%;height:400px">
						<textarea class="tinymceText" id="Answer" name="Answer" >${resultMap.Answer}</textarea>
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
			<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>&nbsp;&nbsp;
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="doSave()"></span>&nbsp;&nbsp;
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
		</div>
	<!-- END :: Button -->
	</div>

	</form>

</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>