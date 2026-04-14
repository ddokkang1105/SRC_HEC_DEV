<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style>

.subrow-changeset-container {
	border: 1px solid #d1d5db;
}

.changeset-description-textarea {
	width: 100%; height: 80px; resize: none;
	overflow-y: auto; padding: 10px; font-size: small;
}

.empty-placeholder {
	color: #9ca3af;
}

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

.changeset-buttons-container {
	width: 100%; padding: 5px 10px; border: 1px solid #d1d5db;
	border-top:0;
	display: flex; justify-content: end; background-color: #f3f3f3;
}

.grid__cell_status-item {
    text-align: center;
    height: 20px;
    width: 70px;
    border-radius: 100px;
    background: rgba(0, 0, 0, 0.05);
    font-size: 14px;
}

.grid__cell_status-item.new{
	background: rgba(2, 136, 209, 0.1);
   	color: #0288D1;
}

.grid__cell_status-item.mod{
	background: rgba(10, 177, 105, 0.1);
   	color: #0ab169;
}
</style>
<script type="text/javascript">

// 전역 변수 설정
var s_itemID = '${s_itemID}';
var languageID = '${sessionScope.loginInfo.sessionCurrLangType}';
var sessionUserId = "${sessionScope.loginInfo.sessionUserId}";
var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
var mainMenu = "${mainMenu}";
var isItemInfo = "${isItemInfo}"


// changeset 서브로우 별 첨부문서 저장용 전역변수. [{changeSetID: 123, files: [파일정보 배열]} , ... ]
var allSubRowFiles = []; 

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
	
	// list load
	reloadItemHistory();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

// csr 상세정보 팝업 띄우는 함수
function openCsrDetailPopup(projectIdParam, parentIdParam){
	var projectID = projectIdParam;
	var parentId = parentIdParam;
	var screenMode ="V";
	
 	var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=" + screenMode + "&s_itemID="+parentId+"&isItemInfo=Y&seletedTreeId="+s_itemID;
	var w = 1200;
	var h = 800;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
 }
 
// [Check Out] click
function checkOutPop() {
	var url = "cngCheckOutPop.do?";
	var data = "s_itemID="+s_itemID;
	window.open(url+data, "", "width=500, height=150, top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}

function handleAjaxError(err, errDicTypeCode) {
	console.error(err);
	Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
			.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
}

// 변경이력 데이터 가져와 그리드에 주입하는 함수
async function reloadItemHistory(){
	
	$('#loading').fadeIn(150);
	
    const requestData = { s_itemID, languageID  };


	 // 필수 파라미터 체크

    for (const [key, value] of Object.entries(requestData)) {
        	 if (value === undefined || value === null || value === "") {
        		  console.error(key+" 가 필요합니다.");
        	 }
        }

	const params = new URLSearchParams(requestData).toString();
    const url = "getChangeSetListInfo.do?" + params;
    //기존 getItemChangeListInfo
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
        
        if(result.data){
            fnReloadGrid(result.data);
            return true;
        } else {
        	throw new Error(`Problem with data occured: ${data}`)
        }
        
    } catch (error) {	
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.    	
    } finally {
    	$('#loading').fadeOut(150);
    }
}

// 서브로우 표시 시 실행, 첨부파일 데이터 가져옴
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
            console.error(data.message || 'Unknown error occurred');
            return [];
        }
        
    } catch (error) {
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
    	return [];
    } finally {
    	$('#loading').fadeOut(150);
    }
}

// 서브로우 내 view changelog 버튼 클릭 시 실행, 변경내역 데이터 가져옴
async function getRevisionListData(s_itemID, languageID, changeSetID) {
	$('#loading').fadeIn(150);
	
    const requestData = { s_itemID, languageID, changeSetID };
    
    const params = new URLSearchParams(requestData).toString();
    const url = "getRevisionCSInfoView.do?" + params;
    
    try {
        const response = await fetch(url, {
            method: 'GET',
        });
        
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(response.statusText, response.status);
		}
        
        const result = await response.json();
       
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}
        
        if(result.data && (Array.isArray(result.data))){
            return result.data;
        } else {
            throw new Error('Unknown error occurred. data.message :', data.message);
        }
        
    } catch (error) {
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
        return [];
    } finally {
    	$('#loading').fadeOut(150);
    }
}

function fnReloadGrid(newGridData){
	grid.data.parse(newGridData);
	$("#TOT_CNT").html(grid.data.getLength());	
	if(pagination){pagination.destructor();}
	if(grid.data.getInitialData().length >= 50) {
		pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 50,
		});
	} 
} 

</script>
<div id="help_content">
	<form name="historyList" id="historyList" action="#" method="post" onsubmit="return false;">
	
		<input type="hidden" id="itemId" name="itemId" value="${itemId}">
		<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}" />
		<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
		<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
		<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />

		<div class="countList flex align-center justify-between">
			<li class="count">Total <span id="TOT_CNT"></span></li>
			<li><span class="btn_pack nobg white"><a
					class="xls" title="Excel" id="excel"></a></span></li>
		</div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</form>
	
	<iframe id="saveFrame" name="saveFrame" style="display:none;"></iframe>
</div>

<script>

//=======================================================================================================================
//====== [ 그리드 내에서 사용되는 함수 정의 ] ===================================================================================
//=======================================================================================================================

// selector 인자로 받은 요소가 DOM 내 렌더링 완료되거나 5초가 지날 때까지 기다리도록 하는 함수
   const waitForElementRender = (selector) => {   
        return new Promise((resolve, reject) => {
        	
            const element = document.getElementById(selector);
            
            if (element) {
                resolve(element);
                return;
            }
            
            const observer = new MutationObserver((mutations, obs) => {
                const element = document.getElementById(selector);
                if (element) {
                    obs.disconnect();
                    resolve(element);
                }
            });
            
            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
            
            setTimeout(() => {
                observer.disconnect();
                reject(new Error(`Element ${selector} not found within timeout`));
            }, 5000);
        });
    };
	
	
/** 서브로우 확장 후 실행되며, 첨부파일 정보를 호출해 붙여줌*/
async function expandSubrowCallback (rowData) {
	const changeSetID = rowData.ChangeSetID;
	
	let fetchedSubRowFiles = []; 

	try {
		
		// 이미 첨부파일 로드해온적 있는 subrow라면, 서버에 로드 요청 X, 이전 데이터 활용
	    if(rowData.attachFilesLoaded) {
	    	const existingIndex = allSubRowFiles.findIndex(item => item.changeSetID === changeSetID);
	    	if (existingIndex !== -1) {
	    		fetchedSubRowFiles = allSubRowFiles[existingIndex].files;
	        } else {
	        	throw new Error("에러 발생 : 서브로우 첨부파일 데이터 로드 이력 존재하나 파일 데이터가 누락되어있음.");
	        }
	    } 
	 	// 첨부파일 로드해온적 없는 subrow라면 서버에 로드 요청
	    else {
	    	fetchedSubRowFiles = await getChangesetFileInfo(s_itemID, languageID, changeSetID)
	    	rowData.attachFilesLoaded = true;
	    }

	    // 중복 체크 후 전역 배열에 파일 데이터 추가 또는 업데이트
	    const existingIndex = allSubRowFiles.findIndex(item => item.changeSetID === changeSetID);
	    if (existingIndex !== -1) {
	        allSubRowFiles[existingIndex].files = fetchedSubRowFiles;
	    } else {
	        allSubRowFiles.push({
	            changeSetID: changeSetID,
	            files: fetchedSubRowFiles
	        });
	    }
	    
	    const filesDiv = await waitForElementRender(`files-\${changeSetID}`);
        
        // 로드해온 데이터에 서브로우에 해당하는 첨부문서 정보가 있다면 첨부문서 컨테이너에 이를 렌더링
	    let filesHTML = `<div class="changeset-files-inner-container" >`;
    
           if (fetchedSubRowFiles.length > 0) {
               // 파일 목록
               filesHTML += `<div style="width:80%; max-height: 120px; overflow-y: auto;">`;
               
               fetchedSubRowFiles.forEach(function(file, idx) {
                   filesHTML += `
                       <div class="changeset-individual-file" onclick="toggleIndividualFileCHK(\${changeSetID}, '\${file.Seq}')">
                           <input type="checkbox" name="attachFileCheck_\${changeSetID}_\${file.Seq}" style="margin-right: 8px;">
                           <span style="cursor: default; color: #2563eb; flex: 1;">\${file.FileRealName}</span>
                       </div>
                   `;
               });
               
               filesHTML += `</div>`; // 파일 목록 끝
        } else {
            filesHTML += `<div class="empty-placeholder">첨부된 파일이 없습니다.</div>`
        }

        filesHTML += `
            <div style="margin-left: 10px; min-width:180px; text-align: right; height: 100%; display: flex; align-items: end;">
                <span class="btn_pack medium icon" style="margin-right: 8px;">
                    <span class="download"></span>
                    <input value="Download All" type="button" onclick="downloadTargetSubrowAllFiles(\${changeSetID})" style="cursor: pointer;">
                </span>
                <span class="btn_pack medium icon">	
                    <span class="download"></span>
                    <input value="Download" type="button" onclick="downloadTargetSubrowSelectedFiles(\${changeSetID})" style="cursor: pointer;">
                </span>
            </div>
        `;
        
        filesHTML += `</div>`;
        
        filesDiv.innerHTML = filesHTML;
		
	} catch (error) {
		handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
	}
}

/** Subrow에서 Download All 버튼 클릭 시, 클릭 발생한 Subrow에 포함된 파일을 changeSetID를 타케팅한 후 전부 다운로드 */
function downloadTargetSubrowAllFiles(changeSetID) {
    // changeSetID에 해당하는 파일 데이터 식별
    const targetChangeSetData = allSubRowFiles.find(item => item.changeSetID === changeSetID);
    
    if (targetChangeSetData && targetChangeSetData.files) {
        if (targetChangeSetData.files.length <= 0) {
      		Promise.all([
    			getDicData("ERRTP", "LN0026"), 
    			getDicData("BTN", "LN0034"), // 닫기
    		]).then(results => {
    			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
    		});
        } else {
        	const seqArr = new Array();

        	targetChangeSetData.files.forEach((file, idx)=> {
        		seqArr.push(file.Seq);
        	})
        	
        	const url  = "fileDownload.do?seq="+seqArr;  	
        	ajaxSubmitNoAdd(document.historyList, url, "saveFrame");	
        }   
    } else {
  		Promise.all([
			getDicData("ERRTP", "LN0014"), 
			getDicData("BTN", "LN0034"), // 닫기
		]).then(results => {
			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
		});
        console.error('해당 changeSetID의 파일 데이터를 찾음. 내부 오류 발생');
        console.error('changeSetID: ', changeSetID);
        console.error('allSubRowFiles: ', allSubRowFiles);
    }
}

/** Subrow에서 Download 버튼 클릭 시, 클릭 발생한 Subrow에 포함된 파일을 changeSetID를 타케팅한 후 CHK 값이 1인 파일들 다운로드 */
function downloadTargetSubrowSelectedFiles(changeSetID) {
    // changeSetID에 해당하는 파일 데이터 식별
    const targetChangeSetData = allSubRowFiles.find(item => item.changeSetID === changeSetID);
    
    if (targetChangeSetData && targetChangeSetData.files) {
        if (targetChangeSetData.files.length <= 0) {
      		Promise.all([
    			getDicData("ERRTP", "LN0026"), 
    			getDicData("BTN", "LN0034"), // 닫기
    		]).then(results => {
    			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
    		});
        } else {
        	const checkedFiles = targetChangeSetData.files.filter((file) => file.CHK == 1);
        	if (checkedFiles.length <= 0 ) {
          		Promise.all([
        			getDicData("ERRTP", "LN0018"), 
        			getDicData("BTN", "LN0034"), // 닫기
        		]).then(results => {
        			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
        		});
        	} else {     	
            	const seqArr = new Array();
            	checkedFiles.forEach((file, idx)=> {
            		seqArr.push(file.Seq);
            	})    	
            	const url  = "fileDownload.do?seq="+seqArr;  	
            	ajaxSubmitNoAdd(document.historyList, url, "saveFrame");
        	}
        }   
    } else {
  		Promise.all([
			getDicData("ERRTP", "LN0014"), 
			getDicData("BTN", "LN0034"), // 닫기
		]).then(results => {
			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
		});
        console.error('해당 changeSetID의 파일 데이터를 찾았으나 내부 오류 발생');
        console.error('changeSetID: ', changeSetID);
        console.error('allSubRowFiles: ', allSubRowFiles);
    }
}

/** Subrow 내 첨부파일 클릭 시 전역변수에 저장된 첨부파일 저장소 내 해당 첨부파일의 CHK 값 토글 */
function toggleIndividualFileCHK(changeSetID, fileSeq) {
	// allSubRowFiles에서 클릭된 파일이 속한 subrow에 해당하는 changeSet 찾기
    const targetChangeSet = allSubRowFiles.find(item => item.changeSetID === changeSetID);
    if (!targetChangeSet || !targetChangeSet.files) {
  		Promise.all([
			getDicData("ERRTP", "LN0014"), 
			getDicData("BTN", "LN0034"), // 닫기
		]).then(results => {
			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
		});
    	console.error("오류 발생: 클릭한 파일에 해당하는 changeSetID가 allSubRowFiles에 존재하지 않음.");
        return;
    }
    
    // 타겟 changeSet의 files 배열에서 인자로 받은 seq에 해당하는 파일 찾기
    const targetFile = targetChangeSet.files.find(file => file.Seq == fileSeq);
    if (!targetFile) {
  		Promise.all([
			getDicData("ERRTP", "LN0014"), 
			getDicData("BTN", "LN0034"), // 닫기
		]).then(results => {
			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
		});
  		console.error("오류 발생: 클릭한 파일이 changeSet 데이터 내에 존재하지 않습니다.");
        return;
    }
   
    // 3. CHK 값 토글 (0 ↔ 1)
    targetFile.CHK = targetFile.CHK === 1 ? 0 : 1;

    // 4. 체크박스 UI도 동기화 보강
    const checkbox = document.querySelector(`input[name="attachFileCheck_\${changeSetID}_\${fileSeq}"]`);
    if (checkbox) {	
        checkbox.checked = targetFile.CHK === 1;
    }
}

/** Subrow에서 View Changelog 버튼 클릭 시, 클릭 발생한 Subrow에 해당하는 변경이력 데이터 가져온 후 dhx 모달을 열어 붙여줌 */
function openChangelogModal (changeSetID, itemName, versionText, changeType, changeStatus) {
	const htmlString = `
		<div style="width:100%; height: 100%; overflow-y: auto;" id="changeLogModal">
			<div id="\${changeSetID}-layout"></div>
		</div>`;
		
	const title= "" + itemName + " " + "[" +versionText + "] " + " - " + changeType + " / " + changeStatus + "";
	
	async function openModalCallback (s_itemID, languageID, changeSetID) {

		const res = await getRevisionListData(s_itemID, languageID, changeSetID);
		

        const finalData = Array.isArray(res) && res.length > 0 ? res : [];
		
		const getElementTargetId = changeSetID + "-layout";
		const layoutDiv = document.getElementById(getElementTargetId);
		
		if (!layoutDiv) return;

	    // 기존 내용 비우기
	    layoutDiv.innerHTML = "";
	    
		if (layoutDiv) {
			const layout = new dhx.Layout(getElementTargetId, {
			    cols: [
			        {
			        	id: "a"
			        },
			    ]
			});
		    
		    //  데이터 없을 때
		    if (finalData.length === 0) {

		        showEmptyDataPage("#changeLogModal");
		    
		        return;
		    }
		    
			const modalGrid =  new dhx.Grid("modalGrid", {
			    columns: [
			    	{ width: 80, id: "ItemID", header: [{ text: "ID", align:"center" }], align:"center" },
			    	{ width: 160, id: "ItemName", header: [{ text: "명칭", align:"center" }], align:"center" },
			    	{ width: 120, id: "ClassName", header: [{ text: "클래스", align:"center" }], align:"center" },
			    	{ id: "Description", header: [{ text: "변경개요", align:"center" }], align:"center" },
		    	],
		    	autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    height: "auto",
			    data: finalData
			})
			layout.getCell("a").attach(modalGrid);
		}	
	}
	openHtmlWithDhxModal(htmlString, title, 900, 480, () => openModalCallback(s_itemID, languageID, changeSetID));
}

/** subRow의 결재문서 아이콘 클릭 시 실행되는 결재 문서 상세정보 모달 여는 함수 */
function openAprvDetailPopup(wfURL, WFInstanceID, ChangeSetID, ProjectID, ItemClassCode) {
	var url =  wfURL + ".do";
	var data = "wfInstanceID=" + WFInstanceID + "&actionType=view&changeSetID=" + ChangeSetID + "&isMulti=N&wfDocType=CS&projectID=" + ProjectID + "&docSubClass=" + ItemClassCode;
	var w = 900;
	var h = 530;
	openUrlWithDhxModal(url, data, title="", w, h)
}

/** subRow의 "view version item" 버튼 클릭 시 실행되는 버전아이템 조회 모달 여는 함수 */
function openVersionItemModal(itemdId, changeSetID, projectID, authorID, status, version ) {
	var url = "viewVersionItemInfo.do?s_itemID="+s_itemID
				+"&changeSetID="+changeSetID
				+"&projectID="+projectID
				+"&authorID="+authorID
				+"&status="+status
				+"&version="+version;	
	openUrlWithDhxModal(url);
}

/** subRow의 "view current item" 버튼 클릭 시 실행되는 현재 버전 아이템 조회 모달 여는 함수 */
function goItemPopUpNoID() {
	var url = "popupMasterItem.do?languageID="+ languageID + "&id="+s_itemID+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,"${getData.ItemID}");
}

//empty page 생성  
var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CCCCCC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 6H11"/><path d="M21 12H11"/><path d="M21 18H11"/><path d="M3 6h2"/><path d="M3 12h2"/><path d="M3 18h2"/><path d="M5 6v12"/></svg>';

function showEmptyDataPage(targetSelector = "#layout") {


    const elements = document.querySelectorAll('.empty-wrapper.btns');
    if (elements.length > 0) return;

    getDicData("ERRTP", "LN0042").then((errtp042) => {
        document.querySelector(targetSelector).insertAdjacentHTML(
            "beforeEnd",
            emptyPage(emptyIcon, errtp042.LABEL_NM, "", "", "", "")
        );
    });
}

// =======================================================================================================================
// ====== [ 그리드 설정 ] ===================================================================================================
// =======================================================================================================================
	
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});

var grid;
var pagination;

var grid = new dhx.Grid("grid",  {
    columns: [
        { width: 80, id: "Version", header: [{ text: "Version", align:"center"}], align:"center"},
        { width: 120, id: "ChangeTypeCode", header: [{ text: "${menu.LN00022}", align:"center" }], align:"center", htmlEnable: true,
        	template: function (text, row, col) {
        		var result = "";
        		 switch (text) {
         			case "DEL" : result = '<span class="grid__cell_status-item">'+row.ChangeType; break;
         			case "MOD" : result = '<span class="grid__cell_status-item mod">'+row.ChangeType; break;
         			case "NEW" : result = '<span class="grid__cell_status-item new">'+row.ChangeType; break;
         			default : result = "";
     			}
        		return result ;
         	}
        },
        { id: "RequestUserName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
        { id: "RequestDate", header: [{text: "${menu.LN00063}", align:"center"}], align:"center"},
        { id: "CompletionDate", header: [{ text: "${menu.LN00070}", align:"center"}], align:"center"},
        { id: "ApproveDate", header: [{ text: "${menu.LN00095}", align:"center" }], align:"center" },
        { id: "ValidFromDate", header: [{ text: "${menu.LN00296}", align:"center"}], align:"center"},
        { id: "ChangeStsCode", header: [{ text: "${menu.LN00027}", align:"center"}], htmlEnable: true, align: "center",
        	template: function (text, row, col) {
        		var result = "";
                switch (text) {
        			case "MOD" : result = '<span class="grid__cell_status-item new">'+row.ChangeSts; break;
        			case "CLS" : result = '<span class="grid__cell_status-item">'+row.ChangeSts; break;
        			default : result = '<span class="grid__cell_status-item mod">'+row.ChangeSts;
    			}
        		if(row?.Info?.WFStatusName) result += `(\${row.Info.WFStatusName})`;
                result += '</span>'
        		return result ;
         }},
         { id: "", header: [{ text: "${menu.ZLN0017}", align:"center"}], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		let txt = `-`;
                       if(row?.Info?.WFInstanceID) txt = `<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" class="cur-po" onclick="openAprvDetailPopup('\${row.wfURL}', '\${row.Info.WFInstanceID}', '\${row.Info.ChangeSetID}', '\${row.Info.ProjectID}', '\${row.Info.ItemClassCode}')"><path d="m692-156 130-135-35-33-96.29 99L652-264l-34 34 74 74ZM288-576h384v-72H288v72ZM719.77-48Q640-48 584-104.23q-56-56.22-56-136Q528-320 584.23-376q56.22-56 136-56Q800-432 856-375.77q56 56.22 56 136Q912-160 855.77-104q-56.22 56-136 56ZM144-96v-648q0-29.7 21.15-50.85Q186.3-816 216-816h528q29.7 0 50.85 21.15Q816-773.7 816-744v259q-17-7-35.03-11-18.04-4-36.97-6v-242H216v528h240q3 30 12.12 58T492-105l-12 9-56-45-56 45-56-45-56 45-56-45-56 45Zm144-216h177q5-20 13.5-37.5T498-384H288v72Zm0-132h264q26-21 56-35t64-20v-17H288v72Zm-72 228v-528 528Z"/></svg>`;
	        		return txt;
	         }},
        { hidden: true, id: "ProjectName", header: [{ text: "${menu.LN00131}", align:"center" }], align: "left"},
        { hidden:true, id: "ChangeSetID", header: [{ text: "ChangeSetID", align:"center"}], align:"center"},
    ],
    subRowConfig: {
        height:280, padding: 20, toggleIcon: true,
    },
    subRow: (row) => {
        if(row) {        	
            const changeSetID = row.ChangeSetID;
            const versionText = row.Version; // "3.0 등"
            const itemName = row.ItemName; 
            const changeType = row.ChangeType; // "개정", "제정" 등
            const changeStatus = row.ChangeSts; // "편집 중", "릴리즈" 등
            const projectID = row.ProjectID;
            const itemID = row.ItemID;
            const authorID = row.Info.AuthorID;
            const status = row.Info.StatusCode;
 
            const descriptionYN = row.Info?.Description ? true : false;
            const description = row.Info?.Description || '작성된 변경이력 내역이 없습니다.';
            
            const lastChangeSet = row.lastChangeSet // "Y" or "N"
            
            const versionItemInputHtml = lastChangeSet == "N" ? 
            		`<input value="View Version Item" onclick="openVersionItemModal('\${itemID}', '\${changeSetID}', '\${projectID}', '\${authorID}', '\${status}', '\${versionText}' )" type="submit">`
            		: `<input value="View Current Item" onclick="goItemPopUpNoID()" type="submit">`;
            
            return `
                <div id="subrow-\${changeSetID}" class="subrow-changeset-container">
                	<textarea id="description-\${changeSetID}" name="description" readOnly class="changeset-description-textarea \${descriptionYN ? '' : 'empty-placeholder'}">\${description}</textarea>
                    <div id="files-\${changeSetID}" class="changeset-files-outer-container">Loading...</div>
                </div>
                   <div class="changeset-buttons-container">
               	<span class="btn_pack medium icon">
               		<span class="confirm"></span>
              			<input
              				value="View Changelog"
              				onclick="openChangelogModal(\${changeSetID}, '\${itemName}', '\${versionText}', '\${changeType}', '\${changeStatus}' )"
              				type="submit" >
              		</span>
              		<span class="btn_pack medium icon">
            		<span class="confirm"></span>`
            		+ versionItemInputHtml +
           		`</span>
               	</div>
            `;
        }
    },
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    height: "auto",
});

grid.events.on("afterExpand", function(rowId) {
    const rowData = grid.data.getItem(rowId);
    expandSubrowCallback(rowData);
});

grid.events.on("filterChange", function(row,column,e,item){
	$("#TOT_CNT").html(grid.data.getLength());
});

layout.getCell("a").attach(grid);
</script>