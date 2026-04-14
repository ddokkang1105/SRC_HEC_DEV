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
	var gridData = ${AllProcessListData};
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
				{ width: 50, id: "L1Code", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "Identifier", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "Level", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT01", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT03", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT17", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT15", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT16", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT09", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "ZAT04", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "LOVZAT05", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT80", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "ZAT3013", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT08", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "AT13", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "Owner", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "OwnerTeamName", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "LastUpdateUser", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "LastUpdated", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "RASIC", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				<c:if test="${itemTypeCode eq 'OJ00001' }">
				{ width: 50, id: "connectionOutbound", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				{ width: 50, id: "connectionInbound", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center", editable: false },
				</c:if>

			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		
		grid.events.on("cellClick", function(row,column,e){
			console.log("row.ItemId :"+row.ItemID+", column :"+column.id);
			if(column.id == "CSStatusName"){ // CS
			
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
	
	
	
	
	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};
	

</script>

<body>
<form name="GRProcessStatisticsFrm" id="GRProcessStatisticsFrm" method="post" action="#" onsubmit="return false;">
	 <div class="child_search" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
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

