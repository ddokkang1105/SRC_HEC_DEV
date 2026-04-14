<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>
	var mySCR = "${mySCR}";
	var scrMode = "${scrMode}";
	var scrStatus = "${scrStatus}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 225)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 225)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
				
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		
		fnSelect('scrStatus', data+"&category=SCRSTS", 'getDictionaryOrdStnm', scrStatus, 'Select');
  		fnSelect('regTeam', data, 'getSCRRegTeam', '', 'Select', 'scr_SQL');	
  		
		$("input.datePicker").each(generateDatePicker);
	
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		
		if("${reqDateLimit}" != null && "${reqDateLimit}" != ""){
			var now = new Date();
			$("#end_regDT").val(now.toISOString().substring(0,10));
			var bDay = new Date(now.setDate(now.getDate() - "${reqDateLimit}"));
			$("#st_regDT").val(bDay.toISOString().substring(0,10))
		}
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
	
	
	
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var url = "processItsp.do";
		var data = "&pageNum="+$("#currPage").val()
					+"&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID+"&mainType="+mainType;
		var target = "srListDiv";
		ajaxPage(url, data, target);
	}
	
</script>

<div id="scrDiv">
<form name="scrFrm" id="scrFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="floatL mgT10 mgB12" style="width:100%"><h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;System Change Request</h3></div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		    <col width="8%">
		    <col width="17%">
	    </colgroup>      
	     <tr>
	      	<!-- 상태 -->
	       	<th class="alignL pdL5">${menu.LN00027}</th>
	        <td>      
		       	<select id="scrStatus" Name="scrStatus" style="width:98%"></select>
	       	</td> 
	     	<!-- 작업계획시작일 -->
	        <th class="alignL pdL5">${menu.LN00061}</th>     
	        <td>     
	            <input type="text" id="st_planStartDT" name="st_planStartDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				
				~
				<input type="text" id="end_planStartDT" name="end_planStartDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				
	         </td> 
	        <!-- 작업계획시작일 -->
	        <th class="alignL pdL5">${menu.LN00221}</th>     
	        <td>     
	            <input type="text" id="st_planEndDT" name="st_planEndDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				
				~
				<input type="text" id="end_planEndDT" name="end_planEndDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				
	        </td>
	          <!-- 등록일 -->
	        <th class="alignL pdL5">${menu.LN00013}</th>     
	        <td>     
	            <input type="text" id="st_regDT" name="st_regDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				
				~
				<input type="text" id="end_regDT" name="end_regDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				
	        </td>	       
	     <tr>
	     	  <!-- SCR No. -->
	        <th class="alignL  pdL5">SCR No.</th>
	        <td  class= "alignL"><input type="text" class="text" id="scrCode" name="scrCode" value="" style="ime-mode:active;width:98%;" /></td>  
	        <!-- SCR 제목 -->
	        <th class="alignL pdL5" >${menu.LN00002}</th>     
		    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;width:98%;" /></td>    
	        <!-- 담당자 -->
	       	<th class="alignL pdL5">${menu.LN00004}</th>
	        <td><input type="text" class="text" id="regUser" name="regUser" value="" style="ime-mode:active;width:98%;" /></td>
	  		 <!-- 담당조직 -->
	        <th class="alignL pdL5">${menu.LN00153}</th>
	        <td  class= "alignL">     
		        <select id="regTeam" Name="regTeam" style="width:98%">
		            <option value=''>Select</option>
		        </select>
	        </td> 	        
	    </tr>      	 	
   	</table>
   
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
        	&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
    <div style="width:100%;" id="layout"></div>
	<div id="pagination" style="margin-top: 60px;"></div>
	
</form>
</div>

<script type="text/javascript">

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
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 120, id: "SCRCode", header: [{ text: "SR No." , align: "center" }, { content: "inputFilter" }], align: "center" },
        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }, { content: "inputFilter" }], align: "left" },
        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 100, id: "ProjectName", header: [{ text: "Project" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120, id: "RegTeamName", header: [{ text: "${menu.LN00153}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120,id: "RegUserName", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120,id: "ApproverName", header: [{ text: "${menu.LN00094}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 90, id: "RegDT", header: [{ text: "${menu.LN00013}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 90, id: "PlanEndDT", header: [{ text: "${menu.LN00221}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 90, id: "ScrCtsCls", header: [{ text: "CTS${menu.LN00118}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true,  id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
        { hidden: true,  id: "SCRID", header: [{ text: "SCRID" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

// excel 일반
function doExcel() {		
	fnGridExcelDownLoad(grid);
}

//row click event
grid.events.on("cellClick", function (row,column,e) {
	doDetail(row);
});

// filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

// 페이징
var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});

$("#TOT_CNT").html(grid.data.getLength());



function doSearchList(){ 
	if($("#st_planStartDT").val() != "" && $("#end_planStartDT").val() == "")		$("#end_planStartDT").val(new Date().toISOString().substring(0,10));
	if($("#st_planEndDT").val() != "" && $("#end_planEndDT").val() == "")			$("#end_planEndDT").val(new Date().toISOString().substring(0,10));
	if($("#st_regDT").val() != "" && $("#end_regDT").val() == "")							$("#end_regDT").val(new Date().toISOString().substring(0,10));
	
	var sqlID = "scr_SQL.getSCR";
	var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&scrMode=" + scrMode
		+ "&mySCR=" + mySCR
		+ "&subject=" + encodeURIComponent($("#subject").val())
		+ "&status=" + $("#scrStatus").val()
		+ "&regUserName=" + $("#regUser").val()
		+ "&regTeam=" + $("#subject").val()
		+ "&scrCode=" + $("#scrCode").val()
		+ "&st_planStartDT=" + $("#st_planStartDT").val()
		+ "&end_planStartDT=" + $("#end_planStartDT").val()
		+ "&st_planEndDT=" + $("#st_planEndDT").val()
		+ "&end_planEndDT=" + $("#end_planEndDT").val()
		+ "&st_regDT=" + $("#st_regDT").val()
		+ "&end_regDT=" + $("#end_regDT").val()
		+ "&regTeamID=" + $("#regTeam").val()
		+ "&finTestor=${finTestor}"
		+ "&loginUserId=${sessionScope.loginInfo.sessionUserId}"
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

function doDetail(row){
	var scrnType = "${scrnType}";
	var scrID = row.SCRID;
	var srID = row.SRID;
	var screenMode = "V";
	var url = "viewRFCPSCRDetail.do";		
	var data = "srID="+srID+"&scrID="+scrID+"&screenMode="+screenMode; 
	var w = 1100;
	var h = 800;
	window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}
</script>