<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 15px;
	width: auto;
}
.dhx_grid-cell .edit-button {
    border: 1px solid #0288d1;
    background:none;
}
.dhx_layout-rows {
	flex: 1 auto;
}
.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
	padding-right:20px;
}
.title-section {
	margin-top:0;
}
.dhx_form-group--disabled {
	opacity: .7;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px; width:100%;");
		};
		
		$("#excel").click(function (){
			grid.export.xlsx({
		        url: "//export.dhtmlx.com/excel"
		    });
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnItemPopUp(itemId){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
</script>
<body>
	<form action="" method="post" onsubmit="return false;">
		<div class="cfgtitle" >${reportName}</div>
	    <div class="flex justify-between mgB10 mgT10 mgL10 mgR10">
			<div class="count">Total  <span id="TOT_CNT"></span></div>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</div>
		<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none; height:0px;" frameborder="0" scrolling='no'></iframe>
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	var grid = new dhx.Grid("gridArea", {
	    columns: [
	        { width: 80, id: "PreL1ID", header: [{ text: "PRE L1 ID", align:"center"}, { content: "selectFilter" }], align:"center", template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre2L1ID; else return row.PreL1ID;
	    		}
	        },
	        { width: 100, id: "PreClass", header: [{ text: "PRE Level", align:"center" }, { content: "selectFilter" }], align:"center", template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre2Class; else return row.PreClass;
	    		}
	        },
	        { width: 150, id: "PreID", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre2ID; else return row.PreID;
	    		}
	        },
	        { id: "PreName", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable: true, template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre2Name; else return row.PreName;
	    		}
	        },
	        { width: 100, id: "Pre37", header: [{ text: "System Type", align:"center" }, { content: "selectFilter" }], template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre237; else return row.Pre37;
	    		}
	        },
	        { width: 150, id: "Pre13", header: [{ text: "System", align:"center" }, { content: "selectFilter" }], template: function (text, row, col) {
	        		if(row.Pre2ItemID) return row.Pre213; else return row.Pre13;
	    		}
	        },
	        { width: 80, id: "PostL1ID", header: [{ text: "POST L1 ID", align:"center" }, { content: "selectFilter" }], align:"center", template: function (text, row, col) {
	        		if(row.Post2ItemID) return row.Post2L1ID; else return row.PostL1ID;
	    		}
	        },
	        { width: 100, id: "PostClass", header: [{ text: "POST Level", align:"center" }, { content: "selectFilter" }], align:"center", template: function (text, row, col) {
	        		if(row.Post2ItemID) return row.Post2Class; else return row.PostClass;
	    		}
	        },
	        { width: 120, id: "PostID", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], template: function (text, row, col) {
	        		if(row.Post2ItemID) return row.Post2ID; else return row.PostID;
	    		}
	        },
	        { id: "PostName", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable: true, template: function (text, row, col) {
	        		if(row.Post2ItemID) return row.Post2Name; else return row.PostName;
	    		}
	        },
	        { width: 100, id: "Post37", header: [{ text: "System Type", align:"center" }, { content: "selectFilter" }], template: function (text, row, col) {
	        		if(row.Post2ItemID) return row.Post237; else return row.Post37;
	    		}
	        },
	        { width: 120, id: "Post13", header: [{ text: "System", align:"center" }, { content: "selectFilter" }], template: function (text, row, col) {
		        	if(row.Post2ItemID) return row.Post213; else return row.Post13;
		        }
    		},
	        { width: 85, id: "SysType", header: [{ text: "Sys. Type IF" }, { content: "selectFilter" }], align:"center" },
	        { width: 75, id: "System", header: [{ text: "System IF" }, { content: "selectFilter" }], align:"center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true
	});
	
	grid.data.sort({
	    by: "PreID",
	    dir: "asc"
	})
	
	grid.events.on("filterChange", function(row,column,e, item){
		$("#TOT_CNT").html(grid.data.getLength());
	});
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id == "PreName") fnItemPopUp(row.PreItemID);
		if(column.id == "PostName") 
			if(row.Post2ItemID) fnItemPopUp(row.Post2ItemID);
			else fnItemPopUp(row.PostItemID);
	});
	
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
</script>
</html>