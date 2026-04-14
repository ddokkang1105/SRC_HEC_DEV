<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page import="nets.sso.agent.web.v2020.authcheck.AuthCheck" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.LiteralConst" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.ParamInfo" %>
<%@ page import="nets.sso.agent.web.v2020.common.enums.AuthStatus" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentException" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentExceptionCode" %>
<%@ page import="nets.sso.agent.web.v2020.common.logging.SsoLogger" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.Encode" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.WebUtil" %>
<%@ page import="nets.sso.agent.web.v2020.conf.AgentConf" %>
<%@ page import="java.util.Iterator" %>
<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String hkfcSSO = "";
	String olmLoginid = request.getParameter("olmLoginid") == null ? "" : request.getParameter("olmLoginid");
	//String languageID = request.getParameter("languageID") == null ? GlobalVal.DEFAULT_LANGUAGE: request.getParameter("languageID");
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
	
	String wfInstanceID = request.getParameter("wfInstanceID") == null ? "" : request.getParameter("wfInstanceID");
	String srID = request.getParameter("srID") == null ? "" : request.getParameter("srID");
	String mainType = request.getParameter("mainType") == null ? "" : request.getParameter("mainType");
	
%>

<%

    try
    {
        String loginUrl = "http://ssodev.hyundai-kefico.com:9090/login/";       // 로그인 URL
        String logoutUrl = "";      // 로그아웃 URL
        String returnScript = "";   // 로그아웃,로그인, KPAL 메인 해야 할 경우 사용할 스크립트
        String userId = "";         // 사용자 아이디
        String userAttributes = ""; // 사용자 속성

        // 인증 객체 선언(Request와 Response 인계)
        AuthCheck auth = new AuthCheck(request, response);
        // 인증 체크(인증 상태 값 리턴)
        AuthStatus status = auth.checkLogon();

        // 인증 체크 후 상세 에러코드 조회
        String errorCode = String.valueOf(auth.getErrCode());
        String errorMessage = auth.getErrMsg();

        if (status != AuthStatus.SSOUnAvailable)
        {
            // 로그오프 URL 설정
            logoutUrl = auth.getSsoSite().getProviderLogoutUrl(request) + "?" +
                    ParamInfo.SITE_ID + "=" + auth.getSsoSite().getCode() + "&" +
                    ParamInfo.RETURN_URL + "=" + Encode.url(auth.getThisUrl(), LiteralConst.UTF_8);       // ThisURL은 사용자가 현재 호출한 페이지의 URL

            // 로그온 URL 설정
            //loginUrl = auth.getSsoSite().getLoginUrl();
            if (StrUtil.isNullOrEmpty(loginUrl)){
                //loginUrl = "logon.jsp";
			}
            loginUrl += (loginUrl.contains("?") ? "&" : "?")
                    + ParamInfo.SITE_ID + "=" + auth.getSsoSite().getCode()
                    + "&" + ParamInfo.RETURN_URL + "=" + Encode.url(auth.getThisUrl(), LiteralConst.UTF_8);
        }

        //인증상태별 처리
        if (status == AuthStatus.SSOSuccess)
        {
            // ---------------------------------------------------------------------
            // 인증 상태: 인증 성공
            // - 인증 토큰(쿠키) 존재하고, 토큰 형식에 맞고, SSO 정책 체크 결과 유효함.
            // ---------------------------------------------------------------------

            // 사용자 아이디 추출
            userId = auth.getUserID();
            // 사용자 속성 모두 조회(전달되는 사용자 속성을 보여주기 위한 코드. 프로젝트 개발 시 필요 없으면 제거)
            if (auth.getUserInfoCollection() != null && auth.getUserInfoCollection().size() > 0)
            {
                Iterator<String> keys = auth.getUserInfoCollection().keySet().iterator();
                while (keys.hasNext())
                {
                    if (StrUtil.isNotEmpty(userAttributes))
                    {
                        userAttributes += "<br />";
                    }
                    String key = keys.next();
                    userAttributes += key + ":" + auth.getUserInfoCollection().get(key);
                }
            }

            // 사용자 속성 중 특정 사용자 속성 값 조회(사용자 이름, 조직 코드 등. 필요 없다면 제거)
            String somethingUserAttribute = auth.getUserInfo("AttributeName");
            hkfcSSO = "T";
			if(object != "" && linkType != "" && linkID != "" && mainType == "" ){
				//Nets SSO Item popup
				returnScript = "goOlmNetsLink();";
				System.out.println("goOlmNetsLink");
			}else if(mainType != ""){
				
			}
			else{
				//메인 페이지 이동
				returnScript = "goOLMIndexPage();";
				System.out.println("goOLMIndexPage");
			}

        }
        else if (status == AuthStatus.SSOFirstAccess)
        {
            // ---------------------------------------------------------------------
            // 인증 상태: 최초 접근
            // - 인증 토큰(쿠키)가 존재하지 않음.
            // ---------------------------------------------------------------------

            // 인증 확인을 위해 페이지 이동

            // ThisURL을 이용하여 현재 페이지로 다시 돌아오도록 함.
            // authCheck.TrySSO("되돌아올URL");
            // 직접 되돌아 올 URL을 직접 입력하여 호출 할 수도 있음
            auth.trySSO();
        }
        else if (status == AuthStatus.SSOFail)
        {
            // ---------------------------------------------------------------------
            // 인증 상태 : 인증 실패 또는 로그오프 상태
            // - 인증 오류 발생 또는 로그온 하지 않은 로그오프 상태
            // ---------------------------------------------------------------------
            // 상태 구분은 ErrorCode로 판별
            if (auth.getErrCode() == AgentExceptionCode.NoException.getValue())
            {
                // 오류없음: 로그오프 상태 -> 로그온 페이지 이동
                returnScript = "goLogin();";
            }
            else if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue())
            {
                // 중복 로그온 발생 (로그아웃 상황)
                errorMessage += " IP:" + auth.getDuplicationIP() + " Time:" + auth.getDuplicationTime();
                returnScript = "goLogout('" + errorMessage + "');";
            }
            else if (auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue())
            {
                // 사용자 인증 세션 부재 (로그아웃 상황)
                returnScript = "goLogout('" + errorMessage + "');";
            }
            else if (auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue())
            {
                // 인증 유휴 시간을 초과 (로그아웃 상황)
                returnScript = "goLogout('" + errorMessage + "');";
            }
            else if (auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue())
            {
                // 인증 기한 만료 (로그아웃 상황)
                returnScript = "goLogout('" + errorMessage + "');";
            }

        }
        else if (status == AuthStatus.SSOUnAvailable)
        {
            // ---------------------------------------------------------------------
            // 인증 상태: 서비스 불가
            // - 네트워크 장애 또는 DB or SSO 서버 정지 등
            // ---------------------------------------------------------------------

            // SSO 로그온이 아닌 로컬 로그온을 유도
            //response.sendRedirect("logon.jsp");
        }
%>
<!DOCTYPE html>
<html>
<head>
    <title>NETS*SSO</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript">
        function goLogout(msg) {
            location.href = '<%=WebUtil.stripTag(logoutUrl)%>';
        }
		function goLogin() {
			location.href = '<%=WebUtil.stripTag(loginUrl)%>';
        }

		function goOlmNetsLink() {
            var theForm = document.olmNetsLink;
            theForm.submit();
		}
		//로그인 페이지 이동
        function goOLMIndexPage() {
			var theForm = document.olmNetsSSOLogin;
			
			var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
			var LOGIN_ID = aesUtil.encrypt(SALT, IV, PASSPHARSE, '<%=userId%>');
			
			var PWD_KEY = aesUtil.encrypt(SALT, IV, PASSPHARSE, '<%=GlobalVal.PWD_KEY%>');

			document.getElementById('salt').value = SALT;
			document.getElementById('iv').value = IV;
			document.getElementById('PWD_KEY').value = PWD_KEY;

			var input1 = document.createElement('input');
			// set attribute (input)
			input1.setAttribute("type", "hidden");
			input1.setAttribute("id", "LOGIN_ID");
			input1.setAttribute("name", "LOGIN_ID");
			input1.setAttribute("value", LOGIN_ID);
			
			theForm.append(input1);

            theForm.submit();
			// form
        }
    </script>
</head>
<body>



<form id="olmNetsSSOLogin" name="olmNetsSSOLogin" action="/custom/hyundai/indexHKFC.do" method="post">
	<input name="hkfcSSO" id="hkfcSSO" type="hidden" value="T">
	<input name="salt" id="salt" type="hidden" value="">
	<input name="iv" id="iv" type="hidden" value="">
	<input name="PWD_KEY" id="PWD_KEY" type="hidden" value="">
</form>

<form id="olmNetsLink" name="olmNetsLink" action="/olmLink.do" method="post">
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
</form>

<form id="olmNetsMasterLink" name="olmNetsMasterLink" action="/login/loginForm.do" method="post">
	
	<input name="olmLoginid" id="olmLoginid" type="hidden" value="<%=userId%>">
	<input name="languageID" id="languageID" type="hidden" value="<%=languageID%>">

	<input name="mainType" id="mainType" type="hidden" value="<%=mainType%>">
	<input name="srID" id="srID" type="hidden" value="<%=srID%>">
	<input name="wfInstanceID" id="wfInstanceID" type="hidden" value="<%=wfInstanceID%>">
</form>


<script type="text/javascript">
    <%=WebUtil.stripTag(returnScript)%>
</script>

</body>
</html>
<%
    }
    catch (AgentException e)
    {
        SsoLogger.log(AgentConf.LogLevel.ERROR, e, request);
    }
%>