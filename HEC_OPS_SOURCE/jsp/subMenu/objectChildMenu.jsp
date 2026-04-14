<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">    
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript">
	var s_itemID = '${s_itemID}';
	$(document).ready(function(){setocFrame('ObjectInfoChild','1','');});
	function setocFrame(avg, avg2, filter){
		if(filter == ''){filter = 'occ';}		
		var url = avg+".do";		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&modelID=${s_itemID}"
				+"&s_itemID=${s_itemID}"
				+"&width="+ocFrame.offsetWidth
				+"&option="+$("#option",parent.document).val()
				+"&filter="+filter
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}";
		var target="ocFrame";	
		ajaxTabPage(url, data, target);
		for(var i = 1 ; i < 5; i++){
			if(i == avg2){
				$("#pliOCM"+i).addClass("selected");
			}else{
				$("#pliOCM"+i).removeClass("selected");
			}
		}
	}	
</script>
</head>
<body>
<div class="ddoverlap">
	<ul>
		<li id="pliOCM1" class="selected" onclick="setocFrame('ObjectInfoChild','1','${filter}')"><a><span>${menu.LN00035}</span> </a></li>
		<li id="pliOCM2" onclick="setocFrame('ObjectAttrInfo','2','${filter}')"><a><span>${menu.LN00031}</span></a></li>
<c:if test="${tabCheck.HasDimension == '1' }">
		<li id="pliOCM3" onclick="setocFrame('dimensionList','3','${filter}')"><a><span>Dimension</span></a></li>	
</c:if>		
<c:if test="${tabCheck.ChangeMgt == '1' }">
		<li id="pliOCM4"><a href="javascript:setocFrame('ObjectHistoryGrid','4','${filter}');"><span>${menu.LN00012}</span></a></li>		
</c:if>			
	</ul>
</div>
	<div id="ocFrame"></div>
<!-- 
	<iframe width="100%" height="95%" frameborder="0" style="border: 0" name="ocFrame" id="ocFrame"  scrolling='no' src="ObjectInfoChild.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option=${option}&getAuth=${sessionScope.loginInfo.sessionLogintype}"></iframe>
 -->	
 </body>
 </html>
