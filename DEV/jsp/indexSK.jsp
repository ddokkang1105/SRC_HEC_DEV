<%@ page import="com.nets.sso.agent.AuthUtil" %>
<%@ page import="com.nets.sso.agent.authcheck.AuthCheck" %>
<%@ page import="com.nets.sso.common.AgentException" %>
<%@ page import="com.nets.sso.common.AgentExceptionCode" %>
<%@ page import="com.nets.sso.common.Utility" %>
<%@ page import="com.nets.sso.common.enums.AuthStatus" %>
<%@ page import="java.util.Enumeration" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String olmLoginid = request.getParameter("olmLoginid ") == null ? "" : request.getParameter("olmLoginid");
	String languageID = request.getParameter("languageID") == null ? "1042" : request.getParameter("languageID");
	String scrnType = request.getParameter("scrnType") == null ? "" : request.getParameter("scrnType");
	String keyId = request.getParameter("keyId") == null ? "" : request.getParameter("keyId");
	String object = request.getParameter("object") == null ? "" : request.getParameter("object");
	String linkType = request.getParameter("linkType") == null ? "" : request.getParameter("linkType");
	String linkID = request.getParameter("linkID") == null ? "" : request.getParameter("linkID");
	String iType = request.getParameter("iType") == null ? "" : request.getParameter("iType");
	String aType = request.getParameter("aType") == null ? "" : request.getParameter("aType");
	String option = request.getParameter("option") == null ? "" : request.getParameter("option");
	String type = request.getParameter("type") == null ? "" : request.getParameter("type");
	String changeSetID = request.getParameter("changeSetID") == null ? "" : request.getParameter("changeSetID");
	String projectType = request.getParameter("projectType") == null ? "" : request.getParameter("projectType");
	String arcCode = request.getParameter("arcCode") == null ? "" : request.getParameter("arcCode");
	String linkUrl = request.getParameter("linkUrl") == null ? "" : request.getParameter("linkUrl");
    	
	String wfInstanceID = request.getParameter("wfInstanceID") == null ? "" : request.getParameter("wfInstanceID");
	String srID = request.getParameter("srID") == null ? "" : request.getParameter("srID");
	String mainType = request.getParameter("mainType") == null ? "" : request.getParameter("mainType");
	String defArcCode = request.getParameter("defArcCode") == null ? "" : request.getParameter("defArcCode");
%>
<%
	String logoffUrl = "";        // 로그오프 URL
	String logonId = "";          // 로그온 된 사용자 아이디
	String userInfo = "";         // 로그온 된 사용자 추가정보
	String scriptMsg = "";        // 에러 메시지
	String returnUrlTagName = ""; // 리턴 URL 태그 이름
	String siteTagName = "";      // 사이트 응용프로그램 태그 이름

 try {
	String userId = "";         // 사용자 아이디

	 // 인증 객체 선언(Request와 Response 인계)
	 AuthCheck auth = new AuthCheck(request, response);
	 // 인증 체크(인증 상태 값 리턴)
	 AuthStatus status = auth.checkLogon();
	 
	//일반 설정값들
     returnUrlTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.RETURN_URL);
     siteTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.SITE_ID);
     logoffUrl = auth.getSsoProvider().getLogoffUrl(request, auth.getSsoSite().getSiteDNS()) + "?" + siteTagName + "=" + auth.getSsoSite().getSiteDNS() + "&" + returnUrlTagName + "=" + Utility.encodeUrl(auth.getThisUrl(), "UTF-8");
     
     //인증상태별 처리
     if (status == AuthStatus.SSOFirstAccess) {
         //최초 접속
         auth.trySSO();
     } else if (status == AuthStatus.SSOSuccess) {
         //사용자정보 조회 샘플
         userId = auth.getUserInfo("empNo");
         
         //인증성공
         scriptMsg = "goOLMIndexPage('"+userId+"');";
     } else if (status == AuthStatus.SSOFail) {
         //인증실패
         if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
             scriptMsg = "alertError('" + auth.getErrCode() + "', '');";
             response.sendRedirect("/custom/sk/loginAuth.do");
         }
			
			//로그오프를 해야하는 상황
         if (auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue() ||
             auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()) {
             scriptMsg += "OnLogoff();";
         }
     } else if (status == AuthStatus.SSOUnAvailable) {
         //SSO장애
         scriptMsg = "alertError('SSO 장애 SSOUnAvailable');";
         response.sendRedirect("/custom/sk/loginAuth.do");
     } else if (status == AuthStatus.SSOAccessDenied) {
         //접근거부
          scriptMsg = "alertError('접근거부 SSOAccessDenied');";
         response.sendRedirect("/custom/sk/loginAuth.do");
     }
	 %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript">
	//에러 메시지 - sk 가이드
	function alertError(msg, url) {
	    if (msg != "")
	        alert(msg);
	    if (url != "")
	        document.location.href = url;
	}
	
	 //로그오프 - sk 가이드
    function OnLogoff() {
        document.location.href = "<%=logoffUrl%>";
    }
	 
  //로그인 페이지 이동 - sk 가이드
    function goLogonPage() {
<%--         window.location.href = "./logon.jsp?<%=returnUrlTagName%>=<%=Utility.encodeUrl(auth.getThisUrl(), "UTF-8")%>"; --%>
  }
	  
	//로그인 페이지 이동
     function goOLMIndexPage(userId) {
    	 document.cookie = "sso=Y";
		
     	var form = document.createElement("form");     
     	form.setAttribute("method","post");                    
     	form.setAttribute("action","/custom/sk/loginAuth.do");        
     	document.body.appendChild(form);                        

     	var input_id = document.createElement("input");  
     	input_id.setAttribute("type", "hidden");                 
     	input_id.setAttribute("name", "loginid");
     	input_id.setAttribute("value", userId);   
     	form.appendChild(input_id);
     	
     	// 패스워드 체크하지 않기 위한 파라미터
     	var skSSO = document.createElement("input");  
     	skSSO.setAttribute("type", "hidden");                 
     	skSSO.setAttribute("name", "IS_CHECK");
     	skSSO.setAttribute("value", "N");
     	form.appendChild(skSSO);
     	
     	var lang = document.createElement("input");  
     	lang.setAttribute("type", "hidden");                 
     	lang.setAttribute("name", "lng");
     	lang.setAttribute("value", <%=languageID%>);
     	form.appendChild(lang);
     	
     	var skSSO = document.createElement("input");
     	skSSO.setAttribute("type", "hidden");                 
     	skSSO.setAttribute("name", "skSSO");
     	skSSO.setAttribute("value", "Y");
     	form.appendChild(skSSO);
     	                       
     	form.submit();
     }
</script>
</head>
<body>
	<form id="form1" method="post">
		<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
		<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
		<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
	
		<input name="olmLoginid" id="olmLoginid" type="hidden" value="<%=userId%>">
		<input name="languageID" id="languageID" type="hidden" value="<%=languageID%>">
		<input name="scrnType" id="scrnType" type="hidden" value="<%=scrnType%>">
		<input name="keyId" id="keyId" type="hidden" value="<%=keyId%>">
		<input name="object" id="object" type="hidden" value="<%=object%>">
		<input name="linkType" id="linkType" type="hidden" value="<%=linkType%>">
		<input name="linkID" id="linkID" type="hidden" value="<%=linkID%>">
		<input name="iType" id="iType" type="hidden" value="<%=iType%>">
		<input name="aType" id="aType" type="hidden" value="<%=aType%>">
		<input name="option" id="option" type="hidden" value="<%=option%>">
		<input name="type" id="type" type="hidden" value="<%=type%>">
		<input name="changeSetID" id="changeSetID" type="hidden" value="<%=changeSetID%>">
		<input name="projectType" id="projectType" type="hidden" value="<%=projectType%>">
		<input name="arcCode" id="arcCode" type="hidden" value="<%=arcCode%>">
		<input name="linkUrl" id="linkUrl" type="hidden" value="<%=linkUrl%>">
	
		<input name="wfInstanceID" id="wfInstanceID" type="hidden" value="<%=wfInstanceID%>">
		<input name="srID" id="srID" type="hidden" value="<%=srID%>">
		<input name="mainType" id="mainType" type="hidden" value="<%=mainType%>">
		<input name="defArcCode" id="defArcCode" type="hidden" value="<%=defArcCode%>">
		
		
		<script><%=scriptMsg%></script>
	    사용자:<%=logonId %><br/>
	    사용자 속성<br/><%=userInfo%><br/><br/>
	    <input type="button" value="로그오프" onclick="OnLogoff();"/><br><br/>
	</form>
</body>
</html>
<%
} catch (AgentException e) {
    e.printStackTrace();
%><%=e.toString()%><%
    }
%>
