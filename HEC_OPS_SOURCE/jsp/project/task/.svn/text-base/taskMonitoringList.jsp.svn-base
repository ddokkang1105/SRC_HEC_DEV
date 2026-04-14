<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
 <!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	
	$(document).ready(function(){		
		$("input.datePicker").each(generateDatePicker);	
		$('.searchList').click(function(){
			doSearchList();	
		});
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		var isSearch = "${isSearch}";
		if(isSearch=="Y"){
			gridInit();	
			doSearchList();			
		}
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
		var d = setGridData(); 
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");

		fnSetColType(p_gridArea, 14, "img");
		fnSetColType(p_gridArea, 15, "img");
		
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(19, true);
		p_gridArea.setColumnHidden(20, true);
		p_gridArea.setColumnHidden(21, true);
		p_gridArea.setColumnHidden(22, true);
		p_gridArea.setColumnHidden(23, true);
		p_gridArea.setColumnHidden(24, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		p_gridArea.enablePaging(true,listScale,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		result.title 	= "${title}";
		result.key 	= "task_SQL.getTaskResultList";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00131},${menu.LN00130},Task,${menu.LN00004},${menu.LN00221},${menu.LN00063},${menu.LN00064},Gap,ProgramID,T-Code,${menu.LN00022},Down,File,FileID,SysFileName,OrigialFileName,FilePath,ChangeSetID,TaskTypeCode,ItemID,FltpCode,TaskIDA";
		result.cols 	= "ID|ItemName|ProjectName|CsrName|TaskName|ActorName|PlanEndDate|ActualStartDate|ActualEndDate|EndDateGap|ProgramID|T_Code|ChangeTypeName|AttachFileBtn|UploadFileBtn|FileID|SysFileName|OriginalFileName|FilePath|ChangeSetID|TaskTypeCode|ItemID|FltpCode|TaskIDA";//24
		result.widths = "30,80,*,100,80,70,80,80,80,80,40,100,100,60,40,50,50,50,50,50,50,50,50,50,50,";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
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
					+ "&currentDate=${thisYmd}";
					
		if($("#project").val() != null){
			result.data = result.data + "&projectID="+$("#project").val();
		}
		if($("#csrOrder").val() != null){
			result.data = result.data + "&csrOrderID="+$("#csrOrder").val();
		}
		if($("#taskTypeCode").val() != null){
			result.data = result.data +"&taskTypeCode="+$("#taskTypeCode").val();
		}
	
		return result;
	}
	
	function gridOnRowSelect(id, ind){
		if(ind==13){ // fileDown
			var originalFileName = p_gridArea.cells(id, 18).getValue();
			var sysFileName = p_gridArea.cells(id, 17).getValue();
			var filePath = p_gridArea.cells(id,19).getValue();
			var seq = p_gridArea.cells(id, 16).getValue();
			
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.taskMonitorFrm, url,"subFrame");
		}else if(ind == 1){ // item popup
			var itemID = p_gridArea.cells(id, 22).getValue(); 
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
	       		<font> <input type="text" id="fromPlanEndDate" name="fromPlanEndDate" class="text datePicker" value="${beforeYmd}"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10"></font>
					~
				<font><input type="text" id="toPlanEndDate" name="toPlanEndDate" class="text datePicker" value="${thisYmd}"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10"></font>
	       	</td>
	       	<!-- 완료일 -->
	       	<th>${menu.LN00064}</th>
	       	<td class="alignL">	       	
	       		<font><input type="text" id="fromActEndDate" name="fromActEndDate" class="text datePicker" value=""
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10"></font>
					~
				<font><input type="text" id="toActEndDate" name="toActEndDate" class="text datePicker" value=""
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10"></font>
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
       <li class="count">Total  <span id="TOT_CNT"></span></li>
       <li class="alignR" >
       	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" OnClick="doExcel()"></span>
	   </li>
    </div>
    <form name="taskMonitorFrm" id="taskMonitorFrm" action="#" method="post">
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>	
	</form>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	

<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
