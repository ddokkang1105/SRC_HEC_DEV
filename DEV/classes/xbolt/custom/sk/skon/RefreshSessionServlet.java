package xbolt.custom.sk.skon;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/refreshSession.do")
public class RefreshSessionServlet extends HttpServlet {
	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        // 현재 세션 가져오기
	        HttpSession session = request.getSession(false); // 현재 세션이 없으면 null 반환
	    	
	        if (session != null) {
	            // web.xml에 설정된 세션 타임아웃 값을 가져와서 세션 갱신
	            int timeout = session.getMaxInactiveInterval(); // 이미 설정된 값 가져오기
	            session.setMaxInactiveInterval(timeout); // 세션 갱신
	            response.getWriter().write(String.valueOf(timeout)); 
	           
	            
	        } else {
	            response.getWriter().write("No session found"); // 세션이 없는 경우
	        }
	    }


	

}
