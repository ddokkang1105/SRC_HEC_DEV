<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/> 
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="ClassCode"/>
</script>

<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<style type="text/css">
	/* 그룹 헤더의 'Group' 글자 숨기기 */
	.dhx_grid-header-cell-text_content[aria-label="Sort by Group"] {
		font-size: 0px !important;
	}
	
	/* 오른쪽 패널 배경색을 살짝 다르게 하여 구분감 부여 */
    #right-panel {
        box-shadow: inset 5px 0 10px -5px rgba(0,0,0,0.1);
    }

	/* DHTMLX 그룹 헤더 텍스트 숨기기 유지 */
    .dhx_grid-header-cell-text_content[aria-label="Sort by Group"] {
        font-size: 0px !important;
    }
    
	.main-content-wrapper {
	    display: flex;
	    width: 100%;
	    height: calc(100vh - 180px) !important; 
	    min-height: 400px;
	    background: #fff;
	    border: 1px solid #ddd;
	    box-sizing: border-box;
	}
	
	#left-panel, #right-panel {
	    height: 100%;
	    overflow: hidden;
	}     	
	
	.dim-modal-container .noline {
		display: none;
	}
	.dim-modal-container {
		padding: 24px 32px;
		box-sizing: border-box;
		height: 100%;
		overflow: hidden;
	}
	.dim-modal-container .btnlast {
		text-align: right;
		padding-right: 24px;
		padding-top: 12px;
		padding-bottom: 50px;
		height: 100%;
		vertical-align: bottom;
	}
	.dim-modal-container .tbl_blue01 {
		width: 100%;
		margin: 0;
		border: 0;
		border-collapse: collapse;
		table-layout: fixed;
		height: 100%;
	}
	.dim-modal-container .tbl_blue01 th,
	.dim-modal-container .tbl_blue01 td {
		border-left: 0;
	}
	.custom-dhx-modal .dhx_window-content,
	.custom-dhx-modal .dhx_window__content {
		overflow: hidden !important;
	}

	#gridDiv2 {
		display: flex;
		flex-direction: column;
		min-height: 0;
		overflow: hidden;
	}
	#gridLayout2 {
		flex: 1 1 auto;
		min-height: 0;
		width: 100%;
		box-sizing: border-box;
	}
	
</style>

<!-- 2. Script -->
<script type="text/javascript">

	if (window.dhx && !window.dhx9) {
		window.dhx9 = window.dhx;
	}

	const s_itemID = "${s_itemID}";
	const languageID = "${sessionScope.loginInfo.sessionCurrLangType}";

	var gridLayout, grid;
	var gridLayout2, grid2;
	var grid2PagingData;
	var grid2AllRows = [];
	var grid2PageSize = 40;
	var dhxModal;
	var dimModalState = { parent: null, next: null };
	
	var dimValID;
	var pagination;
	
	// 좌측 그리드 컬럼 세팅
	const columns = [
	  	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
		{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
		{ hidden:true,width: 50, id: "PlainText", header: [{ text: "Dimension" , align: "center"}]},
		{ width: 150, id: "DimValueID", header: [{ text: "Code" , align: "center" },{ content: "inputFilter" }],align: "center"},
		{ width: 150, id: "Name", header: [{ text: "Value" , align: "center" },{ content: "inputFilter" }],align: "center"},
		{ hidden:true,width: 80, id: "ParentID", header: [{ text: "ParentDimID" , align: "center" }], align: "" },
		{ hidden:true,width: 80, id: "SCount", header: [{ text: "SCount" , align: "center" }], align: "" },
		
		{ width: 130, id: "DeletedIMG", header: [{ text: "Deleted" , align: "center"}],htmlEnable:true, align: "center",
        	template:function (text,row,col){
        		if (!row.DeletedIMG || row.DeletedIMG === "blank.png") return "";
        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.DeletedIMG+'" width="18" height="18">';
        	}	
        },
		{ hidden:true,width: 80, id: "MaxLevel", header: [{ text: "MaxLevel" , align: "center" }], align: "" },
		{ width: 100, id: "Edit", header: [{ text: "Action" , align: "center"}],htmlEnable:true, align: "center",
	        	template: function (text, row, col) {
	        		return "<span class=\"btn_pack small icon mgR10\"><span class=\"edit\"></span><input value=\"Edit\" type=\"submit\" onclick=\"showEditDimDhxModal('" + row.id + "');\" ></span>";
	            },	
        },
		{ hidden:true,width: 80, id: "Deleted", header: [{ text: "Deleted" , align: "center" }], align: "" },
	]

	
	// 우측 그리드 컬럼 세팅
	const columns2 = [
	  	// { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
		{ width: 50, id: "checkbox2", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk2(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
/* 		{ width: 70, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align: "center",
        	template:function (text,row,col){
        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
        	}},			{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" },{ content: "selectFilter" }],align: "center"},
 */		
		{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" },{ content: "inputFilter" }],align: "center"},
 		{ width: 200, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }]},
		{ width: 250, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" }], align: "left" },
		{ width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" },{ content: "selectFilter" }], align: "center" },	
		{ width: 80, id: "TeamName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
		{ width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}" , align: "center" }], align: "center" },
		{ width: 150, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" },
		{ hidden:true,width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00013}" , align: "center" }], align: "center" },
		{ hidden:true,width: 80, id: "Version", header: [{ text: "${menu.LN00017}" , align: "center" }], align: "center" },
		{ hidden:true,width: 80, id: "ID", header: [{ text: "ItemID" , align: "center" }], align: "center" },
		{ hidden:true,width: 80, id: "SCOUNT", header: [{ text: "SCOUNT" , align: "center" }], align: "center" },
		
	]
	
	
	$(document).ready(function() {
		// SKON CSRF 보안 조치 
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})	
		
		bindEvents();
		setTimeout(function() {
	        initGrid();
	        loadData();
	        
			initGrid2();
	        //loadData2();
	    }, 200);
		
		
		$("#excel").click(function(){
			fnGridExcelDownLoad(grid2, "N");
		});
	});
	
	/**
	 * @function bindEvents
	 * @description 브라우저 윈도우 리사이즈 시 그리드 영역 높이 자동 조절
	 */
	function bindEvents() {
		$(window).on("resize", () => {
	        const vh = window.innerHeight || document.documentElement.clientHeight;
	        const offset = 180;
	        const gridHeight = vh - offset;

	        $(".main-content-wrapper").css("height", gridHeight + "px");

	        setTimeout(() => {
	            if (gridLayout) gridLayout.paint();
	            if (grid) grid.paint();
	            
	            if (gridLayout2) gridLayout2.paint();
	            if (grid2) grid2.paint();
	        }, 100);
	    }).trigger("resize");
		
	}
	
	/**
	 * @function initGrid
	 * @description DHTMLX Layout 및 Grid 초기 설정 및 이벤트 바인딩
	 */
	function initGrid() {
		gridLayout = new dhx.Layout("gridLayout", { rows: [{ id: "a" }] });

		grid = new dhx.Grid("grid", {
			columns: columns,
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
		});

		gridLayout.getCell("a").attach(grid);

		grid.events.on("cellClick", function(row, column, e) {
		    gridOnRowSelect(row,column);
	
		});
	}

	let lastClickedRow = null;

	/**
	 * @function gridOnRowSelect
	 * @description 좌측 그리드 행 클릭 시 우측 패널 및 데이터 로드
	 * @param {string} row, col - 그리드 row, column 값
	 */	
	function gridOnRowSelect(row, col){ 
		lastClickedRow = row;
		//$("#addNewItem").attr('style', 'display: none');   
		$("#addNewItem").hide();
	    dimValID = row.DimValueID;
	    
	    if (col.id == "Edit" || col.id == "checkbox") {
	    	return;
	    }
	    
	    if (col.id != "checkbox") {
	        const leftPanel = document.getElementById("left-panel");
	        const rightPanel = document.getElementById("right-panel");
	        const resizer = document.getElementById("panel-resizer"); 
	        const valueInsert = document.getElementById("valueInsert");
	        const gridDiv_btn = document.getElementById("gridDiv_btn");
	        const gridDiv2 = document.getElementById("gridDiv2");
	        
	        if(gridDiv_btn) gridDiv_btn.style.display = "none"

			// 1. 레이아웃 비율 조정
	        leftPanel.style.flex = "4";
	        rightPanel.style.flex = "6";
	        
	        valueInsert.style.display = "flex"; 
	        gridDiv2.style.display = "block";	        
	        
	        if(resizer) resizer.style.display = "flex";
	        if (pagination && typeof pagination.paint === "function") {
	        	setTimeout(() => { pagination.paint(); }, 0);
	        }
	        
			// 2. 오른쪽 영역 노출 로직
	        setTimeout(() => {
	            // document.getElementById("gridDiv2").style.display = "block";
	            // $("#gridDiv2").show();
	            
	            if (!grid2) {
	                initGrid2();
	            } else {
	                grid2.paint(); 
	            }
	            
	            // pagination 설정
	            if (pagination) {
	            	const pagEl = document.getElementById("pagination");
	            	if (pagEl && pagEl.children.length === 0 && typeof pagination.mount === "function") {
	            		pagination.mount("pagination");
	            	}
	            	if (typeof pagination.paint === "function") {
	            		pagination.paint();
	            	}
	            }
	            loadData2(row.DimValueID);
	        }, 50);
	    }
	}
	
	/**
	 * @function initGrid2
	 * @description 우측 그리드 초기화 및 렌더링
	 */	 
	function initGrid2() {
		const container = document.getElementById("gridLayout2");
	    if (container) container.style.display = "block";

	    if (grid2) {
	    	grid2.mount("gridLayout2");
	        grid2.paint();
	        return;
	    }

		// 그룹핑 - 아이콘 + 클래스이름
	    grid2 = new dhx.Grid(null, {
	        columns: columns2,
		    group: {
		    	by: "ClassName",
		    	type: "column",
		        panel: false,
		    	column: {
		    		id: "group",
		    		header: [{ text: "" }],
		    		width: 300,
		    		minWidth: 180,
		    		adjust: false,
		    		htmlEnable: true,
		    		template: function (value, row, col) {
		    			if (!row.$group) return "";
		    			const first = grid2 && grid2.data
		    				? grid2.data.find(r => !r.$group && r.ClassName === row.ClassName)
		    				: null;
		    			const img = first ? first.ItemTypeImg : null;
		    			const label = value || row.ClassName || "";
		    			const count = (row.$count !== undefined && row.$count !== null) ? " (" + row.$count + ")" : "";
		    			return '<div style="display:flex; align-items:center; gap:6px;">'
		    				+ (img ? '<img src="${root}${HTML_IMG_DIR_ITEM}/' + img + '" width="18" height="18">' : '')
		    				+ '<span>' + label + count + '</span>'
		    				+ '</div>';
		    		}
		    	}
		    },
		    groupable: true,
	        autoWidth: false,
	        resizable: true,
	        selection: "row",
	        tooltip: false,
	        htmlEnable: true,
	        css: "grid-native-scroll"
	    });
	    
	    grid2.mount("gridLayout2");
	    
		// grid2 Pagination Setting 
	    grid2PagingData = new dhx.DataCollection();
	    pagination = new dhx.Pagination("pagination", {
	        data: grid2PagingData,
	        pageSize: grid2PageSize
	    });
	    pagination.events.on("change", function (page) {
	    	applyGrid2Page(page);
	    });

	    grid2.events.on("cellClick", function(row, column, e) {
	        gridOnRowSelect2(row, column);
	    });
	}

	/**
	 * @function applyGrid2Page
	 * @description 우측 그리드 페이징 적용 - 그룹화 유지 + 페이징
	 * @param {integer} 
	 */	
	function applyGrid2Page(pageIndex) {
		const start = pageIndex * grid2PageSize;
		const end = start + grid2PageSize;
		const pageRows = grid2AllRows.slice(start, end);
		
		grid2.data.parse(pageRows);
	 	grid2.data.group(
			[{ by: "ClassName", collapsed: false }],
			{ displayMode: "column", field: "group" }
		);
		if (typeof grid2.expandAll === "function") {
			grid2.expandAll();
		}
		grid2.paint();
	}
	
	// 우측 그리드 행 클릭 시 상세 팝업 오픈
	function gridOnRowSelect2(row, col){
		if (row.$group) {
	        return false;
	    }		

		if (col.id === "checkbox2") {
	        return false;
	    }		
		
		if(row.ID){
			doDetail(row.ID);
		}
	}
	
	// 아이템 상세 팝업 호출
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}	
	
	/**
	 * @function loadData
	 * @async
	 * @description Dimension 목록을 Fetch API를 통해 로드
	 */
	async function loadData() {
		$('#loading').fadeIn(150);
		resetUIState();

		const params = new URLSearchParams({
			s_itemID: s_itemID,
			languageID: languageID,
			sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
			sqlID: "dim_SQL.selectDimList"
		});

		const url = "getData.do?" + params;

		const response = await fetch(url, {
			method: "GET",
			headers: { "Content-Type": "application/x-www-form-urlencoded" }
		});

		try {
			const response = await fetch(url, { method: 'GET' });
			if (!response.ok) {
				const errorMessage = data.message || "서버 오류 발생";
				// LN0014
				const error = new Error(errorMessage);
				error.type = 'SERVER_ERROR';
				error.status = response.status;
				throw error;
			}

			const data = await response.json();
			if (!data.success) {
				const errorMessage = data.message || "요청 처리 실패";
				const error = new Error(errorMessage);
				error.type = 'SERVER_ERROR';
				throw error;
			}

			if (data && data.data) {
				return grid.data.parse(data.data);
			} else {
				const error = new Error("서버가 반환한 데이터가 유효하지 않음");
				error.type = 'INVALID_DATA';
				throw error;
			}

		} catch (error) {
			handleAjaxError(error);
		} finally {
			$('#loading').fadeOut(150);
		}
	}

	/**
	 * @function loadData2
	 * @async
	 * @description 두 번째 그리드 데이터를 서버로부터 가져와 로드합니다.
	 * @param {string} dimValID - 선택된 행의 Dimension Value ID
	 */
	async function loadData2(dimValID) {
	    if (!dimValID) return;

		// grid2가 초기화 전이라면 초기화 함수 먼저 실행
	    if (!grid2) initGrid2();	    
	    
	    $('#loading').fadeIn(150);

	    const params = new URLSearchParams({
	        dimTypeID: "${s_itemID}",
	        s_itemID: dimValID,
	        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
	        sqlID: "dim_SQL.selectDimPertinentDetailList"
	    });

	    const url = "getData.do?" + params;

	    try {
	        const response = await fetch(url, { method: 'GET' });
	    
			if (!response.ok) {
				throw throwServerError(response.statusText, response.status);
			}
	        
	        const result = await response.json();
		    
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		    
		    if (result && result.data && Array.isArray(result.data)) {
		    	grid2AllRows = result.data;
				$("#TOT_CNT").html(grid2AllRows.length);
				
				if (grid2PagingData) {
					grid2PagingData.parse(grid2AllRows);
				}
				if (pagination) {
					pagination.setPage(0, true);
				}
				applyGrid2Page(0);
		    } else {
		        const error = new Error("서버가 반환한 데이터가 유효하지 않음");
		        error.type = 'INVALID_DATA';
		        throw error;
		    }

	    } catch (error) {
	        console.error("loadData2 Error:", error);
	        handleAjaxError(error, "LN0014");
	    } finally {
	        $('#loading').fadeOut(150);
	    }
	}
	
	/**
	 * @function resetUIState
	 * @description [UI 헬퍼] 마스터 체크박스 및 상태 초기화
	 */	 
	function resetUIState() {
		const masterChk = document.querySelector("#gridLayout .dhx_grid-header [type='checkbox']");
		if (masterChk) {
			masterChk.checked = false;
		}
	}
	
	/**
	 * @function handleAjaxError
	 * @description 공통 AJAX 에러 처리
	 */	
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

	/**
	 * @function fnMasterChk
	 * @description 그리드 상단 전체 선택 체크박스 동작 제어
	 * @param {boolean} checked - 체크 여부 (true/false)
	 */
	function fnMasterChk(checked) {
		grid.data.forEach(function(row) {
			if (!row.$group) {
				grid.data.update(row.id, { checkbox: checked });
			}
		});
	}
	 
	/**
	 * @function fnMasterChk2
	 * @description 우측 그리드 전체 선택 체크박스 동작 제어
	 * @param {boolean} checked - 체크 여부 (true/false)
	 */
	function fnMasterChk2(checked) {
		grid2.data.forEach(function(row) {
			if (!row.$group) {
				grid2.data.update(row.id, { checkbox2: checked });
			}
		});
	}	 

	// Dimension 입력 모달 생성 및 초기화 콜백 실행	
	function openDimModal(title, initCallback) {
		const modalHtml = "<div id='dimModalContainer' class='dim-modal-container'></div>";
		dhxModal = openHtmlWithDhxModal(modalHtml, title, 900, 260, () => {
			const container = document.getElementById("dimModalContainer");
			const table = document.getElementById("addNewItem");
			if (container && table) {
				if (!dimModalState.parent) {
					dimModalState.parent = table.parentNode;
					dimModalState.next = table.nextSibling;
				}
				table.style.display = "table";
				container.appendChild(table);
			}
			if (typeof initCallback === "function") initCallback();
		});
		
		// Modal 닫힐 때 addNewItem 테이블 기존 상태로 복구
		if (dhxModal && dhxModal.events && dhxModal.events.on) {
			dhxModal.events.on("beforeHide", function() {
				const table = document.getElementById("addNewItem");
				if (table && dimModalState.parent) {
					table.style.display = "none";
					if (dimModalState.next && dimModalState.next.parentNode === dimModalState.parent) {
						dimModalState.parent.insertBefore(table, dimModalState.next);
					} else {
						dimModalState.parent.appendChild(table);
					}
				}
				return true;
			});
		}
	}

	/**
	 * @function showAddDimDhxModal
	 * @description Dimension 추가 모달 오픈
	 */	
	function showAddDimDhxModal() {
		openDimModal("Add Dimension", () => {
			document.querySelector(".noline span").textContent = "Add Dimension";
			$("#dimValueName").val("");
			$("#dimValueID").val("");
			document.querySelector("#dimValueID").removeAttribute("disabled");
			$("#BeforeDimValueID").val("");
			$("#saveType").val("New");
			$("#dimDeleted").prop("checked", false);
		});
	}

	/**
	 * @function showEditDimDhxModal
	 * @description Dimension 수정 모달 오픈
	 * @param {string} rowId - 선택한 rowID
	 */	
	function showEditDimDhxModal(rowId) {
		let targetRow = null;
		if (rowId) {
			targetRow = grid.data.getItem(rowId);
		} else if (lastClickedRow) {
			targetRow = lastClickedRow;
		} else {
			showDhxAlert("시스템 오류가 발생했습니다.");
			return;
		}
		
		openDimModal("Edit Dimension", () => {
			document.querySelector(".noline span").textContent = "Edit Dimension";
			document.querySelector("#dimValueID").setAttribute("disabled","disabled");
			
			$("#dimValueName").val(targetRow.Name);
			$("#dimValueID").val(targetRow.DimValueID);
			$("#BeforeDimValueID").val(targetRow.DimValueID);
			
			var dimDel = targetRow.DeletedIMG;
			if (dimDel === "blank.png") {
				$("#dimDeleted").prop("checked", false);
			} else {
				$("#dimDeleted").prop("checked", true);
			}
			
			$("#saveType").val("Edit");
		});
	}
	 
	/**
	 * @function newDimension
	 * @async
	 * @description Dimension 저장(신규/수정) 처리
	 */
	async function newDimension() {
	    const saveType = $("#saveType").val();
	    const isEdit = (saveType === "Edit");
	    const confirmMsg = isEdit ? "${CM00005}" : "${CM00009}";

	    const params = new URLSearchParams();
	    params.append("s_itemID", "${s_itemID}");
	    params.append("saveType", saveType);
	    params.append("dimDeleted", $("#dimDeleted").is(":checked"));
	    params.append("dimValueID", $("#dimValueID").val());
	    params.append("dimValueName", $("#dimValueName").val());
	    
	    if (isEdit) {
	        params.append("BeforeDimValueID", $("#BeforeDimValueID").val());
	        params.append("languageID", "${sessionScope.loginInfo.sessionCurrLangType}");
	    }

	    Promise.all([
	        getDicData("BTN", "LN0032"), // 확인
	        getDicData("BTN", "LN0033")  // 취소
	    ]).then(([okBtn, cancelBtn]) => {
	        showDhxConfirm(confirmMsg, () => {
	            (async () => {
	                try {
	                    $('#loading').fadeIn(150);
	                    
	                    const response = await fetch("admin/NewDimensionV4.do", {
	                        method: 'POST',
	                        headers: {
	                            'Content-Type': 'application/x-www-form-urlencoded',
	                            'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
	                        },
	                        body: params
	                    });

	                    if (!response.ok) throw new Error("Network response was not ok");

	                    const result = await response.json();

	        if (result.success === true) {
	        	let msg = result.message;
	            
	            const decodedMsg = decodeURIComponent(msg.replace(/\+/g, " "));
	            
	            showDhxAlert(decodedMsg);
	            if (dhxModal) {
	            	dhxModal.destructor();
	            	dhxModal = null;
	            }
	            $("#addNewItem").hide();
	            loadData();
	        } else {
	        	let msg = result.message;
	            
	            const decodedMsg = decodeURIComponent(msg.replace(/\+/g, " "));
	            
	            showDhxAlert(decodedMsg);
	            if (dhxModal) {
	            	dhxModal.destructor();
	            	dhxModal = null;
	            }
	            $("#addNewItem").hide();
	            loadData();
	        }

	                } catch (error) {
	                	showDhxAlert("시스템 오류가 발생했습니다.");
	                } finally {
	                    $('#loading').fadeOut(150);
	                }
	            })();
	        }, () => { return; }, okBtn.LABEL_NM, cancelBtn.LABEL_NM);
	    });
	}
	
	/**
	 * @function delRemove
	 * @async
	 * @description 선택된 Dimension 항목 삭제 처리
	 */
	async function delRemove() {
	    // 1. 체크된 행 찾기
	    const checkedRows = grid.data.findAll(row => row.checkbox);

	    if (checkedRows.length === 0) {
	    	showDhxAlert("${WM00023}");
	        return;
	    }

	    // 2. 삭제 확인 창
	    Promise.all([
	        getDicData("BTN", "LN0032"),
	        getDicData("BTN", "LN0033")  // 취소
	    ]).then(([okBtn, cancelBtn]) => {
	        showDhxConfirm("${CM00004}", () => {
	            (async () => {
	                try {
	                    $('#loading').fadeIn(150);
	                    
						// 삭제 가능한 대상 필터링 (하위 항목이 없는 것만)
	                    const targets = checkedRows.filter(row => {
	                        if (row.SCount != '0' && row.SCount != undefined) {
	                        	showDhxAlert(row.Name + " ${WM00024}"); // 하위항목이 있어 삭제 불가
	                            grid.data.update(row.id, { checkbox: false });
	                            return false;
	                        }
	                        return true;
	                    });

	                    if (targets.length === 0) return;

						// 3. 비동기 삭제 요청 처리 (Promise.all)
	                    const deletePromises = targets.map(async (row, index) => {
	                        const isFinal = (index === targets.length - 1);
	                        const params = new URLSearchParams();
	                        params.append("DimTypeID", "${s_itemID}");
	                        params.append("DimValueID", row.DimValueID);
	                        params.append("loginID", "${sessionScope.loginInfo.sessionUserId}");
	                        if (isFinal) params.append("FinalData", "Final");

	                        const response = await fetch("admin/DelDimensionV4.do", {
	                            method: 'POST',
	                            headers: {
	                                'Content-Type': 'application/x-www-form-urlencoded',
	                                'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
	                            },
	                            body: params
	                        });
	                        return response.json();
	                    });

	                    const results = await Promise.all(deletePromises);
	                    
						// 4. 결과 메시지 처리 (마지막 응답 확인)
	                    const lastResult = results[results.length - 1];
	                    if (lastResult && lastResult.success) {
	                        const decodedMsg = decodeURIComponent(lastResult.message.replace(/\+/g, " "));
	                        showDhxAlert(decodedMsg);
	                        loadData(); // 그리드 새로고침
	                    } else {
	                    	showDhxAlert("시스템 오류가 발생했습니다.");
	                    }

	                } catch (error) {
	                    console.error("Delete Error:", error);
	                    showDhxAlert("시스템 오류가 발생했습니다.");
	                } finally {
	                    $('#loading').fadeOut(150);
	                }
	            })();
	        }, () => { return; }, okBtn.LABEL_NM, cancelBtn.LABEL_NM);
	    });
	}	

	/**
	 * @function fnDeleteDim
	 * @async
	 * @description 선택된 Dimension 완전 삭제 처리 (한 번의 요청으로 일괄 삭제)
	 */
	async function fnDeleteDim() {
	    // 1. 체크된 행 추출
	    const checkedRows = grid.data.findAll(row => row.checkbox);

	    if (checkedRows.length === 0) {
	    	showDhxAlert("${WM00023}");
	        return;
	    }

		// 2. 삭제 확인 창
	    Promise.all([
	        getDicData("BTN", "LN0032"), // 확인
	        getDicData("BTN", "LN0033")  // 취소
	    ]).then(([okBtn, cancelBtn]) => {
	        showDhxConfirm("${CM00004}", () => {
	            (async () => {
					// 3. ID들을 콤마로 연결한 문자열 생성
	                const dimValueIDs = checkedRows.map(row => row.DimValueID).join(",");

	                const params = new URLSearchParams();
	                params.append("dimTypeID", "${s_itemID}");
	                params.append("dimValueIDs", dimValueIDs);

	                try {
	                    $('#loading').fadeIn(150);

	                    const response = await fetch("admin/deleteDimensionV4.do", {
	                        method: 'POST',
	                        headers: {
	                            'Content-Type': 'application/x-www-form-urlencoded',
	                            'Accept': 'application/json',
	                            'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
	                        },
	                        body: params
	                    });

	                    if (!response.ok) throw new Error("Network response was not ok");

	                    const result = await response.json();

						// 4. 결과 디코딩 및 알림
	                    if (result.success) {
	                        const decodedMsg = decodeURIComponent(result.message.replace(/\+/g, " "));
	                        showDhxAlert(decodedMsg);
	                        
	                        // refresh list
	                        loadData(); 
	                    } else {
	                        const errorMsg = result.message ? decodeURIComponent(result.message.replace(/\+/g, " ")) : "처리 중 오류 발생";
	                        showDhxAlert(errorMsg);
	                    }

	                } catch (error) {
	                    console.error("Delete Error:", error);
	                    showDhxAlert("시스템 오류가 발생했습니다.");
	                } finally {
	                    $('#loading').fadeOut(150);
	                }
	            })();
	        }, () => { return; }, okBtn.LABEL_NM, cancelBtn.LABEL_NM);
	    });
	}
	
 	/**
	 * @function delSubDim
	 * @async
	 * @description 우측 그리드 항목 삭제
	 */
	 async function delSubDim() {
		// 1. 체크박스(CHK)가 true인 행만 정확히 추출
	    const checkedRows = grid2.data.findAll(row => row.checkbox2 === true);
	    
	    if (checkedRows.length === 0) {
	    	showDhxAlert("${WM00023}");
	        return;
	    }

	    Promise.all([
	        getDicData("BTN", "LN0032"),
	        getDicData("BTN", "LN0033")  // 취소
	    ]).then(([okBtn, cancelBtn]) => {
	        showDhxConfirm("${CM00004}", () => {
	            (async () => {
	                try {
	                    $('#loading').fadeIn(150);

						// 2. 서버로 보낼 ID 목록 생성 (콤마로 연결)
	                    const items = checkedRows.map(row => row.ID).join(",");
	                    
	                    const params = new URLSearchParams();
	                    params.append("items", items);
	                    params.append("dimTypeId", "${s_itemID}");
	                    params.append("dimValueId", dimValID); 

						// 3. 비동기 삭제 요청
	                    const response = await fetch("admin/DelSubDimensionV4.do", {
	                        method: 'POST',
	                        headers: {
	                            'Content-Type': 'application/x-www-form-urlencoded',
	                            'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
	                        },
	                        body: params
	                    });

	                    if (!response.ok) throw new Error("Network response was not ok");

	                    const result = await response.json();

						// 4. 서버 처리 성공 시
	                    if (result.success) {
	                        const decodedMsg = decodeURIComponent(result.message.replace(/\+/g, " "));
	                        showDhxAlert(decodedMsg);

	                        // remove only checked rows
	                        checkedRows.forEach(row => {
	                            grid2.data.remove(row.id); 
	                        });
	                        
							loadData2(dimValID);
	                    } else {
	                    	showDhxAlert(decodeURIComponent(result.message.replace(/\+/g, " ")));
	                    }

	                } catch (error) {
	                    console.error("Delete Error:", error);
	                    showDhxAlert("시스템 오류가 발생했습니다.");
	                } finally {
	                    $('#loading').fadeOut(150);
	                }
	            })();
	        }, () => { return; }, okBtn.LABEL_NM, cancelBtn.LABEL_NM);
	    });
	}

 	
 	/**
	 * @function toggleRightPanel
	 * @description 우측 패널 토글
	 */ 	
	 function toggleRightPanel() {
		    const leftPanel = document.getElementById("left-panel");
		    const rightPanel = document.getElementById("right-panel");
		    const resizer = document.getElementById("panel-resizer");
		    const icon = document.getElementById("toggle-icon");
		    const valueInsert = document.getElementById("valueInsert");
	        const gridDiv_btn = document.getElementById("gridDiv_btn");

			// 로그에서 확인된 것처럼 "6 1 0%"와 같은 형태이므로 포함 여부로 체크
			const currentFlex = rightPanel.style.flex;
			
			// 6 또는 1이 포함되어 있는지 확인
			if (currentFlex.includes("6") || currentFlex.includes("1")) {
				leftPanel.style.flex = "1";
				rightPanel.style.flex = "0";
				resizer.style.display = "none";
				valueInsert.style.display = "none";
				if(gridDiv_btn) gridDiv_btn.style.display = "flex"
			} 
		} 	
 	
</script>
</head>
<body>
	<form name="dimList" id="dimList" action="#" method="post" onsubmit="return false;">
	</form>		
	<input type="hidden" id="sDimValue" value="" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<!-- BIGIN :: LIST_GRID -->
	<div class="child_search mgB10">
		<li class="floatR pdR20" id="gridDiv_btn">
			<span class="btn_pack nobg"><a class="add" title="Add" id="newButton" onclick="showAddDimDhxModal();"></a></span>
			<!-- <span class="btn_pack nobg white"><a class="edit" title="Edit" id="newButton"  onclick="addDim(3);"></a></span> -->
			<!-- <span class="btn_pack nobg white"><a class="del" title="Remove" onclick="delRemove();"></a></span> -->
			
			<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
				<span class="btn_pack nobg white"><a class="del" title="Remove" onclick="fnDeleteDim();"></a></span>
			</c:if>
		</li>
	</div>
		
	<div class="main-content-wrapper" style="display: flex; width: 100%; background: #fff; border: 1px solid #ddd;">
	    
	    <div id="left-panel" style="flex: 1; min-width: 0; border-right: none; transition: flex 0.3s ease;">
	        <div id="gridDiv" style="width:100%; height: 100%;">
	            <div id="gridLayout" style="width:100%; height: 100%;"></div>
	        </div>
	    </div>
	
<!-- 		<div id="panel-resizer" onclick="toggleRightPanel()" style="width: 10px; background: #eee; cursor: pointer; display: none; align-items: center; justify-content: center; border-left: 1px solid #ddd; border-right: 1px solid #ddd;">
	        <span id="toggle-icon" style="font-weight: bold; font-size: 10px;">??/span>
	    </div>	 -->
	
	    <div id="right-panel" style="flex: 0; min-width: 0; overflow: hidden; border-left: 1px solid #eee; transition: flex 0.3s ease; background: #fafafa; display: flex; flex-direction: column;">
	        <div id="valueInsert" style="display:none; padding: 15px; flex: 1 1 auto; min-height: 0; display: flex; flex-direction: column;">
	            
	            <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 15px; margin-bottom: 10px;">
	                <span class="count" style="font-weight: bold;">Total <span id="TOT_CNT" style="color: #0288d1;">0</span></span>
	                <div class="btn-group">
						<span class="btn_pack nobg"><a class="clear" title="Back" id="panel-resizer" onclick="toggleRightPanel();"></a></span>
						<span class="btn_pack nobg"><a class="add" title="Add" id="newButton1" onclick="assignDim2Item();"></a></span>
						<span class="btn_pack nobg white"><a class="del" title="Delete" onclick="delSubDim();"></a></span>
						<span class="btn_pack nobg white"><a class="xls" title="Excel" id="excel"></a></span>
	                </div>
	            </div>
	
            <div id="gridDiv2" style="flex-grow: 1; width: 100%; min-height: 0;">
                <div id="gridLayout2" style="width:100%; height:100%;"></div>
            </div>
        </div>
        <div id="pagination" style="width: 100%; height: 50px; padding-top: 5px; border-top: 1px solid #eee;"></div>
	    </div>
	</div>
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<td colspan="6" class="noline"><img src="${root}${HTML_IMG_DIR}/icon_mark.png"><span>Add Dimension</span></td>
		</tr>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueID" name="dimValueID"  value=""/></td>			
			<th class="viewtop">${menu.LN00028}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueName" name="dimValueName"  value=""/></td>
			<th class="viewtop">Deleted</th>				
			<td class="viewtop"><input type="checkbox" id="dimDeleted" name="dimDeleted" /></td>
		</tr>
		<tr>
			<td colspan="6" class="btnlast">
				<input type="hidden" id="saveType" name="saveType" value="New">
				<input type="hidden" id="BeforeDimValueID" name="BeforeDimValueID" value="">					
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="newDimension()"></span>
			</td>
		</tr>	
	</table>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
<script type="text/javascript">

	/**
	 * @function assignDim2Item
	 * @description Dimension-아이템 연결 팝업
	 */	
	function assignDim2Item() {
		 if (!window.__dhx_backup && (window.dhx || window.dhx9)) {
		 	window.__dhx_backup = window.dhx || window.dhx9;
		 }
		 var url = "searchNewDimItemPop.do";
		 var data = "dimTypeID=${s_itemID}&dimValueID="+dimValID;
		           
		 fnOpenLayerPopup(url,data,doCallBack,617,436);
			
	}

	/**
	 * @function doCallBack
	 * @async
	 * @description 팝업 콜백 후 데이터 갱신
	 */		
	async function doCallBack() {
	    try {
	    	if (!window.dhx && window.__dhx_backup) {
	    		window.dhx = window.__dhx_backup;
	    	} else if (!window.dhx && window.dhx9) {
	    		window.dhx = window.dhx9;
	    	}
	    	
	        await loadData();

	        if (dimValID) {
	            await loadData2(dimValID);
	        }
	    } catch (e) {
	        console.error(e);
	        showDhxAlert("시스템 오류가 발생했습니다.");
	    }
	}

	/**
	 * @function doCallBack
	 * @description 팝업 닫기 후 우측 그리드 갱신
	 */		
	function addClose(avg){
		if (!window.dhx && window.__dhx_backup) {
			window.dhx = window.__dhx_backup;
		} else if (!window.dhx && window.dhx9) {
			window.dhx = window.dhx9;
		}
		loadData2(dimValID);
	}
	
</script>
 </body>
</html>
