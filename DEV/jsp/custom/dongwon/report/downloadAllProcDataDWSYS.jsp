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
	console.log(gridData);
	var grid = new dhx.Grid("grid", {
	    columns:[
	    	{ height : 100,width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
	    	{ width: 80, id: "L1Code", header: [{ text: "L1", align: "center" }], align: "left" },
	    	{ width: 120, id: "Path", header: [{ text: "Path", align: "center" }], align: "left" },
	    	{ width: 80, id: "Code", header: [{ text: "ID", align: "center" }], align: "left" },
	    	{ width: 90, id: "Name", header: [{ text: "명칭", align: "center" }], align: "left" },
	    	{ width: 80, id: "Level", header: [{ text: "Level", align: "center" }], align: "left" },
	    	{ width: 80, id: "Title", header: [{ text: "Title", align: "center" }], align: "left" },
	    	{ width: 180, id: "Description", header: [{ text: "개요", align: "center" }], align: "left" },
	    	{ width: 180, id: "Guideline", header: [{ text: "Guideline", align: "center" }], align: "left" },
	 		{ width: 120, id: "SYSTYPE", header: [{ text: "System Type", align: "center" }], align: "left" },
	 		{ width: 80, id: "MODUALAPP", header: [{ text: "모듈/APP", align: "center" }], align: "left" },
	 		{ width: 80, id: "FUNREQ", header: [{ text: "기능요건", align: "center" }], align: "left" },
	 		{ width: 100, id: "PDA", header: [{ text: "전자결재/PDA", align: "center" }], align: "left" },
	 		{ width: 100, id: "LEGACY", header: [{ text: "Legacy", align: "center" }], align: "left" },
	 		{ width: 100, id: "LEGACYIFID", header: [{ text: "Legacy IF ID", align: "center" }], align: "left" },
	 		{ width: 120, id: "ASIS", header: [{ text: "AS IS 현황", align: "center" }], align: "left" },
	    	{ width: 120, id: "TOBE", header: [{ text: "TOBE 변화사항", align: "center" }], align: "left" },
	    	{ width: 80, id: "KPI", header: [{ text: "${menu.LN00188}", align: "center" }], align: "left" },
	    	{ width: 80, id: "Input", header: [{ text: "Input", align: "center" }], align: "left" },
	    	{ width: 80, id: "Output", header: [{ text: "Output", align: "center" }], align: "left" },
	    	{ width: 80, id: "DePartmentInCharge", header: [{ text: "관련조직", align: "center" }], align: "left" },
	    	{ width: 90, id: "ORG", header: [{ text: "Role", align: "center" }], align: "left" },
	    	{ width: 180, id: "BusinessRule", header: [{ text: "Business Rule", align: "center" }], align: "left" },
			{ width: 80, id: "REMARK", header: [{ text: "비고/이슈", align: "center" }], align: "left" },
			{ width: 80, id: "PINUM", header: [{ text: "PI 과제번호", align: "center" }], align: "left" },
			{ width: 80, id: "PROG", header: [{ text: "Progress", align: "center" }], align: "left" },
	    	{ width: 80, id: "TCODE", header: [{ text: "화면코드", align: "center" }], align: "left" },
	    	{ width: 80, id: "SPEC", header: [{ text: "특기사항", align: "center" }], align: "left" },
	    	{ width: 100, id: "CHKPOINT", header: [{ text: "Check Point", align: "center" }], align: "left" },
	    	{ width: 100, id: "PROCTYPE", header: [{ text: "Process Type", align: "center" }], align: "left" },
	    	
	    	{ width: 80, id: "CMM", header: [{ text: "공통프로세스", align: "center" }], align: "left" },
	    	{ width: 50, id: "D01", header: [{ text: "소재", align: "center" }], align: "left" },
	    	{ width: 50, id: "D02", header: [{ text: "패키징", align: "center" }], align: "left" },
	    	{ width: 50, id: "D03", header: [{ text: "2차전지", align: "center" }], align: "left" },
// 	    	{ width: 50, id: "D04", header: [{ text: "건식", align: "center" }], align: "left" },
	    	{ width: 120, id: "C101", header: [{ text: "(국내)동원시스템즈", align: "center" }], align: "left" },
	    	{ width: 120, id: "C102", header: [{ text: "(국내)동원F&B", align: "center" }], align: "left" },
	    	
		    { width: 100, id: "Owner", header: [{ text: "Owner", align: "center" }], align: "center" },
		    { width: 100, id: "LastUpdated", header: [{ text: "Last Updated", align: "center" }], align: "center" },
		    { hidden : true, width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center" }
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