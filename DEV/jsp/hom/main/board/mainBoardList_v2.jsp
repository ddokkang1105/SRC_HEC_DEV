<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	function fnDetail(mgtID, ID){
		var url="boardDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardID="+ID+"&BoardMgtID="+mgtID+"&noticType="+$('#noticType').val();
		fnOpenLayerPopup(url,data,"",617,436);/*openPopup(url,400,400,"new");*/
	}
</script>

<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${noticType}"></input>
	<c:choose>
       <c:when test="${isView == '0'}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle" width="100%">
		        <colgroup>
		           	<col width="60%">
		           	<col width="20%">
			       	<col width="20%">
		        </colgroup>
		        <tr>
					<th>${menu.LN00002}</th>
					<th>${menu.LN00060}</th>
					<th>${menu.LN00070}</th>
				</tr>		
				<c:forEach var="list" items="${brdList}" varStatus="status" end="${listSize}">
					<tr onclick="fnDetail('${list.BoardMgtID}','${list.BoardID}')">
					   <td class="alignL">${list.Subject}<c:if test="${list.chkNew == '1'}"><img src="${root}${HTML_IMG_DIR}/new.png"></c:if></td>
					   <td>${list.WriteUserNM}</td>
					   <td>${list.ModDT2}</td>					
					</tr>
					<tr>
					   <td colspan="3" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>