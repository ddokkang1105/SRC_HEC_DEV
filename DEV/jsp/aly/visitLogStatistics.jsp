<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<!-- <script src="dhtmlxchart.js" type="text/javascript"></script>  -->

<html>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
	.gray{
    	background-color: #f2f2f2;
	}
</style>

<script>
	var p_chart;
	var grid_skin = "dhx_brd";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
		$("#excel").click(function(){  fnGridExcelDownLoad();  });		
	});
	
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
	var headerList = ${headerListJson};

	var gridColumns = [
		{ width: 100, id: "Date", header: [{ text: "Date" , align: "center" }], align: "center" },
		{ width: 100, id: "totalMember", header: [{ text: "접속자 수", align: "center" }], align: "center" },
	];

	headerList.forEach(header => {
		gridColumns.push({
			width: 100,
			id: header.code, 
			header: [{ text: header.name, align: "center" }], 
			align: "center"
		});
	});
	
	var gridData = {
		header: headerList,
		data: rows.map(row => {
			var rowData = {};
			var cells = Array.from(row.children);

			rowData["Date"] = cells[0] ? cells[0].textContent : "";
			rowData["totalMember"] = parseInt(cells[1].textContent, 10);
			rowData["Process"] = parseInt(cells[2].textContent, 10);

			headerList.forEach((header, index) => {
				rowData[header.code] = parseInt(cells[index + 2].textContent, 10);
			});

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
	layout.getCell("a").attach(grid);

	//cell css
	grid.data.forEach(function(item) {
        grid.addCellCss(item.id, "Date", "gray");
        grid.addCellCss(item.id, "Total", "gray");

        if ( item.Date === "Total") {
            grid.config.columns.forEach(function(column) {
                grid.addCellCss(item.id, column.id, "gray");
            });
        }
    });
	
	//조회
	function doSearchList(){
		var url = "visitLogStatistics.do";
		var target = "visitLogStList";		
		var data = "haederL1="+$("#haederL1").val();
		ajaxPage(url, data, target);
	}	

	
	// END ::: GRID	
	//===============================================================================
		
		
	// ===============================================================================
	// BEGIN ::: EXCEL && PDF
	// function doExcel() {		
	// 	p_gridArea.toExcel("${root}excelGenerate"); 
	// }
	// function doPdf() {		
	// 	p_gridArea.toPDF("${root}pdfGenerate");
	// }	
	// END ::: EXCEL && PDF
	// ===============================================================================
		
</script>

<body>
<div id="visitLogStList">
	<form name="rptForm" id="rptForm" action="" method="post" >
		<div class="floatL msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Visit Log Statistics</div>
		<div class="alignBTN">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel"></span>
		</div>
			
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="grdGridArea" style="width:100%"></div>
		</div>	
	</form>
</div>
</body>

</html>