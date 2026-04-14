<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
 <!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	
	$(document).ready(function(){		

		
		$("input.datePicker").each(generateDatePicker);	
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
	
		fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}','getPjtMbrRl','','Select');
		fnSelect('csrType','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=CNGT1','getDictionary','','Select');
		fnSelect('cboType','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&attrTypeCode=AT00063','getAttrTypeLov','','Select');

	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	
	function fnGetCsrOrder(parentID){
		if(parentID != ""){
		
			fnSelect('csrOrder','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','','Select');
			fnSelect('taskTypeCode','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID='+parentID,'getPjtTaskTypeCode','','Select');
		}
	}
	
 	function doSearchList(){
	
			let	sqlID = "task_SQL.getTaskResultList";

			let param ="&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&userID=${sessionScope.loginInfo.sessionUserId}"	
						+ "&screenMode=report"
						+ "&fromPlanEndDate="+$("#fromPlanEndDate").val()
						+ "&toPlanEndDate="+$("#toPlanEndDate").val()
						+ "&fromActEndDate="+$("#fromActEndDate").val()
						+ "&toActEndDate="+$("#toActEndDate").val()
						+ "&taskStatus="+$("#taskStatus").val()
						+ "&fileAttach="+$("#fileAttach").val()
						+ "&csrType="+$("#csrType").val()
						+ "&cboType="+$("#cboType").val()
						+ "&pageNum=" + $("#currPage").val()
						+ "&htmlImgDir= ${htmlImgDir}"
						+ "&currentDate=${thisYmd}"
						+"&sqlID="+sqlID;	
			
			if($("#project").val() != null){
				param +=  "&projectID="+$("#project").val();
			}
			if($("#csrOrder").val() != null){
				param += "&csrOrderID="+$("#csrOrder").val();
			}
			if($("#taskTypeCode").val() != null){
				param += "&taskTypeCode="+$("#taskTypeCode").val();
			}
		
	
				$.ajax({
					url:"jsonDhtmlxListV7.do",
					type:"POST",
					data:param,
					success: function(result){
				
						fnReload(result);
					
					 
					},error:function(xhr,status,error){
						console.log("ERR :["+xhr.status+"]"+error);
					}
				});	
		
	}
 	
 	function fnReload(newGridData){
 	
 	    grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	} 
	 

	
 	function gridOnRowSelect(row, col){ //id, ind
		if(col.id === "AttachFileBtn"){ // fileDown
			var originalFileName = row.OriginalFileName;
			var sysFileName = row.SysFileName;
			var filePath = row.FilePath;
			var seq = row.FileID;
			
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.taskMonitorFrm, url,"subFrame");
		}else if(col.id === "ID"){ // item popup
			var itemID = row.ItemID; 
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
			var w = 1200;
			var h = 900; 
			itmInfoPopup(url,w,h,itemID);
		}
	}	 
	
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
		
</script>
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Task Monitoring List</div>
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="9%">
		    <col width="11%">
		    <col width="8%">
		    <col width="11%">
		    <col width="8%">
		    <col width="11%">
		    <col width="11%">
		    <col width="11%">
	    </colgroup>
	    <tr>
	    	<!-- 프로젝트 -->
	       	<th class="viewtop">${menu.LN00131}</th>
	       	<td class="viewtop alignL">
	       		<select id="project" Name="project" style="width:120px;" OnChange="fnGetCsrOrder(this.value);"></select>
	       	</td>
	       	<!-- 변경오더 -->
	       	<th class="viewtop">${menu.LN00191}</th>
	       	<td class="viewtop alignL">
	       		<select id="csrOrder" Name="csrOrder" style="width:120px;">
	       			<option value='' >Select</option>
	       		</select>
	       	</td>
			<!-- 변경구분 -->
	       	<th class="viewtop">${menu.LN00022}</th>
	       	<td class="viewtop last alignL">	       	
	       		<select id="csrType" Name="csrType" style="width:120px;">
	       			<option value='' >Select</option>
	       		</select>
	       	</td>
	     </tr>
	     <tr>
	    	<!-- taskType -->
	       	<th class="">Task</th>
	       	<td class="alignL">
	       		<select id="taskTypeCode" Name="taskTypeCode" style="width:120px;">
	       			<option value='' >Select</option>
	       		</select>
	       	</td>
			<!-- status -->
	       	<th>${menu.LN00065}</th>
	       	<td class="alignL">
	       		<select id="taskStatus" Name="taskStatus" style="width:120px;">
	       			<option value='' >Select</option>
	       			<option value='1' >${menu.LN00118}</option>
	       			<option value='2' >${menu.LN00265}</option>
	       		</select>
	       	</td>
	       	<!-- 파일첨부  -->
	       	<th>${menu.LN00111}</th>
	       	<td class="last alignL">
	       		<select id="fileAttach" Name="fileAttach" style="width:120px;">
	       			<option value='' >Select</option>
	       			<option value='1' >Yes</option>
	       			<option value='2' >No</option>
	       		</select>
	       	</td>
	      
		</tr>
		 <tr>
	       	<!-- 완료예정일 -->
	       	<th>${menu.LN00221}</th>
	       	<td>	 
	       		<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
				<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-1 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>      	
	       		<input type="text" id="fromPlanEndDate" name="fromPlanEndDate" class="text datePicker" value="${beforeYmd}"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					~
				<input type="text" id="toPlanEndDate" name="toPlanEndDate" class="text datePicker" value="${thisYmd}"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
	       	</td>
	       	<!-- 완료일 -->
	       	<th>${menu.LN00064}</th>
	       	<td class="alignL">	       	
	       		<input type="text" id="fromActEndDate" name="fromActEndDate" class="text datePicker" value=""
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					~
				<input type="text" id="toActEndDate" name="toActEndDate" class="text datePicker" value=""
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
	       	</td>
			 <!-- CBO_TYPE -->
	        <th>${AT00063}</th>
	       	<td class="last alignL">
	       		<select id="cboType" Name="cboType" style="width:120px;">
	       			<option value='' >Select</option>
	       		</select>
	       	</td>
	     </tr>
	</table><br>
	<div class="countList">
       <li class="count">Total <span id="TOT_CNT"></span></li>
       <li class="alignR" >
       	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색"  OnClick="doSearchList()"/>
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" OnClick="doExcel()"></span>
	   </li>
  <form name="taskMonitorFrm" id="taskMonitorFrm" action="#" method="post"> 
	<div id="grdGridArea" style="width:100%"></div>
  </form> 
	<div id="pagination" class="mgT10"></div>
    </div>
	<!-- START :: PAGING -->
	<!-- END :: PAGING -->	


<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

<!-- dhtmlx9 ver upgrade -->

<script type="text/javascript">
 var layout = new dhx.Layout("grdGridArea", {
    rows: [
        {
            id: "a",
        },
    ]
}); 

	
var gridData = ${gridData};
 var grid = new dhx.Grid(null, {
    columns: [
        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 80,id: "ID",  header: [{ text: "${menu.LN00106}", align: "center" }], align: "center" },
        { gravity:1,id: "ItemName",         header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
        { width: 100,id:"ProjectName",      header: [{ text: "${menu.LN00131}", align: "center" }], align: "left" },
        { width: 80,id: "CsrName",          header: [{ text: "${menu.LN00130}", align: "center" }], align: "left" },
        { width: 70,id: "TaskName",         header: [{ text: "Task",             align: "center" }], align: "center" },
        { width: 80,id: "ActorName",        header: [{ text: "${menu.LN00004}",  align: "center" }], align: "center" },
        { width: 80,id: "PlanEndDate",      header: [{ text: "${menu.LN00221}",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
        { width: 80,id: "ActualStartDate",  header: [{ text: "${menu.LN00063}",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
        { width: 80,id: "ActualEndDate",    header: [{ text: "${menu.LN00064}",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
        { width: 50,id: "EndDateGap",       header: [{ text: "Gap",              align: "center" }], align: "center" },
        { width: 100,id:"ProgramID",        header: [{ text: "ProgramID",        align: "center" }], align: "left" },
        { width: 100,id:"T_Code",           header: [{ text: "T-Code",           align: "center" }], align: "left" },
        { width: 80,id: "ChangeTypeName",   header: [{ text: "${menu.LN00022}",  align: "center" }], align: "left" },
        {  width: 60,id: "AttachFileBtn",    header: [{ text: "Down",             align: "center" }], align: "center", htmlEnable: true },
        { width: 50,id: "UploadFileBtn",    header: [{ text: "File",             align: "center" }], align: "center", htmlEnable: true, hidden: true },
        { width: 50,id: "FileID",           header: [{ text: "FileID",           align: "center" }], hidden: true },
        { width: 50,id: "SysFileName",      header: [{ text: "SysFileName",      align: "center" }], hidden: true },
        { width: 50,id: "OriginalFileName", header: [{ text: "OrigialFileName",  align: "center" }], hidden: true }, // 원문 철자 유지
        { width: 50,id: "FilePath",         header: [{ text: "FilePath",         align: "center" }], hidden: true },
        { width: 50,id: "ChangeSetID",      header: [{ text: "ChangeSetID",      align: "center" }], hidden: true },
        { width: 50,id: "TaskTypeCode",     header: [{ text: "TaskTypeCode",     align: "center" }], hidden: true },
        { width: 50,id: "ItemID",           header: [{ text: "ItemID",           align: "center" }], hidden: true },
        { width: 50,id: "FltpCode",         header: [{ text: "FltpCode",         align: "center" }], hidden: true },
        { width: 50,id: "TaskIDA",          header: [{ text: "TaskIDA",          align: "center" }], hidden: true }

    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
$("#TOT_CNT").html(grid.data.getLength());
layout.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});
 


grid.events.on("cellClick", function(row, column, e) {
    var projectId  = row.ProjectID;

   gridOnRowSelect(row, column);
    
});
</script>
	
