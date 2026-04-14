<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	
	function fnWFDetail(projectID,wfID,stepInstID,actorID,stepSeq,wfInstanceID,lastSeq,documentID,docCategory){
		fnGoWFDetail(projectID,wfID,stepInstID,actorID,stepSeq,wfInstanceID,lastSeq,documentID,docCategory);
	} 
	
	function doSearchList(){
		fnWFListReload();
	}
</script>

<form name="WFForm" id="WFForm" action="" method="post" style="width: 100%;height:100%;">
	<c:choose>
       <c:when test="${workflowList.size() == 0}">
     		
    	</c:when>
    	<c:otherwise>
		<c:forEach var="list" items="${workflowList}" varStatus="status" end="${listSize}">
			<ul onclick="fnWFDetail('${list.ProjectID}','${list.WFID}','${list.StepInstID}','${list.ActorID}','${list.StepSeq}','${list.WFInstanceID}','${list.LastSeq}','${list.DocumentID}','${list.DocCategory}' )" >
			   <li style="width:70%;max-width:595px;">${list.Subject}</li>
			   <li style="width:13%;" class="alignC">${list.CreatorName}</li>
			   <li style="width:17%;" class="alignC">${list.CreationDT}</li>
			</ul>
       	</c:forEach>       
		</c:otherwise>
	</c:choose>
</form>