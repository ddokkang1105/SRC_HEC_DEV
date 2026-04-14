package xbolt.cmm.framework.filter;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.TimezoneThreadLocal;
import xbolt.cmm.framework.val.TimezoneGlobalVal;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * TimzoneFilter
 *
 * @version 1.0
 * @Class Name : TimzoneFilter.java
 * @Description : ThreadLocal에 session정보 set을 하기 위한 Filter
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 07. 21.	kgy		최초생성
 * @see
 * @since 2025. 07. 21.
 */
/*
 사용할 경우 web.xml에 추가
    <filter>
        <filter-name>TimezoneFilterChain</filter-name>
        <filter-class>xbolt.cmm.framework.filter.TimezoneFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>TimezoneFilterChain</filter-name>
        <url-pattern>*.do</url-pattern>
    </filter-mapping>
 */
public class TimezoneFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpSession session = request.getSession(false);

        String userTimezone = TimezoneGlobalVal.SERVER_TIMEZONE;

        if (session != null) {
            Object loginInfo = session.getAttribute("loginInfo");
            if(loginInfo instanceof Map){
                String timezone = StringUtil.checkNull(((Map)loginInfo).get("sessionUserTimeZone"));
                if(!(timezone == null || timezone.isEmpty())) userTimezone = timezone;
            }
        }

        TimezoneThreadLocal.set(userTimezone);

        try {
            filterChain.doFilter(servletRequest, servletResponse);
        } finally {
            TimezoneThreadLocal.clear();
        }
    }

    @Override
    public void destroy() {

    }
}


