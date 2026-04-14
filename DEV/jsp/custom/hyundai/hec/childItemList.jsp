<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00055" var="WM00055"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00056" var="WM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00057" var="WM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00058" var="WM00058"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00059" var="WM00059"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00060" var="WM00060"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00040" var="CM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00122" var="WM00122" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116_1" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>

<script>

//---------------------------------------------------------
//[공통 사용 변수] ::
//---------------------------------------------------------
var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
var AuthorID = `${sessionScope.loginInfo.sessionUserId}`;
var s_itemID = `${s_itemID}`;
var accMode = `${accMode}`;
var option = `${option}`;
var defDimTypeID = `${defDimTypeID}`;
var defDimValueID = `${defDimValueID}`;
var showTOJ = `${showTOJ}`;
var showElement = `${showElement}`;
var sessionParamSubItems = `${sessionParamSubItems}`;

$(document).ready(function(){
	
	// 1. 초기 표시 화면 크기 조정 및 화면 크기 변경에 따른 layout 높이 조정 
	$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");
	};
	
	// 2. [button] 설정
	$("#excel").click(function(){ fnGridExcelDownLoad(); });
	setFnUpdateChilidItemOrder(); // [Eidt Order] 버튼 셋팅
	
	// 3. [grid] load
	renderChildItemList();
	
});

//---------------------------------------------------------
//[CALLBACK] START ::
//---------------------------------------------------------

function fnCallBack(){doTcSearchList();}
function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function urlReload() {renderChildItemList();}
function fnReload() {renderChildItemList();}//항목 이동 후 callback

//---------------------------------------------------------
//[CALLBACK] END ::
//---------------------------------------------------------

//---------------------------------------------------------
//[BUTTON] START ::
//---------------------------------------------------------

/**
* @function setFnUpdateChilidItemOrder
* @description [Eidt Order] 버튼 조건을 확인하고 html 렌더링 합니다.
*/
async function setFnUpdateChilidItemOrder(){
	
	const sortOption = await loadSortOption();
	const TreeDataFiltered = await loadTreeDataFiltered();
	
	const btnContainer = document.getElementById('updateChildIdItemOrderBtn');
    if (!btnContainer) return;
    
	if(sortOption == '1' && TreeDataFiltered == 'N'){
		
		btnContainer.style.display = 'inline-block';
		btnContainer.innerHTML = '';
		
		const link = document.createElement('a');
        link.className = 'updown';
        link.title = 'Edit Order';
        link.setAttribute('onclick', 'fnUpdateChilidItemOrder()');
		
        btnContainer.appendChild(link);
        
	} else {
		btnContainer.style.display = 'none';
        btnContainer.innerHTML = '';
	}
	
}

/**
* @function deleteItem
* @description [Delete] 버튼을 클릭하면 선택한 아이템을 삭제합니다.
*/
function deleteItem(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	
	// a. 항목을 한개 이상 선택하여 주십시요.
	if(!selectedCell.length){
		Promise.all([
			getDicData("BTN", "LN0034") // 닫기
		]).then(results => {
			showDhxAlert('${WM00023}', results[0].LABEL_NM);
		});
		return false;
	}
	
	// 선택된 항목을 삭제하시겠습니까?
	Promise.all([
		getDicData("BTN", "LN0032"), // 확인
		getDicData("BTN", "LN0033")  // 취소
	]).then(results => {
		showDhxConfirm("${CM00004}", () => executeDelete(selectedCell), null, results[0].LABEL_NM, results[1].LABEL_NM);
	});
	
}

/**
* @function validateDeleteItem
* @param {item} 삭제할 아이템
* @description 삭제를 원하는 아이템의 삭제 가능 여부를 체크합니다.
*/
function validateDeleteItem(item) {
    let errorMsg = "";

    if (item.Blocked != "0") {
        errorMsg = (item.ItemStatus == "REL") ? "${WM00121}" : "${WM00054}"; // a.CSR에 등록 안된 항목이므로 삭제할 수 없습니다. || 릴리즈 대기 중이므로 삭제할 수 없습니다.
    } else if (item.GUBUN == "O") {
        errorMsg = " - ${WM00052}"; // b. 모델에서 사용된 Element 입니다. 모델에서 해당 Element를 삭제하십시요.
    } else if (item.ChangeMgt == "1" && (item.Status == "MOD1" || item.Status == "DEL1")) {
        errorMsg = " ${WM00046}"; // c. 선택할 수 없는 항목 입니다. ( 변경중 or 삭제예정 )
    } else if (item.SCOUNT != 0) {
        errorMsg = " - ${WM00024}"; //d. 하위항목이 있으므로 삭제할 수 없습니다.
    }

    if (errorMsg) {
        getDicData("BTN", "LN0034").then(res => {
            showDhxAlert(item.ItemName + errorMsg, res.LABEL_NM);
        });
        grid.data.update(item.id, { "checkbox": false });
        return false;
    }
    return true;
}

/**
* @function executeDelete
* @param {selectedCell} 삭제할 아이템
* @description delete api를 호출하여 아이템을 삭제합니다.
*/
function executeDelete(selectedCell){
	
	const deleteIds = [];

    for (const cell of selectedCell) {
        if (!validateDeleteItem(cell)) return;
        deleteIds.push(cell.ItemID);
    }

    if (deleteIds.length > 0) {
    	deleteItemAPI(deleteIds);
    }
	
}

var itemTreePop;
/**
* @function setSubDiv
* @param {avg} 팝업 유형
* @param {avg2} 팝업 오픈 시 숨김처리 할 div
* @description 아이템을 이동하는 팝업을 호출합니다.
*/
function setSubDiv(avg, avg2){	
	$("#"+avg2).attr('style', 'display: none');
	$("#"+avg).removeAttr('style', 'display: none');	
	
	if(avg == 'MoveItem'){/*Move*/
		var items = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00057}");
			return false;
		}
	
		for(idx in selectedCell){
			if(selectedCell[idx].GUBUN == "O" || selectedCell[idx].GUGUN == "o"){
				alert(selectedCell[idx].ItemName + "${WM00059}");
				return false;
			}else{
				items.push(selectedCell[idx].ItemID);
			}
		};
			
		if (items != "") {
			var url = "itemTreePop.do";
			var data = "items=" + items + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
// 			fnOpenLayerPopup(url,data,doCallBackMove,617,436);
			itemTreePop = openUrlWithDhxModal(url, data, "Select Tree" , 617, 436)
		}
	}
}

/**
* @function fnMoveItems
* @param {avg} 이동할 itemID
* @param {isCheck}
* @description 아이템을 이동을 처리합니다.
*/
var tranSearchCheck = false;
function fnMoveItems(avg, isCheck){
	if(isCheck == "false") {
		alert("${WM00060}");
		return;
	}
	
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	
	if(!selectedCell.length){
		alert("${WM00023}");
		return;
	}else{		
		if('${s_itemID}'==avg){
			alert("${WM00055}");
			return;
		}
		if(confirm("${CM00040}")){
			var items = new Array();
			for(idx in selectedCell){
				if(selectedCell[idx].ItemID == avg){
					alert("${WM00056}");
					return;
				}
				items.push(selectedCell[idx].ItemID);
			};
			
			if(items != ""){
				var url = "changeItemParent.do";
				var data = "s_itemID=${s_itemID}&items="+items+"&fromItemID="+avg;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
// 			$(".popup_div").hide();
// 			$("#mask").hide();
			itemTreePop.hide();
		}		
	}
}

/**
* @function newItemInsert
* @param {addYN} Save and Add 버튼 클릭 여부
* @description 아이템을 생성합니다.
*/
function newItemInsert(addYN){
	// 입력 필수 체크 : 계층, 명칭, CSR 입력 필수
	if($("#newClassCode").val() == ""){alert("${WM00041_1}");$("#newClassCode").focus();return false;}
	if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
	if($("#csrInfo").val() == ""){alert("${WM00041_2}");$("#csrInfo").focus();return false;}
	var newItemName = encodeURIComponent($("#newItemName").val());
	//if(confirm("신규 정보를 생성 하시겠습니까?")){		
	if(confirm("${CM00009}")){		
		var url = "createItem.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&newClassCode="+$("#newClassCode").val()
					+"&newIdentifier="+$("#newIdentifier").val()
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&AuthorName="+$("#AuthorName").val()
					+"&newItemName="+newItemName
					+"&csrInfo="+$("#csrInfo").val()
					+"&dimTypeID="+$("#dimTypeID").val()
					+"&dimTypeValueID="+$("#dimTypeValueID").val()
					+"&addYN="+addYN
					+"&autoID="+$("#autoID").val()
					+"&preFix="+$("#preFix").val();
					
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}

/**
* @function doReturnInsert
* @param {classCode} 아이템의 classCode
* @param {addYN} Save and Add 버튼 클릭 여부
* @description 아이템 생성 후 생성 화면을 초기화 합니다.
*/
function doReturnInsert(classCode,addYN){
	setTimeout(function() {urlReload();}, 2000);
	if(addYN == "Y"){
		$("#newClassCode").val(classCode);
		$("#newIdentifier").val("");
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');
		$("#newItemName").val("");
	}else{
		$("#newClassCode").val("");$("#newIdentifier").val("");
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');
		$("#newItemName").val("");
		$("#csrInfo").val("");
		
		if(dhxModal) {
	    	dhxModal.destructor();  
	    	dhxModal = null;
	    }
	}
	
	$("#newIdentifier").attr('disabled',false);
	$("#preFix").val("");
}

/**
* @function editMulitiItemID
* @description Edit ID/Name 버튼을 클릭 시 아이템의 ID와 Name을 일괄편집 하는 팝업창을 호출합니다.
*/
function editMulitiItemID(){
	
	    var url = "editItemIDNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("", "SelectOwner", option);
	    document.processList.action=url;
	    document.processList.target="SelectOwner";
	    document.processList.submit();
}
/**
* @function editCheckedAllItems
* @param {avg} 팝업 타입
* @description 타입 파라미터에 따라 아이템 정보를 편집하는 팝업창을 호출합니다. 
*/
function editCheckedAllItems(avg){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	if(!selectedCell.length){
		alert("${WM00023}");
		return false;
	}
	var items = new Array();	
	var classCodes = new Array();
	for(idx in selectedCell){
		items.push(selectedCell[idx].ItemID);
	  	classCodes.push(selectedCell[idx].ClassCode);
	};
	
	if (items != "") {
		$("#items").val(items);
		if (avg == "Attribute2") {
			var url = "selectAttributePop.do";
			var data = "items="+items+"&classCodes="+classCodes; 
		    var option = "dialogWidth:400px; dialogHeight:250px;";
		    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
			$("#classCodes").val(classCodes);
		    document.processList.action=url;
		    document.processList.target="selectAttribute2";
		    document.processList.submit();
		    
		}else if (avg == "Attribute") {
			var url = "selectAttributePop.do";
			var data = "classCodes="+classCodes+"&items="+items; 
		    var option = "dialogWidth:400px; dialogHeight:250px;";		
		   
		    var w = "400";
			var h = "350";
			$("#classCodes").val(classCodes);
		    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		    document.processList.action=url;
		    document.processList.target="selectAttribute";
		    document.processList.submit();
			    
		} else  if (avg == "Owner") {			    
		    var url = "selectOwnerPop.do"; 
		    var option = "width=550, height=350, left=300, top=300,scrollbar=yes,resizble=0";
		    window.open("", "SelectOwner", option);
		    document.processList.action=url;
		    document.processList.target="SelectOwner";
		    document.processList.submit();
		} 
	 }
}

/**
* @function goSearchList
* @description 상세검색 팝업창을 호출합니다.
*/
function goSearchList() {
	var url = "itemListMgt.do";
	var data = "?s_itemID=${s_itemID}&menucat=middle&option=${option}&pop=Y&accMode=${accMode}&itemListPage=/itm/search/searchListV4";
	
	var w = window.screen.availWidth;
	var h = window.screen.availHeight;
	
	window.open(url+data, "", "width="+w+", height="+h+", top=0,left=0,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	
}

/**
* @function fnGetDimTypeValue
* @param {dimTypeID} 
* @description 아이템 신규 생성 시
*/
function fnGetDimTypeValue(dimTypeID){
	var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
	fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');	
}

// [hasDimension 확인 후 fnSetDimension 호출]
function fnGetHasDimension(classCode){ 
	var url = "getHasDimension.do";
	var data = "itemClassCode="+classCode;
	var target = "blankFrame";
	ajaxPage(url, data, target);
}

function fnSetDimension(hasDimension, autoID, preFix){ 
	if(hasDimension == "1"){
		$("#dimensionRow").attr('style', 'display:flex;');
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
	}else{
		$("#dimensionRow").attr('style', 'display:none;');
	}
	
	if(autoID == "Y"){
		$("#newIdentifier").attr('disabled',true);
		$("#newIdentifier").val("");
		$("#autoID").val(autoID);
		$("#preFix").val(preFix);
	}else{
		$("#newIdentifier").attr('disabled',false);
		$("#autoID").val(autoID);
		$("#preFix").val("");
	}
}

function fnUpdateChilidItemOrder(){
	var sqlKey = "item_SQL.getChildItemList";
	var url = "childItemOrderList.do?s_itemID=${s_itemID}&sqlKey="+sqlKey;
	var w = 500;
	var h = 500;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");

}

var identifier = "";
var itemName = "";

// [Copy Item] Save
function fnCopyItemInfo(){
	var cpIdentifier = $("#cpIdentifier").val();
	var cpItemName = $("#cpItemName").val();
	var cpCsrInfo = $("#cpCsrInfo").val();
	
	if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
	if(cpCsrInfo == ""){alert("${WM00041_2}");$("#cpCsrInfo").focus();return false;}
	
	if(cpIdentifier == identifier){ alert("${WM00116_1}"); return;}
	if(confirm("${CM00009}")){		
		var url = "createItem.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&newClassCode="+$("#cpClassCode").val()
					+"&newIdentifier="+cpIdentifier
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&AuthorName="+$("#AuthorName").val()
					+"&newItemName="+cpItemName
					+"&csrInfo="+cpCsrInfo				
					+"&addYN="
					+"&autoID="+$("#autoID").val()
					+"&preFix="+$("#preFix").val()
					+"&cpItemID="+$("#cpItemID").val()
					+"&refItemID="+$("#cpItemID").val()
					+"&modelID="+$("#modelID").val()
					+"&checkElmts="+$("#checkElmts").val()
					+"&newModelName="+$("#newModelName").val()
					+"&MTCTypeCode="+$("#MTCTypeCode").val()
					+"&ModelTypeCode="+$("#ModelTypeCode").val()
					+"&elmCopyOption=ref"
					+"&mstSTR=Y";
		
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}

// [Copy Item] Model Select 설정 후 Event
$("#modelID").change(function() {
	var modelID = $(this).val();
	if(modelID == ""){return;}
	var itemTypeCode = $("#cpItemTypeCode").val();
	
	var url = "openReferenceModelPop.do?ItemTypeCode="+itemTypeCode+"&modelID="+modelID; 
	var w = 500;
	var h = 400;
	itmInfoPopup(url,w,h);
	
});

// [Add] 버튼 ( * addOption이 01인 경우 )
function fnRegisterItem(){
	let url = "registerItem.do";	
	let data = "&s_itemID=${s_itemID}&classCode=${classCode}&fltpCode=${fltpCode}&dimTypeList=${dimTypeList}";	
	let target = "processListDiv";
	ajaxPage(url, data, target);
}

//---------------------------------------------------------
//[BUTTON] END ::
//---------------------------------------------------------

//---------------------------------------------------------
//[Auth] START ::
//---------------------------------------------------------

// 아이템 AccCtrl 권한 체크 (파일 조회용)
function fnCheckItemArrayAccRight(itemIDs){
	$.ajax({
		url: "checkItemArrayAccRight.do",
		type: 'post',
		data: "&itemIDs="+itemIDs,
		error: function(xhr, status, error) { 
		},
		success: function(data){	
			data = data.replace("<script>","").replace(";<\/script>","");		
			fnCheckAccCtrlFilePopOpen(data,itemIDs);
		}
	});	
}
function fnCheckAccCtrlFilePopOpen(data,itemIDs){
	var dataArray = data.split(",");
	var accRight = dataArray[0];
	var fileName = dataArray[1];
	
	if(accRight == "Y"){
		var url = "selectFilePop.do";
		var data = "?s_itemID="+itemIDs; 
	   
	    var w = "400";
		var h = "350";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}else{			
		alert("${WM00033}"); return;
	}
}

//---------------------------------------------------------
//[Auth] END ::
//---------------------------------------------------------

//---------------------------------------------------------
//[API] START ::
//---------------------------------------------------------

// [getItemTypeCode] 자동 검색 조회 api
async function loadAutoComplete() {
	const sqlID = 'item_SQL.getItemTypeCode'; 
	const sqlGridList = 'N';
    const requestData = { s_itemID, sqlID, sqlGridList };
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
			const itemTypeCode = result.data.itemTypeCode;
	    	autoComplete("newItemName", "AT00001", itemTypeCode, "", "", 5, "top");
		} else {
			return;
		}

	} catch (error) {
		handleAjaxError(error);
	}
   
}

// [하위항목] 조회 및 grid 셋팅
async function renderChildItemList() {
	
	const searchKey = $("#searchKey").val();
   	let searchValue = $("#searchValue1").val();
   	searchValue = encodeURIComponent(searchValue);
   	
   	const TreeDataFiltered = await loadTreeDataFiltered();
   	
	const requestData = { listType : 'child', languageID, s_itemID, option, TreeDataFiltered, defDimTypeID, defDimValueID, searchKey, searchValue, showTOJ, showElement, accMode, sessionParamSubItems };
    const url = "zhec_getItemListInfo.do";

    try {
    	const response = await fetch(url, { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams(requestData).toString()
        });
		
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
			
			if(pagination) pagination.destructor();
			
			// empty page
			if(result.data.length === 0){
				
				showEmptyDataPage(); // empty page 호출
	            grid.data.parse([]);
	            $("#TOT_CNT").html("0");
	            
			} else {
				
				deleteEmptyDataPageAndPrepareLayout(); // empty page 삭제
				grid.data.parse(result.data.map(r => ({...r, checkbox: false}))); // check 해제
		 		$("#TOT_CNT").html(grid.data.getLength());
		 		pagination = new dhx.Pagination("pagination", {
		 		    data: grid.data,
		 		    pageSize: 50,
		 		});
		 		
			}
			
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

// [treeDataFiltered] 조회 api
async function loadTreeDataFiltered() {
	const sqlID = 'menu_SQL.selectArcTreeDataFiltered'; 
	const sqlGridList = 'N';
	const SelectMenuId = option;
	
    const requestData = { SelectMenuId, sqlID, sqlGridList };
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
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}

}

//[class option] 조회 api
async function renderClassOptions() {
	const sqlID = 'item_SQL.getClassOption'; 
	const sqlGridList = 'N';
    const requestData = { s_itemID, languageID, option, sqlID, sqlGridList };
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
			
			makeSelectOption('newClassCode', result.data, 'ItemClassCode', 'NAME');
	        
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

// [csr option] 조회 api [ *option : N = 신규생성용 / C = 복사용 ]
async function renderCsrOptions(option) {
	const sqlID = 'project_SQL.getCsrListWithMember'; 
	const sqlGridList = 'N';
    const requestData = { AuthorID, languageID, sqlID, sqlGridList };
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
			
			if(option === 'N') makeSelectOption('csrInfo', result.data); // [new]
			else if(option === 'C') makeSelectOption('cpCsrInfo', result.data); // [copy]
	        
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

// [sort option] 조회 api
async function loadSortOption() {
	const sqlID = 'menu_SQL.getArcSortOption'; 
	const sqlGridList = 'N';
	const arcCode = option;
	
    const requestData = { arcCode, sqlID, sqlGridList };
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
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

//[Delete] 아이템 삭제 처리 api
async function deleteItemAPI(deleteIds) {
	    
	const url = 'setItemStatusForDelApi.do';
	const stringItems = deleteIds.map(id => String(id));
	
	const requestData = {
        items: stringItems,
        sessionUserId: AuthorID
    };
    
    try {
    	const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData) 
        });
        
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(response.statusText, response.status);
		}

        const result = await response.json();
        
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}
        
		Promise.all([
			getDicData("ERRTP", "LN0041"), // 삭제되었습니다.
			getDicData("BTN", "LN0034"), // 닫기
		]).then(results => {
			urlReload();
			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
		});
        
    } catch (error) {
    	handleAjaxError(error, "LN0014");
    }
    
}

//---------------------------------------------------------
//[API] END ::
//---------------------------------------------------------

//---------------------------------------------------------
//[UI] START ::
//---------------------------------------------------------

// 화면 높이 조절
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

// empty page 생성  
var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CCCCCC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 6H11"/><path d="M21 12H11"/><path d="M21 18H11"/><path d="M3 6h2"/><path d="M3 12h2"/><path d="M3 18h2"/><path d="M5 6v12"/></svg>';
function showEmptyDataPage() {
	$("#layout").attr("style","height:0px; width:100%;");
    
	let buttonFunc = "";
	let buttonTitle = "";
	let buttonStyle = "";
	
	const elements = document.querySelectorAll('.empty-wrapper.btns');
	
	if(elements.length > 0) return;
	
	if ("${pop}" !== 'pop' && "${sessionScope.loginInfo.sessionLogintype}" === 'editor' && "${myItem}" === 'Y' && "${blocked}" !== 'Y') {
		
		buttonFunc = "showAddChildItemDhxModal()";
		if("${addOption}" === '01') buttonFunc = "fnRegisterItem()";
		
		Promise.all([getDicData("ERRTP", "LN0042"), getDicData("BTN", "LN0026")])
		.then(([errtp042, btn026])=>{
			document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, '하위항목을 등록하세요.', buttonFunc, btn026.LABEL_NM));
		})
		} else {
		Promise.all([getDicData("ERRTP", "LN0042")])
		.then(([errtp042])=>{
			document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, "", "", "", ""));
		})
	}
}

// empty page 제거
function deleteEmptyDataPageAndPrepareLayout(){
	const elements = document.querySelectorAll('.empty-wrapper.btns');
	elements.forEach(el => el.remove());
	$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");
}

//---------------------------------------------------------
//[UI] END ::
//---------------------------------------------------------


//---------------------------------------------------------
//[COMMON] START :: 공통 function
//---------------------------------------------------------

/**
* @function makeSelectOption
* @param {String} select의 id값
* @param {Array} select의 옵션을 만들 data 
* @param {String} codeKey 불러온 data의 코드의 키 값
* @param {String} nameKey 불러온 data의 네임의 키 값
* @description id로 특정 select 를 찾아 option을 받은 data를 기준으로 추가합니다.
*/
function makeSelectOption(id, data, codeKey = 'CODE', nameKey = 'NAME'){
	const selectElement = document.getElementById(id);
  selectElement.innerHTML = '<option value="">Select</option>';
  
  if (!data) return;
  
  data.forEach(item => {
      const option = document.createElement('option');
      option.value = item[codeKey];
      option.textContent = item[nameKey];  
      selectElement.appendChild(option);
  });
}

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

//---------------------------------------------------------
//[COMMON] END :: 
//---------------------------------------------------------
 
 
</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="itemID" name="itemID">
	<input type="hidden" id="ItemID" name="ItemID">
	<input type="hidden" id="checkIdentifierID" name="checkIdentifierID">
	<input type="hidden" id="itemDelCheck" name="itemDelCheck" value="N">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="level" name="level" value="${request.level}">
	<input type="hidden" id="Auth" name="Auth" value="${sessionScope.loginInfo.sessionLogintype}">	
	<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
		<input type="hidden" id="showBlocked" name="showBlocked" value="Y">	
	</c:if>
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}">	
	<input type="hidden" id="AuthorSID" name="AuthorSID" value="${sessionScope.loginInfo.sessionUserId}">	
	<input type="hidden" id="AuthorName" name="AuthorName" value="${sessionScope.loginInfo.sessionUserNm}">	
	<input type="hidden" id="fromItemID" name="fromItemID" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="autoID" name="autoID" >
	<input type="hidden" id="preFix" name="preFix" >
	
	<input type="hidden" id="checkElmts" name="checkElmts" >
	<input type="hidden" id="newModelName" name="newModelName" >
	<input type="hidden" id="MTCTypeCode" name="MTCTypeCode" >
	<input type="hidden" id="ModelTypeCode" name="ModelTypeCode" >
	<div id="subItemListDiv" name="subItemListDiv">		
        <ul class="countList flex align-center justify-between">
            <li class="count">
            	Total  <span id="TOT_CNT"></span>
	            <c:if test="${accMode != 'OPS'}">
					<div class="btns mgL5" style="display:inline-block;"><button class="secondary" onclick="goSearchList();">Search</button></div>
				</c:if>
            </li>
			<li>
				<c:if test="${pop != 'pop'}">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
							<c:if test="${blocked != 'Y'}">
								<span class="btn_pack nobg white"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span>
								 <c:choose>
							   		<c:when test="${addOption eq '01'}" >
							   			<span class="btn_pack nobg"><a class="add"onclick="fnRegisterItem()" title="Register Item"></a></span>
							   		</c:when>
							   		<c:otherwise>
							   			<!-- <span class="btn_pack nobg"><a class="add"onclick="setSubDiv('addNewItem','addNewItem')" title="Add"></a></span> -->
							   			<span class="btn_pack nobg"><a class="add"onclick="showAddChildItemDhxModal()" title="Add"></a></span>
							   		</c:otherwise>
						   		</c:choose>
						   		<span class="btn_pack nobg"><a class="list" onclick="editMulitiItemID();" title="Edit ID/Name"></a></span>
							
								<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
									<!-- <span class="btn_pack nobg"><a class="copy" onclick="fnCopyItemInfoOpen();" title="Copy Item"></a></span> -->
									<span class="btn_pack nobg"><a class="copy" onclick="showCopyItemDhxModal();" title="Copy Item"></a></span>
								</c:if>
							</c:if>
							
							<span class="btn_pack nobg"><a class="move" onclick="setSubDiv('MoveItem')" title="Move"></a></span>
							
							<c:if test="${blocked != 'Y'}">
								<span class="btn_pack nobg" id="updateChildIdItemOrderBtn" style="display:none;"></span>
							</c:if>
							
							<span class="btn_pack nobg"><a class="gov" onclick="editCheckedAllItems('Owner');" title="Ownership"></a></span>
							
							<c:if test="${blocked != 'Y'}">
								<span class="btn_pack nobg white"><a class="del" onclick="deleteItem()" title="Delete"></a></span>
							</c:if>
						</c:if>	
					</c:if>
				</c:if>
        		<span class="btn_pack nobg white"><a class="xls" id="excel" title="Excel"></a></span>
			</li>	
          </ul>
		</div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
		<div id="transDiv"></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
	
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>


<script>
	
	//---------------------------------------------------------
	//[GRID] START ::
	//---------------------------------------------------------
	
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
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true, align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 50, id: "Photo", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
	            }
	        },
	        { width: 110, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }], align:"center"},
	        { 			  id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left"},	        
	        { width: 110, id: "ClassName", header: [{text: "${menu.LN00016}", align:"center"}], align: "center"},
	        { width: 140, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center"},
	        { width: 140, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center" },
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 100, id: "ItemStatusText", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center", htmlEnable: true},
	        { width: 50, id: "FileIcon", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.FileIcon+'" width="7" height="11">';
	            }
	        }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    multiselection : true   
	    
	});
	
	// [grid] Cell 클릭
	var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" && column.id != "FileIcon"){
			doDetail(row.ItemID);
		}else if(column.id == "FileIcon") {
			var fileCheck = row.FileIcon;

			if(fileCheck.indexOf("blank.gif") < 1) {
				if( '${loginInfo.sessionMlvl}' != "SYS"){
					fnCheckItemArrayAccRight(row.ItemID);
				}else{
					var url = "selectFilePop.do";
					var data = "?s_itemID="+row.ItemID; 
				   
				    var w = "650";
					var h = "350";
				    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
				}
			}
		}else{ tranSearchCheck = false; }
			
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	// [grid] Cell 클릭 > 팝업
	function doDetail(avg1){
		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop"+"&accMode=${accMode}&itemMainPage=/itm/itemInfo/itemMainMgt";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	//---------------------------------------------------------
	//[GRID] END ::
	//---------------------------------------------------------
	
	//---------------------------------------------------------
	//[MODAL] START ::
	//---------------------------------------------------------
	
	// [add New Item]
	var addChildItemModalHtml = `
		<ul class="board-form-list" id="addNewItem">
	    <li class="flex align-center pdT40 pdB5">
	        <div class="align-center flex" style="flex: 1;">
	            <h3 class="tx" style="color:#3F3C3C;">${menu.LN00016}</h3>
	            <span class="wrap_sbj">
	                <select id="newClassCode" name="newClassCode" class="form-sel" onchange="fnGetHasDimension(this.value);" style="width: 100%;">
	                </select>
	            </span>
	        </div>
	    </li>
	    
	    <li class="flex align-center pdT5 pdB5">
		    <div class="align-center flex" style="flex: 1;">
		        <h3 class="tx" style="color:#3F3C3C;">${menu.LN00106}</h3>
		        <span class="wrap_sbj">
		            <input type="text" class="text" id="newIdentifier" name="newIdentifier" value="" style="width: 100%;">
		        </span>
	    	</div>
	    </li>
	    
	    <li class="flex align-center pdT5 pdB5">
		    <div class="align-center flex" style="flex: 1;">
		        <h3 class="tx" style="color:#3F3C3C;">${menu.LN00028}</h3>
		        <span class="wrap_sbj">
		        	<input type="text" class="text" id="newItemName" name="newItemName" value="" autocomplete="name" style="width: 100%;">
		        </span>
	    	</div>
	    </li>

	    <li class="flex align-center pdT5 pdB5">
	        <div class="align-center flex" style="flex: 1;">
	            <h3 class="tx" style="color:#3F3C3C;">${menu.LN00191}</h3>
	            <span class="wrap_sbj">
	                <select id="csrInfo" name="csrInfo" class="form-sel" style="width: 100%;">
	                </select>
	            </span>
	        </div>
	    </li>

	    <li id="dimensionRow" class="flex align-center pdT5 pdB5" style="display:none;">
	        <h3 id="dim1" class="tx" style="color:#3F3C3C;">Dimension</h3>
	        <div class="flex" style="flex: 1;">
	            <span id="dim2" class="wrap_sbj" style="margin-right: 10px;">
	                <select id="dimTypeID" name="dimTypeID" class="form-sel" onchange="fnGetDimTypeValue(this.value);" style="width: 100%;">
	                </select>
	            </span>
	            <span id="dim3" class="wrap_sbj">
	                <select id="dimTypeValueID" name="dimTypeValueID" class="form-sel" style="width: 100%;">
	                </select>
	            </span>
	        </div>
	    </li>

	    <li class="flex align-center pdT20 pdB5" style="justify-content: flex-end;">
	        <div class="btns align-center flex">
	        	<button onclick="newItemInsert()" class="secondary">Save</button>
	        	<button onclick="newItemInsert('Y')" class="secondary" style="margin-left: 5px;">Save and Add</button>
	        </div>
	    </li>
	</ul>
	`;

	function showAddChildItemDhxModal(){
		
		// 모달이 돔에 마운트 된 후 실행시킬 콜백함수
		function showAddChildItemModalCallback(){
			
			document.getElementById("newItemName").value = "";
			document.getElementById("dimTypeID").value = "";
			document.getElementById("dimTypeValueID").value = "";
			
			document.getElementById("ownerTeamID") && (document.getElementById("ownerTeamID").value = '${sessionScope.loginInfo.sessionTeamId}');
			document.getElementById("newIdentifier") && document.getElementById("newIdentifier").focus();
			
			var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
			fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');
			
			// select 셋팅
			renderClassOptions();
			renderCsrOptions('N');
			
			// [자동 검색 기능]
			loadAutoComplete();
			
		}
        dhxModal = openHtmlWithDhxModal(addChildItemModalHtml, "${menu.LN00096}", 800, 450, showAddChildItemModalCallback)
	}
	
	// [copy Item]
	var copyItemModalHtml = `
		<ul class="board-form-list" id="copyItem">
	    <li class="flex align-center pdT40 pdB5">
	        <div class="align-center flex" style="flex: 1;">
	            <h3 class="tx" style="color:#3F3C3C;">${menu.LN00016}</h3>
	            <span class="wrap_sbj">
	            	<input type="hidden" id="cpClassCode" name="cpClassCode" value="" />
					<input type="text" class="text" id="cpIdentifier" name="cpIdentifier" value="" style="width: 100%;" />
					<input type="hidden" id="cpItemID" name="cpItemID" value="" />	
					<input type="hidden" id="cpItemTypeCode" name="cpItemTypeCode" value="" />
	            </span>
	        </div>
	    </li>
	    
	    <li class="flex align-center pdT5 pdB5">
		    <div class="align-center flex" style="flex: 1;">
		        <h3 class="tx" style="color:#3F3C3C;">${menu.LN00028}</h3>
		        <span class="wrap_sbj">
		        <input type="text" class="text" id="cpItemName" name="cpItemName"  value="" style="width: 100%;" />
		        </span>
	    	</div>
	    </li>
	    
	    <li class="flex align-center pdT5 pdB5">
		    <div class="align-center flex" style="flex: 1;">
		        <h3 class="tx" style="color:#3F3C3C;">${menu.LN00191}</h3>
		        <span class="wrap_sbj">
			        <select id="cpCsrInfo" name="cpCsrInfo" class="form-sel" style="width: 100%;"><option value="">Select</option></select>
		        </span>
	    	</div>
	    </li>

	    <li class="flex align-center pdT5 pdB5">
	        <div class="align-center flex" style="flex: 1;">
	            <h3 class="tx" style="color:#3F3C3C;">${menu.LN00125}</h3>
	            <span class="wrap_sbj">
	                <select id="modelID" name="modelID" class="form-sel" style="width: 100%;"></select>
	            </span>
	        </div>
	    </li>

	    <li class="flex align-center pdT20 pdB5" style="justify-content: flex-end;">
	        <div class="btns align-center flex">
	        	<button onclick="fnCopyItemInfo()" class="secondary">Save</button>
	        </div>
	    </li>
	</ul>
	`;

	function showCopyItemDhxModal(){
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });	
		
		if(selectedCell.length != 1){
			alert("${WM00106}");
			return false;
		}
		
		// 모달이 돔에 마운트 된 후 실행시킬 콜백함수
		function showCopyItemModalCallback(){
			
			var itemID = "";	
			var classCode = "";
			var gubun = "";
			var itemTypeCode = "";
			
			for(idx in selectedCell){	
			  	itemID = selectedCell[idx].ItemID;	
				identifier = selectedCell[idx].Identifier;	
				itemName = selectedCell[idx].ItemName;	
				classCode = selectedCell[idx].ClassCode;	
				gubun = selectedCell[idx].GUBUN;	
				itemTypeCode = selectedCell[idx].ItemTypeCode;	
			};
			
			if(gubun != "M"){
				alert("${WM00046}");
				return false;
			}
			
			var data = "&itemID="+itemID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('modelID', data, 'selectModelList', '', 'Select', 'model_SQL');
			
			renderCsrOptions('C');
			
			document.getElementById("ownerTeamID") && (document.getElementById("ownerTeamID").value = '${sessionScope.loginInfo.sessionTeamId}');
			document.getElementById("cpItemID") && (document.getElementById("cpItemID").value = itemID);
			document.getElementById("cpIdentifier") && (document.getElementById("cpIdentifier").value = identifier);
			document.getElementById("cpItemName") && (document.getElementById("cpItemName").value = itemName);
			document.getElementById("cpClassCode") && (document.getElementById("cpClassCode").value = classCode);
			document.getElementById("cpItemTypeCode") && (document.getElementById("cpItemTypeCode").value = itemTypeCode);
			
			document.getElementById("checkElmts").value = "";
			document.getElementById("newModelName").value = "";
			document.getElementById("MTCTypeCode").value = "";
			document.getElementById("ModelTypeCode").value = "";
			
		}
        dhxModal = openHtmlWithDhxModal(copyItemModalHtml, "Copy Item", 800, 450, showCopyItemModalCallback)
	}
	
	//---------------------------------------------------------
	//[MODAL] END ::
	//---------------------------------------------------------
	
	
	
	
	
	//---------------------------------------------------------
	//[사용 여부 확인이 필요한 function] ::
	//---------------------------------------------------------
	
	function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}
	
	function testLayer(avg1,avg2,avg3){
		// 조회 창을 닫음
		$(".popup_div").hide();
		$("#mask").hide();
		// 변경요청 화면을 모달로 표시
		goInsertChangeSet(avg1,avg2,avg3);
	}

	/* 변경요청 insert -체크항목 , 유형, 선택항목(이동시)*/
	function goInsertChangeSet(avg1, avg2 , avg3) {
		//var url = "changeInfoAddViewPop.do?";
		//var data = "items=" + avg1 + "&changeType=" + avg2 + "&userId=${sessionScope.loginInfo.sessionUserId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
		
		//Move - 구조 이동시
		if(avg3 != ""){
			//현재 항목과 이동될 항목이 같은지 체크
			if('${s_itemID}'==avg3){
				//alert("같은 항목으로는 이동 하지 못합니다.");//arguments
				alert("${WM00055}");//arguments
				return;
			}
			var checkVal = avg1.split(",");
			for(var i = 0; i < checkVal.length ; i++){
				if(checkVal[i] == avg3){
					//alert("이동 될 항목중 선택 된 항목이 들어 있습니다.");
					alert("${WM00056}");
					return
				}
			}
			data = data + "&fromItemID=${s_itemID}&toItemID="+avg3;
		}
		
		var url = "changeInfoAddView.do";
		var data = "backScreen=1&s_itemID=${s_itemID}&option=${option}&items=" + avg1 + "&changeType=" + avg2 
			+ "&userId=${sessionScope.loginInfo.sessionUserId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "processList";		
		ajaxPage(url, data, target);
		
		//var option = "dialogWidth:1050px; dialogHeight:305px; scroll:yes";
	    //window.showModalDialog(url + data , self, option);
	}
	
	function fnCopyItemInfoOpen(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });	
		
		if(selectedCell.length != 1){
			alert("${WM00106}");
			return false;
		}
		
		var itemID = "";	
		var classCode = "";
		var gubun = "";
		var itemTypeCode = "";
		for(idx in selectedCell){	
		  	itemID = selectedCell[idx].ItemID;	
			identifier = selectedCell[idx].Identifier;	
			itemName = selectedCell[idx].ItemName;	
			classCode = selectedCell[idx].ClassCode;	
			gubun = selectedCell[idx].GUBUN;	
			itemTypeCode = selectedCell[idx].ItemTypeCode;	
		};
		if(gubun != "M"){
			alert("${WM00046}");
			return false;
		}
		
		var data = "&itemID="+itemID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('modelID', data, 'selectModelList', '', 'Select', 'model_SQL');
		
		$("#copyItem").removeAttr('style', 'display: none');
		$("#addNewItem").attr('style', 'display: none');	
		
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');	
		$("#divTapItemAdd").attr('style', 'display: none');	
		$("#divTapItemCopy").removeAttr('style', 'display: none');
		$("#transDiv").attr('style', 'display: none');
		$("#moveOrg").attr('style', 'display: none');		
		
		$("#cpItemID").val(itemID);
		$("#cpIdentifier").val(identifier);
		$("#cpItemName").val(itemName);
		$("#cpClassCode").val(classCode);
		$("#cpItemTypeCode").val(itemTypeCode);
		
		$("#checkElmts").val('');
		$("#newModelName").val('');
		$("#MTCTypeCode").val('');
		$("#ModelTypeCode").val(''); 
	}
	
	function fnSetCopyModelInfo(checkElmts, newModelName, MTCTypeCode,ModelTypeCode){
		$("#checkElmts").val(checkElmts);
		$("#newModelName").val(newModelName);
		$("#MTCTypeCode").val(MTCTypeCode);
		$("#ModelTypeCode").val(ModelTypeCode); 
	}
	
</script>