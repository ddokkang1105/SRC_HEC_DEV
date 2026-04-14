<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	$(document).ready(function(){		
		var today = new Date();
		
		var calendar = new dhx.Calendar("calendar", {
		    width:"90%"
		});
		calendar.setValue(today);
	
		var str = "";
		<c:forEach var="list" items="${schdlList}" varStatus="i">
			var startDate = "${list.start_date}";
			var endDate = "${list.end_date}";
			str += ""
				<c:choose>
					<c:when test='${schdlList[i.index].startDateM ne schdlList[i.index-1].startDateM}'>
					+"</ul>"
					+"<ul <c:if test="${list.startDateM eq today}">style='box-shadow: 2px 0px 0px 0px #4265EE inset;'</c:if>>"
					+"<li class='schdlDate' <c:if test="${list.startDateM eq today}">style='color:#4265EE;font-weight: 900;'</c:if>>"
					</c:when>
					<c:otherwise>
						+"<li class='schdlDate'>"
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test='${schdlList[i.index].startDateM ne schdlList[i.index-1].startDateM}'>
						+"${list.startDateM}</li>"
					</c:when>
					<c:otherwise>
						+"</li>"
					</c:otherwise>
				</c:choose>
				+"<li class='schdlInfoList' onclick='fnSdlDetail(${list.ScheduleID})'>"
				+"<span class='schdlTime'><p>"+startDate.substr(11,15)+"</p></span>"
				+"<span class='schdlSbjLo'><p>${list.Subject}</p><p>${list.Location}</p></span>"
				+"</li>"
		</c:forEach>

		if(str != ""){
			$("#schdlList").html(str);
		}
		

		$(".schdlInfoList").hover(
		  function() {
		    $(this).addClass("hover");
		  }, function() {
		    $(this).removeClass("hover");
		  }
		);
	});
	
	function fnSdlDetail(scheduleId){ 
		var url="schdlDetailPop.do";
		var data="scheduleId="+scheduleId;
		fnOpenLayerPopup(url,data,"",617,436);
	}
	
</script>
<style>
.dhx_calendar{
	padding-bottom: 0;
	padding-top: 3%;
}
.dhx_calendar-day{
	margin-bottom: 1%;
}
</style>
<div id="schdlInfo">
	<div id="calendarDiv">	
		<div id="calendar"></div>	
	</div>	
	<div id="schdlList">
		There is no schedule.
	</div>
</div>