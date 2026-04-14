﻿﻿<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<script src="${root}cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var type = "<%=request.getParameter("mainType") == null ? "" : request.getParameter("mainType")%>";
var pwdEnc = "<%=GlobalVal.PWD_ENCODING%>";
var skSSO="${skSSO}";

var path ="${path}";

$(document).ready(function(){
// 	fnInit();
fnInitCookie();

	$(".login-form").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
	$(".login-btn").click(function() {fnLogin();});
	$(".sso-login-btn").click(function() {fnSSOLogin();});
	
	if(path == "global"){
		$(".sso-login-btn").attr("style", "display:none;");
	}
	
	if(skSSO != ""){
		$(".login-container").attr("style", "display:none;");
		fnLogin(false);
	}
});

function fnSelect(id, code, menuId, defaultValue, isAll){
	url = "<c:url value='/ajaxCodeSelect.do'/>";
	data = "ajaxParam1="+code+"&menuId="+menuId;
	ajaxSelect(url, data, id, defaultValue, "n");
}
function fnInitCookie(){
	var val = getCookie("sfolmLgId");
	if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;
	document.getElementById("IS_CK").checked = true;}
}

function fnLogin(isCheck) {
    var url = "<c:url value='/custom/sk/loginCheck.do'/>";
	if(isCheck == undefined){isCheck = true;}
	if(isCheck){
		if( !fnCheckValidation()){return;}	
		fnSetCookie();
		var pwd = $("#PASSWORD").val();
		
		if(pwdEnc == "Y") {
			var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
			pwd = aesUtil.encrypt(SALT, IV, PASSPHARSE, pwd);
		}
	
		$("#PASSWORD").val(pwd);
	} else { // SSO Login
		$('#LOGIN_ID').val("${loginid}");
		$('#LANGUAGE').val("${lng}");
	}
	
	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
	//ajaxPage(url, data, target);
}

function fnSSOLogin() {
//     var url = "<c:url value='/indexSK.jsp'/>";
// 	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
	location.href="/indexSK.jsp"
}

function fnCheckValidation(){
	var isCheck = true;
	if($('#LOGIN_ID').val() == ""){alert("Enter login ID");$('#LOGIN_ID').focus();return false;}
	if($('#PASSWORD').val() == ""){alert("Enter passoword");$('#PASSWORD').focus();return false;}
// 	if($('#LANGUAGE').val() == ""){alert("Select language"); return false;}	
	return isCheck;
}
function fnSetCookie(){
    if(document.getElementById("IS_CK").checked) { setCookie("sfolmLgId", $('#LOGIN_ID').val(), 180);} else {  setCookie("sfolmLgId", "", -1);  }
}
function fnReload(isScs){
	if(isScs == 'Y' && type == "linkPop") {
		parent.fnReload();
	}
}

function fnReloadLock(){
	alert("비밀번호 입력 오류 5회 초과로, 해제 후 이용할 수 있습니다.\n관리자에게 문의하세요.")
}

function leadingZero(num) {
    return (num < 10 ? "0" : "") + num;
}

function fnConfirmDuplicateLogin(loginId,pwd,languageID,loginIdx){	
	var url = "/login/confirmDuplicateLogin.do";
	var form = $("form")[0];
	var input = document.createElement("input");
     input.id = "LOGIN_ID";
     input.name = "LOGIN_ID";
     input.type = "hidden";
     input.value = loginId;
     form.appendChild(input);
     
     input = document.createElement("input");
     input.id = "PASSWORD";
     input.name = "PASSWORD";
     input.type = "hidden";
     input.value = pwd;
     form.appendChild(input);
     
     input = document.createElement("input");
     input.id = "LANGUAGE";
     input.name = "LANGUAGE";
     input.type = "hidden";
     input.value = languageID;
     form.appendChild(input);
     
     input = document.createElement("input");
     input.id = "loginIdx";
     input.name = "loginIdx";
     input.type = "hidden";
     input.value = loginIdx;
     form.appendChild(input);
	
	form.action = url;
	form.submit();
}

function authFailed() {
	alert("The authentication numbers do not match.")
}

function ldapFailed() {
	alert("ldap 인증 안됨");
}

function authTimeOut() {
	alert("3 minutes have passed. Please request the authentication number again.")
}
function deactive() {
	alert("The user information does not exist or the user has expired.");
	location.href = "/custom/sk/loginAuth.do";
}
</script>
<style>
	.login-container {
		background: #fff;
	}
	.login-img {
	    width: 100%;
    height: 100%;
    position: relative;
    background: url(/cmm/sf/images/login-bg.jpg);
    background-size: cover;
    background-position-x: 56%;
	}
	.radio-group {
		margin-bottom:30px;
	}
</style>
</head>
<body style="  display: flex;  align-items: center;">	
<form id="dfForm" name="dfForm" action="" method="post">
	<input name="srID" id="srID"  value="${srID}" type="hidden">
	<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
	<input name="wfInstanceID" id="wfInstanceID"  value="${wfInstanceID}" type="hidden">
	<input name="defArcCode" id="defArcCode"  value="${defArcCode}" type="hidden">
	<input type="hidden" id="linkUrl" name="linkUrl" value="${linkUrl}" >
	
</form>	
<div class="align-center flex login-container">
	<div class="login-img"></div>
	<div style="width: 1300px;margin: 0 auto;display: flex;flex-direction: column;align-items: center;" >
		<div class="login-form-container" style="box-shadow: none;">
			<img src="${root}${HTML_IMG_DIR}logo.png" class="logo" alt="logo" style="margin: 0 auto 50px;"/>
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;" class="login-form">
				<input name="LANGUAGE" id="LANGUAGE"  value=<%=GlobalVal.DEFAULT_LANGUAGE%> type="hidden">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
			    <input name="iv" id="iv"  value="" type="hidden">
			    <input name="salt" id="salt"  value="" type="hidden">
			    <input name="keepLoginYN" id="keepLoginYN"  value="${keepLoginYN}" type="hidden">
			    <input name="authStep" id="authStep" value="" type="hidden">
			    <input type="hidden" id="skSSO" name="skSSO" value="${skSSO}"/>
				<ul>
					<li class="login-form-wrapper">
					</li>
					<li class="login-form-wrapper">
						<label for="LOGIN_ID" class="label">아이디</label>
						<input type="text" name="LOGIN_ID" id="LOGIN_ID" class="input-text"/>
					</li>
					<li class="login-form-wrapper">
						<label for="PASSWORD" class="label">Password</label>
						<input type="password" name="PASSWORD" id="PASSWORD" class="input-text"/>
					</li>
					<li class="login-form-wrapper" id="authentication-wrapper">
						<label for="authentication" class="label">Authentication Code</label>
						<div class="auth-container">
							<input type="text" name="authNumber" id="authNumber" class="input-text" disabled/>
							<button type="button" class="auth-btn" id="auth-btn" onclick="fnLogin()">Authentication Code</button>
						</div>
					</li>
				</ul>
				<input type="checkbox" name="IS_CK" id="IS_CK"  class="input-check"/><label for="IS_CK">아이디 기억하기</label>
				<button class="login-btn" id="login-btn" disabled>Login</button>
				<button class="sso-login-btn" id="sso-login-btn" >SSO Login</button>
			</form>
		</div>
		<div class="login-desc">
			· If you lose your ID/password, you can find it in the integrated Groupware.
		</div>
	</div>
</div>
<div id="resultLogin"></div>	
<iframe name="saveLgFrame" id="saveLgFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>