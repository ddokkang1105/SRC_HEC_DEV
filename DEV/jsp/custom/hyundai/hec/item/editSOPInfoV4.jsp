<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
  
 <!DOCTYPE html>
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />

<script type="text/javascript">
	var chkReadOnly = false;
	var isWf = "";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var s_itemID = "${s_itemID}";
	var scrnMode = "${scrnMode}";
	var sessionUserId = "${sessionScope.loginInfo.sessionUserId}";
	var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
	/* [SynapEditor 적용]
	 * editSTPInfoV4.jsp 로 이관할 때 먼저 같이 옮겨야 하는 설정값.
	 * Synap iframe 페이지 경로를 공통 변수로 분리했다.
	 */
	var synapFrameBaseUrl = "synapEditorFrame.do";

	//file
	var docCategory = 'ITM';
	var scrnType = 'ITM';
	var mgtId = '';
	var previousAddedFileNames = new Set();
</script>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<style>


#processItemInfo {
    height: 100vh !important; /* 브라우저 높이 전체 사용 */
    overflow: hidden !important;
}

#itemDiv {

    height: calc(100vh - 60px) !important; 
    overflow-y: auto !important; /* 이 영역에 스크롤 생성 */
    overflow-x: hidden;
    padding-bottom: 50px; 
}


.tbl_preview {
    width: 100% !important;
}

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
	/* [SynapEditor 적용]
	 * editSTPInfoV4.jsp 로 이관 시 함께 복사해야 하는 Synap 전용 스타일 영역.
	 * 현재 반영본은 iframe 표시, 전체화면, 미리보기 모달 스타일까지 포함한다.
	 */
	.synap-frame-wrap {
		position: relative;
		width: 100%;
		background: #fff;
		overflow-x: hidden;
	}
	.synap-frame-wrap .synap-editor-frame {
		display: block;
		width: 100%;
		height: 100%;
		border: 0;
		background: #fff;
	}
	.synap-frame-wrap.synap-frame-expanded {
		position: fixed;
		inset: 0;
		z-index: 9998;
		width: 100vw;
		height: 100vh !important;
		background: #fff;
	}
	body.synap-editor-expanded-active {
		overflow: hidden;
	}
	.synap-preview-modal[hidden] {
		display: none !important;
	}
	.synap-preview-modal {
		position: fixed;
		inset: 0;
		z-index: 9999;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 24px;
		background: rgba(0, 0, 0, 0.25);
	}
	.synap-preview-dialog {
		display: flex;
		flex-direction: column;
		width: min(1200px, 100%);
		max-height: calc(100vh - 48px);
		background: #fff;
		border-radius: 18px;
		box-shadow: 0 18px 50px rgba(0, 0, 0, 0.18);
		overflow: hidden;
	}
	.synap-preview-header,
	.synap-preview-footer {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 16px 18px;
	}
	.synap-preview-header {
		font-size: 18px;
		font-weight: 600;
	}
	.synap-preview-body {
		flex: 1;
		padding: 0 18px 18px;
		overflow: auto;
	}
	.synap-preview-content {
		min-height: 120px;
		padding: 16px;
		border: 1px solid #e5e5e5;
		border-radius: 10px;
		background: #fff;
	}
	.synap-preview-close,
	.synap-preview-footer button {
		border: 0;
		border-radius: 6px;
		background: #1f73f1;
		color: #fff;
		font-weight: 600;
		cursor: pointer;
	}
	.synap-preview-close {
		width: 34px;
		height: 34px;
		font-size: 22px;
		line-height: 1;
		background: transparent;
		color: #333;
	}
	.synap-preview-footer button {
		padding: 8px 16px;
	}
	
</style>
<script type="text/javascript">

	$(document).ready(function(){				
		
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});


		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});

		// 비동기 데이터 렌더링 호출
		initPageData();
	});

	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}
		return height - 50;
	}
	
	/**
	 * @function initPageData
	 * @description 페이지 로드 시 필요한 데이터를 비동기로 조회하여 렌더링합니다.
	 */
	async function initPageData() {
		
	
		
		// 1. 아이템 기본 정보 렌더링
		await renderProcessInfo();
		// 2. 유관조직(Role) 렌더링
		await renderRoleList();
		// 3. 첨부파일 리스트 렌더링
		await renderFileList();
		// 4. 본문 속성(AT00501) 렌더링
		await renderAttr('AT00501');
		
		// 5. synap editor 렌더링
		/* [SynapEditor 적용]
		 * SynapEditor 적용 화면에서는 본문 데이터 조회 후 iframe 초기화 추가
		 */
		initSynapFrames(document.getElementById('Con_01'));
	}

	/**
	 * @function renderProcessInfo
	 * @description 아이템 기본 정보를 api를 통해 가져온 후 html 렌더링 합니다.
	 */
	async function renderProcessInfo() {
		const sqlID = 'report_SQL.getItemInfo'; 
		const sqlGridList = 'N';
		const requestData = { languageID, s_itemID, sqlID, sqlGridList };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		
		try {
			const response = await fetch(url, { method: 'GET' });
			const result = await response.json();
			
			if (result && result.success && result.data && result.data.length > 0) {
				const info = result.data[0];
				
				// 공통 요소 바인딩 (ID 기준)
				const itemTypeCodeEl = document.getElementById("itemTypeCode");
				const parentPathEl = document.getElementById("parentPath");
				const AT00001El = document.getElementById("AT00001");
				const DescriptionEl = document.getElementById("Description");
				const ReasonEl = document.getElementById("Reason");
				const AuthorIDEl = document.getElementById("AuthorID");
				const ownerTeamCodeEl = document.getElementById("ownerTeamCode");
				const projectIdEl = document.getElementById("projectId");

				if(itemTypeCodeEl && scrnMode === 'E') itemTypeCodeEl.value = info.ItemTypeCode || '';
				if(parentPathEl && scrnMode === 'N') parentPathEl.value = info.Path || '';
				if(AT00001El) AT00001El.value = info.ItemName || '';
				if(DescriptionEl) DescriptionEl.value = info.ChangeSetDec || '';
				if(ReasonEl) ReasonEl.value = info.Reason || '';
				
				// Hidden 필드 업데이트
				if(AuthorIDEl) AuthorIDEl.value = info.AuthorID || '';
				if(ownerTeamCodeEl) ownerTeamCodeEl.value = info.OwnerTeamID || '';
				if(projectIdEl) projectIdEl.value = info.ProjectID || '';

				// 수정 모드 시 텍스트 노출 부분 (ID 추가된 요소들)
				if(scrnMode === 'E') {
					const itemTypeNameSpan = document.getElementById("itemTypeNameSpan");
					const pathSpan = document.getElementById("pathSpan");
					const identifierSpan = document.getElementById("identifierSpan");
					const ownerTeamNameSpan = document.getElementById("ownerTeamNameSpan");

					if(itemTypeNameSpan) itemTypeNameSpan.innerText = info.ItemTypeName || '';
					if(pathSpan) pathSpan.innerText = info.Path || '';
					if(identifierSpan) identifierSpan.innerText = info.Identifier || '';
					if(ownerTeamNameSpan) ownerTeamNameSpan.innerText = info.OwnerTeamName || '';
				}
			}
		} catch (error) {
			console.error("renderProcessInfo error:", error);
		}
	}

	/**
	 * @function renderRoleList
	 * @description 유관조직 리스트를 조회하여 orgNames input에 렌더링 합니다.
	 */
	async function renderRoleList() {
		const sqlID = "role_SQL.getItemTeamRoleList";
		const asgnOption = '1,2'; 
		const requestData = { languageID, itemID : s_itemID, asgnOption, sqlID };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		
		try {
			const response = await fetch(url, { method: 'GET' });
			const result = await response.json();
			
			if (result && result.success && result.data) {
				const relRoles = result.data
					.filter(item => item.TeamRoletype === 'REL')
					.map(item => item.TeamNM)
					.join(', ');
				
				const orgNamesEl = document.getElementById("orgNames");
				if(orgNamesEl) orgNamesEl.value = relRoles;
			}
		} catch (error) {
			console.error("renderRoleList error:", error);
		}
	}

	/**
	 * @function renderFileList
	 * @description 첨부파일 리스트를 조회하여 HTML을 생성합니다.
	 */
	async function renderFileList() {
		const requestData = { DocumentID : s_itemID, s_itemID, DocCategory : 'ITM', languageID, isPublic : 'N' };
		const params = new URLSearchParams(requestData).toString();
		const url = "getItemFileListInfo.do?" + params;

		try {
			const response = await fetch(url, { method: 'GET' });
			const result = await response.json();
			
			if (result && result.success && result.data) {
				const existingFileListEl = document.getElementById("existingFileList");
				if(!existingFileListEl) return;

				let html = "";
				result.data.forEach(file => {
					// 삭제 버튼 권한 체크 (작성자 본인 또는 관리자)
					const canDelete = (sessionUserId === file.RegMemberID || sessionAuthLev === "1");
					const delIcon = canDelete ? `<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('\${file.Seq}')">` : "";

					html += `
						<div id="divDownFile\${file.Seq}" class="mm" name="divDownFile\${file.Seq}">
							<input type="checkbox" name="attachFileCheck" value="\${file.Seq}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('\${file.Seq}');">\${file.FileRealName}</span>
							\${delIcon}
							<br>
						</div>`;
				});
				existingFileListEl.innerHTML = html;
			}
		} catch (error) {
			console.error("renderFileList error:", error);
		}
	}

	/**
	 * @function renderAttr
	 * @description 본문 속성(AT00501)을 조회하여 렌더링합니다.
	 */
	async function renderAttr(AttrTypeCode) {
		const accMode = "${accMode}";
		/* [SynapEditor apply]
		 * Copy this Editable/requestData pattern together when porting to editSTPInfoV4.jsp.
		 * The Synap editor flow expects Editable to be included in the attr request.
		 */
		const Editable = "1";
		const requestData = { languageID, s_itemID, accMode, AttrTypeCode, Editable };
		const params = new URLSearchParams(requestData).toString();
		const url = "getItemAttrList.do?" + params;
		
		try {
			const response = await fetch(url, { method: 'GET' });
			const result = await response.json();
			/* [SynapEditor apply]
			 * iframe lookup key must match:
			 * - iframe data-attr-code
			 * - hidden textarea id/name
			 * - AttrTypeCode passed into renderAttr()
			 */
			const frame = document.querySelector('iframe.synap-editor-frame[data-attr-code="' + AttrTypeCode + '"]'); 				// synapEditor 설정 
			
			if (result && result.success && result.data && result.data.length > 0) {
				const content = decodeHtml(result.data[0].PlainText || "");
				const textarea = document.getElementById(AttrTypeCode);
				const frame = document.querySelector('iframe.synap-editor-frame[data-attr-code="' + AttrTypeCode + '"]');
				
				if(textarea) {
					textarea.value = content;
				}
				
				/* [SynapEditor apply]
				 * Core bridge block.
				 * Keep this block as-is when moving Synap content binding to editSTPInfoV4.jsp.
				 * It updates both the hidden textarea and the iframe editor instance.
				 */
				// synapEditor 설정 
				if (frame && frame.contentWindow) {
					if (typeof frame.contentWindow.setEditorHtml === 'function') {
						frame.contentWindow.setEditorHtml(content);
					} else if (typeof frame.contentWindow.initSynapEditorBridge === 'function') {
						frame.contentWindow.initSynapEditorBridge({
							editorId: AttrTypeCode,
							frameId: frame.id,
							height: Number(frame.getAttribute('data-editor-height') || setWindowHeight()),
							html: content,
							readOnly: frame.getAttribute('data-readonly') === 'true'
						});
					}
				}
			}
		} catch (error) {
			console.error("renderAttr error:", error);
		}
	}
	
	function decodeHtml(html) {
		if (html == null) {
			return '';
		}
		var txt = document.createElement('textarea');
		txt.innerHTML = html;
		return txt.value;
	}

	function getSynapFrameUrl() {
		return synapFrameBaseUrl;
	}

	/* [SynapEditor apply]
	 * Copy the functions below as one group when porting:
	 * - decodeHtml
	 * - initSynapFrames
	 * - syncSynapFramesToTextarea
	 * - syncEditorContentBeforeSubmit
	 * Fullscreen/preview helpers are optional UI extras, but init/sync are required.
	 */
	function initSynapFrames(container) {
		var scope = container || document;
		var frames = scope.querySelectorAll('iframe.synap-editor-frame');
		frames.forEach(function(frame) {
			var attrCode = frame.getAttribute('data-attr-code');
			var height = Number(frame.getAttribute('data-editor-height') || setWindowHeight());
			var readOnly = frame.getAttribute('data-readonly') === 'true';

			var initialize = function() {
				if (!frame.contentWindow || typeof frame.contentWindow.initSynapEditorBridge !== 'function') {
					return;
				}
				var hiddenField = document.getElementById(attrCode);
				var initialHtml = hiddenField ? hiddenField.value : '';
				frame.contentWindow.initSynapEditorBridge({
					editorId: attrCode,
					frameId: frame.id,
					height: height,
					html: initialHtml,
					readOnly: readOnly
				});
			};

			frame.onload = initialize;
			try {
				if (frame.contentWindow && frame.contentWindow.document && frame.contentWindow.document.readyState === 'complete') {
					initialize();
				}
			} catch (e) {
				console.error('Synap iframe init check failed:', attrCode, e);
			}
		});
	}

	function syncSynapFramesToTextarea() {
		var frames = document.querySelectorAll('iframe.synap-editor-frame');
		frames.forEach(function(frame) {
			var attrCode = frame.getAttribute('data-attr-code');
			var hiddenField = document.getElementById(attrCode);
			if (!hiddenField || !frame.contentWindow || typeof frame.contentWindow.getEditorHtml !== 'function') {
				return;
			}
			try {
				var editorHtml = frame.contentWindow.getEditorHtml() || '';
				// 175번 테스트서버(Nginx) 배포 시 아래 한 줄 주석 해제, 공통/운영 배포 시 다시 주석 처리
				// editorHtml = editorHtml.replace(/\/hyundai\/upload\/output\//gi, '/upload/output/');
				hiddenField.value = editorHtml;
			} catch (e) {
				console.error('Synap iframe sync failed:', attrCode, e);
			}
		});
	}

	function syncEditorContentBeforeSubmit() {
		syncSynapFramesToTextarea();
	}

	function setSynapFrameFullscreen(frameId, isExpanded) {
		var frame = document.getElementById(frameId);
		if (!frame) {
			return;
		}

		var wrapper = frame.closest('.synap-frame-wrap');
		if (!wrapper) {
			return;
		}

		var baseHeight = Number(frame.getAttribute('data-editor-height') || setWindowHeight());
		if (isExpanded) {
			wrapper.classList.add('synap-frame-expanded');
			frame.style.height = '100%';
			document.body.classList.add('synap-editor-expanded-active');
			return;
		}

		wrapper.classList.remove('synap-frame-expanded');
		wrapper.style.height = baseHeight + 'px';
		frame.style.height = baseHeight + 'px';

		if (!document.querySelector('.synap-frame-wrap.synap-frame-expanded') && !document.getElementById('synapPreviewModal')) {
			document.body.classList.remove('synap-editor-expanded-active');
		}
	}

	function ensureSynapPreviewModal() {
		var modal = document.getElementById('synapPreviewModal');
		if (modal) {
			return modal;
		}

		var html = '';
		html += '<div id="synapPreviewModal" class="synap-preview-modal" hidden>';
		html += '  <div class="synap-preview-dialog" role="dialog" aria-modal="true" aria-labelledby="synapPreviewTitle">';
		html += '    <div class="synap-preview-header">';
		html += '      <div id="synapPreviewTitle">Preview</div>';
		html += '      <button type="button" class="synap-preview-close" aria-label="Close" onclick="closeSynapPreviewModal()">&times;</button>';
		html += '    </div>';
		html += '    <div class="synap-preview-body">';
		html += '      <div id="synapPreviewContent" class="synap-preview-content"></div>';
		html += '    </div>';
		html += '    <div class="synap-preview-footer">';
		html += '      <button type="button" onclick="closeSynapPreviewModal()">Close</button>';
		html += '    </div>';
		html += '  </div>';
		html += '</div>';

		document.body.insertAdjacentHTML('beforeend', html);
		modal = document.getElementById('synapPreviewModal');
		modal.addEventListener('click', function(event) {
			if (event.target === modal) {
				closeSynapPreviewModal();
			}
		});
		return modal;
	}

	function openSynapPreviewModal(html) {
		var modal = ensureSynapPreviewModal();
		var content = document.getElementById('synapPreviewContent');
		if (content) {
			content.innerHTML = html || '';
		}
		modal.hidden = false;
		document.body.classList.add('synap-editor-expanded-active');
	}

	function closeSynapPreviewModal() {
		var modal = document.getElementById('synapPreviewModal');
		if (!modal) {
			return;
		}
		modal.hidden = true;
		var content = document.getElementById('synapPreviewContent');
		if (content) {
			content.innerHTML = '';
		}
		if (!document.querySelector('.synap-frame-wrap.synap-frame-expanded')) {
			document.body.classList.remove('synap-editor-expanded-active');
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
					
				}
			}
		}
		
		if(!document.querySelector("#tmp_file_items").innerHTML) {
			document.querySelector("#tmp_file_items").style.display = "";
		}
	}
	//************** addFilePop V4 설정 END ************************//
	
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
	function doAttachFile(){
		var browserType="";
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=SOP&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id=${itemID}&fltpCode=FLTP003";
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,360,360, "Attach File");}
	}

	function fnAttacthFileHtml(seq, fileName){ 
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
			'	<br>'+
			'</div>';		
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
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
		ajaxSubmitNoAdd(document.editSOPFrm, url,"saveFrame");
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SOP";
		ajaxSubmitNoAdd(document.editSOPFrm, url,"saveFrame");
	}

	function fnDeleteItemFile(seq){
		var url = "changeSetFileDelete.do";
		var data = "&delType=1&fltpCode=FLTP003&seq="+seq;
		ajaxPage(url, data, "saveFrame");
		
		fnDeleteFileHtml(seq);
	}
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).remove();
		
		//$('#divFileImg').hide();
		
	}

	function setSubFrame() {
		
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
		var url = "itemMainMgt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID="+$(trObj).find("#ItemID").text()
				+"&scrnType=pop&itemMainPage=itm/itemInfo/itemMainMgt";
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
		
		if(confirm("${CM00001}")){	
			
			if(setAllCondition()) {
			
			var url = "zhec_saveItemInfoAPI.do";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm, url);
			}
		}
	}
	

	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&option=AR010100&hiddenClassList='CL05003','CL16004'";

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

		var url = "itemMainMgt.do?"
				+"s_itemID=${itemID}"
 				+"&scrnMode=V&accMode=DEV"+"&itemID=${itemID}"
 				+"&itemViewPage=custom/hyundai/hec/item/viewSOPInfoV4&screenMode=pop&itemMainPage=custom/hyundai/hec/item/viewSOPInfoV4&itemEditPage=${itemEditPage}"
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes")	
		
	}
	

	function goApprovalPop() {
		

		if(confirm("${CM00001}") && setAllCondition()){		
			isWf = "Y";
			/* [SynapEditor apply] Required before submit: iframe html -> hidden textarea */
			syncEditorContentBeforeSubmit();
			var url = "zhec_saveItemInfoAPI.do";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm, url);
			
		}
		
	}
	
	function fnItemDelete() {
		

		if(confirm("폐기를 진행하시겠습니까?")  && setAllCondition()){		
			isWf = "Y";
			$("#scrnMode").val("D");
			syncEditorContentBeforeSubmit();
			
			var url = "zhec_saveItemInfoAPI.do";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm, url);
			
		}
		
	}
	
	function fnEditCallBack(avg, newToken) {
		if(isWf == "Y" && avg != "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack();
		}
		else if (isWf == "Y" && avg == "Y") {
			var url = "${wfURL}.do?";
			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
					
			var w = 1500;
			var h = 1050; 
			itmInfoPopup(url+data,w,h);
			goBack();
		}
		else {
			// file 토큰 업데이트
	    	if(newToken) {
	    		document.getElementById("uploadToken").value = newToken;
	    		
	    		// temp 파일 삭제
	    		var ul = document.getElementById("tmp_file_items");
				while (ul.firstChild) {
				    ul.removeChild(ul.firstChild);
				}
				ul.style.display = "none";
	    		
	    		//전역 uploadToken 갱신
	    	    uploadToken = newToken;     
	    	    
	    		// file창 리로드
	    	    renderFileList();
	    	    
	    	    // Vault 재초기화 (새 토큰 사용)
	    	    if (window.vault) {
	    	        initVault();
	    	    }
		    }
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
	        url = "cxnItemTreeMgtV4.do";   
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
			/* [SynapEditor apply] Save Text button also needs iframe -> textarea sync */
			syncEditorContentBeforeSubmit();
			var url = "saveObjectInfo.do?AT00001YN=N";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm,url, "saveFrame");
		}
	}
	
	function fnRefreshPage(option, itemID,scrnMode){
		parent.fnRefreshPageCall(option, itemID,scrnMode);
	}
	
    var orgTeamTreePop;
	function fnGoOrgTreePop(){
		var url = "orgTreePop.do";
		var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}&option=NoP";
		//fnOpenLayerPopup(url,data,doCallBack,617,436);
		 orgTeamTreePop = openUrlWithDhxModal(url, data, "Search Organization" , 617, 436)
	}
	
	function fnTeamRoleCallBack(){
	}
	
	function doCallBack(){}
	
	function fnSaveTeamRole(teamIDs,teamNames){
		$("#orgNames").val(teamNames);
		$("#orgTeamIDs").val(teamIDs);
		orgTeamTreePop.hide();
	}
	
	
	// [Back] click
	function goBack() {
		var url = "itemMainMgt.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}&itemMainPage=custom/hyundai/hec/item/viewSOPInfoV4";
// 		ajaxPage(url, data, "processItemInfo");

		if(parent.olm?.menuTree) {
			// 트리 오른쪽 화면에서 view 화면으로 돌아갈 경우 - 트리 클릭 이벤트로 아이템 다시 로드
			parent.olm.menuTree.selection.add("${itemID}");
			parent.olm.getMenuUrl("${itemID}");
		} else {
			// 팝업에서 로드할 경우, url 재호출
			location.href = url+"?"+data;
		}
	}
	
	function selfClose(){
		goBack();
	}
	

	function setAllCondition() {
		
		if("${sessionScope.loginInfo.sessionAuthLev}" == "1") {
			return true;
		}
		
		if ($("#parentID").val() == "" ) {
			alert("분류체계를 선택하여 주십시오.");
			return false;
		}
		if ($("#AT00001").val() == "" ) { 
			alert("표준명을 입력하여 주십시오.");
			return false;
		}
		if ($("#Description").val() == "" ) {
			alert("제/개정/폐기 사유를 입력하여 주십시오.");
			return false;
		}
		if ($("#Reason").val() == ""  ) {
			alert("주요 개정 사항을 입력하여 주십시오.");
			return false;
		}
		if ($("#orgNames").val() == "" ) {
			alert("유관조직을 선택하여 주십시오.");
			return false;
		}
		return true;
	}
	
</script>
</head>
<!-- BIGIN :: -->
<body>
<form name="editSOPFrm" id="editSOPFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
<div id="processItemInfo">
<input type="hidden" id="s_itemID" name="s_itemID"  value="${itemID}" />
<input type="hidden" id="option" name="option"  value="${option}" />		
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
<input type="hidden" id="AuthorID" name="AuthorID" value="" />
<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />			
<input type="hidden" id="sub" name="sub" value="${sub}" />
<input type="hidden" id="function" name="function" value="saveObjInfoMain">
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
<input type="hidden" id="projectId" name="projectId" value="" />
<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" />

	<div id="htmlReport" style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
				
		<div id="menuDiv" style="margin:0 10px;">
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>
				
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB10">
				<div class="pdL10 pdT15 pdB5" style="width:98%;">
				<p class="cont_title">${menu.LN00321} ${menu.LN00046}</p>
				</div>
				<table class="tbl_preview mgB10">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>${menu.LN00021}</th>
						<td class="alignL pdL10">
						<span id="itemTypeNameSpan"></span>
						<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="">
						<input type="hidden" id="classCode" name="classCode" value="">
						</td>
						
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10"><span id="pathSpan"></span>
						</td>
					</tr>
					<tr>
						<th>Sop No.</th>
						<td class="alignL pdL10">
						<span id="identifierSpan"></span>
						</td>
						<th>${menu.ZLN018}</th>
						<td class="alignL pdL10">
						<input type="text" id="AT00001" name="AT00001" value="" class="text" maxLength="100">
						</td>
					</tr>
					<tr>
						<th>${menu.ZLN019}</th>
						<td class="alignL pdL10">
						<span id="ownerTeamNameSpan"></span>						
						</td>
						<th>${menu.ZLN021}</th>
						<td class="alignL pdL10">	
						<input type="text" id="orgNames" name="orgNames" value="" class="text" onClick="fnGoOrgTreePop()">
						</td>
					</tr>
					<tr>
						<th>${menu.LN00359}</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;"></textarea> 
						</td>						
					</tr>
					<tr>
						<th>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Reason" name="Reason" style="width:100%;height:40px;"></textarea>
						</td>						
					</tr>
					<tr>
						<th>${menu.LN00019}</th>
						<td class="alignL pdL10" colspan="3">
						<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items"></ul>
						<div id="existingFileList"></div>
						</div>
					</tr>
				</table>
			</div>
			
			<div class="alignR">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="button" onclick="goBack()"></span>
				<span class="btn_pack medium icon"><span class="upload"></span><input value="${menu.LN00019}" type="button" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp;		
				<span class="btn_pack medium icon"><span class="search"></span><input value="Preview" onclick="openPreviewPop()" type="submit"></span>
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
				<c:if test="${itemInfo.Status ne 'NEW1'}">
				<span class="btn_pack medium icon"><span class="del"></span><input value="폐기" onclick="fnItemDelete()" type="submit"></span>
				</c:if>
				<span class="btn_pack medium icon"><span class="save"></span><input value="${menu.LN00211}" onclick="goApprovalPop()" type="submit"></span>
			</div>
			
				
			<div class="noticeTab02">
				<input id="tab_01" type="radio" name="notice02" checked>
				<label for="tab_01" id="pli1" onclick="setInfoFrame('1');"><h5>본문</h5></label>
				<input id="tab_02" type="radio" name="notice02">
				<label for="tab_02" id="pli5" onclick="setInfoFrame('2');"><h5>연관 항목</h5></label>
				<input id="tab_03" type="radio" name="notice02">
				<label for="tab_03" id="pli6" onclick="setInfoFrame('3');"><h5>${menu.LN00215}</h5></label>
				
				<div id="Con_01">
					<!-- [SynapEditor apply]
						Port this whole markup block to editSTPInfoV4.jsp in place of the old TinyMCE textarea.
						iframe = visible Synap editor
						hidden textarea(#AT00501) = submit field kept for existing save APIs
					-->
					<div class="synap-frame-wrap">
						<iframe class="synap-editor-frame"
							id="synapFrame_AT00501"
							name="synapFrame_AT00501"
							src="synapEditorFrame.do"
							data-attr-code="AT00501"
							data-readonly="false"
							></iframe>
						<textarea id="AT00501" name="AT00501" style="display:none;"></textarea>
					</div>
					<div class="alignR mgT10"><span class="btn_pack medium icon"><span class="save"></span><input value="Save Text" onclick="saveMainText()" type="button"></span></div>
				</div>
				<div id="Con_02">
					<div id="subRelFrame"  name="subRelFrame" style="width:100%;"></div>
				</div>
				<div id="Con_03">
					<div id="csFrame"  name="csFrame" style="width:100%;"></div>
				</div>
			</div>	
			
		</div>
	</div>
</div>
</form>

<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
