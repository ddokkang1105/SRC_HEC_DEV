<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%
String noticType = request.getParameter("noticType") == null ? "1" : request.getParameter("noticType");
%> 

<script>
	$(document).ready(function(){
	});	
	function fnDetail(mgtID, faqID){
		var url="zDlm_boardDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&faqID="+faqID+"&BoardMgtID="+mgtID+"&noticType="+$('#noticType').val();
		fnOpenLayerPopup(url,data,"",600,650);/*openPopup(url,400,400,"new");*/
	}
</script>
<style>
.postInfo{
	height:100%;
   	overflow-y: auto;
   	background:#fff;
}
.postInfo ul{
    background: #fff;
    width: 96%;
    padding: 0 2%;
    display: table;
    table-layout:fixed;
}
.postInfo ul:hover{
	background:rgba(65, 152, 247, 0.15);
	cursor:pointer;
	box-shadow: 2px 0px 0px 0px #4265EE inset;
	transition: background-color .2s ease-out;
}
.postInfo li{
	display: table-cell;    
	padding: 1.44% 1.4%;
    border-bottom: 1px solid #e6e6e6;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.postInfo ul:last-child li{
	border:none;
}
</style>
	<input type="hidden" id="noticType" name="noticType" value="${noticType}"></input>
	<div class="postInfo">
	<c:choose>
       <c:when test="${isView == '0'}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
			<c:forEach var="list" items="${brdList}" varStatus="status" end="${listSize-1}">
			<ul onclick="fnDetail('${boardMgtID}','${list.FAQ_ID}')">
			    <li style="width:65%;max-width:595px;">${list.QESTN_SJ}<c:if test="${list.chkNew == '1'}"><img src="${root}${HTML_IMG_DIR}/new.png"></c:if></li>
			  	<%-- <li style="width:20%;" class="alignC">${list.NAME}</li> --%>
			    <li style="width:20%;" class="alignC">${list.FRST_REGIST_PNTTM}</li>
	    	</ul>
	       	</c:forEach>       
		</c:otherwise>
	</c:choose>
	</div>