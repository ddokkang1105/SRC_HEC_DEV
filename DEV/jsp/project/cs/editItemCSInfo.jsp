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
  var changeSetID = "${changeSetID}";
  var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
  

  // 게시글에 이미 첨부되어있던 파일들 정보
  var previousAddedBoardFilesRaw = "${attachFileList}";

  function javaObjToArr(str) {
    if (str == "") return [];

    let jsonStr = str.replace(/(\w+)=/g, '"$1":');
    jsonStr = jsonStr.replace(/:\s*([,\}\]])/g, ':""$1');

    jsonStr = jsonStr.replace(/:([^,\}\]]+)/g, (match, value) => {
      value = value.trim();
      if (value === '""') return ':' + value;
      if (!isNaN(value) && value !== '') return ':' + value;
      if (value.startsWith('"') && value.endsWith('"')) return ':' + value;
      return ':"' + value + '"';
    });

    return JSON.parse(jsonStr);
  }

  var fileObjArray = javaObjToArr(previousAddedBoardFilesRaw);

  function extractFileRealNamesToSet(arr) {
    if (!Array.isArray(arr) || arr.length === 0) return new Set();
    return new Set(arr.map(item => item.FileRealName));
  }

  function removeBySeqInPlace(arr, seqValue) {
    const index = arr.findIndex(item => item.Seq == seqValue);
    if (index !== -1) arr.splice(index, 1);
    return arr;
  }

  var previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);

  var scrnType = "CS";
  var docCategory = "CS";
  var mgtId = "${resultMap.BoardMgtID}";
  var boardId = "${resultMap.BoardID}";
  var s_itemID = "${s_itemID}"
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

<style>

  html, body { height: 100%; margin: 0; }

  #changeInfoEditFrm { height: 100%; }

  #revisionArea{
    overflow-x: hidden;
  }

.changeset-description-textarea {
  width: 100%; height: 80px; resize: none;
  overflow-y: auto; padding: 10px; font-size: small;
}

.empty-placeholder { font-style: italic; color: #9ca3af; }

.changeset-files-outer-container {
  height: 130px; resize: none;
  overflow-y: auto; padding: 10px;
}

.changeset-files-inner-container {
  width:100%; display:flex; justify-content: space-between; height: 100%;
  padding: 4px 10px; border: 1px solid #d1d5db; border-radius: 4px; background-color: #f9fafb;

  box-sizing: border-box;
}




*, *::before, *::after { box-sizing: border-box; }

/* 첨부파일 영역 가로 스크롤 방지 */
/* .changeset-files-outer-container {
  overflow-x: hidden !important;
}
 */

</style>

<script type="text/javascript">

  var nOdListSize = "${nOdList.size()}";
  var changeType = "${getData.ChangeTypeCode}";

  $(document).ready(function(){
    $("input.datePicker").each(generateDatePicker);

 /*    $('#saveChangeSetInfo').click(function(e){
      saveChangeSetInfo();
    }); */

    var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
    fnSelect('changeType', data+"&category=CNGT1", 'getDictionaryOrdStnm', '${getData.ChangeTypeCode}', 'Select');

    // 기존 desHeight 계산 로직 유지
    var desHeight = 150;

    if (nOdListSize > 0 && changeType == 'MOD') desHeight += 40;
    $("#description").css({ width: "100%", height: desHeight + "px" });

    resizeChangeInfoLayout();
    $(window).on("resize", resizeChangeInfoLayout);

    if ($("#itemListBox").length) {
      $("#itemListBox").css("height", (setWindowHeight() - 460) + "px");
      $(window).on("resize", function(){
        $("#itemListBox").css("height", (setWindowHeight() - 480) + "px");
      });
    }
    
    // 화면 로드 후 실행
    //변경내역
    renderRevisionList();
	//첨부파일 
    loadAttachFileList();
  });

  function setWindowHeight(){
    return window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
  }

  function resizeChangeInfoLayout() {
    var h = setWindowHeight();
    var outerOffset = 20;

    var viewDivH = Math.max(300, h - outerOffset);


    var maxDesc = Math.max(120, viewDivH - 350);
    var currentDescH = $("#description").outerHeight() || 0;
    if (currentDescH > maxDesc) {
      $("#description").css("height", maxDesc + "px");
    }
  }

  
	// 변경 항목 데이터 API
async function getCSInfoView(){

	  const requestData = { changeSetID, languageID };
      const params = new URLSearchParams(requestData).toString();
	  const url = "getRevisionCSInfoView.do?" + params;
    
	  try{
		  const response = await fetch(url, { method: 'GET' });
			//조회용 api method = GET
		  	if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(response.statusText, response.status);
				}
			
		  	const result = await response.json();
		  	
		  	if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		  	
		    if(result.data){
		    	 return result.data;
	        } else {
	        	throw new Error(`Problem with data occured: ${data}`)
	        }

		  
	  }catch (error) {	
	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.    	
	    } finally {
	    	$('#loading').fadeOut(150);
	    }

	}
	

 
	
//화면에 변경내역 렌더링 
 async function renderRevisionList() {
	  const list = await getCSInfoView();
	  const area = document.getElementById('revisionArea');
	  const tbody = document.getElementById('revisionTbody');
	  if (!tbody || !area) return;
	  tbody.innerHTML = '';
	  if (!Array.isArray(list) || list.length === 0) {
	    area.style.display = 'none';
	    return;
	  }
	  area.style.display = 'block';   

	  let html = '';
	  for (var i = 0; i < list.length; i++) {
	    var r = list[i];
	    html += '<tr>'
	         +  '<td class="alignC pdL5 last">' + (r.Identifier || '') + '</td>'
	         +  '<td class="alignC pdL5 last">' + (r.ItemName || r.RevisionType || '') + '</td>'
	         +  '<td class="alignC pdL5 last">' + (r.ClassName || '') + '</td>'
	         +  '<td class="alignC pdL5 last" style="cursor:pointer;"'
	         +   ' onclick="goItemPopUp(\'' + r.ItemID + '\')">'
	         + (r.Description || '') + '</td>'
	         + '</tr>';
	  }
	  tbody.innerHTML = html;

	}

 

  // [List] click
  function goBack() {
    var isItemInfo = "${isItemInfo}";
    var isStsCell = "${isStsCell}";
    var isMyTask = "${isMyTask}";
    var url = "changeInfoList.do";
    var target = "help_content";
    var data = "ProjectID=${ProjectID}&mainMenu=${mainMenu}&screenMode=${screenMode}"
      + "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isNew=${isNew}"
      + "&currPageA=${currPageA}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}"
      + "&isMyTask=${isMyTask}";

    if (isItemInfo == "Y" && isStsCell == "Y") {
      url = "itemHistory.do";
      data = "s_itemID=${seletedTreeId}";
    }
    if (isMyTask == "Y") {
      url = "myChangeSet.do";
    }
    ajaxPage(url, data, target);
  }


  
	function fnCallBack(checkInOption){

		
		if(checkInOption == "03" || checkInOption == "03A" || checkInOption == "03B"){
		
			window.goApprovalPop();
					
			window.fnItemMenuReload();	
			if (window.currentDhxModal) {
			    window.currentDhxModal.close();
			}
			
	
			
		}else{
			
			window.fnItemMenuReload();	
			if (window.currentDhxModal) {
			    window.currentDhxModal.close();
			}
	
		} 


	}  
	function fnEvaluation(){ 
		$("#evDiv").attr("style","visibility:visible");
	}
	
/* 	function fnSaveEvaluation(){
		if (confirm("${CM00001}")) {
			var url = "saveEVSore.do";			
			ajaxSubmit(document.changeInfoEditFrm, url, "saveFrame");
		}
	} */
	
/* 	function fnSetEvScore(evScore,attrTypeCode,lovCode){
		$("#evScore"+attrTypeCode).val(evScore);
		$("#lovCode"+attrTypeCode).val(lovCode);
	} */
	
/* 	function fnCallBackAppr(){
		var url = "viewItemChangeInfo.do"
		var data = "changeSetID=${getData.ChangeSetID}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=${mainMenu}&seletedTreeId=${seletedTreeId}"
			+ "&screenMode=view&isMyTask=Y&isItemInfo=${isItemInfo}";
		var target = "changeInfoEditFrm";
		
		ajaxPage(url, data, target);
	} 
	 */
	function fnCallBackSave(){
		var url = "editItemCSInfo.do"
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
	
	
  /* 첨부문서 다운로드 */
  function FileDownload(checkboxName, isAll){
    var seq = new Array();
    var j =0;
    var checkObj = document.all(checkboxName);

    if (isAll == 'Y') {
      if (checkObj.length == undefined) {
        checkObj.checked = true;
      }
      for (var i = 0; i < checkObj.length; i++) {
        checkObj[i].checked = true;
      }
    }

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
    ajaxSubmitNoAdd(document.changeInfoEditFrm, url,"saveFrame");

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
  
  
/* 	function setChsFrame(avg){
		
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
		
	} */
	
	
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
// 	        display_scripts = display_scripts +
// 	            '<div id="'+fileID+'" class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
// 	            '   <img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:25px;height:15px;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+', true)">' +
// 	            '   <br>' +
// 	            '</div>';		
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
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
	//****************** 첨부파일 API *******************************//
	
	
	async function loadAttachFileList() {
    const fileList = await getChangesetFileInfo(s_itemID, languageID, changeSetID);
    renderAttachFileList(fileList);
}
	
	async function getChangesetFileInfo (s_itemID, languageID, changeSetID) {
	$('#loading').fadeIn(150);
	
	const isPublic = 'N';
    const DocCategory = 'CS';
	const requestData = { s_itemID, languageID, changeSetID, isPublic, DocCategory  };
    
    const params = new URLSearchParams(requestData).toString();
    const url = "getItemFileListInfo.do?" + params;

    
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
        
        // success 체크
        if(result.data && (Array.isArray(result.data))){
            return result.data;
        } else {
         //   console.error(data.message || 'Unknown error occurred');
            console.error(result.message || 'Unknown error occurred');
            return [];
        }
        
    } catch (error) {
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
    	return [];
    } finally {
    	$('#loading').fadeOut(150);
    }
}

	
	function renderAttachFileList(fileList) {
// 	    const fileItemsEl = document.getElementById("fileList");
	    
// 	    const fileButtonsEl = document.getElementById("tmp_file_buttons");

// 	    if (!fileItemsEl || !fileButtonsEl) return;

// 	    fileItemsEl.innerHTML = "";
// 	    fileButtonsEl.innerHTML = "";

// 	    if (!Array.isArray(fileList) || fileList.length === 0) {
// 	        fileItemsEl.innerHTML = `<div id="emptyAttachPlaceholder" class="empty-placeholder">첨부된 파일이 없습니다.</div>`;
// 	        return;
// 	    }
// 	    let fileHtml = "";

// 	    fileList.forEach(function(file) {
// 	        var deleteBtnHtml = "";

// 	        if (sessionUserId == file.RegMemberID && file.DocCategory != "ITM") {
// 	            deleteBtnHtml =
// 	                '<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" ' +
// 	                'style="cursor:pointer;width:25px;height:15px;padding-left:10px" ' +
// 	                'alt="Delete file" ' +
// 	                'align="absmiddle" ' +
// 	                'onclick="fnDeleteItemFile(\'' + file.Seq + '\')">';
// 	        }

// 	        fileHtml +=
// 	            '<div id="divDownFile' + file.Seq + '" class="mm" name="divDownFile' + file.Seq + '">' +
// 	                '<input type="checkbox" name="checkedFile" value="' + file.Seq + '" style="margin-right:8px;">' +
// 	                '<span style="cursor:pointer; color:#2563eb; flex:1;" onclick="fileNameClick(\'' + file.Seq + '\');">' +
// 	                    (file.FileRealName || '') +
// 	                '</span>' +
// 	                deleteBtnHtml +
// 	            '</div>';

	   		let html = "";
			
			style = fileList.length > 0 ? "border: none;padding: 0;" : "display:none;";
			html += '<div class="tmp_file_wrapper" style="'+style+'" id="tmp_file_wrapper">';
			html += '<table id="tmp_file_items" name="tmp_file_items" width="100%">';
			html += '<colgroup><col width="40px"><col width=""><col width="70px"></colgroup>';
			html += '<tbody name="file-list">';
			for(var i = 0; i < fileList.length; i++) {
				html += '<tr id="'+fileList[i].Seq+'">';
				html += '<td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteItemFile(\''+fileList[i].Seq+'\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>';
				html += '<td name="fileName" class="downloadable" onclick="fileNameClick(\'' + fileList[i].Seq + '\');">'+fileList[i].FileRealName+'</td>';
				html += '<td class="alignR">'+textfileSize(fileList[i].FileSize)+'</td>';
				html += '</tr>';
			}
			html += '</tbody>';
			html += '</table>';
			html += '</div>';
			
			document.querySelector("#csFileList").insertAdjacentHTML("beforeend", html);
// 	    });

// 	    fileItemsEl.innerHTML = fileHtml;

// 	    fileButtonsEl.innerHTML =
// 	        '<span class="btn_pack medium icon" style="margin-right: 8px;">' +
// 	            '<span class="download"></span>' +
// 	            '<input value="&nbsp;Download All&nbsp;&nbsp;" type="button" onclick="FileDownload(\'checkedFile\', \'Y\')">' +
// 	        '</span>' +
// 	        '<span class="btn_pack medium icon">' +
// 	            '<span class="download"></span>' +
// 	            '<input value="Download" type="button" onclick="FileDownload(\'checkedFile\', \'N\')">' +
// 	        '</span>';
	}
</script>

<form name="changeInfoEditFrm" id="changeInfoEditFrm" enctype="multipart/form-data" action="#" method="post" onsubmit="return false;">

  <div id="changeInfoEditDiv" class="hidden">

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

<!--     <div class="cop_hdtitle" style="border-bottom:1px solid #ccc"> -->
<!--       <h3 style="padding: 6px 0 6px 6px"> -->
<%--         <img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${menu.LN00207} --%>
<!--       </h3> -->
<!--     </div> -->

    <div id="tblChangeSet" style="width:99%">

      <!--  table 중첩 제거: table 하나만 사용 -->
      <table class="new-form form-column-8" style="table-layout:fixed; width:100%;" border="0" cellpadding="0" cellspacing="0">
        <colgroup>
          <col width="10%"/>
          <col width="90%"/>
          <%-- <col width="10%"/>
          <col width="22%"/>
          <col width="10%"/>
          <col width="23%"/> --%>
        </colgroup>

        <tr>
		  <!-- 버전  -->
          <th>${menu.LN00017}</th>
          <td>
            <input type="text" id="version" name="version" value="${getData.Version}" class="text" style="width:100%">
          </td>
         </tr>
         <tr>
          <!-- 변경구분 -->
          <th>${menu.LN00022}</th>
          <td>
            <select id="changeType" name="changeType" style="width:100%"></select>
          </td>
          </tr>
          <!-- 시행일  -->
          <tr>
          <th>${menu.LN00296}</th>
          <td>
            <input type="text" id="ValidFrom" name="ValidFrom"
              value="${fn:trim(getData.ValidFrom)}"
              class="input_off datePicker stext" size="8" style="width: 120px;"
              onchange="this.value = makeDateType(this.value);"
              maxlength="10">
          </td>
        </tr>

   
	<tr>
  <th>${menu.LN00290}</th>
  <td colspan="5">
      <!-- 변경개요  -->
      <c:choose>
        <c:when test="${empty getData.Description}">
            <textarea id="description" name="description"
			  class="changeset-description-textarea edit"
			  placeholder="작성된 변경이력 내역이 없습니다."><c:out value="${getData.Description}"/></textarea>
        </c:when>
        <c:otherwise>
          <textarea id="description" name="description" 
            class="changeset-description-textarea">${getData.Description}</textarea>
        </c:otherwise>
      </c:choose>
  </td>
	</tr>
<tr>
  <th>${menu.LN00122}</th>
  <td colspan="5" id="csFileList">
<!-- 	 <div class="changeset-files-outer-container"> -->
<!-- 	      <div class="changeset-files-inner-container"> -->
<!-- 	        파일 목록 -->
<!-- 	        <div> -->
<!-- 	          <div id="tmp_file_items"></div> -->
<!-- 	        </div> -->
<!-- 	        버튼 -->
<!-- 	        <div id="tmp_file_buttons"></div> -->
<!-- 	      </div> -->
<!-- 	    </div> -->
	</td>
	</tr>
	
 <%-- 	      <!-- 첨부파일  -->
	      <div class="changeset-files-outer-container">
	        <div class="changeset-files-inner-container">
	
	          <!-- 파일 목록 -->
	         <div style="flex:1; min-width:0; max-height:120px; overflow-y:auto;">
	           <div id="tmp_file_items" name="tmp_file_items"></div>
	            <c:choose>
	              <c:when test="${attachFileList.size() > 0}">
	                <c:forEach var="fileList" items="${attachFileList}">
	                
	                 <div id="divDownFile${fileList.Seq}" class="mm" name="divDownFile${fileList.Seq}">
	                    <input type="checkbox" name="checkedFile" value="${fileList.Seq}" style="margin-right:8px;">
	                    <span style="cursor:pointer; color:#2563eb; flex:1;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
	                   <c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID && fileList.DocCategory != 'ITM'}">
	                    <img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:25px;height:13px;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('${fileList.Seq}')">
	                  </c:if>
	                  </div>
	                </c:forEach>
	              </c:when>
	              <c:otherwise>
	                <div class="empty-placeholder">첨부된 파일이 없습니다.</div>
	              </c:otherwise>
	            </c:choose>
	          </div>
	
	          <!-- 버튼 -->
	          <div style="margin-left:10px; flex:0 0 auto; text-align:right; display:flex; align-items:flex-end; gap:8px;">
	            <c:if test="${attachFileList.size() > 0}">
	              <span class="btn_pack medium icon" style="margin-right: 8px;">
	                <span class="download"></span>
	                <input value="&nbsp;Download All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')">
	              </span>
	              <span class="btn_pack medium icon">
	                <span class="download"></span>
	                <input value="Download" type="button" onclick="FileDownload('checkedFile', 'N')">
	              </span>
	            </c:if>
	          </div>
	
	        </div>
	      </div> --%>

<!--         <tr> -->
<!--         버튼  -->
<!--           <td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9"> -->
<%--             <c:if test="${fileTypeCount >= 1}"> --%>
<!--               <span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp; -->
<%--             </c:if> --%>
<!--             <span class="btn_pack medium icon"><span class="confirm"></span><input value="Check in" onclick="fnCheckInItem()" type="submit"></span> -->
<!--           </td> -->
<!--         </tr> -->
      </table>

	<div class="btn-wrap mgT10">
		<div></div>
		<div class="btns">
			<c:if test="${fileTypeCount >= 1}">
				<button class="secondary" onclick="openDhxVaultModal()">Attach</button>
			</c:if>
			<button class="primary" onclick="fnCheckInItem()">Check in</button>
		</div>
	</div>
	<div id="revisionArea" style="width:100%; overflow:auto; display:none;">
   			<span class="cop_hdtitle" >＊ ${menu.LN00205}</span>
			  <table class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" border="0">
			    <colgroup>
			      <col width="11%">
			      <col width="30%">
			      <col width="11%">
			      <col width="67%">
			    </colgroup>
			    <thead>
			      <tr>
			        <th class="last">${menu.LN00106}</th>
			        <th class="last">${menu.LN00028}</th>
			        <th class="last">${menu.LN00016}</th>
			        <th class="last">${menu.LN00290}</th>
			      </tr>
			    </thead>
			    <tbody id="revisionTbody"></tbody>
			  </table>
		</div>

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
                <td class="alignC pdL5 last">${list.Identifier}</td>
                <td class="alignC pdL5 last">${list.ItemName}</td>
                <td class="alignC pdL5 last">${list.StatusName}</td>
                <td class="alignC pdL5 last">${list.Path}</td>
                <td class="alignC pdL5 last">${list.CreationTime}</td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </c:if>

    </div><!-- /tblChangeSet -->
  </div><!-- /changeInfoEditDiv -->
</form>

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
