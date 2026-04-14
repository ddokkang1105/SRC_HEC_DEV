<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	
	var docCategory = "${docCategory}"; // "ITM";	
	if(docCategory == ""){docCategory = "ITM"; }
	var id = $('#DocumentID').val();

	var scrnType = "ITM_M";

	var mgtId = "";
	var boardId = "";
	
	var itemClassCode = "${itemClassCode}";
	
	var documentId = "${DocumentID}";
	
	var projectId = "";
	
	var changeSetId ="";

	var previousAddedFileNames = new Set;
	
	var USE_FILE_LOG = "${USE_FILE_LOG}";
	
	var sessionAuthLevel = "${sessionScope.loginInfo.sessionMlvl}";
	
	var myItemYN = "${myItem}";
	
	var refFileID = '';
	var fileID = '';
	
	var multiFileUploadEnabled = true;
	var fileListYN = '${fileListYN}';
	
	
	// 그리드에 표시되는 파일의 이름을 반환하는 함수
	// 새 파일 첨부 시도 시 프론트 딴 중복검사 위한 데이터를 구성해 previousAddedFileNames에 할당하는 용도로 사용됨
	function getGridFileNames() {
	    const allData = grid.data.serialize();
	    const fileNames = new Set(allData.map(item => item.FileRealName));
	    return fileNames;
	}

</script>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Mod "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021D" arguments="Delete "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021B" arguments="Block "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068"/>

<style>
.context-menu-wrapper {
    position: relative;
}
.context-menu {
    position: absolute;
    z-index: 999;
    top:27px;
    left: 4px;
    background: #fff;
    border: 1px solid rgba(0, 0, 0, .1);
    box-shadow: 0 4px 10px 0 rgba(63, 64, 70, .1), 0 1px 1px 0 rgba(63, 64, 70, .05);
/*     max-width: 240px; */
    margin-top: 8px;
    border-radius: 6px;
    display:none;
}
.context-menu.open {
	display: block;
}
.context-menu .title {
    display: flex;
    align-items: center;
	border-bottom: 1px solid rgba(0, 0, 0, .1	);
    box-shadow: none;
    height: 25px;
    padding: 5px 30px 6px 16px;
    font-weight: 500;
}
.context-menu .title:empty {
    display: none;
}
.context-menu .menu {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    max-width: 100%;
    word-wrap: normal;
    display: block;
    /* font-size: 13px; */
    line-height: 21px;
    color: #202124;
    padding: 5px 15px;
    text-align: left;
    position: relative;
    cursor:pointer;
}
.context-menu .menu:hover {
    background-color: #F1F3F9;
}
.context-menu .menu.selected {
	color:#0761CF;
}
.context-menu .menu .primary {
    width: 100%;
	height: 30px;
}
.right-panel-area {
	
}
.info-list {
    display: flex;
    flex-wrap: wrap;
    font-size: 13px;
    line-height: 19px;
}
.info-list dt{
	flex: none;
    width: 104px;
    padding: 7px 16px 6px 0;
    box-sizing: border-box;
    font-weight: 500;
}
.info-list dd{
    word-wrap: normal;
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: calc(100% - 104px);
    padding: 7px 0 6px;
}

#button-container {
    display: flex;
    gap: 10px;
    align-items: start; !important
}

#downTempFile {
	height: 32px; !important
}

/* file 확장자별 아이콘 css */
.file-icon {
    font-size: 22px;
    cursor: pointer;
    vertical-align: middle;
    transition: color 0.15s ease, transform 0.15s ease;
}

/* hover 공통 효과 */
.file-icon:hover {
    transform: scale(1.1);
}

/* ===============================
   파일 타입별 색상 정의  (mdi 클래스 기준 : materialdesignicons.min.css)
   =============================== */

/* PDF */
.mdi-file-pdf-box.file-icon {
    color: #E53935; /* red */
}
.mdi-file-pdf-box.file-icon:hover {
    color: #B71C1C;
}

/* EXCEL */
.mdi-file-excel-box.file-icon {
    color: #2E7D32; /* green */
}
.mdi-file-excel-box.file-icon:hover {
    color: #1B5E20;
}

/* WORD */
.mdi-file-word-box.file-icon {
    color: #1E88E5; /* blue */
}
.mdi-file-word-box.file-icon:hover {
    color: #0D47A1;
}

/* ===============================
   기타 / 알 수 없는 파일
   =============================== */
.mdi-file.file-icon {
    color: #757575; /* gray */
}
.mdi-file.file-icon:hover {
    color: #424242;
}

</style>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var fileOption = "${fileOption}";
	var schCntnLayout;	//layout적용
	var now;
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var itemFileOption = "${itemFileOption}";
	
	$(document).ready(function(){
		
		$("#excel").click(function(){ 
			Promise.all([
				getDicData("ERRTP", "LN0015"), 
				getDicData("BTN", "LN0032"), // 확인
				getDicData("BTN", "LN0033")  // 취소
			]).then(results => {
				showDhxConfirm(results[0].LABEL_NM, () => fnGridExcelDownLoad(), null, results[1].LABEL_NM, results[2].LABEL_NM);
			});
		} );
		
		// list 호출
		fnFileReload();
		
		// Download Template File 버튼 show/hide 여부 체크 -> fltp 타입별로 템플릿 문서가 존재할 경우 해당 문서를 다운받을 수 있는 버튼이 생성된다. 
		fnSetDownTempFileButton();
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	function doSearchList(){
		fnFileReload();
	}
	
	function fnFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			
			Promise.all([
				getDicData("ERRTP", "LN0018"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});

		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
			
			var frmType = "${frmType}";
			var url  = "fileDownload.do?seq="+seq+"&alertType=DHX";
			if(frmType =="documentDetailFrm"){ 
				ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
			}else{
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
			}
		}
	}	
	
	function fnFileUpload(){		
	    var fileCount = document.getElementById("files_upload").files.length;
	    var fileSize = new Array();
	    var fileName = new Array();	
	 	for(var i=0; i<fileCount; i++){
	 		fileSize[i] = document.getElementById("files_upload").files[i].size;
	 		fileName[i] = document.getElementById("files_upload").files[i].name;
	 	}		  
		var files =  $("#files-upload").val();
		var url  = "fileUpload.do?files="+files+"&fileSize="+fileSize+"&fileName="+fileName;
		ajaxSubmit(document.fileMgtFrm, url);
	}	
	
	function fnMultiUpload(){ 
			var browserType="";
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="addFilePop.do";
			var data="scrnType=ITM_M&delTmpFlg=Y&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id="+$('#DocumentID').val();
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
			else{openPopup(url+"?"+data,490,410, "Attach File");}
	}
	
	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=ITM_M&docCategory=ITM&id="+$('#DocumentID').val();
		openPopup(url+"?"+data,480,510, "Attach File");
	}
	
	//*************** Vault Modal  **************************//
	
	function openDhxVaultModal(multiFileEnabledParam){
		
		if (multiFileEnabledParam === false) {
			multiFileUploadEnabled = false;
		} else {
			multiFileUploadEnabled = true;
		}
	
		const selectableNodes = document.querySelectorAll(".context-menu .selectable");
	    const selectedFltpCode = Array.from(selectableNodes).find(e => e.classList.contains('selected'))?.getAttribute("data-value");
	    
	    if (!selectedFltpCode) {  		
			Promise.all([
				getDicData("ERRTP", "LN0016"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
	    } else {
	    	// dhtmlx 윈도우로 vault 띄우기
// 			newFileWindow.show();
	    	document.querySelector(".context-menu").classList.remove("open");
	    	// fltp 코드
	    	showFileWindow(selectedFltpCode);
	    }
	}	

	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${DocumentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}";  
		
		ajaxPage(url, data, target);
	}
	
	// 첨부파일 삭제
	function fnDeleteFile(){

		if(selectedItemBlocked == "0"){
			var sysFileName = new Array();
			var filePath = new Array();
			var seq = new Array();
			
			var selectedCell = grid.data.findAll(function (data) {
		        return data.checkbox;
		    });
			
			if(!selectedCell.length){
		  		
		  		Promise.all([
					getDicData("ERRTP", "LN0017"), 
					getDicData("BTN", "LN0034"), // 닫기
				]).then(results => {
					showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
				});
		  		
		  		
			} else {			
				var chkBlock = "";
				var documentID = "";
				var itemID = documentId;
				for(idx in selectedCell){					
					chkBlock = selectedCell[idx].Blocked;
					documentID = selectedCell[idx].DocumentID;
					itemID = documentId;
					
					if(chkBlock != "Y" && documentID == itemID){				
						sysFileName[idx] =  selectedCell[idx].SysFile;
						filePath[idx] = selectedCell[idx].FilePath;
						seq[idx] = selectedCell[idx].Seq;
					}
					else if(documentID != itemID) {
						var fileName = selectedCell[idx].FileRealName;						

						Promise.all([
								getDicData("ERRTP", "LN0019"), 
								getDicData("BTN", "LN0034"), // 닫기
							]).then(results => {
								showDhxAlert(fileName + results[0].LABEL_NM, results[1].LABEL_NM);
						});
						return;
					}else {
						var fileName = selectedCell[idx].FileRealName;	
						
						Promise.all([
							getDicData("ERRTP", "LN0020"), 
							getDicData("BTN", "LN0034"), // 닫기
						]).then(results => {
							showDhxAlert(fileName + results[0].LABEL_NM, results[1].LABEL_NM);
						});
						return;
					}	
				}
			
				function afterConfirmDeletion () {
					var url = "deleteFileFromLst.do";
					var data = "&alertType=DHX&itemId=${s_itemID}&sysFile="+sysFileName+"&filePath="+encodeURIComponent(filePath)+"&seq="+seq;
					var target = "subFrame";
					ajaxPage(url, data, target);
				}
				
				Promise.all([
					getDicData("ERRTP", "LN0021"),
					getDicData("BTN", "LN0032"), // 확인
					getDicData("BTN", "LN0033")  // 취소
				]).then(results => {
					showDhxConfirm(results[0].LABEL_NM, afterConfirmDeletion, null, results[1].LABEL_NM, results[2].LABEL_NM);	
				});
				
						
			}
			
		}else{
			if(selectedItemStatus == "REL"){
				Promise.all([
					getDicData("ERRTP", "LN0022"), 
					getDicData("BTN", "LN0034"), // 닫기
				]).then(results => {
					showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
				});
		     } else {
		    	 Promise.all([
						getDicData("ERRTP", "LN0023"), 
						getDicData("BTN", "LN0034"), // 닫기
					]).then(results => {
						showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
					});
		     }
		}	
	}

	
	// (사용이 주석처리되어있는 함수)
	function fnExtFileUpdateCount(seq){
		var url = "extFileUpdateCount.do";
		var data = "&fileSeq="+seq+"&scrnType=ITEM";
		var target = "subFrame";
		ajaxPage(url, data, target);	
	}
	
	// fileOption이 ExtLink일 때 활성화되는 파일 추가 방식
	function fnAddExtFile() {
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="modExtFilePop.do";
		var data="isNew=Y&browserType="+browserType+"&itemClassCode=${itemClassCode}&DocumentID="+documentId;
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
		else{openPopup(url+"?"+data,1000,410, "Modify File");}
	}
	
	// fileOption이 ExtLink일 때 활성화되는 기존 첨부파일 편집 방식
	function fdModExtFile() {
		if(selectedItemBlocked == "0"){
			var seq = new Array();
			
			var selectedCell = grid.data.findAll(function (data) {
		        return data.checkbox;
		    });
			
			for(idx in selectedCell){		
				seq[idx] = selectedCell[idx].Seq;				
			}
			if(selectedCell.length < 1) {
				
		  		Promise.all([
					getDicData("ERRTP", "LN0018"), 
					getDicData("BTN", "LN0034"), // 닫기
				]).then(results => {
					showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
				});
				
				return;
			}
			else if(selectedCell.length > 10) {
				Promise.all([
					getDicData("ERRTP", "LN0024"), 
					getDicData("BTN", "LN0034"), // 닫기
				]).then(results => {
					showDhxAlert(results[0].LABEL_NM + "10", results[1].LABEL_NM);
				});
				return;
			}
		
			var browserType="";
			//if($.browser.msie){browserType="IE";}
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="modExtFilePop.do";
			var data="seqList="+seq+"&browserType="+browserType;
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
			else{openPopup(url+"?"+data,1000,410, "Modify File");}
		
		}
	}
	
	// 담당자 변경
	function fnChangeRegMember(){		
		var fileSeqs = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
	  		Promise.all([
				getDicData("ERRTP", "LN0018"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
	  		
		} else {
			for(idx in selectedCell){
				fileSeqs[idx] = selectedCell[idx].Seq;
			};
		}
		
		$("#fileSeqs").val(fileSeqs);
		if(fileSeqs != ""){
			var url = "searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL"
						+ "&languageID="+languageID;
			window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
	}
	
	function setSearchNameWf(avg1, avg2, avg3, avg4){
		
		Promise.all([
			getDicData("ERRTP", "LN0025"),
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmCallback, null, results[1].LABEL_NM, results[2].LABEL_NM);	
		});	
		
		function afterConfirmCallback(){
			var url = "updateFileRegMember.do";
			var target = "subFrame";
			var data = "fileSeqs="+$("#fileSeqs").val()+"&memberID="+avg1+"&alertType=DHX"; 
		 	ajaxPage(url, data, target);
		}
	}


	// 파일 block
	function fnBlock(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
	  		Promise.all([
				getDicData("ERRTP", "LN0018"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			return;
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		
		function afterConfirmBlock () {
			var url  = "updateFileBlocked.do";
			var data = "alertType=DHX&seq="+seq;
			ajaxPage(url,data,"subFrame");
		}
		
		Promise.all([
			getDicData("ERRTP", "LN0025"),
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmBlock, null, results[1].LABEL_NM, results[2].LABEL_NM);	
		});	
		
	}
	
	// 파일 이름 변경
	function editFileName(){		
	    var url = "editFileNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("editFileNamePop.do?DocumentID="+$("#DocumentID").val()+"&docCategory="+docCategory, "SelectOwner", option);	 
   }
	
	// fileOption이 ExtLink일 때 활성화되는 기존 첨부파일 다운로드
	function fnExtFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			
	  		Promise.all([
				getDicData("ERRTP", "LN0018"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
	  		
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		var frmType = "${frmType}";
		var url  = "downloadExtLinkFile.do?seq="+seq;
		if(frmType =="documentDetailFrm"){ 
			ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
		}else{
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		}
	}
	
	function fnDownloadTempFile(){
		var docCategory = "ITM"; 
		var url = "selectFilePop.do";
		var data = "?s_itemID=&docCategory="+docCategory+"&templateFile=Y"+"&itemClassCode="+itemClassCode; 
	   
	    var w = "500";
		var h = "350";
		
		openUrlWithDhxModal(url+data, null, "", w, h);

	}
	
</script>
</head>
<body>
<form name="fileMgtFrm" id="fileMgtFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />
	<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}" />
	<input type="hidden" id="fileSeqs" name="fileSeqs" >
	
	<div class="pdT10">
		<c:if test="${backBtnYN != 'N'}" >
			<div>
				<span class="flex align-center">
					<span class="back" onclick="goNewItemInfo()"><span class="icon arrow"></span></span>
					<b>${menu.LN00019}</b>
				</span>
			</div>
		</c:if>
		<div class="btn-wrap flex justify-between countList">
          <div class="count">Total  <span id="TOT_CNT"></span></div>
          <div class="btns" id="button-container">
	 		<c:if test="${fileOption == 'OLM' or (myItem == 'Y' &&  fileOption != 'ExtLink') }">
				<span class="btn_pack nobg white"><a class="download" onclick="fnFileDownload()" title="Download"></a></span>
<!-- 				<button class="secondary" onclick="fnFileDownload()">다운로드</button> -->
			</c:if>
			<c:if test="${myItem == 'Y' && itemBlocked ne '2'}">			
				<c:if test="${fileOption != 'ExtLink' and uploadYN != null and uploadYN ne ''}">
<!-- 					<span class="btn_pack nobg"><a class="upload" onclick="openDhxVaultModal()" title="Upload"></a></span> -->
					<div class="context-menu-wrapper">
						<span class="btn_pack nobg context-menu-opener"><a class="upload" onclick="uploadFile()" title="Upload"></a></span>
<!-- 						<button class="secondary context-menu-opener" onclick="uploadFile()">업로드</button> -->
						<ul class="context-menu">
							<li class="title"></li><%-- <li class="title">${menu.LN00091}</li> --%>
<!-- 							<li class="menu"><button class="primary mgB5 mgT4" onclick="openDhxVaultModal()">Add File</button></li> -->
						</ul>
						
					</div>
				</c:if>
			<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
	 			<span class="btn_pack nobg"><a class="gov" onclick="fnChangeRegMember();" title="Ownership"></a></span>	 			
<!-- 				<button class="secondary" onclick="fnChangeRegMember()">담당자 변경</button> -->
	 		</c:if>
			<c:if test="${fileOption == 'ExtLink'}">				
				<span class="btn_pack nobg"><a class="download" onclick="fnExtFileDownload()" title="Download"></a></span>
				<span class="btn_pack nobg"><a class="add" onclick="fnAddExtFile()" title="Add"></a></span>					
				<span class="btn_pack nobg"><a class="edit" onclick="fdModExtFile()" title="Edit"></a></span>
				
<!-- 				<button class="secondary" onclick="fnExtFileDownload()">다운로드</button> -->
<!-- 				<button class="secondary" onclick="fnAddExtFile()">추가</button> -->
<!-- 				<button class="secondary" onclick="fdModExtFile()">변경</button> -->
			</c:if>	
				<span class="btn_pack nobg"><a class="list" onclick="editFileName();" title="Rename"></a></span>
				<span class="btn_pack nobg"><a class="block" onclick="fnBlock()" title="Block"></a></span>				
				<span class="btn_pack nobg white"><a class="del" onclick="fnDeleteFile()" title="Delete"></a></span>
				
<!-- 				<button class="secondary" onclick="editFileName()">이름 바꾸기</button> -->
<!-- 				<button class="secondary" onclick="fnBlock()">Block</button> -->
<!-- 				<button class="secondary" onclick="fnDeleteFile()">삭제</button> -->
			</c:if>					   
	 		<span class="btn_pack nobg white"><a class="xls"  id="excel" title="Excel"></a></span>
<!-- 	 		<button class="secondary" id="excel">내려받기</button> -->
	   		<c:if test="${backBtnYN != 'N'}" >
			</c:if>
           </div>
         </div>
     </div>
	 <div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="width:0px;height:0px;display:none" frameborder="0"></iframe>
</body>

<script>
	const contextMenuOpener = document.querySelector(".context-menu-opener");

	displayFLTP();

	var layout = new dhx.Layout("layout", {
	    cols: [
	        {
	        	id: "a"
	        },
	        {
	            html: "This cell was hidden",
	            id: "show",
	            hidden: true,
	            width : "350px",
	            css : "right-panel-area"
	        },
	    ]
	});
	
	var pagination;
	
	var grid = "";	
	function selectFileTab(mode, e){
		document.querySelectorAll(".tabbar ul li a").forEach(e => e.classList.remove("tab--active"));
		e.classList.add("tab--active");
		
		const detailList = document.getElementById('detail-list');
		const logList = document.getElementById('log-list');
		
		if(mode == 'detail') {
			detailList.style.display = 'inline-flex';
			logList.style.display = 'none';
		} else {
			logList.style.display = 'inline-flex';
			detailList.style.display = 'none';
		}
		
	}
	 	  	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 		previousAddedFileNames = getGridFileNames();
 		if(grid.data.getInitialData().length < 50) pagination.destructor();
 	}
	
 	const changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);

	// file list reload
	async function fnFileReload(){
		let requestData = { 
			DocumentID : documentId, 
			s_itemID : documentId, 
			hideBlocked : 'N',
			fileListYN,
			isPublic : 'N',
			DocCategory : docCategory,
			languageID
		};
				
		// getRltdItemId
		const rltdItemId = await getRltdItemId();
		if(rltdItemId && rltdItemId !== ''){
			requestData = {
					...requestData,
					rltdItemId
			}
	    }
	
		try {
	        
			const params = new URLSearchParams(requestData).toString();
		    const url = "getItemFileListInfo.do?" + params;
		    const response = await fetch(url, { method: 'GET' });
	        
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
			}
	      
			const result = await response.json();
		    
		    // 서버가 반환하는 성공여부 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
			
		    console.log("result.data :"+result.data);
			if(result && result.data.length > 0) {
	        	$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px;");
	        	
	        	if(grid == "") {	        	
					grid = new dhx.Grid("grid", {
					    columns: [
					        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
					        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], editorType: "checkbox", align: "center", type: "boolean",  editable: true, sortable: false}, 
					        { width: 40, id: "File", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
					        	template: function (text, row, col) {
					        		//return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';					        		
					        		let iconClass = "mdi-file";
					        		const fmt = (row.FileFormat || "").toLowerCase().trim(); 
					        		if (fmt === "pdf") {
					        	        iconClass = "mdi-file-pdf-box";
					        	    } else if (fmt === "xlsx" || fmt === "xls") {
					        	        iconClass = "mdi-file-excel-box";
					        	    } else if (fmt === "docx" || fmt === "doc") {
					        	        iconClass = "mdi-file-word-box";
					        	    }
					        	    return '<span class="mdi  ' + iconClass + ' file-icon"></span>';
					            }
					        },	   
					        { id: "FileRealName", header: [{text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" },	  					       
					        { width: 100, id: "CSVersion", header: [{ text: "Version", align:"center" },{content: "selectFilter"}], align: "center"},
					        { width: 140, id: "FltpName", header: [{ text: "${menu.LN00091}", align:"center" },{ content: "selectFilter"} ], align: "center"},
					        { width: 90, id: "LanguageCode",   header: [{ text: "${menu.LN00147}", align:"center"},{ content : "selectFilter" }], align:"center" },	        
					        { width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
					        { width: 150, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center" },
					        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center" },
					        { width: 80, id: "DownCNT", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center" },
					        { width: 80, id: "FileStatus", header: [{text: "${menu.LN00027}", align:"center" },{content : "selectFilter"}], align:"center"},
					        { width: 80, id: "Seq", header: [{ text: "Seq", align:"center" }], align:"center" , hidden:true},
					        { width: 80, id: "RefFileID", header: [{text: "ROOT", align:"center"},{content : "selectFilter"}], align:"center", hidden:true},
					        
					        { id: "Blocked", header: [{text: "Blocked"}], align:"center" ,hidden:true },	 	        
					        { id: "SysFile", header: [{text: "SysFile"}], hidden:true},
					        { id: "FileName", header: [{text: "FileName"}], hidden:true},
					        { id: "FltpCode", header: [{text: "FltpCode"}], hidden:true},
					        { id: "FilePath", header: [{text: "FilePath"}], hidden:true},
					        { id: "DcumentID", header: [{text: "DocumentID"}], hidden:true},
					        { id: "ExtFileURL", header: [{text: "ExtFileURL"}], hidden:true}
					          
					    ],
					    autoWidth: true,
					    resizable: true,
					    selection: "row",
					    tooltip: false,
					    height: "auto",
					});
					
					grid.events.on("cellClick", function(row,column,e){
						
						// 체크박스 클릭 시 체크박스 토글 외 동작 X
						if (column.id == "checkbox") {
							return;
						}
						
						// 다운로드 아이콘 클릭 시 다운로드 실행
						if(column.id == "File"){
							var url  = "fileDownload.do?seq="+row.Seq+"&alertType=DHX";
							var frmType = "${frmType}";
					
							if(frmType =="documentDetailFrm"){ 
								ajaxSubmitNoAdd(document.documentDetailFrm, url,"subFrame");
							}else{
								ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
							}
						}
						
						var extFileURL = row.ExtFileURL;	
	
						// 파일 옵션이 ExtLink인 경우에 대한 처리 (현재는 테스트 중인 DB에선 OLM으로 되어있음)
						if(fileOption=="ExtLink"){
							var url  = row.ExtFileURL;						
							var w = 1200;
							var h = 900;
							url = url.replace(/&amp;/gi,"&");
							
							itmInfoPopup(url,w,h); 
							fnExtFileUpdateCount(row.Seq);
						} else {
							if(sessionAuthLevel != "SYS" && myItemYN != 'Y' && itemFileOption == "VIEWER"){
								showFileDetailPanel();
								
								// 아래는 기존 처리 코드임.
								// ★★★ 팝업 열던 itmInfoPopup가 우측 패널이 열리는 showFileDetailPanel로 대체되었으나, 그 외 내용에 대해선 별도 처리 필요할 수 있음
								
	//			 				var url = "openViewerPop.do?seq="+row.Seq;
	//			 				var w = 1200;
	//			 				var h = 900;
	//			 				if(extFileURL != "") { 
	//			 					w = screen.availWidth-38;
	//			 					h = screen.avilHeight;
	//			 					url = url + "&isNew=N";	
	//			 				} else { url = url + "&isNew=Y"; }			
	//			 				itmInfoPopup(url,w,h); 			
							} else{
								showFileDetailPanel();
								
								// 아래는 기존 처리 코드임.
								// ★★★ 팝업 열던 itmInfoPopup가 우측 패널이 열리는 showFileDetailPanel로 대체되었으나, 그 외 내용에 대해선 별도 처리 필요할 수 있음
								
	//			 				var isNew = "N";								
	//			 				var url  = "fileDetail.do?&isNew="+isNew
	//			 						+"&seq="+row.Seq
	//			 						+"&DocumentID="+row.DocumentID
	//			 						+"&itemClassCode=${itemClassCode}"
	//			 						+"&selectedItemBlocked="+selectedItemBlocked
	//			 						+"&selectedItemAuthorID="+selectedItemAuthorID
	//			 						+"&selectedItemLockOwner="+selectedItemLockOwner;
	//			 				var w = 1200;
	//			 				var h = 500;
	//			 				itmInfoPopup(url,w,h); 					
							}
						}
						
						
						// 우측 파일 상세정보 패널 여는 함수
						async function showFileDetailPanel() {
							let html = '';
							html += '<div class="tabbar pdB20 pdL20 pdR20 border-section mgL20 h-100">'
							html += '<div class="align-center flex">'
							html += '<ul class="pdL0">';
							html += '<li class="flex align-center"><a class="tab--active flex align-center" onclick="selectFileTab(\'detail\', this)">상세 정보</a></li>';
							if(USE_FILE_LOG == "Y") html += '<li class="flex align-center"><a onClick="selectFileTab(\'log\', this)" class="flex align-center">활동</a></li>';
							html += '</ul>';
							html += '<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" onclick="hideFileDetailPanel()" class="cur-po"><path d="m291-240-51-51 189-189-189-189 51-51 189 189 189-189 51 51-189 189 189 189-51 51-189-189-189 189Z"/></svg>'
							html += '</div>'
							
							// api 호출
							const requestData = { seq : row.Seq , languageID };
							const params = new URLSearchParams(requestData).toString();
							const detailUrl = "getItemFileInfo.do?" + params;
							const logUrl = "getFileLog.do?" + params;
							let finalHtml = html;
							
							try {
						        const [detailRes, logRes] = await Promise.all([
						            fetch(detailUrl).then(r => r.json()),
						            USE_FILE_LOG == "Y" ? fetch(logUrl).then(r => r.json()) : Promise.resolve({data: []})
						        ]);
								
						        // 1. file detail
								finalHtml += '<div style="height: calc(100% - 61px);display: flex;flex-direction: column;justify-content: space-between;" id="detail-list" class="mgT10">';
								finalHtml += '<dl class="info-list">';
								finalHtml += '<dt>${menu.LN00101}</dt>';
								finalHtml += '<dd>'+detailRes.data.FileRealName+'</dd>';
								if(docCategory == "ITM"){
									finalHtml += '<dt>${menu.LN00043}</dt>';
									finalHtml += '<dd style="color:#0054FF;text-decoration:underline;cursor:pointer;" onClick="fnOpenItemDetail(' +detailRes.data.DocumentID +')">'+detailRes.data.Path+'</dd>';
								}
								finalHtml += '<dt>${menu.LN00091}</dt>';
								finalHtml += '<dd>'+detailRes.data.FltpName+'</dd>';
								finalHtml += '<dt>${menu.LN00131}</dt>';
								if(docCategory == "ITM"){
									finalHtml += '<dd>'+detailRes.data.ProjectName +'/'+ detailRes.data.CsrName+'</dd>';
								}
								finalHtml += '<dt>${menu.LN00060}</dt>';
								finalHtml += '<dd>'+detailRes.data.WriterName+'('+detailRes.data.TeamName+')'+'</dd>';
								finalHtml += '<dt>${menu.LN00017}</dt>';
								finalHtml += '<dd>'+detailRes.data.CSVersion+'</dd>';
								finalHtml += '<dt>${menu.LN00078}</dt>';
								finalHtml += '<dd>'+detailRes.data.CreationTime+'</dd>';
								finalHtml += '<dt>${menu.LN00070}</dt>';
								finalHtml += '<dd>'+detailRes.data.LastUpdated+'</dd>';		
								
								finalHtml += '<dt>${menu.LN00035}</dt>';
								if(selectedItemBlocked == '0' && detailRes.data.Blocked !== '2' && (selectedItemAuthorID == sessionUserId || sessionAuthLev == '1'))
									finalHtml += '<dd><textarea class="edit" id="Description" name="Description" style="width: 100%; height: 160px;" >' + (detailRes.data?.Description ?? '') + '</textarea></dd>';
								else
									finalHtml += '<dd>' + (detailRes.data?.Description ?? '') + '</dd>';								
								finalHtml += '</dl>';
								
								if(selectedItemBlocked == '0' && detailRes.data.Blocked !== '2' && (selectedItemAuthorID == sessionUserId || sessionAuthLev == '1')){
									finalHtml += '<div class="btn-wrap">';
									finalHtml += '<div class="btns">';
									
									if(detailRes.data.RevisionYN == 'Y') finalHtml += "<button class='secondary' onclick=\"saveNewFile('" + detailRes.data.RefFileID + "', '" + detailRes.data.FltpCode + "')\">Update</button>";
									else finalHtml += "<button class='secondary' onclick=\"modifyFile('"+ detailRes.data.Seq + "', '" +  detailRes.data.FltpCode + "')\">Update</button>";
									
									finalHtml += "<button class='secondary' onclick=\"saveFileDescription('" + detailRes.data.Seq + "', '" + detailRes.data.FltpCode + "')\">Save</button>";
									finalHtml += '</div>';
									finalHtml += '</div>';
								}
								
								finalHtml += '</div>';
								
						        // 2. log detail
						        if(USE_FILE_LOG == "Y") {
						            finalHtml += '<div id="log-list" style="display:none;" class="info-list">';
						            logRes.data.forEach(logItem => {
						            	finalHtml += '<div class="mem_list flex align-center mgT10">'
						  	    		finalHtml += '<div class="thumb mgR10" style="width: 30px;height: 30px;">'
						  	    		finalHtml += '<div class="initial_profile" style="background-color: rgb(134, 164, 212);">'
						  	    		finalHtml += '<em style="font-size: 15px;">'+logItem.Name.substring(0,1)+'</em>'
						  	    		finalHtml += '</div>'
						  	    		finalHtml += '</div>'
						  	    		finalHtml += '<div class="address_item_info">'
						  	    		finalHtml += '<p class="company_info">'+logItem.Time+'</p>'
						  	    		finalHtml += '<div class="name_info">'
						  	    		finalHtml += '<div class="name_txt">'
						  	    		finalHtml += '<font class="name">'+logItem.Name+'</font>'+'('+logItem.TeamName+')'+'님이 '+logItem.FileOption+'했습니다.'
						  	    		finalHtml += '</div>'
						  	    		finalHtml += '</div>'
						  	    		finalHtml += '</div>'
						  	    		finalHtml += '</div>'
						            });
						            finalHtml += '</div>';
						        }
								
						        // final
						        finalHtml += '</div>';

						        layout.getCell("show").attachHTML(finalHtml);
						        layout.getCell("show").show();

						    } catch (error) {
						        finalHtml += '</div>';
						        layout.getCell("show").attachHTML(finalHtml);
						        layout.getCell("show").show();
						    }
						}
					});
					
					 grid.events.on("filterChange", function(row,column,e,item){
						$("#TOT_CNT").html(grid.data.getLength());
					 });
					 
					 layout.getCell("a").attach(grid);
					 
					 if(pagination){pagination.destructor();}
					 pagination = new dhx.Pagination("pagination", {
					    data: grid.data,
					    pageSize: 50,
					});
	        	}
				
				fnReloadGrid(result.data);
				
// 				if(contextMenuOpener){
// 					contextMenuOpener.addEventListener("click", (e) => {
// 						document.querySelector(".context-menu").classList.toggle("open");
// 				    })
// 				}
				
				if(document.querySelector(".empty-wrapper")) document.querySelector(".empty-wrapper").remove();
			} else {
				if(grid) grid.destructor();
				
				const emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" height="48px" viewBox="0 -960 960 960" width="48px" fill="#CCCCCC"><path d="M220-80q-24 0-42-18t-18-42v-680q0-24 18-42t42-18h361l219 219v521q0 24-18 42t-42 18H220Zm331-554v-186H220v680h520v-494H551ZM220-820v186-186 680-680Z"/></svg>'
				let buttonFunc = "";
				let buttonTitle = "";
				let buttonStyle = "";
				
				if("${myItem}" === "Y") {
					buttonFunc = "uploadFile()";
					buttonTitle = "Add File";
					buttonStyle = "context-menu-opener primary";
				}
				
				document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, "파일이 없습니다.", "파일을 등록해주세요.", buttonFunc, buttonTitle, buttonStyle));
			}
	        
		 } catch (error) {    	
			 console.log("fnFileReload error :"+error);
		    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
		 }
	}
	
	function handleAjaxError(err, errDicTypeCode) {
		console.error("handleAjaxError err :"+err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
	
	
	function hideFileDetailPanel() {
		layout.getCell("show").hide();
	}
	
	// 연관항목 id 가져오기
	async function getRltdItemId(){
	    const requestData = {
	        languageID: languageID,
	        DocumentID: documentId
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
	        return "";
	    }
	}
	
	// "템플릿 파일" 기능 코드
	async function fnSetDownTempFileButton(){
	    const requestData = {
	        itemClassCode: itemClassCode,
	        docCategory: docCategory,
	    };
	    
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getFileTmpCount.do?" + params;
	    
	    try {
	        const response = await fetch(url, {
	            method: 'GET',
	        });
	        
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
			}
	        
	        const result = await response.json();
	        const dataCount = Number(result.data);
        
	        if (isNaN(dataCount)) {
	        	console.warn(`Type of data count within template file generation logic was not number: ${dataCount}`);
	        }
	        
	        if(dataCount > 0){
	            // data 값이 0이 넘으면 템플릿 파일 다운로드받을 수 있도록 버튼 렌더링
	            const button = document.createElement('button');
	            button.className = 'cmm-btn';
	            button.id = 'downTempFile';
	            button.style.marginLeft = '5px';
	            button.textContent = 'Download Template File';
	            button.onclick = fnDownloadTempFile;

	            document.getElementById('button-container').prepend(button);
	        }
	        
	    } catch (error) {
	    	handleAjaxError(error, "LN0014");
	    }
	}
	
	// 업로드 버튼 클릭 시 표시되는 문서유형 드롭다운 목록 렌더링 및 onclick 함수 지정
	function displayFLTP() {
		const fltpList = fnSelectJson("&itemClassCode="+itemClassCode+"&docCategory="+docCategory, "fltpCode");
		
		let html = "";
		if(fltpList.length > 0) {
			fltpList.forEach(e => {
				html += '<li class="menu selectable" data-value="'+e.value+'">'+e.content+'</li>';
				return html;
			});
			// 오류 코드
			if(contextMenuOpener) document.querySelector(".context-menu .title").insertAdjacentHTML("afterend", html);
		}
		
		// 문서유형 선택 로직
		const selectableNodes = document.querySelectorAll(".context-menu .selectable");

		selectableNodes.forEach(clickedNode => {
		    clickedNode.addEventListener('click', function() {
		        selectableNodes.forEach(node => {
		            node.classList.remove('selected');
		        });
		        
		        this.classList.add('selected');
		        openDhxVaultModal();
		    });
		});
	}
	
	function uploadFile() {
		document.querySelector(".context-menu").classList.toggle("open");
	}
	
	
	// file detail 관련 function
	
	function fnOpenItemDetail(DocumentID){ 
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=" + DocumentID + "&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,DocumentID);
	}
	
async function saveFileDescription(seq, fltpCode) {
	    
		if(confirm("${CM00001}")){	
			const url = 'saveFileDesc.do';
		    const descValue = document.getElementById("Description") ? document.getElementById("Description").value : "";
		    
		    const formData = new FormData();
		    formData.append('seq', seq);
		    formData.append('languageID', languageID);
		    formData.append('DocumentID', '${DocumentID}');
		    formData.append('fltpCode', fltpCode);
		    formData.append('Description', descValue);
		    formData.append('sessionUserID', sessionUserId);
	
		    try {
		        const response = await fetch(url, {
		            method: 'POST',
		            body: formData 
		        });
		        
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(response.statusText, response.status);
				}
	
		        const result = await response.json();
		        
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}

		        
		        if (result.success) {
		        	
					Promise.all([
						getDicData("ERRTP", "LN0043"), // 저장이 완료되었습니다
						getDicData("BTN", "LN0034"), // 닫기
					]).then(results => {
						showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
					});
					
		        } else {
		        	throw new Error("서버가 저장 작업 실패");
		        }
		    } catch (error) {
		    	handleAjaxError(error, "LN0014");
		    }
		}
	}
	
	function saveNewFile(RefFileID, fltpCode) {
		multiFileUploadEnabled = true;
		refFileID = RefFileID;
		showFileWindow(fltpCode);
	}
	
	function modifyFile(seq, fltpCode) {
		multiFileUploadEnabled = false;
		fileID = seq;
		showFileWindow(fltpCode);
	}
	
</script>

</html>