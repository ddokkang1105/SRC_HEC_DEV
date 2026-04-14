<%@ page language ="java"
	contentType="text/html; charset=UTF-8" 
	import="java.text.SimpleDateFormat"
%>

<%--
/* ------------------------------------------------------------------------
 * @source  : olmLinkSapPopup.jsp
 * @desc    : SAP Single Sign On 처리
 * ------------------------------------------------------------------------
 * SAP Test Environment
 * Copyright(c) 2016 SMARTFACTORY,  All rights reserved.
 * ------------------------------------------------------------------------
 * VER  DATE         AUTHOR             DESCRIPTION
 * ---  -----------  -----------------  -----------------------------------
 * 1.0  2016.01.09   SMARTFACTORY                Initial
 * ------------------------------------------------------------------------ */
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<html>
<head>
<title>LF SAP Item Popup</title>
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script type="text/javascript">
function ajaxSubmitNoAdd(submitForm, action, iFrameName) {if(action!=null) {submitForm.action = action;}if(iFrameName!=null) {submitForm.target=iFrameName;}else {makeFrame();submitForm.target="saveFrame";} submitForm.submit();return true;}

function fnOnLoad() 
{
	if("${E_RESULT}" == "S"){
		var SAP_R3_NAME = "${SAP_R3_NAME}";
	    var ll_return;                                                               
	    var exeStr_1 = "\"C:\\Program Files\\SAP\\FrontEnd\\SAPgui\\sapshcut.exe \"";
	    var exeStr_1_64 = "\"C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\sapshcut.exe \"";
	    
		//olm 수행
		//sapshcut.exe -guiparm="/M/165.244.231.68/S/sapmsLFP/G/LGFLFP" -u=(유저ID) -pw=(유저P/W) -system=LFP -l=3 -client=100 -command="*YZIDMR100 P_PERNR=(유저사번); P_TCODE=(T-CODE)"
	    
	    var exeStr_2 = "";
	    var exeStr_3 = "-u=${E_UNAME} ";                                                  
	    var exeStr_4 = "-pw=${E_PWD} ";                                                
	    var exeStr_5 = "-system=${SAP_R3_NAME} ";   
	    var exeStr_6 = "-language=3 ";
	    //var exeStr_6 = "-l=3 ";                                               
	    var exeStr_7 = "-client=${SAP_CLIENT_NO} ";                                               
	    var exeStr_8 = "-command=\"*YZIDMR100 P_PERNR=${E_PERNR}; P_TCODE=${T_CODE}\" "; 
	    //var exeStr_8 = "-command=\"*YZIDMR100 P_PERNR=${E_PERNR}\" ";
	
	    if(SAP_R3_NAME == "LFD")      exeStr_2 = "-guiparm=\"165.244.231.75 00\" ";
	    else if(SAP_R3_NAME == "LFQ") exeStr_2 = "-guiparm=\"165.244.231.70 10\" ";
	    //else if(SAP_R3_NAME == "LFP") exeStr_2 = "-guiparm=\"/M/165.244.231.68/S/sapmsLFP/G/LGFLFP /UPDOWNLOAD_CP=8500\" ";
	    else if(SAP_R3_NAME == "LFP") exeStr_2 = "-guiparm=\"/M/165.244.231.68/S/sapmsLFP/G/LGFLFP\" ";
	
		var execStr32 = exeStr_1 + exeStr_2 + exeStr_3 +
		                exeStr_4 + exeStr_5 + exeStr_6 +
		                exeStr_7 + exeStr_8;
		var execStr64 = exeStr_2 + exeStr_3 +
		                exeStr_4 + exeStr_5 + exeStr_6 +
		                exeStr_7 + exeStr_8;	                
		//alert ( execStr64 );
		//ll_return = LgfSapGuiRun.ExcuteFile( execStr32, 1);
		//ll_return = LgfSapGuiRun.ExcuteFile( execStr64, 1);
		//LgfSapGuiRun.ExcuteFile( execStr32, 1);
		//LgfSapGuiRun.ExcuteFile( execStr64, 1);
		LgfSapGuiRun.ExcuteSAPGui( execStr64, 1);
		
		closeThis();
	}else if("${E_RESULT}" == "F"){
	    var frm = document.sapLoginInfo;

		if ( confirm("동일한 사번으로 접속 이력이 존재합니다. \n접속을 강제 종료 하시겠습니까?") ){
		    var url = "${pageContext.request.contextPath}/lf/"+"<c:url value='/closeSAPLFtransaction.do'/>";
			ajaxSubmitNoAdd(document.sapLoginInfo, url,"saveSapFrame");
			
			//frm.method = "post";
			//frm.action = "/idms/system.login.SsoLoginDup.dev";
			//frm.submit();
		}
		else{
			closeThis();
		}
	}else{
		alert("[SAP 로그인에서 실패했습니다.] SAP Message :: " + "${E_MESSAGE}");
	}
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

<body topmargin="0" leftmargin="0" onLoad="fnOnLoad();">
<!-- 
<OBJECT ID="LgfSapGuiRun"
		CLASSID="CLSID:81AE0ECC-D1A9-4550-8559-6AFFA14EFB58"
		CODEBASE="http://localhost/cmm/lf/activeX/LgfSapGuiRun.CAB#version=1,0,0,1"> 
</OBJECT>
 -->

<OBJECT ID="LgfSapGuiRun"
		CLASSID="CLSID:81AE0ECC-D1A9-4550-8559-6AFFA14EFB58"
		CODEBASE="http://sapsso.lgfashion.co.kr/idms/activeX/LgfSapGuiRun.CAB#version=1,0,0,1"> 
</OBJECT>


<FORM name="sapLoginInfo">
	<INPUT name="i_server" type="hidden" value="${E_SERVER}"></INPUT>
	<INPUT name="i_mandt"  type="hidden" value="${E_MANDT}"></INPUT>
	<INPUT name="i_termid" type="hidden" value="${E_TERMID}"></INPUT>
	<INPUT name="i_uname"  type="hidden" value="${E_UNAME}"></INPUT>
	<INPUT name="i_date"   type="hidden" value="${E_LOGON_DATE}"></INPUT>
	<INPUT name="i_time"   type="hidden" value="${E_LOGON_TIME}"></INPUT>
	<INPUT name="i_pernr"  type="hidden" value="${E_PERNR}"></INPUT>
	<INPUT name="p0"  type="hidden" value="2"></INPUT> 
	<INPUT name="p1"  type="hidden" value="${E_PERNR}"></INPUT>
	<INPUT name="usid"  type="hidden" value="${E_PERNR}"></INPUT>
</FORM>
<iframe name="saveSapFrame" id="saveSapFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

</body>
</html>
