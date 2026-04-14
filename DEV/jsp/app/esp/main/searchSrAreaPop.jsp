<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
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

<script type="text/javascript">
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
		// button setting
  		fnSetButton("save", "", "Select");
  		getDicData("GUIDELN", "ZLN0005").then(data => document.querySelector("#GUIDELN-ZLN0005").innerText = data.LABEL_NM);
		
		fnSRAreaLoad();

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
	
	function fnSelect() {
		let srAreaName = "";
		const selected = grid.selection.getCell().row;
		if(!selected.SRArea2Name) srAreaName = selected.SRArea1Name;
		else srAreaName = selected.SRArea2Name;
		opener.setSrArea(selected.ClientID, selected.SRArea1, selected.SRArea2, srAreaName);
		self.close();
	}
</script>
</head>
<body>
	<div class="page-title pdL10 pdR10 btn-wrap">
		${menu.ZLN0024}
		<div class="btns">
			<button id="save" onclick="fnSelect()"></button>
		</div>
	</div>
	<p class="pdL10 pdR10 mgB10" style="color:#0761cf;" id="GUIDELN-ZLN0005"></p>
	<div style="width: 100%;" id="layout"></div>
</body>

<script type="text/javascript">
		let layout = new dhx.Layout("layout", {
			rows : [ {
				id : "a",
			}, ]
		});
		
		let gridData = "";
		
		let clientID = "${clientID}";
		if(clientID  == '' || clientID === undefined || clientID == null) {
			clientID = "${sessionScope.loginInfo.sessionClientId}";
		}
		
		function fnSRAreaLoad() {
			$('#loading').fadeIn(150);
			fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&roleFilter=${roleFilter}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&myCSR=${myCSR}&clientID=${clientID}")
			.then((response) => response.json())
			.then((data) => {
				grid.data.parse(data);
				if("${isCallCenter}" !== "Y") {
					if("${priorityClientID}"){
						setSelectFilterByValue("${priorityClientID}", "ClientID", "CompanyName", "CompanyName");
					} else {
						setSelectFilterByValue(clientID, "ClientID", "CompanyName", "CompanyName");
					}
					setSelectFilterByValue("APP", "APP/INFRA", "APP/INFRA", "");
				}
				$('#loading').fadeOut(150);
			});
		}
		
		const grid = new dhx.Grid(null, {
			  columns: [
			        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			       	{ width:120, id: "CompanyName", header: [{ text: "${menu.ZLN0039}" , align: "center"},{content : "selectFilter"}], align: "center"},
			       	{ width:100, id: "APP/INFRA", header: [{ text: "${menu.LN00217}" , align: "center"},{content : "selectFilter"}], align: "center"},
			        { width:200, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" },{content : "inputFilter"}], align: "center"},
			        { id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" },{content : "inputFilter"}], align: "center"},
			        { hidden:true, id: "ClientID", header: [{ text: "ClientID" , align: "center"}], align: "center"},
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
		        const selectFilter = document.querySelector(".dhx_grid-header-cell[dhx_id='"+resultColumnId+"']>label>select.dhx_grid-filter--select");
		        if (selectFilter) {
		        	selectFilter.value = resultValue; // 필터 기본값 설정
		        	selectFilter.dispatchEvent(new Event("change")); // 필터링 적용
		        }
		    }, 100);
		}
		
		// 더블클릭 이벤트 추가
		grid.events.on("cellDblClick", (row, column, event) => {
			fnSelect();
		});

</script>
</html>