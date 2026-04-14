<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	var screenType = "${screenType}";	
	//var tinyEditorType = "MAX";
</script><!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

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
	
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		
	 	
		 fnSelect('project', data, 'getESPCustomerList', '${resultMap.orgnztId}', 'Select', 'esm_SQL');
		
		
			
		
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
		var url  = "zDlm_knowledgeSaveBoard.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}

	// 필수값 처리 20250402
	function isNotEmptyById(labelId, showAlert) {
	    var element = document.getElementById(labelId); // ID로 요소 찾기

	    if (element) {
	        var value = element.value.trim(); // 입력값에서 앞뒤 공백 제거

	        if (value === "") { // 값이 비어 있으면
	            if (showAlert) {
	                var message = "";

	                // labelId에 따라 menu 값 설정
	                if (labelId === "knoNm") {
	                    message = `${menu.LN00002}은`; // 제목
	                } else if (labelId === "project") {
	                    message = `${menu.ZLN0018}는`; //관계사
	                } else if (labelId.includes("srArea")) {
	                    message = `${menu.ZLN0024}는`; //서비스 파트
	                } else {
	                    message = labelId; // 기본적으로 labelId를 그대로 출력
	                }

	                alert(message + " 필수입력 항목입니다."); // 최종 메시지 출력
	            }
	            return false; // 유효성 검사 실패
	        }
	        return true; // 유효성 검사 통과
	    }

	    return false; // 요소가 없으면 기본적으로 false 반환
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		if(isNotEmptyById("knoNm", true)==false){return false;}
		if(isNotEmptyById("project", true)==false){return false;}
		if(NEW === 'Y'){
			if(isNotEmptyById("srArea1", true)==false){return false;}
			if(isNotEmptyById("srArea2", true)==false){return false;}
		} else if (NEW === 'N'){
			if(isNotEmptyById("srAreaSearch", true)==false){return false;}
		}
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
					+"&projectID=${searchOrg}"
					+"&scEndDt=${scEndDt}"
					+"&projectCategory=${projectCategory}"
					+"&boardTypeCD=MN196";
					
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
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		
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
		var url  = "zDlm_kinfoMFileDownload.do?seq="+seq+"&scrnType=BRD";
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
		var url  = "zDlm_kinfoMFileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}
	
	
	
	/* 등록일시 서비스 파트 설정 */
	document.getElementById("srAreaBtn").addEventListener("click", function() {
		
			searchSrArea();
		
	});
	
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=${srType}&roleFilter=${roleFilter}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		$("#customerNo").val(clientID);
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
</script>
<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10">
	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="knoId" name="knoId" value="${resultMap.knoId}">
		<input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" value="${resultMap.ATCH_FILE_ID}">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${resultMap.BoardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${resultMap.BoardID}">
		<input type="hidden" id="screenType" name="screenType" value="${screenType}">
		<input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${defBoardMgtID}" >
		<input type="hidden" id="RegUserID" name="RegUserID" value="${resultMap.RegUserID}" >
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;">
			<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>
			<c:if test="${NEW == 'N'}">&nbsp;개인지식&nbsp;${menu.LN00103} </c:if> <!--개인지식 수정 -->
			<c:if test="${NEW == 'Y'}">&nbsp;개인지식&nbsp;${menu.LN00128} </c:if> <!--개인지식 등록  -->
			</h3>
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
				<th>${menu.LN00002}<font color="red">&nbsp;*</font></th>
				<td class="sline tit last" >
				
					<input type="text" class="text" id="knoNm" name="knoNm" value="${resultMap.knoNm}" size="60" />
		    						    							    						    					  				
				</td>
				<th>${menu.ZLN0018}<font color="red">&nbsp;*</font></th>
				<td class="sline tit last">
				 	<select id="project" name="project" class="sel" style="width:250px; margin-left:5px;"></select>	
				</td>	
			</tr>	
			<tr>
				<th>${menu.ZLN0024}<font color="red">&nbsp;*</font></th>
			    <td colspan="3" class="sline tit last" style="position:relative;">
			    	<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width: calc(25% - 24px);" value="${resultMap.srarea2Name}"  autocomplete="off"/>
				    <img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png"/>
			    	
					<input type="hidden" id="srArea1" name="srArea1" value="${resultMap.srArea1}"/>
					<input type="hidden" id="srArea2" name="srArea2" value="${resultMap.srArea2}"/>
					<ul class="autocomplete"></ul>
			    </td>	
			</tr>	
				
			<tr>
				<!-- 첨부문서 -->
				<th style="height:53px;">${menu.LN00111}</th>
				<td colspan="3" style="height:53px;" class="alignL pdL5 last">
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
							<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.atchFileId}','${fileList.fileSn}')">
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
				<th>${menu.ZLN0025}</th>
		  		<td colspan="4" style="height: 300px;" align="center" class="tit last">
		  			<div style="width:100%;height:300px">
						<textarea class="tinymceText" id="sympton" name="sympton" >${resultMap.symtonDesc}</textarea>
					</div>
				</td>	
			</tr>	
			<tr>
				<th>${menu.ZLN0026}</th>
		  		<td colspan="4" style="height: 300px;" align="center" class="tit last">
		  			<div style="width:100%;height:300px">
						<textarea class="tinymceText" id="rootCause" name="rootCause">${resultMap.rootCauseDesc}</textarea>
					</div>
				</td>	
			</tr>
			<tr>
				<th>${menu.ZLN0027}</th>
		  		<td colspan="4" style="height: 300px;" align="center" class="tit last">
		  			<div style="width:100%;height:300px">
						<textarea class="tinymceText" id="knwldgCn" name="knwldgCn" >${resultMap.knoCn}</textarea>
					</div>
				</td>	
			</tr>
			</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN">		
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
<script>

const srAreaSearch = document.querySelector("#srAreaSearch");
const autoComplete = document.querySelector(".autocomplete");


let nowIndex = 0;
let matchDataList, findIndex = [];
srAreaSearch.addEventListener("keyup", function(event) {
  // 검색어
	const value = srAreaSearch.value;

	switch (event.keyCode) {
	    // UP KEY
	    case 38:
	      	nowIndex = Math.max(nowIndex - 1, 0);
	      	break;

	    // DOWN KEY
	    case 40:
	    	nowIndex = Math.min(nowIndex + 1, matchDataList.length - 1);
	      	break;

	    // ENTER KEY
	    case 13:
	    	document.querySelector("#srAreaSearch").value = matchDataList[nowIndex].SRArea2Name || "";
			document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "";
			document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "";
			
			// customerNo 변경 감지 > category 재 셋팅
			let customerNo = document.querySelector("#customerNo").value;
			if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != matchDataList[nowIndex].ClientID){
				document.querySelector("#customerNo").value = matchDataList[nowIndex].ClientID || "";
				fnSelectSetting();
			}
			
			// 초기화
			nowIndex = 0;
			matchDataList.length = 0;
			break;
      
    	default:
    		// 자동완성 필터링
	    	matchDataList, findIndex = [];
			if(value) {
				//if(document.querySelector("#company").value == "") matchDataList = srAreaData.filter(e => e.SRArea2Name.includes(value));
				//else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea2Name.includes(value));
				 matchDataList = srAreaData.filter(e => e.SRArea2Name.match(new RegExp(value, "i")));
			} else {
				matchDataList = []
			}
			break;
	}
	
	// 리스트 보여주기
	showList(matchDataList, value, nowIndex);
});

const showList = (data, value, nowIndex) => {
	// 정규식으로 변환
	const regex = new RegExp(`(\\\(${value}\\))`, "g");
	data.length > 0 ? autoComplete.classList.add("on") : autoComplete.classList.remove("on");
	autoComplete.innerHTML = data.map((e, index) => `<div class='\${nowIndex === index ? "active" : ""}' data-index='\${e.RNUM}'><span>\${e.CompanyName}</span><span>\${e.SRArea1Name}</span><span>\${e.SRArea2Name.replace(regex, "<mark>$1</mark>")}</span></div>`).join("");
};

autoComplete.addEventListener("mouseover", function(e) {
	autoComplete.childNodes.forEach(child => child.classList.remove("active"))
});

// srArea 팝업 영역 외 클릭시 팝업 닫기
document.addEventListener("click", function(e) {
	if(autoComplete.contains(e.target)) {
		document.querySelector("#srAreaSearch").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea2Name;
		document.querySelector("#srArea1").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea1;
		document.querySelector("#srArea2").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea2;
		
		// customerNo 변경 감지 > category 재 셋팅
		let customerNo = document.querySelector("#customerNo").value;
		if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != srAreaData[e.target.parentNode.getAttribute("data-index") - 1].ClientID){
			document.querySelector("#customerNo").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].ClientID;
			fnSelectSetting();
		}
		
	}
    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
})
</script>