<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>

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
	var gridData = ${subItemHistoryList};
	var statusCSS;
	
	$(document).ready(function() {
		$("#grid_container").attr("style","height:"+(setWindowHeight() - 180 )+"px;");
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
		
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
		if (grid) {
	        grid.destructor();
	    }
		$("#TOT_CNT").html(totalCnt);
		grid = new dhx.Grid("grid_container", {
			columns: [
				{ width: 80, id: "MainVersion", header: [{ text: "Version", align: "center"}, { content: "selectFilter" }], align: "center", editable: false },
				{ width: 50, id: "SEQ", header: [{ text: "Seq.", align: "center"}], align: "center", editable: false },				
				{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" }], htmlEnable: true, align:"center",editable: false , template: function (text, row, col) {
	                return "<img src=${root}${HTML_IMG_DIR_ITEM}"+text+">";
	            } },
		        { width: 150, id: "ItemClassName", header: [{ text: "${menu.LN00016}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 200, id: "ItemName", header: [{ text: "${menu.LN00028}", align: "center"}, { content: "inputFilter"}], gravity:1, align: "left" },
		        { width: 70, id: "SubVersion", header: [{ text: "Sub Ver.", align: "center"}], htmlEnable: true, align: "center"},
		        { width: 100, id: "AuthorName", header: [{ text: "${menu.LN00004}", align: "center"}, { content: "inputFilter"}], align: "center"},
		        { width: 100, id: "AuthorTeamName", header: [{ text: "${menu.LN00153}", align: "center"}, { content: "inputFilter"}], align: "center" },
		        { width: 120, id: "PjtName", header: [{ text: "${menu.LN00131}", align: "center"}, { content: "selectFilter"}], align: "center"},
		        { width: 120, id: "CsrName", header: [{ text: "${menu.LN00191}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "ChangeTypeName", header: [{ text: "${menu.LN00022}", align: "center"}, { content: "selectFilter" }], align: "center"},
		        { width: 100, id: "CSStatusName", header: [{ text: "${menu.LN00027}", align: "center"}, { content: "selectFilter" }], htmlEnable: true, align:"center", template: function (text, row, col) {
		        		switch (row.StatusCode) {
		        			case "MOD" : statusCSS = "mod"; break;
		        			case "CLS" : statusCSS = "cls"; break;
		        		}
	                	return '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>';
	            	}
		        },
	        
		        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00063}", align: "center"}], align: "center"}, /* 시작일 */
		        { width: 100, id: "CompletionDT", header: [{ text: "${menu.LN00064}", align: "center"}], align: "center"}, /* 완료일 */
		        { width: 100, id: "ApproveDate", header: [{ text: "${menu.LN00296}", align: "center"}], align: "center"},  /* 시행일 */
		        { hidden: true, width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center"}], align: "center"}, /* 수정일 */
		        { hidden: true, widht: 100, id: "ItemID", header:[{ text: "ItemID"}]},
		        { hidden: true, widht: 100, id: "StatusCode", header:[{ text: "StatusCode"}]},
		        { width: 80, hidden : true, id: "ChangeSetID", header: [{ text: "ChangeSet ID", align: "center"}], align: "center"}
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		
		grid.events.on("cellClick", function(row,column,e){
			if(column.id == "SubVersion"){ // CS			
				fnOpenInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
			
			}else if(column.id == "Identifier" || column.id == "ItemName"){
				fnOpenItemPop(row.ItemID);
			}
		});	
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	} 
	
	layout.getCell("a").attach(grid);
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnOpenInfoView(avg1, avg2, avg3){	
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2+"&itemID="+avg3
				+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&mainMenu=${mainMenu}"
				+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}";
		var w = 1200;
		var h = 650; 
		itmInfoPopup(url,w,h);
	}
	
	function exportXlsx() {
		fnGridExcelDownLoad();
	};

</script>

<body>
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	 <div class="countList" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR20">	
			<span class="btn_pack nobg white"><a class="xls" onclick="exportXlsx()" title="Excel" ></a></span>
		</li>	
    </div>
    <div style="width: 100%;" id="layout"></div>
	<div style="width: 100%;" id="grid_container"></div><div id="pagination"></div>
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

