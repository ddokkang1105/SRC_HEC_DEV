<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_3" arguments="${menu.LN00035}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_4" arguments="${menu.LN00017}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00085" var="WM00085_5" arguments="${menu.LN00022}"/>
<style>
.subrow-changeset-container { border: 1px solid #d1d5db; }

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
}

.changeset-individual-file {
  padding: 5px 0; display: flex; align-items: center; border-bottom: 1px solid #e5e7eb;
}


*, *::before, *::after { box-sizing: border-box; }

/* 첨부파일 영역 가로 스크롤 방지 */
/* .changeset-files-outer-container {
  overflow-x: hidden !important;
}
 */
.changeset-files-inner-container {
  width: 100%;
  box-sizing: border-box;
}
</style>
<script type="text/javascript">

	var revListSize = "${revisionList.size()}";
	var nOdListSize = "${nOdList.size()}";
	var changeType = "${getData.ChangeTypeCode}";
	var changeSetID = "${changeSetID}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var dhxModal = null;
    var s_itemID = "${s_itemID}";

	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
				
		  //  기존 desHeight 계산 로직 유지
		  var desHeight = 150;
		  if (revListSize > 0) desHeight += 40;
		  if (nOdListSize > 0 && changeType == 'MOD') desHeight += 40;
		  $("#description").css({ width: "100%", height: desHeight + "px" });

		  //  레이아웃 리사이즈 호출
		  resizeChangeInfoLayout();

		  //  resize는  이벤트로 추가
		  $(window).on("resize", resizeChangeInfoLayout);

		  //  itemListBox도 여기서 같이 처리 (window.onresize 덮어쓰기 제거)
		  if ($("#itemListBox").length) {
		    $("#itemListBox").css("height", (setWindowHeight() - 460) + "px");
		    $(window).on("resize", function(){
		      $("#itemListBox").css("height", (setWindowHeight() - 480) + "px");
		    });
		  }
		  
		  renderRevisionList();
		  loadAttachFileList();
	});
	
	function setWindowHeight(){
		  return window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		}

	function resizeChangeInfoLayout() {
		  var h = setWindowHeight();
		  var outerOffset = 20;
		  var viewDivH = Math.max(300, h - outerOffset);
		  $("#changeInfoViewDiv").css("height", viewDivH + "px");
		  var maxDesc = Math.max(120, viewDivH - 350);
		  var currentDescH = $("#description").outerHeight() || 0;
		  if (currentDescH > maxDesc) {
		    $("#description").css("height", maxDesc + "px");
		  }
		  if ($("#revisionArea").length) {
		    var revisionH = Math.max(150, viewDivH - 520);
		    $("#revisionArea").css("height", revisionH + "px");
		  }
		  
		}

	
	// 변경 항목 데이터 API
async function getCSInfoView(){

	const requestData = { changeSetID, languageID };
	const params = new URLSearchParams(requestData).toString();
	const url = "getRevisionCSInfoView.do?" + params;
    
	
	try{
		 const response = await fetch(url, { method: 'GET' });
		 
		 if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
		    }
		 const result = await response.json();
		
		 if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		 if (result.data) { //data.data : 결과값
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
	
	/*변경항목 목록   */
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

	
function handleAjaxError(err, errDicTypeCode) {
	console.error(err);
	Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
			.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
}


	// [edit] or [back] click
	function goEditOrView(avg) {
		var isItemInfo = "${isItemInfo}";
		var isStsCell = "${isStsCell}";
		var isMyTask = "${isMyTask}";
		var url = "viewItemCSInfo.do";
		var target = "changeInfoViewFrm";
		var data = "screenMode="+avg+"&changeSetID=${getData.ChangeSetID}&StatusCode=${StatusCode}&isAuthorUser=Y"
				+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}"
				+ "&mainMenu=${mainMenu}&s_itemID=${s_itemID}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
				+ "&currPageA=${currPageA}&isMyTask=${isMyTask}";
		
		if (isItemInfo == "Y" && isStsCell == "Y") {
			url = "itemHistory4.do"; // 변경이력
			data = "s_itemID=${seletedTreeId}";
		}
		if (isMyTask == "Y") {
			target = "changeInfoLstTskFrm";
		}

		ajaxPage(url, data, target);
	}
	
	// [Item] click

	function goItemPopUpNoID() {

		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${getData.ItemID}&scrnType=pop&itemMainPage=/itm/itemInfo/itemMainMgt";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,"${getData.ItemID}");
	}
	

	
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
		
	// [Rework] click
	function rework() {
		if (confirm("${CM00059}")) {
			var url = "rework.do";
			$("#item").val("${getData.ItemID}");
			$("#cngt").val("${getData.ChangeSetID}");
			$("#pjtId").val("${ProjectID}");
			ajaxSubmit(document.changeInfoViewFrm, url);
		}
	}
	
	function fnCallBack(){
		var isItemInfo = "${isItemInfo}"; 
		if(isItemInfo == "Y"){ opener.fnCngCallBack();
		}else{ opener.doSearchCngtList(); }		
		//self.close();		
		closeMe();
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
		
	
	function fnCallBack(){
		var isFromPjt = "${isFromPjt}";
		if(isFromPjt == 'Y'){
			opener.doSearchCngtList();
		}else{
			opener.doSearchList();
		}
		self.close();
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
	
	// 전자결제 상신 페이지 호출
	function goAprvDetail() {
	
		
		var url = "${wfURL}.do";
		var data = "wfInstanceID=${getData.WFInstanceID}&actionType=view&changeSetID=${getData.ChangeSetID}&isMulti=N&wfDocType=CS&projectID=${ProjectID}&docSubClass=${getData.ItemClassCode}";
		var w = 900;
		var h = 700;
		
		window.open(url+"?"+data,'window','width='+w+', height='+h+', left=200, top=100,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
	}		

	// [Item] click
	function goItemPopUp(avg1) {
	
		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop&itemMainPage=/itm/itemInfo/itemMainMgt";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}

	function goEdit(){
		var url = "editItemCSInfo.do"
		var data = "changeSetID=${getData.ChangeSetID}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${seletedTreeId}"
			+ "&isItemInfo=${isItemInfo}"
			+ "&screenMode=edit&isMyTask=Y";
		var target = "changeInfoViewFrm";
		
		ajaxPage(url, data, target);
	}

	function goApprovalPop() {
		var url = "${wfURL}.do?";
		var data = "isPop=Y&changeSetID=${getData.ChangeSetID}&isMulti=N&wfDocType=CS&ProjectID=${getData.ProjectID}&docSubClass=${getData.ItemClassCode}&actionType="+actionType;
				
		var w = 1500;
		var h = 1050; 
		itmInfoPopup(url+data,w,h);
		closeMe();
	}
	
	function goWfStepInfo(wfDocType,wfUrl,wfInstanceID) {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = wfUrl;
		var data = "isNew=Y&wfDocType="+wfDocType+"&isMulti=N&isPop=Y&categoryCnt=1&changeSetID=${getData.ChangeSetID}&wfInstanceID="+wfInstanceID;
				
		ajaxPage(url,data,"changeInfoViewFrm");
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

		ajaxSubmitNoAdd(document.changeInfoViewFrm, url,"blankFrame");
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
		ajaxSubmitNoAdd(document.changeInfoViewFrm, url,"blankFrame");
	}
	
	function closeMe(){
		  try{
		    if (window.parent && typeof window.parent.closeDhxModal === "function") {
		      window.parent.closeDhxModal();
		      return;
		    }
		  }catch(e){}
		  try{ window.close(); }catch(e){ self.close(); }
		}
	

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
	    const fileItemsEl = document.getElementById("tmp_file_items");
	    const fileButtonsEl = document.getElementById("tmp_file_buttons");

	    if (!fileItemsEl || !fileButtonsEl) return;

	    fileItemsEl.innerHTML = "";
	    fileButtonsEl.innerHTML = "";

	    if (!Array.isArray(fileList) || fileList.length === 0) {
	        fileItemsEl.innerHTML = `<div id="emptyAttachPlaceholder" class="empty-placeholder">첨부된 파일이 없습니다.</div>`;
	        return;
	    }
	    let fileHtml = "";

	    fileList.forEach(function(file) {
	        var deleteBtnHtml = "";
		    fileHtml +=
	            '<div id="divDownFile' + file.Seq + '" class="mm" name="divDownFile' + file.Seq + '">' +
	                '<input type="checkbox" name="checkedFile" value="' + file.Seq + '" style="margin-right:8px;">' +
	                '<span style="cursor:pointer; color:#2563eb; flex:1;" onclick="fileNameClick(\'' + file.Seq + '\');">' +
	                    (file.FileRealName || '') +
	                '</span>' +
	                deleteBtnHtml +
	            '</div>';
	    });

	    fileItemsEl.innerHTML = fileHtml;

	    fileButtonsEl.innerHTML =
	        '<span class="btn_pack medium icon" style="margin-right: 8px;">' +
	            '<span class="download"></span>' +
	            '<input value="&nbsp;Download All&nbsp;&nbsp;" type="button" onclick="FileDownload(\'checkedFile\', \'Y\')">' +
	        '</span>' +
	        '<span class="btn_pack medium icon">' +
	            '<span class="download"></span>' +
	            '<input value="Download" type="button" onclick="FileDownload(\'checkedFile\', \'N\')">' +
	        '</span>';
	}
</script>

<form name="changeInfoViewFrm" id="changeInfoViewFrm" enctype="multipart/form-data" action="#" method="post" onsubmit="return false;">
<div id="changeInfoViewDiv" class="hidden" style="overflow:auto; overflow-x:hidden; padding: 6px 6px 6px 6px;" >
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
	<!-- 화면 타이틀 : view - 변경항목 상세 조회, edit - 변경항목 상세 내역 편집 -->
	<div class="cop_hdtitle">
		<h3 style="padding:0 6px">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
				${menu.LN00206}   
		</h3>
	</div>
	<div id="tblChangeSet">
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
 <tr>
  <th class="alignL pdL10">${menu.LN00290}</th>
  <td colspan="5" class="last alignL pdL5">

    <div class="subrow-changeset-container">

      <!-- 변경개요  -->
      <c:choose>
        <c:when test="${empty getData.Description}">
          <textarea id="description" name="description" readOnly
            class="changeset-description-textarea empty-placeholder">작성된 변경이력 내역이 없습니다.</textarea>
        </c:when>
        <c:otherwise>
          <textarea id="description" name="description" readOnly
            class="changeset-description-textarea">${getData.Description}</textarea>
        </c:otherwise>
      </c:choose>
    </div>
	  </td>
	</tr>
	<tr>
	
  <th class="alignL pdL10">${menu.LN00122}</th>
  <td colspan="5" class="last alignL pdL5">
	      <!-- 첨부파일  -->
	      <div class="changeset-files-outer-container">
	        <div class="changeset-files-inner-container">
	  <!-- 파일 목록 -->
	        <div style="flex:1; min-width:0; max-height:120px; overflow-y:auto;">
	          <div id="tmp_file_items"></div>
	        </div>
	
	        <!-- 버튼 -->
	        <div id="tmp_file_buttons"
	             style="margin-left:10px; flex:0 0 auto; text-align:right; display:flex; align-items:flex-end; gap:8px;">
	        </div>
	  
	        </div>
	      </div>
	
	
	  </td>
	</tr>
			 <tr>
	           <td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9" >
		           &nbsp;
		           <span class="btn_pack medium icon">
			           <span class="confirm"></span>
			           <input value="View current Item" onclick="goItemPopUpNoID()" type="submit">
		           </span>
	         	  	<c:if test="${lastChangeSet == 'N' }">
	           		&nbsp;
	           		<span class="btn_pack medium icon">
		           		<span class="confirm"></span>
		           		<input value="View version Item" onclick="fnOpenViewVersionItemInfo(${getData.ChangeSetID})" type="submit">
	           		</span>
		            </c:if>
         
			    </td>
      		</tr>
		</table>
		

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
	
	</div>
</div>
</form>

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
