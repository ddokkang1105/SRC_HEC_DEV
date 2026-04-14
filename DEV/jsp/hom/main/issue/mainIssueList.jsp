<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	function fnISDetail(IssueID){
		var url="issueDetailPop.do";
		var data="issueId="+IssueID;
		fnOpenLayerPopup(url,data,"",617,436);
	}
</script>

<form name="issueForm" id="issueForm" action="" method="post" >
	<c:choose>
       <c:when test="${issueList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
					<col width="65%">
			       	<col width="20%">
			    </colgroup>
		        
				<c:forEach var="list" items="${issueList}" varStatus="status" end="${listSize}">
					<tr onclick="fnISDetail('${list.IssueID}')">
					   <td>${list.Subject}</td>
					   <td>${list.RequestorName}</td>
			           <td>${list.CreationTime}</td>
					</tr>
					<tr>
					   <td colspan="3" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>