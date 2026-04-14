<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
    <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
  </head>
  <body>
  	<div class="pdL20 pdR20">
	    <div class="new-form">
	    	<div class="btn-wrap page-title btns">
				${menu.ZLN0066}
				<button onclick="fnSaveFile()" class="primary">${menu.ZLN0067}</button>
			</div>
   			<!-- 첨부문서 -->
			<table class="form-column-8 new-form" width="100%" cellpadding="0" cellspacing="0"  style="table-layout: fixed;">
				<colgroup>
					<col width="140px">
				    <col width="calc(100% - 140px)">
				</colgroup>	
				<tr>
					<!-- 단계 -->
					<th>${menu.ZLN0060}</th>
					<td class="alignL">
						<select id="activity" style="width:300px;" onChange="fnChangeActivity();">
						</select>
					</td>			
				</tr>
				<tr>
					<!-- 첨부문서 -->
					<th>${menu.LN00111}</th>
					<td class="alignL last btns" id="fileList" style="height: 250px;display: block;overflow:hidden auto;"></td>			
				</tr>
			</table>
	    </div>
   	</div>
   	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
    <script>
    let fileTypeList = "";
    let fileTypeUpdateList = [];
	let speCode = "${status}";
    
    getSrFileList();
    setActivity();
    
	async function selectFileType(defaultValue, ind, seq) {
		// FileType setting
  		if(fileTypeList.length === 0) {
  			fileTypeList = await fetch("/olmapi/espFileType/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&docCategory=SR&speCode="+speCode+"&srType=${srType}")
  			.then((response) => response.json())
  			.then(data => fileTypeList = data)
  		}

    	let html = `<select onchange="setFlleTypeUpdateList(this, \${seq})">`;
	    fileTypeList.forEach(e => {
	        if (e.CODE == defaultValue) {
	            html += `<option value="\${e.CODE}" selected>\${e.NAME}</option>`;
	        } else {
	            html += `<option value="\${e.CODE}">\${e.NAME}</option>`;
	        }
	    });
	    html += '</select>';

    	return html;
	}
	
	function setFlleTypeUpdateList(e, seq) {
		if(fileTypeUpdateList.filter(e => e.seq === seq).length === 0) fileTypeUpdateList.push({ "seq" : seq, "fileType" : e.value});
		else fileTypeUpdateList[fileTypeUpdateList.findIndex(e => e.seq === seq)] = { "seq" : seq, "fileType" : e.value};
	}
	
	function textfileSize(e) {
		if(e === '0') return '0'
		else return getFileSize(e);
	}
	
	async function setAttachFileCheck(){
	    const attachFileCheckList = await setAttachFileCheckList();
	    if(attachFileCheckList !== undefined && attachFileCheckList !== '' && attachFileCheckList !== null){
	    	$("#attachFileCheckText").text("*필수첨부파일 : " + attachFileCheckList);
	    }
	}
	
	// 필수첨부파일 list
	async function setAttachFileCheckList(fileList){
		let SRAT0004 = "${SRAT0004}";
	    if(SRAT0004 !== undefined && SRAT0004 !== null && SRAT0004 !== ''){
	    	const response = await fetch('/olmapi/espActivityFileCheck', {
				method: 'POST',
				body : JSON.stringify({
					srID : "${srID}",
					languageID : "${sessionScope.loginInfo.sessionCurrLangType}",
					clientID : "${customerNo}",
					speCode : speCode,
					SRAT0004 : SRAT0004
	            }),
				headers: {
					'Content-Type': 'application/json; charset=UTF-8',
				},
			});
			
			// 첨부파일 리스트 가져오기 ( fltpCode / fltpCodeNM )
			const attachCheckList = await response.json();
			
			let attachFileCheckList = '';
			
			if (attachCheckList && attachCheckList.length > 0) {
				attachCheckList.forEach(item => {
					if(fileList !== undefined && fileList !== '' && fileList !== null){
						if (!fileList.includes(item.FltpCode)) {
					        if(attachFileCheckList === '') attachFileCheckList = item.Name;
					        else attachFileCheckList += ',' + item.Name;
					    }
					} else {
				        if(attachFileCheckList === '') attachFileCheckList = item.Name;
				        else attachFileCheckList += ',' + item.Name;
					}
				});
			}
			
			if(attachFileCheckList !== '' && attachFileCheckList !== null && attachFileCheckList !== undefined){
				return attachFileCheckList;
			}
	    }
	}
	
    async function getSrFileList() {
    	//$('#loading').fadeIn(150);
    	
	    document.querySelector("#fileList").innerHTML = '';

	    const res = await fetch("/olmapi/activityFile?srID=${srID}&speCode="+speCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
	    const data = await res.json();
	    
	    let html = "";
	    let style = "";
	    
	    if(data !== undefined && data !== null && data !== ''){
				html += '<button id="attach" onclick="doAttachFileV4()"></button>';
				style = data.data.length > 0 ? "width:100%;" : "display:none;";
				html += '<div class="tmp_file_wrapper mgT10" style="'+style+'" id="tmp_file_wrapper">';
				html += '<table id="tmp_file_items" name="tmp_file_items" width="100%">';
				html += '<colgroup><col width="40px"><col width="170px"><col width=""><col width="70px"></colgroup>';
				html += '<tbody name="file-list">';
				for(var i = 0; i < data.data.length; i++) {
					html += '<tr id="'+data.data[i].Seq+'">';
					html += '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteESRFile(\'${srID}\',\''+data.data[i].Seq+'\',\''+data.data[i].FileName+'\',\''+data.data[i].srFilePath+'\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>';
					html += '<td name="fileType">' + await selectFileType(data.data[i].fltpcode, i, data.data[i].Seq) + '</td>';
					html += '<td name="fileName">'+data.data[i].FileRealName+'</td>';
					html += '<td class="alignR">'+textfileSize(data.data[i].FileSize)+'</td>';
					html += '</tr>';
				}
				html += '</tbody>';
				html += '</table>';
				html += '</div>';
		    
		    //fileAttachCheck
		    html += '<span id="attachFileCheckText" style="margin-top: 5px; display:inline-block; color:#0761cf;"></span>'
			document.querySelector("#fileList").insertAdjacentHTML("beforeend", html);
			fnSetButton("attach", "attach", "Attach", "tertiary");
		 
			//$('#loading').fadeOut(150);
			
			setAttachFileCheck();
	    }
	}
    
	// 필수 산출물 체크
	async function attachFileCheck() {
		let fileList = [];
		
		const fileListContainer = document.querySelector("#tmp_file_items").children.namedItem("file-list").childNodes;
		fileListContainer.forEach(e => {
		    if(e.tagName === "TR" && e.children.namedItem("fileType")) fileList.push(e.children.namedItem("fileType").childNodes[0].value)
		})
		
		//fileAttachCheck
	    const attachFileCheckList = await setAttachFileCheckList(fileList);
		if(attachFileCheckList !== '' && attachFileCheckList !== null && attachFileCheckList !== undefined){
			//alert("필수 첨부파일이 없습니다. [" + attachFileCheckList + "]\n※ 첨부파일의 문서유형을 확인바랍니다");
			getDicData("ERRTP", "ZLN0003").then(data => alert(data.LABEL_NM.replace("replaceText", attachFileCheckList)));
		    return false;
		}else{
			return true;
		}
	}
	
	async function fnSaveFile(){
		if(!await validOption()) { return; }
		
		// 파일 저장
		await saveFile();
	}
	 // 완료 시 체크
    
	async function validOption(){
		let res = true;
		
		// 필수 산출물 체크
		if(!await attachFileCheck()){
			res = false;
		}
		
		return res;
	}
	 
	async function saveFile() {
		let fileList = [];
		const fileListContainer = document.querySelector("#tmp_file_items").children.namedItem("file-list").childNodes;
		fileListContainer.forEach(e => {
		    if(e.tagName === "TR" && e.children.namedItem("fileType")) fileList.push({"fileType" : e.children.namedItem("fileType").childNodes[0].value, "fileName" : e.children.namedItem("fileName").textContent})
		})
		
		if(fileList.length > 0 || fileTypeUpdateList.length > 0) {
			const res = await fetch('/saveEsrFile.do', {
				method: 'POST',
				body : JSON.stringify({
					srID : "${srID}",
					docCategory : "SR",
					projectID : "${projectID}",
					speCode : speCode,
					activityLogID : "${activityLogID}",
					fileList : fileList,
					fileTypeUpdateList : fileTypeUpdateList,
	            }),
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			}).then(() => {
				self.close();
				window.opener.doSearchFileList();
			})
		}
	}
	
	// Activity 선택
	function setActivity(){
		
		$('#loading').fadeIn(150);
		
		var sqlID="esm_SQL.getESMProLogInfo";
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID="+sqlID;
			param += "&srID=${srID}"
			param += "&docCategory=SR"
			param += "&srType=${srType}"
			param += "&notInActivityStatusList='07','00'";
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				const rs = JSON.parse(result);
				const activitySelect = document.getElementById('activity');
				rs.forEach(activity => {
				    const option = document.createElement("option");
				    option.value = activity.speCode; 
				    option.textContent = activity.ActivityName;
				    activitySelect.appendChild(option);  // select에 option 추가
				    
				    if(activity.speCode === speCode){
				    	option.selected = true;
				    }
				});
				
				$('#loading').fadeOut(150);
				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	// Activity 변경
	function fnChangeActivity(){
		fileNameMapV4.forEach(e => fetch("/removeFile.do?fileName="+e));
		
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
		
		speCode = document.getElementById('activity').value;
		// fileType 리스트 초기화
		fileTypeList = [];
// 		window.location.href = "/zDLM_changeFile.do?srID=${srID}&status="+speCode+"&srType=${srType}&customerNo=${customerNo}&projectID=${projectID}";
		getSrFileList();
	}
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	var duplMap = new Map();
	let duplMsg = false;
	
	//************** addFilePop V4 설정 START ************************//
	function getKeyByValue(map, searchValue) {
	  for (let [key, value] of map.entries()) {
	    if (value === searchValue)
	      return key;
	  }
	}
	
	function doAttachFileV4(){		
		var url="addFilePopV4.do";
		var data="scrnType=SR&docCategory=${docCategory}"
				+"&activityLogID=${activityLogInfo.ActivityLogID}"
				+"&speCode=${srInfoMap.Status}"
				+"&srType=${srType}";
		openPopup(url+"?"+data,490,450, "Attach File");
	}
	
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize, fltpCode){ 
		duplMsg = false;
		// 새로 추가한 리스트에 있거나
		const id = getKeyByValue(fileNameMapV4, fileName);
		
		//기존 파일 리스트에 가지고 있는 경우
		document.getElementsByName("fileName").forEach(e => {
			if(e.innerText == fileName) {
				duplMsg = true;
				fetch("/removeFile.do?fileName="+fileName);
			}
		});
		
		fileID = fileID.replace("u","");
		if(!id && !duplMsg) {
			fileIDMapV4.set(fileID,fileID,fileSize);
			fileNameMapV4.set(fileID,fileName);
			fileSizeMapV4.set(fileID,fileSize);
		} else {
			duplMap.set(fileID,fileName);
		}
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID, fileName){
		fileID = fileID.replace("u","");
		
		if(!getKeyByValue(duplMap, fileName)) {			
			fetch("/removeFile.do?fileName="+fileName);

			fileIDMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileNameMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileSizeMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
		}
	}
	
	async function fnDisplayTempFileV4(){
		if(fileTypeList.length === 0) {
  			fileTypeList = await fetch("/olmapi/espFileType/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&scrnType=SR&docCategory=SR&activityLogID=${activityLogInfo.ActivityLogID}&speCode="+speCode+"&srType=${srType}")
  			.then((response) => response.json())
  			.then(data => fileTypeList = data)
  		}
		
		let html = '<select>';
		fileTypeList.forEach(e => {
			html += `<option value="\${e.CODE}">\${e.NAME}</option>`
		});
		html += '</select>';
		
		let display_scripts = "";
		fileIDMapV4.forEach(function(fileID) {			
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
				'<td name="fileType">'+
				html+
				'</td>'+
				'<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
				'<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
				'</tr>';
			}
		});
		
		document.querySelector("#tmp_file_items").children.namedItem("file-list").insertAdjacentHTML("beforeend",display_scripts);
		document.querySelector("#tmp_file_wrapper").style.display = "block";
		
		if(duplMsg) getDicData("ERRTP", "LN0006").then(data => alert(data.LABEL_NM));
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		const duplKey = getKeyByValue(duplMap, fileNameMapV4.get(String(fileID)));
		if(duplKey) {
			duplMap.delete(duplKey);
		}
		var fileName = document.getElementById(fileID).children.namedItem("fileName").innerHTML;
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"saveFrame");
		}
	
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0)
			document.querySelector("#tmp_file_wrapper").style.display = "none";
	} 
	//************** addFilePop V4 설정 END ************************//
	
	// 기존 파일 삭제
	function fnDeleteESRFile(srID, seq, fileName, filePath){
		var url = "deleteSRFile.do";
		var data = "srID="+srID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$("#"+seq).remove();
	}
    </script>
  </body>
</html>
