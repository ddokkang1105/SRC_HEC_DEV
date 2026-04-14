<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<!-- <link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css"> -->

<html>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var grid_skin = "dhx_brd";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		fnSelect('haederL1','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=OJ','getMasterL1List','${haederL1}','Select',"analysis_SQL","");
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
		{ hidden: true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		{ hidden: true, width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		{ width: 100, id: "Date", header: [{ text: "Date" , align: "center" }], align: "center" },
		{ width: 100, id: "totalMember", header: [{ text: "No. of Visitors", align: "center" }], align: "center" }
	];

	var gridData = {
		header: headerList,
		data: rows.map(row => {
			var rowData = {};
			var cells = Array.from(row.children);
			rowData["Date"] = cells[0].textContent;
			rowData["totalMember"] = parseInt(cells[1].textContent, 10);

			headerList.forEach((header, index) => {
				rowData[header.code] = parseInt(cells[index + 2].textContent, 10);
			});

			return rowData;
		})
	};

	headerList.forEach(header => {
		var moduleCountCell = xmlDoc.evaluate(`//row/cell[position() > 2 and not(text() = '0')]`, xmlDoc, null, XPathResult.ANY_TYPE, null);// 모듈 카운트가 0이 아닌 경우에만 header 추가
		var moduleCountValue = moduleCountCell.iterateNext();
		
		if (moduleCountValue) {
			gridColumns.push({ width: 100, id: header.code, header: [{ text: header.name, align: "center" }], align: "center" });
		}
	});


	var grid = new dhx.Grid("grdGridArea", {
		columns: gridColumns,
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData.data
	});
	layout.getCell("a").attach(grid);

	//조회
	function doSearchList(){
		var url = "visitLogStatisticsByDay.do";
		var target = "visitSDList";		
		var data = "haederL1="+$("#haederL1").val();
		ajaxPage(url, data, target);
	}	

	function fnSearchProchSum(){
		doSearchList();
	}	

</script>
<body>
<div id="visitSDList">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Daily Visit Log by Item Type</h3>
	</div>
		<div class="child_search">
			<ol>
				<li>&nbsp;&nbsp;${menu.LN00021}
					<select id="haederL1" name="haederL1" style="width:160px"></select>			
				</li>
				<li>
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()" />
				</li>
				<li class="floatR pdR20">
					<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				</li>
			</ol>
		</div>
		<form name="rptForm" id="rptForm" action="" method="post" >	
			<div id="gridDiv" class="mgB10 mgT5">
				<div id="grdGridArea" style="width:100%">
				</div>
			</div>
			<!-- END :: LIST_GRID -->			
		</form>
</div>
</body>

</html>