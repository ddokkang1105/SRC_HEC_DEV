<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>


<form name="SCRFrm" id="SCRFrm" action="" method="post" >
	<c:choose>
       <c:when test="${scrList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="15%">
			       	<col width="50%">
			       	<col width="19%">
			       	<col width="15%">
			    </colgroup>			   	
			   	<tr>
				   <th>System</th>
				   <th>${menu.LN00002}</th>
				   <th>${menu.LN00065}</th>
				   <th>${menu.LN00221}</th>
				</tr>      
				<c:forEach var="list" items="${scrList}" varStatus="status" end="${listSize}">
					<tr onclick="fnSCRDetail('${list.SCRID}','${list.SRID}')" >
					   <td>${list.SCRArea2Name}</td>
					   <td class="alignL">${list.Subject}</td>					   
			 		   <td>${list.StatusName}</td>
					   <td>${list.SRDueDate}</td>					  
					</tr>
					<tr>
					   <td colspan="5" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>