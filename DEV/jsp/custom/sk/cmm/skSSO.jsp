<%@ page import="nets.sso.agent.web.v2020.authcheck.AuthCheck" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentException" %>
<%@ page import="nets.sso.agent.web.v2020.common.logging.SsoLogger" %>
<%@ page import="nets.sso.agent.web.v2020.conf.AgentConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	String scriptFunc = "";
	String userid = "";
	try{
		 // 페이지는 자동으로 이동되니, 페이지 이동은 추가로 기술하지 않습니다.
		 AuthCheck auth = new AuthCheck(request, response);
		 
		 //System.out.println("auth :"+auth.checkLogon()); 
		 //System.out.println("sso Status  :"+request.getParameter("ssoStatus")); 
		 boolean logonYN = auth.logon(false);
			 
		// System.out.println("logonYN :"+logonYN); 
		 	 
	     if (logonYN){ //인증됨
			 userid = auth.getUserID();			
			 scriptFunc = "fnLogIn()";
			 
		 }else{
			 // scriptFunc = "fnOLMLogonPage()";
			 String returnUrl = "/custom/sk/loginAuth.do";
		 	 response.sendRedirect(returnUrl);
		 }
	}catch (AgentException ignore){}
%>

<!DOCTYPE html>
<head>
<title>NETS*SSO</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script language="javascript" type="text/javascript">
   	<%=scriptFunc%>
   	
   	//로그인 페이지 이동
     function fnLogIn() {
     	var form = document.createElement("form");     
     	form.setAttribute("method","post");                    
     	form.setAttribute("action","/custom/sk/cmm/sksso.do");        
     	document.body.appendChild(form);                        

     	var input_id = document.createElement("input");  
     	input_id.setAttribute("type", "hidden");                 
     	input_id.setAttribute("name", "loginid");
     	input_id.setAttribute("value", "<%=userid%>");   
     	form.appendChild(input_id);
     	
     	var skSSO = document.createElement("input");  
     	skSSO.setAttribute("type", "hidden");                 
     	skSSO.setAttribute("name", "skSSO");
     	skSSO.setAttribute("value", "T");
     	form.appendChild(skSSO);
     	
     	var lang = document.createElement("input");  
     	lang.setAttribute("type", "hidden");                 
     	lang.setAttribute("name", "lang");
     	lang.setAttribute("value", "1042");
     	form.appendChild(lang);
     	                       
     	form.submit();  
     }
   	
      //에러 메시지
      function alertError(msg, url) {
          if (msg != "")
              alert(msg);
          if (url != "")
              document.location.href = url;
      }
     //로그오프
     function OnLogoff() {
         
     }
     
     //로그인 페이지 이동
     function fnOLMLogonPage() {
      	alert("그룹웨어 로그인 하세요.");  
      	return;
     }
	
</script>
</head>
<body>
	<form name="mainForm" action="#" method=post target='main'>
	<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
	<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
	<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
	<input type="hidden" id="loginIdx" name="loginIdx" value="${loginIdx}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>	
	<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>	
	<input type="hidden" id="srID" name="srID" value="${srID}"/>
	<input type="hidden" id="proposal" name="proposal" value="${proposal}"/>
	<input type="hidden" id="status" name="status" value="${status}"/>		
	<input type="hidden" id="skSSO" name="skSSO" value="${skSSO}"/>
	<input type="hidden" id="keepLoginYN" name="keepLoginYN" value="${keepLoginYN}"/>				
	</form>
</body></html>


