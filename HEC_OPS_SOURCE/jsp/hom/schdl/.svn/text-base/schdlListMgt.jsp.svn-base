<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
String noticType = request.getParameter("noticType") == null ? "4" : request.getParameter("noticType");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script type="text/javascript">
	var noticType;var menuIndex = "1 2 3 4";	
	$(document).ready(function(){
		setSubFrame(noticType);
	});
	function setSubFrame(avg){
		//fnInitValues();$('#noticType').val(avg);
		var url = "goSchdlList.do";		
		var target = "subBFrame";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType="+avg+"";
		data += "&searchViewFlag=${searchViewFlag}&documentID=${documentID}&docCategory=${docCategory}";
		ajaxPage(url, data, target);
		//setSubTab(menuIndex, avg, "pli");
	}

	function fnInitValues(){
		$('#ScheduleID').val("");
		$('#noticType').val("");
	}	

	/*
	function goScheduleList(){
		if(confirm("목록으로 이동하시겠습니까?")){
			var url = "goSchdlList.do";
			var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType="+$('#noticType').val();
			var target="subBFrame";
			ajaxPage(url, data, target);
		}
	}
	//스케쥴 상세화면 이동
	function goSchdlDetail(isNew,scheduleId,pageNum){ 
		var url = "selectSchedulDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew="+isNew+"&scheduleId="+scheduleId+"&pageNum="+pageNum;
		var target = "subBFrame";
		ajaxPage(url, data, target);		
	}
	*/
	function fnGoScheduler(){
		document.location.href = "schedulMgt.do"; return;
		var url = "schedulMgt.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "subBFrame";
		ajaxPage(url, data, target);	
	}
	
</script>
</head>
<body>
<div class="pdL10 pdR10 pdT5">
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ScheduleID" name="ScheduleID" value="">
</form>
<div id="subBFrame" name="subBFrame" style="overflow-x:hidden;overflow-y:hidden;margin:0 auto;"></div>
</div>
</body>
</html>