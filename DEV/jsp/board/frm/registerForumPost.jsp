<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

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
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00245}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00389}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015_1" arguments="검토기한"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015_2" arguments="${menu.LN00389}"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
//파일 업로드 처리 이동 [fileAttachHelper.js]
var screenType = "${screenType}";
var fileSize = "${itemFiles.size()}";
var mailRcvListSQL = $("#mailRcvListSQL").val();
var dueDateMgt = $("#dueDateMgt").val();
var showAuthorInfo = "${showAuthorInfo}";

$(document).ready(function() { 
	//console.log("${sessionScope.loginInfo.sessionUserNm}");
	
  const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth() + 1).padStart(2, '0'); 
  const dd = String(today.getDate()).padStart(2, '0');
  const formattedDate = yyyy+'-'+mm+'-'+dd;

  // 작성일자 
  if(showAuthorInfo ==="Y"){
	  
  document.getElementById('writeDate').value = formattedDate;
  //문서정보 구하기 (문서번호, 문서명)
/*   var parts = path.substring(path.lastIndexOf("/") + 1).split(" ",2);
  identifier = parts[0];  
  docTitle = parts[1]; 
  document.getElementById('docID').value = identifier;
  document.getElementById('docTitle').value=docTitle */
  }
  
  
  
	var emailCode = $("#emailCode").val();
	$("input.datePicker").each(generateDatePicker);
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";

	fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
	setTimeout(function() {
	    $("#category option[value='BRDSTS101']").remove();
	    $("#category option[value='BRDSTS102']").remove();
	}, 300); 
	
	<c:if test="${categoryYN == 'Y'}">
	document.getElementById("category").addEventListener("change", function() {
		const typeCode = $("#category").val();
		setGuideLineforCat(typeCode);
		
		var selectedText = $('#category option:selected').text();
		$('#categoryNM').val(selectedText);
	})
	</c:if>
			
	$("#send").click(function(e) {
		
		if($("#subject").val() == ""){
			alert("${WM00034_3}");
			return false;
		}
		
		if(mailRcvListSQL == "manual"){
			if($("#sharers").val() == ""){
			alert("${WM00034_1}");
			return false;
			}
		}
		if(emailCode == "REQITMRW"){
			if($("#SC_END_DT").val() == ""){
				alert("${WM00034_2}");
				return false;	
			}
		}
		if(emailCode == "BRDMAIL"){
			if($("#SC_END_DT").val() == ""){
				alert("${WM00034_2}");
				return false;	
			}
		}
		if(mailRcvListSQL == "review"){
			if($("#sharers").val() == ""){
			alert("${WM00034_1}");
			return false;
			}
			if($("#SC_END_DT").val() == ""){
				alert("${WM00034_2}");
				return false;	
			}
			if($("#SC_END_DT").val() < formattedDate) {
				alert("${WM00015_1}");
				return false;
			}
		}
		if(dueDateMgt == "Y"){
			if($("#SC_END_DT").val() == ""){
				alert("${WM00034_2}");
				return false;	
			}
		}
		if($("#SC_END_DT").val() < formattedDate) {
			alert("${WM00015_2}");
			return false;
		}
		
		if(confirm("${CM00001}")){
			var url  = "saveForumPost.do";
			ajaxSubmit(document.newFormFrm, url);
		}
	});
	
/* 	function updateBlocked() { //1이면 완료 , 0 이면 처리중  
		if(confirm("${CM00016}")){
			fetch(`/blockedForum.do?blocked=1&boardID=${boardID}`)
			.then((response) => response.json())
			.then((json) => {
				if(json.result == "success") alert("${WM00067}");
				if(json.result == "failed") alert("${WM00068}");
				doReturn();
			});
		}
	} */
	
	$('#back').click(function(e){
		doReturn();
	});
	
});

//[Add] 버튼 Click
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

var boardTitle = "${boardTitle}";
function doReturn(){
	var listType = "${listType}";
	var url = "boardForumList.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&pageNum="+$("#currPage").val()+"&noticType=${noticType}&BoardMgtID=${BoardMgtID}&isMyCop=${isMyCop}"
				+"&scStartDt=${scStartDt}"+"&scEndDt=${scEndDt}"
				+"&searchType=${searchType}"+"&searchValue=${searchValue}"
				+"&screenType=${screenType}&projectID=${projectID}&listType=${listType}&srID=${srID}&srType=${srType}"
				+"&instanceNo=${instanceNo}&changeSetID=${changeSetID}"
				+"&mailRcvListSQL="+mailRcvListSQL+"&emailCode="+emailCode+"&showItemInfo=${showItemInfo}&scrnType=${scrnType}"
				+"&dueDateMgt=${dueDateMgt}"
				+"&boardTitle="+encodeURIComponent(boardTitle)
				+"&identifier="+$("#docID").val()
				+"&docTitle="+$("#docTitle").val()  
				+"&itemVersion=${itemVersion}"
				+"&showItemInfo=${showItemInfo}&dueDateMgt=${dueDateMgt}&forumMailOption=${forumMailOption}&replyMailOption=${replyMailOption}&showAuthorInfo=${showAuthorInfo}&showItemVersionInfo=${showItemVersionInfo}&showReplyDT=${showReplyDT}&openDetailSearch=${openDetailSearch}";
	if(listType == 1){data = data + "&s_itemID="+$('#s_itemID').val();}			
	var target = "help_content";
	ajaxPage(url, data, target);
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
	
	function fnDeleteItemFile(BoardID, seq){
		var url = "boardFileDelete.do";
		var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");
		
		$('#divDownFile'+seq).remove();	
		
		document.querySelectorAll(".file_box").forEach((item) => {
		    if(item.innerText == "") item.style.display = "";
		})
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
</script>
<div class="pdB15 mgT20" style="width: 70%; margin: 0 auto;">
	<form name="newFormFrm" id="newFormFrm" enctype="multipart/form-data" action="boardForumNew.do" method="post" onsubmit="return false;">
		<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >
		<input type="hidden" id="noticType" name="noticType" value="${noticType}">
		<input type="hidden" id="noticType" name="BoardMgtID" value="${BoardMgtID}">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
		<input name="userId" id="userId" type="hidden" value="${sessionScope.loginInfo.sessionUserId}" />
		<input name="date" id="date" type="hidden"/> 
		<input type="hidden" id="screenType" name="screenType" value="${screenType}" />
		<input type="hidden" id="projectID" name="projectID" value="${projectID}" />
		<input type="hidden" id="srID" name="srID" value="${srID}" />
		<input type="hidden" id="srType" name="srType" value="${srType}" />
		<input type="hidden" id="instanceNo" name="instanceNo" value="${instanceNo}" />
		<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}" />
		<input type="hidden" id="boardMgtName" name="boardMgtName" value="${boardMgtName}" />
		<input type="hidden" id="mailRcvListSQL" name="mailRcvListSQL" value="${mailRcvListSQL}" />
		<input type="hidden" id="emailCode" name="emailCode" value="${emailCode}" />
		<input type="hidden" name="ItemMgtUserID" id="ItemMgtUserID" value="${ItemMgtUserMap.AuthorID}" />
		<input type="hidden" name="showItemInfo" id="showItemInfo" value="${showItemInfo}" />
		<input type="hidden" name="forumMailOption" id="forumMailOption" value="${forumMailOption}" />
		<input type="hidden" name="showReplyDT" id="showReplyDT" value="${showReplyDT}" />
		<input type="hidden" name="openDetailSearch" id="openDetailSearch" value="${openDetailSearch}" />
		<input type="hidden" name="boardTitle" id="boardTitle" value="${boardTitle}" />
		<input type="hidden" name="categoryNM" id="categoryNM" value="" />
	<%-- 	<c:if test="${BoardMgtID == 'BRD0201'}"> --%>
		 <input type="hidden" name="blocked" id="blocked" value="0"/>
	<%-- 	</c:if> --%>
		<c:if test="${dueDateMgt eq 'Y'}">
		<input type="hidden" name="dueDateMgt" id="dueDateMgt" value="${dueDateMgt}" />
		</c:if>
		<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" >

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
						<input type="text" id=SC_END_DT	name="SC_END_DT" class="text datePicker" size="10" style="width: 175px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
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
					<h3 class="tx mgT12">${menu.LN00042 }</h3>
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
					<input type="text" id=SC_END_DT	name="SC_END_DT" class="text datePicker" size="10" style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</span>
			</li>
			</c:if>
			<li class="flex pdT5 pdB5">
				<h3 class="tx mgT12">${menu.LN00111 }</h3>
				<div style="width:calc(100% - 100px);">
					<button class="cmm-btn" onclick="openDhxVaultModal()">Attach</button>
					<ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items"></ul>
				</div>
				</li>
			<li class="flex pdT5 pdB5">
				<div style="width:100%;height:350px;">
					<textarea  class="tinymceText" id="content" name="content" >${dicInfo.Description}</textarea>
				</div>
			</li>
		</ul>
		<div class="alignR">
			<button class="cmm-btn mgT10 mgR5" id="back" style="color: #333333;">Cancel</button>
			<button class="btn-4265EE cmm-btn mgT10" id="send">Submit</button>
		</div>
	</form>
</div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
