<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
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

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "base";
var type = "<%=request.getParameter("mainType") == null ? "" : request.getParameter("mainType")%>";
var pwdEnc = "<%=GlobalVal.PWD_ENCODING%>";
var lockYN = "N";

$(document).ready(function(){
	fnInit();
	$(".logwrap1").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
	$(".login").click(function() {fnLogin();});
});
function fnInit(){	
	fnSelect('LANGUAGE', '', 'langType', defaultLang, 'Select');
// 	fnSelect('USER_TIME_ZONE', '', 'timeZone', '', 'Select');
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
	
	console.log("url : "+url);
	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
	//ajaxPage(url, data, target);
}
function fnCheckValidation(){
	var isCheck = true;
	if($('#LOGIN_ID').val() == ""){alert("Enter login ID");$('#LOGIN_ID').focus();return false;}
	if($('#PASSWORD').val() == ""){alert("Enter passoword");$('#PASSWORD').focus();return false;}
	if($('#LANGUAGE').val() == ""){alert("Select language"); return false;}	
	return isCheck;
}
function fnSetCookie(){
    if(document.getElementById("IS_CK").checked) { setCookie("sfolmLgId", $('#LOGIN_ID').val(), 180);} else {  setCookie("sfolmLgId", "", -1);  }
}
function fnReload(isScs,sessionTime){
	if(isScs == 'Y' && type == "linkPop") {
		
		parent.fnReload();
	}
	else if(isScs=='Y'){
		console.log("timeout="+sessionTime);
		var url = "${root}mainpage.do?loginIdx=${loginIdx}";
		var form = $("form")[0];
		if(sessionTime !=0 && sessionTime!= null){
			url = "${root}mainpage.do?loginIdx=${loginIdx}&timeout="+sessionTime;
		}
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

</script>
</head>
<body style="  display: flex;  align-items: center;">	
<form id="dfForm" name="dfForm" action="" method="post">
	<input name="srID" id="srID"  value="${srID}" type="hidden">
	<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
	<input name="wfInstanceID" id="wfInstanceID"  value="${wfInstanceID}" type="hidden">
	<input name="defArcCode" id="defArcCode"  value="${defArcCode}" type="hidden">
</form>	
<div id="wrapper1">
	<div class="logwrap1">
		<div class="loginarea1">
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
			    <input name="iv" id="iv"  value="" type="hidden">
			    <input name="salt" id="salt"  value="" type="hidden">
			    <input name="keepLoginYN" id="keepLoginYN"  value="${keepLoginYN}" type="hidden">
				<div class="loginForm1">
					<ul>
						<li style="text-align:center;font-wieght:bold;font-size:24px;color:#fff;">LOG IN</li>
						<li>
							<span><input class="fllogin" type="text" name="LOGIN_ID" id="LOGIN_ID" value="" size="15" title="ID"  style="ime-mode:inactive;" placeholder="ID"/></span>
						</li>
						<li>
							<span><input class="fllogin" type="password" name="PASSWORD" id="PASSWORD" value="" size="15" title="Password"  style="ime-mode:inactive;" placeholder="PASSWORD"/></span>
						</li>
						<li>
							<input type="checkbox" name="IS_CK" id="IS_CK" style="width:10%;margin-left:-4px;" value=""/>SAVE ID</font>
						</li>
						<li class="">
							<a href="#" class="login"><div class="btn_login">CONITINUE</div></a>
							<a href="#" class="lock" style="display:none;"><div class="btn_lock">1:00</div></a>
						</li>
						<li class="align-center flex justify-between mgT20">
							<label for="LANGUAGE">Language</label>
							<select name="LANGUAGE" id="LANGUAGE" class="language_login" style="width: 150px;"></select>
					    </li>
					    <!-- 
					    <li class="align-center flex justify-between">
							<label for="USER_TIME_ZONE">Time Zone</label>
							<select name="USER_TIME_ZONE" id="USER_TIME_ZONE" class="language_login" style="width: 150px;"></select>
					    </li>
					     -->
					    <li>
							<div class="login_logo"><img src="${root}${HTML_IMG_DIR}/logo_white.png"></div>
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