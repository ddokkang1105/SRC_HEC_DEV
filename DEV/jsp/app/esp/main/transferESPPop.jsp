<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">	
	var srType = "${srType}";
	var esType = "${esType}";
	
	var searchData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=${srInfoMap.ClientID}";
	
	jQuery(document).ready(function() {
		
  		// button
  		//fnSetButton("save", "", "등록");
		// grid
		fnSRAreaLoad();
	});
	
	function fnSelect() {
		const selected = grid.selection.getCell().row;
		const srArea2 = selected.SRArea2;
		const srArea1 = selected.SRArea1;
		const srArea = (srArea2 === undefined || srArea2 === '' || srArea2 === null) ? srArea1 : srArea2;
		
		fetch("/olmapi/srAreaGroupMember/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&srArea=" + srArea)
		.then((response) => response.json())
		.then(data => grid2.data.parse(data));
		
		grid2.selection.removeCell();
		$("#memberList").show();
		
	}
	
	function fnSave(){
		
		const select = grid2.selection.getCell();
		if(select === "" || select === undefined || select === null) { alert("${WM00020}"); return; }
		else {
			if(!confirm("${CM00001}")){ return;}
			const selected = grid2.selection.getCell().row;
			var data = "srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&esType=${srInfoMap.ESType}&srType=${srInfoMap.SRType}&activityStatus=01"
				+"&speCode=${srInfoMap.Status}&procRoleTP=${srInfoMap.ProcRoleTP}&receiptUserID=${srInfoMap.ReceiptUserID}&newReceiptUserID=" + selected.MemberID + "&newReceiptTeamID=" + selected.TeamID
				+"&nextEmailCode=ESPMAIL002";
			var url = "transferESP.do";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
		
	}

	function fnCallBack(){
		opener.fnCallBackSR();
		self.close();
	}
	
</script>
<style>
.dhx_grid-cell:hover {
    cursor: pointer;
}

.hover-row {
	background-color: #f0f8ff !important; /* 연한 파란색 */
}
</style>
</head>

<body>
<div style="padding:10px; height:100%; overflow:auto;" id="mainLayer">
	
	<div class="page-title pdL10 pdR10 btn-wrap">
		${menu.ZLN0174} ${srAreaLabelNM1}/${srAreaLabelNM2} ${menu.LN00047}
	</div>
	
	<div style="width:100%; height:191px!important;" id="layout"></div>
	
	<div id="memberList" style="display:none;">
		<div class="page-title pdL10 pdR10 btn-wrap ">
			${menu.LN00004} ${menu.LN00047}
		</div>
		<div style="width:100%; height:300px!important;" id="layout2"></div>
	</div>
	
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>


</body>

<script type="text/javascript">
		let layout = new dhx.Layout("layout", {
			rows : [ {
				id : "a",
			}, ]
		});
		
		let layout2 = new dhx.Layout("layout2", {
			rows : [ {
				id : "a",
			}, ]
		});
		
		let gridData = "";
		
		function fnSRAreaLoad() {
			fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&roleFilter=${roleFilter}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&myCSR=${myCSR}&clientID=${clientID}")
			.then((response) => response.json())
			.then((data) => {
				grid.data.parse(data);
				if("${srInfoMap.SRArea2Name}" === '' || "${srInfoMap.SRArea1Name}" === null || "${srInfoMap.SRArea1Name}" === undefined){
					setSelectFilterByValue("${srInfoMap.SRArea1Name}", "SRArea1Name", "SRArea1Name", "");
				} else {
					setSelectFilterByValue("${srInfoMap.SRArea2Name}", "SRArea2Name", "SRArea2Name", "");
				}
			});
		}
		
		const grid = new dhx.Grid(null, {
			  columns: [
			        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			       	{ width:150, id: "CompanyName", header: [{ text: "${menu.ZLN0039}" , align: "center"},{content : "selectFilter"}], align: "center"},
			       	{ width:50, id: "APP/INFRA", header: [{ text: "${menu.LN00217}" , align: "center"},{content : "selectFilter"}], align: "center"},
			        { width:150, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" },{content : "inputFilter"}], align: "center"},
			        { width:260, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" },{content : "inputFilter"}], align: "center"},
			    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});

		layout.getCell("a").attach(grid);
		
		// header filter default setting
		function setSelectFilterByValue(targetValue, targetColumnId, resultColumnId, filterColumnId) {
		    const data = grid.data.serialize();

		 	// clientID 로 companyName 찾기
		    const row = data.find((row) => row[targetColumnId] === targetValue);
		    if (!row) return;

		    const resultValue = row[resultColumnId];

		    // filter setting
		    setTimeout(() => {
		    	// select type
		        const selectFilter = document.querySelector(".dhx_grid-header-cell[dhx_id='"+resultColumnId+"']>label>select.dhx_grid-filter--select");
		        if (selectFilter) {
		        	selectFilter.value = resultValue; // 필터 기본값 설정
		        	selectFilter.dispatchEvent(new Event("change")); // 필터링 적용
		        }
		        // input type
		        const inputFilter = document.querySelector(".dhx_grid-header-cell[dhx_id='"+resultColumnId+"']>label>input.dhx_input");
		        if (inputFilter) {
		        	inputFilter.value = resultValue; // 필터 기본값 설정
		        	inputFilter.dispatchEvent(new Event("input")); // 필터링 적용
		        }
		    }, 100);
		}
		
		
		grid.events.on("cellClick", function(row,column){
			fnSelect();
		});
		
		const grid2 = new dhx.Grid(null, {
			  columns: [
			        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			       	{ width:200, id: "ProcRoleTPName", header: [{ text: "${menu.LN00109}" , align: "center"},{content : "inputFilter"}], align: "center"},
			       	{ width:100, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center"},{content : "inputFilter"}], align: "center"},
			       	{ width:150, id: "TeamName", header: [{ text: "${menu.LN00104}" , align: "center"},{content : "inputFilter"}], align: "center"},
			       	{ width:150, id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center"},{content : "inputFilter"}], align: "center"},
			       	{ hidden: true, id: "MemberID", header: [{ text: "memberID", align: "center" }], align: "center" },
			    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: ""
		});
		
		layout2.getCell("a").attach(grid2);
		
		grid.events.on("cellMouseOver", (row, col) => {
		    const rowElement = document.querySelector('[dhx_id=' + row.id + ']');
		    if (rowElement) {
		        rowElement.classList.add("hover-row");
		        rowElement.addEventListener("mouseleave", function onLeave() {
		            rowElement.classList.remove("hover-row");
		            // 이벤트를 한 번만 처리하도록 제거
		            rowElement.removeEventListener("mouseleave", onLeave);
		        });
		    }
		});
		
		grid2.events.on("cellMouseOver", (row, col) => {
		    const rowElement = document.querySelector('[dhx_id=' + row.id + ']');
		    if (rowElement) {
		        rowElement.classList.add("hover-row");
		        rowElement.addEventListener("mouseleave", function onLeave() {
		            rowElement.classList.remove("hover-row");
		            // 이벤트를 한 번만 처리하도록 제거
		            rowElement.removeEventListener("mouseleave", onLeave);
		        });
		    }
		});
		
		grid2.events.on("cellClick", function(row,column){
			fnSave();
		});
		
</script>


</html>
