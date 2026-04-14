<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 120)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 120)+"px;");
		};
		
		$("#excel").click(function (){
			grid.export.xlsx({
		        url: "//export.dhtmlx.com/excel"
		    });
		});
	});
	
	//===============================================================================
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>

</head>
<body>
	<div style="margin:0px 20px;">
		<div class="flex justify-between align-center">
			<div class="title-section" >Last updated within 6 months</div>
			<button class="cmm-btn" id="excel">Down</button>
		</div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</div>
	
	<script>
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdOTGridArea", {
		    columns: [
		        { width: 50, id: "RNUM", header: [{ text: "No" }], align: "center" },
		        { width: 150, id: "TypeCode", header: [{ text: "${menu.LN00042}", align:"center" }, { content: "selectFilter" }], align: "center" },
		        { width: 200, id: "Identifier", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }] },
		        { width: 350, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }] },
		        { width: 150, id: "TeamName", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align: "center" },
		        { width: 150,  id: "AuthorName", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align: "center" },
		        { width: 150,  id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "selectFilter" }], align: "center" },
		        { width: 150,  id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData,
		});
		
		layout.getCell("a").attach(grid);
		
		grid.events.on("cellClick", function(row,column,e){
	    	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ItemID+"&scrnType=pop";
	    	var w = 1200;
	    	var h = 900;
	    	itmInfoPopup(url,w,h);
		});
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 50,
		});
	</script>
		
</body>
</html>