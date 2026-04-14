<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%

	//EPKI 용 인증서 값  EPKI 서버 인증서가 변경되면 다시 바꿔줘야 함
	HttpSession m_Session = request.getSession();
	String sessionID = m_Session.getId();
	
	String strServerCert = "MIIF1TCCBL2gAwIBAgIUTy/4odYJAoRpQ77C3RQ+t/UvgZMwDQYJKoZIhvcNAQELBQAwUDELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExDTALBgNVBAsMBEdQS0kxFDASBgNVBAMMC0NBMTM0MTAwMDMxMB4XDTE1MDUwNzA3NTU1MVoXDTE3MDgwNzA3NTU1MFowcTELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExGDAWBgNVBAsMD0dyb3VwIG9mIFNlcnZlcjESMBAGA1UECwwJ6rWQ7Jyh67aAMRYwFAYDVQQDDA1TVlI3MDA4MTAxMDAzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAweaPt2VcGUnahXnpRmg6z35oFBN44cQBShUgDhc9xxrfFTeRHWfRCx3HSY+ZqivT/lTSwd86RikAFUU6gBh4Z6coGPF3/qMOAOji9Eyxu2MTQAIwtGlwnGGJppUXUHfikh8zLzZUQVlm+ZhaoRVpRuRC723/qsJ6HrOvkBoC6gE07xFvKIqiTdNKQbtHzAIsolau6tNmvtHvXDjJJaIbZenzezGH1Asjpf3rbQ/itMasg+d+iGFZJVBqAXrAjWeJhVu29YQFqZ4ynsq5LSUXvEC1d2S8IPTaUfmzxO11/Vq9WIzay3kJe/dF/py0YipG9UusAKr9tpih9bPFXjbUNwIDAQABo4IChDCCAoAwNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzABhhtodHRwOi8vb2NzcC5lcGtpLmdvLmtyOjgwODAweQYDVR0jBHIwcIAUjkb4DZ54dqLMGuQPUX9S102cWxuhVKRSMFAxCzAJBgNVBAYTAktSMRwwGgYDVQQKDBNHb3Zlcm5tZW50IG9mIEtvcmVhMQ0wCwYDVQQLDARHUEtJMRQwEgYDVQQDDAtHUEtJUm9vdENBMYICJxkwHQYDVR0OBBYEFJdqJmtwZc729QBEbfTFOrjXRlX+MA4GA1UdDwEB/wQEAwIEMDBtBgNVHSABAf8EYzBhMF8GCiqDGoaNIQUDAQcwUTAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5lcGtpLmdvLmtyL2Nwcy5odG1sMCMGCCsGAQUFBwICMBcaFUVkdWNhdGlvbiBDZXJ0aWZpY2F0ZTAxBgNVHRIEKjAooCYGCSqDGoyaRAoBAaAZMBcMFeq1kOycoeqzvO2Vmeq4sOyIoOu2gDBuBgNVHREEZzBloGMGCSqDGoyaRAoBAaBWMFQMDzIxMC4xMDIuMjIwLjIxMDBBMD8GCiqDGoyaRAoBAQEwMTALBglghkgBZQMEAgGgIgQgnDgVHXkskR3JW0bmwOR/OhvcaoGe356xTyUuPv6YHQMwgYgGA1UdHwSBgDB+MHygeqB4hnZsZGFwOi8vbGRhcC5lcGtpLmdvLmtyOjM4OS9jbj1jcmwxcDFkcDE0MTkwLG91PUNSTCxvdT1HUEtJLG89R292ZXJubWVudCBvZiBLb3JlYSxjPWtyP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MA0GCSqGSIb3DQEBCwUAA4IBAQB70yZ1jXQbmWUrbOUCgy3RU4XcWcuw5+CqyhZkUpEL1d20OfO37xxMXV7ir5UaEkB8hy/yGSzh190ZCTqPgl5OhOxiCMOUKk60z60NP4OUg3cR52jQ9KHyNLBG5lhzhH8/Xmi/2rGHDv5/RIAWgp+r1QAsGjcuDZTWqFEkffQLnKlYHGT+4dLk600EPz1E2GYfGOZPyStOMyStI6vu4aN1JAgQCXwBERaxpXRFNkKy6gCknxukm597swpPsN7FpJbz7tbmmq4iVRjKE6j8p7ZhNqNzENfsecRrBTkMWMJg+Ef8bruOW9OcpUtOdZ0ax9IFyTdTdzYhs0N16lvN2lonMIIF1TCCBL2gAwIBAgIUTy/4odYJAoRpQ77C3RQ+t/UvgZMwDQYJKoZIhvcNAQELBQAwUDELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExDTALBgNVBAsMBEdQS0kxFDASBgNVBAMMC0NBMTM0MTAwMDMxMB4XDTE1MDUwNzA3NTU1MVoXDTE3MDgwNzA3NTU1MFowcTELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExGDAWBgNVBAsMD0dyb3VwIG9mIFNlcnZlcjESMBAGA1UECwwJ6rWQ7Jyh67aAMRYwFAYDVQQDDA1TVlI3MDA4MTAxMDAzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAweaPt2VcGUnahXnpRmg6z35oFBN44cQBShUgDhc9xxrfFTeRHWfRCx3HSY+ZqivT/lTSwd86RikAFUU6gBh4Z6coGPF3/qMOAOji9Eyxu2MTQAIwtGlwnGGJppUXUHfikh8zLzZUQVlm+ZhaoRVpRuRC723/qsJ6HrOvkBoC6gE07xFvKIqiTdNKQbtHzAIsolau6tNmvtHvXDjJJaIbZenzezGH1Asjpf3rbQ/itMasg+d+iGFZJVBqAXrAjWeJhVu29YQFqZ4ynsq5LSUXvEC1d2S8IPTaUfmzxO11/Vq9WIzay3kJe/dF/py0YipG9UusAKr9tpih9bPFXjbUNwIDAQABo4IChDCCAoAwNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzABhhtodHRwOi8vb2NzcC5lcGtpLmdvLmtyOjgwODAweQYDVR0jBHIwcIAUjkb4DZ54dqLMGuQPUX9S102cWxuhVKRSMFAxCzAJBgNVBAYTAktSMRwwGgYDVQQKDBNHb3Zlcm5tZW50IG9mIEtvcmVhMQ0wCwYDVQQLDARHUEtJMRQwEgYDVQQDDAtHUEtJUm9vdENBMYICJxkwHQYDVR0OBBYEFJdqJmtwZc729QBEbfTFOrjXRlX+MA4GA1UdDwEB/wQEAwIEMDBtBgNVHSABAf8EYzBhMF8GCiqDGoaNIQUDAQcwUTAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5lcGtpLmdvLmtyL2Nwcy5odG1sMCMGCCsGAQUFBwICMBcaFUVkdWNhdGlvbiBDZXJ0aWZpY2F0ZTAxBgNVHRIEKjAooCYGCSqDGoyaRAoBAaAZMBcMFeq1kOycoeqzvO2Vmeq4sOyIoOu2gDBuBgNVHREEZzBloGMGCSqDGoyaRAoBAaBWMFQMDzIxMC4xMDIuMjIwLjIxMDBBMD8GCiqDGoyaRAoBAQEwMTALBglghkgBZQMEAgGgIgQgnDgVHXkskR3JW0bmwOR/OhvcaoGe356xTyUuPv6YHQMwgYgGA1UdHwSBgDB+MHygeqB4hnZsZGFwOi8vbGRhcC5lcGtpLmdvLmtyOjM4OS9jbj1jcmwxcDFkcDE0MTkwLG91PUNSTCxvdT1HUEtJLG89R292ZXJubWVudCBvZiBLb3JlYSxjPWtyP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MA0GCSqGSIb3DQEBCwUAA4IBAQB70yZ1jXQbmWUrbOUCgy3RU4XcWcuw5+CqyhZkUpEL1d20OfO37xxMXV7ir5UaEkB8hy/yGSzh190ZCTqPgl5OhOxiCMOUKk60z60NP4OUg3cR52jQ9KHyNLBG5lhzhH8/Xmi/2rGHDv5/RIAWgp+r1QAsGjcuDZTWqFEkffQLnKlYHGT+4dLk600EPz1E2GYfGOZPyStOMyStI6vu4aN1JAgQCXwBERaxpXRFNkKy6gCknxukm597swpPsN7FpJbz7tbmmq4iVRjKE6j8p7ZhNqNzENfsecRrBTkMWMJg+Ef8bruOW9OcpUtOdZ0ax9IFyTdTdzYhs0N16lvN2lon";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- EPKI Client Toolkit 공용 스크립트 -->
<SCRIPT language="javascript" src="http://sso.daelim.ac.kr/isignplus/epki/EPKICommon.js"></SCRIPT>

<SCRIPT language="javascript">
<!--
//EPKI Client Toolkit 설치 확인, 객체 생성 및 공통 속성 지정
SetupObjECT(true);
InitObjECT();

function RequestSessionData()
{
	var theForm = document.forms[0];
	var strRequestData;

    strRequestData = RequestSession("<%=strServerCert%>", "ARIA", "<%=sessionID%>");
    if(strRequestData == "")
	{
		ECTErrorInfo();
	}
	else if(strRequestData == "100"){
		// 취소 버튼 클릭시
		return;
	}else
	{
		theForm.SessionRequestData.value = strRequestData;
		theForm.submit();
	}
}
-->
</SCRIPT>

</head>
	
<body>
	<!-- Web-Agent의 로그인페이지에 include 한다. -->
	<%@ include file="/WEB-INF/jsp/custom/daelim/sso/isign_sso_login_include.jsp" %>
	<!-- Web-Agent의 로그인페이지에 include 한다. -->
	
	<!-------------------------------------------------------
	 * login form
	 //------------------------------------------------------>
	<form name="loginform" method="post" action="http://sso.daelim.ac.kr/LoginServlet?method=pkiProcess&ssid=<%=SSID%>">
		
		<!----- [인증서버와 통신 방식이 ISSAC-Web인 경우만 설정]ISSAC-Web 구간 암호화를 적용하기 위하여 hidden을  추가하여야 한다. ----->
		<input type="hidden" name="issacweb_data" value="" />
		<input type="hidden" name="challenge" value="" />
		<input type="hidden" name="response" value="" />
		<!----- [인증서버와 통신 방식이 ISSAC-Web인 경우만 설정]ISSAC-Web 구간 암호화를 적용하기 위하여 hidden을  추가하여야 한다. ----->
		
		<!----- [인증 방식:ID/PWD방식의 로그인인 경우]아이디와 비밀번호 input name은 각각 id,pw로 설정 ----->
		아이디 : <input type="text" name="id" />
		비밀번호 : <input type="password" name="pw" onKeyDown="javascript:if(event.keyCode==13){idpwLogin();}"/>
		<!----- [인증 방식:ID/PWD방식의 로그인인 경우]아이디와 비밀번호 input name은 각각 id,pw로 설정 ----->
		
		<!----- [인증 방식:ID/PWD방식의 로그인인 경우]ID/PW로그인 ----->
		<input type="button" onclick="javascript:idpwLogin();" value="로그인" style="cursor:hand" />
		<!----- [인증 방식:ID/PWD방식의 로그인인 경우]ID/PW로그인 ----->
		
		<!----- [인증 방식:PKI 방식의 로그인인 경우]인증서 로그인 ----->
		<input type="button" value="인증서 로그인" onclick="javascript:pkiLogin();" />
		<!----- [인증 방식:PKI 방식의 로그인인 경우]인증서 로그인 ----->	
	</form>
	

</body>
</html>