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

	$(document).ready(function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		fnGridList();
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData;
	
	var grid = new dhx.Grid("grid_container",  {
		columns: [
			{ width: 50, id: "L1Code", header: [{ text: "L1Code", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "Identifier", header: [{ text: "Identifier", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "Level", header: [{ text: "Level", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT01", header: [{ text: "${menu.LN00028}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT03", header: [{ text: "${attrTypeMap.AT00003}", align: "center"}], align: "center", htmlEnable: true, editable: false },
			{ width: 50, id: "AT05", header: [{ text: "${attrTypeMap.AT00005}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT15", header: [{ text: "${attrTypeMap.AT00015}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT16", header: [{ text: "${attrTypeMap.AT00016}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT09", header: [{ text: "${attrTypeMap.AT00009}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT10", header: [{ text: "${attrTypeMap.AT00010}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT06", header: [{ text: "${attrTypeMap.AT00006}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT14", header: [{ text: "${attrTypeMap.AT00014}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT08", header: [{ text: "${attrTypeMap.AT00008}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT13", header: [{ text: "${attrTypeMap.AT00013}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT22", header: [{ text: "${attrTypeMap.AT00022}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT23", header: [{ text: "${attrTypeMap.AT00023}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT25", header: [{ text: "${attrTypeMap.AT00025}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "LOVAT26", header: [{ text: "${attrTypeMap.AT00026}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT30", header: [{ text: "${attrTypeMap.AT00030}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "LOVAT37", header: [{ text: "${attrTypeMap.AT00037}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT48", header: [{ text: "${attrTypeMap.AT00048}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT55", header: [{ text: "${attrTypeMap.AT00055}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT90", header: [{ text: "${attrTypeMap.AT00090}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT91", header: [{ text: "${attrTypeMap.AT00091}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT9963", header: [{ text: "${attrTypeMap.AT9963}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "AT9966", header: [{ text: "${attrTypeMap.AT9966}", align: "center"}], align: "center", editable: false },

			{ width: 50, id: "ZAT1", header: [{ text: "${attrTypeMap.ZAT0001}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT2", header: [{ text: "${attrTypeMap.ZAT0002}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT3", header: [{ text: "${attrTypeMap.ZAT0003}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT4", header: [{ text: "${attrTypeMap.ZAT0004}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT5", header: [{ text: "${attrTypeMap.ZAT0005}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT6", header: [{ text: "${attrTypeMap.ZAT0006}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT7", header: [{ text: "${attrTypeMap.ZAT0007}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT8", header: [{ text: "${attrTypeMap.ZAT0008}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT9", header: [{ text: "${attrTypeMap.ZAT0009}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT10", header: [{ text: "${attrTypeMap.ZAT0010}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "ZAT11", header: [{ text: "${attrTypeMap.ZAT0011}", align: "center"}], align: "center", editable: false },
			
			{ width: 50, id: "C100", header: [{ text: "공통", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C101", header: [{ text: "SPC", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C102", header: [{ text: "PC", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C103", header: [{ text: "SL", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C104", header: [{ text: "BR", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C105", header: [{ text: "GFS", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C106", header: [{ text: "SPL", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C107", header: [{ text: "S9", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C108", header: [{ text: "Pack", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C109", header: [{ text: "PB", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C110", header: [{ text: "샌드팜", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C111", header: [{ text: "샤니", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "C112", header: [{ text: "호남샤니", align: "center"}], align: "center", editable: false },
			
			
			{ width: 50, id: "Owner", header: [{ text: "${menu.LN00004}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "LastUpdateUser", header: [{ text: "${menu.LN00105}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center"}], align: "center", editable: false },
			{ width: 50, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center"}], align: "center", editable: false },



		],
		autoWidth: true,
		selection: "row",
		resizable: true,
		htmlEnable: true
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
		
	grid.events.on("cellClick", function(row,column,e){
		/* console.log("row.ItemId :"+row.ItemID+", column :"+column.id);
		if(column.id == "CSStatusName"){ // CS
		
			fnOpenInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
		
		}else if(column.id == "Identifier" || column.id == "ItemName"){
			fnOpenItemPop(row.ItemID);
		} */
	});	
		
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});
	
	layout.getCell("a").attach(grid);
	
	function fnGridList(){ 
		var param = "";				
	    $("#loading").fadeIn();   
		$.ajax({
			url:"custom/spc/zSpc_getAllProcessListGridData.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 		$("#loading").fadeOut();   
 	}

</script>

<body>
<form name="GRProcessStatisticsFrm" id="GRProcessStatisticsFrm" method="post" action="#" onsubmit="return false;">
	 <div class="child_search" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" ></span>
		</li>	
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

