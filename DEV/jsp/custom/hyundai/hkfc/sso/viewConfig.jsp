<%@ page import="nets.sso.agent.web.v2020.common.util.WebUtil" %>
<%@ page import="nets.sso.agent.web.v2020.conf.AgentConf" %>
<%@ page import="nets.sso.agent.web.v2020.conf.SSOConfig" %>
<%@ page import="nets.sso.agent.web.v2020.conf.SSOProvider" %>
<%@ page import="nets.sso.agent.web.v2020.conf.SSOSite" %>
<%@ page import="nets.sso.agent.web.v2020.conf.proxy.SsoProxyProvider" %>
<%@ page import="nets.sso.agent.web.v2020.conf.proxy.SsoProxySite" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    SSOProvider provider = SSOConfig.getInstance().getCurrentSSOProvider(request.getServerName());
    SSOSite site = SSOConfig.getInstance().getCurrentSSOSite(request.getServerName());
    AgentConf agentConf = null;
    if (provider != null) agentConf = provider.getAgentConf();
    SsoProxySite proxySite = null;
    if (site != null) proxySite = site.getProxy(request);
    SsoProxyProvider proxyProvider = null;
    if (proxySite != null) proxyProvider = proxySite.getSsoProxyProvider();

    if (null == provider || site == null)
    {
%>Can not find configuration for '<%=WebUtil.stripTag(request.getServerName())%>'.<%
}
else
{
%>
<html>
<head><title>SSO 환경설정</title></head>
<body>

<table>
    <tr>
        <th>policy version</th>
        <td><%=WebUtil.stripTag(String.valueOf(provider.getPolicyVer()))%>
        </td>
    </tr>
    <tr>
        <th>Provider</th>
        <td>
            <ul>
                <li>FQDN: <%=WebUtil.stripTag(provider.getFqdn())%></li>
                <li>context-path: <%=WebUtil.stripTag(provider.getContextPath())%></li>
                <li>service.uri: <%=WebUtil.stripTag(provider.getServiceUrl())%></li>
                <li>port.type: <%=WebUtil.stripTag(provider.getPortType().name())%></li>
                <li>port.http: <%=WebUtil.stripTag(provider.getPortHttp())%></li>
                <li>port.https: <%=WebUtil.stripTag(provider.getPortHttps())%></li>
                <li>ip check: <%=WebUtil.stripTag(String.valueOf(provider.getIpCheckYn()))%></li>
                <li>idle-timeout max: <%=WebUtil.stripTag(String.valueOf(provider.getIdleMin()))%>(min)</li>
                <li>idle-timeout interval: <%=WebUtil.stripTag(String.valueOf(provider.getIdleCheckMin()))%>(min)</li>
                <li>expire: <%=WebUtil.stripTag(String.valueOf(provider.getTokenHour()))%>(hour)</li>
                <li>duplication: <%=WebUtil.stripTag(String.valueOf(provider.getDupYn()))%></li>
                <li>duplication interval: <%=WebUtil.stripTag(String.valueOf(provider.getDupCheckMin()))%>(min)</li>
                <li>validateSecureChannel: <%=WebUtil.stripTag(String.valueOf(provider.isValidateSecureChannel()))%></li>
                <li>connection timeout: <%=WebUtil.stripTag(String.valueOf(provider.getConnectTimeout()))%></li>
                <li>mfa.enable: <%=WebUtil.stripTag(String.valueOf(provider.getMfa().getEnable()))%></li>
                <li>mfa.cookie: <%=WebUtil.stripTag(String.valueOf(provider.getMfa().getCookieName()))%></li>
            </ul>
        </td>
    </tr>
    <% if (agentConf != null)
    { %>
    <tr>
        <th>Agent</th>
        <td>
            <ul>
                <li>code: <%=WebUtil.stripTag(agentConf.getAgentCode())%></li>
                <li>type: <%=WebUtil.stripTag(agentConf.getAgentType().name())%></li>
                <li>version: <%=WebUtil.stripTag(agentConf.getAgentVer())%></li>
                <li>validateCertYn: <%=WebUtil.stripTag(String.valueOf(agentConf.getValidateCertYn()))%></li>
                <li>deviceDnaYn: <%=WebUtil.stripTag(String.valueOf(agentConf.getDeviceDnaYn()))%></li>
                <li>redirectYn: <%=WebUtil.stripTag(String.valueOf(agentConf.getNavRedirectYn()))%></li>
                <li>frameTopYn: <%=WebUtil.stripTag(String.valueOf(agentConf.getFrameTopYn()))%></li>
                <li>timeOffset: <%=WebUtil.stripTag(String.valueOf(agentConf.getTimeOffset()))%>(min)</li>
                <li>checkLiveYn: <%=WebUtil.stripTag(String.valueOf(agentConf.getCheckLiveYn()))%></li>
                <li>logLevel: <%=WebUtil.stripTag(agentConf.getLogLevel().name())%></li>
                <li>logPath: <%=WebUtil.stripTag(agentConf.getLogPath())%></li>
            </ul>
        </td>
    </tr>
    <% } %>
    <tr>
        <th>Site</th>
        <td>
            <ul>
                <li>fqdn: <%=WebUtil.stripTag(site.getFqdn())%></li>
                <li>code: <%=WebUtil.stripTag(site.getCode())%></li>
                <li>acl: <%=WebUtil.stripTag(String.valueOf(site.getAclYn()))%></li>
                <li>default: <%=WebUtil.stripTag(site.getUrl())%></li>
                <li>login.ep: <%=WebUtil.stripTag(site.getLoginEp())%></li>
                <li>logout.ep: <%=WebUtil.stripTag(site.getLogoutEp())%></li>
                <li>sso.service: <%=WebUtil.stripTag(site.getProviderSsoUrl(request))%></li>
                <li>sso.logon: <%=WebUtil.stripTag(site.getProviderLoginUrl(request))%></li>
                <li>sso.logon.wa: <%=WebUtil.stripTag(site.getProviderLoginWaUrl(request))%></li>
                <li>sso.logoff: <%=WebUtil.stripTag(site.getProviderLogoutUrl(request))%></li>
            </ul>
            <p>Token</p>
            <ul>
                <li>generation: <%=WebUtil.stripTag(String.valueOf(site.getTokenConfig().getGeneration()))%></li>
                <li>name: <%=WebUtil.stripTag(site.getTokenConfig().getName())%></li>
                <li>httpOnly: <%=WebUtil.stripTag(String.valueOf(site.getTokenConfig().getHttpOnly()))%></li>
                <li>secure: <%=WebUtil.stripTag(String.valueOf(site.getTokenConfig().getSecure()))%></li>
                <li>standard: <%=WebUtil.stripTag(String.valueOf(site.getTokenConfig().getStandard()))%></li>
            </ul>
            <p>Attr</p>
            <ul>
                <li>name: <%=WebUtil.stripTag(site.getAttrConfig().getName())%></li>
                <ul>
                    <% for (Object attrName : site.getAttrConfig().getAttrList())
                    { %>
                    <li><%=WebUtil.stripTag((String) attrName)%></li>
                    <% } %>
                </ul>
            </ul>
        </td>
    </tr>
    <tr>
        <th>Proxy</th>
        <td>
            <p>Proxy Site</p>
            <% if (proxySite != null)
            { %>
            <ul>
                <li>header.dns: <%=WebUtil.stripTag(proxySite.getHeaderDns())%></li>
                <li>header.ip: <%=WebUtil.stripTag(proxySite.getHeaderIp())%></li>
                <li>header.url: <%=WebUtil.stripTag(proxySite.getHeaderUrl())%></li>
                <li>default.url: <%=WebUtil.stripTag(proxySite.getUrl())%></li>
                <li>proxy.yn: <%=WebUtil.stripTag(String.valueOf(proxySite.isProxy(request)))%></li>
                <li>proxy.url: <%=WebUtil.stripTag(proxySite.getUrl(request))%></li>
            </ul>
            <p>Proxy Provider</p>
            <% if (proxyProvider != null)
            {
            %>
            <ul>
                <li>header.dns: <%=WebUtil.stripTag(proxyProvider.getHeaderDns())%></li>
                <li>header.path: <%=WebUtil.stripTag(proxyProvider.getProxyPath())%></li>
                <li>header.ip: <%=WebUtil.stripTag(proxyProvider.getHeaderIp())%></li>
                <li>proxy.yn: <%=WebUtil.stripTag(String.valueOf(proxySite.isProxy(request)))%></li>
                <li>proxy.url: <%=WebUtil.stripTag(proxySite.getUrl(request))%></li>
            </ul>
            <% }
            else
            {%>
            proxy provider is null.
            <%} %>
            <% }
            else
            {%>
            proxy site is null.
            <% } %>
        </td>
    </tr>
</table>
</body>
</html>
<%
    }
%>