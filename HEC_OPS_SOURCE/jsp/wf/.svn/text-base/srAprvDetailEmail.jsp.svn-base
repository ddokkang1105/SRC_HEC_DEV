<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script type="text/javascript">

	function ajaxPage(url, data, target, preHtml, debug, debugTarget) {
		$.ajax({
			url: url,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
			,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
		});
	}
	
	jQuery(document).ready(function() {
		var url="/login/loginCheck.do";
		var data="loginid=${userID}&languageID=${languageID}";
		ajaxPage(url, data, "divResult");
	});

	function fnReload(){					
		var stepInstStatus = "${stepInstStatus}";
		if(stepInstStatus == "2" || stepInstStatus == "3"){
			alert("${msg}"); return;
		}
		var url = "wfDocMgt.do";
		var data = "projectID=${projectID}&pageNum=1&isPop=Y&isMulti=N&actionType=view"
					+"&stepInstID=${stepInstID}"
					+"&actorID=${actorID}"
					+"&stepSeq=${stepSeq}"
					+"&wfInstanceID=${wfInstanceID}"
					+"&wfID=${wfID}"
					+"&documentID=${documentID}"
					+"&srID=${srID}"
					+"&lastSeq=${lastSeq}"
					+"&docCategory=${docCategory}"
					+"&wfMode=${wfMode}";
					
		var w = 1200;
		var h = 650; 
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	};
	
	function fnCallBack(){
		self.close();
	}
	
	function fnProcessCallBackSubmit(url, data) {
		var screenType = "${screenType}";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function doSearchList(){ // updateESR.do callback 동기화 
		self.close();
	}
	
</script>
</head>
<body>
<div id="divResult"></div>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="yes" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
