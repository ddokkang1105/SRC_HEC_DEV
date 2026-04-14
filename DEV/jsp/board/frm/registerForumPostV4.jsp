<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>


<script type="text/javascript">
var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
var screenType = "${screenType}";
var RegUserId = ""; // fetch 후 세팅 (새 글 작성 시에는 초기값 없음)
var NEW = "Y"; // 새 글 작성 페이지이므로 기본값은 'Y'

var fileObjArray = []; // 현재 임시 저장된 파일 목록 (Dhtmlx Vault 연동)
var previousAddedBoardFilesRaw = "${itemFiles}";

window.scrnType = "BRD"; var scrnType = "BRD";
window.docCategory = "BRD"; var docCategory = "BRD";

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
	
</script>

<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00245}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00389}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015_1" arguments="검토기한"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015_2" arguments="${menu.LN00389}"/>


<style>
.new-form .tmp_file_wrapper td { padding: 8px 10px; }
.new-form input[type=checkbox]+label {
    box-sizing: border-box; color: #222; display: inline-block;
    line-height: 20px; min-height: 20px; padding-left: 22px;
    position: relative; vertical-align: top; margin-right: 16px; padding-right: 0
}
.new-form input[type=checkbox]+label:before {
    content: ""; display: inline-block; width: 16px; height: 16px;
    left: 0; position: absolute; top: 2px;
    border: 1px solid #ddd; box-sizing: border-box;
}
</style>

<script type="text/javascript">

	//URL 파라미터에서 초기값 가져오기 (read-only)
	const urlParams = new URLSearchParams(window.location.search);
	window.mgtId = urlParams.get('boardMgtID') || "${forumDTO.boardMgtID}"; // DTO에서 가져오거나 URL에서 가져옴
	window.forumID = urlParams.get('boardID') || "${forumDTO.boardID}";
	var itemClassCode = urlParams.get('itemClassCode') || "";
	window.documentId = urlParams.get('documentID') || "${forumDTO.boardID}";
	var projectId = urlParams.get('projectID') || "";
	var changeSetId = urlParams.get('changeSetID') || "";
	var uploadToken = urlParams.get('uploadToken') || ""; // URL에서 uploadToken 가져오기
	var noticType = urlParams.get('noticType') || "";
	var emailCode = urlParams.get('emailCode') || "";
	var mailRcvListSQL = urlParams.get('mailRcvListSQL') || "";
	var showItemInfo = urlParams.get('showItemInfo') || "";
	var forumMailOption = urlParams.get('forumMailOption') || "";
	var showReplyDT = urlParams.get('showReplyDT') || "";
	var openDetailSearch = urlParams.get('openDetailSearch') || "";
	var boardTitle = urlParams.get('boardTitle') || "";
	var categoryYN = "${categoryYN}"; // cmmMap에서 받아오는 값
	var dueDateMgt = urlParams.get('dueDateMgt') || "";
	var showAuthorInfo = urlParams.get('showAuthorInfo') || "";
	var showItemVersionInfo = urlParams.get('showItemVersionInfo') || "";
	
	var fileSize = "0"; // 초기 파일 사이즈 (새 글이므로 0)
	var templProjectID = urlParams.get('templProjectID') || "${forumDTO.templProjectID}";
	var projectType = urlParams.get('projectType') || "${forumDTO.projectType}";
	var ClosingDT = ""; // 공지사항 만료일

	jQuery(document).ready(function() {
		// Datepicker 초기화 - 공통함수 호출
		if (typeof fnCallDatePicker === "function") {
			fnCallDatePicker();
		}

		// 초기 데이터 로딩 (새 글이므로 초기값만 세팅)
		setupInitialData();
		
		// 저장 버튼 클릭 이벤트
		$("#send").click(function(e) {
			if(validateForm()){
				if(confirm("${CM00001}")){
					doSaveForumPost();
				}
			}
		});
		
		// 취소 버튼 클릭 이벤트
		$('#back').click(function(e){
			fnGoForumList();
		});

		// TinyMCE 에디터 초기화
        setTimeout(() => {
            if(typeof tinyMCE !== 'undefined' && tinyMCE.get('Content')) { // 대문자 'Content'도 확인
                tinyMCE.get('Content').setContent(""); 
            } else if(typeof tinyMCE !== 'undefined' && tinyMCE.get('content')) { // 소문자 'content'도 확인
                tinyMCE.get('content').setContent(""); 
            }
        }, 500);
	});

	// 초기 데이터 설정 (새 글 작성 시 필요한 기본값 설정)
	async function setupInitialData() {
		document.getElementById('boardMgtID').value = window.mgtId; // BoardMgtID 값 할당
		const today = new Date();
		const yyyy = today.getFullYear();
		const mm = String(today.getMonth() + 1).padStart(2, '0'); 
		const dd = String(today.getDate()).padStart(2, '0');
		const formattedDate = yyyy+'-'+mm+'-'+dd;

		// 작성일자 (showAuthorInfo가 'Y'일 때)
		if(showAuthorInfo === "Y" && document.getElementById('writeDate')) {
			document.getElementById('writeDate').value = formattedDate;
		}
		
		// 서버에서 초기 데이터 로드
		try {
			const response = await fetch("getRegisterForumPostData.do?boardMgtID=" + mgtId + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sessionUserId=${sessionScope.loginInfo.sessionUserId}&projectType=" + projectType + "&templProjectID=" + templProjectID);
			const data = await response.json();

			if (data.success) {
				// uploadToken 설정
				if(document.getElementById('uploadToken')) {
					document.getElementById('uploadToken').value = data.uploadToken;
					window.uploadToken = data.uploadToken;
				}
				// 게시판 이름 업데이트
				if(data.boardMgtName) {
					boardTitle = data.boardMgtName;
					document.querySelector('.pdB15.mgT10 .align-center p').innerHTML = boardTitle + '&nbsp;&gt;&nbsp;Write';
				}
				// CategoryYN 업데이트
				if(data.CategoryYN) {
					categoryYN = data.CategoryYN;
				}
				// ItemMgtUserMap 업데이트 (필요시)
				if(data.ItemMgtUserMap && document.getElementById('itemMgtUserID')) {
					document.getElementById('itemMgtUserID').value = data.ItemMgtUserMap.AuthorID;
				}
			} else {
				alert("초기 데이터 로드 실패: " + data.message);
			}
		} catch (error) {
			console.error("Error fetching initial data:", error);
			alert("초기 데이터를 가져오는 중 오류가 발생했습니다.");
		}

		// 카테고리 셀렉트 박스
		var sData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&boardMgtID=" + mgtId + "&projectType=" + projectType + "&templProjectID=" + templProjectID;
		fnSelect('category', sData, 'getBoardMgtCategory', '', 'Select'); // 새 글이므로 초기 선택값 없음
	}

	// 폼 유효성 검사
	function validateForm() {
		if ($("#subject").val() === "") {
			alert("${WM00034_3}"); // 제목
			return false;
		}
		if (mailRcvListSQL === "manual" && $("#sharers").val() === "") {
			alert("${WM00034_1}"); // 검토자
			return false;
		}
		if ((emailCode === "REQITMRW" || emailCode === "BRDMAIL" || mailRcvListSQL === "review" || dueDateMgt === "Y") && $("#SC_END_DT").val() === "") {
			alert("${WM00034_2}"); // 검토기한/만료일
			return false;
		}
		
		const today = new Date();
		const yyyy = today.getFullYear();
		const mm = String(today.getMonth() + 1).padStart(2, '0'); 
		const dd = String(today.getDate()).padStart(2, '0');
		const formattedDate = yyyy+'-'+mm+'-'+dd;

		if ($("#SC_END_DT").val() !== "" && $("#SC_END_DT").val() < formattedDate) {
			alert("${WM00015_1}"); // 검토기한/만료일이 오늘보다 이전
			return false;
		}
		return true;
	}

	// 게시글 저장 함수 (기존 saveForumPost.do URL 사용)
	function doSaveForumPost(){ 
		// TinyMCE 에디터의 최신 내용을 Content 필드에 반영
		if(typeof tinyMCE !== 'undefined' && tinyMCE.get('Content')) { // 대문자 'Content'도 확인
	$("#Content").val(tinyMCE.get('Content').getContent());
	} else if(typeof tinyMCE !== 'undefined' && tinyMCE.get('content')) { // 소문자 'content'도 확인
	$("#content").val(tinyMCE.get('content').getContent());
	}
		var url  = "saveForumPost.do"; // 기존 URL 재사용
		console.log(document.boardFrm);
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}
	
	// 명시적으로 전역 객체에 바인딩 (iframe에서 호출 가능하도록)
	window.doReturn = function() {
		fnGoForumList();
	};
	window.fnCallback = function() {
		fnGoForumList();
	};

	// 목록으로 돌아가기 함수
	function fnGoForumList(){
		var url = "boardForumList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&BoardMgtID=" + mgtId
				+ "&pageNum=1"
				+ "&screenType=" + screenType
				+ "&boardTitle=" + encodeURIComponent(boardTitle)
				+ "&noticType=" + noticType
				+ "&category=" + categoryYN
				+ "&listType=" + (urlParams.get("listType") || "1")
				+ "&showItemInfo=" + showItemInfo
				+ "&showAuthorInfo=" + showAuthorInfo
				+ "&showItemVersionInfo=" + showItemVersionInfo
				+ "&dueDateMgt=" + dueDateMgt;
				
		var s_itemID = "${forumDTO.s_itemID}";
		
		if(s_itemID) {
			data += "&s_itemID=" + s_itemID;
		}
		
		ajaxPage(url, data, "help_content");
	}

	// Sharer (검토자/공유자) 추가 팝업
	function addSharer(){
		var projectID = $("#project").val();
		var sharers = $("#sharers").val();
		var url = "selectMemberPop.do?mbrRoleType=R&&s_memberIDs="+sharers;
		window.open(url,"schedlFrm","width=900 height=700 resizable=yes");			
	}
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
		$("#sharerNamesText").val(memberNames);
	}

	// 게시판 category별 가이드라인
	async function setGuideLineforCat(typeCode){
		if(typeCode !== undefined && typeCode !== null && typeCode !== ''){
			const response = await fetch("/getDictionary.do?category=BRDCAT&typeCode=" + typeCode + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
			const data = await response.json();
			if(data !== undefined && data !== null && data !== '') {
				if(data.data.Description !== undefined && data.data.Description !== null && data.data.Description !== ''){
					tinyMCE.get('content').setContent(data.data.Description);
				}
			}
		}
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
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
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

		let fileFormat = "";
		fileIDMapV4.forEach(function(fileID) {
			fileFormat = fileNameMapV4.get(fileID).split(".")[1];
			switch (true) {
				case fileFormat.includes("do") : fileFormat = "doc"; break;
				case fileFormat.includes("xl") : fileFormat = "xls"; break;
				case fileFormat.includes("pdf") : fileFormat = "pdf"; break;
				case fileFormat.includes("hw") : fileFormat = "hwp"; break;
				case fileFormat.includes("pp") : fileFormat = "ppt"; break;
				default : fileFormat = "log"
			}
			  display_scripts = display_scripts+
			  	'<li id="'+fileID+'"  class="flex icon_color_inherit justify-between mm align-center" name="'+fileID+'">'+ 
				'<span><span class="btn_pack small icon mgR25">'+
				'	<span class="'+fileFormat+'"></span></span>' +
				'	<span style="line-height:24px;">'+fileNameMapV4.get(fileID) + '</span></span>' +
				'<i class="mdi mdi-window-close" onclick="fnDeleteFileHtmlV4('+fileID+', true)"></i>'+
				'</li>';
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: block;');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	
	//  임시파일 삭제 
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){			
		var fileName = document.getElementById(fileID)?.innerText;
		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
// 		fileSizeMapV4.delete(String(fileID));
		
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
		
		if(!document.querySelector("#tmp_file_items").innerHTML) {
			document.querySelector("#tmp_file_items").style.display = "";
		}
	}
	//************** addFilePop V4 설정 END ************************//
	
	// Attach 버튼 클릭 시 Dhtmlx Vault 모달 띄우기 (기존 openDhxVaultModal 사용)
	function openDhxVaultModal(){
		newFileWindow.show();
	}

	function fnCheckNoticeYN(){
		if($("#noticeYN").is(":checked")){ $("#closingCalDp").show(); $("#noticeYN").val("Y"); }
		else { $("#closingDT").val(""); $("#closingCalDp").hide(); $("#noticeYN").val("N"); }
	}
</script>

<div class="pdB15 mgT10" style="width: 70%; margin: 0 auto;">
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveForumPost.do" method="post" onsubmit="return false;">
		<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
		<input type="hidden" id="noticType" name="noticType" value="${noticType}">
		<input type="hidden" id="boardMgtID" name="BoardMgtID" value="${mgtId}">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${forumDTO.s_itemID}" />
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
		<input name="userId" id="userId" type="hidden" value="${sessionScope.loginInfo.sessionUserId}" />
		<input name="date" id="date" type="hidden"/> 
		<input type="hidden" id="screenType" name="screenType" value="${screenType}" />
		<input type="hidden" id="projectID" name="projectID" value="${projectId}" />
		<input type="hidden" id="srID" name="srID" value="${srID}" />
		<input type="hidden" id="srType" name="srType" value="${srType}" />
		<input type="hidden" id="instanceNo" name="instanceNo" value="${instanceNo}" />
		<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetId}" />
		<input type="hidden" id="boardMgtName" name="boardMgtName" value="${boardMgtName}" />
		<input type="hidden" id="mailRcvListSQL" name="mailRcvListSQL" value="${mailRcvListSQL}" />
		<input type="hidden" id="emailCode" name="emailCode" value="${emailCode}" />
		<input type="hidden" name="itemMgtUserID" id="itemMgtUserID" value="${ItemMgtUserMap.AuthorID}" />
		<input type="hidden" name="showItemInfo" id="showItemInfo" value="${showItemInfo}" />
		<input type="hidden" name="forumMailOption" id="forumMailOption" value="${forumMailOption}" />
		<input type="hidden" name="showReplyDT" id="showReplyDT" value="${showReplyDT}" />
		<input type="hidden" name="openDetailSearch" id="openDetailSearch" value="${openDetailSearch}" />
		<input type="hidden" name="boardTitle" id="boardTitle" value="${boardTitle}" />
		<input type="hidden" name="categoryNM" id="categoryNM" value="" />
		 <input type="hidden" name="blocked" id="blocked" value="0"/>
		<c:if test="${dueDateMgt eq 'Y'}">
		<input type="hidden" name="dueDateMgt" id="dueDateMgt" value="${dueDateMgt}" />
		</c:if>

		<div class="align-center flex justify-between pdT10 pdB10"  style="border-bottom: 1px solid #dfdfdf;">
			<p style="font-size: 15px;color: #b0b0b0;">${boardTitle}&nbsp;&gt;&nbsp;Write</p>
		</div>
		<ul>
			<li class="flex align-center pdT40 pdB5">
				<c:if test="${categoryYN == 'Y'}">
				<div class="align-center flex" style="flex: 2 1 0;">
					<h3 class="tx">${menu.LN00002 }</h3>
					<span class="wrap_sbj">
						<input type="text" name="subject" id="subject">
					</span>
				</div>
				</c:if>
				<c:if test="${categoryYN != 'Y'}">
				<div class="align-center flex" style="flex: 2 1 0;">
					<h3 class="tx">${menu.LN00002 }</h3>
					<span class="wrap_sbj">
						<input type="text" name="subject" id="subject">
					</span>
				</div>
				</c:if>
				<c:if test="${dueDateMgt eq 'Y' || mailRcvListSQL eq 'review'}">
					<div class="align-center flex" style="  width:25%; margin-left: 30px;  ">
					<h3 class="tx">
						<c:choose>
							<c:when test="${mailRcvListSQL eq 'review'}">검토기한</c:when>
							<c:otherwise>${menu.LN00389 }</c:otherwise>
						</c:choose>
					</h3>
					<span class="wrap_sbj">
						<input type="text" id="SC_END_DT"	name="scEndDt" class="text datePicker" size="10" style="width: 175px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</span>
					</div>
				</c:if>
			</li>
			
			<!-- 담당자, 담당부서,작성일자 -->
			<c:if test="${showAuthorInfo eq 'Y'}">
			<li class="flex align-center pdT5 pdB5">	
				<div class="align-center flex" style="width:35%;">
					<h3 class="tx">
						${menu.LN00060 } 
					</h3>
					<span class="wrap_sbj">
						<input type="text" name="writeNM" id="writeNM" value="${sessionScope.loginInfo.sessionUserNm}" readonly>
					</span>
				</div>
				<div class="align-center flex" style="width:35%; margin-left: 30px;">
					<h3 class="tx">
						${menu.LN01008 }
					</h3>
					<span class="wrap_sbj">
						<input type="text" name="writerTM" id="writerTM" value="${sessionScope.loginInfo.sessionTeamName}" readonly>
					</span>
				</div>
				<div class="align-center flex" style="width:25%; margin-left: 30px;">
					<h3 class="tx">작성일자</h3>
					<span class="wrap_sbj">
						<input type="text" name="writeDate" id="writeDate" style="width: 180px;" readonly>
					</span>
				</div>
			</li>
			</c:if>
			
			<li class="flex align-center pdT5 pdB5">
			<c:if test="${showItemVersionInfo eq 'Y'}">
				<div class="align-center flex" style="width:35%;">
					<h3 class="tx">문서번호</h3>
					<span class="wrap_sbj">
						<input type="text" name="docID" id="docID" value ="${identifier}" readonly>
					</span>
				</div>
				<div class="align-center flex" style="width:35%; margin-left: 30px;">
					<h3 class="tx">문서명</h3>
					<span class="wrap_sbj">
						<input type="text" name="docTitle" id="docTitle" value="${docTitle}"readonly>
					</span>
				</div>
				<div class="align-center flex" style="width:25%; margin-left: 30px;">
					<h3 class="tx">개정번호</h3>
					<span class="wrap_sbj">
						<input type="text" name="version" id="version" style="width: 180px;" value="${itemVersion}" readonly>
					</span>
				</div>
			</c:if>
			</li>
			
			<li class="flex align-center pdT5 pdB5">
			<c:if test="${categoryYN eq 'Y'}">
				<div class="flex pdT5 pdB5" style="margin-left: 0px !important;">
					<h3 class="tx mgT12">Category</h3>
					<select id="category" name="category" class="form-sel" style="width:300px;"></select>
				</div> 
			</c:if>	
			</li>
			
			<li class="flex align-center pdT5 pdB5">
				<c:if test="${mailRcvListSQL eq 'review'}">
				<div class="align-center flex" style="flex: 2 1 0;">
						<h3 class="tx">검토부서</h3>
						<span class="wrap_sbj">
							<input type="text" name="reviewDept" id="reviewDept">
						</span>
					</div>
				</c:if>
			</li>
			<li class="flex align-center pdT5 pdB5">
				<c:if test="${mailRcvListSQL eq 'review'}">
				<h3 class="tx">검토자</h3>
				<span class="wrap_sbj">
					<input type="text" placeholder="Click" onclick="addSharer()" id="sharerNamesText" readonly>
					<input type="hidden" class="text" id="sharerNames" name="sharerNames" value="">
					<input type="hidden" class="text" id="sharers" name="sharers" value="">
				</span>
				</c:if>
			</li>
			<c:if test="${mailRcvListSQL eq 'manual' }">
			<li class="flex align-center pdT5 pdB5">
				<h3 class="tx">${menu.LN00245 }</h3>
				<span class="wrap_sbj">
					<input type="text" placeholder="Click" onclick="addSharer()" id="sharerNamesText" readonly>
					<input type="hidden" class="text" id="sharerNames" name="sharerNames" value="">
					<input type="hidden" class="text" id="sharers" name="sharers" value="">
				</span>
			</li>
			</c:if>
			<c:if test="${!empty mailRcvListSQL && mailRcvListSQL ne '' && mailRcvListSQL ne 'review'}">
			<li class="flex align-center pdT5 pdB5">
				<h3 class="tx">${menu.LN00389 }</h3>
				<span class="wrap_sbj">
					<input type="text" id="SC_END_DT"	name="scEndDt" class="text datePicker" size="10" style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</span>
			</li>
			</c:if>
			<li class="flex pdT5 pdB5">
				<h3 class="tx mgT12">${menu.LN00111 }</h3>
				<div style="width:calc(100% - 100px);">
					<button class="cmm-btn" type="button" onclick="openDhxVaultModal()">Attach</button>
					<ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items"></ul>
				</div>
			</li>
			<li class="flex pdT10 pdB10">
				<div style="width:100%;height:350px;">
					<textarea  class="tinymceText" id="Content" name="content" ></textarea> <!-- name="Content" -> name="content" -->
				</div>
			</li>
		</ul>
		<div class="alignR">
			<input name="date" id="date" type="hidden"/>
			<button class="cmm-btn mgT10 mgR5" id="back" type="button" style="color: #333333;">Cancel</button>
			<button class="btn-4265EE cmm-btn mgT10" id="send" type="button">Submit</button>
		</div>
	</form>
</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
<!-- Forced Refresh: 2024-05-22 17:40 -->