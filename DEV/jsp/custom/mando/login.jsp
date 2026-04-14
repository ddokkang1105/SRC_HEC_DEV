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
<link rel="stylesheet" type="text/css" href="${root}cmm/mando/css/mnd.css"/>
<script src="${root}cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
var olmloginID="${loginid}";
var olmloginPW="${pwd}";
var olmloginLng="${lng}";
$(document).ready(function(){ 
	var ssoYN = "${ssoYN}";
	
	$(window).resize(function(){
	  $('.login_area').css({
		position:'absolute',
		left: ($(window).width() - $('.login_area').outerWidth())/2,
		top: ($(window).height() - $('.login_area').outerHeight())/2-10
	  });
	}).resize();

	if(olmloginID != ""){
		$("#login_wrap").attr("style", "display:none;");
		$('#LOGIN_ID').val(olmloginID);
		$('#PASSWORD').val(olmloginPW);
		$('#LANGUAGEID').val(olmloginLng);
		fnLogin(false);
	}else{
		fnSelect('LANGUAGE','','langType',olmloginLng==""?defaultLang:olmloginLng,'Select');
		fnInitDisplay();fnInitCooki();		
		$("#PASSWORD").keyup(function() {if(event.keyCode == '13') {fnLogin();}});
		$("#login_button").click(function() {fnLogin(true);});
	}

	var sessionLoginId = "${sessionScope.loginInfo.sessionLoginId}";
	
	if(ssoYN == "Y" && sessionLoginId != "" && sessionLoginId != "guest") {
		$("#login_wrap").attr("style", "display:none;");
		fnReload("Y");
	}
		
	/*
	$('.selectyze1').Selectyze({
		theme : 'css1'
	});*/
});
function fnSelect(id,code,menuId,defaultValue,isAll){url = "<c:url value='/ajaxCodeSelect.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxSelect(url,data,id,defaultValue,"n");}
function fnInitDisplay(){$("#wrapper1").attr("style", "display:block;");}
function fnInitCooki(){var val = getCookie("sfolmLgId");if( val == false){document.getElementById("LOGIN_ID").focus();} else{$('#LOGIN_ID').val(val) ;document.getElementById("IS_CK").checked = true;}}
function fnLogin(isCheck) {
	var url="",target = "resultLogin",data ="";
	var is_check = "${IS_CHECK}";
    url = "${pageContext.request.contextPath}/mando/login"+atchUrl+".do"; 
	if(isCheck == undefined){isCheck = true;}
	if(isCheck){
		if(!fnCheckValidation()){return;}	
		fnSetCookie();
		var pwd = $("#PASSWORD").val(); 
		if(is_check != "N") { 
			var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
			pwd = aesUtil.encrypt(SALT, IV, PASSPHARSE, pwd);
		}
		$("#PASSWORD").val(pwd);
		data = fnAddData("LOGIN_ID")+fnAddData("LANGUAGE")+"&PASSWORD="+pwd;
	}else{ // SSLogin	
		
		if(is_check != "N" && olmloginPW != "") { 
			var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT0);
			olmloginPW = aesUtil.encrypt(SALT, IV, PASSPHARSE, olmloginPW);
		}
	
		$("#PASSWORD").val(olmloginPW);
		data = "LOGIN_ID="+olmloginID+"&PASSWORD="+olmloginPW+"&LANGUAGE="+olmloginLng;
	}
	$("#iv").val(IV);
	$("#salt").val(SALT);

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
<body>	
	<form id="dfForm" name="dfForm" action="" method="post"></form>	
	<div id="login_wrap">
	<p class="login_logo"><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/login_logo.png" /></p>
	  <div class="login_area">
	    <h1><img src="${pageContext.request.contextPath}/${HTML_IMG_DIR}/login_title.png" alt="G-BPMS" /></h1>
	    <div class="login_box">
	      <form id="loginForm" name="loginForm" action="#" method="post" onsubmit="return false;">
	      <input name="LANGUAGEID" id="LANGUAGEID" type="hidden">
		  <input name="loginIdx" id="loginIdx"  value="${loginIdx}" type="hidden">
		  <input name="screenType" id="screenType"  value="${screenType}" type="hidden">
		  <input name="mainType" id="mainType"  value="${mainType}" type="hidden">
		  <input name="srID" id="srID"  value="${srID}" type="hidden">
		  <input name="iv" id="iv"  value="" type="hidden">
		  <input name="salt" id="salt"  value="" type="hidden">
	      <div class="login_input">
	        <p>
	          <label for="id">Login ID</label>
	          <input type="text" name="LOGIN_ID" id="LOGIN_ID" value="${loginid}">
	        </p>
	        <p>
	          <label for="pw">Password</label>
	          <input type="password" name="PASSWORD" id="PASSWORD">
	        </p>
	        <p>
	          <label>Language</label>
	          <select class="language_select" name="LANGUAGE" id="LANGUAGE"></select>
	        </p>
	        <p style="text-align: right;">
	        <input type="checkbox" name="IS_CK" id="IS_CK" value="" style="width:15px;background:none;"/>&nbsp;<font color="#ffffff" >Save ID</font>
	        </p>
	      </div>
		  </form>
	    </div>
	    <div class="login_btn">
	      <input type="button" id="login_button" value="Login" class="btn_comm btn_login"/>
	    </div>
	  </div>
	</div>
<div id="resultLogin"></div>	
<iframe name="saveLgFrame" id="saveLgFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>