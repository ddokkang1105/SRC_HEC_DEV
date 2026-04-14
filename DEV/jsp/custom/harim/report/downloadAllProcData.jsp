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
	    	{ width: 80, id: "L1Code", header: ["", { text: "L1 ID", align: "center" }], align: "left" },
	    	{ width: 100, id: "Code", header: ["", { text: "ID", align: "center" }], align: "left" },
	    	{ width: 80, id: "L1", header: [{ text: "프로세스 구조", align: "center", colspan : 4 }, { text: "L1", align: "center" }], align: "left" },
	    	{ width: 80, id: "L2", header: ["", { text: "L2", align: "center" }], align: "left" },
	    	{ width: 80, id: "L3", header: ["", { text: "L3", align: "center" }], align: "left" },
	    	{ width: 80, id: "L4", header: ["", { text: "L4", align: "center" }], align: "left" },
	    	
	    	{ width: 90, id: "Name", header: ["", { text: "명칭", align: "center" }], align: "left" },
	    	{ width: 80, id: "Level", header: ["", { text: "Level", align: "center" }], align: "left" },
	    	{ width: 180, id: "Description", header: ["", { text: "개요", align: "center" }], align: "left" },
	    	{ width: 80, id: "Input", header: ["", { text: "Input", align: "center" }], align: "left" },
	    	{ width: 80, id: "Output", header: ["", { text: "Output", align: "center" }], align: "left" },
	    	{ width: 90, id: "ORG", header: ["", { text: "Role", align: "center" }], align: "left" },
	    	{ width: 80, id: "PI", header: ["", { text: "담당 PI", align: "center" }], align: "left" },
	    	{ width: 100, id: "CONSULT", header: ["", { text: "담당 컨설턴트", align: "center" }], align: "left" },
	    	{ width: 120, id: "SYSTYPE", header: ["", { text: "System Type", align: "center" }], align: "left" },
	 		{ width: 80, id: "MODULE", header: ["", { text: "모듈", align: "center" }], align: "left" },
	 		{ width: 80, id: "ITSYS", header: ["", { text: "IT SYSTEM", align: "center" }], align: "left" },
	 		{ width: 80, id: "TCODE", header: ["", { text: "화면코드", align: "center" }], align: "left" },
	 		{ width: 100, id: "FITGAP", header: ["", { text: "Fit/GAP", align: "center" }], align: "left" },
	 		{ width: 100, id: "FITRATE", header: ["", { text: "Fit Rate", align: "center" }], align: "left" },
	 		{ width: 120, id: "GAPID", header: ["", { text: "GAP ID", align: "center" }], align: "left" },
	    	{ width: 100, id: "GAPSOL", header: ["", { text: "GAP Solution", align: "center" }], align: "left" },
	    	  	
	    	{ width: 80, id: "B00", header: [{ text: "업종분야", align: "center", colspan : 3 },{text :"그룹공통"}], align: "left" },
	    	{ width: 80, id: "B01", header: ["", { text: "업종공통(가금)", align: "center" }], align: "left" },
	    	{ width: 80, id: "B02", header: ["", { text: "업종공통(축산)", align: "center" }], align: "left" },
	    	{ width: 80, id: "C01", header: [{ text: "사별특화", align: "center", colspan : 11 },{ text: "하림", align: "center" }], align: "left" },
	    	{ width: 80, id: "C02", header: ["", { text: "올품", align: "center" }], align: "left" },
	    	{ width: 80, id: "C03", header: ["", { text: "한강식품", align: "center" }], align: "left" },
	    	{ width: 80, id: "C04", header: ["", { text: "주원산오리", align: "center" }], align: "left" },
	    	{ width: 80, id: "C05", header: ["", { text: "싱그린FS", align: "center" }], align: "left" },
	    	{ width: 80, id: "C06", header: ["", { text: "선진", align: "center" }], align: "left" },
	    	{ width: 80, id: "C07", header: ["", { text: "팜스코", align: "center" }], align: "left" },
	    	{ width: 80, id: "C08", header: ["", { text: "NS홈쇼핑", align: "center" }], align: "left" },
	    	{ width: 80, id: "C09", header: ["", { text: "팬오션", align: "center" }], align: "left" },
	    	{ width: 80, id: "C10", header: ["", { text: "하림산업", align: "center" }], align: "left" },
	    	{ width: 80, id: "C11", header: ["", { text: "제일사료", align: "center" }], align: "left" },
	    	{ width: 80, id: "D01", header: [{ text: "사업분야", align: "center", colspan : 10 },{ text: "곡물", align: "center" }], align: "left" },
	    	{ width: 80, id: "D02", header: ["", { text: "해운", align: "center" }], align: "left" },
	    	{ width: 80, id: "D03", header: ["", { text: "사료", align: "center" }], align: "left" },
	    	{ width: 80, id: "D04", header: ["", { text: "축산(양돈)", align: "center" }], align: "left" },
	    	{ width: 80, id: "D05", header: ["", { text: "축산(가금)", align: "center" }], align: "left" },
	    	{ width: 80, id: "D06", header: ["", { text: "축산(한우&기타)", align: "center" }], align: "left" },
	    	{ width: 80, id: "D07", header: ["", { text: "도축가공(신선&식육)", align: "center" }], align: "left" },
	    	{ width: 80, id: "D08", header: ["", { text: "식품제조(육가공)", align: "center" }], align: "left" },
	    	{ width: 80, id: "D09", header: ["", { text: "유통판매", align: "center" }], align: "left" },
	    	{ width: 80, id: "D10", header: ["", { text: "기타", align: "center" }], align: "left" },
		    { width: 100, id: "Owner", header: ["", { text: "Owner", align: "center" }], align: "center" },
		    { width: 100, id: "LastUpdated", header: ["", { text: "Last Updated", align: "center" }], align: "center" },
		    { hidden : true, width: 0, id: "ItemID", header: ["", { text: "ItemID", align: "center" }], align: "center" }
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
			fnGridExcelDownLoad('','','하림그룹 To-Be Process 체계도');
			 /* grid.export.xlsx({
			        url: "//export.dhtmlx.com/excel"
			        ,name: "하림그룹 To-Be Process 쳬계도" 
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