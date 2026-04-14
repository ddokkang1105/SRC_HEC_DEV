<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script>
	$(document).ready(function(){
	});	
	
	function fnctrDetail(ctrID){
		fnGoctrDetail(ctrID);
	}
	function doSearchctrList(){
		location.reload();	
	}
</script>

<form name="ctrForm" id="ctrForm" action="" method="post" >
	<c:choose>
       <c:when test="${ctrList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
			<c:forEach var="list" items="${ctrList}" varStatus="status" end="${listSize}">
				<ul onclick="fnctrDetail('${list.ctrID}')" >
				   <li style="width:15%; max-width: 60px;">${list.sysArea2NM}</li>
				   <li style="width:54%; max-width: 240px;">${list.subject}</li>
				   <li  style="width:15%; max-width: 60px;">${list.statusNM}</li>
				   <li  style="width:16%;" class="alignC">${list.regDT}</li>
				</ul>
	       	</c:forEach>
		</c:otherwise>
	</c:choose>
</form>