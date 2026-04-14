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
<head>

<script type="text/javascript">
	var i = 0;
	var SymTypeCode;
	<c:forEach items="${symTypeList}" var="list" varStatus="status">
		if(SymTypeCode == null || SymTypeCode == ''){
			SymTypeCode = "${list.SymTypeCode}";
		} else {
			SymTypeCode +=  ",${list.SymTypeCode}";
		}
	</c:forEach>
	
	$(document).ready(function(){
		$("#symTypeCodes").val(SymTypeCode);
	});
	
	function fnEditModelSortNum(){	
		if(confirm("${CM00001}")){			
			var url  = "editSymAllocSortNum.do";
			ajaxSubmit(document.objectInfoFrm, url,"subFrame");
		}
	}
	
	function fnCallBack(){
 		opener.doOTSearchList();
		self.close();
	}
		
</script>
</head>
<body >	
<div>
	<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="symTypeCodes" name=symTypeCodes value="" >
	<input type="hidden" id="modelTypeCode" name="modelTypeCode" value="${ModelTypeCode}" >
	<div id="objectInfoDiv">
		<div class="child_search_head pdB10"><p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit Symbol SortNum</p></div>			
		<div  style="height:500px;padding:0 10px;overflow:auto;">	
		<table class="tbl_blue01" border="0" cellpadding="0" cellspacing="0" >
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<tr>
				<th class="last viewline">${menu.LN00015}</th>
				<th class="last" style="word-break:break-all">${menu.LN00176}</th>
				<th class="last" style="word-break:break-all">${menu.LN00028}</th>
				<th class="last" style="word-break:break-all">Sort No.</th>
			</tr>
				
			<c:forEach var="list" items="${symTypeList}" varStatus="status">			
			<tr>
				<td class="last line alignC">${list.SymTypeCode}</td>
				<td class="last"><img src="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/${list.SymbolIcon}"></td>
				<td class="last">${list.Name}</td>
				<td class="last">
					<input type="text" id="sortNum_${list.SymTypeCode}" name="sortNum_${list.SymTypeCode}" value="${list.SortNum}" class="text alignC">
				</td>
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