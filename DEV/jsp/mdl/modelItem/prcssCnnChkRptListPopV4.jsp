<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<!-- 화면 표시 메세지 취득  -->
<script>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
</script>

<style type="text/css">
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
	
	const ItemID = "${ItemID}";
	const languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	const mdlCategory = "${mdlCategory}";	
	
	var gridLayout, grid;

	const columns = [
	    { width: 350, id: "IDITEM", header: [{ text: "", align: "center" }], hidden: true },
	    { width: 0, id: "Identifier2", header: [{ text: "", rowspan: 2, align: "center" }], hidden: true },
	    { width: 0, id: "itemName", header: [{ text: "", rowspan: 2, align: "center" }], hidden: true },
	    { width: 100, id: "Identifier", header: [{ text: "${menu.LN00178} Process", colspan: 2, align: "center" }, { text: "ID", align: "center" }] },
	    { width: 250, id: "prePstItemName", header: ["", { text: "Name", align: "center" }] },
	    { width: 65, id: "KBN", header: [{ text: "${menu.LN00178}", rowspan: 2, align: "center" }], align: "center" },
	    { width: 60, id: "VrfctnLink", header: [{ text: "Result", rowspan: 2, align: "center" }], align: "center" },
	]
	
	
	$(document).ready(function() {	
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '${DefDimTypeID}', 'Select');
		
		if("${DefDimTypeID}" != null && "${DefDimTypeID}" != '') {
			fnGetDimValue("${DefDimTypeID}");
		}
		
		bindEvents();
		initGrid();
		loadData();		
		
	});	
	
	/**
	 * @function bindEvents
	 * @description 브라우저 윈도우 리사이즈 시 그리드 영역 높이 자동 조절
	 */	
	function bindEvents() {
		$(window).on("resize", () => {
			const height = (window.innerHeight || document.body.clientHeight) - 260;
			$("#gridLayout").css("height", height + "px");
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
 			group: { panel: false },
			groupable: true,
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
		});

		gridLayout.getCell("a").attach(grid);

		grid.events.on("cellClick", function(row,column,e){
			if (row.$group) {
	            // [수정] grid.data 가 아니라 grid 객체에서 직접 호출합니다.
	            if (grid.expand && grid.collapse) {
	                if (grid.isExpanded(row.id)) {
	                    grid.collapse(row.id);
	                } else {
	                    grid.expand(row.id);
	                }
	            }
	            return; 
	        }
			
			var ItemID = "";
			if(column.id == "Identifier2" || column.id == "itemName"){
				ItemID = row.ItemID;
			}else if(column.id == "Identifier" || column.id == "prePstItemName"){
				ItemID = row.ObjectID;
			}else{
				return;
			}
			
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,ItemID);
		});
	}

	/**
	 * @function loadData
	 * @async
	 * @description 프로세스 연결성 체크 리스트를 서버로부터 로드
	 */
	async function loadData() {
	    // 1. UI 상태 초기화 및 로딩 시작
	    $('#loading').fadeIn(150); 
	    
	    if (grid && grid.data) {
	    	grid.data.ungroup();
	        grid.data.removeAll();
	    }
	    document.getElementById("TOT_CNT").innerHTML = "0";

	    // 2. 파라미터 준비
	    const dimValueID = document.getElementById("dimValueID")?.value || "";
	    const rptType = fnGetRadioValue();
	    const finalDimValueID = (dimValueID === "" && "${DefDimValueID}" !== "") ? "${DefDimValueID}" : dimValueID;

	    const requestData = {
	        ItemID: ItemID,
	        languageID: languageID,
	        mdlCategory: mdlCategory,
	        rptType: rptType,
	        dimValueID: finalDimValueID
	    };
	    
	    const params = new URLSearchParams(requestData).toString();

	    try {
	        // 3. fetch 호출 (POST 방식)
	        const response = await fetch("selectPrcssCnnChkListV4.do", {
	            method: "POST",
	            headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
	            body: params
	        });

	        // 4. HTTP 응답 상태 체크
	        if (!response.ok) {
	            const error = new Error("서버 내 오류 발생");
	            error.type = 'SERVER_ERROR';
	            error.status = response.status;
	            throw error;
	        }

	        const data = await response.json();

	        // 5. 비즈니스 로직 성공 여부(success 필드) 체크
	        if (!data.success) {
	            const errorMessage = data.message || "요청 처리 실패";
	            const error = new Error(errorMessage);
	            error.type = 'SERVER_ERROR';
	            throw error;
	        }

	        // 6. 데이터 유효성 검사 및 그리드 업데이트
	        if (data && data.data) { 
	        	updateGrid(data.data || []);
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
	 * @function updateGrid
	 * @description 서버 데이터를 그리드에 파싱하고 그룹화 적용
	 * @param {Array} data - 서버에서 받은 JSON 데이터 배열
	 */
		function updateGrid(data) {
			grid.data.ungroup();
			//grid.hideColumn("Identifier2");
			grid.data.removeAll();

			if (data.length > 0) {
				grid.setColumns(columns);
				grid.data.parse(data);
				$("#TOT_CNT").text(grid.data.getLength());
				grid.data.group([{ by: "IDITEM" }]);
			} else {
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
	 
	function gridOnRowSelect(id, ind){
		var ItemID = "";
		if(ind == 1 || ind == 2){
			ItemID = pp_grid1.cells(id, 7).getValue();
		}else if(ind == 3 || ind == 4){
			ItemID = pp_grid1.cells(id, 8).getValue();
		}else{
			return;
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function fnGetRadioValue() {
		var radioObj = document.all("rptType");
		
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
	}
	
	function fnGetDimValue(dimTypeID){
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
		fnSelect('dimValueID', data, 'getDimTypeValueId', '${DefDimValueID}', 'Select');
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body align="center" style="width:100%;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp; Consistency check of process connections</p>
	</div>
	 <div class="child_search" >
	   <li>
	   		 <input type="radio" name="rptType" value="1" checked >&nbsp;&nbsp;Outbound Check
	   		&nbsp;&nbsp;<input type="radio" name="rptType" value="2" >&nbsp;&nbsp;Inbound Check
	   		<c:if test="${classCode == 'CL01001' || classCode == 'CL01000'}">
	   		&nbsp;* Dimension&nbsp;
	   		<select id="dimTypeID" name="dimTypeID" style="width:120px;"  OnChange=fnGetDimValue(this.value);></select>
	   		<select id="dimValueID" name="dimValueID" style="width:120px;"><option value="">Select</option></select>	   		
	   		</c:if>&nbsp;&nbsp;&nbsp;&nbsp;
	   		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="loadData()" value=Search />
	   		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	   	</li>	
	</div>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridLayout" style="width:100%;height:700px;"></div>
	</div>	
   <iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</body>

</html>