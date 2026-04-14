<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<!-- 화면 표시 메세지 취득  -->
<script>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
</script>

<style type="text/css">
	div.gridbox_dhx_web table.obj tr td {
		height: 17px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		max-width: 150px;
		max-height: 100px;
	}

	/* 그룹 헤더의 'Group' 글자 숨기기 */
	.dhx_grid-header-cell-text_content[aria-label="Sort by Group"] {
		font-size: 0px !important;
	}
</style>

<!-- 2. Script -->
<script type="text/javascript">

	if (window.dhx && !window.dhx9) {
		window.dhx9 = window.dhx;
	}

	const s_itemID = "${s_itemID}";
	const languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	const myItem = "${myItem}";

	var gridLayout, grid;
	var descriptionWin = null;

	const columns = [
		{ width: 100, id: "DimTypeName", header: [{ text: "${menu.LN00088}" , align: "center" }], align: "center", hidden: true},
		{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align: "center"}], align: "center", type: "boolean", editable: true, sortable: false,
			template: function (text, row) {
				return row.$group ? "" : text;
			}},
		{ width: 100, id: "DimValueID", header: [{ text: "Code", align: "center" }], align: "center" },
		{ width: 200, id: "DimValueName", header: [{ text: "Value", align: "center" }], align: "center" },
		{ hidden: true, width: 100, id: "DimTypeID", header: [{ text: "DimTypeID", align: "center" }], align: "center" },
		{ fillspace : true, id: "DescAbrv", header: [{ text: "Description", align: "center", colspan:"2" }], align: "left" },
		{ width: 50, id: "ImgView", header: [{ text: "View Detail", align:"center" }], htmlEnable: true, align: "center",
			template: function (text, row) {
				if (row.$group || !row.ImgView) {
					return "";
				}
				return '<img src="${root}${HTML_IMG_DIR}/'+row.ImgView+'" width="25" height="25">';
			}
		}
	]

	$(document).ready(function() {

		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};

		initGrid();
		loadData();
	});

	/**
	 * @function initGrid
	 * @description DHTMLX Layout 및 Grid 초기 설정 및 이벤트 바인딩
	 */
	function initGrid() {
		gridLayout = new dhx.Layout("gridLayout", { rows: [{ id: "a" }] });

		grid = new dhx.Grid("grid", {
			columns: columns,
			group: { panel: false },
			groupable: true,
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
		});

		gridLayout.getCell("a").attach(grid);

		grid.events.on("cellClick", function(row,column,e){
			if(column.id == "ImgView"){ gridOnRowSelect(row); }
		});
	}

	/**
	 * @function loadData
	 * @async
	 * @description 서버로부터 Dimension 목록을 Fetch API를 통해 로드
	 */
	async function loadData() {
		$('#loading').fadeIn(150);

		// 마스터 체크박스 및 상태 초기화
		const masterChk = document.querySelector("#gridLayout .dhx_grid-header [type='checkbox']");
		if (masterChk) {
			masterChk.checked = false;
		}

		const sqlID = "dim_SQL.selectDim";
		const param = new URLSearchParams({
			s_itemID: s_itemID,
			languageID: languageID,
			sqlID: sqlID
		});

		const url = "getData.do?" + param;

		try {
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
				updateGrid(data.data || []);
			} else {
				// 서버가 반환한 데이터가 유효하지 않을 경우
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
	 * @function updateGrid
	 * @description 서버 데이터를 그리드에 파싱하고 그룹화 적용
	 * @param {Array} data - 서버에서 받은 JSON 데이터 배열
	 */
	function updateGrid(data) {
		// 기존 그룹핑 해제 (해제하지 않고 데이터 삭제 시 grouping 중복 생성)
		grid.data.ungroup();
		grid.hideColumn("DimTypeName");
		grid.data.removeAll();

		if (data.length > 0) {
			grid.setColumns(columns);
			grid.data.parse(data);
			$("#TOT_CNT").text(grid.data.getLength());
			grid.data.group([{ by: "DimTypeName" }]);
		} else {
			// 데이터가 0건일 때 헤더가 깨지는 현상 방지를 위해 빈 헤더 설정
			const emptyStateColumns = [
				{ width: 150, id: "temp_group_header", header: [{ text: "", align: "left" }], align: "left" },
				...columns
			];
			grid.setColumns(emptyStateColumns);
			$("#TOT_CNT").html(0);
		}
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
	 * @function gridOnRowSelect
	 * @description 상세 설명(Description)을 위한 DHTMLX Window 팝업 생성
	 * @param {Object} row - 클릭된 그리드 로우 데이터 객체
	 */
	function gridOnRowSelect(row) {
		const dimTypeId = row.DimTypeID;
		const dimValueId = row.DimValueID;
		const url = "viewItemDimDesc.do";
		const fullUrl = url + "?s_itemID=${s_itemID}&dimValueId=" + dimValueId + "&dimTypeId=" + dimTypeId;
		const w = 500;
		const h = 350;

		if (descriptionWin) {
			descriptionWin.destructor();
			descriptionWin = null;
		}

		descriptionWin = openUrlWithDhxModal(fullUrl, null, "", w, h);
	}

	/**
	 * @function window.onSaveItemDimDescComplete
	 * @description 팝업(viewItemDimDesc.jsp)에서 저장 완료 시 호출되는 콜백
	 * 1. 목록 데이터 최신화 (loadData)
	 * 2. 팝업 창 닫기 및 객체 초기화
	 */
	window.onSaveItemDimDescComplete = function() {
		loadData();

		if (descriptionWin) {
			descriptionWin.destructor();
			descriptionWin = null;
		}
	};

	var dimTreePop;
	// [Assign] Click
	function assignOrg() {
		const url = "dimTreePop.do";
		const data = "s_itemID=" + s_itemID;
// 		fnOpenLayerPopup(url, data, function(){ doCallBack(); }, 617, 436);
		dimTreePop = openUrlWithDhxModal(url, data, "Search Dimension" , 617, 436)
	}
	function doCallBack(){}

	// [Assign] - Callback
	function assignClose(){
		if (window.dhx9) window.dhx = window.dhx9;
		
		dimTreePop.hide();
		
		loadData();
	}

	// [Del] Click
	async function delDimension() {
		const selectedRows = grid.data.findAll(row => row.checkbox === true);

		if (selectedRows.length === 0) {
			const [btn] = await Promise.all([
				getDicData("BTN", "LN0034")    // 닫기 버튼
			]);
			showDhxAlert("${WM00023}", btn.LABEL_NM);
			return false;
		}

		const [btnOk, btnCancel] = await Promise.all([
			getDicData("BTN", "LN0032"),   // 확인 버튼
			getDicData("BTN", "LN0033")    // 취소 버튼
		]);

		const proceedDeletion = () => {
			const validRows = selectedRows.filter(row => !row.$group && row.DimTypeID && row.DimValueID);

			if (validRows.length > 0) {
				const dimTypeIds = validRows.map(row => row.DimTypeID).join(",");
				const dimValueIds = validRows.map(row => row.DimValueID).join(",");

				const params = {
					s_itemID: s_itemID,
					dimTypeIds: dimTypeIds,
					dimValueIds: dimValueIds,
					alertType: "DHX"
				};

				const queryString = $.param(params);
				ajaxPage("delDimensionForItem.do", queryString, "blankFrame");
			}
		};

		// Fallback
		const _dhx = window.dhx9 || window.dhx;
		if (_dhx && _dhx.confirm) {
			showDhxConfirm("${CM00004}", proceedDeletion, null, btnOk.LABEL_NM, btnCancel.LABEL_NM);
		} else {
			if (confirm("${CM00004}")) proceedDeletion();
		}
	}

	// [Del] - Callback
	function doSearchList(){
		loadData();
	}

	// [Back] Click
	function goBack(){
		var url = "itemInfoMgt.do";
		var target = "actFrame";
		var data = "s_itemID=" + s_itemID
				+ "&languageID=" + languageID
				+ "&itemInfoPage=/itm/itemInfo/NewItemInfoMainV4";
		ajaxPage(url, data, target);
	}

</script>
<div class="pdT10">
	<div>
		<span class="flex align-center">
			<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
			<b>${menu.LN00088}</b>
		</span>
	</div>

	<ul class="countList flex align-center justify-between">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li>
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' || myItem == 'Y'}">
				<span class="btn_pack nobg"><a class="assign" onclick="assignOrg();" title="Assign"></a></span>
				<span class="btn_pack nobg white"><a class="del" onclick="delDimension();" title="Delete"></a></span>
			</c:if>
		</li>
	</ul>

	<div id="gridDiv" class="mgB10 clear">
		<div id="gridLayout" style="width:100%"></div>
	</div>
</div>

<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
