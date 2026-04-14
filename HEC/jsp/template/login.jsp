<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />

<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<!-- 1. Include JSP -->
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";

$(document).ready(function(){
	
	fnInit();
	$(".doLogin").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
	$(".login").click(function() {fnLogin();});
});
function fnInit(){	
	fnSelect('LANGUAGE', '', 'langType', defaultLang, 'Select');
	fnInitCooki();
}
function fnSelect(id, code, menuId, defaultValue, isAll){
	url = "<c:url value='/ajaxCodeSelect.do'/>";
	data = "ajaxParam1="+code+"&menuId="+menuId;
	ajaxSelect(url, data, id, defaultValue, "n");
}
function fnInitCooki(){
	var val = getCookie("sfolmLgId");
	if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;document.getElementById("IS_CK").checked = true;}
}
function fnLogin() {
	if( !fnCheckValidation()){return;}	
	fnSetCookie();
    var url = "<c:url value='/login/loginbase.do'/>";
	var target = "resultLogin";
	//var data =fnAddData("LOGIN_ID")	+ fnAddData("LANGUAGE")	+ fnAddData("PASSWORD") +"&IS_CHECK=Y";
	//var data ="LOGIN_ID="+$("#LOGIN_ID").val()+"&LANGUAGE="+$("#LANGUAGE").val()+"&PASSWORD="+encodeURIComponent($("#PASSWORD").val()) +"&IS_CHECK=Y";
	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
	//ajaxPage(url, data, target);
}
function fnCheckValidation(){
	var isCheck = true;
	if($('#LOGIN_ID').val() == ""){alert("Enter ID");$('#LOGIN_ID').focus();return false;}
	if($('#PASSWORD').val() == ""){alert("Enter password");$('#PASSWORD').focus();return false;}
	if($('#LANGUAGE').val() == ""){alert("Select lanaguage."); return false;}	
	return isCheck;
}
function fnSetCookie(){if(document.getElementById("IS_CK").checked) { setCookie("sfolmLgId", $('#LOGIN_ID').val(), 180);} else {  setCookie("sfolmLgId", "", -1);}}
function fnReload(isScs) {if(isScs=='Y'){var url = "${root}mainpage.do";var form = $("form")[0]; form.action = url;form.submit();}}
</script>
</head>
<body>
	<form id="dfForm" name="dfForm" action="" method="post"></form>	
	<div id="wrapper1">
		<div class="logwrap1">
			<div class="loginarea1">
			<form id="loginForm" name="loginForm" action="" method="post" onsubmit="return false;">
				<input type="hidden" id="IS_CHECK" name="IS_CHECK" value="Y"/>
				<div class="loginForm1">
					<ul>
						<li>
							<span class="namew"><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/text_id1.png" width="55" height="15" /></span>
							<input class="mgL5" type="text" name="LOGIN_ID" id="LOGIN_ID" value="" size="15" title="ID"  style="ime-mode:inactive;"/>
						</li>
						<li>
							<span class="namew"><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/text_pw1.png" width="71" height="15" /></span>
							<input class="doLogin mgL5" type="password" name="PASSWORD" id="PASSWORD" value="" size="15" title="Password"  style="ime-mode:inactive;"/>
						</li>
						<li>
							<span class="namew mgR5"><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/text_lang1.png" width="76" height="19" /></span>
							<select name="LANGUAGE" id="LANGUAGE" class="text" style="height:20px;width:110px"></select>
						</li>
						<li class="alignR">
							<input  class="pdL40 pdT3" type="checkbox" name="IS_CK" id="IS_CK" value=""/>&nbsp;<font color="#ffffff" class="pdR10">Save ID</font>
						</li>
						<li class="mgT20 alignC">
							<a href="#" class="login"><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/btn_signin.png" title="Login" id="login"/></a>
						</li>
					</ul>
				</div>
			</form>			
			</div>
		</div>
	</div>
<div id="resultLogin"></div>	
<iframe name="saveLgFrame" id="saveLgFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>