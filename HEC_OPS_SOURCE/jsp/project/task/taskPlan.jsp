<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script>

	$(document).ready(function(){	
		$("input.datePicker").each(generateDatePicker);
	});
	
	function searchPopup(url){
		window.open(url,'window','width=650, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnEditTask(ctgry,ctgryName,curTask){
		var itemID = "${itemID}";
		var changeSetID = "${changeSetID}";
		var projectID = "${projectID}";
		var csrAuthorID = "${csrAuthorID}";
		var parentID = "${parentID}";
		var csrStatus = "${csrStatus}";
		
		var url = "editTask.do";
		var data = "&changeSetID="+changeSetID+"&itemID="+itemID+"&projectID="+projectID+"&category="+ctgry+"&categoryName="+ctgryName+"&csrAuthorID="+csrAuthorID+"&parentID="+parentID+"&curTask="+curTask+"&csrStatus="+csrStatus;				
		var target = "taskPlan";	
		ajaxPage(url,data,target);	
	}
	
	function fnFileDownLoad(taskTypeCode){	
		var originalFileName = $("#originalFileName"+taskTypeCode).val();
		var sysFileName = $("#sysFileName"+taskTypeCode).val();
		var seq = $("#fileID"+taskTypeCode).val();
		var url  = "fileDownload.do?seq="+seq;
	
		ajaxSubmitNoAdd(document.taskPlan, url,"blankFrame");
	}

</script>
</head>
<body>
	<!-- <div style="height:5px"></div>  -->
	<div id="objectInfoDiv" style="width:100%;overflow:auto;overflow-x:hidden;margin: 0;">
	<form name="taskPlan" id="taskPlan" action="#" method="post" onsubmit="return false;"> 
		<table class="tbl_task" width="100%" border="0" cellpadding="0" cellspacing="0"  >
		
		<colgroup>
		  <col>
		  <col width="13%">
		  <col width="7%">
		  <col width="7%">
		  <col width="7%">
		  <col width="7%">
          <col width="7%">
          <col width="7%">
          <col width="7%">
          <col width="7%">
          <col width="7%">
          <col width="7%">
          <col width="5%">
          <col width="5%">
          <col width="3%">
		  <col>
		  </colgroup>		
			<tr>
				<th class="viewtop" rowspan="2" >No</th>
				<th class="viewtop last2" rowspan="2">Task</th>
				<th class="viewtop last2" colspan="5">Plan
					<c:if test="${ ( sessionScope.loginInfo.sessionMlvl == 'SYS' || csrAuthorID == sessionScope.loginInfo.sessionUserId) && csrStatus == 'MOD'}">
						<c:if test="${sessionScope.loginInfo.sessionMlvl == 'SYS' || curTask == 'RDY' || curTask == 'PLAN1'}"> 
						<span class="btn_pack small icon" style="margin: 0 0 0 180;" ><span class="edit"></span>
						<input value="Edit" type="submit" onclick="fnEditTask('P','Plan','PLAN1');"></span>
					</c:if>
					</c:if> 
				</th>
				<th class="viewtop last2" colspan="5">Actual 
					<c:if test="${(csrAuthorID == sessionScope.loginInfo.sessionUserId || actorYN == 'Y')  && csrStatus != 'CLS'}">  
						<c:if test="${curTask != 'RDY' && curTask != 'PLAN1'}">
						<span class="btn_pack small icon" style="margin: 0 0 0 180;" ><span class="edit"></span>
						<input value="Edit" type="submit" onclick="fnEditTask('A','Actual');"></span>
						</c:if>
					</c:if>  
				</th>
				<th class="viewtop" colspan="2">Difference</th>
				<th class="last" rowspan="2">File</th>
			</tr>
			<tr>
				<th>${menu.LN00153}</th>
				<th>${menu.LN00004}</th>
				<th>${menu.LN00061}</th>
				<th>${menu.LN00221}</th>
				<th class="last2">M/D</th>
				<th>${menu.LN00153}</th>
				<th>${menu.LN00004}</th>
				<th>${menu.LN00063}</th>
				<th>${menu.LN00064}</th>
				<th class="last2">M/D</th>
				<th>Start</th>
				<th >End</th>
			</tr>
			<c:forEach var="taskList" items="${taskList}" varStatus="status">			
			<tr>				
				<td>${taskList.RNUM}</td>
				<td class="last2">${taskList.TaskTypeName}</td>				
				<!-- Plan -->
				<td>${taskList.TeamNameP}</td>
				<td>${taskList.ActorNameP}</td>
				<td>${taskList.StartDateP}</td>
				<td>${taskList.EndDateP}</td>
				<td  class="last2">${taskList.MandayP}</td>	
				
				<!-- Actual -->
				<td>${taskList.TeamNameA}</td>
				<td >${taskList.ActorNameA}</td>
				<td>${taskList.StartDateA}</td>
				<td>${taskList.EndDateA}</td>
				<td  class="last2">${taskList.MandayA}</td>
				<td>${taskList.StartDateGap}</td>	
				<td >${taskList.EndDateGap}</td>	
				<td class="last">				
				<c:if test="${taskList.FileID != null}"> 
					<img src="${root}${HTML_IMG_DIR}/btn_file_add.png" style="cursor:pointer;width:13;height:13;" alt="파일삭제" onclick="fnFileDownLoad('${taskList.TaskTypeCode}')">
				</c:if>
				<input type="hidden" id="originalFileName${taskList.TaskTypeCode}" name="originalFileName${taskList.TaskTypeCode}" value="${taskList.FileRealName}" >	
				<input type="hidden" id="sysFileName${taskList.TaskTypeCode}" name="sysFileName${taskList.TaskTypeCode}" value="${taskList.FileName}" >	
				<input type="hidden" id="fileID${taskList.TaskTypeCode}" name="fileID${taskList.TaskTypeCode}" value="${taskList.FileID}" >			
				</td>					
			</tr>
			</c:forEach>
		</table>
	</form>
	</div>	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>
