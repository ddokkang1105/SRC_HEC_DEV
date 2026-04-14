<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var grid_skin = "dhx_brd";
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});

	// XML 데이터 파싱
	var parser = new DOMParser();
	var xmlDoc = parser.parseFromString(`${xmlData}`, "text/xml");
	var rows = Array.from(xmlDoc.getElementsByTagName("row"));

	var gridColumns = [ 
		{ width: 100, id: "SRArea1Name", header: [{ text: "Domain/Status" , align: "center" }], align: "center" },
		{ width: 100, id: "REQCNT", header: [{ text: "접수대기" , align: "center" }], align: "center" },
		{ width: 100, id: "RCVCNT", header: [{ text: "접수" , align: "center" }], align: "center" },
		{ width: 100, id: "CSRCNT", header: [{ text: "변경검토" , align: "center" }], align: "center" },
		{ width: 100, id: "CNGCNT", header: [{ text: "변경 중" , align: "center" }], align: "center" },
		{ width: 100, id: "CMPCNT", header: [{ text: "조치 완료" , align: "center" }], align: "center" },
		{ width: 100, id: "CLSCNT", header: [{ text: "확인완료" , align: "center" }], align: "center" },
		{ width: 100, id: "TotalCNT", header: [{ text: "Total" , align: "center" }], align: "center" }
		];

	var gridData = {
		data: rows.map(row => {
			var rowData = {};
			var cells = Array.from(row.children);

			rowData["SRArea1Name"] = cells[0].textContent;
			rowData["REQCNT"] = cells[1].textContent; 
			rowData["RCVCNT"] = cells[2].textContent; 
			rowData["CSRCNT"] = cells[3].textContent; 
			rowData["CNGCNT"] = cells[4].textContent; 
			rowData["CMPCNT"] = cells[5].textContent; 
			rowData["CLSCNT"] = cells[6].textContent; 
			rowData["TotalCNT"] = cells[cells.length - 1].textContent; 

			return rowData;
		})
	};

	var grid = new dhx.Grid("grdGridArea", {
		columns: gridColumns,
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData.data
	});
	var total = grid.data.getLength();
	layout.getCell("a").attach(grid);
	
	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var url = "mainSRStatistics.do";
		var target = "mainSrStatList";		
		var data = "srType=ITSP";
		ajaxPage(url, data, target);
	}	
	
</script>
<div id="mainSrStatList">
	<form name="srRptFrm" id="srRptFrm" action="" method="post" >
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="grdGridArea" style="width:100%;height:240px;"></div>
		</div>
	</form>
</div>