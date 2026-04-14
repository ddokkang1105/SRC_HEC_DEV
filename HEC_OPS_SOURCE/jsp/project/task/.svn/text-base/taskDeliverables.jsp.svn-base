<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="./cmm/js/xbolt/popupHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script>

	$(document).ready(function(){	
		$("input.datePicker").each(generateDatePicker);
	});
	
	// [Attach] 버튼 클릭
	function saveTaskFile(taskID,fltpCode,fileID){ 
		//if(!confirm("${CM00001}")){ return;}
		//if(!fnCheckValidation()){return;}		
		var url  = "saveTaskFile.do?itemID=${itemID}&taskID="+taskID+"&fltpCode="+fltpCode+"&fileID="+fileID; 
		ajaxSubmit(document.taskDlvrblsFrm, url,"blankFrame");
	}
	
	function fnFileDownLoad(taskTypeCode){	
		var originalFileName = $("#originalFileName"+taskTypeCode).val();
		var sysFileName = $("#sysFileName"+taskTypeCode).val();
		var filePath = $("#filePath"+taskTypeCode).val();
		var seq = $("#fileID"+taskTypeCode).val();
		var url  = "fileDownload.do?seq="+seq;

		ajaxSubmitNoAdd(document.taskDlvrblsFrm, url,"blankFrame");
	}
	
	// file upload 후 reload
	function fnCallBack(){		
		var itemID = "${itemID}";
		var changeSetID = "${changeSetID}";
		var projectID = "${projectID}";
		var csrAuthorID = "${csrAuthorID}";
	    var parentID = "${parentID}";
	    var csrStatus = "${csrStatus}";
	    
		var url = "taskDeliverables.do";
		var data = "itemID="+itemID+"&changeSetID="+changeSetID+"&projectID="+projectID+"&csrAuthorID="+csrAuthorID+"&parentID="+parentID+"&csrStatus="+csrStatus;
		var target="arcFrame";
		ajaxPage(url, data, target);
	}
	
	
</script>
	<form name="taskDlvrblsFrm" id="taskDlvrblsFrm" action="" enctype="multipart/form-data" method="post">
	<input type="hidden" id="csrAuthorID" name="csrAuthorID" value="${csrAuthorID}">
	<input type="hidden" id="csrStatus" name="csrStatus" value="${csrStatus}">
	<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}">
	<!-- <div style="height:5px"></div>  -->
	<div style="width:100%;overflow:auto;overflow-x:hidden;margin: 0;">
		<table class="tbl_task" width="100%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th class="last" width="2%" >No</th>
				<th class="last" width="8%" >${menu.LN00091}</th>
				<th class="last" width="5%" >File</th>
				<th class="last" width="22%" >${menu.LN00101}</th>
				<th class="last" width="7%" >${menu.LN00070}</th>
				<th class="last" width="11%" >${menu.LN00060}</th>
				<th class="last" width="8%" >${menu.LN00104}</th>
				<th class="last" width="4%" >${menu.LN00030}</th>
				<c:if test="${(csrAuthorID == sessionScope.loginInfo.sessionUserId || actorYN == 'Y')  && csrStatus != 'CLS'}">  
				<th class="last" width="10%" >${menu.LN00103}</th>
				</c:if>
			</tr>
			<c:forEach var="taskFileList" items="${taskFileList}" varStatus="status">			
			<tr>
				<td class="last">${taskFileList.RNUM}</td>
				<td class="last">
					<input type="text" id="TaskTypeName" name="TaskTypeName" value="${taskFileList.FltpName}" class="text" style="margin-left=5px;border:0px;">	
				</td>
				<td class="last">
					<c:if test="${taskFileList.FileID != null}"> 
					<img src="${root}${HTML_IMG_DIR}/btn_file_add.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnFileDownLoad('${taskFileList.TaskTypeCode}')">
					</c:if>
				</td>
				<td class="last">${taskFileList.FileRealName}</td>
				<td class="last">${taskFileList.LastUpdated}</td>
				<td class="last">${taskFileList.RegMemberName}</td>	
				<td class="last">${taskFileList.TeamName}</td>
				<td class="last">${taskFileList.DownCNT}</td>
				<c:if test="${(csrAuthorID == sessionScope.loginInfo.sessionUserId || actorYN == 'Y')  && csrStatus != 'CLS'}">  
				<td class="last">
					<c:if test="${taskFileList.TaskID != null }" >
					<input type="file" name='uploadFile${taskFileList.TaskTypeCode}' id='uploadFile${taskFileList.TaskTypeCode}' OnChange="saveTaskFile('${taskFileList.TaskID}','${taskFileList.FltpCode}','${taskFileList.FileID}')">
					</c:if>
				</td>
				</c:if>
				<input type="hidden" id="originalFileName${taskFileList.TaskTypeCode}" name="originalFileName${taskFileList.TaskTypeCode}" value="${taskFileList.FileRealName}" >	
				<input type="hidden" id="sysFileName${taskFileList.TaskTypeCode}" name="sysFileName${taskFileList.TaskTypeCode}" value="${taskFileList.FileName}" >	
				<input type="hidden" id="fileID${taskFileList.TaskTypeCode}" name="fileID${taskFileList.TaskTypeCode}" value="${taskFileList.FileID}" >			
			</tr>
			</c:forEach>
		</table>
	</div>	
	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	
