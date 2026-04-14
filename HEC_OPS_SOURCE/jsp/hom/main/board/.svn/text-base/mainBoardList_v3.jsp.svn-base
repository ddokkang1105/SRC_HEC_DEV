<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<%
String noticType = request.getParameter("noticType") == null ? "1" : request.getParameter("noticType");
%> 
<script>
	$(document).ready(function(){
	});	
	function fnDetail(mgtID, ID){
		var url="boardDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardID="+ID+"&BoardMgtID="+mgtID+"&noticType="+$('#noticType').val();
		fnOpenLayerPopup(url,data,"",617,436);/*openPopup(url,400,400,"new");*/
	}
</script>
<style>

</style>
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="noticType" name="noticType" value="${noticType}"></input>
	<c:choose>
       <c:when test="${isView == '0'}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
		    <table class="tbl_nstyle">
		        <colgroup>
		        	<col>
		        	<col width="25%">
		        	<col width="25%">
		        	<col width="10%">
		        </colgroup>
				<c:forEach var="list" items="${brdList}" varStatus="status" end="4">
					<tr onclick="fnDetail('${list.BoardMgtID}','${list.BoardID}')">
					   <td>${list.Subject}<c:if test="${list.chkNew == '1'}"><img src="${root}${HTML_IMG_DIR}/new.png"></c:if></td>
					   <td><img src="${root}${HTML_IMG_DIR}/img_date.png" class="pdR10"><b>${list.ModDT2}</b></td>
					   <td><img src="${root}${HTML_IMG_DIR}/img_write.png" class="pdR10"><b>${list.WriteUserNM}</b></td>
					   <td><img src="${root}${HTML_IMG_DIR}/img_count.png" class="pdR10"><font style="color:#f97d1b;font-weight:bold;">${list.ReadCNT}</font></td>
					</tr>
					<tr>
					   <td colspan="4" class="hr1"></td>
					</tr> 
		       	</c:forEach>       
		     </table>
		</c:otherwise>
	</c:choose>
</form>