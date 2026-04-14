<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 

<c:choose>
	<c:when test="${isPopup eq 'Y' }">
		<script type="text/javascript">
			$(document).ready(function(){
				var url="${extUrl}";
				var data = "";
				
				if("${getUserInfo}" == "Y"){
					data += "?id=${sessionScope.loginInfo.sessionEmployeeNm}&name=${sessionScope.loginInfo.sessionUserNm}&dept=${sessionScope.loginInfo.sessionTeamName}";
				}
				
				var windowWidth = $( window ).width();
				var popupWidth = (windowWidth*70)/100;
				
				var options = "top=10, left=10, width=" + popupWidth + ", height=600, status=no, menubar=no, toolbar=no, resizable=no";
				
				//window.open(url+data, "popup", options);
				window.location.href = url+data;
			});
		</script>
	</c:when>
	<c:otherwise>
		<iframe name="blankFrame" id="blankFrame" src="${ewInfo.VarFilter}${extUrl}" style="width:100%;height:100%;" frameborder="0"></iframe> 
	</c:otherwise>
</c:choose>
