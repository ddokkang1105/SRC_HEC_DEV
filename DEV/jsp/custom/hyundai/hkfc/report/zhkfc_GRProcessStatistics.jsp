<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
	.edit {
		background: #4CAF50;
		color: #FFF
	}
	.my_сustom_сlass {
		background: greenyellow;
	}
	.grid__cell_status-item {
	    background: rgba(0,0,0,.05);
	    color: #8792a7;
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
    }
    .mod {
    	color: #0ab169;
    }
    .cls {
    	color:#ff5252;
    }
    .dhx_demo-exam-grid__controls__icon {
	    color: #fff;
	    width: 16px;
	    height: 16px;
	    font-size: 16px;
	    line-height: 16px;
	}
</style>

<script type="text/javascript">
	var gridData = ${GRProcessStatisticsList};
	var statusCSS;
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.65 )+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.65)+"px;");
		};
		
		var data = "&s_itemID=${s_itemID}";
		fnSelect('csVersion', data, 'getCSVersion', '', 'Select');	
		
		fnGridList(gridData, ${totalCnt});
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	function fnGridList(resultdata, totalCnt){
		$("#TOT_CNT").html(totalCnt);
		grid = new dhx.Grid("grid_container", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
//				{ width: 80, hidden : true, id: "ChangeSetID", header: [{ text: "ChangeSet ID", align: "center"}], align: "center"},
				{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" }], htmlEnable: true, align:"center",editable: false , template: function (text, row, col) {
	                return "<img src=${root}${HTML_IMG_DIR_ITEM}"+text+">";
	            } },
		        { width: 150, id: "ItemClassName", header: [{ text: "${menu.LN00016}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { id: "ItemName", header: [{ text: "${menu.LN00028}", align: "center"}, { content: "inputFilter" }], gravity:1, align: "left" },
		        { id: "PTeamName", header: [{ text: "부문", align: "center"}, { content: "selectFilter" }], gravity:1, align: "left" },
		        { width: 80, id: "Version", header: [{ text: "Version", align: "center"}], align: "center"},
		        /*
		        { width: 100, id: "AuthorName", header: [{ text: "${menu.LN00004}", align: "center"}, { content: "inputFilter"}], align: "center"},
		        { width: 100, id: "AuthorTeamName", header: [{ text: "${menu.LN00153}", align: "center"}, { content: "inputFilter"}], align: "center" },
		        { width: 120, id: "PjtName", header: [{ text: "${menu.LN00131}", align: "center"}, { content: "selectFilter"}], align: "center"},
		        { width: 120, id: "CsrName", header: [{ text: "${menu.LN00191}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        */
		        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00063}", align: "center"}], align: "center", htmlEnable: true, template: function (text, row, col) {
		        		switch (row.StatusCode) {
	        			case "MOD" : statusCSS = "mod"; break;
	        			case "CLS" : statusCSS = ""; break;
	        			}
		            return ( text != null ? '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>' : '');
		        	}
            	},
		        { width: 100, id: "CompletionDT", header: [{ text: "${menu.LN00070}", align: "center"}], align: "center", htmlEnable: true, template: function (text, row, col) {
		        		switch (row.StatusCode) {
	        			case "MOD" : statusCSS = "mod"; break;
	        			case "CLS" : statusCSS = ""; break;
	        			}
		            return ( text != null ? '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>' : '');
		        	}
            	},
			    { width: 100, id: "ApproveDate", header: [{ text: "${menu.LN00095}", align: "center"}], align: "center", align: "center", htmlEnable: true, template: function (text, row, col) {
		        		switch (row.StatusCode) {
	        			case "MOD" : statusCSS = ""; break;
	        			case "CLS" : statusCSS = "cls"; break;
	        			}
	            	return ( text != null ? '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>' : '');
	            	}
	        	},
		        
		        { width: 100, id: "ItemStatus", header: [{ text: "${menu.LN00027}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "ChangeTypeName", header: [{ text: "${menu.LN00022}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "CSStatusName", header: [{ text: "${menu.LN00012}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00042}", align: "center"}, { content: "selectFilter" }], htmlEnable: true, align:"center", template: function (text, row, col) {
		        		switch (row.StatusCode) {
		        			case "MOD" : statusCSS = "mod"; break;
		        			case "CLS" : statusCSS = "cls"; break;
		        		}
	                return '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>';
	            	}
		        },
	        
		    //    { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00063}", align: "center"}], align: "center"}, /* 시작일 */
		    //    { width: 100, id: "CompletionDT", header: [{ text: "${menu.LN00064}", align: "center"}], align: "center"}, /* 완료일 */
		    //    { width: 100, id: "ApproveDate", header: [{ text: "${menu.LN00296}", align: "center"}], align: "center"},  /* 시행일 */
		    //    { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center"}], align: "center"}, /* 수정일 */
		        { hidden: true, widht: 100, id: "ItemID", header:[{ text: "ItemID"}]},
		    //    { hidden: true, widht: 100, id: "StatusCode", header:[{ text: "StatusCode"}]}
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(grid.data.getLength());
		});	
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	} 
	
	layout.getCell("a").attach(grid);
	
	
	
	
	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};
	
	function fnSearchList(){
		var url = "zhkfc_GRProcessStatistics.do";
		//ajaxSubmitNoAdd(document.GRProcessStatisticsFrm, url, "help_content");
		var target = "help_content";
		 
		ajaxPage(url, "&selYear="+$("#selYear").val(), target);
	}

</script>

<body>
<form name="GRProcessStatisticsFrm" id="GRProcessStatisticsFrm" method="post" action="#" onsubmit="return false;">
	 <div class="child_search" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="pdL55 floatL">
			Year  &nbsp;&nbsp;
			<select name="selYear" id="selYear" style="width:150px;">
				<c:forEach var="data" items="${yearList}" varStatus="status">
				    <option
				    <c:if test="${data eq selYear}">selected="selected"</c:if>
				     value="${data}"> ${data} </option>
				</c:forEach>
			</select>
			&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchList()" style="cursor:pointer;"/>
		</li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" onClick="exportXlsx()"></span>
		</li>	
    </div>
    <div style="width: 100%;" id="layout"></div>
	<div style="width: 100%;" id="grid_container"><div id="pagination"></div></div>
	
	
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

