<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {			
		fnSearch("searchProcessList.do");				
	});	
	
	function fnSearch(url){ 
		var data = "&searchValue="+$("#searchValue").val();
		var target="actFrame";
		ajaxPage(url, data, target);
	}
	
</script>

</head>
<body >
<div class="pdL10 pdR10">
	<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">	
	<div class="cop_hdtitle mgB5" style="border-bottom:1px solid #ccc;">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;${menu.LN00047}_NEW</h3>
	</div>
	
	<div>
	<input type="text" id="searchValue" name="searchValue" value="" class="text" style="width:300px;ime-mode:active;">
	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="display:inline-block;" OnClick="fnSearch('searchProcessList.do');" >
	&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" OnClick="fnSearch('multiSearchProcessList.do');" style="cursor:pointer;">	
	</div>	

	<div id="actFrame" style="width:100%;overflow:auto;"></div>	
	</form>
</div>
</body>
</html>