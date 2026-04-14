<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/vault.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/vault.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
.dhx_vault--container {
	flex: 1 1 auto;
}
</style>
<script>

let fltpCode = null; // 파일코드
var uploadToken = "${uploadToken}"; // 임시폴더 생성을 위한 token

// 중복 확인용
var IS_FiLE_NAME_UNIQUE = "<%=GlobalVal.IS_FiLE_NAME_UNIQUE%>";
let uploadedFileNames = new Set();
let uploadedFileIDs = new Set();

// max file size
const fileTotalMaxSize = "<%=GlobalVal.UPLOAD_ALL_FILES_MAX_SIZE%>";
const individualFileMaxSize = "<%=GlobalVal.FILE_MAX_SIZE%>";

// 알림 메세지
let alertMessageList = [];
let alertMessageListServer = [];

// 클라이언트 측 발생 오류 메시지 출력 시점 위한 변수들
let processedItemCount = 0;
let alertTimer = null;
let beforeAddProcessedFileList = [];
let beforeAddDeniedFileList = [];


// esc키로 dhtmlx alert 닫히도록 할지 말지는 이 상수로 관리
const ESC_KEY_CLOSE_ALERT = false;

//모달에 추가 시 즉시 save처리될지 해당 상수로 관리
var IS_MODAL_UPLOAD_AUTOSAVE = true;

var isLoading = false;

function fnSelectNone(id, code, menuId, defaultValue, isAll, headerKey) {var url = "<c:url value='/ajaxCodeSelect.do'/>";var data = "ajaxParam1="+code+"&menuId="+menuId+"&headerKey="+headerKey;ajaxSelect(url, data, id, defaultValue, 'n', headerKey);}

function setFltpDropdown (scrnType) {
	if(scrnType =="ITM_M"){
		var data = "&itemClassCode=" + itemClassCode;
		var fltpName = "";
		fnSelectNone('fltpCode', data, 'fltpCode', fltpName);
		
		return true
	}
}

function modalSave(){
	
	if(!vault || isLoading){
		console.warn("파일 전송 중 modalSave 호출됨 - 파일 전송은 계속되나 해당 호출에 대한 실행 거부");
		return false;
	}
	
	// vault에 업로드된 파일들 확인
	const uploadedFiles = vault.data.serialize().filter(file => file.status === "uploaded");
	
	if(uploadedFiles.length === 0){
		console.warn("등록된 파일이 없는 상태에서 modalSave 호출됨 - 해당 호출에 대한 실행 거부");
		return false;
	}
	
	else {
		// scrnType에 따라 다른 저장 로직 실행
		if(scrnType === 'ITM_M' || scrnType === 'INST' || scrnType === 'SCR'){
			// 멀티 파일 저장 (서버에 직접 저장)
			fnMutiSave();
		} else if(scrnType === 'SR' || scrnType === 'BRD' || scrnType === 'SCHDL' || scrnType === 'CS' || scrnType === 'ITM'){
			// 부모 화면으로 파일 정보 전달
			fnSaveToOpener();
		}
	}
};

let vault_container = null;
function fnMutiSave(){
    var url = "saveMultiFile.do";
    
    if(scrnType == "INST"){
        url = "saveInstanceFile.do"; 
    }   
    // blankSubFrame iframe 확인하고 없다면 생성
    var iframe = document.querySelector('iframe[name="blankSubFrame"]');
    if(!iframe) {
        // console.log("blankSubFrame 생성");
        iframe = document.createElement('iframe');
        iframe.name = 'blankSubFrame';
        iframe.id = 'blankSubFrame';
        iframe.src = 'about:blank';
        iframe.style.display = 'none';
        iframe.style.width = '0px';
        iframe.style.height = '0px';
        document.body.appendChild(iframe);
    }
    
    // 기존 form 있다면 제거
    if(document.uploadFrm) document.uploadFrm.remove();
        
    // form을 항상 새로 생성해 최신 데이터 반영되도록
    var form = document.createElement('form');
    form.name = 'uploadFrm';
    form.id = 'uploadFrm';
    form.method = 'post';
    document.body.appendChild(form);
    
    var fields = {
        scrnType: scrnType,
        usrId: sessionUserId,
        mgtId: mgtId,
        id: documentId,
        refFileID: refFileID,
        fileID: fileID,
        itemClassCode: itemClassCode,
        docCategory: docCategory,
        projectID: projectId,
        changeSetID: changeSetId,
        uploadToken : uploadToken,
        vaultModalYN : "Y"
    };
    
    if(fltpCode){
        fields.fltpCode = fltpCode;
    }
    
    for(var key in fields){
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = fields[key];
        form.appendChild(input);
    }
    
    // 모달 닫기 전 vault container 저장
    vault_container = document.getElementById("vault_container");
    
	// 모달 닫기
	newFileWindow.hide();
	
	// 로더 활성화
	$('#loading').fadeIn(150);
    
    // submit 실행 (비동기)
    ajaxSubmit(document.uploadFrm, url, "blankSubFrame");
}

function fnSaveToOpener(){
	// 업로드 진행 중인지 확인

	// 부모 화면의 fnDisplayTempFileV4 함수 호출
    if (typeof fnDisplayTempFileV4 === 'function') {
        fnDisplayTempFileV4();
    }
	
	// 모달 닫기
	newFileWindow.hide();

}

// saveMultiFile 이후 실행되는 callbak 함수
function multiSaveCallback(newToken){
	// 1. 로더 비활성화
	$('#loading').fadeOut(150);
	
	// 2. container 체크
//  	const container = document.getElementById("vault_container");
//     if (!vault_container) {
//         newFileWindow.hide();
//         fnReload();
//         return; 
//     }

    // 3. 전역 uploadToken 갱신
    uploadToken = newToken;     
    
    // 4. 모달 닫기
    newFileWindow.hide();
    
    // 5. 부모 창의 파일 목록 새로고침
    fnFileReload();
    
    // 6. Vault 재초기화 (새 토큰 사용)
    if (window.vault) {
        initVault();
    }
}


// Vault 이벤트 정리 함수
function setupVaultEvents() {
    
	if (!window.vault) return;
    
    // Vault 이벤트에서 사용되는 전역 변수 초기화
    uploadedFileNames.clear();
    uploadedFileIDs.clear();
    uploadDeliveredCount = 0;
    
    beforeAddProcessedFileList = [];
    beforeAddDeniedFileList = [];
    
 	// 1. BeforeAdd : 파일 드래그&드롭되는 각 파일에 대해서 서버 전송 대기열에 추가되기 전에 실행됨 >> false 반환 시 vault UI에 표시 X
    // (front) vaultUI 내 이름 중복 검사, 파일 크기 총합 검증, 개별 파일 크기 검증, 유효한 확장자인지 검증
    vault.events.on("beforeAdd", function(newFileMeta){  

    	const file = newFileMeta.file;
		let isThisFileOK = true;
		
		// 파일사이즈 0인 경우 차단
		if (file.size == 0) {
		    Promise.all([
		        getDicData("ERRTP", "LN0044") // 사이즈가 0인 파일은 업로드할 수 없습니다.
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + "results[0].LABEL_NM");
		    });
   
		    isThisFileOK = false;
		    
		    processedItemCount ++;
			
	    	// 기존 타이머 취소
			if (alertTimer) {
				clearTimeout(alertTimer);
			}
			
			// 모든 파일 처리 완료 확인 (300ms 대기)
			alertTimer = setTimeout(function() {
				if (processedItemCount > 0) {
					showErrorDhxAlerts();
					processedItemCount = 0;
				}
			}, 300);
			beforeAddDeniedFileList.push(file);	
	    	return isThisFileOK;
		}
		

	
		// 0. multiUpload 비활성화 된 경우 파일 개수 제한 ======================================================================
			
		if (typeof multiFileUploadEnabled !== 'undefined' && multiFileUploadEnabled === false && beforeAddProcessedFileList.length >= 1) {
	
		    Promise.all([
		        getDicData("ERRTP", "LN0029") // 현재 단계에선 하나의 파일만 업로드 할 수 있어, 해당 파일 업로드가 거부되었습니다.
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
		    });
		    
		    isThisFileOK = false;
		    
		    processedItemCount ++;
			
	    	// 기존 타이머 취소
			if (alertTimer) {
				clearTimeout(alertTimer);
			}
			
			// 모든 파일 처리 완료 확인 (300ms 대기)
			alertTimer = setTimeout(function() {
				if (processedItemCount > 0) {
					showErrorDhxAlerts();
					processedItemCount = 0;
				}
			}, 300);
			beforeAddDeniedFileList.push(file);	
	    	return isThisFileOK;
		}
	
		// 1-1. vaultUI 내 파일명 중복 여부 검증 시작 ==========================================================================
		
		// 1-1-1. 중복 원천 방지
		if (IS_FiLE_NAME_UNIQUE == "Y"){
//			if ("N" == "Y"){	
			// 1-1-1-1. 현 vault 모달 등록 대기열에 업로드된 파일과 비교
			if (uploadedFileNames.has(file.name)) {
	            
			    Promise.all([
			        getDicData("ERRTP", "LN0030") // 동일한 이름의 파일이 이미 업로드 대기열에 존재해 업로드가 거부되었습니다.
			    ]).then(results => {
			    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
			    });
	            
	            isThisFileOK = false;
	        }		
			// 1-1-1-2. 신규 작성 아니라 편집 시, 현재 vault 모달 말고 기존 게시글 또는 아이템에 첨부된 파일과 비교
			if (previousAddedFileNames.has(file.name)) {

				Promise.all([
			        getDicData("ERRTP", "LN0031") // 동일한 이름의 파일이 이미 첨부되어 있어 업로드가 거부되었습니다.
			    ]).then(results => {
			    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
			    });
				
	            isThisFileOK = false;
			}
					
		}
		
		// 1-1-2. 중복 시 파일명 뒤에 (1)형태의 숫자 자동으로 붙여서 저장 허용
		else if (IS_FiLE_NAME_UNIQUE == "N"){
//			else if ("N" == "N"){
			
			let newFileName = file.name;
			let needsRename = false;
			let renameReasonType = ""
			
			// 1-1-2-1. 현 vault 모달 등록 대기열에 업로드된 파일과 비교
			if (uploadedFileNames.has(file.name)) {
				
				// file.name 변경처리
				needsRename = true;
				renameReasonType = "vault";
				
	        }		
			// 1-1-2-2. 신규 작성 아니라 편집 시, 현재 vault 모달 말고 기존 게시글 또는 아이템에 첨부된 파일과 비교
			if (previousAddedFileNames.has(file.name)) {
				
				// file.name 변경처리
				needsRename = true;
				renameReasonType = "previousFiles";
				
			}
			
			if (needsRename) {
				// 모든 기존 파일명을 하나의 Set으로 병합
				const allExistingNames = new Set([...uploadedFileNames, ...previousAddedFileNames]);
				
				// 고유한 파일명 생성
				newFileName = generateUniqueFileName(file.name, allExistingNames);
				
				// File 객체의 name 속성 변경 (새로운 File 객체 생성)
				const newFile = new File([file], newFileName, { type: file.type });
				
				// newFileMeta.file을 새로운 파일로 교체
				Object.defineProperty(newFileMeta, 'file', {
					value: newFile,
					writable: true,
					configurable: true
				});
				
				if (renameReasonType == "vault") {
					Promise.all([
				        getDicData("ERRTP", "LN0032") // 동일한 이름의 파일이 업로드 대기열에 존재해, 해당 파일의 이름을 다음과 같이 변경했습니다.
				    ]).then(results => {
				    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM + " - " + newFileName);
				    });
				} else if (renameReasonType == "previousFiles") {
					Promise.all([
				        getDicData("ERRTP", "LN0033") // 동일한 이름의 파일이 이미 첨부되어있어, 해당 파일의 이름을 다음과 같이 변경했습니다.
				    ]).then(results => {
				    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM + " - " + newFileName);
				    });
				}
			}
		}
		
		else {
			console.error("IS_FiLE_NAME_UNIQUE 설정 오류.")
		}
	
		// ===== vaultUI 내 파일명 중복 여부 검증 종료 ==========================================================================
    
    
    	// 1-2. vaultUI 내 파일 크기 총합 검증 시작 ============================================================================
    	
    	const existingFiles = vault.data.serialize();
    	// 이번 beforeAdd 순회 전까지 vault UI에 추가된 파일 배열
    	
    	let currentTotalSize = 0;

	    
	    existingFiles.forEach(file => {
	        currentTotalSize += file.size; 
	    });
	
    	if (file.size + currentTotalSize > fileTotalMaxSize) {
    		
			Promise.all([
		        getDicData("ERRTP", "LN0034") // 한 번에 업로드할 수 있는 총 파일 크기 제한을 초과하여 업로드에 실패했습니다. (총 파일 크기 제한: 
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM + fileTotalMaxSize/1024/1024 +")");
		    });
   		
    		isThisFileOK = false;
    	}
    	// ===== vaultUI 내 파일 크기 총합 검증 종료 ===============================================================================
    	
    	
    	// 1-3. 개별 파일 사이즈 검증 시작 =========================================================================================

    	if (file.size > individualFileMaxSize) {
    		
    		Promise.all([
		        getDicData("ERRTP", "LN0035") // 개별 파일 크기 제한을 초과해 업로드가 거부되었습니다. (개별 파일 크기 제한:  
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM + individualFileMaxSize/1024/1024 +")");
		    });

    		isThisFileOK = false;
    	}
    	// ===== 개별 파일 사이즈 체크 종료 ========================================================================================
    		
    	
    	// 1-4. 확장자 검증 시작 =================================================================================================
    	const FILE_FORMAT_WHITE_LIST = "<%=GlobalVal.FILE_FORMAT_WHITE_LIST%>";
        const all_file_list = FILE_FORMAT_WHITE_LIST.split(",");
        
     	// 파일명을 .으로 분리, 첫 번째 요소(파일명 본체)를 제외한 나머지가 모두 확장자
        const parts = file.name.split(".");
     	
     	
		// 1-4-1. (default) 멀티확장자 자체를 차단
		// 파일명에 .이 여러개면 멀티확장자이므로 전부 엄격하게 차단됨 => 고객사 요구에 따라 비교적 유연한 검증/차단적용 위해선 1-4-2. 수정해서 사용
        if (parts.length > 2) {
        	Promise.all([
		        getDicData("ERRTP", "LN0036") // 멀티 확장자 파일은 업로드할 수 없습니다.  
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
		    });
            isThisFileOK = false;
        } else if (parts.length === 2) {
            // 확장자가 1개인 경우 화이트리스트 검증
            const ext = parts[1].toUpperCase();
            
            if (!all_file_list.includes(ext)) {
            	Promise.all([
    		        getDicData("ERRTP", "LN0037") // 해당 파일의 확장자는 업로드 될 수 없습니다.  
    		    ]).then(results => {
    		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
    		    });
                isThisFileOK = false;
            }
        } else {
            // 확장자가 없는 파일 처리
            Promise.all([
    		        getDicData("ERRTP", "LN0038") // 확장자가 없는 파일은 업로드될 수 없습니다.  
    		    ]).then(results => {
    		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
    		    });
            isThisFileOK = false;
        }
        
     	// 1-4-2. (고객사 요구에 따라 변경해서 사용) 파일명 내 .으로 나눠진 부분들이 화이트리스트에 포함되어있다면 pass, 하나라도 아니라면 차단
     	
//      	// 첫 번째 요소(파일명 본체)를 제외한 나머지가 모두 확장자
// 		if (parts.length > 1) {
// 		    // 첫 번째 요소 제외하고 모든 확장자 추출
// 		    const extensions = parts.slice(1);
		    
// 		    // 각 확장자를 검증
// 		    for (let i = 0; i < extensions.length; i++) {
// 		        const ext = extensions[i].toUpperCase();
		        
// 		        if (!all_file_list.includes(ext)) {
// 		            const alertMessage = file.name + " 파일 등록 대기열 추가 실패 :" + "<br>" + 
// 		                "확장자가 " + extensions[i] + "인 파일은 업로드할 수 없습니다.";
		            
// 		            alertMessageList.push(alertMessage);
// 		            isThisFileOK = false;
// 		            break; // 하나라도 허용되지 않는 확장자가 있으면 즉시 중단
// 		        }
// 		    }
// 		} else {
// 		    // 확장자가 없는 파일 처리
// 		    const alertMessage = file.name + " 파일 등록 대기열 추가 실패 :" + "<br>" + 
// 		        "확장자가 없는 파일은 업로드할 수 없습니다.";
		    
// 		    alertMessageList.push(alertMessage);
// 		    isThisFileOK = false;
// 		}
        
    	// 확장자 체크 종료 =================================================================================================
    	
    	processedItemCount ++;
	
    	// 기존 타이머 취소
		if (alertTimer) {
			clearTimeout(alertTimer);
		}
		
		// 모든 파일 처리 완료 확인 (300ms 대기)
		alertTimer = setTimeout(function() {
			if (processedItemCount > 0) {
				showErrorDhxAlerts();
				processedItemCount = 0;
			}
		}, 300);
		
		
		if (isThisFileOK) {
			beforeAddProcessedFileList.push(file);
		} else {
			beforeAddDeniedFileList.push(file);
		}
    	
    	return isThisFileOK;

    });
 
 	// 2. UploadFile : 파일 드래그&드롭되는 각 파일에 대해서 서버 uploader 객체로 전송 및 답변 반환받은 후 실행됨
    // 서버 uploader 객체는 파일 검증하며 임시폴더 내 업로드 성공/실패 결과를 반환하며, UploadFile은 각 파일에 대한 이 반환값에 따른 동작 처리
    vault.events.on("UploadFile", function(file){
    	console.log("UploadFile 이번 파일 =====================================");
		console.log(file);
		console.log("========================================================");
		// 성공실패 여부는 state 속성 (boolean), status ("uploaded" 등 string)에서 식별하는 것으로 보임
		// 강선임님께 상황에서 어떤 값 반환하도록 할 것인지 전달받아 작업
		
		
		uploadDeliveredCount ++ ;
	
		if (!file.state) {
			// 서버 반환값이 "실패" 일 때 임시 메시지		
            Promise.all([
		        getDicData("ERRTP", "LN0039") // 서버가 해당 파일에 대한 처리를 거부했습니다.  
		    ]).then(results => {
		    	alertMessageList.push(file.name + " - " + results[0].LABEL_NM);
		    });


			// 빨간색 오류 아이콘 딱지 붙여서 vaultUI에 남기는 처리
			// file.status = "false";
			
			// vault에서 지우는 처리
			vault.data.remove(file.id);
			
		}
		else {
			// 업로드 성공 시 set에 추가 > 파일 이름/ID 중복 검증에 활용
            uploadedFileNames.add(file.name);
            uploadedFileIDs.add(file.id);
			
			// *** 현재 팝업을 연 부모 UI에 파일 추가하던 기존 로직. 팝업이 아니라 모달로 변경됐으므로 코드 수정 필요할 것으로 보임
			if(file.name.length > 0 && "${scrnType}"!="ITM_M" && "${scrnType}"!="INST" && "${scrnType}"!="SCR"){
				var fltpCode = $("#fltpCode").val();

				if (typeof fnAttacthFileHtmlV4 === 'function') {
	                fnAttacthFileHtmlV4(file.id, file.name, file.size, fltpCode);
	            }
			}
		}
		
		
		
		// 모든 업로드 처리 완료 시 saveModal
		if (uploadDeliveredCount == vault.data.serialize().length) {
			
			// console.log("모든 파일 업로더 전송 및 처리 완료")
			
			if (alertMessageList.length > 0 && !isAlertOpen) {
	            showErrorDhxAlerts();
	        } else if (alertMessageList.length > 0 && isAlertOpen){
	        	
	        	dhxAlert.close();	
	        
	        	showErrorDhxAlerts();
	        }
			
			if (IS_MODAL_UPLOAD_AUTOSAVE) {
				modalSave();
			}		
		}
	});

 	// 3. BeforeRemove : vaultUI에서 개별 파일 제거 버튼 클릭 시 즉시 호출됨
	vault.events.on("BeforeRemove", function(file){
		
		$('#modalLoader').css({'opacity': '1', 'visibility': 'visible'});
    
	    // true를 반환하면 삭제 진행, false를 반환하면 삭제 취소
	    return true;
	});
        
 	// 4. AfterRemove : vaultUI에서 개별 파일 제거 버튼 클릭 후 제거 완료 시 호출됨
    // 서버 uploader 객체 통해 임시폴더에 저장됐던 파일 삭제 및 파일명/id 중복검증 용 set에서의 제거 로직 포함
	vault.events.on("AfterRemove", function(file){
		// 중복 검증용 Set에서 삭제된 파일 정보 제거
	    uploadedFileNames.delete(file.name);
	    uploadedFileIDs.delete(file.id);
		
		if("${scrnType}" == "SR") {
			// *** 현재 팝업을 연 부모 UI에 파일 제거하던 기존 로직. 팝업이 아니라 모달로 변경됐으므로 코드 수정 필요할 것으로 보임
			if (typeof fnDeleteFileMapV4 === 'function') {
				fnDeleteFileHtmlV4(file.id, false);
	        }
		} else {
			    		    
			if(file.name.length>0 && scrnType != "ITM_M" && scrnType != "INST" && scrnType !="SCR"){
				if (typeof fnDeleteFileMapV4 === 'function') {

					const fileIdToProcess = file.id.startsWith('u') ? file.id.substring(1) : file.id;
				
					fnDeleteFileHtmlV4(fileIdToProcess, false);
	            }
			}
			// 임시폴더에서 삭제하는 로직
			var url  = "removeTempFile.do";
			var data = "fileName="+file.name+"&uploadToken=" + uploadToken;
			ajaxPage(url,data,"blankSubFrame");
		}
		
		setTimeout(function(){
			$('#modalLoader').css({'opacity': '0', 'visibility': 'hidden'});
	    	isLoading = false;}, 700);
		
		uploadDeliveredCount --;
		
	});
    
 	// 5. RemoveAll : vaultUI에서 모든 파일 제거 버튼 클릭 시 호출됨
    // 서버 uploader 객체 통해 임시폴더에 저장됐던 파일 삭제 및 파일명/id 중복검증 용 set에서의 제거 로직 포함
	vault.events.on("RemoveAll", function(){
		
		// *** 기존 addFilePopV4.jsp의 로직 그대로 가져왔으나,
		// *** 특정 scrnType일 때에만 임시폴더 삭제 메서드 호출하거나 파일명 중복 검증용 set 정리하는 등 이해 못하겠는 부분 많음
		// *** 확인 필요할듯
	
    	if(scrnType == "SR") {
    		
    		// fileNameList.forEach(e => window.opener.fnDeleteFileMapV4("",e));
		        uploadedFileIDs.forEach(fileId => {
	            if (typeof fnDeleteFileMapV4 === 'function') {
					const fileIdToProcess = fileId.startsWith('u') ? fileId.substring(1) : fileId;	
					fnDeleteFileHtmlV4(fileIdToProcess, false);
	            }
	        });
    		uploadedFileIDs.clear();
            uploadedFileNames.clear();
            
            beforeAddProcessedFileList = [];
            beforeAddDeniedFileList = [];
            
    	} else {
    		if(scrnType != "ITM_M" && scrnType != "INST" && scrnType != "SCR"){
				uploadedFileIDs.forEach(fileId => {
         			if (typeof fnDeleteFileMapV4 === 'function') {
						const fileIdToProcess = fileId.startsWith('u') ? fileId.substring(1) : fileId;
						fnDeleteFileHtmlV4(fileIdToProcess, false);
						uploadDeliveredCount = 0;
         			}
     			});
        
				var url  = "removeTempFile.do";
				var data = "removeAll=Y&uploadToken=" + uploadToken;
				ajaxPage(url,data,"blankSubFrame");
			}

		    uploadedFileIDs.clear();
            uploadedFileNames.clear();
            
            beforeAddProcessedFileList = [];
            beforeAddDeniedFileList = [];
    	}
		
    	setTimeout(function(){
			$('#modalLoader').css({'opacity': '0', 'visibility': 'hidden'});
	    	isLoading = false;}, 700);
    	
    	uploadDeliveredCount =0;
   });
}

// Vault 생성
function initVault() {
   
	// 1. vault 존재 시 초기화
    if (window.vault) {
        window.vault.destructor();
        window.vault = null;
    }
    if (typeof vault !== 'undefined' && vault) {
        try { vault.destructor(); } catch(e){}
        vault = null;
    }
    
    try {
        // 2. 토큰 업데이트
        var currentToken = uploadToken;
        // var param ="scrnType=" + scrnType + "&mgtId=" + mgtId + "&id=" + id + "&usrId=" + sessionUserId + "&mode=html5&uploadToken="+ currentToken + "&fltpCode=" + fltpCode;
        // var param ="scrnType=" + scrnType + "&mgtId=" + mgtId + "&usrId=" + sessionUserId + "&mode=html5&uploadToken="+ currentToken + "&fltpCode=" + fltpCode;
    	
        const paramsObj = {
			scrnType: typeof scrnType !== 'undefined' ? scrnType : "",
      		mgtId: typeof mgtId !== 'undefined' ? mgtId : "",
			usrId: typeof sessionUserId !== 'undefined' ? sessionUserId : "",
			mode: "html5",
			uploadToken: typeof currentToken !== 'undefined' ? currentToken : "",
			fltpCode: typeof fltpCode !== 'undefined' ? fltpCode : ""
        };

       	const searchParams = new URLSearchParams();

       	for (const key in paramsObj) {
       	    const value = paramsObj[key];
       	    if (value !== null && value !== undefined && value !== "") {
       	        searchParams.append(key, value);
       	    } else {
       	        searchParams.append(key, ""); 
       	    }
       	}

       	var param = searchParams.toString();
        
        // 3. 초기화
        window.vault = new dhx.Vault(null, {
            uploader: {
                target: "${root}fileUploadHandler.do?" + param,
                autosend: true,
            },
            downloadURL: "${root}backend/upload/files/",
        });
        
        // 4. 이벤트 재설정
        setupVaultEvents(); 
        
        modalLayout.cell("vault_area").attach(window.vault);
        
        return true
    }
    catch (error){
    	
    	console.warn("modalLayout: ", modalLayout);
    	return error;
    }
    

}

var headerHtml = ""

var footerHtml = ""	

var loaderHtml = `
    <div id="modalLoader" style="opacity:0; visibility:hidden; position:absolute; top:0; left:0; right:0; bottom:0; background-color:rgba(255,255,255,0.7); z-index:9999; transition:opacity 0.15s, visibility 0.15s; display:flex; align-items:center; justify-content:center;">
        <div style="width:38px; height:38px;">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 38" width="38" height="38">
              <defs>
                <radialGradient id="modalLoaderGradient" cx=".66" fx=".66" cy=".313" fy=".313" gradientTransform="scale(1.5)">
                  <stop offset="0" stop-color="#193598"/>
                  <stop offset=".3" stop-color="#193598" stop-opacity=".9"/>
                  <stop offset=".6" stop-color="#193598" stop-opacity=".6"/>
                  <stop offset=".8" stop-color="#193598" stop-opacity=".3"/>
                  <stop offset="1" stop-color="#193598" stop-opacity="0"/>
                </radialGradient>
              </defs>
              <path transform-origin="center" fill="none" stroke="url(#modalLoaderGradient)" stroke-width="4.56" stroke-linecap="round" stroke-dasharray="200 1000" d="M32.3 19A13.3 13.3 0 0 1 19 32.3 13.3 13.3 0 0 1 5.7 19a13.3 13.3 0 0 1 26.6 0z">
                <animateTransform type="rotate" attributeName="transform" calcMode="spline" dur="1.9" values="360;0" keyTimes="0;1" keySplines="0 0 1 1" repeatCount="indefinite"/>
              </path>
              <path transform-origin="center" fill="none" opacity=".2" stroke="#193598" stroke-width="4.56" stroke-linecap="round" d="M32.3 19A13.3 13.3 0 0 1 19 32.3 13.3 13.3 0 0 1 5.7 19a13.3 13.3 0 0 1 26.6 0z"/>
            </svg>
        </div>
    </div>
`;
	
if (IS_MODAL_UPLOAD_AUTOSAVE) {
	footerHtml += `
		<div id="vault_container" style="width:100%; height:340px; box-sizing:border-box;"></div>
	`;
}

if (!IS_MODAL_UPLOAD_AUTOSAVE) {
	footerHtml += `
		<div id="vault_container" style="width:100%; height:340px; box-sizing:border-box;"></div>
		<div class="flex justify-end mgT15">
		    <div class="btns">
	    		<button id="save" class="primary" onclick="modalSave()">Save</button>
		    </div>
		</div>
	`;
}

// Layout 설정
var layoutConfig = {
    rows: [
        {
            id: "header_area",
            height: "content", 
            html: headerHtml
        },
        {
            id: "vault_area",
        }
    ]
};

if (!IS_MODAL_UPLOAD_AUTOSAVE) {
    layoutConfig.rows.push({
        id: "footer_area",
        height: "content", 
        html: footerHtml
    });
}

var modalLayout = new dhx.Layout(null, layoutConfig);

var newFileWindow = new dhx.Window({
    width: 460,
    height: (docCategory == 'ITM') && (scrnType=='ITM_M' || scrnType=='INST') ? 540 : 500,
    title: "첨부문서 등록",
    modal: true
});

newFileWindow.attach(modalLayout);

var isAlertOpen = false;

newFileWindow.events.on("beforeHide", function(position, events) {
    if (isAlertOpen) {
        return false; // alert가 열려있으면 모달 닫기 방지
    }
    return true; // alert가 없으면 정상적으로 닫기
});

var needInitOnAfterShow = true;

window.vault = null;

newFileWindow.events.on("afterShow", () => {
	
	alertMessageList = [];
	
	const existingLoader = document.getElementById("modalLoader");
    if (existingLoader) {
        existingLoader.remove();
    }
    
    // dhtmlx 내부 DOM 렌더링 후 로더 주입되도록 지연시간 부여
    setTimeout(() => {
        
        const windowRoot = newFileWindow.getContainer ? newFileWindow.getContainer() : null; 
        
        let windowContent = null;
        if (windowRoot) {
            windowContent = windowRoot.querySelector(".dhx_window-content, .dhx_window__content");
        }

        if (windowContent) {
            // 로더 재주입
            windowContent.style.position = "relative";
            windowContent.insertAdjacentHTML("beforeend", loaderHtml);
        } else {
            console.warn("DOM 참조 실패: Window에서 dhtmlx window 영역 찾기 실패");
        }
    }, 50); 
	
	if (needInitOnAfterShow) {
		const executeInitVaultResult = initVault();
		
		if (executeInitVaultResult === true) {
			needInitOnAfterShow = false;
		} else {
			console.warn("initVault 중 오류 발생: ", executeInitVaultResult);
		}
		
	}
});

var dhxAlert;

function showFileWindow(code) {
	fltpCode = code;
	newFileWindow.show();
}

//dhtmlx 알러트 화면에 띄우는 함수
function showErrorDhxAlerts() {

	// ESC 키 감지 리스너 추가
    const handleEscKey = function(e) {
    	
    	// ESC 키 닫힘 허용 시
    	if (ESC_KEY_CLOSE_ALERT){
            if (e.key === 'Escape' || e.keyCode === 27) {
                isAlertOpen = false;
                alertMessageList = [];
                document.removeEventListener('keydown', handleEscKey);
            }
    	}
    	else {
            if (e.key === 'Escape' || e.keyCode === 27) {
        	
                e.preventDefault()
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
    	}

    };
    
    document.addEventListener('keydown', handleEscKey, true);	
    let msgToPrint = "";
    
    if (!isAlertOpen && (alertMessageList.length > 0)){
    	isAlertOpen = true;	
    	alertMessageList.forEach((msgItem) => {
    		msgToPrint += msgItem + "<br>" + "<br>";
   		});
           
    	showDhxAlert(msgToPrint, "close", afterCloseCallback)
    	function afterCloseCallback(answer){
    		isAlertOpen = false;
    		alertMessageList = [];
    		document.removeEventListener('keydown', handleEscKey);
    		
    		newFileWindow.hide();
    		if(scrnType === 'ITM_M' || scrnType === 'INST' || scrnType === 'SCR'){
    			console.log("newFileWindow.hide()2");
    			newFileWindow.hide();
   			}
   		}          
	}
}

// 파일명 중복 시 새로운 파일명 생성하는 함수
function generateUniqueFileName(originalName, existingNames) {
	
	// 원본 파일명의 확장자 부분 분리
	const lastDotIndex = originalName.lastIndexOf('.');
	const nameWithoutExt = lastDotIndex > -1 ? originalName.substring(0, lastDotIndex) : originalName;
	const extension = lastDotIndex > -1 ? originalName.substring(lastDotIndex) : '';
	
	// 원본 파일명이 (숫자) 패턴 갖는지 확인
	const numberPattern = /\((\d+)\)$/;
	const match = nameWithoutExt.match(numberPattern);
	
	// 원본 파일명에서 (숫자) 패턴 제거해 baseName에 저장
	let baseName = match ? nameWithoutExt.replace(numberPattern, '') : nameWithoutExt;
	
	// 원본 파일명이 (숫자) 패턴 갖는다면 해당 숫자를 startNumber에 저장
	let startNumber = match ? parseInt(match[1]) : 0;
	
	// 중복되지 않는 파일명 만들기
	let newFileName = originalName;
	let counter = startNumber + 1;
	
	while (existingNames.has(newFileName)) {
		newFileName = baseName + '(' + counter + ')' + extension;
		counter++;
	}
	
	return newFileName;
}
</script>