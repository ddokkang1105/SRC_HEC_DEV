<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 2. Script -->
<script type="text/javascript">


	function fnGoItemInfo(avg) {
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);	
			
	}

</script>

</head>
	<c:forEach items="${csList}" var="list" varStatus="status">
		<ul onClick="fnGoItemInfo('${list.ItemID}')">
			<li style="width:10%;max-width:85px;">${list.TypeCode}</li>
			<li style="width:50%;">${list.Identifier}&nbsp;&nbsp;${list.ItemName}</li>
			<li style="width:13%;">${list.TeamName}</li>
			<li style="width:12%;" class="alignC">${list.ItemStatusName}</li>
			<li style="width:15%;" class="alignC">${list.LastUpdated}</li>
		</ul>
	</c:forEach>
</html>
