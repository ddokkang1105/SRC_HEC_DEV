<%@ page import="com.nets.sso.agent.AuthUtil" %>
<%@ page import="com.nets.sso.agent.authcheck.AuthCheck" %>
<%@ page import="com.nets.sso.common.AgentException" %>
<%@ page import="com.nets.sso.common.AgentExceptionCode" %>
<%@ page import="com.nets.sso.common.Utility" %>
<%@ page import="com.nets.sso.common.enums.AuthStatus" %>
<%@ page import="java.util.Enumeration" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
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
            //인증정보 모두 보기(화면에서 보고 싶을 때 주석을 제거 하세요)
            if (auth.getUserInfoCollection() != null && auth.getUserInfoCollection().size() > 0) {
                //JDK 1.4
//                for (Enumeration e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
//                    if (Utility.isNullOrEmpty(userInfo) == false)
//                        userInfo += "<br />";
//                    String key = (String) e.nextElement();
//                    userInfo += key + ":" + auth.getUserInfoCollection().get(key);
//                }
                //JDK 1.5
                for (Enumeration<String> e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
                    if (Utility.isNullOrEmpty(userInfo) == false)
                        userInfo += "<br />";
                    String key = e.nextElement();
                    userInfo += key + ":" + auth.getUserInfoCollection().get(key);
                }
            }
            //사용자정보 조회 샘플
            String userinfo = auth.getUserInfo("AttributeName");
            // String somethingUserInfo = auth.getUserInfo("조회할이름");	//조회할 이름은 프로젝트 시, 정해지면 전달해드립니다.
            //선입자를 끊고, 내가 인증 성공했을 경우, 선입자의 정보를 보여준다.
            if (Utility.isNullOrEmpty(auth.getDuplicationIP()) == false) {
                String dupInfo = "(끊어진 사용자정보)\\nIP:" + auth.getDuplicationIP() + "\\nTime:" + auth.getDuplicationTime();
                scriptMsg = "alertError('" + dupInfo + "', '');";
            }
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
            <%-- 
        	window.location.href = "/ktng/sso/logon.do?<%=returnUrlTagName%>=<%=Utility.encodeUrl(auth.getThisUrl(), "UTF-8")%>";
        	 
        	window.location.href = "/custom/ktng/index.do?LOGIN_ID=<%=logonId%>";
        	--%>
        	// form

        	var form = document.createElement("form");     
        	form.setAttribute("method","post");                    
        	form.setAttribute("action","/custom/ktng/index.do");        
        	document.body.appendChild(form);                        

        	var input_id = document.createElement("input");  
        	input_id.setAttribute("type", "hidden");                 
        	input_id.setAttribute("name", "LOGIN_ID");
        	input_id.setAttribute("value", "<%=logonId%>");   
        	form.appendChild(input_id);
        	
        	var ktngSSO = document.createElement("input");  
        	ktngSSO.setAttribute("type", "hidden");                 
        	ktngSSO.setAttribute("name", "ktngSSO");
        	ktngSSO.setAttribute("value", "T");
        	form.appendChild(ktngSSO);
        	                       
        	form.submit();  
        }
    </script>
</head>
<body>
    <script language="javascript"><%=scriptMsg%></script>
    사용자:<%=logonId %><br/>
    사용자 속성<br/><%=userInfo%><br/><br/>
    <input type="button" value="로그오프" onclick="OnLogoff();"/><br><br/>
</body>
</html>
<%
} catch (Exception e) {
    //2025-03-25 소스코드 취약점 수정
    log.error("Exception", e);
%><%=e.toString()%><%
    }
%>



