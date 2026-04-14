﻿<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<%@ page import="nets.sso.agent.web.v2020.authcheck.AuthCheck" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.LiteralConst" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.ParamInfo" %>
<%@ page import="nets.sso.agent.web.v2020.common.enums.AuthStatus" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentException" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentExceptionCode" %>
<%@ page import="nets.sso.agent.web.v2020.common.logging.SsoLogger" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.Encode" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.v2020.conf.AgentConf" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.WebUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    try
    {
        String returnUrl = "";       // 되돌아올 URL
        String siteID = "";          // 사이트 식별자

        returnUrl = WebUtil.getRequestValue(request, ParamInfo.RETURN_URL, StrUtil.EMPTY_STRING); // 리턴 URL 설정 (인증 후 되돌아 올 URL)
        siteID = WebUtil.getRequestValue(request, ParamInfo.SITE_ID, StrUtil.EMPTY_STRING); // 사이트 식별자 설정
        
%>

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
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
var olmloginID="${loginid}";
var olmloginPW="${pwd}";
var olmloginLng="${lng}";
var ssoUrl="${ssoUrl}";
$(document).ready(function(){
	$(".login").click(function() {fnLogin(true);});
	
	if(olmloginID != ""){
		$("#wrapper1").attr("style", "display:none;");
		$('#LOGIN_ID').val(olmloginID);
		$('#PASSWORD').val(olmloginPW);
		$('#LANGUAGEID').val(olmloginLng);
		fnLogin(false);
	}else{
		fnSelect('LANGUAGE','','langType',olmloginLng==""?defaultLang:olmloginLng,'Select');
		fnInitDisplay();fnInitCooki();
	}
});
function fnSelect(id,code,menuId,defaultValue,isAll){url = "<c:url value='/ajaxCodeSelect.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxSelect(url,data,id,defaultValue,"n");}
function fnInitDisplay(){$("#wrapper1").attr("style", "display:block;");}
function fnInitCooki(){var val = getCookie("sfolmLgId");if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;document.getElementById("IS_CK").checked = true;}}
function fnLogin(isCheck) {
	var data ="";
    
	if(isCheck == undefined){isCheck = true;}
	if(ssoUrl){
		if(!fnCheckValidation()){return;}	
		fnSetCookie();
		data = fnAddData("LOGIN_ID")+fnAddData("LANGUAGE")+fnAddData("PASSWORD")+"&IS_CHECK=Y";
		$("#IS_CHECK").val("Y");
		document.forms["loginForm"].target = "_top";
		document.forms["loginForm"].setAttribute("action","${ssoUrl}");
        document.forms["loginForm"].submit();
	} else {
		var url = "${pageContext.request.contextPath}/custom/ssg/loginSSG.do"; 
		if(isCheck) {
			if(!fnCheckValidation()){return;}	
			fnSetCookie();
			data = fnAddData("LOGIN_ID")+fnAddData("LANGUAGE")+fnAddData("PASSWORD")+"&IS_CHECK=Y";
			$("#IS_CHECK").val("Y");
			ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
		} else{ // SSLogin	
			$("#wrapper1").attr("style", "display:none;");
			$('#LOGIN_ID').val(olmloginID);
			$('#PASSWORD').val(olmloginPW);
			$('#LANGUAGEID').val(olmloginLng);

			data = "LOGIN_ID="+olmloginID+"&PASSWORD="+olmloginPW+"&LANGUAGE="+olmloginLng+"&IS_CHECK=N";
			ajaxSubmitNoAdd(document.loginForm, url,"saveLgFrame");
		}
	}
	
	

}
function fnCheckValidation(){
	var isCheck = true;
	if($('#LOGIN_ID').val() == ""){alert("Enter ID");$('#LOGIN_ID').focus();return false;}
	if($('#PASSWORD').val() == ""){alert("Eneter password");$('#PASSWORD').focus();return false;}
	if($('#LANGUAGE').val() == ""){alert("Select language."); return false;}	
	return isCheck;
}
function fnSetCookie(){if(document.getElementById("IS_CK").checked){setCookie("sfolmLgId", $('#LOGIN_ID').val(), 180);} else {  setCookie("sfolmLgId", "", -1);  }}
function fnReload(isScs){if(isScs=='Y'){ 
	var url = "${root}mainpage.do?loginIdx=${loginIdx}&screenType=${screenType}&srID=${srID}&mainType=${mainType}&sysCode=${sysCode}&status=${status}";
	var form = $("form")[0];
	form.action = url;
	form.submit();
	}else{
		fnInitDisplay();
	}
}
function fnEnterLogin(e) {
	var key = e.key;
	if(key == "Enter") fnLogin(true);
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
	<form id="dfForm" name="dfForm" action="" method="post"></form>
	<div id="wrapper1">
		<div class="logwrap1">
			<div class="loginarea1">
			<form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;" onkeypress="fnEnterLogin(event)">
				<input name="LANGUAGEID" id="LANGUAGEID" type="hidden">
				<input name="IS_CHECK" id="IS_CHECK"  value="${IS_CHECK}" type="hidden">
				<input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
				<input name="screenType" id="screenType"  value="${screenType}" type="hidden">
				<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
				<input name="srID" id="srID"  value="${srID}" type="hidden">
				<input type="hidden" id="emartSSO" name="emartSSO" value="${emartSSO}"/>
				<input type="hidden" name="<%=ParamInfo.CRED_TYPE%>" value="BASIC"/>
				<input type="hidden" name="<%=ParamInfo.RETURN_URL%>" value="<%=WebUtil.stripTag(returnUrl)%>"/>
				<input type="hidden" name="<%=ParamInfo.SITE_ID%>" value="<%=WebUtil.stripTag(siteID)%>"/>
				<input name="keepLoginYN" id="keepLoginYN"  value="${keepLoginYN}" type="hidden">
				<div class="loginForm1" style="padding-bottom:0;">
					<ul>
						<li style="text-align:center;font-wieght:bold;font-size:24px;color:#fff;">LOG IN</li>
						<li>
							<span><input class="fllogin" type="text" name="userID" id="LOGIN_ID" value="" size="15" title="ID"  style="ime-mode:inactive;" placeholder="ID"/></span>
						</li>
						<li>
							<span><input class="fllogin" type="password" name="password" id="PASSWORD" value="" size="15" title="Password"  style="ime-mode:inactive;" placeholder="PASSWORD"/></span>
						</li>
						<li>
							<input type="checkbox" name="IS_CK" id="IS_CK" style="width:10%;margin-left:-4px;" value=""/>SAVE ID</font>
						</li>
						<li class="">
							<a href="#" class="login"><div class="btn_login">CONTINUE</div></a>
						</li>
						<li>
							<span><select name="LANGUAGE" id="LANGUAGE" class="language_login"></select></span>
					    </li>
					    <li>
							<div class="login_logo"><img src="${root}${HTML_IMG_DIR}/logo_white.png"></div>
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
<%
    }
    catch (AgentException e)
    {
        SsoLogger.log(AgentConf.LogLevel.ERROR, e, request);
    }
%>