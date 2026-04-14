<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<!-- 2025-03-26 소스 취약점 -->
	<%--<meta http-equiv="Content-Security-Policy" content="script-src 'self' 'sha256-0lrhsqqzoeiSmJAAXjKhQAnMB+uJl00lJt1tPHDqnzE=';"/>--%>

	<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
	<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
	<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
	<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
	<style>
		/* 그룹 헤더의 'Group' 글자 숨기기 */
		.dhx_grid-header-cell-text_content[aria-label="Sort by Group"] {
			font-size: 0px !important;
		}
	</style>

	<script>
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var accMode = "${accMode}";
		var isSubItem ="${isSubItem}";
		var itemID = "${s_itemID}";

		var layout, grid, pagination;

		// 라이브러리 유실 방지를 위한 안전 변수 선언
		window._preservedDhx = window.dhx || dhx;

		window.columns = [
			{ width: 110, id: "TeamRoleNM", header: [{text: "${menu.LN00119}", align:"center"}], align:"center", hidden: true },
			{ width: 50,  id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align: "center" }], align: "center", type: "boolean",  editable: true, sortable: false,
				template: function (text, row) {
					return row.$group ? "" : text;
				}},
			{ width: 80,  id: "TeamCode", header: [{ text: "${menu.LN00164}", align:"center" }], align: "center"},
			{ width: 130, id: "TeamNM", header: [{ text: "${menu.LN00247}", align:"center" }], align: "center"},
			{id: "TeamPath", header: [{ text: "${menu.LN00162}", align:"center" }], align:"left"},
			{ width: 80,  id: "AssignedDate", header: [{ text: "${menu.LN00078}", align:"center" }], align:"center" },
			{ width: 80,  id: "LastUpdated",   header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
			{ width: 80,  id: "RoleManagerNM", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center" },
			{ width: 80,  id: "TMRStatusNM", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center" },
			{ width: 80,  id: "TeamID", header: [{ text: "TeamID", align:"center" }], hidden:true },
			{ width: 80,  id: "TeamRoleID", header: [{ text: "TeamRoleID", align:"center" }], hidden:true },
			{ width: 80,  id: "RoleDescription", header: [{ text: "RoleDescription", align:"center" }], hidden:true },
			{ id: "Assigned", header: [{text: "Assigned"}], hidden:true}

		];

		$(document).ready(function(){

			// 초기 표시 화면 크기 조정
			$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");

			// 화면 크기 조정
			window.onresize = function() {
				$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");
			};

			$("#excel").click(() => fnGridExcelDownLoad());

			$("#memberName").keypress(function(e) {
				if (e.keyCode == 13) {
					searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
					return false;
				}
			});

			fnInitInterface();			// 레이아웃 및 그리드 초기화
			reloadItemTeamRoleList();	// 초기 데이터 로드
		});

		function setWindowHeight(){
			var size = window.innerHeight;
			var height = 0;
			if( size == null || size == undefined){
				height = document.body.clientHeight;
			}else{
				height=window.innerHeight;
			}return height;
		}

		/**
		 * @function fnInitInterface
		 * @description DHTMLX Layout 및 Grid 초기화 설정
		 */
		function fnInitInterface() {
			layout = new dhx.Layout("layout", {
				rows: [{ id: "a" }]
			});

			grid = new dhx.Grid(null, {
				columns: window.columns,
				group: { panel: false },
				groupable: true,
				autoWidth: true,
				resizable: true,
				selection: "row",
				tooltip: false,
				htmlEnable: true
			});

			layout.getCell("a").attach(grid);

			pagination = new dhx.Pagination("pagination", {
				data: grid.data,
				pageSize: 50
			});

			fnInitGridEvents();
		}

		/**
		 * @function fnInitGridEvents
		 * @description 그리드 내 발생하는 클릭 및 필터 이벤트 정의
		 */
		function fnInitGridEvents() {
			grid.events.on("cellClick", function(row, column) {

				if (row.$group) return;

				// 역할 클릭 시 상세 정보 모달창
				if (column.id == "group" && (userId == "${itemIDAuthorID}" || authLev == 1) ) {
					fnGoTeamRoleDetailPop(row);
					return;
				}

				// 일반 컬럼 클릭 시 조직정보 팝업 오픈
				if (column.id != "checkbox") {
					var teamID = row.TeamID;
					var w = "1200";
					var h = "800";
					var url = "orgMainInfo.do?id=" + teamID;
					window.open(url, "", "width="+w+", height="+h+", top=100, left=100, resizable=yes");
				}
			});

			grid.events.on("filterChange", function() {
				$("#TOT_CNT").html(grid.data.getLength());
			});
		}

		/**
		 * @function fnGoTeamRoleDetailPop
		 * @description 역할 상세 정보 조회를 위한 모달 오픈 함수
		 */
		function fnGoTeamRoleDetailPop(row) {
			if (typeof dhx === "undefined" || !dhx) { window.dhx = window._preservedDhx; }

			var url = "goTeamRoleDetailPop.do";
			var data = "?rowData=" + encodeURIComponent(JSON.stringify(row)) + "&s_itemID=" + itemID;

			var teamRoleDetailModal = openUrlWithDhxModal(url+data, "", "", 600, 380);

			window.fnCloseDetailModal = function() {
				if (teamRoleDetailModal) {
					teamRoleDetailModal.destructor();
					teamRoleDetailModal = null;
				}
			};
		}

		// [Add] - Click
		function fnGoTeamRoleTypePop(){

			if (typeof dhx === "undefined" || !dhx) {
				window.dhx = window._preservedDhx;
				var dhx = window._preservedDhx; 		// 로컬 스코프 대응
			}

			var url = "goTeamRoleTypePop.do";
			var w = 500;
			var h = 250;

			var teamRoleTypeModal = openUrlWithDhxModal(url, null, "", w, h);

			window.fnCloseDhxModal = function() {
				if (teamRoleTypeModal) {
					teamRoleTypeModal.destructor();
					teamRoleTypeModal = null;
				}
			};
		}

		var orgTeamTreePop;
		// [Add] -> [Next] - Click
		function fnGoOrgTreePop(roleTypeCode, roleTypeName){
			$("#roleTypeCode").val(roleTypeCode);

			var alreadyAssignedIDs = "";
			grid.data.forEach(function(row) {
				if (row.TeamRoleNM === roleTypeName) {
					if (alreadyAssignedIDs !== "") alreadyAssignedIDs += ",";
					alreadyAssignedIDs += row.TeamID;
				}
			});

			var url = "orgTreePop.do";
			var data = "?s_itemID=${s_itemID}&teamIDs=${teamIDs}&assignedIDs=" + alreadyAssignedIDs;
// 			fnOpenLayerPopup(url,data,doCallBack,617,436);
			orgTeamTreePop = openUrlWithDhxModal(url, data, "Search Organization" , 617, 436)
		}

		function doCallBack(){}

		// [Add] -> [Next] -> [Add] - Click
		function fnSaveTeamRole(teamIDs){
			if(!confirm("${CM00001}")){ return;}
			var roleTypeCode = $("#roleTypeCode").val();
			var url = "saveTeamRole.do";
			var target = "saveRoleFrame";
			var data = "teamIDs="+teamIDs+"&teamRoleCat=${teamRoleCat}"
					+"&roleTypeCode="+roleTypeCode+"&itemID=${s_itemID}&assigned=1";
			ajaxPage(url, data, target);
		}

		// [Add] -> [Next] -> [Add] - Callback
		// [Del] - Callback
		function fnTeamRoleCallBack() {
			orgTeamTreePop.hide();
			reloadItemTeamRoleList();
		}

		// [Del]
		function fnRemoveTeamRole(){
			var selectedCell = grid.data.findAll(function (data) {
				return data.checkbox;
			});
			if(!selectedCell.length){
				alert("${WM00023}");
			} else {
				if(confirm("${CM00002}")){
					var url = "deleteTeamRole.do";
					var teamRoleIDs =  new Array;
					var assigneds =  new Array;

					for(idx in selectedCell){
						teamRoleIDs[idx] = selectedCell[idx].TeamRoleID;
						assigneds[idx] = selectedCell[idx].Assigned;
					};
					var data = "teamRoleIDs="+teamRoleIDs+"&assigneds="+assigneds;
					var target = "saveRoleFrame";
					ajaxPage(url, data, target);
				}
			}
		}
	</script>
</head>
<body>
<div id="roleAssignDiv">
	<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="roleTypeCode" name="roleTypeCode" >
		<ul class="countList flex align-center justify-between">
			<li class="count">Total  <span id="TOT_CNT"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<c:if test="${accMode != 'OPS' }" >
				<input type="checkbox" id="removed" name="removed" onClick="reloadItemTeamRoleList()">&nbsp;Show hidden</li>
			</c:if>
			<li>
				<c:if test="${(itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1) and itemBlocked eq 0}" >
					<span class="btn_pack nobg "><a class="add" onclick="fnGoTeamRoleTypePop();" title="Add"></a></span>
					<span class="btn_pack nobg"><a class="remove" onclick="fnRemoveTeamRole()" title="Remove"></a></span>
				</c:if>
				<span class="btn_pack nobg white"><a class="xls"  title="Excel"  id="excel">></a></span>
			</li>
		</ul>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</form>
	<div style="width:0px;height:0px;display:none;">
		<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
	</div>
</div>
</body>
<script>

	/**
	 * @function reloadItemTeamRoleList
	 * @description 비동기 서버 데이터 조회 및 그리드 갱신
	 */
	async function reloadItemTeamRoleList() {

		resetUIState();

		var showRemoved = "N";
		if( document.all("removed").checked == true){ showRemoved="Y"; }

		var asgnOption = "2,3"; //해제,신규 미출력 & 릴리즈, 해제중 출력
		if(accMode == "DEV" || accMode == "" || accMode == null){
			asgnOption = "1,2"; //해제,해제중 미출력 & 신규, 릴리즈 출력
		}

		var sqlID = "role_SQL.getItemTeamRoleList";
		if(isSubItem === "Y"){ sqlID = "role_SQL.getSubItemRoleList"; }

		const requestData = { itemID, languageID, showRemoved, asgnOption, sqlID };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;

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
			updateGrid(data.data);
		} else {
			// 서버가 반환한 데이터가 유효하지 않을 경우
			const error = new Error("서버가 반환한 데이터가 유효하지 않음");
			error.type = 'INVALID_DATA';
			throw error;
		}
	}

	/**
	 * [UI 헬퍼] 마스터 체크박스 및 상태 초기화
	 */
	function resetUIState() {
		const masterChk = document.querySelector("#layout .dhx_grid-header [type='checkbox']");
		if (masterChk) {
			masterChk.checked = false;
		}
	}

	/**
	 * @function injectGroupIcons
	 * @description 그룹 행의 펼침/접힘 화살표 바로 뒤에 아이콘 삽입
	 */
	function injectGroupIcons() {
		const groupCells = document.querySelectorAll(
				"#layout .dhx_grid-cell[data-dhx-col-id='group'].dhx_grid-expand-cell"
		);

		groupCells.forEach(function(groupCell) {
			const arrow = groupCell.querySelector(".dhx_grid-expand-cell-icon");
			if (!arrow) return;

			// 이미 넣었으면 중복 방지
			if (groupCell.querySelector(".group-role-icon")) return;

			// 클래스 아이콘 생성
			const icon = document.createElement("span");
			icon.className = "group-role-icon dhx_tree-list-item__icon dxi icon-csh_organization-closed";
			icon.setAttribute("aria-hidden", "true");

			// 화살표 바로 뒤에 삽입
			arrow.insertAdjacentElement("afterend", icon);
		});
	}

	/**
	 * @function updateGrid
	 * @description 서버 데이터를 그리드에 파싱하고 그룹화 적용
	 * @param {Array} data - 서버에서 받은 JSON 데이터 배열
	 */
	function updateGrid(data) {
		grid.data.ungroup();
		grid.hideColumn("TeamRoleNM");
		grid.data.removeAll();

		if (data.length > 0) {
			deleteEmptyDataPageAndPrepareLayout(); // empty page 제거
			grid.setColumns(columns);
			grid.data.parse(data);
			$("#TOT_CNT").text(grid.data.getLength());
			grid.data.group([{ by: "TeamRoleNM" }]);

			setTimeout(function() {
				injectGroupIcons();
			}, 50);
		} else {
			if(pagination) pagination.destructor();
			showEmptyDataPage(); // empty page
			const emptyStateColumns = [
				{ width: 150, id: "temp_group_header", header: [{ text: "", align: "left" }], align: "left" },
				...columns
			];

			grid.setColumns(emptyStateColumns);
			$("#TOT_CNT").html(0);
		}
	}

	// [ui] empty page 생성
	var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CCCCCC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 6H11"/><path d="M21 12H11"/><path d="M21 18H11"/><path d="M3 6h2"/><path d="M3 12h2"/><path d="M3 18h2"/><path d="M5 6v12"/></svg>';
	function showEmptyDataPage() {
		$("#layout").attr("style","height:0px; width:100%;");

		let buttonFunc = "";
		let buttonTitle = "";
		let buttonStyle = "";

		const elements = document.querySelectorAll('.empty-wrapper.btns');

		if(elements.length > 0) return;
		if (("${itemIDAuthorID}" === '${sessionScope.loginInfo.sessionLogintype}' || "${sessionScope.loginInfo.sessionAuthLev }" === '1') && "${itemBlocked}" === '0') {

			let buttonFunc = "fnGoTeamRoleTypePop()";

			Promise.all([getDicData("ERRTP", "LN0042"), getDicData("BTN", "LN0026")])
					.then(([errtp042, btn026])=>{
						document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, '관련조직을 등록하세요.', buttonFunc, btn026.LABEL_NM, ""));
					})
		} else {
			Promise.all([getDicData("ERRTP", "LN0042")])
					.then(([errtp042])=>{
						document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, "", "", "", ""));
					})
		}
	}

	// [ui] empty page 제거
	function deleteEmptyDataPageAndPrepareLayout(){
		const elements = document.querySelectorAll('.empty-wrapper.btns');
		elements.forEach(el => el.remove());

		$("#layout").attr("style","height:"+(setWindowHeight() - 240)+"px; width:100%;");
		if (layout) layout.paint();

	}
</script>