<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

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
<body>
	<c:forEach items="${itemModList}" var="list" varStatus="status">
		<ul onClick="fnGoItemInfo('${list.ItemID}')">
			<li style="width:15%;">${list.ItemTypeName}</li>
			<li style="width:58%;">${list.Identifier}&nbsp;${list.ItemNM}</li>
			<li style="width:12%;" class="alignC">${list.StatusNM}</li>
			<li style="width:15%;" class="alignC">${list.LastUpdated}</li>
		</ul>
	</c:forEach>
</body>
</html>
