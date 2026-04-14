<%@ page import="com.nets.sso.agent.AuthUtil" %>
<%@ page import="com.nets.sso.agent.authcheck.AuthCheck" %>
<%@ page import="com.nets.sso.common.AgentException" %>
<%@ page import="com.nets.sso.common.AgentExceptionCode" %>
<%@ page import="com.nets.sso.common.Utility" %>
<%@ page import="com.nets.sso.common.enums.AuthStatus" %>
<%@ page import="java.util.Enumeration" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>

<%


	String ktngSSO = request.getParameter("ktngSSO") == null ? "" : request.getParameter("ktngSSO");
	String olmLoginid = request.getParameter("olmLoginid") == null ? "" : request.getParameter("olmLoginid");
	//String languageID = request.getParameter("languageID") == null ? GlobalVal.DEFAULT_LANGUAGE: request.getParameter("languageID");
	String languageID = request.getParameter("languageID");
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


    String logoffUrl = "";        // 로그오프 URL
    String logonId = "";          // 로그온 된 사용자 아이디
    String userInfo = "";         // 로그온 된 사용자 추가정보
    String scriptMsg = "";        // 에러 메시지
    String returnUrlTagName = ""; // 리턴 URL 태그 이름
    String siteTagName = "";      // 사이트 응용프로그램 태그 이름
    
    final Log log = LogFactory.getLog(this.getClass());
    
    try {
        //인증객체생성 및 인증확인
        AuthCheck auth = new AuthCheck(request, response);
        //인증확인
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
            //인증성공
            //로그인 아이디
            logonId = auth.getUserID();            
            scriptMsg += "goOLMIndexPage();";
        } else if (status == AuthStatus.SSOFail) {
            //인증실패
            if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
                scriptMsg = "alertError('" + auth.getErrCode() + "', '');";
            }
            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) {
                scriptMsg = "alertError('중복로그인 정보 IP:" + auth.getDuplicationIP() + " TIME:" + auth.getDuplicationTime() + "', '');";
            }
            //로그오프를 해야하는 상황
            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue() ||
                    auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue() ||
                    auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue() ||
                    auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()) {
                scriptMsg += "OnLogoff();";
            } else {
                scriptMsg += "goLogonPage();";
            }
        } else if (status == AuthStatus.SSOUnAvailable) {
            //SSO장애
            scriptMsg = "alertError('현재 통합인증 서비스가 불가합니다.', '');";
        } else if (status == AuthStatus.SSOAccessDenied) {
            //접근거부
            response.sendRedirect("denied.jsp");
        }
%>
<!DOCTYPE html>
<head>
    <title>NETS*SSO</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script language="javascript" type="text/javascript">
        //에러 메시지
        function alertError(msg, url) {
            if (msg != "")
                alert(msg);
            if (url != "")
                document.location.href = url;
        }
        //로그오프
        function OnLogoff() {
            document.location.href = "<%=logoffUrl%>";
        }
        //로그인 페이지 이동
        function goLogonPage() {
            window.location.href = "https://iamdev.ktng.com/im/jsp/sso/login/?<%=returnUrlTagName%>=<%=Utility.encodeUrl(auth.getThisUrl(), "UTF-8")%>";
        }
		
      //로그인 페이지 이동
        function goOLMIndexPage() {
            var theForm = document.olmNetsLink;
            theForm.submit();
		}
    </script>
</head>
<body>
	<form id="olmNetsLink" name="olmNetsLink" action="/olmLink.do" method="post">
    	<input name="ktngSSO" id="ktngSSO" type="hidden" value="<%=ktngSSO%>">
    	<input name="olmLoginid" id="olmLoginid" type="hidden" value="<%=logonId%>">
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
    </form>
    
    <script language="javascript"><%=scriptMsg%></script>
</body>
</html>
<%
} catch (AgentException e) {
	//2025-03-25 소스코드 취약점 수정
	log.error("Exception", e);
	//e.printStackTrace();
%><%=e.toString()%><%
    }
%>



