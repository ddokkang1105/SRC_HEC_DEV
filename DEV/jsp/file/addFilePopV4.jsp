<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<title>Upload</title>

<!-- meta block -->
<title>Upload and rename - DHTMLX Vault</title>
<meta name="description" content="Check interactive samples of DHTMLX Vault to explore its configuration and other details.">
<!-- end meta block -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" charset="utf-8">
<script type="text/javascript" src="${root }cmm/js/dhtmlx/vaultV4/codebase/vault.js?v=4.0.0"></script>
<link rel="stylesheet" href="${root }cmm/js/dhtmlx/vaultV4/codebase/vault.css?v=4.0.0">
<link rel="stylesheet" href="${root }cmm/js/dhtmlx/vaultV4/common/index.css?v=4.0.0"> 
<link rel="stylesheet" href="${root }cmm/js/dhtmlx/vaultV4/common/vault.css?v=4.0.0">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00118" var="WM00118"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<script type="text/javascript">

	$(document).ready(function() {
		
		(function cleanPreviousTempFiles() {
	        var url  = "removeFile.do";
	        var data = "removeAll=Y&isInit=Y";
	        ajaxPage(url, data, "blankSubFrame"); 
	        console.log("팝업 초기화: 이전 임시 파일 보관소 비우기 요청 완료.");
	    })();
		
	});


 	debugger;
	if("${scrnType}"=="ITM_M"){
		var data = "&itemClassCode=${resultMap.itemClassCode}";
		var fltpName = "";
		fnSelectNone('fltpCode', data, 'fltpCode', fltpName); 
	}else if("${scrnType}"=="INST"){		
		var data = "&itemID=${id}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
		fnSelectNone('fltpCode', data, 'getInstanceFltp', ""); 
		
	}else if("${docCategory}"=="SR" || "${actvityLogID}" != ""){		
		var data = "&activityLogID=${activityLogID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&docCategory=${docCategory}&speCode=${speCode}&srType=${srType}"; 
	
		fnSelectNone('fltpCode', data, 'getESMFltpAllocList', "", "", "esm_SQL"); 
	};
	/* else if("${scrnType}"=="SCR"){
		var data = "&scrId=${id}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('fltpCode', data, 'getFltpBySCR', '','','scr_SQL');
	}; */
	
	function fnMutiSave(){
		var url  = "saveMultiFile.do";
		var screenType = "${screenType}";
		if(screenType == "INST"){url="saveInstanceFile.do"; }
		ajaxSubmit(document.uploadFrm, url,"blankSubFrame");	
	}
	
	function clickClosePop(){
		debugger;

		
		if(fileNameList.length && "${scrnType}" == "SR") {
			fileNameList.forEach(e => window.opener.fnDeleteFileMapV4("",e));
			window.removeEventListener("beforeunload", beforeUnloadHandler);
			close();
		} else {
			if("${scrnType}"=="ITM_M") fnGoList();
			else self.close();
		}
	}
	

	
	
	function viewMessage(restrictedExtensions){
		if(typeof restrictedExtensions == "undefined" || restrictedExtensions == null){
			restrictedExtensions = "";
		}		
		alert("${WM00067}" + restrictedExtensions);
		fnGoList();
	}
	
	//kefico 전용 
	function viewMessageMIP(avg){
		if(avg ==="secret"){
			alert("이 파일은 보안 설정(예: 비밀 레이블)으로 인해 접근이 불가합니다. 파일 소유자에게 문의 해주세요.");
		}		
		alert("${WM00067}" + restrictedExtensions);
		fnGoList();
	}
	

	function fnGoList(){
		if("${screenType}" == "csrDtl"){
			
			window.opener.fnCallBack(); 
		}else{window.opener.setSubFrame();}
		self.close();
	}
	
	function fnSaveToOpener(){
		window.removeEventListener("beforeunload", beforeUnloadHandler);
		if(!complete) {
			alert("파일 전송 중입니다.!");
			return false;
		}
		debugger;
		window.opener.fnDisplayTempFileV4();
		self.close();
	}
	
	const beforeUnloadHandler = (event) => {
		fileNameList.forEach(e => window.opener.fnDeleteFileMapV4("",e));
	}
	
	window.addEventListener("beforeunload", beforeUnloadHandler);
	
</script>
</head>

<body>
		<form name="uploadFrm" id="uploadFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
		<input type="hidden" id="usrId" name="usrId" value="${usrId}">
		<input type="hidden" id="mgtId" name="mgtId" value="${mgtId}">
		<input type="hidden" id="id" name="id" value="${id}">
		<input type="hidden" id="itemClassCode" name="itemClassCode" value="${resultMap.itemClassCode}">
		<input type="hidden" id="docCategory" name="docCategory" value="${docCategory}">
		<input type="hidden" id="projectID" name="projectID" value="${projectID}">
		<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}">
		<c:if test="${screenType == 'csrDtl' || scrnType eq 'SCR'}">
		<input type="hidden" id="fltpCode" name="fltpCode" value="${fltpCode}">
		</c:if>
		
	    <div >
  			<table class="tbl_brd mgT20 mgR20" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
				<c:if test="${(docCategory == 'ITM') && (scrnType=='ITM_M' || scrnType=='INST')}">
				<tr>
					<td>
						<div style="margin-top:3px;margin-right:10px;">
							<span style="margin-right:18px;">${menu.LN00091}</span>
							<span>
							<select id="fltpCode" name="fltpCode" style="width:200px;" ></select>
							<input type="hidden" class="text" id="fileType" name="fileType" value="${resultMap.fltpCode}" size="60" />
							</span>
						</div>
					</td>
				</tr>
				</c:if>
			</table>
		</div>
		<section class="dhx_sample-container">
			<div class="dhx_sample-container__widget" id="vault"></div>
		</section>
		<div class="alignBTN mgB5 mgR50">
				<c:if test="${scrnType=='ITM_M' || scrnType=='INST' || scrnType=='SCR'}">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnMutiSave();" type="submit"></span>
				</c:if>
				<c:if test="${scrnType eq 'SR' || scrnType eq 'BRD' || scrnType eq 'SCHDL' || scrnType eq 'CS'}">
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveToOpener();" type="submit"></span>
				</c:if>	
				<span class="btn_pack medium icon"><span class="confirm"></span><input class="popup_closeBtn" value="Close" onclick="clickClosePop();" type="submit"></span>
		</div>		
		<script >
			let complete = true;
			let fileIDList = [];
			let fileNameList = [];
			
		    var param ="scrnType=${scrnType}&mgtId=${mgtId}&id=${id}&usrId=${usrId}&mode=html5";
			var vault = new dhx.Vault("vault", {
				uploader: { 
					target: "/fileUploadHandler?" + param,
					autosend: true,
					 // params:{ param1:"value1",  param2:"value2" }
				},
				downloadURL: "/backend/upload/files/",
			});	
			
			vault.events.on("UploadFile", function(file){
				console.log("UploadFile 콜백 실행");
				console.log(file);
				console.log("=========================================");
				var files = vault.data.findAll({by:"status", match:"uploaded"});
				//console.log("files :"+ JSON.stringify(files) ); //  JSON.parse(files)
				
				// file.state 값이 null 또는 undefined일 경우
			    if (file.state == null || file.state === undefined) {
			        alert(file.name + "의 상태를 확인할 수 없습니다. 서버 오류가 발생했을 수 있습니다.");
			        return false;  // 업로드 처리를 중단합니다.
			    }
				
				if(!file.state){
					alert(file.name+"은(는) 첨부가 불가능한 파일 유형입니다."); return true;
				}
				if(file.name.length>0 && "${scrnType}"!="ITM_M" && "${scrnType}"!="INST" && "${scrnType}"!="SCR"){
					//console.log("files:"+file.name+":::"+file.id);
					var fltpCode = $("#fltpCode").val();

	        		fileNameList.push(file.name);
		        	// 기존 위치
	        		// fileIDList.push(file.id);
		    		window.opener.fnAttacthFileHtmlV4(file.id, file.name, file.size, fltpCode);
				}
				fileNameList.push(file.name);
			});
			
			vault.events.on("uploadProgress", function(file){
				complete = false;
			})
			
	    	vault.events.on("AfterRemove", function(file){
	    		if("${scrnType}" == "SR") {
	    			fileIDList.splice(fileIDList.findIndex(e => e == file.id), 1);
	    			fileNameList.splice(fileNameList.findIndex(e => e == file.name), 1);
	    			window.opener.fnDeleteFileMapV4("",file.name);
	    		} else {
	    			//console.log("AfterRemove : "+file.id+" , filename :"+file.name + "scrnType = ${scrnType}");	    		    
	    			if(file.name.length>0 && "${scrnType}"!="ITM_M" && "${scrnType}"!="INST" && "${scrnType}"!="SCR"){
			    		//window.opener.fnDeleteFileHtmlV4("#"+file.id);
			    		window.opener.fnDeleteFileMapV4(file.id);
					}
	    			var url  = "removeFile.do";
	    			var data = "fileName="+file.name;
	    			ajaxPage(url,data,"blankSubFrame");
	    		}
	    	});
	    	
	    	vault.events.on("RemoveAll", function(){
   		    	if("${scrnType}" == "SR") {
   		    		fileNameList.forEach(e => window.opener.fnDeleteFileMapV4("",e));
   		    		fileIDList = [];
   		    		fileNameList = [];
   		    	} else {
   	   		    	if("${scrnType}"!="ITM_M" && "${scrnType}"!="INST" && "${scrnType}"!="SCR"){
   			    		window.opener.fnDeleteFileMapV4('', 'removeall');
   					}
   	   		    	
   	   		 		 /* 
   	    		    vault.data.map(function(fileItem){
   	    		    	
   	    		    	console.log("fileItem file name  :"+fileItem.file +" , fileItem.file.fileName :"+fileItem.file.fileName);
   	    		    	
   	    		        return fileItem.file;
   	    		    }); */
   	    			var url  = "removeFile.do";
   	    			var data = "removeAll=Y";
   	    			ajaxPage(url,data,"blankSubFrame");
   		    	}
    		    
    	   });
	    	
	    	vault.events.on("uploadComplete",function(files) {
				console.log("uploadComplete 콜백 실행");
				console.log(files);
				console.log("=========================================");
	    		complete = true;
	    	})
	    	
	    	var totalSize = 0; 
	    	var maxSize = 1024765432; // 977MB
	    	
	        vault.events.on("beforeuploadfile", function(file){  // beforeuploadfile
// 	        	console.log("file.name :::> "+file.name+", file.size :"+file.size+", uploaded :"+file.uploaded);
	        
				console.log("beforeuploadfile 콜백 실행");
				console.log(fileNameList);
				console.log(file);
				console.log("=========================================");
	        	
	        	totalSize += file.size;
			    if (totalSize > maxSize) return false; 
			    
			    /* var fileLength = file.name.length;
			    var ext = file.name.slice(file.name.indexOf(".") + 1).toLowerCase();
			 
			    if (ext == "jsp" || ext== "php" || ext=="js" || ext=="asp" || ext=="aspx" || ext=="exe"){
			    	alert("upload 불가능한 파일입니다. ");
			    	return false;
			    } */
			    
			    if(fileNameList.includes(file.name)) {
	        		alert("동일한 파일은 중복 업로드 되지 않습니다.");
	        		return false;
			    }
			   
			    return true;
	    	});
			  
			
			</script>	
			<iframe name="blankSubFrame" id="blankSubFrame" src="about:blank" style="display:none" frameborder="0"></iframe>	
		</form> 
</body>
</html>