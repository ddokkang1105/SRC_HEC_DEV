package xbolt.cmm.framework.filter;

import javax.servlet.*; 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.awt.datatransfer.SystemFlavorMap;
import java.io.IOException;

public class CustomCsrfFilter implements Filter {

    private static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";
    private static final String CSRF_SESSION_NAME = "CSRF_TOKEN";

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponose, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponose;
        String formToken = "";
        String headerToken = "";
        // 1. 상태 변경 요청인지 확인 (GET, HEAD, OPTIONS는 통과)
        String method = request.getMethod().toUpperCase();
        if (method.equals("GET") || method.equals("HEAD") || method.equals("OPTIONS")) {
            chain.doFilter(request, response);
            return;
        }
        
        //ajax submit
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            //ajaxSubmit
            formToken = request.getParameter(CSRF_HEADER_NAME);
            //ajaxPage
            headerToken = request.getHeader(CSRF_HEADER_NAME);
        }

        String sessionToken = (String) request.getSession().getAttribute(CSRF_SESSION_NAME);

        System.out.println(headerToken);
        System.out.println(formToken);
        System.out.println(sessionToken);

        if ((headerToken == null && formToken == null) || sessionToken == null) {
             if(!(headerToken.equals(sessionToken) && formToken.equals(sessionToken))){
                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid CSRF Token");
                 return;
             }     
        }

        System.out.println("Csrf Token Test 성공");

        chain.doFilter(request, response);
    }


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}