<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	function fnDetail(mgtID, ID){
		var url="boardDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardID="+ID+"&BoardMgtID="+mgtID;
		fnOpenLayerPopup(url,data,"",617,436);/*openPopup(url,400,400,"new");*/
	}
</script>
<style>

</style>
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="boardMgtID" name="boardMgtID" value="${boardMgtID}"></input>
	<c:choose>
       <c:when test="${isView == '0'}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
    		<ul class="notice">
	      		<li style="height:20px;"><span onClick="javascript:fnClickMoreBoard();"><img src="${root}${HTML_IMG_DIR}/more.png"></span></li>
    			<c:forEach var="list" items="${brdList}" varStatus="status" end="4">
    			<li><a href="javascript:fnDetail('${list.BoardMgtID}','${list.BoardID}')">${list.Subject}</a><span>${list.ModDT2}</span></li>
		       	</c:forEach> 
		    </ul>
		</c:otherwise>
	</c:choose>
</form>