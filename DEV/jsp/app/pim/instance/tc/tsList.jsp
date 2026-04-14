<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var elmItemID = "${elmItemID}";
	
	fnSelect('status','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=INSTSTS','getDictionary','','Select');
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px; width:100%;");
		};	
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function gridOnRowSelect(instanceNo, instanceClass, procType){
		
		var url = "viewTSDetail.do";
		var data = "&instanceNo="+instanceNo+"&instanceClass="+instanceClass+"&masterItemID=${masterItemID}&procType="+procType;
		var target = "instanceListDiv";	
		ajaxPage(url, data, target);
	} 
	function fnRegistTCInst(){
		var url = "registerTS.do";
		var target = "instanceListDiv";
		var data = "masterItemID=${masterItemID}";
		ajaxPage(url, data, target);
	}
</script>
</head>
<body>
<div id="instanceListDiv" style="height:100%;">
<form name="plmFrm" id="plmFrm" action="" method="post" onsubmit="return false">
	<div class="child_search" >
		<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/bullet_blue.png"></img>&nbsp;&nbsp;<b>Test Plan List</b>
	   </li>
	</div>
	<div class="countList pdT10">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="pdL55 floatL">
			<li class="floatR">	   		
		  		 <c:if test="${sessionScope.loginInfo.sessionUserId ==  authorID}">
		    	<span class="btn_pack small icon"><span class="add"></span><input value="Register" type="submit" onclick="fnRegistTCInst()" style="cursor:hand;"></span>
				</c:if>
			</li>
     </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>
</div>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center", hidden : true },
	        { width: 100, id: "ProcType", header: [{ text: "Type", align: "center" }, { content: "inputFilter" }], align: "center", hidden : true },
	        { width: 200, id: "projectNo", header: [{ text: "No", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 500, id: "ProcInstanceName", header: [{ text: "PLAN Name", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 300, id: "csrName", header: [{ text: "${menu.LN00131}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 120, id: "OwnerName", header: [{ text: "${menu.LN01006}", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 150, id: "OwnerTeamName", header: [{ text: "${menu.LN00153}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 100, id: "StatusNM", header: [{ text: "${menu.LN00027}", align: "center" }], htmlEnable: true, align: "center" },
	        { width: 90, id: "StartDate", header: [{ text: "${menu.LN00063}", align: "center" }], align: "center" },
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00062}", align: "center" }], align: "center", hidden : true },
	        { width: 90, id: "EndDate", header: [{ text: "${menu.LN00064}", align: "center" }], align: "center", hidden : true },
	        { width: 40, id: "InstanceClass", header: [{ text: "InstanceClass", align: "center" }], align: "center", hidden : true },
	        { width: 30, id: "ProcInstNo", header: [{ text: "ProcInstNo", align: "center" }], align: "center", hidden : true },
	        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00078}", align: "center" }], align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("cellClick", function(row,column,e){
		gridOnRowSelect(row.ProcInstNo, row.InstanceClass, row.Type);
	}); 
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});
	

	function urlReload(){
		var sqlID = "instance_SQL.getProcInstList";
		var param = "processID=${masterItemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
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
		$("#TOT_CNT").html(grid.data.getLength());
	}

</script>


</body></html>