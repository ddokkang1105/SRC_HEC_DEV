﻿<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
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
<%-- <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/> --%>

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "company";
var type = "<%=request.getParameter("mainType") == null ? "" : request.getParameter("mainType")%>";
var pwdEnc = "<%=GlobalVal.PWD_ENCODING%>";
var lockYN = "N";

$(document).ready(function(){
	fnInit();
	$(".login-form").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
	$(".login-btn").click(function() {fnLogin();});
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
	if (lockYN == "Y") return;
	if( !fnCheckValidation()){return;}	
	fnSetCookie();
    var url = "<c:url value='/login/login"+atchUrl+".do'/>";
	//var target = "resultLogin";
	//var data =fnAddData("LOGIN_ID")	+ fnAddData("LANGUAGE")	+ fnAddData("PASSWORD") +"&IS_CK=Y";
	var pwd = $("#PASSWORD").val();
	
	if(pwdEnc == "Y") {
		var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
		pwd = aesUtil.encrypt(SALT, IV, PASSPHARSE, pwd);
	}
	
	$("#PASSWORD").val(pwd);
	$("#iv").val(IV);
	$("#salt").val(SALT);
	
	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
	//ajaxPage(url, data, target);
}
function fnCheckValidation(){
	var isCheck = true;	
	if($('#companyID').val() == ""){alert("Select Company");$('#LOGIN_ID').focus();return false;}
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
	else if(isScs=='Y'){
		var url = "${root}mainpage.do?loginIdx=EClick";
		var form = $("form")[0];
		form.action = url;
		form.submit();
	}
}

function fnReloadLock(){
	// 1분간 lock 처리
    $(".login").hide();
    $(".lock").show();
    lockYN = "Y";
    
    var seconds = 59;
    var countdown = setInterval(function() {
        var minutes = Math.floor(seconds / 60);
        var remainingSeconds = seconds % 60;

        $(".btn_lock").text(minutes + ":" + leadingZero(remainingSeconds));
        if (seconds <= 0) {
        	clearInterval(countdown);
            $(".login").show();
            $(".lock").hide();
            lockYN = "N";
        } 
        seconds--;
    }, 1000);
    
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

function fnPossibleAuth() {
	document.querySelector("#auth-btn").disabled = false;
}

function requestAuth() {
	fetch('/login/requestUserAuth.do', {
		method: 'POST',
		body : JSON.stringify({
			LANGUAGE : defaultLang,
			LOGIN_ID : document.querySelector("#LOGIN_ID").value,
			PASSWORD : document.querySelector("#PASSWORD").value,
			companyID : document.querySelector("#companyID").value,
        }),
		headers: {
			'Content-type': 'application/json; charset=UTF-8',
		},
	})
	.then(res => res.json())
	.then(data => {
		alert(data.message)
		document.querySelector("#authNumber").disabled = false;
		document.querySelector("#authStep").value = "Y";
	})
}

function authFailed() {
	alert("인증번호가 일치하지 않습니다.")
}

</script>
<style>
/* login */
 .login-container {
    background: #EEF1F7;
    width: 100%;
    height: 100%;
    position: relative;
}
 .login-bg {
     background: #182B57;
     height: 420px;
     position:relative;
}
 .login-bg .login-bg-svg {
     mix-blend-mode: overlay;
     position: absolute;
 }
 .login-bg .login-bg-svg.left {
 	left:0;
 }
  .login-bg .login-bg-svg.right {
 	right:0;
 }
  .login-bg .login-bg-svg.top {
 	top:0;
 }
  .login-bg .login-bg-svg.bottom {
 	bottom:0;
 }
 .login-section {
     position: absolute;
     top: 50%;
     left: 50%;
     transform: translate(-50%, -50%);
}
 .login-title-container {
     text-align: center;
     color: #fff;
     margin-bottom: 30px;
}
 .login-title-container .title {
     font-size: 50px;
     font-weight: normal;
}
 .login-form-container {
     background: #fff;
     box-shadow: 0px 3px 20px #0000000F;
     border-radius: 10px;
     text-align: center;
     width: 500px;
}
 .login-form-container .logo {
    margin: 40px 0 25px;
    max-height: 38px;
}
 .login-form-container .login-form {
     padding: 0 40px 40px;
     width: 100%;
     box-sizing: border-box;
     text-align: left;
}
 .login-form-container .login-form .login-form-wrapper .label {
     font-size: 14px;
     color: #222;
     margin-top: 5px;
     display: block;
}
 .login-form-container .login-form .login-form-wrapper .input-text {
     width: 100%;
     height: 36px;
     border-radius: 3px;
     border: 1px solid #ddd;
     margin: 8px 0 10px;
     padding-left: 10px;
     transition: all 0.15s;
     box-sizing: border-box;
}
 .login-form-container .login-form .login-form-wrapper .auth-container {
   	display: flex;
    align-items: center;
    gap: 10px;
 }
 .login-form-container .login-form .login-form-wrapper .auth-btn {
	background: #0761CF;
	color: #fff;
	flex: 1 0 auto;
	padding: 0 15px;
	height: 37px;
	border-radius: 3px;
	border: none;
	font-size: 13px;
	transition: all 0.25s;
	}
 .login-form-container .login-form .login-form-wrapper .auth-btn:disabled {
	cursor: not-allowed;
    background: #ddd;
}
  .login-form-container .login-form .login-form-wrapper .authe-btn.active {
    background: #0761CF;
  }
 .login-form-container .login-form .login-form-wrapper .input-text:focus {
     border-color: #0761CF;
     transition: all 0.15s;
}
 .login-form-container .login-form .input-check {
     overflow: hidden;
     width: 0px;
}
 .login-form-container .login-form .input-check+label{
     -webkit-box-sizing: border-box;
     box-sizing: border-box;
     color: #222;
     position: relative;
}
 .login-form-container .login-form .input-check+label:before {
     position: relative;
     content: "";
     height: 16px;
     width: 16px;
     left: 0px;
     top: 5px;
     display: inline-block;
     border-radius: 3px;
     border: 1px solid #ddd;
     transition: all 0.15s;
     margin-right: 6px;
}
 .login-form-container .login-form .input-check:hover+label:before {
     border-color: #0761CF;
}
 .login-form-container .login-form .input-check:checked+label:before {
     background-color: #0761CF;
     background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' height='20px' viewBox='0 -960 960 960' width='20px' fill='%23FFFFFF'%3E%3Cpath d='M389-267 195-460l51-52 143 143 325-324 51 51-376 375Z'/%3E%3C/svg%3E");
     background-repeat: no-repeat;
     background-position: center center;
     background-size: 16px;
     border: 1px solid #0761CF;
}
 .login-form-container .login-btn {
     display: block;
     background: #0761CF;
     color: #fff;
     border: none;
     width: 100%;
     height: 50px;
     border-radius: 6px;
     margin-top: 40px;
     font-size: 15px;
}

 .login-form-container .sso-login-btn {
     display: block;
     background: #182b57;
     color: #fff;
     border: none;
     width: 100%;
     height: 50px;
     border-radius: 6px;
     margin-top: 10px;
     font-size: 15px;
}

 .login-desc {
     color: #222;
     font-weight: 300;
     font-size: 14px;
     white-space: pre-line;
     width: fit-content;
     margin: 0 auto;
 }
</style>
</head>
<body style="  display: flex;  align-items: center;">	
<form id="dfForm" name="dfForm" action="" method="post">
	<input name="srID" id="srID"  value="${srID}" type="hidden">
	<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
	<input name="wfInstanceID" id="wfInstanceID"  value="${wfInstanceID}" type="hidden">
</form>	
<div class="login-container">
	<div class="login-bg">
		<img src="${root}${HTML_IMG_DIR}/login-bg-1.png" alt="login-bg-1" class="login-bg-svg left top"/>
		<img src="${root}${HTML_IMG_DIR}/login-bg-2.png" alt="login-bg-2" class="login-bg-svg right bottom"/>
	</div>
	<div class="login-section">
		<div class="login-title-container">
			<h1 class="title">로그인</h1>
		</div>
		<div class="login-form-container">
			<img src="${root}${HTML_IMG_DIR}/logo.png" class="logo" alt="logo" />
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;" class="login-form">
				<input name="LANGUAGEID" id="LANGUAGEID"  value=<%=GlobalVal.DEFAULT_LANGUAGE%> type="hidden">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
			    <input name="iv" id="iv"  value="" type="hidden">
			    <input name="salt" id="salt"  value="" type="hidden">
			    <input name="keepLoginYN" id="keepLoginYN"  value="${keepLoginYN}" type="hidden">
			    <input name="authStep" id="authStep" value="" type="hidden">
				<ul>
					<li class="login-form-wrapper">
						<label for="companyID" class="label">회사</label>
						<select id="companyID" name="companyID" class="input-text">
							<c:forEach var="list" items="${companyList}">
								<option value="${list.CODE}">${list.NAME}</option>
							</c:forEach>
						</select>
					</li>
					<li class="login-form-wrapper">
						<label for="LOGIN_ID" class="label">아이디</label>
						<input type="text" name="LOGIN_ID" id="LOGIN_ID" class="input-text"/>
					</li>
					<li class="login-form-wrapper">
						<label for="PASSWORD" class="label">비밀번호</label>
						<input type="password" name="PASSWORD" id="PASSWORD" class="input-text"/>
					</li>
					
					<li class="login-form-wrapper">
						<span><select name="LANGUAGE" id="LANGUAGE" class="input-text"></select></span>
					</li>
					    
<!-- 					<li class="login-form-wrapper"> -->
<!-- 						<label for="authentication" class="label">인증번호</label> -->
<!-- 						<div class="auth-container"> -->
<!-- 							<input type="text" name="authNumber" id="authNumber" class="input-text" disabled/> -->
<!-- 							<button type="button" class="auth-btn" id="auth-btn" disabled onclick="requestAuth()">인증번호 받기</button> -->
<!-- 						</div> -->
<!-- 					</li> -->
				</ul>
				<input type="checkbox" name="IS_CK" id="IS_CK"  class="input-check"/><label for="IS_CK">아이디 기억하기</label>
				<button class="login-btn">로그인</button>
			</form>
		</div>
		<div class="login-desc">
			· 아이디 / 비밀번호 분실시에는 통합그룹웨어에서 찾기가 가능합니다.
			· 이클릭시스템에서는 로그인만 가능합니다.
		</div>
	</div>
</div>
<div id="resultLogin"></div>	
<iframe name="saveLgFrame" id="saveLgFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>