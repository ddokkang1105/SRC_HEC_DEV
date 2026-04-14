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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
var totalCount = "${totalCount}";
$(function(){
	$("#TOT_CNT").html(totalCount);
	// 초기 표시 화면 크기 조정
	$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
	};
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
</script>
<style>
	.dhx_grid-row:hover {
		background: rgba(65, 152, 247, 0.15);
	    cursor: pointer;
	    box-shadow: 2px 0px 0px 0px #4265ee inset;
	    transition: background-color .2s ease-out;
	}
	.grid__cell_status-item {
	    background: rgba(0,0,0,.05);
	    color: #8792a7;
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
    }
    .new {
    	color: #0ab169;
    }
    .mod {
    	color: orange;
    }
    .cls {
    	color:#000000;
    }
</style>
</head>

<body>
<div id="connectionTypeDiv" style="display: block;height: 100%;overflow: hidden auto;">	
<form name="objectTypeList" id="objectTypeList" action="saveObject.do" method="post" onsubmit="return false;">
	<div class="flex align-center justify-between mgB10 mgT5">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR10">
			<span class="btn_pack small icon" onclick="fnDownload()"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</div>
</form>
	<div id="treeGridArea" style="width: 100%"></div>
	<div style="width: 100%;" id="layout"></div>
</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
	var statusCSS = "cls";
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var treeGridData = ${treeGridData};
	
	treeGridData.map((e) => {
	    if(e.parent === 0) {
	    	delete e.parent
	    	delete e.LastUpdated
	    }
	})
	
    treeGridData.forEach(item => {
        if (item.ParentIdentifier && item.ParentName) {
            item.ParentGroupTitle = item.ParentIdentifier + " " + item.ParentName;
        }
    });
	
	var treeGrid = new dhx.Grid("treeGridArea", {
	    columns: [
	    	{ id: "Identifier", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], width:250, htmlEnable: true,
	        	template: function (text, row, col) {
	        		let result = "";
	        		result = row.Identifier && row.Identifier + " "  + row.itemName;
	        		return result;
	        	}
			},
	        { id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }], width:400},
			{ id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "selectFilter" }], width:120, align:"center" },
	        { id: "AuthorName", type: "string", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "selectFilter" }], width:120, align:"center" },
	        { id: "StatusName", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "selectFilter" }], width:120, htmlEnable: true, align:"center", template: function (text, row, col) {
	        		let statusCSS = "";
	        		switch (row.Status) {
		        		case "NEW1" : statusCSS = "new"; break;
		    			case "MOD1" : statusCSS = "mod"; break;
		    			case "REL" : statusCSS = "cls"; break;
		    		}
	        		if(statusCSS) return '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>';
    			} 
	        },
	        { id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center"}], width:120, align:"center" },
	    ],
	    group: {
	        panel: false,
	        order: ["ParentGroupTitle"], 
	    },
	    autoWidth: true,
	    resizable: true,
	    data : treeGridData,
	});
	
// 	treeGrid.groupBy("ParentIdentifier");

	layout.getCell("a").attach(treeGrid);
	
// 	treeGridData.filter(function (item) {
// 		if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
//     });
	
	function fnDownload() {
		treeGrid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	}
	
	treeGrid.events.on("cellClick", function(row,column,e){
		if(row.parent != "treeGridArea"){
	    	 var itemID = JSON.stringify(row.id).replace(/\"/g, "");
	    	 fnOpenItemPop(itemID);
		}
	});
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
</script>
</body>
</html>