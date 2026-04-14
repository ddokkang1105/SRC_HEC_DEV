<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	
	function fnSRDetail(SRID,requestUserID,receiptUserID,status){
		fnGoSRDetail(SRID,requestUserID,receiptUserID,status);
	} 
</script>

<form name="SRForm" id="SRForm" action="" method="post" >
	<c:choose>
       <c:when test="${srList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="16%">
			       	<col width="50%">
			       	<col width="19%">
			       	<col width="14%">
			    </colgroup>
			    <tr>
					<th>Domain</th>
					<th>${menu.LN00028}</th>
					<th>${menu.LN00065}</th>
					<th>${menu.LN00078}</th>
				</tr>			   	        
				<c:forEach var="list" items="${srList}" varStatus="status" end="${listSize}">
					<tr onclick="fnSRDetail('${list.SRID}','${list.RequestUserID}','${list.ReceiptUserID}','${list.Status}')" >
					   <td>${list.SRArea1Name}</td>
					   <td class="alignL">${list.Subject}</td>
					   <td>${list.StatusName}</td>
					   <td>${list.RegDate}</td>
					</tr>
					<tr>
					   <td colspan="4" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>