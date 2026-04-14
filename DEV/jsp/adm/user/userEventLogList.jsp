<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

<script type="text/javascript">
	var gridData = ${UserEventLogListData};
	
 	gridData = gridData.map(item => ({
	    ...item,
            
			    ChangeName: item.ChangeName && item.ChangeName.length === 2
		        ? item.ChangeName[0] + "*" + item.ChangeName[1]
		        : item.ChangeName && item.ChangeName.length > 2
		            ? item.ChangeName[0] + "*".repeat(item.ChangeName.length - 2) + item.ChangeName[item.ChangeName.length - 1]
		            : item.ChangeName,
		        
		            ChangeLoginID: item.ChangeLoginID && item.ChangeLoginID.length > 3
		            ? item.ChangeLoginID.slice(0, -3) + "***"
		            : item.ChangeLoginID && item.ChangeLoginID.length > 1
		                ? item.ChangeLoginID[0] + "*".repeat(item.ChangeLoginID.length - 1)
		                : item.ChangeLoginID,
		                
	   			 ChangedName: item.ChangedName && item.ChangedName.length === 2
	            ? item.ChangedName[0] + "*" + item.ChangedName[1]
	            : item.ChangedName && item.ChangedName.length > 2
	                ? item.ChangedName[0] + "*".repeat(item.ChangedName.length - 2) + item.ChangedName[item.ChangedName.length - 1]
	                : item.ChangedName,
	            
	                ChangedLoginID: item.ChangedLoginID && item.ChangedLoginID.length > 3
		            ? item.ChangedLoginID.slice(0, -3) + "***"
		            : item.ChangedLoginID && item.ChangedLoginID.length > 1
		                ? item.ChangedLoginID[0] + "*".repeat(item.ChangedLoginID.length - 1)
		                : item.ChangedLoginID
		                
	}));	 

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
		var url = "userEventLogList.do";
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
				{ width: 180, id: "ActionDescription", header: [{ text: "Event 정보", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 120, id: "ChangeLoginID", header: [{ text: "담당자 ID", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 100, id: "ChangeName", header: [{ text: "담당자 이름", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 180, id: "ChangeMemberTeamName", header: [{ text: "담당자 부서 명", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 120, id: "ChangedLoginID", header: [{ text: "변경자 ID", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 100, id: "ChangedName", header: [{ text: "변경자 이름", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 120, id: "Before", header: [{ text: "변경 전 데이터", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 300, id: "After", header: [{ text: "변경 후 데이터", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 180, id: "Date", header: [{ text: "시간", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 80, id: "IpAddress", header: [{ text: "접속 IP", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
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
		    pageSize: 50,
		});
		
		layout.getCell("a").attach(grid);
	} 
	
	function exportXlsx() {
		fnGridExcelDownLoad();
	};
</script>

<body>
<div class="pdL10 pdR10">
	<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
		  <div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		
			<h3 style="padding: 6px 0; border-bottom: 1px solid #ccc;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
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
</div>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>