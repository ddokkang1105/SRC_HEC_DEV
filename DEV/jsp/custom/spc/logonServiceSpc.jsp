<%@ page import="nets.sso.agent.web.v2020.authcheck.AuthCheck" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.ParamInfo" %>
<%@ page import="nets.sso.agent.web.v2020.common.enums.AuthStatus" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentException" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.v2020.common.constant.LiteralConst" %>
<%@ page import="nets.sso.agent.web.v2020.common.util.Encode" %>
<%@ page import="nets.sso.agent.web.v2020.common.exception.AgentExceptionCode" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
 try
 {
	 String loginUrl = ""; // 로그인 URL
	 String logoutUrl = ""; // 로그아웃 URL
	 String returnUrl = ""; // 되돌아올 URL
	 String logInOutScript = ""; // 로그인 아웃 script 
	 String logoutScript = ""; // 로그오프 해야 할 경우 사용할 스크립트
	 String errorCode = ""; // 에러코드
	 String errorMessage = ""; // 에러 메시지
	 String siteID = ""; // 사이트 식별자
	 String userID = request.getParameter(ParamInfo.USER_ID);
	 String userPw = "";
	 // 인증 객체 선언(Request와 Response 인계)
	 AuthCheck auth = new AuthCheck(request, response);
	 // 인증 체크(인증 상태 값 리턴)
	 AuthStatus status = auth.checkLogon();
	 // 인증 체크 후 상세 에러코드 조회
	 errorCode = String.valueOf(auth.getErrCode());
	 
	 errorMessage = auth.getErrMsg();
	 returnUrl = request.getParameter(ParamInfo.RETURN_URL); // 리턴 URL 설정 (인증 후되돌아 올 URL)
	 siteID = request.getParameter(ParamInfo.SITE_ID); // 사이트 식별자 설정
	 
	 
	 System.out.println("1. status   =>"+status);
	 System.out.println("2. errorMessage   =>"+errorMessage);
	 System.out.println("3. returnUrl   =>"+returnUrl);
	 System.out.println("4. siteID   =>"+siteID);
	 System.out.println("5. loginUrl   =>"+loginUrl);
	 
	 if (status != AuthStatus.SSOUnAvailable){
		 if (StrUtil.isNullOrEmpty(returnUrl)){
			 // 리턴 URL 값이 전달되지 않았다면, 기본 URL을 그 값으로 설정
			 returnUrl = auth.getSsoSite().getUrl();
		 	 if (StrUtil.isNullOrEmpty(returnUrl)){
			 	// 기본 URL이 없을 경우. 현재 URL을 리턴 URL로 설정(이 부분은 필요 시 수정. ThisURL을 사용해도 무방)
			 	returnUrl = auth.getThisUrl();
			 }
		 }
		 if (StrUtil.isNullOrEmpty(siteID)){
		 	siteID = auth.getSsoSite().getCode(); // 전달된 식별자가 없으면, 현재 사이트 식별자를 사용
		 }
	 	// 사용자 계정을 SSO에 전달할 인증 서버의 로그온 URL 설정
	 	loginUrl = auth.getSsoSite().getProviderLoginUrl(request);
	 	logoutUrl = auth.getSsoSite().getProviderLogoutUrl(request) + "?" + 
		ParamInfo.SITE_ID + "=" + siteID + "&" + ParamInfo.RETURN_URL + "=" + 
		Encode.url(returnUrl, LiteralConst.UTF_8);
	 }
	 
	 System.out.println("logon service status ===>"+status);
	 System.out.println("상태값 ::AuthStatus.SSOSuccess::"+ AuthStatus.SSOSuccess +" , AuthStatus.SSOUnAvailable : " + AuthStatus.SSOUnAvailable +", AuthStatus.SSOFail :"+AuthStatus.SSOFail);
	 //인증상태별 처리
	 if (status == AuthStatus.SSOSuccess){ // 0
		 // ---------------------------------------------------------------------
		 // 인증 상태: 인증 성공
		 // - 인증 토큰(쿠키) 존재하고, 토큰 형식에 맞고, SSO 정책 체크 결과 유효함.
		 // ---------------------------------------------------------------------
		 // 로그온 UI 페이지가 아닌 업무 페이지로 이동 시킴
		  // 사용자 아이디 추출
         userID = auth.getUserID();
		 System.out.println("SSOSuccess auth.getThisUrl() :"+auth.getThisUrl());
		 if (returnUrl.contains(auth.getThisUrl())){
		 	response.sendRedirect("default.jsp");
		 }else{
			 System.out.println("인증성공");
			 //returnUrl = "/custom/spc/indexSpc.do?ssoStatus=0";
		 	 //response.sendRedirect(returnUrl);
		 	 
			 logInOutScript = "goOLMIndexPage('"+userID+"');";
		 }
	 }else if (status == AuthStatus.SSOUnAvailable){ // -3
		 // ---------------------------------------------------------------------
		 // 인증 상태 : 인증 실패 또는 로그오프 상태
		 // - 인증 오류 발생 또는 로그온 하지 않은 로그오프 상태
		 // ---------------------------------------------------------------------	 
	 
		 // SSO 장애 시 정책에 따라 자체 로그인 페이지로 이동 시키거나, SSO 인증을 위한 포탈 로그인 페 이지로 이동
		 
		 response.sendRedirect("/index.do");
		  errorMessage = "SSO service is not available now. Please try again in a few minutes.";
	  }else if (status.equals(AuthStatus.SSOFirstAccess)) { // -1
		  // ---------------------------------------------------------------------
		  // 인증 상태: 최초 접근
		  // - 다른 사이트에서 이미 인증 했는지 확인하기 위하여, SSO 인증서버로 페이지를 이동시킨다.
		  // - 인증 확인 후 현재 페이지로 다시 되돌아 온다.
		  // ---------------------------------------------------------------------
		  System.out.println("최초인증 auth.trySSO()");
		  auth.trySSO();
		  //logInOutScript = "fnSSOFirstAccess();";
	  }else if (status.equals(AuthStatus.SSOFail)) { // -2
		  	// ---------------------------------------------------------------------
		  	// 인증 상태: 로그아웃 상태 또는 인증 에러 상태
		  	// - 에러코드가 '0' 이라면, 로그아웃 상태이며, '0'이 아니라면 오류상태이다.
		  	// ---------------------------------------------------------------------
		  	
		  	System.out.println("AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue() : "+AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue());
		  	System.out.println("AgentExceptionCode.NoExistUserIDSessionValue.getValue() : "+AgentExceptionCode.NoExistUserIDSessionValue.getValue());
		  	System.out.println("AgentExceptionCode.TokenIdleTimeout.getValue() : "+AgentExceptionCode.TokenIdleTimeout.getValue());
		  	System.out.println("AgentExceptionCode.TokenExpired.getValue() : "+AgentExceptionCode.TokenExpired.getValue());
		  	
	  		if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()){ // 11060002
		  		// 중복 로그온 발생 (로그오프 상황)
		  		errorMessage += " IP:" + auth.getDuplicationIP() + " Time:" + auth.getDuplicationTime();
		  		logInOutScript = "fnOLMLogout('" + errorMessage + "');";
	  		}else if (auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()){ // 11040007
			  // 사용자 인증 세션 부재 (로그오프 상황)
			  errorMessage += " auth.getErrCode():" + auth.getErrCode()+":: AgentExceptionCode.NoExistUserIDSessionValue.getValue() ::"+AgentExceptionCode.NoExistUserIDSessionValue.getValue();
			  logInOutScript = "fnOLMLogout('" + errorMessage + "');";
		  
			}else if (auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue()){ // 11030005
			  // 인증 유휴 시간을 초과 (로그오프 상황)
			  errorMessage += " auth.getErrCode():" + auth.getErrCode()+":: AgentExceptionCode.TokenIdleTimeout.getValue() ::"+AgentExceptionCode.TokenIdleTimeout.getValue();
			  
			  logInOutScript = "fnOLMLogout('" + errorMessage + "');";
		  
			}else if (auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue()){ // 11030006
				errorMessage += " auth.getErrCode():" + auth.getErrCode()+":: AgentExceptionCode.TokenExpired.getValue() ::"+AgentExceptionCode.TokenExpired.getValue();
			   // 인증 기한 만료 (로그오프 상황)
			  // logInOutScript = "OnLogon('1');";
			} else if(auth.getErrCode() == 0){ // 
				errorMessage += " auth.getErrCode():" + auth.getErrCode();
			 	response.sendRedirect("/index.do");
			}  
	  }
	 %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>NETS*SSO - Logon</title>
<script type="text/javascript">
	      
	  	function fnOLMLogout(msg) {
	  		location.href = '<%=logoutUrl%>';
	  	}
		  
		function OnInit() {
		  	//document.forms["form1"].txtUserID.focus();
			  
		}
		  
		//로그인 페이지 이동
        function goOLMIndexPage(userId) {
        	var form = document.createElement("form");     
        	form.setAttribute("method","post");                    
        	form.setAttribute("action","/custom/spc/loginSpcForm.do");        
        	document.body.appendChild(form);                        

        	var input_id = document.createElement("input");  
        	input_id.setAttribute("type", "hidden");                 
        	input_id.setAttribute("name", "loginid");
        	input_id.setAttribute("value", "<%=userID%>");   
        	form.appendChild(input_id);
        	
        	var spcSSO = document.createElement("input");  
        	spcSSO.setAttribute("type", "hidden");                 
        	spcSSO.setAttribute("name", "spcSSO");
        	spcSSO.setAttribute("value", "T");
        	form.appendChild(spcSSO);
        	
        	var lang = document.createElement("input");  
        	lang.setAttribute("type", "hidden");                 
        	lang.setAttribute("name", "lang");
        	lang.setAttribute("value", "1042");
        	form.appendChild(lang);
        	                       
        	form.submit();
        }
				
		function fnLoginForm(keepLoginYN) { alert("logonServiceSpc... "); document.all.main.src = lgnUrl+"&keepLoginYN="+keepLoginYN;}
	
</script>
</head>
<body onLoad="OnInit();">
<form id="form1" method="post" action="<%=loginUrl%>">
 <table style="display:none;">
	 <tr>
	 	<td>사용자 ID <%=loginUrl%>:</td>
	 	<td><input type="text" id="txtUserID" name="<%=ParamInfo.USER_ID%>"/></td>
	 </tr>
	 <tr>
	 	<td>비밀번호 <%=request.getParameter(ParamInfo.USER_PW)%>:</td>
	 	<td><input type="password" id="txtPwd" name="<%=ParamInfo.USER_PW%>"/></td>
	 </tr>
 	 <tr><td colspan="2" align="center"><input type="button" value="로그온" onclick="OnLogon();"/></td></tr>
 </table>
 
 <input type="hidden" name="<%=ParamInfo.CRED_TYPE%>" value="BASIC"/>
 <input type="hidden" name="<%=ParamInfo.RETURN_URL%>" value="<%=returnUrl%>"/>
 <input type="hidden" name="<%=ParamInfo.SITE_ID%>" value="<%=siteID%>"/>
</form>
  <hr/>
상태 코드:<%=status.toString()%>
<hr/>
에러 코드:<%=errorCode%>
<hr/>

에러 메시지:<%=errorMessage%>
<hr/>
<!-- <a href="./logonEnc.jsp">암호화 로그온</a> -->
<script type="text/javascript">
 <%=logInOutScript%>
</script>
</body>
</html>
<%
}
catch (AgentException e)
{
 System.out.println("ErrorCode : " + e.getExceptionCode().toString());
 System.out.println("ErrorMessage : " + e.getMessage());
%>
<%=e.toString()%>
<%
 }
%>

	  

