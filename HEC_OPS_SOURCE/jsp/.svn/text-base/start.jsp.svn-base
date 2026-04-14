<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="ShortCut ICON"  href="/images/favicon.ico"></link>
<title>::: SF OLM :::</title>


<script language="Javascript">

function StartSample() {
	//CreateShortCut();
	document.getElementById("loading").display = "block";
	OpenLogin();
}

function CreateShortCut() {
	 //스크립트를 사용하여 Shortcut 만들기
	 /*
	var WshShell = new ActiveXObject("WScript.Shell");
	strDesktop = WshShell.SpecialFolders("Desktop");
	var oUrlLink = WshShell.CreateShortcut(strDesktop + "\\SF OLM.url" );
	oUrlLink.TargetPath = "${root}start2.jsp";

	oUrlLink.Save();
	*/
}

function OpenLogin() {

	//var dsWindow;
	//dsWindow =
	window.open ("${root}index.do",'_self', "mywindow"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,top=0,left=0,width=1014,height=680");
	//dsWindow = window.open ("http://localhost:8080/keb_xbolt/index.jsp", "mywindow","status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680");
	//dsWindow.moveTo(0, 0);

	//window.open('','_self','');
	//window.close();
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
<body onload="StartSample()">
<div id="loading" class="loading">
	<div class="loadingBar">
		<div class="loadingPadding" ></div>
	</div>
</div>

</body>
</html>

