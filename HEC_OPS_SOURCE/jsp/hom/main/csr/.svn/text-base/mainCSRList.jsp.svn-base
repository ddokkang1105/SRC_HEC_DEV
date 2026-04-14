<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	
	function fnCSRDetail(projectID){
		fnGoCSRDetail(projectID);
	} 
</script>

<form name="CSRForm" id="CSRForm" action="" method="post" >
	<c:choose>
       <c:when test="${csrList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="">
			       	<col width="">
			       	<col width="15%">
			       	<col width="15%">
			    </colgroup>	
			    <tr>
					<th>${menu.LN00131}</th>
					<th>${menu.LN00028}</th>
					<th>${menu.LN00027}</th>
					<th>${menu.LN00063}</th>
				</tr>	        
				<c:forEach var="list" items="${csrList}" varStatus="status" end="${listSize}">
					<tr onclick="fnCSRDetail('${list.ProjectID}')" >
					   <td>${list.ParentName}</td>
					   <td class="alignL">${list.ProjectName}</td>
					   <td>${list.StatusName}</td>
					   <td>${list.StartDate}</td>
					</tr>
					<tr>
					   <td colspan="4" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>