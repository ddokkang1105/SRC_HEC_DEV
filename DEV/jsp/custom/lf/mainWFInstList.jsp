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

<form name="WFForm" id="WFForm" action="" method="post" >
	<c:choose>
       <c:when test="${workflowList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="10%">
			       	<col width="55%">
			       	<col width="15%">
			       	<col width="20%">
			    </colgroup>
			   	<tr>
			   		<th>${menu.LN00024}</th>
			   		<th>${menu.LN00002}</th>
					<th>${menu.LN00060}</th>
					<th>${menu.LN00078}</th>
			   	</tr>
				<c:forEach var="list" items="${workflowList}" varStatus="status" end="${listSize}">
					<tr onclick="fnWFDetail('${list.ProjectID}','${list.WFID}','${list.StepInstID}','${list.ActorID}','${list.StepSeq}','${list.WFInstanceID}','${list.LastSeq}','${list.DocumentID}','${list.DocCategory}' )" >
					   <td>${list.RNUM}</td>
					   <td class="alignL">${list.Subject}</td>
					   <td>${list.CreatorName}</td>
					   <td>${list.CreationDT}</td>
					</tr>
					<tr>
					   <td colspan="4" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>