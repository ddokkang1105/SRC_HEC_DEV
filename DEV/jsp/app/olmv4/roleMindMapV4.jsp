<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxDiagram/codebase/diagramWithEditor.js?v=6.0.1"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxDiagram/codebase/diagramWithEditor.min.css?v=6.0.1">

<style>
	html, body {
		height:100%;
		padding:0;
		margin:0;
		overflow:hidden;
	}

	html, body, .dhx_diagram {
		background: #fff;
	}

	.dhx_sample-container__without-editor {
		height: calc(100% - 61px);
	}

	.dhx_sample-container__with-editor {
		height: calc(100% - 61px);
	}

	.dhx_sample-widget {
		height: 100%;
	}
</style>

<section style="margin-bottom: 10px;">
	<!-- default export to a PDF file -->
	<button class="cmm_btn btn--save" onclick="fnExport('pdf')">Export to PDF</button>
	<!-- default export to a PNG file -->
	<button class="cmm_btn btn--save" onclick="fnExport('png')">Export to PNG</button>
</section>

<div class="dhx_sample-widget" id="diagram" height="100%"></div>

<script>
	var roleMindMap = null;
	var s_itemID = "${param.s_itemID}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";

	// 클릭 처리 규칙: id prefix로 액션 변함
	const ID_PREFIX = Object.freeze({
		CLASS: "CLS",
		USER: "u",
		FOUR_D: "4d_",
		TEAM_REL: "tr_",
		EXCLUDED: "cxnPrc"
	});

	$(document).ready(function() {
		fnSearch();
	});

	/**
	 * 서버에서 mindmap 데이터 조회
	 */
	async function fnSearch() {
		$('#loading').fadeIn(150);

		const requestData = { s_itemID, languageID };
		const params = new URLSearchParams(requestData).toString();
		const url = "getRoleMindMapDataV4.do?" + params;

		try {
			const response = await fetch(url, { method: 'GET' });
			const data = await response.json();

			if (!response.ok) {
				const errorMessage = data.message || "서버 내 오류 발생";
				const error = new Error(errorMessage);
				error.type = 'SERVER_ERROR';
				error.status = response.status;
				throw error;
			}

			// 서버가 반환하는 성공여부 필드 체크
			if (!data.success) {
				const errorMessage = data.message || "요청 처리 실패";
				const error = new Error(errorMessage);
				error.type = 'SERVER_ERROR';
				throw error;
			}

			if (data && data.data) {
				initDiagram(data.data);
			} else {
				// 서버가 반환한 데이터가 유효하지 않을 경우
				const error = new Error("서버가 반환한 데이터가 유효하지 않음");
				error.type = 'INVALID_DATA';
				throw error;
			}

		} catch (err) {
			console.error("[ERROR] Fetch 실패:", err);
		} finally {
			$('#loading').fadeOut(150);
		}
	}

	/**
	 * Diagram 인스턴스를 생성하고 이벤트를 바인딩
	 * - 새 데이터 로드 시 기존 인스턴스를 파기하여 메모리 누수 방지
	 */
	function initDiagram(resultData) {
		const diagramList = resultData.diagramListData;
		const leftItems = resultData.leftItems;
		const rightItems = resultData.rightItems;

		if (roleMindMap) {
			roleMindMap.destructor();
		}

		roleMindMap = new dhx.Diagram("diagram", {
			type: "mindmap",
			typeConfig: {
				side : {
					left : leftItems,
					right : rightItems
				}
			},
		});

		// 노드 클릭: id 규칙에 따라 상세/팀정보/무시 처리
		roleMindMap.events.on("itemClick", function(id) {
			const action = resolveClickAction(id);
			if (action.type === "DETAIL") fnDetail(action.itemId);
			if (action.type === "TEAM") fnOpenTeamInfoMain(action.teamId);
		});

		roleMindMap.data.parse(diagramList);
	}

	/**
	 * 클릭된 노드 id로 수행할 액션을 결정
	 */
	function resolveClickAction(id) {
		if (!id) return { type: "NONE" };

		if (id === ID_PREFIX.EXCLUDED) return { type: "NONE" };
		if (id.startsWith(ID_PREFIX.CLASS)) return { type: "NONE" };
		if (id.startsWith(ID_PREFIX.USER)) return { type: "NONE" };

		if (id.startsWith(ID_PREFIX.FOUR_D)) {
			const parts = id.split("_");
			return { type: "DETAIL", itemId: parts[2] };
		}

		if (id.startsWith(ID_PREFIX.TEAM_REL)) {
			const parts = id.split("_");
			return { type: "TEAM", teamId: parts[1] };
		}

		return { type: "DETAIL", itemId: id };
	}

	/**
	 * Export 기능
	 * - dhtmlx built-in exporter 사용
	 */
	function fnExport(type) {
		if (roleMindMap) {
			if (type === 'pdf') roleMindMap.export.pdf();
			else if (type === 'png') roleMindMap.export.png();
		}
	}

	/**
	 * 팀 정보 화면: 별도 창으로 오픈
	 */
	function fnOpenTeamInfoMain(teamID){
		var w = "1200", h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "teamInfo", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

	/**
	 * 아이템 상세 팝업
	 */
	function fnDetail(avg){
		var url = "popupMasterItem.do?languageID="+languageID+"&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200, h = 900;
		if(typeof itmInfoPopup === 'function') {
			itmInfoPopup(url,w,h,avg);
		} else {
			window.open(url, "detail", "width="+w+", height="+h);
		}
	}
</script>