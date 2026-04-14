<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@page import="com.rathontech2018.sso.sp.config.Env"%>
<%@page import="com.rathontech2018.sso.sp.agent.web.WebAgent"%>
<%
    String errMsg = request.getParameter("SsoReturnValue");
    if(errMsg != null && !errMsg.equals("")) {
        %>
        <script type="text/javascript">
            alert('<%=errMsg%>');
            location.href = 'test_sso.jsp';
        </script>
        <%
        return;
    }

    /* agent code - start */
	WebAgent agent = new WebAgent();

	agent.requestAuthentication(request, response);
	
	/* agent code - end */
%>
<%	
	String context = request.getContextPath();
	String base = request.getScheme() + "://" + request.getServerName() + ":" +  request.getServerPort() + context;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sample - Rathon SSO SP Login Page</title>
<script type="text/javascript">
	function doSubmit() {
		var lid = document.getElementById('UserID').value;
		var lpw = document.getElementById('UserPWD').value;

		if (lid == null || lid == "") {
			alert("\uC544\uC774\uB514\uB97C \uC785\uB825\uD558\uC2ED\uC2DC\uC624.");
		} else if (lpw == null || lpw == "") {
			alert("\uD328\uC2A4\uC6CC\uB4DC\uB97C \uC785\uB825\uD558\uC2ED\uC2DC\uC624.");
		} else {
			document.f.submit();
		}
	}
</script>
</head>
<body>
<center>
<%
	String uniqueID = (String) session.getAttribute("RathonSSO_UniqueID");
	if (uniqueID == null) {
%>
<form name="f" action="<%= Env.IDPM_DOMAIN_CONTEXT + Env.IDPM_LOGIN_REQ_URI%>" method="post">
	<%= agent.getLoginFormParameter(request) %>
	
	<table width="185" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td height="10"></td>
            </tr>
            <tr>
              <td height="4"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td height="4"></td>
            </tr>
            <tr>
              <td height="28" style="padding-right:18px;"> JAVA SP 로그인 </td>
            </tr>
            <tr>
              <td class="language">I&nbsp;D&nbsp;&nbsp;<input type="text" name="UserID" id="UserID" style="width:90px;"></td>
            </tr>
            <tr>
              <td class="language">PW&nbsp;<input type="password" name="UserPWD" id="UserPWD" style="width:90px;" >
              </td>
            </tr>
     
            <tr>
              <td height="4"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td height="40"><a href="#" onclick="javascript:doSubmit()">로그인</a></td>
            </tr>
            
            <tr height=5>
            	<td>
            	   &nbsp;            	   
            	</td>
            </tr>
        </table>
</form>
<%	
	} else {
		out.print("test_login.jsp에 인증 되었습니다.");
	}
%>
</center>
</body>
</html>