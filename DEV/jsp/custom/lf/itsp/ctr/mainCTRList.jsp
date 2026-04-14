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
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="20%">
			       	<col width="50%">
			       	<col width="15%">
			       	<col width="15%">
			    </colgroup>
			   	<tr>
			   		<th>${sysArea2LabeNM}</th>
			   		<th>${menu.LN00002}</th>
					<th>${menu.LN00027}</th>
					<th>${menu.LN00063}</th>
			   	</tr>
				<c:forEach var="list" items="${ctrList}" varStatus="status" end="${listSize}">
					<tr onclick="fnctrDetail('${list.ctrID}')" >
					   <td>${list.sysArea2NM}</td>
					   <td class="alignL">${list.subject}</td>
					   <td>${list.statusNM}</td>
					   <td>${list.regDT}</td>
					</tr>
					<tr>
					   <td colspan="4" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>