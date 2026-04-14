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
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      };
      
     $("#excel").click(function(){
    	doExcel();
	 });
      
     $("#Search").click(function(){
    	doSearchList();
		return false;
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
	    	{ width: 80, id: "ItemID", header: ["", { text: "ItemID", align: "center" }], align: "center" },
	    	{ width: 60, id: "L1Code", header: ["", { text: "L1 ID", align: "center" },{content:"selectFilter"}], align: "left" },
	    	{ width: 90, id: "Code", header: ["", { text: "ID", align: "center" },{content:"selectFilter"}], align: "left" },
	    	{ width: 80, id: "L1", header: [{ text: "프로세스 구조", align: "center", colspan : 4 }, { text: "L1", align: "center" },{content:"selectFilter"}], align: "left" },
	    	{ width: 100, id: "L2", header: ["", { text: "L2", align: "center" },{content:"selectFilter"}], align: "left" },
	    	{ width: 150, id: "L3", header: ["", { text: "L3", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 150, id: "L4", header: ["", { text: "L4", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 50, id: "Level", header: ["", { text: "Level", align: "center" }], align: "left" },
	    	{ width: 100, id: "STATUS", header: ["", { text: "상태", align: "center" },{content:"selectFilter"}], align: "left" },
	    	{ width: 250, id: "Description", header: ["", { text: "개요", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 230, id: "OPSTD", header: ["", { text: "운영기준", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 100, id: "ISSUES", header: ["", { text: "이슈 및 비고", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 120, id: "Frequency", header: ["", { text: "주기", align: "center" }], align: "left" },
	 		{ width: 70, id: "TKTIME", header: ["", { text: "소요시간", align: "center" }], align: "left" },
	 		{ width: 80, id: "CProc", header: ["", { text: "중요프로세스", align: "center" },{content:"selectFilter"}], align: "left" },
	 		{ width: 80, id: "DIVISION", header: ["", { text: "DIVISION", align: "center" },{content:"selectFilter"}], align: "left" },
	 		{ width: 100, id: "OwnerTeamName", header: ["", { text: "관리조직", align: "center" },{content:"selectFilter"}], align: "left" },
	 		{ width: 80, id: "Owner", header: ["", { text: "담당자", align: "center" },{content:"selectFilter"}], align: "left" },
	 		{ width: 180, id: "ExeDept", header: ["", { text: "수행부서", align: "center" },{content:"inputFilter"}], align: "left" },
	    	{ width: 180, id: "RelDept", header: ["", { text: "유관부서", align: "center" },{content:"inputFilter"}], align: "left" },
		
	    	  	
	    
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
   
   
   
   
   function doSearchList(){
	   var sqlID = "custom_SQL.zDongwon_getAllProcessList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
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
		//fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}
   
	var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			//fnGridExcelDownLoad();
			fnGridExcelDownLoad('','','대림_Business Process Master List', 'custom_SQL.zDlmc_getAllProcessList_gridList');
			/*  grid.export.xlsx({
			        url: "//export.dhtmlx.com/excel"
			    }); */
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
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Business Process Master List </span>
	</div>	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
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