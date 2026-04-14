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

<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${root}cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
var olmloginID="${loginid}";
var olmloginPW="${pwd}";
var olmloginLng="${lng}";
$(document).ready(function(){ 
	if(olmloginID != ""){
		$("#wrapper1").attr("style", "display:none;");
		$('#LOGIN_ID').val(olmloginID);
		$('#PASSWORD').val(olmloginPW);
		$('#LANGUAGEID').val(olmloginLng);
		fnLogin(false);
	}else{
		fnSelect('LANGUAGE','','langType',olmloginLng==""?defaultLang:olmloginLng,'Select');
		fnInitDisplay();fnInitCooki();		
		$(".doLogin").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
		$(".login").click(function() {fnLogin(true);});
	}
	$(".logwrap1").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
});
function fnSelect(id,code,menuId,defaultValue,isAll){url = "<c:url value='/ajaxCodeSelect.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxSelect(url,data,id,defaultValue,"n");}
function fnInitDisplay(){$("#wrapper1").attr("style", "display:block;");}
function fnInitCooki(){var val = getCookie("sfolmLgId");if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;document.getElementById("IS_CK").checked = true;}}
function fnLogin(isCheck) {
	var url="",target = "resultLogin",data ="";
    url = "${pageContext.request.contextPath}/daelim/logindaelim.do"; 
	if(isCheck == undefined){isCheck = true;}
	if(isCheck){
		if(!fnCheckValidation()){return;}	
		fnSetCookie();
		var pwd = $("#PASSWORD").val();
		$("#PASSWORD").val(pwd);
		data = fnAddData("LOGIN_ID")+fnAddData("LANGUAGE")+"&PASSWORD="+pwd;
		$("#IS_CHECK").val("Y");
	}else{ // SSLogin	

		data = "LOGIN_ID="+olmloginID+"&PASSWORD="+olmloginPW+"&LANGUAGE="+olmloginLng;
	}

	ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
}
function fnCheckValidation(){
	var isCheck = true;
	if($('#LOGIN_ID').val() == ""){alert("Enter ID");$('#LOGIN_ID').focus();return false;}
	if($('#PASSWORD').val() == ""){alert("Eneter password");$('#PASSWORD').focus();return false;}
	if($('#LANGUAGE').val() == ""){alert("Select language."); return false;}	
	return isCheck;
}
function fnSetCookie(){if(document.getElementById("IS_CK").checked){setCookie("sfolmLgId", $('#LOGIN_ID').val(), 180);} else {  setCookie("sfolmLgId", "", -1);  }}
function fnReload(isScs){
	if(isScs=='Y'){ 
		var url = "${root}mainpage.do?loginIdx=${loginIdx}&gloProjectID=${gloProjectID}&itemID=${itemID}&focusedItemID=${focusedItemID}";
		var form = $("form")[0];form.action = url;form.submit();
	}else{/*fnInitDisplay();*/}
}
</script>
</head>
<body>	
	<form id="dfForm" name="dfForm" action="" method="post"></form>	
	<div id="wrapper1">
		<div class="logwrap1">
			<div class="loginarea1">
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;">
				<input name="LANGUAGEID" id="LANGUAGEID" type="hidden">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">				
				<input name="empNo" id="empNo"  value="${employeeNum}" type="hidden">
				<input name="language" id="language"  value="${language}" type="hidden">
				<input name="gloProjectID" id="gloProjectID"  value="${gloProjectID}" type="hidden">
				<div class="loginForm1">
					<ul>
						<li>
							<div class="login_logo"><img src="${root}${HTML_IMG_DIR}/logo_SmartFactory_white.png"></div>
						</li>
						<li>
							<!-- span class="namew"><img src="${root}${HTML_IMG_DIR}/text_id1.png" width="55" height="15" /></span-->
							<span><input class="fllogin" type="text" name="LOGIN_ID" id="LOGIN_ID" value="" size="15" title="아이디"  style="ime-mode:inactive;" placeholder="아이디를 입력해 주세요."/></span>
						</li>
						<li>
							<!-- span class="namew"><img src="${root}${HTML_IMG_DIR}/text_pw1.png" width="71" height="15" /></span-->
							<span><input class="fllogin" type="password" name="PASSWORD" id="PASSWORD" value="" size="15" title="비밀번호"  style="ime-mode:inactive;" placeholder="비밀번호를 입력해 주세요."/></span>
						</li>
						<li>
							<!-- span class="namew mgR5"><img src="${root}${HTML_IMG_DIR}/text_lang1.png" width="76" height="19" /></span-->
							<span><select name="LANGUAGE" id="LANGUAGE" class="language_login"></select></span>
					    </li>
						<li>
							<input type="checkbox" name="IS_CK" id="IS_CK" style="width:10%;margin-left:-4px;" value=""/>아이디 저장</font>
						</li>
						<li class="">
							<a href="#" class="login"><div class="btn_login">로그인<!-- img src="${root}${HTML_IMG_DIR}/btn_signin.png" title="로그인" id="login"/--></div></a>
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