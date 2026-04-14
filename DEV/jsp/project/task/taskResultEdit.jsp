<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00028" var="CM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00139" var="WM00139" arguments="날짜"/>

<script>
	$(document).ready(function(){	
		
		$("input.datePicker").each(generateDatePicker);
	});
	
	function fnGoBack() {
		var url = "editTaskResultList.do";
		var data = "pageNum=${pageNum}&itemTypeCode=${itemTypeCode}"; 
		var mainVersion = "${mainVersion}";
		var target = "actFrame";
		if(mainVersion == "mainV4"){target = "help_content";}
	 	ajaxPage(url, data, target);
	}
	
	function fnSaveTask(){		
		if(confirm("${CM00001}")){
			var url = "saveTaskResult.do"; 
			ajaxSubmit(document.editTaskResultFrm, url, "blankFrame");
		}
	}
	
	function fnFileUpload(changeSetID,taskTypeCode,taskID,fltpCode,itemID,fileID,sysFile,projectID){
		var url = "taskFileUploadPop.do?changeSetID="+changeSetID+"&taskTypeCode="+taskTypeCode+"&fltpCode="+fltpCode+"&itemID="+itemID+"&fileID="+fileID+"&taskID="+taskID+"&sysFile="+sysFile+"&projectID="+projectID;
		var w = 500;
		var h = 250;
		itmInfoPopup(url,w,h);
	}
	
	function fnFileDownLoad(originalFileName,sysFileName,filePath,seq){ 
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.editTaskResultFrm, url,"subFrame");
	}
	
	function fnDateChk(date){
		//날짜 유효성검사
	    if ( !isValidDate(date) ) {
	        alert('${WM00139}');
	    }
	}

</script>
</head>
<body>
	<form name="editTaskResultFrm" id="editTaskResultFrm" action="*" method="post" onsubmit="return false">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}" >
	<input type="hidden" id="taskCnt" name="taskCnt" value="${taskCnt}" >
	<input type="hidden" id=mainVersion name="mainVersion" value="${mainVersion}" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; Edit Task
		</h3>
	</div>	
	<div class="child_search01" >
		<ul>
			<li class="floatR pdR20">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="fnGoBack()" type="submit"></span>
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveTask()"  type="submit"></span>
			</li>
		</ul>
	</div>	
	<div style="overflow-y:auto; height:400px;">
	<table class="tbl_task" style="padding-top:10px;" width="100%"  border="0" cellpadding="0" cellspacing="0"  >
		<tr>
			<th style="word-break:break-all" width="2%">No</th>
			<th style="word-break:break-all" width="4%">ID</th>
			<th style="word-break:break-all" width="8%">${menu.LN00028}</th>
			<th style="word-break:break-all" width="6%">Task</th>
			<th style="word-break:break-all" width="6%">${menu.LN00221}</th>
			<th style="word-break:break-all" width="6%">${menu.LN00063}</th>
			<th style="word-break:break-all" width="6%">${menu.LN00233}</th>
			<th style="word-break:break-all" width="9%">Program ID</th>
			<th style="word-break:break-all" width="9%">T_Code</th>
			<th style="word-break:break-all" width="3%">Down</th>
			<th class="last2" style="word-break:break-all" width="2%">File</th>
		</tr>
		<c:forEach var="taskList" items="${taskList}" varStatus="status">		
		<tr>
			<input type="hidden" id="itemID${status.index}" name="itemID${status.index}" value="${taskList.ItemID}" >	
			<input type="hidden" id="changeSetID${status.index}" name="changeSetID${status.index}" value="${taskList.ChangeSetID}" >	
			<input type="hidden" id="taskTypeCode${status.index}" name="taskTypeCode${status.index}" value="${taskList.TaskTypeCode}" >	
			<input type="hidden" id="taskIDP${status.index}" name="taskIDP${status.index}" value="${taskList.TaskIDP}" >	
			<input type="hidden" id="taskIDA${status.index}" name="taskIDA${status.index}" value="${taskList.TaskIDA}" >	
			<td class="last">${status.count}</td>			
			<td class="last">${taskList.ID}</td>
			<td class="last">${taskList.ItemName}</td>
			<td class="last">${taskList.TaskName}</td>
			<td class="last">${taskList.PlanEndDate}	
			</td>
			<td class="last">
				<input type="text" id="actualStartDate${status.index}" name="actualStartDate${status.index}" value="${taskList.ActualStartDate}" class="text datePicker" size="8"
						style="width: 70px;" maxlength="10">
						
			</td>
			<td class="last">
				<input type="text" id="actualEndDate${status.index}" name="actualEndDate${status.index}" value="${taskList.ActualEndDate}" class="text datePicker" size="8"
						style="width: 70px;" maxlength="10">
						
			</td>
			<td class="last">
				<input type="text" id="programID${status.index}" name="programID${status.index}" value="${taskList.ProgramID}" class="text" style="margin-left=5px;">	
			</td>
			<td class="last">
				<input type="text" id="tCode${status.index}" name="tCode${status.index}" value="${taskList.TCode}" class="text" style="margin-left=5px;">	
			</td>
			<td class="last">
				<c:if test="${taskList.FileID != null}"> 
					<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="fileDown" align="absmiddle" onclick="fnFileDownLoad('${taskList.FileRealName}','${taskList.FileName}','','${taskList.FileID}')">
				</c:if>
			</td>
			<td class="last">
				<c:if test="${taskList.FltpCode != null}"> 
					<img src="${root}${HTML_IMG_DIR}/btn_file_attach.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="fileUpload" align="absmiddle" onclick="fnFileUpload('${taskList.ChangeSetID}','${taskList.TaskTypeCode}','${taskList.TaskIDA}','${taskList.FltpCode}','${taskList.ItemID}','${taskList.FileID}','${taskList.SysFile }','${taskList.ProjectID}')">
				</c:if>
			</td>			
		</tr>
		</c:forEach>
	</table>
	</div>
</form>	
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>
