<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<style>
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
	
	.cxn_layer{display:none;width:400px;height:180px;overflow-x:hidden;overflow-y:auto;position:absolute;border:1px gray solid;background-color:white; }
	.cxn_layer.open{display:block}
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<!-- 2. Script -->
<script type="text/javascript">
	var positionX,positionY;
	var cxnItemID;
	
	var s_itemID = "${s_itemID}";
	var childCXN = "${childCXN}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var cxnTypeList = "${cxnTypeList}";
	var notInCxnClsList = "${notInCxnClsList}";
	
	// fileList 호출용
	var option = "${option}";
	var filter = "${filter}";
	var ItemIDs = []; 
	
	var combinedLinkData = []; // linkYN 옵션 데이터
	
	$(document).ready(function() {
		LoadAllCxnData();
	});
	
	// 선후행 및 일반 연관항목 아이템 정보 모두 가져오는 함수
	async function LoadAllCxnData(linkYN) {
		
		$('#loading').fadeIn(150);
		
		try{
		    // 선후행 & 일반 연관항목 정보 요청 병렬 처리, 완료 보장.
		    const promiseAllResults = await Promise.allSettled([
		        reloadConnectedProcess(),
		        reloadCxnItem()
		    ]);
	
		    // results[0]: reloadConnectedProcess의 결과
		    const connectedProcessData = promiseAllResults[0].status === 'fulfilled' 
		        ? promiseAllResults[0].value 
		        : [];
		    
		    // results[1]: reloadCxnItem의 결과
		    const cxnItemData = promiseAllResults[1].status === 'fulfilled' 
		        ? promiseAllResults[1].value 
		        : [];
	
	        const errorMessages = [];
		     
		    const cxnProcessErrorHeader = "선후행 프로세스 에러: ";
		    const cxnItemErrorHeader = "일반 연관항목 에러: ";
	  
	        if (promiseAllResults[0].status === 'rejected') {
	            const error = promiseAllResults[0].reason;
	            errorMessages.push(cxnProcessErrorHeader+error.message);
	            console.error(cxnProcessErrorHeader+error.message);
	        }
	        
	        if (promiseAllResults[1].status === 'rejected') {
	            const error = promiseAllResults[1].reason;
	            errorMessages.push(cxnItemErrorHeader+error.message);
	            console.error(cxnProcessErrorHeader+error.message);
	        }
	   
	        if (errorMessages.length > 0) {
	        	
	      		Promise.all([
	    			getDicData("ERRTP", "LN0014"), 
	    			getDicData("BTN", "LN0034"), // 닫기
	    		]).then(results => {
	    			showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
	    		});	
	        }
	        
	        // load grid
	        const combinedData = connectedProcessData.concat(cxnItemData); 
		    if (Array.isArray(combinedData)){
		    	const newIDs = combinedData.map(item => item.ItemID);
			    ItemIDs.push(...newIDs);
		    }
		    if (combinedData.length > 0) {
		    	
		    	deleteEmptyDataPageAndPrepareLayout();
		    	// link api 호출
		    	if(linkYN == 'Y'){
		   	    	combinedLinkData = await setCxnItemLink(combinedData);
		   	    	if (combinedLinkData && combinedLinkData.length > 0) fnReloadCxnGrid(combinedLinkData);
		   	    	else fnReloadCxnGrid(combinedData);
		    	} else {
		    		fnReloadCxnGrid(combinedData);
		    	}
		    	
		    	
		    } else {
		        console.warn("No data to parse into the grid - empty array [] was used.");
		        showEmptyDataPage();
		        fnReloadCxnGrid([]);
		    }
		} catch (error) {
	    	return;
	        console.error("데이터 병합 중 오류 발생:", error);
	    } finally {
		    $('#loading').fadeOut(150);
	    }
	    
	}
	
	// 선/후행 연계 프로세스 정보 가져오는 함수
	async function reloadConnectedProcess() {
	    const requestData = { s_itemID, languageID, childCXN };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getConnectedProcessList.do?" + params;

	    const response = await fetch(url, { method: 'GET' });

	    if (!response.ok) {
	    	// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
	    	const errorMessage = data.message || "서버 내 오류 발생";
	    	const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        error.status = response.status;
	        throw error;
	    }
	    
	    const data = await response.json();
	    
	    // 서버가 반환하는 성공여부 필드 체크
	    if (!data.success) {
	        const errorMessage = data.message || "요청 처리 실패";
	        const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        throw error;
	    }

	    if (data && data.data) {
	        return data.data; 
	    } else {
	        // 서버가 반환한 데이터가 유효하지 않을 경우
	        const error = new Error("서버가 반환한 데이터가 유효하지 않음");
	        error.type = 'INVALID_DATA';
	        throw error;
	    }
	}
	
	// 일반 연관항목 아이템 정보 가져오는 함수
	async function reloadCxnItem() {
	    const requestData = { s_itemID, languageID, cxnTypeList, notInCxnClsList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getCxnItemList.do?" + params;

	    const response = await fetch(url, { method: 'GET' });

	    if (!response.ok) {
	    	// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
	    	const errorMessage = data.message || "서버 내 오류 발생";
	    	const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        error.status = response.status;
	        throw error;
	    }

	    const data = await response.json();
	    
	    // success 필드 체크
	    if (!data.success) {
	        const errorMessage = data.message || "요청 처리 실패";
	        const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        throw error;
	    }

	    if (data && data.data) {
	        return data.data;
	    } else {
	    	// 서버가 반환한 데이터가 유효하지 않을 경우
	        const error = new Error("서버가 반환한 데이터가 유효하지 않음");
	        error.type = 'INVALID_DATA';
	        throw error;
	    }
	}
	
	// 아이템에 할당된 link 가져오는 함수
	async function setCxnItemLink(combinedData) {
	    
		try {
			
        	const updatePromises = combinedData.map(async (item) => {
            
	            const requestData = { 
	                itemID: item.ItemID, 
	                languageID,
	                itemClassCode: item.ClassCode 
	            };
	            
	            if(item.ItemID){
		            const linkData = await loadCxnItemLink(requestData);
		            return {
		                ...item,
		                ...linkData // 추가 데이터 저장
		            };
	            } else {
	            	return item;
	            }
	            
        	});

        	const resultData = await Promise.all(updatePromises);
        	return resultData;

	    } catch (error) {
	    	return;
	        console.error("데이터 병합 중 오류 발생:", error);
	    }
	}
	
	// cxnItem Link 조회
	async function loadCxnItemLink(requestData) {
	    
		const params = new URLSearchParams(requestData).toString();
	    const url = "getLinkListFromAttAlloc.do?" + params;
	    
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
				return;
			}

		} catch (error) {
			handleAjaxError(error);
		}
	   
	}
	
	function fnReloadCxnGrid(newGridData){
		
		// reset
		if (cxnItemGrid.data.getLength() > 0) {
			cxnItemGrid.data.removeAll();
    	}
		
		// ClassName에 ItemTypeImg 추가
		const modifiedData = newGridData.map(item => {
			if (item.ItemTypeImg) {
				const currentClassName = item.ClassName;
				return { 
					...item, 
					ClassName: '<img src="${root}${HTML_IMG_DIR}/item/'+item.ItemTypeImg+'" width="18" height="18">&nbsp;'+ currentClassName
				};
			}
			return item; 
		});
		
		cxnItemGrid.data.parse(modifiedData);
		cxnItemGrid.data.group([
			{ by: "ClassName" }
		]);

 		$("#TOT_CNT").html(cxnItemGrid.data.getLength());
 	}
	
	function downExcelCxnItem() {
		Promise.all([
			getDicData("ERRTP", "LN0015"), 
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, () => fnGridExcelDownLoad(cxnItemGrid), null, results[1].LABEL_NM, results[2].LABEL_NM);
		});
	}
	
</script>

<body>
<div id="processDIV">	
<form name="cxnItemTreeFrm" id="cxnItemTreeFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	<div class="btn-wrap pdT10 pdB10">
		<div class="btns">
			<div>
				<input type="checkbox" id="linkHideShow" value="" class="switch" onclick="fnLinkHideShow()">
				<label for="linkHideShow" class="switch_label">Link</label>
			</div>			
			<div>
				<input type="checkbox" id="teamHideShow" value="" class="switch" onclick="fnTeamHideShow()">
				<label for="teamHideShow" class="switch_label">Team</label>
			</div>
		</div>
		<div class="btns">

			<c:if test="${myItem == 'Y'}">	
				<c:if test="${childCXN ne 'Y' }">
	<!-- 				<span class="btn_pack nobg" alt="Assign" title="Assign"  style="cursor:pointer;_cursor:hand"><a onclick="assignProcess();"class="assign" ></a></span> -->
	<!--       			<span class="btn_pack nobg"><a class="relationship" onclick="fnEditAttr();" title="Relationship"></a></span> -->
	      			
	      			<button class="secondary" onclick="assignProcess()">Add</button>
	      			<button class="secondary" onclick="fnEditAttr()">Relationship</button>
				</c:if>
	<!-- 			<span class="btn_pack nobg"><a class="file" onclick="fnConnItemDocumentList();" title="Files" id="file"></a></span>	 -->
	<!-- 			<span class="btn_pack nobg white"><a class="del" onclick="delProcess();" title="Delete" id="delPrc"></a></span>	 -->
				<button class="secondary" onclick="openCxnItemFilesModal()">File</button>
				<button class="secondary" onclick="delProcess()">Delete</button>
	
			</c:if>					
	<!-- 		<span class="btn_pack nobg white"><a class="xls"  title="Excel" id="excel"></a></span> -->
			<button class="secondary" onclick="downExcelCxnItem()">Excel</button>
		</div>
	</div>
	
	<div style="width: 100%;" id="cxnItemlayout" class="mgB20"></div>
	
	<div class="cxn_layer" id="connectionPopup">								
		<div class="mgT10 mgB10 mgL5 mgR5">
		<span class="closeBtn">
			<span style="cursor:pointer;_cursor:hand;position:absolute;right:10px;" OnClick="fnCloseLayer();">Close</span>
		</span> <br>
		<table id="cxnAttrLayer" class="tbl_blue01 mgT5" style="width:100%;height:98%;">
		</table> 
		</div>
	</div> 
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</form>
</div>



<script>

	const columns = [
		{ id: "ClassName", width: 120, type: "string", header: [{ text: "ClassName", align: "center" }], align: "center", htmlEnable: true },
		{ id: "TreeName", width: 350, header: [{ text: "${menu.LN00028}", align: "center" }], htmlEnable: true, 
        	template: function (text, row, col) {
        		if(row.parent == "cxnItemGrid") return "";   		
        		if(row.parent != "treegrid" && row.parent != "${s_itemID}"){
					if(row.HaveTeamParent == "Y"){
						return '&emsp;&emsp;&emsp;&emsp;' + row.TreeName;
					} else if(row.IsTeamParent == "Y"){
						return '&emsp;&emsp;&emsp;<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">&nbsp;'+ row.TreeName;
					}else{
						return '&emsp;' + row.TreeName;
        			}
        		}else{
        			return '<img src="${root}${HTML_IMG_DIR}/item/'+row.Icon+'" width="18" height="18">&nbsp;'+ row.TreeName;	        			
        		}
        	} 	
        },
        { width: 40, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnTreeGridMasterChk(checked)'></input>", align: "center" }], type: "boolean", align: "center", htmlEnable: true, editable: true, sortable: false},
        { id: "ItemPath", type: "string", header: [{ text: "${menu.LN00043}", align: "center" }], autoWidth: true },
        { id: "LinkType", width: 100, type: "string", header: [{ text: "${menu.LN00038}", align: "center" }], align: "center" },
        { id: "linkImg", width: 50, type: "html", header: [{ text: "Link", align: "center"}], htmlEnable: true, align: "center", sortable: false, hidden: true
        		, template: function (text, row, col) {
	        		if(row.linkImg == undefined){
	        			return '<img src="${root}${HTML_IMG_DIR}/item/blank.png" width="19" height="20">';
	        		}else{	
		        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.linkImg+'" width="19" height="20">';
	        		}
            	} 
        },
        { id: "OwnerTeamName", width: 120, type: "string", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center", hidden: true},
        { id: "Name", width: 120, type: "string", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
        { id: "LastUpdated", width: 120, type: "string", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
        { id: "Status", width: 120, type: "string", header: [{ text: "${menu.LN00027}", align: "center"}] , htmlEnable: true, align: "center",
            template: function (text, row, col) {
                var result = "";
                switch (text) {
        			case "NEW1" : result = '<span class="grid__cell_status-item new">'+row.StatusName+'</span>'; break;
        			case "MOD1" : result = '<span class="grid__cell_status-item mod">'+row.StatusName+'</span>'; break;
        			case "MOD2" : result = '<span class="grid__cell_status-item mod">'+row.StatusName+'</span>'; break;
        			case "REL" : result = '<span class="grid__cell_status-item">'+row.StatusName+'</span>'; break;
        			default : result = '';
    			}
                return result;
            }
        },
	];

	var cxnItemlayout = new dhx.Layout("cxnItemlayout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var cxnItemGrid;

	var cxnItemGrid = new dhx.Grid("cxnItemGrid",  {
		columns: columns,
	    group: {
	    	order: "ClassName",
	        panel: false,
	    },
	    groupable: true,
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    height: "auto",
	});

	cxnItemlayout.getCell("a").attach(cxnItemGrid);

	cxnItemGrid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(cxnItemGrid.data.getLength());
	});
	
	// cell click 시 fetch 
	cxnItemGrid.events.on("cellClick", function(row,column,e){
		if(column.id == "linkImg"){
			if(row.linkUrl != "" && row.linkUrl != undefined ){
				fnOpenLink(row.ItemID,row.linkUrl,row.lovCode,row.attrTypeCode);
			}
		} else if(column.id == "Name" && row.AuthorID != "" && row.AuthorID != undefined ){
			var url = "viewMbrInfo.do?memberID="+row.AuthorID;		
			window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');		
		}else if(column.id == "LinkType" && row.CXNItemID != "" && row.CXNItemID != undefined){	
			doPtgDetail(row.CXNItemID);
		} else if(column.id != "checkbox"){
			if(row.ItemID != undefined && row.ItemID != ""){ doPtgDetail(row.ItemID); }
		}
	});
		
	cxnItemGrid.events.on("cellMouseOver",function(row,column,e){
		if(column.id == "LinkType" && row.CXNItemID != "" && row.CXNItemID != undefined){				
			positionY = event.clientY + 10;
			positionX = event.clientX - 100;
			fnGetCxnAttrList(row.CXNItemID);
		}else{ fnCloseLayer(); }		
	});
	
	function fnTreeGridMasterChk(state) {
	    event.stopPropagation();
	    cxnItemGrid.data.forEach(function (row) {
	        cxnItemGrid.data.update(row.id, { "checkbox" : state })
	    })
	}
			
	async function fnLinkHideShow(){
		if( document.all("linkHideShow").checked == true){
			
			if (!combinedLinkData?.length) {
				LoadAllCxnData('Y');
			}
			cxnItemGrid.showColumn("linkImg");
		}else{
			cxnItemGrid.hideColumn("linkImg");
		}
	}
	
	function fnTeamHideShow(){
		if( document.all("teamHideShow").checked == true){
			cxnItemGrid.showColumn("OwnerTeamName");
		}else{
			cxnItemGrid.hideColumn("OwnerTeamName");
		}
	}
	
	function doPtgDetail(avg){		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	
	function assignProcess(){	
		var url = "selectCxnItemTypePop.do?s_itemID=${s_itemID}&varFilter=${varFilter}&screenMode="; 
		var w = 500;
		var h = 300;
		itmInfoPopup(url,w,h);
	}
	
	var itemTypeCodeTreePop;
	function fnOpenItemTree(itemTypeCode, searchValue, cxnClassCode){
		$("#cxnTypeCode").val(itemTypeCode);
		$("#cxnClassCode").val(cxnClassCode);
		var url = "itemTypeCodeTreePopV4.do";
		var data = "ItemTypeCode="+itemTypeCode+"&searchValue="+searchValue
			+"&openMode=assign&s_itemID=${s_itemID}";

// 		fnOpenLayerPopup(url,data,doCallBack,617,436);
		itemTypeCodeTreePop = openUrlWithDhxModal(url, data, "Search" , 617, 436)
	}
	
	function doCallBack(){
		//alert(1);
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		var url = "cxnItemTreeMgtV4.do";
		var target = "actFrame";
		if('${frameName}' != ''){
			target = '${frameName}';
		}		
		var data = "s_itemID=${s_itemID}&varFilter=${varFilter}&option=${option}"
					+"&filter=${filter}&screenMode=${screenMode}&showTOJ=${showTOJ}"
					+"&frameName=${frameName}&showElement=${showElement}&cxnTypeList=${cxnTypeList}";
		
	 	ajaxPage(url, data, target);
	}
	
	function delProcess(){
		var selectedCell = cxnItemGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
	  		Promise.all([
				getDicData("ERRTP", "LN0017"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			return false;
		}
		function afterConfirmDeletion () {
			var items = new Array();	
			for(idx in selectedCell){
				if(selectedCell[idx].parent != "treegrid" && selectedCell[idx].parent != "${s_itemID}" && selectedCell[idx].parent != "cxnProcess" && selectedCell[idx].IsTeamParent != "Y"){
					items.push(selectedCell[idx].ItemID);
				}else{
					showDhxAlert(selectedCell[idx].TreeName + " 는(은) ${WM00046}");
					cxnItemGrid.data.update(selectedCell[idx].id, { "checkbox" : false });
				}
			};
			
			if (items != "") {
				var url = "DELCNItems.do"; 
				var data = "isOrg=Y&s_itemID=${s_itemID}&alertType=DHX&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}	
		}
		
		Promise.all([
			getDicData("ERRTP", "LN0021"),
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmDeletion, null, results[1].LABEL_NM, results[2].LABEL_NM);	
		});
		
	}

	// After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		var cxnTypeCode = $("#cxnTypeCode").val();
		var cxnClassCode = $("#cxnClassCode").val();
		var url = "createCxnItem.do";
		var data = "s_itemID=${s_itemID}&cxnTypeCode="+cxnTypeCode+"&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$("#cxnTypeCode").val("");
		$("#cxnClassCode").val("");
// 		$(".popup_div").hide();
// 		$("#mask").hide();	

		itemTypeCodeTreePop.hide();
	}
	
	function fnEditAttr(){
		var selectedCell = cxnItemGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
	  		Promise.all([
				getDicData("ERRTP", "LN0018"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			return false;
		}
		var items = new Array();	
		var classCodes = new Array();
		for(idx in selectedCell){
			if(selectedCell[idx].parent != "treegrid" && selectedCell[idx].parent != "${s_itemID}" && selectedCell[idx].parent != "cxnProcess"){
				//items.push(selectedCell[idx].ItemID);
				items.push(selectedCell[idx].CXNItemID);
				//classCodes.push(selectedCell[idx].ClassCode);
				classCodes.push(selectedCell[idx].CXNClassCode);
			}else{
		  		Promise.all([
					getDicData("ERRTP", "LN0027"), 
					getDicData("BTN", "LN0034"), // 닫기
				]).then(results => {
					showDhxAlert(selectedCell[idx].TreeName + results[0].LABEL_NM, results[1].LABEL_NM);
				});
				cxnItemGrid.data.update(selectedCell[idx].id, { "checkbox" : false });
			}
		};
		if(items == "") return;
		var url = "selectAttributePop.do";
		var data = "classCodes="+classCodes+"&items="+items;
		var option = "dialogWidth:400px; dialogHeight:250px;";		
		var w = "400";
		var h = "350";

		$("#items").val(items);
		$("#classCodes").val(classCodes);
		window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		document.cxnItemTreeFrm.action=url;
		document.cxnItemTreeFrm.target="selectAttribute";
		document.cxnItemTreeFrm.submit();
	}
	
	function urlReload(addBtnYN) {
		thisReload(addBtnYN);
	}
		
	function fnCloseLayer(){
		var layerWindow = $('.cxn_layer');
		layerWindow.removeClass('open');
	}
	
	// 미사용 함수
	function fnGetCxnAttrList(itemID){	
		var data = "itemID=" + itemID;
		var target = "blankFrame";
		var url = "";
		
		$.ajax({
			url: "getCxnAttrList.do"
			,type: 'post'
			,data: data
		    ,beforeSend: function(x) {//$('#loading').fadeIn(150);
		   	 if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}
		    }
			,success: function(data){
				$("#" + target).html(data);
			}
		});
	}
	
	function fnSetCxnAttrList(cxnHtml,cxnCnt){			
		if(Number(cxnCnt) == 0){fnCloseLayer();	 return; }
		var oPopup = document.getElementById("connectionPopup");
		
		oPopup.style.top = positionY +"px";
		oPopup.style.left = positionX +"px";
		if(Number(positionY)>540){
			oPopup.style.top = positionY - 280 +"px";
		}
		
		var layerWindow = $('.cxn_layer');
		layerWindow.addClass('open');
				
		var cxnAttrLayer ="";
		
		cxnAttrLayer += "<table class='tbl_blue01' width='100%' border='0' cellpadding='0' cellspacing='0'>";
		cxnAttrLayer += cxnHtml;
		cxnAttrLayer += "</table>"; 
		$('#cxnAttrLayer').html(cxnAttrLayer);
	}
	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}
	
	// ===================================================================================================================================
	// === [ 연관항목 첨부파일 모달 관련 코드들 ] =================================================================================================
	// ===================================================================================================================================
		
	// Files 버튼 클릭 시 표시되는 모달에 렌더링될 Html
	var cxnItemFilesModalHtml = `
		<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">
		<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
		<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
		<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />	
		<input type="hidden" id="sysFileName" name="sysFileName">
		<input type="hidden" id="originalFileName" name="originalFileName">
		<input type="hidden" id="filePath" name="filePath" >
		<input type="hidden" id="seq" name="seq" >	
		<input type="hidden" id="filtered" value="Y"> 
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01" id="search">
			<colgroup>
			    <col width="13%">
			    <col width="20%">
			 	<col width="13%">
			    <col width="20%">
			 	<col width="13%">
			    <col width="21%">			   		
		    </colgroup>
		    <tr>
		       	
		       <!-- 문서유형 -->
		       <th class="alignL viewtop pdL5">${menu.LN00091}</th>
		       <td class="viewtop alignL">      
		        <select id="fltpCode" Name="fltpCode" style="width:90%">
		            <option value=''>Select</option>
		        </select>
		        </td>
		    	<!-- 언어 -->
		        <th class="alignL viewtop pdL5">${menu.LN00147}</th>
		        <td class="viewtop alignL">     
			       	<select id="selectedLanguageID" Name="selectedLanguageID" style="width:90%">
			       		<option value=''>Select</option>
			       	</select>
		       	</td>
		       	<!-- 수정일 -->
		       	<th class="alignL viewtop pdL5">${menu.LN00070}</th>
		        <td class="viewtop alignL">  
			    	<input type="text" id="startLastUpdated" name="startLastUpdated" class="input_off datePicker stext" size="8"
						style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
					
					~
					<input type="text" id="endLastUpdated" name="endLastUpdated" class="input_off datePicker stext" size="8"
						style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
					
		       	</td>     	
		    </tr>
		    <tr>
		   		<!-- 프로세스명칭 -->
		       	<th class="alignL pdL5">${menu.LN00087}</th>
		        <td class="alignL">     
			    	<input type="text" class="text" id="itemName" name="itemName" style="ime-mode:active;width:90%;" />
		       	</td>
		       	<!-- 문서명 -->
		        <th class="alignL pdL5">${menu.LN00101}</th>
		        <td class="alignL">      
		        	<input type="text" class="text" id="fileName" name="fileName" style="ime-mode:active;width:90%;" />
		        </td>
		       	<!-- 작성자 -->
		       	<th class="alignL pdL5">${menu.LN00060}</th>
		         <td class="alignL">       
			     	<input type="text" class="text" id="regUserName" name="regUserName" style="ime-mode:active;width:90%;" />
			     </td>       	
		    </tr>
	   	</table>
		<div style="height: auto; padding-top: 10px; padding-bottom: 20px;" >
			<div class="alignC">
	           	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="searchCxnFileGrid()"/>
	        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
        	</div>
        	<div style="width: 100%; display: flex; justify-content: space-between;">
		        <div class="count">Total  <span id="TOT_CNT_CXN_FILES"></span></div>
		        <div class="">
		        	<span class="mgT5" >&nbsp;<b>The latest</b> <input type="checkbox" id="blocked" name="blocked" value="Y" checked="checked"/></span>
		        	<span class="btn_pack nobg white"><a class="download" onclick="downloadCxnFile(cxnFileGrid)" title="Download"></a></span>
		        	<span class="btn_pack nobg white"><a class="xls" id="excelCxnFileModal" title="excelCxnFileModal"></a></span>
		        </div>
	        </div>
	    </div>
		<div id="gridDiv" style="width:100%;" class="clear" >
			<div id="cxnFileLayout"></div>
		</div>	
		<!-- START :: PAGING -->
		<div id="cxnFilePagination"></div>
		<!-- END :: PAGING -->		
	</form>
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	`
	
	var cxnFileLayout = null;
	var cxnFileGridData = [];
	var cxnFileGrid = null;

	// Files 버튼 클릭 시 실행되는 모달 여는 함수
	function openCxnItemFilesModal(){
		
		if(!ItemIDs.length){
	  		Promise.all([
				getDicData("ERRTP", "LN0042"), // 표시할 데이터가 존재하지 않습니다
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			return false;
		}
		
		// 모달 열린 후 실행시킬 콜백 (첨부파일 데이터 fetch 및 dhtxml grid 렌더링)
		async function openCxnItemFilesModalCallback(){
			
			$('#loading').fadeIn(150);
			
			cxnFileLayout = new dhx.Layout("cxnFileLayout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ],
			    height: 280
			});
		
			cxnFileGridData = await getCxnItemFileList()
			
			cxnFileGrid = new dhx.Grid("cxnFileGrid", {
			    columns: [
			        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
			        { width: 120, id: "FltpName", header: [{ text: "${menu.LN00091}", align: "center" } ], align: "left" },
			        
			        { width: 40, id: "down", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
			        	template: function (text, row, col) {
			        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
			            }
			        },
			        { width: 120, id: "Identifier", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "left" },
			        { width: 200,id: "ItemName", header: [{ text: "${menu.LN00087}", align: "center" } ], align: "left" },
			        { id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" } ], align: "left" },
			        { width: 40, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align: "center" } ], align: "center" },
			        { width: 70, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" } ], align: "center" },
			        { width: 70, id: "RegUserName", header: [{ text: "${menu.LN00060}", align: "center" } ], align: "center" },
			        { width: 50, id: "DownCNT", header: [{ text: "${menu.LN00030}", align: "center" } ], align: "center" },
			        { hidden: true, width: 40, id: "Seq", header: [{ text: "Seq", align: "center" } ], align: "left" },
			        { hidden: true, width: 50, id: "SysFile", header: [{ text: "SysFileWidthPath", align: "center" } ], align: "center" },
			        { hidden: true, width: 50, id: "FltpCode", header: [{ text: "FltpCode", align: "center" } ], align: "center" },
			        { hidden: true, width: 50, id: "FilePath", header: [{ text: "FilePath", align: "center" } ], align: "center" },
			        { hidden: true, width: 50, id: "DocumentID", header: [{ text: "DocumentID", align: "center" } ], align: "center" }

			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: cxnFileGridData
			});

			cxnFileLayout.getCell("a").attach(cxnFileGrid);
			$("#TOT_CNT_CXN_FILES").html(cxnFileGrid.data.getLength());
			
			var cxnFilePagination = new dhx.Pagination("cxnFilePagination", {
				data: cxnFileGrid.data,
				pageSize: 50,
			});
			
			cxnFileGrid.events.on("cellClick", function(row,column,e){
				var originalFileName = row.FileRealName;
				var sysFileName = row.SysFile;
				var filePath = row.FilePath;
				var seq = row.Seq;
				var isNew = "N";
				var DocumentID = row.DocumentID;
			if(column.id == "down"){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
				ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");	
			}else if(column.id != "checkbox"){
				var isNew = "N";
				var url  = "documentDetail.do?isNew="+isNew+"&seq="+seq
						+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 	
				}
			}); 
			
			const selectInputParams = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}";
			fnSelect('selectedLanguageID', selectInputParams, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
			fnSelect('fltpCode', selectInputParams, 'fltpCode', '', 'Select');
			
			$("input.datePicker").each(generateDatePicker);
			$("#excelCxnFileModal").click(function(){
				fnGridExcelDownLoad(cxnFileGrid);
			});
			
			$("#blocked").click(function(){
				if(!$(this).is(':checked')) {
					$("#filtered").val("N");
				}
				else {
					$("#filtered").val("Y");				
				}
				searchCxnFileGrid();
			});
			
			$('#loading').fadeOut(150);
		}
		openHtmlWithDhxModal(cxnItemFilesModalHtml, "연관항목 첨부문서", 1100, 580, () => openCxnItemFilesModalCallback());
	}
	
	function handleAjaxError(err, errDicTypeCode) {
		console.error(err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

	// 연관항목 첨부파일 fetch 수행하는 함수		
	async function getCxnItemFileList(){
		
		const requestData = { s_itemID, languageID, option, filter, ItemIDs };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getCxnItemFileList.do?" + params;
		
	    try {
		    const response = await fetch(url, { method: 'GET' });

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
		        return [];
		    }
	    } catch (error) {	    	
	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
	    	return []; 
	    }
	}
	
	// 연관항목 첨부문서 모달 내 체크박스 선택된 row에 대해 문서 다운로드 실행
	function downloadCxnFile(targetGrid){
		
		$('#loading').fadeIn(150);
		
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;
		
		var selectedCell = cxnFileGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			Promise.all([
				getDicData("ERRTP", "LN0018"), // 문서를 하나 이상 선택해 주십시오.
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			$('#loading').fadeOut(150);
			return;
		}
		
		cxnFileGrid.data.forEach(function(row){
			if(row.checkbox){
				sysFileName[j] = row.SysFileName;
				originalFileName[j] = row.FileRealName;
				filePath[j] = row.FilePath;
				seq[j] = row.Seq;
				j++;
			}
		});	
		
		$("#sysFileName").val("");
		$("#originalFileName").val("");
		$("#seq").val(seq);
		var url  = "fileDownload.do";
		$('#loading').fadeOut(150);
		ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");
	}
	
	function fnClearSearch(){
		$("#languageID").val("");
		$("#fltpCode").val("");
		$("#startLastUpdated").val("");
		$("#endLastUpdated").val("");
		$("#itemName").val("");
		$("#fileName").val("");
		$("#regUserName").val("");
	}
	
	/* 연관항목 첨부문서 모달 내 search 버튼 클릭 시 실행되는 함수 - 필터 값 적용된 검색 결과 가져옴**/
	async function searchCxnFileGrid(){	
		$('#loading').fadeIn(150);
		const sqlID = "fileMgt_SQL.getCxnItemFileList";

	    let cxnItemIdsString;
	    if (typeof ItemIDs === 'string') {
	        try {
	            // 문자열이 배열 형태 "[...]"인 경우 파싱
	            const parsed = JSON.parse(ItemIDs);
	            cxnItemIdsString = Array.isArray(parsed) ? parsed.join(', ') : ItemIDs;
	        } catch (e) {
	            // 파싱 실패 시 그대로 사용
	            cxnItemIdsString = ItemIDs;
	        }
	    } else if (Array.isArray(ItemIDs)) {
	        cxnItemIdsString = ItemIDs.join(', ');
	    } else {
	        cxnItemIdsString = ItemIDs;
	    }
				
		const requestData = new URLSearchParams({
			sqlID,
			itemIDs: cxnItemIdsString,
			languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			selectedLanguageID: $("#selectedLanguageID").val(),
			fltpCode: $("#fltpCode").val(),
			startLastUpdated: $("#startLastUpdated").val(),
			endLastUpdated: $("#endLastUpdated").val(),
			itemName: $("#itemName").val(),
			fileName: $("#fileName").val(),
			regUserName: $("#regUserName").val(),
			filtered: $("#filtered").val()
	    });
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		
	    try {
	    	const response = await fetch(url, { method: 'GET' });
	        
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
			}
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
			
			if (result && result.data) {
				reloadCxnFileGrid(cxnFileGrid, result.data);
			} else {
				reloadCxnFileGrid(cxnFileGrid, []);
			}
       	    
	    } catch (error) {
	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
	    } finally {
	    	$('#loading').fadeOut(150);
	    }
	}
	
	function reloadCxnFileGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
 		$("#TOT_CNT_CXN_FILES").html(targetGrid.data.getLength());
 	}
	
	// [ui] empty page 생성  
 	var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CCCCCC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 6H11"/><path d="M21 12H11"/><path d="M21 18H11"/><path d="M3 6h2"/><path d="M3 12h2"/><path d="M3 18h2"/><path d="M5 6v12"/></svg>';
	function showEmptyDataPage() {
		$("#cxnItemlayout").attr("style","height:0px; width:100%;");
		   
		let buttonFunc = "";
		let buttonTitle = "";
		let buttonStyle = "";
		
		const elements = document.querySelectorAll('.empty-wrapper.btns');
		
		if(elements.length > 0) return;
		if ("${myItem}" === 'Y' && "${childCXN}" !== 'Y') {
			let buttonFunc = "assignProcess()";
			
			Promise.all([getDicData("ERRTP", "LN0042"), getDicData("BTN", "LN0026")])
			.then(([errtp042, btn026])=>{
				document.querySelector("#cxnItemlayout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, '연관항목을 등록하세요.', buttonFunc, btn026.LABEL_NM, ""));
			})
		} else {
			Promise.all([getDicData("ERRTP", "LN0042")])
			.then(([errtp042])=>{
				document.querySelector("#cxnItemlayout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, "", "", "", ""));
			})
		}
	}

	// [ui] empty page 제거
	function deleteEmptyDataPageAndPrepareLayout(){
		const elements = document.querySelectorAll('.empty-wrapper.btns');
		elements.forEach(el => el.remove());
	}

</script>

</body>



