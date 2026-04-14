<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!-- Item 정보 -->
<!-- 
	@RequestMapping(value="/NewItemInfoMain.do")
	
-->
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<script type="text/javascript">
	var chkReadOnly = true;
</script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00058" var="CM00058" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<script type="text/javascript">
	var languageID = "${languageID}";
	var isPossibleEdit = "${isPossibleEdit}";
	var itemStatus = "${itemStatus}";
	var checkOutFlag = "N";
	var accMode = "${accMode}";
	var showInvisible = "${showInvisible}";
	var attrUrl = `${attrUrl}`;
	var papagoTrans = `${papagoTrans}`;
	var gptAITrans = `${gptAITrans}`;
	var s_itemID = `${s_itemID}`;
	var changeSetID = `${changeSetID}`;
	
	$(document).ready(function(){	
		
		var itemObj = $('.geSidebarContainer');
		var height = setWindowHeight();
		if(itemObj.length != 0){
			var objTop = itemObj.offset().top;
			if(objTop > 100){
				height = itemObj.height();
			}
		}
		
// 		if(document.getElementById('htmlReport')!=null&&document.getElementById('htmlReport')!=undefined){
// 			$("#htmlReport").innerHeight(document.body.clientHeight - 145);

// 			window.onresize = function() {
// 				$("#htmlReport").innerHeight(document.body.clientHeight -145);
// 			};
// 		}
		
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		var classNameArray = strClassName.split(",");
		for (var i = 1; i < classNameArray.length + 1; i++) {
			var subTitleId = "subTitle" + i;
			if(document.getElementById(subTitleId)!=null){document.getElementById(subTitleId).innerHTML = classNameArray[i-1];}
		}
		
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer_photo');

		// 레이어 팝업 닫기
		$('.closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		// 레이어 팝업 닫기
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		var loadEdit = "${loadEdit}";
		if(loadEdit == "Y"){
			goItemInfoEdit();
		}
		
		
	});
	
	
	/**
	 * @function setWindowHeight
	 * @description 윈도우 높이를 구합니다.
	 * @returns {Number} 높이
	 */
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//---------------------------------------------------------
	//[CALLBACK] START ::
	//---------------------------------------------------------

	function doCallBack(){}
	
	function urlReload() {
		thisReload();
	}
	
	function afterCar() {
		thisReload();	
	}
	
	function thisReload() {
		var url = "itemInfoMgt.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&varFilter=${showVersion}&itemInfoPage=${itemInfoPage}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnCngCallBack() {
		opener.fnItemMenuReload();	
	}
	//---------------------------------------------------------
	//[CALLBACK] END ::
	//---------------------------------------------------------
	 
	 
	
	
	/**
	* @function goItemInfoEdit
	* @description 편집화면으로 이동합니다.
	*/
	function goItemInfoEdit() {
		if (isPossibleEdit == "Y") { 
		
		    var url = "itemInfoMgt.do";
			var target = "actFrame";
			var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&showVersion=${showVersion}&showInvisible=${showInvisible}&changeSetID='${changeSetID}'&itemInfoPage=itm/itemInfo/editItemAttr";
		 	ajaxPage(url, data, target);
		} else {
			if (itemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	
	
	/**
	* @function goMenu
	* @param {String} 이동 화면
	* @description 의견공유, 변경이력, 관련문서, Dimension 등의 화면으로 이동합니다.
	*/
	function goMenu(avg) {
		var url = "";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}"; 
		
		if (avg == "fileMgt") {
			url = "fileListMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}&langFilter=${langFilter}"; // 관련문서
		} else if (avg == "changeMgt") {
			url = "itemHistory.do"; // 변경이력
			data = data + "&myItem=${myItem}&itemStatus=${itemStatus}";
		} else if (avg == "forum") {
			url = "forumMgt.do"; // 의견공유
		} else if (avg == "dim") {
			url = "itemDimValueListMgt.do"; // Dimension
		} else if (avg == "model") {
			url = "getModelListGrid.do"; // Item Model Occurrence List
			data = data + "&filter=itemOcc";	
		} else if (avg == "rev") {
			url = "revisionList.do?docCategory=ITM"; // Revision
		} else if (avg == "editCS") {
			fnEditChangeSet();
			
			return false;
		}
		
		ajaxPage(url, data, target);
	}
	
	/**
	* @function fnEditChangeSet
	* @description cs화면 편집 팝업을 엽니다.
	*/
	function fnEditChangeSet(){
		var url = "editItemCSInfo.do"
		var data = "?changeSetID=${curChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y";
		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	/**
	* @function FileDownload
	* @param {String} 다운로드 할 파일
	* @param {String} 모두 체크 여부
	* @description 첨부문서, 관련문서를 다운로드 합니다.
	*/
	function FileDownload(checkboxName, isAll){		
		const fileList = document.querySelector("tbody[name='file-list']");
		const seq = Array.from(fileList.querySelectorAll("td[data-id]")).map(td => td.dataset.id);
		
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
	}
	
	/**
	* @function fileNameClick
	* @param {String} FileName
	* @param {String} FileRealName
	* @param {Number} Seq
	* @param {String} ExtFileURL
	* @param {String}
	* @description 첨부문서, 관련문서를 다운로드 합니다.
	*/
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER" || avg3 == "PDFCNVT") {
			var url = "openViewerPop.do?seq="+seq[0]+"&fileOption="+avg3;
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {

			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
		
	}
	
	/**
	* @function fnOpenItemPop
	* @param {String} itemID
	* @description 파라미터로 받은 itemID를 팝업창으로 조회합니다.
	*/
	function fnOpenItemPop(itemID){
		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+itemID+"&scrnType=pop&itemMainPage=/itm/itmInfo/itemMainMgt";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	/**
	* @function fnRunLink
	* @param {String} 이동할 url
	* @param {String} attrUrl  
	* @param {String} attrTypeCode
	* @param {String} varFilter
	* @description 아이템 attr 에서 Link 타입 항목 클릭 시 파라미터로 받은 url로 이동하는 팝업창을 조회합니다.
	*/
 	function fnRunLink(url,attrUrl,attrTypeCode,varFilter){
		var lovCode = "${lovCode}"; 
		var itemID = "${s_itemID}";
		var fromItemID = "${fromItemID}";
		if(fromItemID != ""){
			itemID = fromItemID;
		}
		
		if(url == null || url == ""){
			url = attrUrl;		
		}
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}	
		 else if (url.includes("cxnItemListPop")) {
			url = url+".do?s_itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode + varFilter;
			window.open(url,'','width=750, height=500, left=200, top=100, scrollbar=yes,resizable=yes');					
		}
		 else if (url.includes("cxnItemListMgtV4")) {
			 	url =  url + ".do";
				var data = "s_itemID=" + itemID + varFilter
				var w = 1200;
				var h = 800;
				openUrlWithDhxModal(url, data, title="", w, h)			 
			 
				//url = url+".do?s_itemID="+itemID + varFilter;
				//window.open(url,'','width=1200, height=800, left=200, top=100, scrollbar=yes,resizable=yes');					
		}		
		 else {
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
			window.open(url,'_newtab');					
		}
	} 
	
	/**
	* @function fnCloseLayer
	* @description 관련항목 레이어 팝업을 닫습니다.
	*/
	function fnCloseLayer(){
		var layerWindow = $('.connection_layer');
		layerWindow.removeClass('open');
	}
	
	/**
	* @function linkLayerPopupView
	* @param {String} sLinkName
	* @param {String} sDivName
	* @param {String} pos
	* @description 관련항목 메뉴 popup창에 표시합니다 : 상세항목정보, link 메뉴
	*/
	function linkLayerPopupView(sLinkName, sDivName, pos)  { 
		var nTop = pos.top;
		var nLeft = pos.left;
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("htmlReport").scrollTop;
		oPopup.style.top = (oLink.offsetTop + nTop - 130) + "px";
		oPopup.style.left = nLeft +"px";
	} 
	
	/**
	* @function fnRefItemLayer
	* @param {String} itemID
	* @param {String} layerID
	* @description 관련항목 레이어 팝업을 조회합니다. (mstItem)
	*/
	function fnRefItemLayer(itemID, layerID){ 
		var layerWindow = $('.connection_layer');
		var pos = document.getElementById(layerID).getBoundingClientRect();
		linkLayerPopupView(layerID, 'connectionPopup', pos);
		layerWindow.addClass('open');
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("htmlReport").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
				 
		var linkLayer ="";
		linkLayer += "<tr>";
		linkLayer += "<td style='cursor:pointer;height:20px;' onClick='fnOpenItemPop("+itemID+");' class='alignL last'>${menu.LN00138}</td>";
		linkLayer += "</tr>"; 
		 $('#link').html(linkLayer);
	}

	/**
	* @function fnOpenPapagoTrans
	* @param {String} attrTypeCode
	* @param {String} isHTML
	* @description attr 내용을 papago ai 를 통해 번역합니다.
	*/
	function fnOpenPapagoTrans(attrTypeCode, isHTML) {
		var w = "1200";
		var h = "800";
		var url = "getPapagoTrans.do?itemID="+${s_itemID}+"&attrTypeCode="+attrTypeCode+"&languageID="+${sessionScope.loginInfo.sessionCurrLangType};
		window.open(url, "papago", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	/**
	* @function fnOpenGPTAITrans
	* @param {String} attrTypeCode
	* @param {String} isHTML
	* @description attr 내용을 gpt ai 를 통해 번역합니다.
	*/
	function fnOpenGPTAITrans(attrTypeCode, isHTML) {
		var w = "1200";
		var h = "800";
		var url = "getGPTAITrans.do?itemID="+${s_itemID}+"&attrTypeCode="+attrTypeCode+"&languageID="+${sessionScope.loginInfo.sessionCurrLangType};
		window.open(url, "gptAI", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	//---------------------------------------------------------
	//[API] START ::
	//---------------------------------------------------------
	
	// api 함수 실행
	
	displayVersionAndValidFrom(); // 상단 정보 렌더링
	renderFileList(); //file 렌더링
	renderItemAttrList(); // attr 렌더링
	renderDimList(); // dimension 렌더링
	renderMstItem(); // mstItem 렌더링
	
	getFileCNT(); // file btn count 렌더링
	getRevCNT(); // rev btn count 렌더링
	
	/**
   	* @function renderFileList
   	* @description 현재 item의 첨부파일 리스트를 api 통해 조회 후 html 렌더링 합니다.
    * @returns {String} 아이템 릴리즈 버전
  	*/
	let attachFileList = "";
	async function renderFileList(targetElement) {
		
	    let requestData = { DocumentID : s_itemID, s_itemID, DocCategory : 'ITM', languageID , isPublic : 'N' };
	 	// getRltdItemId
		const rltdItemId = await getRltdItemId();
		if(rltdItemId && rltdItemId !== ''){
			requestData = {
					...requestData,
					rltdItemId
			}
	    }
		
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemFileListInfo.do?" + params;
	    
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			if (result && result.data ) {
				
				// file 정보 조회
				attachFileList = result.data;
				
				// html 렌더링
				const fileOption = await getFileOption();
				
				let html = "";
				if(fileOption != "VIEWER" && fileOption != "PDFCNVT") {
					const fileList = document.querySelector("tbody[name='file-list']");
					
					if(attachFileList.length > 0) {
						// fileSection 보이게 스타일 수정
						const fileSection = document.getElementById('fileSection');
						fileSection.style.display = "";
						
						// Save All 버튼 활성화
						const saveAll = `<div class="btns pdB10 pdL0"><button onclick="FileDownload('checkedFile', 'Y')" class="secondary">Save All</button></div>`;
						document.querySelector(".tmp_file_wrapper").insertAdjacentHTML("beforebegin", saveAll);
					}
					
					// 파일 표시
					attachFileList.forEach((list, index) => {
					    const row = document.createElement('tr');
					    row.innerHTML = `
					        <td data-id="` + list.Seq + `">
					            <svg onclick="fileNameClick('` + list.FileName + `','` + list.FileRealName + `','','` + list.Seq + `','` + list.ExtFileURL + `');" 
					                class="downloadable" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343">
					                <path d="M480-336 288-528l51-51 105 105v-342h72v342l105-105 51 51-192 192ZM263.72-192Q234-192 213-213.15T192-264v-72h72v72h432v-72h72v72q0 29.7-21.16 50.85Q725.68-192 695.96-192H263.72Z"/>
					            </svg>
					        </td>
					        <td class="downloadable" onclick="fileNameClick('` + list.FileName + `','` + list.FileRealName + `','','` + list.Seq + `','` + list.ExtFileURL + `');">` + list.FileRealName + `</td>
					        <td class="alignR">` + textfileSize(list.FileSize,index) + `</td>
					    `;
					    fileList.appendChild(row);
					});
				}
				
				if(fileOption == "VIEWER" || fileOption == "PDFCNVT") {
					const fileList = document.querySelector("tbody[name='file-list']");
					
					if(attachFileList.length > 0) {
						// fileSection 보이게 스타일 수정
						const fileSection = document.getElementById('fileSection');
						fileSection.style.display = "";
					}
					
					if("${myItem}" != 'Y') document.querySelector('.tmp_file_wrapper colgroup col:first-child').remove();
					
					// 파일 표시
					attachFileList.forEach((list, index) => {
					    const row = document.createElement('tr');
					    
					    if("${myItem}" == 'Y') {
					    	row.innerHTML = `
						        <td data-id="` + list.Seq + `">
						        <svg onclick="fileNameClick('` + list.FileName + `','` + list.FileRealName + `','','` + list.Seq + `','` + list.ExtFileURL + `');" 
						                class="downloadable" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343">
						                <path d="M480-336 288-528l51-51 105 105v-342h72v342l105-105 51 51-192 192ZM263.72-192Q234-192 213-213.15T192-264v-72h72v72h432v-72h72v72q0 29.7-21.16 50.85Q725.68-192 695.96-192H263.72Z"/>
						            </svg>
						        </td>
					        `;
					    }
					    row.innerHTML += `
					        <td class="downloadable" onclick="fileNameClick('` + list.FileName + `','` + list.FileRealName + `','` + list.fileOption + `','` + list.Seq + `','` + list.ExtFileURL + `');">` + list.FileRealName + `</td>
					        <td class="alignR">` + textfileSize(list.FileSize,index) + `</td>
					    `;
					    fileList.appendChild(row);
					});
				}
			} else {
				return []; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
		
	}
		
	function textfileSize(e, ind) {
		if(e === '0') return '0'
		else return getFileSize(e);
	}
	
    /**
   	* @function getFileOption
   	* @description 현재 item의 파일 옵션을 return 합니다.
    * @returns {String} 파일 옵션
  	*/
	async function getFileOption() {
		
		const sqlID = 'fileMgt_SQL.getFileOption'; 
		const sqlGridList = 'N';
	    const requestData = { itemId : s_itemID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			if (result && result.data && result.data.length > 0) {
				return result.data;
			} else {
				return ''; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function getItemReleaseVersion
   	* @description 현재 item의 release version을 return 합니다.
    * @returns {String} 아이템 릴리즈 버전
  	*/
	async function getItemReleaseVersion() {
	    
	    const sqlID = 'cs_SQL.getItemReleaseVersion'; 
		const sqlGridList = 'N';
	    const requestData = { itemID : s_itemID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			if (result && result.data && result.data.length > 0) {
				return result.data;
			} else {
				return '1.0'; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function getItemValidFrom
   	* @description 현재 item의 시행일을 return 합니다.
    * @returns {String} 시행일
  	*/
	async function getItemValidFrom() {

		const sqlID = 'cs_SQL.getItemValidFrom'; 
		const sqlGridList = 'N';
	    const requestData = { itemID : s_itemID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();

			if (result && result.data && result.data.length > 0) {
				return result.data;
			} else {
				return ''; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function displayVersionAndValidFrom
   	* @description 최상단에 버전 및 시행일을 표시합니다.
  	*/
	async function displayVersionAndValidFrom() {
		const itemReleaseVersion = await getItemReleaseVersion();
		const itemValidFrom = await getItemValidFrom();
		
		document.querySelector(".child_search01 ").insertAdjacentHTML("afterBegin",'<li class="shortcut">${menu.LN00017}&nbsp;:&nbsp;'+itemReleaseVersion+'&nbsp;/&nbsp;${menu.LN00296}&nbsp;:&nbsp;'+itemValidFrom+'&nbsp;</li>')
	}
	
	
	/**
   	* @function getItemAttrList
   	* @description 아이템 attr 정보를 api를 통해 return 합니다.
   	* @returns {Array} 아이템 attrList
  	*/
	async function getItemAttrList() {

		const requestData = { languageID, s_itemID, accMode, changeSetID, showInvisible };
		const params = new URLSearchParams(requestData).toString();
		const url = "getItemAttrList.do?" + params;
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}

			if (result && result.data) {
				return result.data;
			} else {
				return [];
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
   	
   	/**
   	* @function getItemAttrLOV
   	* @description 아이템 attrTypeCode를 통해 LOV 값을 return한다.
   	* @returns {String} 아이템 attr의 LOV값
  	*/
	async function getItemAttrLOV() {

   		const sqlID = 'attr_SQL.getItemAttr'; 
		const sqlGridList = 'N';
	    const requestData = { ItemID : s_itemID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}

			if (result && result.data) {
				return result.data;
			} else {
				return [];
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
   	
   	/**
   	* @function getItemAttrMLOV
   	* @description 아이템 attrTypeCode를 통해 MLOV 값을 가공하여 return한다.
   	* @returns {String} 아이템 attr의 MLOV값
  	*/
	async function getItemAttrMLOV(AttrTypeCode) {

   		const sqlID = 'attr_SQL.selectAttrLovOption'; 
		const sqlGridList = 'N';
	    const requestData = { s_itemID : AttrTypeCode, languageID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}

			if (result && result.data) {
				
				const mLovValue = result.data.map(item => item.NAME || "").join(" / ");
				return mLovValue;
				
			} else {
				return [];
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
   	
	/**
   	* @function renderItemAttrList
   	* @description 아이템 attr 정보를 api를 통해 가져온 후 html 렌더링 합니다.
  	*/
	async function renderItemAttrList() {
		
		try {
	        // 1. 아이템 기본정보 불러오기
	        const attrList = await getItemAttrList();
	        if (!attrList || attrList.length === 0) {
	            return;
	        }
	        
			if(attrList.length > 0) {
				const attrSection = document.getElementById('attrSection');
				attrSection.style.display = "";
			}
	        					
	       	const tbody = document.querySelector("tbody[name='attr-list']");
	       	
			// 1. attrList 가공 
			// 1-1. invisible 비활성화
			const filteredList = attrList.filter(item => String(item.invisible) !== "1");
	        // 1-2. dataType에 따른 값 셋팅
			await Promise.all(filteredList.map(async (item) => {
	            if (item.DataType === "MLOV") {
	            	//우선은 쿼리 수정을 통해, 쿼리에서 한번에 가져오는 방식으로 진행 (getItemAttrV4)
	                //item.PlainText = await getItemAttrMLOV(item.AttrTypeCode, languageID);
	            }
	        }));
			// 1-3. 중복된 attr 항목의 값 , 로 구분
			const reduceAttrList = filteredList
				.reduce((acc, current) => {
		        // 동일한 attr 항목 ,로 구분
		        const existingItem = acc.find(item => item.Name === current.Name);
		        
		        if (existingItem) {
		            if (current.PlainText) {
		                existingItem.PlainText += ", " + current.PlainText;
		            }
		        } else {
		            acc.push({ ...current });
		        }
		        return acc;
		    }, []);
			
			// 2. RowNum 기준으로 데이터 정렬 및 그룹화
			const rowsMap = reduceAttrList.reduce((acc, item) => {
			    const rowNum = item.RowNum || 0; // RowNum이 없으면 0으로 처리
			    if (!acc[rowNum]) {
			        acc[rowNum] = [];
			    }
			    acc[rowNum].push(item);
			    return acc;
			}, {});

			// 3. RowNum 숫자 순서대로 정렬된 키 배열 생성
			const sortedRowKeys = Object.keys(rowsMap).sort((a, b) => Number(a) - Number(b));
			
			// 4. 테이블 생성 로직
			for (const rowKey of sortedRowKeys) {
			    const rowItems = rowsMap[rowKey]; // 같은 RowNum을 가진 아이템 리스트
			    const currentRow = document.createElement('tr');
			    
			    // 해당 행의 높이는 포함된 아이템 중 가장 큰 AreaHeight를 사용하거나 첫 번째 아이템 기준
			    const maxHeight = Math.max(...rowItems.map(i => i.AreaHeight || 20));
			    currentRow.style.height = maxHeight + "px";
			    
			    for (const item of rowItems) {
			    	
			    	const isHtml = String(item.HTML).trim() == "1";
			    	
			        // th (속성명)
			        const th = document.createElement('th');
			        
			     	// Mandatory 처리
			        if(item.Mandatory == '1') th.innerHTML = '<p style="display:inline;color:#FF0000;">*</p>' + item.Name;
			        else th.innerText = item.Name;
			     	
			     	// trans 번역 버튼
			     	if(item.DataType === 'Text' && papagoTrans === 'Y' && isHtml !== '1'){
			     		const papagoBtn = document.createElement('button');
			     		papagoBtn.innerText = 'Translate';
			     	    papagoBtn.onclick = function() {
			     	        fnOpenPapagoTrans(item.AttrTypeCode, item.HTML);
			     	    };
			     	    th.appendChild(papagoBtn);
			     	}
					if(item.DataType === 'Text' && gptAITrans === 'Y' && isHtml !== '1'){
						const gptBtn = document.createElement('button');
					    gptBtn.innerText = 'Translate';
					    gptBtn.onclick = function() {
					        fnOpenGPTAITrans(item.AttrTypeCode, item.HTML);
					    };
					    th.appendChild(gptBtn);
			     	}
			     	
			        currentRow.appendChild(th);

			        // td (값)
			        const td = document.createElement('td');
			        td.classList.add('alignL', 'pdL10');
			        
			        // HTML 처리
			        
			        const content = item.PlainText || "";
			        
			        if (isHtml) {
			        	
			        	let tiny = '';
			        	tiny += '<div style="width:100%; height:'+item.AreaHeight+'px;" class="pd0">'
			        	tiny += '<textarea class="tinymceText" readonly="readonly" name="'+item.AttrTypeCode+'">'+content+'</textarea>'
			        	tiny += '</div>'
			        	td.innerHTML = decodeHtml(tiny);
						
			        } else {
			        	// Link 옵션
						const Link = item.Link || "";
			        	if(Link || attrUrl){
			        		var linkHtml = '<a onClick="fnRunLink(\'' + (item.URL || '') + '\', \'' + (attrUrl || '') + '\', \'' + (item.AttrTypeCode || '') + '\', \'' + (item.VarFilter || '') + '\');" ';
			        			linkHtml += 'style="color:#0054FF; text-decoration:underline; cursor:pointer;">';
			        			linkHtml += content;
			        			linkHtml += '</a>';
	           				td.innerHTML = linkHtml;
			        	} else {
				            td.textContent = content;
				            td.style.whiteSpace = "pre-wrap";
			        	}
			        }

			        // ColumnNum에 따른 colspan 처리
			        // rowItems 개수가 1개뿐이거나 ColumnNum이 0이면 colspan 적용
			        if (item.ColumnNum === 0 || rowItems.length === 1) {
			            td.colSpan = 3; 
			        }
			        
			        currentRow.appendChild(td);
			    };

			    tbody.appendChild(currentRow);
			};
			
			// 새 스크립트 요소 생성
		    const script = document.createElement('script');
		    script.type = 'text/javascript';
		    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>'; // JSP에서 c:url을 통해 URL 생성

		    document.body.appendChild(script);
		    

	    } catch (error) {
	        console.error("itemAttrList 가공 중 오류 발생:", error);
	        return;
	    }
		
	}

	/**
   	* @function decodeHtml
   	* @param {String} html
   	* @description HTML 엔티티(&lt; 등)를 실제 태그(< 등)로 변환합니다.
   	* @returns {String} 변환된 html
  	*/
	function decodeHtml(html) {
	    const txt = document.createElement("textarea");
	    txt.innerHTML = html;
	    return txt.value;
	}
	
	/**
   	* @function renderDimList
   	* @description api로 호출한 디멘션 정보를 가공하여 html 렌더링합니다.
  	*/
	async function renderDimList() {
		
		const sqlID = 'dim_SQL.selectDim'; 
	    const requestData = { s_itemID, languageID, sqlID };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}
			
			if (result && result.data) {
				
				// dimension 정보 가공
				const dimResultList = result.data.reduce((acc, current) => {
				    const existing = acc.find(item => item.dimTypeName === current.DimTypeName);
				    if (existing) {
				        existing.dimValueNames += " / " + current.DimValuePath;
				    } else {
				        acc.push({
				            dimTypeName: current.DimTypeName,
				            dimValueNames: current.DimValuePath
				        });
				    }
				    return acc;
				}, []);
				
				if(dimResultList.length > 0) {
					const dimensionSection = document.getElementById('dimensionSection');
					dimensionSection.style.display = "";
				}
				
				// html 렌더링
				if("${menuDisplayMap.HasDimension}" == '1') {
					for (const list of dimResultList) {
						const row = document.createElement('tr');
						row.innerHTML += '<th>'+list.dimTypeName+'</th>'
						row.innerHTML += '<td class="tdLast alignL">'+list.dimValueNames+'</td>'
						
						const dimensionList = document.querySelector("tbody[name='dimension-list']");
						dimensionList.appendChild(row);
					}
				}
			} else {
				return;
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function renderMstItem
   	* @description api로 호출한 MstItem 정보를 가공하여 html 렌더링합니다.
  	*/
	async function renderMstItem() {
		
		const sqlID = 'item_SQL.getRefItemInfoList'; 
		const sqlGridList = 'N';
	    const requestData = { mstItemID : s_itemID, languageID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}
			
			if (result && result.data && result.data.length > 0) {
				
				// html 렌더링
				const item = result.data[0];
				let html = '';
				
				html = `<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
					<colgroup>
						<col width="11%">
						<col width="89%">
					</colgroup>
					<tr>
						<td colspan="2" class="hr1">&nbsp;</td>
					</tr>
					<tr>
						<th>Master</th>
						<td class="tdLast alignL pdL5">							
							<a onClick="fnRefItemLayer('\${item.ItemID}','mstItemLayer');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
							<span id="mstItemLayer"> \${item.Identifier} \${item.ItemName}</span>
							</a>				
						</td>
					</tr>		
				</table>`;		
				
				const mainDiv = document.querySelector("#mainDiv");
				if (mainDiv) {
					mainDiv.insertAdjacentHTML('beforeend',html); 
				}
				
			} else {
				return;
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function getFileCNT
   	* @description 현재 item의 파일 count를 return 합니다.
    * @returns {Number} 파일 count
  	*/
	async function getFileCNT() {
		
    	let requestData = { DocumentID : s_itemID, s_itemID, hideBlocked: 'N', DocCategory : 'ITM', languageID };
    	// getRltdItemId
		const rltdItemId = await getRltdItemId();
		if(rltdItemId && rltdItemId !== ''){
			requestData = {
					...requestData,
					rltdItemId
			}
	    }
    	
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemFileListInfo.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();

			if (result && result.data && result.data.length > 0) {
				
				const count = result.data.length;
				
				// html 렌더링
	            const alarmElement = document.getElementById("fileAlarm");
	            if (alarmElement) {
	                alarmElement.textContent = count; 
	            }
				
			} else {
				return; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
    
    /**
   	* @function getRevCNT
   	* @description 현재 item의 REV count를 return 합니다.
    * @returns {Number} REV count
  	*/
	async function getRevCNT() {
		
		const sqlID = 'revision_SQL.getRevisionCOUNT'; 
		const sqlGridList = 'N';
	    const requestData = { documentID : s_itemID, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();

			if (result && result.data && result.data.length > 0) {
				
				const count = result.data.length;
				
				// html 렌더링
	            const alarmElement = document.getElementById("revAlarm");
	            if (alarmElement) {
	                alarmElement.textContent = count; 
	            }
	            
			} else {
				return; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
    /**
   	* @function getRltdItemId
   	* @description 현재 item의 연관항목 id를 return 합니다.
    * @returns {Number} 연관항목 id
  	*/
	async function getRltdItemId(){
	    const requestData = {
	        languageID: languageID,
	        DocumentID: s_itemID
	    };
	    
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getRltdItemId.do?" + params;
	    
	    try {
	        const response = await fetch(url, {
	            method: 'GET',
	        });
	        
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
			}
	        
	        const result = await response.json();
	        
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
	        
			if (result && result.data) {
	        	return result.data;
			} else {
				return "";
			}
	    } catch (error) {
	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
	    }
	}
	//---------------------------------------------------------
	//[API] END ::
	//---------------------------------------------------------
	
	/**
   	* @function handleAjaxError
   	* @description 데이터 로드 실패 시 에러 메시지 팝업 출력
   	* @param {Error} err - 발생한 에러 객체
  	*/
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

</script>

<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${option}"/>
	<input type="hidden" id="onlyMap" name="onlyMap"  value="" />
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="lovCode" name="lovCode"  value="" />
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 

<!-- button -->
<ul class="align-center child_search01 flex justify-between mgB5 mgT5">
   <li id="menuDisplay" style="position:relative;">
 		<c:if test="${itemBlocked eq '0' && sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
  			<span class="btn_pack nobg white"><a href="javascript:goItemInfoEdit();"class="edit mgT2 " title="Attributes"></a></span>		   		
   	    </c:if>
   	  	<c:if test="${menuDisplayMap.FileOption ne  'N'}">
	  		<span class="btn_pack nobg" alt="FILEMGT" title="Files"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('fileMgt');" class="file mgT2 mgR3" alt="imgFILEMGT"></a>
  				<font color="#1141a1" class="count-floating" id="fileAlarm"></font>
	  		</span>
	  	</c:if>
	   	<c:if test="${menuDisplayMap.HasDimension eq '1' && itemBlocked eq '0' && myItem == 'Y'}">
	  		<span class="btn_pack nobg" alt="DIMENSION" title="Dimension"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('dim');" class="dimen mgT2 mgR3" alt="imgDIMENSION"></a>
	  			<font color="#1141a1" class="count-floating">${menuDisplayMap.DIM_CNT}</font>
	  		</span>
	  	</c:if>
	  	<c:if test="${isExistModel eq 'Y'}">
	  		<span class="btn_pack nobg" alt="Occurrence" title="Occurrence"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('model');"class="model mgT2 mgR3"></a>
	  			<font color="#1141a1" class="count-floating">${MDL_CNT}</font>
	  		</span>
	  	</c:if>
	  	<c:if test="${changeMgt ne '1' && curChangeSet ne '' && itemStatus ne 'NEW1' && itemStatus ne 'NEW2'}">
   			<span class="btn_pack nobg" alt="Revision" title="Revision"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('rev');" class="edit2 mgT2 mgR3"></a>
	  			<font color="#1141a1" class="count-floating" id="revAlarm"></font>`
  			</span>
	  	</c:if>
   </li>
</ul>
<div id="htmlReport" style="width:100%;padding:0;" class="mgB20">
<input type="hidden" id="url" name="url" >	
	<div id="mainDiv">
		<!-- 속성 -->
		<table class="new-form form-column-8 mgB20" style="display:none;" id="attrSection" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<colgroup>
				<col width="12%">
				<col width="38%">
				<col width="12%">
				<col width="38%">
			</colgroup>
			<tbody name="attr-list"></tbody>
		</table>
		
		<!-- 디멘션 -->
		<table class="new-form form-column-8 mgB20" style="display:none;" id="dimensionSection" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<colgroup>
				<col width="12%">
				<col width="88%">
			</colgroup>
			<tbody name="dimension-list"></tbody>
		</table>
		
		<!-- 파일 -->
		<table class="new-form form-column-8" style="display:none;" id="fileSection" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<colgroup><col width="12%"><col width="88%"></colgroup>
			<tr>
				<th class="alignL pdL10">${menu.LN00111}</th>
				<td>
					<div class="tmp_file_wrapper" style="border: none;padding: 0;">
						<table width="100%" style="table-layout:fixed;">
							<colgroup>
								<col width="40px">
								<col>
								<col width="80px">
							</colgroup>
							<tbody name="file-list"></tbody>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
</div>

<!-- 관련항목 메뉴 레이어 팝업 -->	
<div class="connection_layer" id="connectionPopup">	
	<span class="closeBtn">
		<span style="cursor:pointer;_cursor:hand;position:absolute;right:10px;" OnClick="fnCloseLayer();">Close</span>
	</span> <br>					
	<div class="mgT10 mgB10 mgL5 mgR5">
	<table id="link" class="tbl_blue01 mgT5" style="width:100%;height:99%;table-layout:fixed;">	
	</table> 
	</div>
</div> 
	
</form>

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>	
<!-- END :: FRAME -->


<script>
//---------------------------------------------------------
//[사용 여부 확인이 필요한 function] ::
//---------------------------------------------------------
function DiagramAsNewWindow(itemId, modelId) {
	var url = "PopupModelDiagramMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=" + itemId 
			+"&modelID="+ modelId +"&percentOfImage=100&getWidth=1200&getCheck=0";
	var w = 1200;
	var h = 900;
	openPopup(url,w,h,itemId);
}

/* 프린트 버튼 클릭 이벤트 */
function printDiv() {
	var url = "NewItemInfoMain.do?";
	var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&kbn=printView"; 
	var w = 700;
	var h = 800;
	openPopup(url+data,w,h,"popUpPrint");
	
}


// 미사용 api
/**
* @function getPrcList
* @description api로 호출한 기본정보를 html 렌더링합니다.
*/
async function getPrcList() {
	const sqlID = 'report_SQL.getItemInfo'; 
	const sqlGridList = 'N';
    const requestData = { languageID, s_itemID, sqlID, sqlGridList };
    const params = new URLSearchParams(requestData).toString();
    const url = "getData.do?" + params;
    
    try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message);
		}
		
		if (result && result.data) {
			
			const table = document.getElementById("processInfo");
            let html = "";
			
            result.data.forEach(prc => {
                html += `
                    <colgroup> 
                        <col width="11%"><col width="14%"><col width="11%"><col width="14%">
                        <col width="11%"><col width="14%"><col width="11%"><col width="14%">
                    </colgroup>
                    <tr>
                        <th class="viewtop">${menu.LN00016}</th>
                        <td class="viewtop">\${prc.ClassName || ''}</td>
                        <th class="viewtop">${menu.LN00027}</th>
                        <td class="viewtop">\${prc.StatusName || ''}</td>                
                        <th class="viewtop">${menu.LN00070}</th>
                        <td class="viewtop">\${prc.LastUpdated || ''}</td>
                        <th class="viewtop">${menu.LN00013}</th>
                        <td class="tdLast viewtop">\${prc.CreateDT || ''}</td>
                    </tr>
                    <tr>                
                        <th>${menu.LN00018}</th>
                        <td style="cursor:pointer;color: #0054FF;text-decoration: underline;" onclick="fnOpenTeamInfoMain('\${prc.OwnerTeamID}')">\${prc.OwnerTeamName || ''}</td>
                        <input type="hidden" name="orderTeamName" value="\${prc.OwnerTeamName || ''}"/>
                        <th>${menu.LN00004}</th>
                        <td id="authorInfo"></td> <th>${menu.LN00352}</th>
                        <td>\${prc.TeamName || ''}</td>
                        <th>${menu.LN00131}</th>
                        <td>\${prc.ProjectName || ''}</td>
                    </tr>
                    <tr>
                        <th style="height:53px;">${menu.LN00019}</th>
                        <td style="height:53px;" class="tdLast alignL" colspan="7">
                            <div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;" id="fileList"></div>
                        </td>
                    </tr>`;
            });

            // 최신 이전 changeSet 정보
            const preCSID = "${preChangeSetID}";
            if (preCSID && preCSID !== "") {
                html += `
    				<tr>
    					<th>Previous</th>
    					<td colspan="7" class="tdLast alignL">							
    						<a onClick="fnOpenViewVersionItemInfo('${preChangeSetID}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
    						Ver.${preChangeSetInfo.Version}&nbsp;Last released on&nbsp;${preChangeSetInfo.CompletionDT}&nbsp; 
    						by ${preChangeSetInfo.AuthorName}
    						</a>				
    					</td>
    				</tr>`;
            }

            table.innerHTML = html;
            
            // [담당자]
            const authorTarget = document.querySelector("#authorInfo");
            if (authorTarget) {
                await getRoleAssignMemberList(authorTarget);
            }
    		// [첨부문서]
    		const fileTarget = document.querySelector("#fileList");
            if (fileTarget) {
            	await getFileList(fileTarget);
            }
			
		} else {
			return;
		}

	} catch (error) {
		handleAjaxError(error);
	}
}
/**
* @function getRoleAssignMemberList
* @description 담당자 정보를 조회합니다.
*/
async function getRoleAssignMemberList(targetElement) {
	const res = await fetch("/getAssignmentMemberList.do?s_itemID=${s_itemID}&languageID=${languageID}&assignmentType=CNGROLETP");
	const data = await res.json();
	let html = "";
	
	if (data.data.length === 0) {
        return;
    }
	
	const target = targetElement || document.querySelector("#authorInfo");
	if(!target) return;
	
	if(data.data.length === 1) {
		html = "${itemInfo.Name}";
		target.style = "cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;";
		target.addEventListener("click", () => fnGetAuthorInfo("${itemInfo.AuthorID}"));
	}
	
	if(data.data.length > 1) {
		html = '<select id="roleAssignMember" Name="roleAssignMember" style="height: 30px;" onchange="fnGetAuthorInfo(this.value);">'
		for (const list of data.data) {
			html += '<option value="'+list.MemberID+'">'+list.Name+'</option>'
		}
		html += '</select>'
	}
	
	target.insertAdjacentHTML("beforeEnd", html);
}


function fnItemLinkLayer(itemID, layerID, classCode){ 
	var layerWindow = $('.connection_layer');
	var pos = $('#'+layerID).offset();  
	linkLayerPopupView(layerID, 'connectionPopup', pos);
	
	// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
	document.getElementById("htmlReport").onscroll = function() {
		// 본문 레이어 팝업
		layerWindow.removeClass('open');
	};
	fnSetLinkList(itemID, classCode);
}

function fnSetLinkList(itemID, classCode){
	var data="itemID="+itemID+"&itemClassCode="+classCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	var returnData;
	var layerOpen = "Y";
	$.ajax({   
		url : "getAttrLinkList.do",     
		type: "POST",     
		data : data,
		//dataType :  'json',
		//contentType: "application/x-www-form-urlencoded; charset=utf-8",
		beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
		success: function(returnData){
			var arrReturnData = returnData.split("/");
			var link = arrReturnData[0].split(",");
			var url = arrReturnData[1].split(",");				
			var lovCode = arrReturnData[2].split(",");
			var attrTypeCode = arrReturnData[3].split(",");
			var cnt = arrReturnData[4].split(",");
			var linkLayer ="";
			linkLayer += "<tr>";
			linkLayer += "<td style='cursor:hand;height:20px;' onClick='fnOpenItemPop("+itemID+");' class='alignL last'>${menu.LN00138}</td>";
			linkLayer += "</tr>"; 
			
			if(cnt > 0){					
				for(var i=0; i<link.length; i++){ 
					$("#url").val(url[i]);
					$("#lovCode").val(lovCode[i]);
					linkLayer += "<tr>";
					linkLayer += "<td height='20px' style='cursor:hand;' onClick='fnGoLink("+itemID+",\""+attrTypeCode[i]+"\");' class='alignL last'> "+link[i]+" </td>";
					linkLayer += "</tr>";
				}
				$('.connection_layer').addClass('open');
				$('#link').html(linkLayer);
			}else{
				fnOpenItemPop(itemID);					
			} 				
		},     
		error: function (jqXHR, textStatus, errorThrown)     {       }
		});
}

function fnGoLink(itemID, attrTypeCode){ 
	var lovCode = $("#lovCode").val();
	var url = $("#url").val();
	if(url == null || url == ""){
		alert("No system can be executed!");
		return;
	}else{		
		url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	}
	window.open(url,'_newtab');
}

//최신 changeSet 이전 changSet 정보 
function fnOpenViewVersionItemInfo(changeSetID){
	var projectID = "${preChangeSetInfo.ProjectID}";
	var authorID = "${preChangeSetInfo.AuthorID}";
	var status = "${preChangeSetInfo.Status}";
	var version = "${preChangeSetInfo.Version}";

	var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}"
				+"&changeSetID="+changeSetID
				+"&projectID="+projectID
				+"&authorID="+authorID
				+"&status="+status
				+"&version="+version;
	window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
}

function fnRegNewCSR(){
	if(confirm("${CM00058}")){
		//var url = "csrDetailPop.do?isNew=Y&quickCheckOut=Y&itemID=${s_itemID}";	
		var url = "registerCSR.do?quickCheckOut=Y&itemID=${s_itemID}";
		var pop_state;
		pop_state = window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
		pop_state.focus();
	}
}
function fnOpenTeamInfoMain(teamID){
	var w = "1200";
	var h = "800";
	var url = "orgMainInfo.do?id="+teamID;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
}


</script>