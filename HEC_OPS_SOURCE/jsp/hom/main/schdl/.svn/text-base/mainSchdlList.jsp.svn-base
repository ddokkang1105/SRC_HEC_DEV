<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	
	function fnSdlDetail(scheduleId){ 
		var url="schdlDetailPop.do";
		var data="scheduleId="+scheduleId;
		fnOpenLayerPopup(url,data,"",617,436);
	}
</script>

<form name="schedulForm" id="schedulForm" action="" method="post" >
	<c:choose>
       <c:when test="${schdlList.size() == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		    	<colgroup>
		    		<col width="18%">
					<col width="18%">
			       	<col width="36%">
			       	<col width="15%">
			       	<col width="15%">
			    </colgroup>
		        <tr>
		        	<th>Project Group</th>
					<th>${menu.LN00131}</th>
					<th>${menu.LN00002}</th>
					<th>${menu.LN00060}</th>
					<th>${menu.LN00063}</th>
				</tr>	    
				<c:forEach var="list" items="${schdlList}" varStatus="status" end="${listSize}">
					<tr onclick="fnSdlDetail('${list.ScheduleID}')">
					   <td class="alignL">${list.ProjectGroupName}</td>
					   <td class="alignL">${list.ProjectName}</td>
					   <td class="alignL">${list.Subject}</td>
					   <td class="alignL">${list.WriteUserNM}</td>
			           <td class="alignL">${list.startDateM}</td>
					</tr>
					<tr>
					   <td colspan="5" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>