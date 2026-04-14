<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
      };
      
	  $("#excel").click(function (){
		  doExcel();
	  });
      
   });
   
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
 	var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns:[
	    	{ width: 71, id: "IT System", header: [{ text: "IT System", align: "center" },{content:"selectFilter"}], align: "center" },
	    	{ width: 161, id: "메뉴코드", header: [{ text: "메뉴코드", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 336, id: "메뉴코드내역", header: [{ text: "메뉴코드내역", align: "center" },{ content: "inputFilter" }], align: "left" },
	    	{ width: 90, id: "담당자명", header: [{ text: "담당자명", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 85, id: "담당자사번", header: [{ text: "담당자사번", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 100, id: "Legacy 담당자", header: [{ text: "Legacy 담당자", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 100, id: "ERP 담당자", header: [{ text: "ERP 담당자", align: "center" },{ content: "inputFilter" }], align: "center" },
	 		{ width: 75, id: "사용량", header: [{ text: "사용량(년)", align: "center" },{ content: "inputFilter" }], align: "center" },
	 		{ width: 63, id: "대상년도", header: [{ text: "대상년도", align: "center" },{content:"selectFilter"}], align: "center" },
	 		{ width: 90, id: "프로그램 구분", header: [{ text: "프로그램 구분", align: "center" },{content:"selectFilter"}], align: "center" },
	 		{ width: 63, id: "배치유무", header: [{ text: "배치유무", align: "center" },{content:"selectFilter"}], align: "center" },
	    	{ width: 87, id: "MAP 반영여부", header: [{ text: "MAP 반영여부", align: "center" },{content:"selectFilter"}], align: "center" },
	    	{ width: 89, id: "프로세스 레벨", header: [{ text: "프로세스 레벨", align: "center"}], align: "center" },
	 		{ width: 134, id: "프로세스ID", header: [{ text: "프로세스ID", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 221, id: "프로세스명", header: [{ text: "프로세스명", align: "center" },{ content: "inputFilter" }], align: "left" },
	    	{ width: 98, id: "프로세스담당자", header: [{ text: "프로세스담당자", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 80, id: "직책", header: [{ text: "직책", align: "center" }], align: "center" },
	    	{ width: 116, id: "부서", header: [{ text: "부서", align: "center" }], align: "center" },
	    	{ width: 98, id: "System Type", header: [{ text: "System Type", align: "center" }], align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});

	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});

	$("#TOT_CNT").html(grid.data.getLength());
   
   
   function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		//fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}
   
	//var delay = 0;
	function doExcel() {
		if(confirm("Excel download 를 진행 하시겠습니까?")){
			fnGridExcelDownLoad();
		}
/* 		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			//fnGridExcelDownLoad();
			 grid.export.xlsx({
			        url: "//export.dhtmlx.com/excel"
			        ,name: "하림그룹 To-Be Process 쳬계도" 
			    });
		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		} */
		
	} 

   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;System - Process</span>
	</div>	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack nobg white"><a class="xls"  id="excel" title="Excel"></a></span>
         </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
			<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>