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
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">


	function fnGoPjtInfo(avg,avg2) {
		
		var url = "";
		var w = 1200;
		var h = 900;
		
		h = 600;
		url = "csrDetailPop.do";
		data = "?ProjectID="+avg+"&screenMode=V&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=1";
		window.open(url+data,"","width="+w+",height="+h+"toolbar=no,resizble=0,scrollbar=yes");				
	}

</script>

</head>
<body>
	<c:forEach items="${csrList}" var="list" varStatus="status">
		<ul onClick="fnGoPjtInfo('${list.CODE}','${list.ProjectType}')">
			<li style="width:13%;max-width:75px;">${list.ParentName}</li>
			<li style="width:60%;max-width: 370px;">${list.NAME}</li>
			<li style="width:12%;max-width: 90px;">${list.StatusName}</li>
			<li style="width:15%;" class="alignC">${list.DueDate}</li>
		</ul>
	</c:forEach>
</body>
</html>
