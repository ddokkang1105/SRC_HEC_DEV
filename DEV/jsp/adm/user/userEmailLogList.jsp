<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var gridData = ${UserEmailLogListData};
	
	gridData = gridData.map(item => ({
	    ...item,	            
	    ReceiverName: item.ReceiverName && item.ReceiverName.length === 2
	            ? item.ReceiverName[0] + "*" + item.ReceiverName[1]
	            : item.ReceiverName && item.ReceiverName.length > 2
	                ? item.ReceiverName[0] + "*".repeat(item.ReceiverName.length - 2) + item.ReceiverName[item.ReceiverName.length - 1]
	                : item.ReceiverName,

	}));
	var statusCSS;
	
	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() * 0.8 )+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		};
		
		fnGridList(gridData);
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSearchList(){
		var url = "userEmailLogList.do";
		var data="reportCode=${reportCode}&languageID=${languageID}&title=${title}&startDate="+$("#startDate").val()+"&endDate="+$("#endDate").val();
		var target = "changeInfoLstFrm";
		 
		ajaxPage(url, data, target);
	}
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	
	var grid;
	function fnGridList(resultdata){		
		grid = new dhx.Grid("grid", {
			columns: [
				{ width: 40, id: "RNUM", header: [{ text: "No.", align: "center" }], align: "center" },
				{ width: 150, id: "Time", header: [{ text: "발송일", align: "center" }], align: "center" },
				{ width: 150, id: "EmailCode", header: [{ text: "Email Code", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 180, id: "EmailName", header: [{ text: "Email Name", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 300, id: "Receiver", header: [{ text: "수신자 Email", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 120, id: "ReceiverName", header: [{ text: "수신자", align: "center" }, { content: "selectFilter" }], align: "center" },
				],

			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		$("#TOT_CNT").html(grid.data.getLength());
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(grid.data.getLength());
		});	
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
		
		layout.getCell("a").attach(grid);
	} 
	
	function exportXlsx() {
		fnGridExcelDownLoad();
	};
</script>

<body>
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	  <div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
	  </div>
	  <div class="countList">
	    	<li class="count">Total  <span id="TOT_CNT"></span></li>
	       <li class="pdL55 floatL">
	       		
	       		<input type="text" id="startDate" name="startDate" value="${startDate}" class="text datePicker" size="10" 
						style="width: 90px; min-width: 85px; text-aligh: left; padding-left: 5px;" onchange="this.value = makeDateType(this.value);"
						maxlength="10" autocomplete="off">

				~
				
					<input type="text" id="endDate" name="endDate" value="${endDate}" class="text datePicker" size="10" 
						style="width: 90px; min-width: 85px; text-aligh: left; padding-left: 5px;" onchange="this.value = makeDateType(this.value);"
						maxlength="10" autocomplete="off">  
				
				
		
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearchList()" value="Search" style="cursor:pointer;">
			
			
		</li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" onClick="exportXlsx()"></span>
		</li>	
	   </div>
	   <div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>