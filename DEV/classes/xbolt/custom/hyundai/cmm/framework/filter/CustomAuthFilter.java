package xbolt.custom.hyundai.cmm.framework.filter;

import xbolt.cmm.framework.util.StringUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 인증/인가 관련 추가 Filter 처리
 *
 * @version 1.0
 * @Class Name : CustomAuthFilter.java
 * @Description : xbolt filter 처리 이외에 추가적으로 인증/인가가 필요한 url 설정
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 06. 25.	kgy		최초생성
 * @see
 * @since 2025. 06. 25.
 */
/*
 사용할 경우 web.xml에 추가(Filter 추가 맨 아래 부분)
    <filter>
        <filter-name>CustomAuthFilterChain</filter-name>
        <filter-class>xbolt.cmm.framework.filter.CustomAuthFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>CustomAuthFilterChain</filter-name>
        <url-pattern>*.do</url-pattern>
    </filter-mapping>
 */
public class CustomAuthFilter implements Filter {

    protected FilterConfig filterConfig = null;
    private static final List<String> authenticateUrls = Arrays.asList(
            //TODO: 기본 Filter 외에 인증 필요 url 추가
    );

    private static final List<String> authorizeUrls = Arrays.asList(
            //TODO: 기본 Filter 외에 인가 필요 url 추가
            "/boardCommentDelete.do", "/admin/insertUserGroup.do"
    );
    private static final List<String> authorizeTemplates = Arrays.asList(
            //TODO: 기본 Filter 외에 인가 필요 template 추가
            "ADMIN"
    );



    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String context = request.getContextPath();
        String requestUrl = request.getServletPath();
        HttpSession session = request.getSession();

        //String baseUrl = "/custom/sk/loginAuth.do";
        String baseUrl = context + "/index.do";
        String templCode = StringUtil.checkNull(request.getParameter("s_templCode"));

        //인증 url check & 인증 check
        if (isAuthenticateUrl(requestUrl) && !isLoginStatus(session)) {
            response.sendRedirect(baseUrl);
            return;
        }

        //인가 url check & 인증 check
        if ((isAuthorizeUrl(requestUrl) || isAuthorizeTemplate(templCode)) && !isLoginStatus(session)) {
            response.sendRedirect(baseUrl);
            return;
        }

        //인가 url check & template check
        if (isAuthorizeUrl(requestUrl) || isAuthorizeTemplate(templCode)) {
            Map loginInfo = (Map) session.getAttribute("loginInfo");
            String authorityLevel = StringUtil.checkNull(loginInfo.get("sessionAuthLev"));

            if (!isAdminStatus(authorityLevel)) {
                response.sendRedirect(baseUrl);
                return;
            }
        }

        if (filterChain != null) {
            filterChain.doFilter(request, servletResponse);
        }


    }

    @Override
    public void destroy() {
        filterConfig = null;
    }

    private boolean isAuthenticateUrl(String url) {
        return authenticateUrls.stream().anyMatch(url::contains);
    }

    private boolean isAuthorizeUrl(String url) {
        return authorizeUrls.stream().anyMatch(url::contains);
    }

    private boolean isAuthorizeTemplate(String template) {
        return authorizeTemplates.stream().anyMatch(template::equalsIgnoreCase);
    }

    private boolean isLoginStatus(HttpSession session) {
        return session != null && session.getAttribute("loginInfo") != null;
    }

    private boolean isAdminStatus(String authorityLevel) {
        return "1".equals(authorityLevel);
    }

    private HttpServletResponse setResponseHeader(HttpServletResponse response) {

        response.addHeader("X-Frame-Options", "SAMEORIGIN");
        response.addHeader("X-XSS-Protection", "1; mode=block");
        response.addHeader("Control-Allow-Origin", "*");
        response.addHeader("Access-Control-Allow-Methods", "GET,POST");
        response.addHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        response.addHeader("Set-Cookie", "name=value; path=/; MaxAge=-1; SameSite=Strict");

        return response;
    }
}
