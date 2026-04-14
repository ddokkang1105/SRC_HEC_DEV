<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	document.getElementById('editArea').style.height = (setWindowHeight() - 90)+"px";	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


</script>
</head>
<body>
<div id="objectInfoDiv" style="width:100%;">	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Visit List</p>
	</div>
	
	<div id="editArea" style="overflow:auto;margin:5px 5px 5px 5px;overflow-x:hidden;">
	<table class="tbl_blue01 mgT2" width="85%"  border="0" cellspacing="0" cellpadding="0">
        	<colgroup>
			<col width="10%">
			<c:if test="${type eq 'UPDATE' }">
			<col width="10%">
			</c:if>
			<col width="10%">
			<col width="10%">
			<col width="10%">
			<col>
		</colgroup>
		<tr>
			<th class="viewtop last">No.</th>
			<c:if test="${type == 'UPDATE' }">
			<th class="viewtop last">ID.</th>
			</c:if>
			<th class="viewtop last">${menu.LN00072}</th>
			<th class="viewtop last">${menu.LN00247}</th>
			<th class="viewtop last">사번</th>
		</tr>
	<c:forEach var="i" items="${visitList}" varStatus="status">	
		<tr>
			<td class="last">${status.index+1} </td>
			<c:if test="${type == 'UPDATE' }">
			<td class="last">
				${i.Identifier}
			</td>
			</c:if>
			<td class="last">
				${i.MemberName}
			</td>
			<td class="last">
				${i.TeamName}
			</td>
			<td class="last">
				${i.EmployeeNum}
			</td>
		</tr>
	</c:forEach>		
	</table>	
	</div>
</div>	</body>
</html>