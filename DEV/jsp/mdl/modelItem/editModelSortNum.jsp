<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<head>

<script type="text/javascript">
	var callBack = "${callBack}";
	var i = 0;
	var elementID;
	<c:forEach items="${itemList}" var="item" varStatus="status">
		if(elementID == null || elementID == ''){
			elementID = "${item.ElementID}";
		} else {
			elementID +=  ",${item.ElementID}";
		}
	</c:forEach>
	
	$(document).ready(function(){
		$("#elementIDs").val(elementID);
	});
	
	function fnEditModelSortNum(){	
		if(confirm("${CM00001}")){			
			var url  = "editModelSortNum.do";
			ajaxSubmit(document.objectInfoFrm, url,"subFrame");
		}
	}
	
	function fnCallBack(){
		if(callBack == "" || callBack == null){
			opener.fnShowChild();
		} else {
			opener[callBack]();
		}
		self.close();
	}
		
</script>
</head>
<body >	
<div>
	<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="elementIDs" name="elementIDs" value="" >
	<input type="hidden" id="modelID" name="modelID" value="${modelID}" >
	<input type="hidden" id="callBack" name="callBack" value="${callBack}" >
	<div id="objectInfoDiv" >
		<div class="child_search_head pdB10"><p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit Model SortNum</p></div>			
		<div  style="height:500px;padding:0 10px;overflow:auto;">	
		<table class="tbl_blue01" border="0" cellpadding="0" cellspacing="0" >
			<colgroup>
				<col width="15%">
				<col width="25%">
				<col width="25%">
				<col width="35%">			
			</colgroup>	
			<tr>
				<th class="last viewline">No</th>
				<th class="last" style="word-break:break-all">Class</th>
				<th class="last" style="word-break:break-all">ID</th>
				<th class="last" style="word-break:break-all">Name</th>
			</tr>
				
			<c:forEach var="itemList" items="${itemList}" varStatus="status">			
			<tr>
				<td class="last line">
					<input type="text" id="sortNum_${itemList.ElementID}" name="sortNum_${itemList.ElementID}" value="${itemList.SortNum}" class="text alignC">
					<input type="hidden" id="elementID" name="elementID" value="${itemList.ElementID}" >
				</td>
				<td class="last">${itemList.ClassName}</td>
				<td class="last">${itemList.Identifier}</td>
				<td class="last alignL">${itemList.ItemName}</td>
			</tr>
			</c:forEach>
		</table>
		</div>	
		<div class="alignBTN mgR10" id="divUpdateModel" >
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnEditModelSortNum()"  type="submit"></span>			
		</div>
		<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</div>
	</form>
	</div>
</body>
</html>