<%@page import="xbolt.cmm.service.CommonDataServiceImpl"%>
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page import = "javax.servlet.ServletException" %>
<%@ page import = "xbolt.cmm.framework.handler.ErrorHandler" %>
<%@ page import = "xbolt.cmm.service.CommonService" %>
<%@ page import = "xbolt.cmm.framework.val.GlobalVal"%>
<%@ page import = "java.util.Enumeration" %>
<%@ page isErrorPage = "true" %>
<% response.setStatus(404); %> 

<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<% 
    String languageID = (String)request.getAttribute("sessionScope.loginInfo.sessionCurrLangType");
    
    if(languageID == null || "".equals(languageID)){
    	languageID = GlobalVal.DEFAULT_LANGUAGE;
    }
	
%> 

<html>
<head>
<title>에러 발생</title>
 <style>
        html, body{
            width: 100%;
            height: 100%;
            margin:0;
            padding:0;
        }
        .container{
            width: 100%;
            height: 100%;
            display: table;
        }
        .contents-wrapper{
            display: table-cell;
            vertical-align: middle;
        }
		.wrapper-CI{
		   	width:100%;
			height:20px;
			background-image:url("./<%=GlobalVal.HTML_IMG_DIR%>logo.png");
			background-position:left;
			background-repeat:no-repeat;
			background-size:contain;
		}
        .content{
            margin:0 auto;
            max-width: 570px;
            padding:3em;
        }
        .error-title{
            border-bottom: 1px solid #dfdfdf;
            padding-bottom: 38px;
        }
        .error-title p{
            font-size: 40px;
            margin:5px 0;
        }
        .error-content{
            margin:2em 0;
            font-size: 15px;
            font-weight: 400;
        }
        .description{
            margin:0;
            padding:0 1.5em;
            margin-top: 3em;
            margin-bottom: 3em;
            font-size: 12px;
            font-weight: 300;
        }
        .text-block{
            word-break: normal;
            margin-top: 3em;
        }
    </style>
</head>
<body>
<c:if test="${sessionScope.loginInfo.sessionCurrLangType == '1042'}">
    <div class="container">
        <div class="contents-wrapper">
            
            <div class="content">
                <div class="text-block error-title">
                    <p>요청하신 페이지를</p>
                    <p>바르게 표시할 수 없습니다.</p> 
                </div>
                <p class="text-block error-content">
                    서비스 이용에 불편을 드려 죄송합니다. 아래와 같은 경우 이 페이지가 표시됩니다.
                </p>
                
                <ul class="text-block description">
                    <li>원하는 웹페이지를 찾을 수 없거나 다른 메뉴로 이동한 경우</li>
                    <li>서비스 수행 중 일시적인 장애가 발생한 경우</li>
                    <li>이용의 폭주로 서비스가 지연되는 경우</li>
                    <li>해당 페이지에 대한 접근이 허가되지 않은 경우</li>
                </ul>
                <div class="wrapper-CI"></div>
            </div>
    
        </div>
    </div>
</c:if>

<c:if test="${sessionScope.loginInfo.sessionCurrLangType == '1033'}">
    <div class="container">
        <div class="contents-wrapper">
            
            <div class="content">
                <div class="text-block error-title">
                    <p>The requested web page</p>
                    <p>cannot be correctly displayed.</p> 
                </div>
                <p class="text-block error-content">
                    We apologize for any inconvenience this may have caused you. You will see this page, if
                </p>
                
                <ul class="text-block description">
                    <li>You can not find the web page you want, or go to another menu</li>
                    <li>Temporary failure occurred during service execution</li>
                    <li>Service is delayed due to heavy use</li>
                    <li>Access to this page is not allowed</li>
                </ul>
                <div class="wrapper-CI"></div>
            </div>
    
        </div>
    </div>
</c:if>

<c:if test="${sessionScope.loginInfo.sessionCurrLangType == '2052'}">
    <div class="container">
        <div class="contents-wrapper">
            
            <div class="content">
                 <div class="text-block error-title">
                    <p>The requested web page</p>
                    <p>cannot be correctly displayed.</p> 
             </div>
                <p class="text-block error-content">
                    We apologize for any inconvenience this may have caused you. You will see this page, if
                </p>
                
                <ul class="text-block description">
                    <li>You can not find the web page you want, or go to another menu</li>
                    <li>Temporary failure occurred during service execution</li>
                    <li>Service is delayed due to heavy use</li>
                    <li>Access to this page is not allowed</li>
                </ul>
                <div class="wrapper-CI"></div>
            </div>
    
        </div>
    </div>
</c:if>
</body>
</html>

