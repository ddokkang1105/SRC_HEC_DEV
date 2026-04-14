<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="./cmm/js/xbolt/popupHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00028" var="CM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00004}"/><!-- 담당자 입력 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00004} and ${menu.LN00063} or ${menu.LN00233}"/><!-- 시작일을 입력 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00233}"/><!-- 종료일 입력 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00027" var="WM00027" arguments="입력"/>

<script>
	$(document).ready(function(){	
		
		$("input.datePicker").each(generateDatePicker);
	});
	
	function fnSaveTask(){
		var taskTypeCodeArr = "${taskTypeCodeArr}";
		var taskTypeCode = taskTypeCodeArr.split(",");
		var category = "${category}";
		var startDate;
		var endDate;
		var befStartDate;
		var taskName;
		var befTaskName;
		var msg = "";
		var checkYN = "N";
		
		for(var i=0; i<taskTypeCode.length; i++){
			taskName = $("#taskName"+taskTypeCode[i]).val(); 
			
			if($("#memberID"+taskTypeCode[i]).val() == "" && $("#startDate"+taskTypeCode[i]).val() == ""  && $("#endDate"+taskTypeCode[i]).val() == ""){
			}else{
				if($("#memberID"+taskTypeCode[i]).val() != "" && ($("#startDate"+taskTypeCode[i]).val() != "" || $("#endDate"+taskTypeCode[i]).val() != "") ){ // 시작일이나 종료일중 하나이상 입력
					checkYN = "Y";
				}
			}
			
			/* if(i > 0){	
				befTaskName = $("#taskName"+taskTypeCode[i-1]).val(); 
				befStartDate = $("#startDate"+taskTypeCode[i-1]).val().replaceAll("-","");
			}
			
			startDate = $("#startDate"+taskTypeCode[i]).val().replaceAll("-","");
			endDate = $("#endDate"+taskTypeCode[i]).val().replaceAll("-","");
			
			// 시작일 종료일 비교 
			if(parseInt(startDate) > parseInt(endDate)){					
				alert(taskName+" ${WM00132}"); return;					
			}
			
			// 전단계 시작일, 다음단계 시작일 비교 
			if(i > 0 ){
				if( parseInt(befStartDate) > parseInt(startDate) ){
					//alert(befTaskName+" 시작일이 "+taskName+" 시작일 보다 클 수 없습니다. "); return;					
					msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00133' var='WM00133' arguments='"+befTaskName+","+taskName+"'/>";
					alert("${WM00133}"); return;
				}
			} */
		}
		if(checkYN == "N"){alert("${WM00034_2}"); return;}	
		if(confirm("${CM00001}")){
			var url = "saveTask.do";
			ajaxSubmit(document.editTaskFrm, url, "blankFrame");
		}
	}
	
	function fnCallBack(status){		
		var itemID = "${itemID}";
		var changeSetID = "${changeSetID}";
		var csrAuthorID = "${csrAuthorID}";	
		var projectID = "${projectID}";
		var parentID = "${parentID}";
		var csrStatus;
		
		if(status == "CLS"){
			csrStatus="CLS";
		}else{
			csrStatus = "${csrStatus}";
		}
		var url = "taskMgt.do";
		var data = "itemID="+itemID+"&changeSetID="+changeSetID+"&csrAuthorID="+csrAuthorID+"&projectID="+projectID+"&parentID="+parentID+"&csrStatus="+csrStatus; 
		var target="taskFrm";
		
		ajaxPage(url, data, target);
	}
	
	function fnConfirmTask(){
		var category = "${category}";
		var changeSetID = "${changeSetID}";
		var itemID = "${itemID}";
		var csrStatus = "${csrStatus}";
		
		var taskTypeCodeArr = "${taskTypeCodeArr}";
		var taskTypeCode = taskTypeCodeArr.split(",");
		var startDate;
		var endDate;
		var taskName;
			
		for(var i=0; i<taskTypeCode.length; i++){
			taskName = $("#taskName"+taskTypeCode[i]).val();
			if($("#memberName"+taskTypeCode[i]).val() != "" || $("#startDate"+taskTypeCode[i]).val() != "" || $("#endDate"+taskTypeCode[i]).val() != ""){
				if($("#memberName"+taskTypeCode[i]).val() == ""){
					alert(taskName+" ${WM00034_1}"); return;
				/* }else if($("#startDate"+taskTypeCode[i]).val() == ""){
					alert(taskName+" ${WM00034_2}"); return;
					*/
				} 
				else if($("#endDate"+taskTypeCode[i]).val() == ""){
					alert(taskName+" ${WM00034_3}"); return;
				}
			}
		}
		
		if(confirm("${CM00001}")){
			var url = "saveTaskConfirm.do";
			var data = "taskConfirmed=1&taskStatus=PLAN2&category="+category+"&changeSetID="+changeSetID+"&itemID="+itemID+"&csrStatus="+csrStatus;
			var target="blankFrame";
			
			ajaxPage(url, data, target);
		}
	}
	
	function fnSetChangeFinish() { // Actual 생성되었는지 체크
		var taskTypeCodeArr = "${taskTypeCodeArr}";
		var taskTypeCode = taskTypeCodeArr.split(",");
		var category = "${category}";
		var startDate;
		var endDate;
		var taskName;
			
		for(var i=0; i<taskTypeCode.length; i++){
			taskName = $("#taskName"+taskTypeCode[i]).val();
			if($("#memberID"+taskTypeCode[i]).val() == ""){
					alert(taskName+" ${WM00034_1}"); return;
			}else if($("#endDate"+taskTypeCode[i]).val() == ""){
				alert(taskName+" ${WM00034_3}"); return;
			}
		}
		
		if (confirm("${CM00049}")) {
			var url = "setCurTaskClose.do";			// checkInItem.do =>   TB_CHANGE_SET.CurTask = 'CLS'로 업데이트 처리로 변경함
			var data = "item=${itemID}&changeSetID=${changeSetID}&category=${categroy}&csrStatus=${csrStatus}";
			var target="blankFrame";
			
			ajaxPage(url, data, target);
		}
	}
	
	
</script>
	<div style="height:5px"></div>	
	<div style="width:100%;overflow:auto;overflow-x:hidden;margin: 0 5 5 5;">
	<form name="editTaskFrm" id="editTaskFrm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="currTskCode" name="currTskCode" >
	<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}" >
	<input type="hidden" id="category" name="category" value="${category}" >
	<input type="hidden" id="itemID" name="itemID" value="${itemID}" >
	<input type="hidden" id="csrAuthorID" name="csrAuthorID" value="${csrAuthorID}" >
	<input type="hidden" id="projectID" name="projectID" value="${projectID}" >
	<input type="hidden" id="parentID" name="parentID" value="${parentID}" >	
	<input type="hidden" id="curTask" name="curTask" value="${curTask}" >		
		<div style="border-bottom:1px solid #896c41;" width="100%" border="0" cellpadding="0" cellspacing="0"  >			
			<span style="font-weight:bold;">&nbsp;&nbsp;&nbsp;- Edit&nbsp;${categoryName}</span>
		</div>		<br>
		<table class="tbl_task" style="padding-top:10px;border-right:1px" width="100%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th class="viewtop last2" style="word-break:break-all" width="4%">Task</th>
				<th class="last" style="word-break:break-all" width="5%">${menu.LN00004}</th>
				<th class="last" style="word-break:break-all" width="9%">${menu.LN00063}</th>
				<th class="last" style="word-break:break-all" width="9%">${menu.LN00233}</th>
				<th class="last" style="word-break:break-all" width="9%">M/D</th>
			</tr>
			<c:forEach var="taskList" items="${taskList}" varStatus="status">			
			<tr>				
				<td class="last2">${taskList.TaskTypeName}
					<input type="hidden" id="taskName${taskList.TaskTypeCode}" name="taskName${taskList.TaskTypeCode}" value="${taskList.TaskTypeName}">
					<input type="hidden" id="taskID${taskList.TaskTypeCode}" name="taskID${taskList.TaskTypeCode}" value="${taskList.TaskID}">
				</td>
				<td class="last">
					<select id="memberID${taskList.TaskTypeCode}" name="memberID${taskList.TaskTypeCode}" class="sel">
			           	<option value=''>Select</option>
			           	<c:forEach var="i" items="${taskAuthorList}">
			           		<c:if test="${ taskList.Actor != null }">
			               	<option value="${i.MemberID}" <c:if test="${i.MemberID == taskList.Actor}">selected="selected"</c:if>>${i.UserName}</option>
			           		</c:if>			           		
			           		<c:if test="${taskList.Actor == null }">
			               	<option value="${i.MemberID}" <c:if test="${i.MemberID == taskList.PlanActor}">selected="selected"</c:if>>${i.UserName}</option>
			           		</c:if>
			           		
			           	</c:forEach>
			       	</select>
				</td>
				<td class="last">
					<font><input type="text" id="startDate${taskList.TaskTypeCode}" name="startDate${taskList.TaskTypeCode}" value="${taskList.StartDate}" class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>		
				</td>
				<td class="last">
					<font> <input type="text" id="endDate${taskList.TaskTypeCode}" name="endDate${taskList.TaskTypeCode}" value="${taskList.EndDate}" class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>		
				</td>
				<td class="last2">
					<input type="text" id="manday${taskList.TaskTypeCode}" name="manday${taskList.TaskTypeCode}" value="${taskList.Manday}" class="text" style="margin-left=5px;">	
				</td>
			</tr>
			</c:forEach>
		</table>
		
	</form>
	</div>		
	<div class="alignBTN" id="divUpdateModel" >
		<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveTask()"  type="submit"></span>
		<c:if test="${category == 'P' && curTask == 'PLAN1' && taskIDCnt == tskCnt && isEndDate == 'Y'}"><!-- endDate YN Check -->
		<span class="btn_pack medium icon"><span  class="confirm"></span><input value="Confirm" onclick="fnConfirmTask()"  type="submit"></span>
		</c:if>
		<c:if test="${category == 'A' && taskIDCnt == tskCnt && isEndDate == 'Y' && csrAuthorID == sessionScope.loginInfo.sessionUserId}"><!-- endDate YN Check -->
		<span class="btn_pack medium icon"><span  class="confirm"></span><input value="Completion" onclick="fnSetChangeFinish()"  type="submit"></span>
		</c:if>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	
