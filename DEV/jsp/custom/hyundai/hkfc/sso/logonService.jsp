<%@ page import="nets.sso.agent.web.v2020.authcheck.AuthCheck" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentException" %>
<%@ page import="nets.sso.agent.web.v2020.common.logging.SsoLogger" %>
<%@ page import="nets.sso.agent.web.v2020.conf.AgentConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    try
    {
        // 페이지는 자동으로 이동되니, 페이지 이동은 추가로 기술하지 않습니다.
        AuthCheck auth = new AuthCheck(request, response);
        boolean logonYN = auth.logon(true);
        if (logonYN)
        {
            //인증됨
            String userid = auth.getUserID();
            // 여기에 각 Application 에서 필요한 로그인 처리가 있다면 기술합니다.
        }
    }
    catch (AgentException e)
    {
        SsoLogger.log(AgentConf.LogLevel.ERROR, e, request);
    }
%>
