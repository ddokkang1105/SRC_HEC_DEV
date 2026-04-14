<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.custom.cj.val.CJGlobalVal"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%
String object = request.getParameter("object") == null ? "" : request.getParameter("object");
String userId = request.getParameter("userId");
String token = request.getParameter("token");
String language = request.getParameter("language");
%>
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

<script type="text/javascript" src="${pageContext.request.contextPath}/cmm/cj/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="<%=CJGlobalVal.CJ_SSO_URL%>/officeon/js/api/officeon.sso.js"></script>

<script type="text/javascript"> 

function ajaxPage(url, data, target, preHtml, debug, debugTarget) {
	$.ajax({
		url: url,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
		,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
	});
}
var object = "<%=object%>";
jQuery(document).ready(function() {
	var userId = "<%=userId%>";
	var token = "<%=token%>";
	var language = "<%=language%>";
	
	ooSSO.openPage(userId, token, language , function(retData){ //alert("retData.data :"+retData.data);
		if(retData.data == "S"){
			//인증성공 시 페이지 오픈처리
			//alert("Identification success");
			var url = "${pageContext.request.contextPath}/cj/logincj.do"; 
			var data="LOGIN_ID=${loginID}&languageID=${language}&IS_CHECK=N&screenType=link";
			ajaxPage(url, data, "divResult");
		 }else{
			//인증실패 시 처리
			alert("Identification failed");
		} 
	});
});

<spring:message code="${DEFAULT_LANG_CODE}.WM00104" var="WM00104" />

function fnReload() {
	var msg = "${WM00104}";	
	var url="";
	if(object==null||object==undefined||object==""){alert(msg);}
	else{
		if(object.toUpperCase()=="ITM"){
			url="<%=GlobalVal.OLM_SERVER_URL%>olmPopupMasterItem.do?languageID=${languageID}"
					+ "&scrnType=${scrnType}&object=${object}"
					+ "&linkType=${linkType}&linkID=${linkID}&option=${option}&accMode=${accMode}";
		}
		if(url.length>0){
			var dsWindow=window.open (url,'_self', "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680");
			dsWindow.moveTo(0, 0);	
		}else{alert(msg);}
	}
}

function closeThis() {
	if(/MSIE/.test(navigator.userAgent)) {
		if(navigator.appVersion.indexOf("MSIE 8") >= 0 ||
				navigator.appVersion.indexOf("MSIE 7") >= 0 ) {
			window.open('about:blank','_self').close();
		} else {
			window.opener = self;
			self.close();
		}
	} else {
		window.close();
	}
}
</script>
</head>
<body>
	<div id="divResult"></div>
</body></html>