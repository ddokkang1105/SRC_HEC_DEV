<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	function fnDetail(ID){
		var isAuthorUser = "N";
		
		/* 변경항목 상세 화면으로 이동 */
			var itemId = ID ;
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);	
	}
</script>
<style>


</style>
<form name="changeSetForm" id="changeSetForm" action="" method="post" >
	<c:choose>
       <c:when test="${isView == '0'}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
    		<ul class="notice">
    			<li style="height:20px;"><span onClick="javascript:fnClickMoreChangeSet();"><img src="${root}${HTML_IMG_DIR}/more.png"></span></li>
    			<c:forEach var="list" items="${chgSetList}" varStatus="status" end="4">
    			<li><a href="javascript:fnDetail('${list.ItemID}')">${list.Identifier}&nbsp;${list.ItemName}</a><span>${list.ClassCode}&nbsp;&nbsp;&nbsp;${list.LastUpdated}</span></li>
		       	</c:forEach> 
		    </ul>     
		</c:otherwise>
	</c:choose>
</form>