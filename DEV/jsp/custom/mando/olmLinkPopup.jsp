<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<% String loginid = request.getParameter("p1");
String languageID = request.getParameter("languageID");
String keyId = request.getParameter("keyId") == null ? "" : request.getParameter("keyId");

String object = request.getParameter("object") == null ? "" : request.getParameter("object");
String linkType = request.getParameter("linkType") == null ? "" : request.getParameter("linkType");
String linkID = request.getParameter("linkID") == null ? "" : request.getParameter("linkID");
String iType = request.getParameter("iType") == null ? "" : request.getParameter("iType");
String aType = request.getParameter("aType") == null ? "" : request.getParameter("aType");
String source = request.getParameter("source") == null ? "" : request.getParameter("source");

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
<script type="text/javascript"> 

function ajaxPage(url, data, target, preHtml, debug, debugTarget) {
	$.ajax({
		url: url,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
		,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
	});
}
var object = "<%=object%>";
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
jQuery(document).ready(function() {
	var loginCheck = "${loginCheck}";
	if(loginCheck == 1 ){
		var url = "${pageContext.request.contextPath}/mando/login"+atchUrl+".do"; 
		var data="LOGIN_ID=${loginid}&languageID=${languageID}&p1=${p1}&p2=${p2}&p3=${p3}&p4=${p4}&p5=${p5}&IS_CHECK=N";
		ajaxPage(url, data, "divResult");
	}else{
		alert("Identification failed"); return;
	}
});
<spring:message code="${DEFAULT_LANG_CODE}.WM00104" var="WM00104" />
function fnReload() {
	var msg = "${WM00104}";	
	var url="";
	if(object==null||object==undefined||object==""){alert(msg);}
	else{
		if(object.toUpperCase()=="ITM"){
			url="olmPopupMasterItem.do?languageID=${languageID}"
					+ "&scrnType=pop&id=<%=keyId%>&object=<%=object%>"
					+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
					+ "&iType=<%=iType%>&aType=<%=aType%>&source=<%=source%>";
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
<body><div id="divResult"></div> 
</html>