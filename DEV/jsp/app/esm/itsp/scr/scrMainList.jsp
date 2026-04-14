<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>


<form name="SCRFrm" id="SCRFrm" action="" method="post" >
	<c:choose>
       <c:when test="${scrList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
   		<c:forEach var="list" items="${scrList}" varStatus="status" end="${listSize}">
			<ul onclick="fnSCRDetail('${list.SCRID}','${list.SRID}')" >
			   <li style="width:15%; max-width: 60px;">${list.SCRArea2Name}</li>
			   <li style="width:54%; max-width: 240px;">${list.Subject}</li>					   
	 		   <li  style="width:15%; max-width: 60px;">${list.StatusName}</li>
			   <li  style="width:16%;" class="alignC">${list.SRDueDate}</li>					  
			</ul>
		</c:forEach>
		</c:otherwise>
	</c:choose>
</form>