<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
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
	
	// FileRealName만 추출하여 Set으로 반환
	function extractFileRealNamesToSet(str) {
		if (str == "") return new Set();
		
		const arr = javaObjToArr(str);
		return new Set(arr.map(item => item.FileRealName));
	}

	// 파일명만 Set으로 저장
	var previousAddedFileNames = extractFileRealNamesToSet(previousAddedBoardFilesRaw);

	var scrnType = "BRD";
	// 고정값. 이걸로써야함
	
	var docCategory = "BRD";
	var mgtId = "${BoardMgtID}";
	var boardId = "${BoardID}";
	
	var itemClassCode = "";
	
	var documentId = "";
	
	var projectId = "";
	
	var changeSetId ="";
	
</script>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />

<script type="text/javascript">
//script에러 방지용 cosole선언
var console = console || {
	log:function(){},
	warn:function(){},
	error:function(){}
};

////////////////////////////////////////////////////
//파일 업로드 처리 이동 [fileAttachHelper.js]
////////////////////////////////////////////////////
var screenType = "${screenType}";
var emailCode = "${emailCode}";	
$(document).ready(function() {
	$("#send").click(function(e) {
		if(confirm("${CM00001}")){
			var actionUrl = "saveForumReply.do";
			ajaxSubmit(document.editRelyFrm, actionUrl);
		}
	});
	$('#back').click(function(e){
		doReturn();
	});
});

function fnDeleteItemFile(BoardID, seq){
	var url = "boardFileDelete.do";
	var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
	ajaxPage(url, data, "blankFrame");
	
	$('#divDownFile'+seq).remove();	
}


function doReturn(){
	var listType = "${listType}";
	var url = "viewForumPost.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
		+ "&noticType=${noticType}" 
		+ "&boardID=${parentID}" 
		+ "&BoardMgtID=${BoardMgtID}" 
		+ "&s_itemID="+$('#s_itemID').val()
		+ "&ItemID="+$('#ItemID').val()
		+ "&userId="+$('#userId').val()
		+ "&privateId="+$('#privateId').val()
		+ "&filter=editEnd"
		+ "&pageNum=${pageNum}"
		+ "&isMyCop=${isMyCop}"
		+ "&screenType=${screenType}"
		+ "&projectID=${projectID}"
		+ "&scStartDt=${scStartDt}"+"&scEndDt=${scEndDt}"
		+ "&mailRcvListSQL=${mailRcvListSQL}"
		+ "&emailCode="+emailCode
		+ "&searchType=${searchType}&listType=${listType}&srID=${srID}";
	if(listType == 1){data = data + "&s_itemID="+$('#s_itemID').val();}		
		
	var target = "help_content";
	ajaxPage(url, data, target);
}

function fileNameClick(avg1){
	var url  = "fileDown.do?seq=" + avg1 + "&scrnType=BRD";
	ajaxSubmitNoAdd(document.editRelyFrm, url,"saveFrame");
}

//************** addFilePop V4 설정 START ************************//
function doAttachFileV4(){
	var url="addFilePopV4.do";
	var data="scrnType=BRD&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
	openPopup(url+"?"+data,480,450, "Attach File");
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

//addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
function fnDeleteFileMapV4(fileID, removeAll){ 
	if(removeAll == "Y"){
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}else{
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
	}
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
	var fileName = fileName = document.getElementById(fileID).innerText;
	//console.log("fnDeleteFileHtml fileID : "+fileID+" , fileName  :"+fileName); // fileID.textContent
	
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
}
//************** addFilePop V4 설정 END ************************//

</script>

<div class="mgL10 mgR10">
	<form name="editRelyFrm" id="editRelyFrm" enctype="multipart/form-data" action="registerForumReply.do" method="post" onsubmit="return false;">
			<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
			<input type="hidden" id="noticType" name="noticType" value="${noticType}">
			<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
			<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
			<input type="hidden" id="parentID" name="parentID" value="${parentID}">
			<input type="hidden" id="boardID" name="boardID" value="${boardID}">
			<input type="hidden" id="boardID" name="BoardMgtID" value="${BoardMgtID}">
			<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
			<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}">
			<input type="hidden" id="deleteSeq" name="deleteSeq">
			<input type="hidden" id="replyLev" name="replyLev" value="1">
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
			<input type="hidden" id="parentRefID" name="parentRefID" value="${parentRefID}">
			<input type="hidden" id="searchType" name="searchType" value="${searchType}" />
			<input type="hidden" id="searchValue" name="searchValue" value="${searchValue}" />
			<input type="hidden" id="scStartDt" name="scStartDt" value="${scStartDt}" />
			<input type="hidden" id="scEndDt" name="scEndDt" value="${scEndDt}" />	
			<input type="hidden" id="screenType" name="screenType" value="${screenType}" />	
			<input type="hidden" id="listType" name="listType" value="${listType}" />	
			<input type="hidden" id="memberID" name="memberID" value="${memberID}" />	
			<input type="hidden" id="subject" name="subject" value="${subject}" />
			<input type="hidden" id="emailCode" name="emailCode" value="${emailCode}" />
			
		<div id="commentDiv" class="hidden" style="width: 100%;" align="center">	
				
		<!--  cop reply -->
		<div>
			<c:if test="${empty boardID}">			
				<div class="cop_hdtitle">
					<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/comment_user.png">&nbsp;&nbsp;Write Reply&nbsp;</h3>
				</div>
			</c:if>
			<c:if test="${!empty boardID}">			
				<div class="cop_hdtitle mgB5" style="border-bottom:1px solid #ccc;">
					<h3><img src="${root}${HTML_IMG_DIR}/comment_user.png">&nbsp;&nbsp;Edit Reply&nbsp;</h3>
				</div>
			</c:if>
			<div>
				<table class="tbl_brd" id="projList" style="table-layout:fixed;" width="100%"	cellpadding="0" cellspacing="0" >
					<colgroup>
						<col>
						<col width="85%">
					</colgroup>
					
					<!-- 첨부문서 -->
					<th class="viewtop" style="height:53px;">${menu.LN00111}</th>
					<td style="height:53px;" class="alignL pdL5 last">
						<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:if test="${itemFiles.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
						</c:if>
						</div>
						<c:forEach var="fileList" items="${fileList}" varStatus="status">
							<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
								<c:if test="${sessionScope.loginInfo.sessionUserId == regUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></c:if>
								<br>
							</div>
						</c:forEach>
						</div>
					</td>
					<tr>
						<td colspan="2" style="height: 260px;padding:5px 5px 5px 5px;" align="center" class="tit last">
							<textarea class="edit" name="content_new" id="content_new" style="width:100%;height:260px" >${content}</textarea>
						</td>
					</tr>		
							
				</table>

		</div>	
		<div class="clear"></div>
			<div class="alignBTN">
				<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="send"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" id="back"></span>
			</div>
		<!-- //cop reply -->			
				
				
				
		</div>
		</div>	
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</div>