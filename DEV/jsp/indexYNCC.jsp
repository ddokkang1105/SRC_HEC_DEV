<%@page import="SafeIdentity.SSO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String SSO_URL = "https://aha.yncc.co.kr/";
	String scriptFunc = "";
	String userID = "";
	String olmI = "";

	try {
 		response.setHeader("Cache-Control", "no-cache");
		
		String CIP = request.getRemoteAddr();
		int nResult = -1;
	
		String sName = "";
		String sToken = "";
		
		sName = "ssoToken";
		
		Cookie[] cookies = request.getCookies();	
		System.out.println("COOKIES COUNT : " + cookies.length);
		if ( cookies != null ) 
		{
			for (int i=0; i < cookies.length; i++) 
			{	
			     String name = cookies[i].getName();
			     String sDomain = cookies[i].getDomain();		
				
			     if( name != null && name.equals(sName) ) 
			     {
			    	 //System.out.println("COOKIES [" + i + "] : " + cookies[i].getValue());
			    	 System.out.println("COOKIE [" + i + "] name: " + name + ", value: " + cookies[i].getValue());
			    	 sToken = cookies[i].getValue();
			     }
			}
		}	
		
		System.out.println("=======================================================");
		System.out.println("CIP : " + CIP);
		System.out.println("Token : " + sToken);
		System.out.println("=======================================================");
		
		if ( sToken  !=  null ) {
			System.out.println("Token 검증을 시작합니다.");
			
			SSO sso = new SSO();
			
			// nResult = sso.verifyToken( sToken, CIP ) ;
			nResult = sso.verifyToken( sToken, "" ) ;
			
			System.out.println("Token 검증 결과 -> nResult Code : " + nResult);
			
//			if( nResult < 0 && !(nResult == -1032 || nResult == -1033 || nResult == -1205 || nResult == -1207) ) {
			if( nResult == -2902 || nResult == -710 || nResult == -748 || nResult == -771 || nResult == -441 || nResult == -442 ) {				
				if( nResult == -2902 ) {
					System.out.println("“세션이 만료되었습니다.”");
					// 로그인 페이지로 리다이렉션 시킨다.
					response.sendRedirect(SSO_URL);
				} else if( nResult == -710 || nResult == -748 || nResult == -771 ) {
					System.out.println("“SSO Agent(safeagent)로 연결을 실패하였습니다. Agent가 동작중인지 확인하세요.”");
					// 로그인 페이지로 리다이렉션 시킨다.
					response.sendRedirect(SSO_URL);
				} 
//				else if( nResult == -1032 || nResult == -1033 ) {
//					System.out.println("“정책서버(policyserver)로 연결을 실패하였습니다. 정책서버가 동작중인지 확인하세요.”");
//					// 로그인 페이지로 리다이렉션 시킨다.
//					response.sendRedirect(SSO_URL);
//				} 
				else if( nResult == -441 || nResult == -442 ) {
					System.out.println("“토큰이 존재하지 않습니다.”");
					// 로그인 페이지로 리다이렉션 시킨다.
					response.sendRedirect(SSO_URL);
				} 
//				else if( nResult == -1205 || nResult == -1207 ) {
//					System.out.println("“토큰 생성시 사용된  서버의  API Key, GroupID(ssotoken.key에서 정의)값과 검증 대상 서버의에서의 값이 다릅니다”");
//					System.out.println("(“또는  VPN 환경등의 이유로 토큰 생성시 클라이언트 IP와 검증시의 IP 값이 다릅니다.”");
//					// 로그인 페이지로 리다이렉션 시킨다.
//					response.sendRedirect(SSO_URL);
//				} 
				else {
					System.out.println("“로그인에 실패하였습니다. 에러코드[" + nResult + "“]”");
					// 로그인 페이지로 리다이렉션 시킨다.
					response.sendRedirect(SSO_URL);
				} 
			} else {
				System.out.println("Token 통과 !");
 				
 				userID = sso.getValueUserID(); //로그인시 입력한 사용자 ID 값 추출
 				
				System.out.println("Token 존재, SSO ON : " + userID);
				// 이후 각 연동 시스템에서 사용자의 아이디로 로그인 처리 후 해당 시스템의 메인 
				// 페이지로 리다이렉션 시켜서 시스템을 이용하도록 코딩한다.
				
				if (!"".equals(userID) && userID != null) {
					olmI = userID;
					scriptFunc = "fnLogIn()";
				}	
				
 			}
			
		} else {
			response.sendRedirect(SSO_URL);
		}
 	
	} catch (Exception e) {
		response.sendRedirect(SSO_URL);
		e.printStackTrace();
	}


%>

<!DOCTYPE html>
<head>
<title>SSO</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
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
	<input type="hidden" id="ynccSSO" name="ynccSSO" value="${ynccSSO}"/>
	<input type="hidden" id="keepLoginYN" name="keepLoginYN" value="${keepLoginYN}"/>				
	</form>
</body></html>



<script language="javascript" type="text/javascript">
   	<%=scriptFunc%>
   	
   	//로그인 페이지 이동
     function fnLogIn() {
     	var form = document.createElement("form");     
     	form.setAttribute("method","post");                    
     	form.setAttribute("action","/custom/yncc/loginYnccForm.do");        
     	document.body.appendChild(form);                        

     	var input_id = document.createElement("input");  
     	input_id.setAttribute("type", "hidden");                 
     	input_id.setAttribute("name", "loginid");
     	input_id.setAttribute("value", "<%=olmI%>");   
     	form.appendChild(input_id);
     	
     	var ynccSSO = document.createElement("input");  
     	ynccSSO.setAttribute("type", "hidden");                 
     	ynccSSO.setAttribute("name", "ynccSSO");
     	ynccSSO.setAttribute("value", "T");
     	form.appendChild(ynccSSO);
     	
     	var lang = document.createElement("input");  
     	lang.setAttribute("type", "hidden");                 
     	lang.setAttribute("name", "lang");
     	lang.setAttribute("value", "1042");
     	form.appendChild(lang);
     	                       
     	form.submit();  
     }
   	
	
</script>