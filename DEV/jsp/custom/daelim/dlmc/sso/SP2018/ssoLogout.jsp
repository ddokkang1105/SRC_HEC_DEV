<%@page import="com.rathontech2018.sso.sp.config.Env"%>
<%
    session.invalidate();
    String relayState = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/SP2018/test_sso.jsp";
    String logoutUrl = Env.IDPM_DOMAIN_CONTEXT + Env.IDPO_LOGOUT_REQ_URI + "?RelayState=" + relayState;
    response.sendRedirect(logoutUrl);
%>