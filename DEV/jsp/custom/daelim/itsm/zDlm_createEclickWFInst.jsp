<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>
<style>
	.saveCss{
		background: #eee;
		border:1px solid #ddd;
		border-radius:5px;
		padding: 1px 7px;
		color: #3F3C3C;
	}
</style>

<script>
			//그리드 전역변수
$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#layout").attr("style","height:800px; width:100%;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:800px; width:100%;");
	};
	fnReload();
});

</script>	
</head>
	
<div id="subItemListDiv" name="subItemListDiv" style="margin-bottom:5px;">		
    <div class="countList">
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR20">	
		</li>	
    </div>
	<div style="margin:5px;">
	<div style="width: 98%;" id="layout"></div>
	<div id="pagination"></div>
	</div>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = "";
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 120, id: "ID", header: [{ text: "TicketID", align:"center" }], align:"center"},
	        { width: 150, id: "STATUS_NAME", header: [{ text: "Ticket 진행 단계", align:"center" }], align:"center" },
	        { width: 280, id: "TITLE", header: [{ text: "제목", align:"center" }], htmlEnable: true, align:"left"},	        
	        { width: 150, id: "REG_DATE", header: [{text: "등록일", align:"center"}], align: "center"},
	        { width: 120, id: "REQ_USR_NAME", header: [{ text: "요청자", align:"center" }], align:"center"},
	        { width: 140, id: "DocTypeName", header: [{ text: "요청부서승인 요청/배포부서승인 요청", align:"center" }], align:"center" },
	       
	        {
				id: "createWF", width: 140, header: [{ text: "createWF", align: "center" }],
				htmlEnable: true, align: "center",
				template: function () {
						return '<button class="saveCss SaveBtn" >결재 생성</button>'
					}
        	},
        	{ width: 100, id: "REQ_DEPT_APP_OPIN", header: [{ text: "REQ_DEPT_APP_OPIN", align:"center" }], align:"center"},
        	{ width: 100, id: "RVW_APP_OPIN", header: [{ text: "RVW_APP_OPIN", align:"center" }], align:"center"},
        	
	        { width: 100, id: "RequestUserID", header: [{ text: "RequestUserID", align:"center" }], align:"center"},
	        { width: 100, id: "REQ_USR_ID", header: [{ text: "REQ_USR_ID", align:"center" }], align:"center"},
	        { width: 100, id: "SRID", header: [{ text: "SRID", align:"center" }], align:"center"},
	        { width: 100, id: "SpeCode", header: [{ text: "SpeCode", align:"center" }], align:"center"},
	        { width: 100, id: "ActivityLogID", header: [{ text: "ActivityLogID", align:"center" }], align:"center"},
	        { width: 100, id: "Category", header: [{ text: "Category", align:"center" }], align:"center"},
	        { width: 100, id: "SubCategory", header: [{ text: "SubCategory", align:"center" }], align:"center"},
	        { width: 100, id: "ClientID", header: [{ text: "ClientID", align:"center" }], align:"center"},
	        { width: 100, id: "ProjectID", header: [{ text: "ProjectID", align:"center" }], align:"center"},
	        { width: 100, id: "ActorID", header: [{ text: "ActorID", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){		
		 if(column.id == "createWF"){
			var url = "zDlm_createEclickWFMgt.do";
			var data = "srID="+row.SRID
					+ "&docCategory=SPE"
					+ "&ProjectID="+row.Project
					+ "&defWFID=WF004"				
					+ "&srRequestUserID="+row.RequestUserID
					+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
					+ "&speCode="+row.SpeCode
					+ "&customerNo="+row.ClientID
					+ "&activityLogID="+row.ActivityLogID
					+ "&srCode="+row.ID
					+ "&documentID="+row.ActivityLogID
					+ "&documentNo="+row.ID
					+ "&inhouse=Y"
					+ "&category="+row.Category
					+ "&subCategory="+row.SubCategory
					+ "&actorID="+row.ActorID
					+ "&docSubClass="+row.SpeCode;
			var target = "saveFrame";
			ajaxPage(url, data, target);
		 }
			
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
 	function fnReload(){ 
		var sqlID = "zDLM_SQL.getEclickWFList";
		var param = "sqlID="+sqlID;
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
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
</script>
</html>
