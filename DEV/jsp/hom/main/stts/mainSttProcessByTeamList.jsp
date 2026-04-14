<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<script type="text/javascript">
	var p_chart;
	$(document).ready(function(){
	//	fnChartLoad();
	});

	
</script>
<div  class="grid" style="width: 100%;height:290px;" id="grid_container"></div>

<script>
    var grid;
	var gridData = ${processTeamData};
	
	var grid = new dhx.Grid("grid_container",  {
	    columns: [
	        ${columns}
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	   
	    sortable : false,
	  	    
	     spans: [
	        { row: '1', column: 'Type1', rowspan: 2 },
	        { row: '3', column: 'Type1', rowspan: 2 },
	        { row: '5', column: 'Type1', colspan: 2 } 
	       
	    ], 
	    data: gridData,
	    
	});
	
	/* grid.events.on("headerCellClick", function(row,column,e){
		  fnGoTreeItem(itemID, true);
	}); */
	
	function fnClickTeamName(teamCode){
		
		fnGoDimTree(teamCode, true);
	}
	
</script>
