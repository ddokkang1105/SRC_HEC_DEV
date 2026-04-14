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
function fnSRDetail(SRID,requestUserID,receiptUserID,status,srType){
	fnGoSRDetail(SRID,requestUserID,receiptUserID,status,srType);
}
</script>

</head>
<c:choose>
      <c:when test="${isView == '0'}">
    		There is no item to be listed.
   	</c:when>
   	<c:otherwise>
   		<c:choose>
   			<c:when test="${scrnType eq 'main'}"> 			<!-- chkNew(Day) 변수를 기준으로 new 표시 -->
	   			<c:forEach items="${esrList}" var="list" varStatus="status" end="${listSize-1}">
					<ul onclick="fnSRDetail('${list.SRID}','${list.RequestUserID}','${list.ReceiptUserID}','${list.Status}','${list.SRType}')">
						<li style="width:13%;max-width:85px;">
							<c:choose>
								<c:when test="${list.SRArea2Name ne '' && list.SRArea2Name ne null }">${list.SRArea2Name}</c:when>
								<c:when test="${list.SRArea1Name ne '' && list.SRArea1Name ne null }">${list.SRArea1Name}</c:when>
								<c:when test="${list.ItemTypeCodeNM ne '' && list.ItemTypeCodeNM ne null }">${list.ItemTypeCodeNM}</c:when>
								<c:otherwise>N/A</c:otherwise>
							</c:choose>
						</li>
						<li style="width:57%;max-width:350px;">
						<c:if test="${list.RegDate > chkYmd}"><span class="new">new</span></c:if>${list.Subject}</li>
						<li style="width:15%;max-width:120px;">${list.ReqUserNM}(${list.ReqTeamNM})</li>
						<li style="width:15%;" class="alignC">${list.ReqDueDate}</li>
					</ul>
				</c:forEach>
   			</c:when>
			<c:when test="${scrnType eq 'mySpace'}">		 	<!-- startCode와 현재 상태가 같은 때를 기준으로 new 표시 -->
	   			<c:forEach items="${esrList}" var="list" varStatus="status" end="${listSize-1}">
					<ul onclick="fnSRDetail('${list.SRID}','${list.RequestUserID}','${list.ReceiptUserID}','${list.Status}','${list.SRType}')">
						<li style="width:13%;max-width:85px;">${list.SRArea2Name}</li>
						<li style="width:57%;max-width:350px;">
						<c:if test="${list.Status eq list.FirstSpeCode}"><span class="new">new</span></c:if>${list.Subject}</li>
						<li style="width:15%;max-width:120px;">${list.ReqUserNM}(${list.ReqTeamNM})</li>
						<li style="width:15%;" class="alignC">${list.ReqDueDate}</li>
					</ul>
				</c:forEach>
   			</c:when>
   		</c:choose>
	
	</c:otherwise>
</c:choose>
</html>
