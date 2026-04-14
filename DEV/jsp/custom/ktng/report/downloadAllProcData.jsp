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
	    	{ height : 100,width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }, { content: "inputFilter" }], align: "center" },
	    	{ width: 80, id: "L1Code", header: [{ text: "L1", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "Path", header: [{ text: "Path", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "Code", header: [{ text: "ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "Level", header: [{ text: "Level", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 90, id: "Name", header: [{ text: "명칭", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "Description", header: [{ text: "개요", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "Guideline", header: [{ text: "Guideline", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "TOCheck", header: [{ text: "Check Point", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "ownerIL", header: [{ text: "Owner(IL)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "ownerIT", header: [{ text: "Owner(IT)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "ownerAL", header: [{ text: "Owner(AL)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "ownerCST", header: [{ text: "Owner(컨설턴트)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "Input", header: [{ text: "Input", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "Output", header: [{ text: "Output", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "DePartmentInCharge", header: [{ text: "관련조직", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 90, id: "ORG", header: [{ text: "수행주체(Role)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "BusinessRule", header: [{ text: "Business Rule", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "systemReq", header: [{ text: "시스템 요구사항", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "APPLTYPE", header: [{ text: "Application Type", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 80, id: "MODUALAPP", header: [{ text: "모듈/APP", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "FIORIID", header: [{ text: "Fiori ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "TCODE", header: [{ text: "T-Code", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "fitGAP", header: [{ text: "Fit/GAP", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "GAPID", header: [{ text: "GAP ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "GAPTYPE", header: [{ text: "GAP 유형", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 140, id: "CHANGELEVEL", header: [{ text: "변화영향도 수준", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 200, id: "CHANGETYPE1_1", header: [{ text: "주요 변화 항목(신규업무)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 200, id: "CHANGETYPE1_2", header: [{ text: "주요 변화 항목(업무 수행 절차 변경)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 200, id: "CHANGETYPE1_3", header: [{ text: "주요 변화 항목(업무R&R변경)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 220, id: "CHANGETYPE2_1", header: [{ text: "주요 변화 항목(업무 수행 복잡도 증가)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 240, id: "CHANGETYPE2_2", header: [{ text: "주요 변화 항목(활용 시스템 난이도 증가)", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 120, id: "CHANGERESPON", header: [{ text: "변화관리 대응방안", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "KTNGSYS", header: [{ text: "KT&G 시스템", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "KGCSYS", header: [{ text: "KGC 시스템", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "YJPSYS", header: [{ text: "YJP 시스템", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "KTNGSCRNM", header: [{ text: "KT&G 화면 ID", align: "center" }, { content: "inputFilter" }], align: "left" },
		    { width: 100, id: "KGCSCRNM", header: [{ text: "KGC 화면 ID", align: "center" }, { content: "inputFilter" }], align: "left" },
		   	{ width: 100, id: "YJPSCRNM", header: [{ text: "YJP 화면 ID", align: "center" }, { content: "inputFilter" }], align: "left" },
		   	{ width: 100, id: "CHGASIS", header: [{ text: "변화사항(ASIS)", align: "center" }, { content: "inputFilter" }], align: "left" },
		   	{ width: 100, id: "FCTREQ", header: [{ text: "기능요건", align: "center" }, { content: "inputFilter" }], align: "left" },
		   	{ width: 80, id: "GAPSLT", header: [{ text: "GAP Solution", align: "center" }, { content: "inputFilter" }], align: "left" },
		    { width: 100, id: "CHGTOBE", header: [{ text: "변화사항(TOBE)", align: "center" }, { content: "inputFilter" }], align: "left" },
		    { width: 80, id: "C001", header: [{ text: "KT&G", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C002", header: [{ text: "태아산업", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C003", header: [{ text: "KT&G터키", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C004", header: [{ text: "KT&G브라질", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C005", header: [{ text: "KT&G러시아(제조)", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C006", header: [{ text: "KT&G미국", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C007", header: [{ text: "KT&G인니", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C008", header: [{ text: "KT&G대만", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C009", header: [{ text: "KGC", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C010", header: [{ text: "KGC예본", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C011", header: [{ text: "라이프앤진", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C012", header: [{ text: "코스모코스", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C013", header: [{ text: "KGC대만", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C014", header: [{ text: "KGC미국", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C015", header: [{ text: "KGC중국", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C016", header: [{ text: "KGC일본", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C017", header: [{ text: "길림한정", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C018", header: [{ text: "코스모중국", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C019", header: [{ text: "코스모홍콩", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 80, id: "C020", header: [{ text: "YJP", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 120, id: "C021", header: [{ text: "KT&G러시아(물류)", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "C022", header: [{ text: "상상스테이", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "Owner", header: [{ text: "Owner", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "Status", header: [{ text: "상태", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "LastUpdated", header: [{ text: "Last Updated", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { hidden : true, width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }, { content: "inputFilter" }], align: "center" }
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
	   var sqlID = "custom_SQL.zKTNG_getAllProcessList";
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
			fnGridExcelDownLoad();
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