<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.regex.*"%>

<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>

<%
	// 환경설정 시작
	String SSO_URL 		= "https://dsin.daesang.com";
	String CLIENT_ID 	= "DBP_01";
	String CLIENT_SECRET = "ZPnw6B4tykR9PHz1xEcTjwQGs1bg1PN18tuaA2IzrXMou5AEOuRFlOXTY6Fd2b1JuA2Cfudk6Hn3QsBReJ94Ig";
	// 환경설정 끝

	// 기본변수 시작
	String W_USER_INF	= "Y";
	String BANDI_SSO_API_GET_TOKEN_URL 	= "/api/sso/token";
	String AND = "&";
	String EQ 	= "=";
	// 기본변수 끝
	String olmI = "";

	// 인증 시작
	String code = request.getParameter("code");
	
	final Log log = LogFactory.getLog(this.getClass());
	

	// code 값 없으면 실패 -> sso 로그인페이지로
	if(code == null) {
		response.sendRedirect(SSO_URL);
	}
	// code 값 있으면 성공 -> sso 서버랑 통신.
	else {
		try {
			// 통신시작
			StringBuffer sb = new StringBuffer();
			sb.append("code").append(EQ).append(code).append(AND);
			sb.append("client_id").append(EQ).append(CLIENT_ID).append(AND);
			sb.append("client_secret").append(EQ).append(CLIENT_SECRET).append(AND);
			sb.append("response_type").append(EQ).append("id_token").append(AND);
			sb.append("iscltapi").append(EQ).append("Y").append(AND);
			sb.append("remote_ip").append(EQ).append(request.getRemoteAddr()).append(AND);
			sb.append("tgentme").append(EQ).append(System.currentTimeMillis()).append(AND);
			sb.append("w_user_inf").append(EQ).append(W_USER_INF);
			String result = post(SSO_URL+BANDI_SSO_API_GET_TOKEN_URL, sb.toString());

			// 결과파싱 시작 (결과 json 값에서 필요한 값만 가져다 쓴다)
			String status = simpleParser("statusCode",result);

			 // 200 성공 -> 로그인 처리
			if("200".equals(status)){
				olmI = (simpleParser("oid",result)).substring(2); // 사번

				// 세션을 발급하든 딴곳으로 넘기든 로그인 처리
				// response.sendRedirect("/indexDS.jsp");
			}
			// 200 외 실패 -> sso 로그인 페이지로
			else{
				response.sendRedirect(SSO_URL);
			}
		} catch(Exception e) {
			//2025-03-25 소스코드 취약점 수정
			log.error("Exception", e);
			//e.printStackTrace();
			//response.sendRedirect(SITE_SSO_CHECK_PAGE);
		}
	}
%>

<%!
	// json 에서 값 가져다 쓰기
	private String simpleParser(String find, String json){
		Matcher matcher = Pattern.compile("\""+find+"\":\"(.+?)\"").matcher(json);
		return (matcher.find()) ? matcher.group(1) : "";
	}

	// http post
	private String post(String ssoUri, String data) {
		String result = "";
		
		final Log log = LogFactory.getLog(this.getClass());
		
		try {
			URL url = new URL(ssoUri);
			if(url.getProtocol().equals("http")) {
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
				conn.setConnectTimeout(5000);
				conn.setDoOutput(true);
				conn.setDoInput(true);
				conn.setUseCaches(false);
				
				PrintWriter out = new PrintWriter(conn.getOutputStream());
				out.print(data);
				out.flush();
				out.close();
				
				if(conn.getResponseCode() == 200) {
					BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
					
					String inputLine = "";
					while ( (inputLine = in.readLine()) != null ) {
						result = inputLine;
					}
					
					in.close();
				} else {
					BufferedReader in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
					String inputLine = "";
					while ( (inputLine = in.readLine()) != null ) {
						result = inputLine;
					}
					
					in.close();
				}
			} else {
				// disableSslVerification(); // SSL 관련 오류 발생 시에 주석 해제하여 우회
				HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
				conn.setConnectTimeout(5000);
				conn.setDoOutput(true);
				conn.setDoInput(true);
				conn.setUseCaches(false);
				
				PrintWriter out = new PrintWriter(conn.getOutputStream());
				out.print(data);
				out.flush();
				out.close();
				
				if(conn.getResponseCode() == 200) {
					BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
					
					String inputLine = "";
					while ( (inputLine = in.readLine()) != null ) {
						result = inputLine;
					}
					
					in.close();
				} else {
					BufferedReader in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
					String inputLine = "";
					while ( (inputLine = in.readLine()) != null ) {
						result = inputLine;
					}
					
					in.close();
				}
			}
		} catch (Exception e) {
			//2025-03-25 소스코드 취약점 수정
			log.error("Exception", e);
			//e.printStackTrace();
		}
		// System.out.println(result);
		return result;
	}
%>

<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
var lgnUrl="${pageContext.request.contextPath}/daesang/logindaesangForm.do";
jQuery(document).ready(function() {
	var olmI = <%=olmI %>;	// 사번
	if(olmI != ""){
		var submitForm = document.mainForm;
		submitForm.target="main";
		submitForm.action=lgnUrl;
		submitForm.submit();
	}else{
		alert("Identification failed");
	}
});
function fnLoginForm() {main.location = lgnUrl;}
</script>
</head><body>
	<form name="mainForm" action="#" method=post target='main'>
	<input type="hidden" id="loginid" name="loginid" value="<%=olmI %>"/>
	<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
	<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
	<input type="hidden" id="loginIdx" name="loginIdx" value="${loginIdx}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>	
	<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>	
	<input type="hidden" id="srID" name="srID" value="${srID}"/>
	<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}"/>	
	<input type="hidden" id="proposal" name="proposal" value="${proposal}"/>
	<input type="hidden" id="status" name="status" value="${status}"/>		
	</form>
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
</body></html>