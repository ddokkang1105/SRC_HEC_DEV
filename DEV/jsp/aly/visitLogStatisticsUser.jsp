<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script>
   var grdGridArea;   
   var dateList ="";
	<c:forEach var="date" items="${dateList}" varStatus="status">
		dateList += ",${date}"
	</c:forEach>
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		};

		$("input.datePicker").each(generateDatePicker); 
	
		$("#excel").click(function(){
			doExcel();
		});
      
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});

		doSearchList();
	});
	
	function getDateList(){
		var selectDate = $("#selectDate").val();
		var dateList = "";
		for(var i=6; i>=0; i--){
			dateList += "," + dateAddDel(selectDate, -i, 'd');
		}
		return dateList;
	}
	
	function dateAddDel(sDate, nNum, type) {
	    var yy = parseInt(sDate.substr(0, 4), 10);
	    var mm = parseInt(sDate.substr(5, 2), 10);
	    var dd = parseInt(sDate.substr(8), 10);
	    
	    if (type == "d") {
	        d = new Date(yy, mm - 1, dd + nNum);
	    }
	    else if (type == "m") {
	        d = new Date(yy, mm - 1, dd + (nNum * 31));
	    }
	    else if (type == "y") {
	        d = new Date(yy + nNum, mm - 1, dd);
	    }
	 
	    yy = d.getFullYear();
	    mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
	    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;
	 
	    return '' + yy + '-' +  mm  + '-' + dd;
	}


	function setWindowHeight(){
		var size = window.innerHeight;
    	var height = 0;
		if( size == null || size == undefined){
        	 height = document.body.clientHeight;
      	}else{
        	height=window.innerHeight;
      	}return height;
	}
   
   //===============================================================================
   // BEGIN ::: GRID


	function setGridConfig(){
		var projectID;
		var result = new Object();
		result.title = "${title}";
		result.key = "analysis_SQL.getVisitLogStatisticsUser";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left,left,left,left,left,left,left";
		result.data = "selectDate="+$("#selectDate").val();
		return result;
	}
	
	function doSearchList(){
	  	var gridConfig = setGridConfig();
		var param = "";
		param += gridConfig.data + "&sqlID="+gridConfig.key
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
// 				console.log(result);
// 				fnReloadGrid(result);
				// 쿼리 analysis_SQL.getVisitLogStatisticsUser가 참고하는 [XBOLTADM].[OLM_VISIT_LOG_VIEW]이 아예 존재하지 않음
				// 데이터 로드 부분은 보류
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
		
		function fnReloadGrid(newGridData){
			grid.data.parse(newGridData);
				$("#TOT_CNT").html(grid.data.getLength());
		}	
	}
   
	var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			grdGridArea.toExcel("${root}excelGenerate");
		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		}
	} 

   function goBack() {
		var url = "objectReportList.do";
		var data = "s_itemID=${s_itemID}"; 
		var target = "proDiv";
	 	ajaxPage(url, data, target);
	}
   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Business Process Master List with Rule/To Check/Role </span>
	</div>	
	<div class="countList" >
		<ul>
			<li class="floatL count">Total  <span id="TOT_CNT"></span></li>
			<li class="floatL mgL40">
			   <input type="text" id="selectDate" name="selectDate" value="${thisYmd}"	class="text datePicker" size="10" style="width:80%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
	
			 </li>
			<li class="floatL mgL10">
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="search" />
			 </li>
			<li class="floatR">
			   <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			 </li>
		</ul>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagination" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>
<script>
	const dates = getDateList();
	const datesArray = dates.substring(1).split(',');
	const grdGridArea = new dhx.Layout("grdGridArea", {
		rows: [ { id: "a" } ] });
	getDateList()
	var grid = new dhx.Grid("grid", {
		columns: [
	    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	    	{ width: 150, id: "loginID", header: [{ htmlEnable: true, text: "${menu.LN00072}", align: "center" }], align: "center"},
			{ id: "visitorName", header: [{ text: "${menu.LN00028}", align: "center" } ], align: "center" },
			{ width: 150, id: "teamName", header: [{ text: "${menu.LN00247}", align: "center" }], align: "center"},
	    	{ width: 100, id: "D6", header: [{ text: datesArray[0], align: "center" } ], align: "center" },
	    	{ width: 100, id: "D5", header: [{ text: datesArray[1], align: "center" } ], align: "left" },
	    	{ width: 100, id: "D4", header: [{ text: datesArray[2], align: "center" } ], align: "center" },
	    	{ width: 100, id: "D3", header: [{ text: datesArray[3], align: "center" } ], align: "center" },
	    	{ width: 100, id: "D2", header: [{ text: datesArray[4], align: "center" } ], align: "center" },
	    	{ width: 100, id: "D1", header: [{ text: datesArray[5], align: "center" } ], align: "center" },
	    	{ width: 120, id: "today", header: [{ text: datesArray[6], align: "center" } ], align: "center" },
	    	{ width: 120, id: "total", header: [{ text: "${menu.LN00260}", align: "center" } ], align: "center" },
	    	],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
	});
	
	grdGridArea.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
		data: grid.data,
		pageSize: 50,
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("cellClick", (row, column, e) => handleGridRowSelect(row, column, e)); 

</script>