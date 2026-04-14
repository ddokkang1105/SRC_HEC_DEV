<%

	/************************************************************
	 *	ReturnURL 설정
	 *  gentProc.jsp 에서 인증완료후 "returnURL" 파라미터에 설정된 URL로 리다이렉트
	 ************************************************************/	
	String returnURL = request.getParameter("returnURL") == null ? "" : request.getParameter("returnURL");
	if (!returnURL.trim().equals("")) session.setAttribute("returnURL", returnURL);
	//	System.out.println("parameter returnURL : (" + returnURL + ") / " + "session retutnURL : " + "(" + session.getAttribute("returnURL") +")");

	
	/************************************************************
	 *	Web-Agent 환경 설정
	 ************************************************************/	
	//String AUTH_URL = "sso.pentasecurity.com";				// ISign+ SSO URL
	String AUTH_URL = "sso.daelim.ac.kr";
	session.setAttribute("AUTHORIZATION_URL", "https://" + AUTH_URL + "/");
	session.setAttribute("AUTHORIZATION_SSL_URL", "https://" + AUTH_URL + "/");
	session.setAttribute("SSID", "145");				// 업무 고유 시스템 번호
	session.setAttribute("REQUEST_DATA", "LOGIN_ID, PASS_WD");		// 인증DB Column명
	
	/**
	  * penta라는 context path가 존재한다면 path + "origin value"로 입력한다.
	  * ex) String path = "/penta";
	  * session.setAttribute("SERVICE_BUSINESS_PAGE", path + "/sso/business.jsp");
	  */
	String path = "";

	session.setAttribute("SERVICE_BUSINESS_PAGE", path + "/daelim/sso/business.do");	//ISign+ SSO 인증을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_LOGIN_PAGE", path + "https://pt.daelim.ac.kr");		//ISign+ SSO 로그인을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_LOGOUT_PAGE", path + "/daelim/sso/logout.do");		//ISign+ SSO 로그아웃을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_ROLE_PAGE", path + "/daelim/sso/agentProc.do");		//ISign+ SSO 인증에는 성공했으나 권한이 없을 때 보여지는 페이지
	session.setAttribute("EXISTING_LOGIN_PAGE", path + "https://pt.daelim.ac.kr");			//ISign+ SSO 네트워크 실패 시 기존 업무로 로그인 페이지
	
	
	String method = request.getParameter("method") == null ? "" : request.getParameter("method");
	String reTry = request.getParameter("reTry") == null ? "" : request.getParameter("reTry");
	String isToken = request.getParameter("isToken") == null ? "" : request.getParameter("isToken");
	String secureToken = request.getParameter("secureToken") == null ? "" : request.getParameter("secureToken");
	String secureSessionId = request.getParameter("secureSessionId") == null ? "" : request.getParameter("secureSessionId");
	
	String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>

<body>
	<form name="sendForm" method="post">
		<input type="hidden" name="isToken" value="<%=isToken%>" />
		<input type="hidden" name="secureToken" value="<%=secureToken%>" />
		<input type="hidden" name="secureSessionId" value="<%=secureSessionId%>" />
	</form>

	<script>
		var method = "<%=method%>";
		var isToken = "<%=isToken%>";
		var reTry = "<%=reTry%>";
		//인증 되지 않는 사용자일 경우 로그인 페이지로 send
		var sendUrl = "<%=SERVICE_LOGIN_PAGE%>";
		var sendForm = document.sendForm;
	
		// 인증서버에서 전달하는 유일한 method는 checkToken이다. 해당 method는 /root/isignplus/send/sendSecureToken.jsp에서 전달한다.
		if (method == "checkToken") {
			// reTry는 인증서버의 모든 코드에서 실패가 동작되면 Y, 정상동작되면 N를 전달한다.
			if(reTry == "N"){
				// isToken은 로그인 시도시 로그인 성공이나 로그인 된 상태일 때 Y, 로그인 실패 또는 로그인 된 상태가 아닐 때 N를 전달한다.
				if(isToken == "Y"){
					// 인증서버에 secureToken를 검증하기 위한 페이지로 send
					sendUrl = "<%=path%>" + "/daelim/sso/checkauth.do";//로그인 성공
				}
			}
		} else {
			// 파라미터가 존재하지 않는다면 인증서버에 Web-Agent의 정보를 요청하기 위한 페이지로 send
			sendUrl = "<%=path%>" + "/daelim/sso/checkserver.do";//인증서버 정보 요청
		}
		
		sendForm.action = sendUrl;
		sendForm.submit();
	</script>

</body>
</html>