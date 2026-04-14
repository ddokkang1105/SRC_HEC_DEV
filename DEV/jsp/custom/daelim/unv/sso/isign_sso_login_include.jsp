<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
	/**
		예외 처리
		-> isign_sso_login_include.jsp가 직접 호출되면 index 및 business 페이지로 send
	*/
	String err = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
	String SERVICE_BUSINESS_PAGE = session.getAttribute("SERVICE_BUSINESS_PAGE") == null ? "/index.jsp" : session.getAttribute("SERVICE_BUSINESS_PAGE").toString();
	if (err.indexOf("isign_sso_login_include.jsp") != -1) {
		response.sendRedirect(SERVICE_BUSINESS_PAGE);
		return;
	}
	

	String SSID = session.getAttribute("SSID") == null ? "" : session.getAttribute("SSID").toString();
	String AUTHORIZATION_URL = session.getAttribute("AUTHORIZATION_URL") == null ? "" : session.getAttribute("AUTHORIZATION_URL").toString();
	String AUTHORIZATION_SSL_URL = session.getAttribute("AUTHORIZATION_SSL_URL") == null ? "" : session.getAttribute("AUTHORIZATION_SSL_URL").toString();
	String authMethod = session.getAttribute("authMethod") == null ? "" : session.getAttribute("authMethod").toString();
	String USEISIGNPAGE = session.getAttribute("USEISIGNPAGE") == null ? "" : session.getAttribute("USEISIGNPAGE").toString();
	String checkServer = session.getAttribute("checkServer") == null ? "" : session.getAttribute("checkServer").toString();
	String Exception = session.getAttribute("Exception") == null ? "" : session.getAttribute("Exception").toString();
	String EXISTLOGIN = session.getAttribute("EXISTING_LOGIN_PAGE") == null ? "" : session.getAttribute("EXISTING_LOGIN_PAGE").toString();
	

	
	/**
	예외 처리
		-> checkServer를 거치지 않았으면 buseinss 페이지 호출
		-> 인증서버와 통신도중 문제가 발생 되면 기존 로그인 페이지로 리다이렉션
	*/	
	if (true == checkServer.equals("")) {
		response.sendRedirect(SERVICE_BUSINESS_PAGE);
		return;
	} else {
		if (true == Exception.equals("Y")) {
			if (EXISTLOGIN.equals("") == true) {
				// 인증서버와 통신도중 문제가 발생하면 출력되는 메시지
				out.println("<h1> 네트워크에 문제가 있습니다. 확인해주세요. </h1>");
				return;
			} else {
				// 인증서버와 통신도중 문제가 발생하면 EXISTLOGIN으로 리다이렉션
				response.sendRedirect(EXISTLOGIN);
				return;
			}
		}
	}


/************************************************************
 *	공통 로그인  부분
 ************************************************************/	
if (true == USEISIGNPAGE.equals("Y")) {
	if (authMethod.indexOf("ssl") != -1) {
		response.sendRedirect(AUTHORIZATION_SSL_URL+"LoginServlet?method=idpwForm&ssid="+SSID);
		return;
	} else {
		response.sendRedirect(AUTHORIZATION_URL+"LoginServlet?method=idpwForm&ssid="+SSID);
		return;
	}

} else {
/************************************************************
 *	개별 로그인  부분
 ************************************************************/		
if (authMethod.indexOf("ssl") == -1) {
%>
		<!-- IssacWeb Applet Version
		<script language="javascript" src="JniIssacWebJs.js"></script>

		// JRE 버전 체크 : 1.6.0_x 버전 보다 작으면 JRE를 설치페이지로 이동 
		<script src="http://www.java.com/js/deployJava.js"></script>
		<script>
			if( !deployJava.versionCheck('1.6.0_0+') )
			{
				if (confirm('JRE를 설치합니다.\n설치를 취소 할 경우 정상동작 되지 않을 수 있습니다.')==true)
					deployJava.installLatestJRE();
				else
					alert("JRE가 설치되지 않았거나 최신버전이 아닙니다. \n페이지가 정상동작 되지 않을 수 있습니다.")
			}				
		</script>
		-->

	<!-- IssacWeb Mix Version -->
		<script language="javascript" src="IssacWebMix.js"></script>
		<script>
			/*
			 * @ authMethod에 따른 IssacWeb Type 분기
			 * @ param : 1=Std, 2=Pro, Other All
			 */
			var authMethod = "<%=authMethod%>";			
			
			if (authMethod == "idpw") {
				issacLoad(1);
			} else if (authMethod == "pki") {
				issacLoad(2);
			} else {
				issacLoad(0);
			}
		</script>

<%
}
%>



<script>
/*********************
 * Global Variable
 *********************/
msg = "인증타입과 다른 방식을 호출하였습니다. 관리자에게 문의해주세요.";
authMethod = "<%=authMethod%>";


/*********************
 * ssl / idpw 인증 방식
 *********************/
function idpwLogin() {	
	/* //IE 버전 9이하는 로그인이 되지 않아야함. 
	var ua = window.navigator.userAgent;
	var ie = ua.indexOf("MSIE ");
	var ieversion = "";
	if( ie > 0 ) {
		ieversion = parseInt(ua.substring(ie+5, ua.indexOf(".", ie))); 
		if( ieversion>=6 && ieversion<=9 ){
			//최신 브라우저 링크 팝업
			browserLinkPopup();
			return;
		}else{ 
			//ie 10이상
		}
	} */
	   
	var frm = document.loginform;	/* login form 수정 */
	if (authMethod.indexOf("idpw") == -1 && authMethod.indexOf("ssl") == -1) {
		alert(msg);
		return;
	}
	
	if (frm.id.value == "") {
		alert("아이디를 입력해주세요.");
		frm.id.focus();
		return;
	}
	
	if (frm.pw.value == "") {
		alert("비밀번호를 입력해주세요.");
		frm.pw.focus();
		return;
	}

	var varForm = frm;
	var varLoginId = frm.id.value;
	var varLoginPw = frm.pw.value;
	
	var charReg = /[a-z]+/g;
	var CHARReg = /[A-Z]+/g;
	var numReg = /[0-9]+/g;
	var specialReg = /['~!@#$%^&*|\\\'\";:.\/?]/gi;
	var timesReg = /\w[1,2]/g;

	var varPw = varLoginPw;
	var varId = varLoginId;

	var found1 = charReg.exec(varPw);
	var found2 = CHARReg.exec(varPw);
	var found3 = numReg.exec(varPw);
	var found4 = specialReg.exec(varPw);


	var Chk = 0;
       
        if(found1 != null){    //소문자
        	Chk++;
        }
        if(found2 != null){    //대문자
        	Chk++;
        }
        if(found3 != null){   //숫자
        	Chk++;
        }
        if(found4 != null){   //특수문자
        	Chk++;
        }


        if(Chk > 2){
			if(varPw.length  < 8) {
				if(varId.length <9){
					alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
				}else{
					alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
				}
				window.open('https://pt.daelim.ac.kr/eXPortal/pages/dl/pwfindPopup.jsp','','height=410, width=600, directories=no,titlebar=no,toolbar=no,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no');
            return;
			}
         }else if(Chk == 1){
			if(varPw.length == 7 || varPw.length == 6) {
				alert('초기 비밀번호 변경이 필요합니다. \r\n 비밀번호를 변경 후 다시 로그인 하여 주십시오.');
				
				window.open('https://pt.daelim.ac.kr/eXPortal/pages/dl/pwfindPopup.jsp','','height=410, width=600, directories=no,titlebar=no,toolbar=no,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no');
           return;
		   }
         }else if(Chk == 2){
			if(varPw.length < 10) {
				if(varId.length <9){
            		alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
				}else{
					alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
				}
				window.open('https://pt.daelim.ac.kr/eXPortal/pages/dl/pwfindPopup.jsp','','height=410, width=600, directories=no,titlebar=no,toolbar=no,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no');
           return;
		   }
         }else{
			if(varId.length <9){
				alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
            }else{
            	alert('비밀번호가 규칙에 맞지 않습니다.\r\n영대문자, 영소문자, 숫자 및 특수문자 중\r\n2종류 이상으로 구성시 최소 10자리 이상 \r\n3종류 이상 시 최소 9자리 이상으로 구성하셔야 합니다.\r\n\r\n비밀번호를 변경 후 다시 로그인 하여 주십시오.');
            
			}
			window.open('https://pt.daelim.ac.kr/eXPortal/pages/dl/pwfindPopup.jsp','','height=410, width=600, directories=no,titlebar=no,toolbar=no,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no');
		 return;
		 }	


	if ( authMethod.indexOf("ssl") != -1 ) {
		frm.action = "<%=AUTHORIZATION_SSL_URL%>LoginServlet?method=idpwProcessEx&ssid=<%=SSID%>";
		frm.submit();
		return;
		
	} else {
		frm.action = "<%=AUTHORIZATION_URL%>LoginServlet?method=idpwProcess&ssid=<%=SSID%>";
		encryptForm(frm);
		return;
	}
		
	return;
}

/*********************
 * pki 인증 방식
 *********************/
function pkiLogin() {
	var frm = document.loginform;	/* login form 수정 */
	
	if (authMethod.indexOf("pki") == -1) {
		alert(msg);
		return false;
	}
	
	if (!isignPki(frm)) {
		return false;
	}
	
	frm.action = "<%=AUTHORIZATION_URL%>LoginServlet?method=pkiProcess&ssid=<%=SSID%>";
	frm.submit();
	
	return false;
}

</script>

<% } %>
