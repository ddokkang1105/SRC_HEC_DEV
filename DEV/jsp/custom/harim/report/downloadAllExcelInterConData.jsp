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
	    	{ width: 60, id: "InterConCode", header: [{ text: "내부통제", align: "center", colspan : 9 }, { text: "ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "InterConName", header: ["", { text: "명칭", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 60, id: "InterConClass", header: ["", { text: "클래스", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 220, id: "Description", header: ["", { text: "개요", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 90, id: "AT910LOV", header: ["", { text: "통제방법", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "AT912", header: ["", { text: "계정과목명", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "AT903", header: ["", { text: "RISK명", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "AT927", header: ["", { text: "법인", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 220, id: "AT06", header: ["", { text: "비고/이슈", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "L5ID", header: [{ text: "연관 프로세스", align: "center", colspan : 2 }, { text: "프로세스ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "L5NAME", header: ["", { text: "프로세스명", align: "center" }, { content: "inputFilter" }], align: "left" },
		    { width: 100, id: "CreationTime", header: ["", { text: "생성일", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "LastUpdated", header: ["", { text: "수정일", align: "center" }, { content: "inputFilter" }], align: "center" },
	    	{ width: 80, id: "Owner", header: ["", { text: "수정자", align: "center" }, { content: "selectFilter" }], align: "center" },
		    { hidden : true, width: 0, id: "ItemID", header: ["", { text: "ItemID", align: "center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    
	});

	layout.getCell("a").attach(grid);
	

	$("#TOT_CNT").html(grid.data.getLength());
   
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
			delay = start + 120000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			fnGridExcelDownLoad('','Y','하림그룹 내부통제 List', 'custom_SQL.zharim_getAllExcelInterConList_gridList');
/* 			grid.export.xlsx({
			        url: "//export.dhtmlx.com/excel"
			        ,name: "하림그룹 To-Be Process 체계도" 
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
   grid.events.on("cellClick", function(row,column,e){
			doDetail(row.ItemID);
   }); 
   
    function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
   } 
		
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;내부통제 List</span>
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

</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>