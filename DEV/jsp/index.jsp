<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<meta name="referrer" content="strict-origin-when-cross-origin" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/> --%>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%;margin:0;}</style>
<script type="text/javascript">

var a = "${olmI}";
var b = encodeURIComponent("${olmP}");
var c = "${olmLng}";
var type="<%=type%>";
var loginIdx = "${loginIdx}";
var lgnUrl="${pageContext.request.contextPath}/login/login"+type+"Form.do?loginid="+a+"&pwd="+b+"&lng="+c+"&loginIdx="+loginIdx;
var checkedDuplicateLoginUrl="${pageContext.request.contextPath}/login/checkedDuplicateLogin.do?loginid="+a+"&pwd="+b+"&lng="+c+"&loginIdx="+loginIdx;
var confirmDuplicateLoginUrl = "${pageContext.request.contextPath}/login/confirmDuplicateLogin.do?loginid="+a+"&pwd="+b+"&lng="+c+"&loginIdx="+loginIdx;

jQuery(document).ready(function() {
	$('#main').attr('src',lgnUrl);
});

function fnLoginForm(keepLoginYN) { document.all.main.src = lgnUrl+"&keepLoginYN="+keepLoginYN;}

function fnCheckedDuplicateLogin(activLoginIp){	
	//main.location = checkedDuplicateLoginUrl+"&activLoginIp="+activLoginIp;
	document.all.main.src = checkedDuplicateLoginUrl+"&activLoginIp="+activLoginIp;
}

function fnCheckedDuplicateLoginOpener(activLoginIp){	
	main.location = checkedDuplicateLoginUrl+"&activLoginIp="+activLoginIp;
}

function fnQuitSystem() {document.all.main.src = "${pageContext.request.contextPath}/login/quitSystem.do?loginid="+a+"&pwd="+b+"&lng="+c+"&loginIdx="+loginIdx;}

 
var closing_window = false;
$(window).on('focus', function () {
	closing_window = false;
 	//if the user interacts with the window, then the window is not being
 	//closed
});

$(window).on('blur', function () {

 closing_window = true;
 if (!document.hidden) { //when the window is being minimized
	 closing_window = false;
 }
 $(window).on('resize', function (e) { //when the window is being maximized
	 closing_window = false;
 });
 $(window).off('resize'); //avoid multiple listening
});

$('html').on('mouseleave', function () {
 closing_window = true;
 //if the user is leaving html, we have more reasons to believe that he's
 //leaving or thinking about closing the window
});

$('html').on('mouseenter', function () {
 closing_window = false;
 //if the user's mouse its on the page, it means you don't need to logout
 //them, didn't it?
});

$(document).on('keydown', function (e) {

 if (e.keyCode == 91 || e.keyCode == 18) {
	 closing_window = false; //shortcuts for ALT+TAB and Window key
 }

 if (e.keyCode == 116 || (e.ctrlKey && e.keyCode == 82)) {
	 closing_window = false; //shortcuts for F5 and CTRL+F5 and CTRL+R
 }
});

//Prevent logout when clicking in a hiperlink
$(document).on("click", "a", function () {
 closing_window = false;
});

//Prevent logout when clicking in a button (if these buttons rediret to some page)
$(document).on("click", "button", function () {
 closing_window = false;

});
//Prevent logout when submiting
$(document).on("submit", "form", function () {
 closing_window = false;
});
//Prevent logout when submiting
$(document).on("click", "input[type=submit]", function () {
 closing_window = false;
}); 

function toDoWhenClosing(){
 $.ajax({
	 type: "POST",
	 url: "/login/toDoWhenClosing.do",
	 // async: false
 });
 return;
}

window.addEventListener('beforeunload', (event) => {
    // Cancel the event as stated by the standard.
    if(closing_window){
	    toDoWhenClosing();
	    //event.preventDefault();
    }
    // Chrome requires returnValue to be set.
    event.returnValue = '';
});

</script>
</head><body><iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe></body></html>