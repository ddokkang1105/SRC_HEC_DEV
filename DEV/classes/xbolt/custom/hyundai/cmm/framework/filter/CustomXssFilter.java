package xbolt.custom.hyundai.cmm.framework.filter;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.custom.hyundai.cmm.XssUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * xss 추가 Filter 처리
 *
 * @version 1.0
 * @Class Name : CustomXssFilter.java
 * @Description : xbolt filter 처리 이외에 추가적으로 인증/인가가 필요한 url 설정
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 06. 25.	kgy		최초생성
 * @see
 * @since 2025. 06. 25.
 */
/*
 사용할 경우 web.xml에 추가
    <filter>
        <filter-name>CustomXssFilterChain</filter-name>
        <filter-class>xbolt.cmm.framework.filter.CustomXssFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>CustomXssFilterChain</filter-name>
        <url-pattern>*.do</url-pattern>
    </filter-mapping>
 */
public class CustomXssFilter implements Filter {

    protected FilterConfig filterConfig = null;

    //private final Pattern htmlPatterns = Pattern.compile("[<>\"';]|%22");
    private final Pattern htmlPatterns = Pattern.compile("[<>\"']|%22", Pattern.CASE_INSENSITIVE);
    private final List<String> sqlPatterns = Arrays.asList(
            "case when", "db_name", "information_schema", "--", "' or ", "\" or ", ";"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String m = request.getMethod(); // GET, POST

 //       1) TRACE/TRACK은 목록 노출 금지: 403/501로만 응답, Allow 헤더 세팅하지 않음
      if ("TRACE".equalsIgnoreCase(m) || "TRACK".equalsIgnoreCase(m)) {
      
          response.sendError(HttpServletResponse.SC_FORBIDDEN); // 또는 SC_NOT_IMPLEMENTED(501)
          return; 
      }

//      // 2) 정책: GET/POST만 허용. 나머지는 전부 차단(목록 노출 금지)
      if (!"GET".equalsIgnoreCase(m) && !"POST".equalsIgnoreCase(m)) {
       
          response.sendError(HttpServletResponse.SC_FORBIDDEN); // 403 (Allow 미노출)
          return;
      }
        // path, url xss check
        if (isInValidPathAndQuery(request)) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            //request.getRequestDispatcher("/errorPage.html").forward(request, response);
            return;
        }

      
        // url sql injection check
        if (isInValidQueryWithoutSqlInjection(request)) {
            response.sendRedirect("/errorPage.do");
            return;
        }
/*
        // header XSS check
        if (isInValidHeader(request)) {
            response.sendRedirect("/errorPage.do");
            return;
        }

        // parameter XSS check
        if (isInValidParameter(request)) {
            response.sendRedirect("/errorPage.do");
            return;
        }
        */

        if (filterChain != null) {
            filterChain.doFilter(request, servletResponse);
        }


    }

    @Override
    public void destroy() {
        filterConfig = null;
    }

    private boolean isInValidPathAndQuery(HttpServletRequest request) {

        String requestURI = StringUtil.checkNull(request.getRequestURI());
        String requestQuery = StringUtil.checkNull(request.getQueryString());

        //uri, query 검사
        if (invalidHtmlEntityCheck(requestQuery)) {
            return true;
        } else if (XssUtil.invalidXssCheck(requestURI) || XssUtil.invalidXssCheck(requestQuery)) {
            return true;
        } else {
            return false;
        }

    }

    private boolean isInValidQueryWithoutSqlInjection(HttpServletRequest request) {

        boolean result = false;
        String requestQuery = StringUtil.checkNull(request.getQueryString());

        //uri, query 검사
        if (invalidSqlInjectionCheck(requestQuery)) result = true;

        return result;
    }

    private boolean isInValidHeader(HttpServletRequest request) {
        Enumeration<String> headerNames = request.getHeaderNames();
        if (headerNames == null) return false;

        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            Enumeration<String> headerValues = request.getHeaders(headerName);

            while (headerValues.hasMoreElements()) {
                String value = headerValues.nextElement();
                if (XssUtil.invalidXssCheck(value)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean isInValidParameter(HttpServletRequest request) {
        Map<String, String[]> paramMap = request.getParameterMap();
        if (paramMap == null) return false;

        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            String[] values = entry.getValue();
            if (values != null) {
                for (String val : values) {
                    if (XssUtil.invalidXssCheck(val)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private boolean invalidSqlInjectionCheck(String query) {

        if (query == null) return false;

        query = query.toLowerCase();

        return sqlPatterns.stream()
                .map(String::toLowerCase)
                .anyMatch(query::contains);
    }

    private boolean invalidHtmlEntityCheck(String value) {

        if (value == null) return false;
        return htmlPatterns.matcher(value).find();
    }

}

