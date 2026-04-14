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
<!-- 1. Include JSP -->
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>

<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "Yncc";
var olmloginID="${loginid}";
var olmloginPW="${pwd}";
var olmloginLng="${lng}";

$(document).ready(function(){ 
$(".doLogin").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
$(".login").click(function() {fnLogin(true);});

	if(olmloginID != ""){
		$("#wrapper1").attr("style", "display:none;");
		$('#LOGIN_ID').val(olmloginID);
		$('#PASSWORD').val(olmloginPW);
		$('#LANGUAGEID').val(olmloginLng);
		fnLogin(false);
	}else{
		//fnSelect('LANGUAGE','','langType',olmloginLng==""?defaultLang:olmloginLng,'Select');
		//fnInitDisplay();fnInitCooki();		
		$("#wrapper1").attr("style", "display:none;");
	}
});
function fnSelect(id,code,menuId,defaultValue,isAll){url = "<c:url value='/ajaxCodeSelect.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxSelect(url,data,id,defaultValue,"n");}
function fnInitDisplay(){$("#wrapper1").attr("style", "display:block;");}
function fnInitCooki(){var val = getCookie("sfolmLgId");if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;document.getElementById("IS_CK").checked = true;}}
function fnLogin(isCheck) {
	var url="",target = "resultLogin",data ="";
    url = "${pageContext.request.contextPath}/custom/yncc/login"+atchUrl+".do"; 
	if(isCheck == undefined){isCheck = true;}
	if(isCheck){
		if(!fnCheckValidation()){return;}	
		fnSetCookie();
		data = fnAddData("LOGIN_ID")+fnAddData("LANGUAGE")+fnAddData("PASSWORD")+"&IS_CHECK=Y";
		$("#IS_CHECK").val("Y");
	}else{ // SSLogin	
		data = "LOGIN_ID="+olmloginID+"&PASSWORD="+olmloginPW+"&LANGUAGE="+olmloginLng+"&IS_CHECK=N";
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
function fnReload(isScs){if(isScs=='Y'){ var url = "${root}mainpage.do?loginIdx=${loginIdx}&screenType=${screenType}&srID=${srID}&mainType=${mainType}&sysCode=${sysCode}&status=${status}";var form = $("form")[0];form.action = url;form.submit();}else{/*fnInitDisplay();*/}}
</script>
</head>
<body style="  display: flex;  align-items: center;">	
	<form id="dfForm" name="dfForm" action="" method="post"></form>	
	<div id="wrapper1">
		<div class="logwrap1">
			<div class="loginarea1">
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;">
				<input name="LANGUAGEID" id="LANGUAGEID" type="hidden">
				<input name="IS_CHECK" id="IS_CHECK"  value="${IS_CHECK}" type="hidden">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
				<input name="screenType" id="screenType"  value="${screenType}" type="hidden">
				<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
				<input name="srID" id="srID"  value="${srID}" type="hidden">
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
						</li>
						<li>
							<span><select name="LANGUAGE" id="LANGUAGE" class="language_login"></select></span>
					    </li>
					    <li>
							<div class="login_logo">
								<img src="${root}cmm/common/images/logo_SmartFactory_white.png">
							</div>
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