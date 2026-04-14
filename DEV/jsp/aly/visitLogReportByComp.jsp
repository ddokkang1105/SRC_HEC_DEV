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

<script type="text/javascript">
	var gridData = ${VisitLogReportByCompListData};
	var gridRowData = ${UserLogListData};
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
	
	/* 
	function fnGridRowList(resultdata){
		gridRowData = new dhx.Grid("gridRowData_container", {
			columns: [
				{ width: 120, id: "DAY_ID", header: [{ text: "DATE", align: "center"}, { content: "selectFilter" }], align: "center"},
				{ width: 120, id: "EMP_NO", header: [{ text: "Employee NO", align: "center"}, { content: "inputFilter" }], align: "center"},
				{ width: 120, id: "EMP_NM", header: [{ text: "Name", align: "center"}, { content: "inputFilter" }], align: "center"},
				{ width: 120, id: "TEAM_NM", header: [{ text: "TeamName", align: "center"}, { content: "selectFilter" }], align: "center"},
				{ width: 120, id: "GR_NM", header: [{ text: "GRTeamName", align: "center"}, { content: "selectFilter" }], align: "center"},
				{ width: 120, id: "COMP_NM", header: [{ text: "CompanyName", align: "center"}, { content: "selectFilter" }], align: "center"},
					],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
	}
	 */
	
	function fnDownData() {
		 fnGridExcelDownLoad();
	};
	
	function fnSearchList(){
		var url = "visitLogReportByComp.do";
		//ajaxSubmitNoAdd(document.GRProcessStatisticsFrm, url, "help_content");
		var target = "help_content";
		 
		ajaxPage(url, "&startDate="+$("#startDate").val()+"&endDate="+$("#endDate").val(), target);
	}

</script>

<body>
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	 <div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
	 </div>
	 <div class="countList" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="mgL50 floatL" style="position:relative;">
       		<input type="text" id="startDate" name="startDate" value="${startDate}"	class="input_off datePicker" size="8"
				style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			~
			<input type="text" id="endDate" name="endDate" value="${endDate}"	class="input_off datePicker" size="8"
				style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearchList()" value="Search" style="cursor:pointer;">			
		</li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="data" onClick="fnDownData()"></span>
		</li>	
    </div>
    <div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
	
	
	
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var gridRowData;
	function fnGridList(resultdata,totalCnt){
		
		grid = new dhx.Grid("grid", {
			columns: [
				{ width: 120, id: "COMP_NM", header: [{ text: "날짜", align: "center"}], align: "center"},
				{ width: 60, id: "totalEmpCNT", header: [{ text: "직원수"}], align: "center"},
				{ width: 60, id: "empCNT", header: [{ text: "방문자수"}], align: "center"},
				<c:forEach var="itemTypedata" items="${itemTypeList}" varStatus="status">

					{ width: 60, id: "${itemTypedata.ItemTypeCode}", header: [{ text: "${itemTypedata.Name}"}], align: "center"},
				
				</c:forEach>
				
					],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
		layout.getCell("a").attach(grid);
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	} 
	</script>
