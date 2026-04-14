<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<script src="${root}cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>

  <meta charset="UTF-8">
  <title>로그인 안내</title>
  <style>
    html, body {
      height: 100%;
      margin: 0;
      font-family: 'Malgun Gothic', sans-serif;
      background-color: white;
    }

    .wrapper {
      height: 100%;
      display: flex;
      justify-content: center;  /* 수평 중앙 */
      align-items: center;      /* 수직 중앙 */
    }

    .notice-box {
      border: 4px solid #002060;
      width: 600px;
      height: 60%;
      box-sizing: border-box;
      padding: 40px;
      text-align: center;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .notice-box h2 {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 30px;
    }

    .contact {
      font-size: 14px;
      margin-top: 20px;
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="notice-box">
      <h2>H-way 시스템 접속은<br>오토웨이를 통해 진행해 주시기 바랍니다.</h2>
      <div class="contact">
          문의 : [경인지원본부 ICT플랫폼2팀] 김종헌 책임매니저 <br>
                   ☎ 02-2134-4897
      </div>
    </div>
  </div>
</body>
</html>

