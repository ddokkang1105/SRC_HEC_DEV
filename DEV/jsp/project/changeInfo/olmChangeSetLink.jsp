<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
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
	var loginid = "${loginid}";
	var sessionUserID="${sessionScope.loginInfo.sessionUserId}";
	
	if(loginid != "" && sessionUserID != "") {

		fnReload();
	}
	else if(loginid != "") {
		var url="/login/loginCheck.do";
		var data="loginid="+loginid+"&languageID=${languageID}";
		ajaxPage(url, data, "divResult");
	}
	else {

		var url="${pageContext.request.contextPath}/login/loginForm.do";
		var data = "?lng=${DEFAULT_LANG_CODE}&mainType=linkPop";
		
		$("#linkMain").attr("src",url+data);
	}
});


function fnReload() {
	var msg = "${WM00104}";	
	var url="";

	url="/olmPopupMasterItem.do?languageID=${languageID}"
			+ "&scrnType=pop&object=CS"
			+ "&linkType=id&linkID=${itemID}&changeSetID=${changeSetID}"
			+ "&option=${arCode}";

	var dsWindow=window.open (url,'_self', "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680,padding=10px");
	dsWindow.moveTo(0, 0);	
		
	
}
function closeThis() {
	//window.close();
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
<body><div id="divResult"></div> <iframe name="linkMain" id="linkMain" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe></body>
</html>