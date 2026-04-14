<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.rathontech2018.sso.sp.agent.web.WebAgent"%>

<%
    response.setHeader("cache-control","no-cache");
    response.setHeader("expires","0");
    response.setHeader("pragma","no-cache");
%>

<html>
<head>
	<title>RathonSSO SP_Test Main Page</title>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="No-Cache">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
</head>
<body>

<%
	String baseURL = (request.isSecure()==true?"https://":"http://") + request.getServerName()+":"+request.getServerPort();
	String id = (String) session.getAttribute("custom_user_id");

	//통합로그인 사용시
	/* agent code - start */
	//agent 호출
	WebAgent agent = new WebAgent();
	//시스템에 SSO인증데이터가 있을 시 false 리턴, 인증정보가 없을 시 로그인페이지 리다이렉트
	agent.requestAuthentication(request, response);
	
	String userName = (String)session.getAttribute("RathonSSO_USER_ID");
	session.setAttribute("custom_user_id", "테스트유저ID_"+userName);
	/* agent code - end */
	
	String errorMsg =  request.getParameter("ErrorMsg");
	StringBuffer errorScript = new StringBuffer();

	if (errorMsg!=null) {
		errorScript.append("<script>");
		errorScript.append("alert("+errorMsg+");");
		errorScript.append("</script>");
	}

	
	/* session data */
	String userid =(String) session.getAttribute("RathonSSO_USER_ID");
	String userOrgCode =(String) session.getAttribute("RathonSSO_PART_NO");
	String sabun =(String) session.getAttribute("RathonSSO_PERSON_NO");
	String loginSessionId =(String) session.getAttribute("IDP_SESSION_ID");
	
	//세션 데이터가 base64 인코딩 되어 있을 경우 => 디코딩
   	//if ( sabun != null ) {
   	//	String decode_sabun = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sabun.getBytes()));
   	//	out.print(decode_sabun + "<-- decode_sabun<br/>");
   	//}
	
	
	/* 현재 저장된 session data 리스트 */
	StringBuffer sb = new StringBuffer();
	sb.append("<p>Session Attributes<p>");
	java.util.Enumeration en = request.getSession().getAttributeNames();
	while(en.hasMoreElements()) {
		String name = (String)en.nextElement();
		
		String value=null;
		try{
			value = (String)request.getSession().getAttribute(name).toString();
		}catch(NullPointerException e){
			value=e.getMessage();
		}
		sb.append("[").append(name).append("] = [").append(value).append("]<br>");
	}
	
	//session 정보 리스트 출력
	//out.print("= [session attribute] =====");
    //out.print("<br />");
    //out.print("<br />");
    //out.print("<br />");
    //out.print(sb.toString());   

    
%>

<%=errorScript%>

<fieldset>
    <h1>TEST Redirection SSO</h1>
	Session을 검사하여 인증되지 않았을 경우 SAML Request를 생성하여 IDP로 Redirect한다.<p>
	여기서는 테스트를 위해 'Please Login' 링크를 만들어 두었다. (자동으로 Redirect할 수 있다.)
</fieldset>
<%

if (null == id) { 
%>
SP에 에러가 발생 했습니다. SP를 확인하세요.
<%} else { %>
	Hello <%= id %> :) You successfully logged in Rathon SSO service
	<p>
	
	jsp call : <a href="<%=baseURL%><%=request.getContextPath()%>/SP2018/ssoLogout.jsp">Logout</a><br />
	
<%= "<br>= [parameters] ===============================<br>" %>
<%
    String paramName;
    StringBuffer pSb = new StringBuffer();
    java.util.Enumeration enums = request.getParameterNames();    

    while(enums.hasMoreElements()) {
        paramName = (String)enums.nextElement();
        pSb.append(paramName + " = " + request.getParameter(paramName)+ "<br>");
    }   
    
    out.print(pSb);
    out.print("<br />");
    
    //session data 출력
    out.print("= [session attribute] =====");
    out.print("<br />");
    out.print("<br />");
    out.print("<br />");
    out.print(sb.toString());   
}

	
	/*
	String ccc = "";
	try {
		ccc = java.net.URLDecoder.decode(bbb, "UTF-8");
	} catch (Exception e) {
		// TODO: handle exception
	}
	out.print(ccc + "<-- ccc<br />");
	*/
	
	
	//String ccc = new String(org.apache.commons.codec.binary.Base64.decodeBase64(bbb.getBytes()));
	//out.print(ccc + "<-- ccc<br />");
	
	//String ccc = new String(bbb.getBytes("UTF-8"),"EUC-KR");
	//out.print(ccc + "<-- ccc<br />");

%>

</body>
</html>