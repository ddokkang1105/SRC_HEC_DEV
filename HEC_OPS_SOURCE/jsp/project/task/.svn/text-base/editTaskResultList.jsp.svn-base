<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00138" var="WM00138" arguments="20"/>

<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);				
		gridInit();		
		doSearchList();
		fnSelect('taskTypeCode','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}','getTaskTypeCode','','Select');
		fnSelect('actor','&userID=${sessionScope.loginInfo.sessionUserId}&itemTypeCode=${itemTypeCode}','getTskActor','','Select');
		
	});
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");

		fnSetColType(p_gridArea, 1, "ch");
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
		p_gridArea.setColumnHidden(25, true);
		p_gridArea.setColumnHidden(26, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		p_gridArea.enablePaging(true,listScale,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		var itemTypeCode = "${itemTypeCode}";
		result.title 	= "${title}";
		result.key 	= "task_SQL.getTaskResultList";
		result.header = "No,#master_checkbox,${menu.LN00106},${menu.LN00028},${menu.LN00131},${menu.LN00130},Task,${menu.LN00004},${menu.LN00221},${menu.LN00063},${menu.LN00064},Gap,ProgramID,T-Code,Down,File,FileID,SysFileName,OrigialFileName,FilePath,ChangeSetID,TaskTypeCode,ItemID,FltpCode,TaskIDA,TaskIDP,CsrAuthorID";//25
		result.cols 	= "CHK|ID|ItemName|ProjectName|CsrName|TaskName|ActorName|PlanEndDate|ActualStartDate|ActualEndDate|EndDateGap|ProgramID|T_Code|AttachFileBtn|UploadFileBtn|FileID|SysFileName|OriginalFileName|FilePath|ChangeSetID|TaskTypeCode|ItemID|FltpCode|TaskIDA|TaskIDP|CsrAuthorID";//24
		result.widths = "30,30,80,*,100,80,80,80,80,80,80,40,100,100,40,40,50,50,50,50,50,50,50,50,50,50,50";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,center,center,center,center,center,center,center,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}"	
					+ "&itemTypeCode=${itemTypeCode}"
					+ "&planEndDate="+$("#planEndDate").val()
					+ "&pageNum=" + $("#currPage").val()
					+ "&searchValue=" + $("#searchValue").val()
					+ "&searchKey=" + $("#searchKey").val()
					+ "&screenMode=myTask"; 
		if($("#taskTypeCode").val() != null){ result.data = result.data +"&taskTypeCode="+$("#taskTypeCode").val();	}
		if($("#taskStatus").val() != null){	result.data = result.data +"&taskStatus="+$("#taskStatus").val();}
		if($("#actor").val() != null){result.data = result.data +"&actor="+$("#actor").val();}
		
		return result;
	}
	
	function gridOnRowSelect(id, ind){
		if(ind==14){ 
			var originalFileName = p_gridArea.cells(id, 18).getValue();
			var sysFileName = p_gridArea.cells(id, 17).getValue();
			var filePath = p_gridArea.cells(id,19).getValue();
			var seq = p_gridArea.cells(id, 16).getValue(); 
			
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.taskResultFrm, url,"subFrame");
		}else if(ind == 15){
			var changeSetID = p_gridArea.cells(id, 20).getValue();
			var taskTypeCode = p_gridArea.cells(id, 21).getValue();
			var fltpCode = p_gridArea.cells(id, 23).getValue();
			var itemID = p_gridArea.cells(id, 22).getValue();
			var sysFile = p_gridArea.cells(id,19).getValue()+p_gridArea.cells(id, 17).getValue();
			var fileID = p_gridArea.cells(id,16).getValue();
			var taskID = p_gridArea.cells(id,24).getValue();
			var url = "taskFileUploadPop.do?changeSetID="+changeSetID+"&taskTypeCode="+taskTypeCode+"&fltpCode="+fltpCode+"&itemID="+itemID+"&sysFile="+sysFile+"&fileID="+fileID+"&taskID="+taskID;
			var w = 500;
			var h = 250;
			itmInfoPopup(url,w,h);
		}else if(ind == 2){
			var itemID = p_gridArea.cells(id, 22).getValue(); 
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
			var w = 1200;
			var h = 900; 
			itmInfoPopup(url,w,h,itemID);
		}
	}	
		
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${itemId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnEditTaskList(){
		var checkedRows = p_gridArea.getCheckedRows(1).split(",").length;
		
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}else if(checkedRows >20){
			alert("${WM00138}"); // 20개 이하 
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var itemIDArr = new Array;
		var changeSetIDArr = new Array;
		var taskTypeCodeArr = new Array;
		var taskIDPArr = new Array;
		var chkVal;
		var j = 0;
		
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				itemIDArr[j] = p_gridArea.cells2(i, 22).getValue();
				changeSetIDArr[j] = p_gridArea.cells2(i, 20).getValue();
				taskTypeCodeArr[j] = p_gridArea.cells2(i, 21).getValue();
				taskIDPArr[j] = p_gridArea.cells2(i, 25).getValue();
				j++;
			}
		}
		
		var url = "editTaskResult.do";
		var data = "&itemIDArr="+itemIDArr+"&changeSetIDArr="+changeSetIDArr+"&taskTypeCodeArr="+taskTypeCodeArr+"&pageNum=" + $("#currPage").val()+"&itemTypeCode=${itemTypeCode}&taskIDPArr="+taskIDPArr+"&mainVersion=${mainVersion}";
		var target = "taskResultFrm";	
		ajaxPage(url,data,target);	
	}
	
	function fnChangeActor(){
		var checkedRows = p_gridArea.getCheckedRows(1).split(",").length;
		
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var itemIDArr = new Array;
		var changeSetIDArr = new Array;
		var taskTypeCodeArr = new Array;
		var taskIDPArr = new Array;
		var chkVal;
		var j = 0;
		
		var userID = "${sessionScope.loginInfo.sessionUserId}";
		var csrAuthorID;
		var itemName;
		var taskName;
	
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				if(userID != p_gridArea.cells2(i, 26).getValue()){
					alert(p_gridArea.cells2(i, 3).getValue() +"["+ p_gridArea.cells2(i, 6).getValue()+"] 은"+"${WM00040}");
				}else{
					itemIDArr[j] = p_gridArea.cells2(i, 22).getValue();
					changeSetIDArr[j] = p_gridArea.cells2(i, 20).getValue();
					taskTypeCodeArr[j] = p_gridArea.cells2(i, 21).getValue();
					j++;
				}
			}
		}
				
		if(itemIDArr != ""){
			var url = "editTaskActorPop.do?";
			var data = "itemIDArr="+itemIDArr+"&changeSetIDArr="+changeSetIDArr+"&taskTypeCodeArr="+taskTypeCodeArr+"&itemID=${itemID}"; 
		    var option = "dialogWidth:450px; dialogHeight:470px;";
		    window.showModalDialog(url + data , self, option);
		}
	}
	
</script>
</head>
<body>
	<form name="taskResultFrm" id="taskResultFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; My Task
		</h3>
	</div><div style="height:10px"></div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="9%">
		    <col width="11%">
		    <col width="8%">
		    <col width="11%">
		    <col width="19%">
		 
	    </colgroup>
	    <tr>
	    	<!-- 완료일 -->
	       	<th class="viewtop last ">${menu.LN00221}</th>
	       	<td class="viewtop last  alignL">
	       		<font><input type="text" id="planEndDate" name="planEndDate" class="text datePicker" size="12" value="${thisYmd}"
					style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	       	</td>
	       	<!-- TASK -->
	       	<th class="viewtop last ">Task</th>
	       	<td class="viewtop last  alignL">
	       		<select id="taskTypeCode" name="taskTypeCode" style="width:120px;"></select>
	       	</td>
		
			<td class="last viewtop " >
	       		<select id="searchKey" name="searchKey" style="width:120px;">
					<option value="Name">${menu.LN00028}</option>
					<option value="ID">${menu.LN00106}</option>			
				</select>
				<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:210px;ime-mode:active;">
				
	       	</td>
	       
	     </tr>
	     <tr>
	    	<!-- 담당자  -->
	       	<th class="last">${menu.LN00004}</th>
	       	<td class="last alignL">
	       		<select id="actor" Name="actor" style="width:120px;">
	       			<option value='' >Select</option>
	       		</select>
	       	</td>
			<!-- 진행상태 -->
	       	<th class="last">${menu.LN00065}</th>
	       	<td class="last alignL">	       	
	       		<select id="taskStatus" Name="taskStatus" style="width:120px;">
	       			<option value='' >Select</option>
	       			<option value='1' >${menu.LN00118}</option>
	       			<option value='2' >${menu.LN00265}</option>
	       		</select>
	       	</td>
			<td class="last alignL"  >
	       		&nbsp;&nbsp;
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색"  onclick="doSearchList()"/>
		   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_pack small icon" style="margin: 0 0 0 0;" ><span class="edit"></span>
				<input value="Edit" type="submit" onclick="fnEditTaskList();"></span>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="gov"></span><input value="Gov" type="submit" onclick="fnChangeActor();"></span>
	       	</td>
		</tr>
	</table>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="height: 340px; width: 100%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>