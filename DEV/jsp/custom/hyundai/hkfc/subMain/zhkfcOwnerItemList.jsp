<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:url value="/" var="root"/>

<script>
	$(document).ready(function(){
	});	
	
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
	<div class="postInfo">
	<c:choose>
       <c:when test="${fn:length(myItemList) == 0}">
     		There is no item to be listed.
    	</c:when>
    	<c:otherwise>
			<c:forEach var="list" items="${myItemList}" varStatus="status">
			<ul onclick="fnItemInfo(${list.ItemID})">
			    <li style="width:75%;max-width:595px;">${list.Identifier} ${fn:escapeXml(list.ItemNM)}</li>
			  	<li style="width:10%;" class="alignC">${list.StatusNM}</li>
			    <li style="width:15%;" class="alignC">${list.LastUpdated}</li>
	    	</ul>
	       	</c:forEach>       
		</c:otherwise>
	</c:choose>
	</div>