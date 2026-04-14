<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript">

	$(document).ready(function(){
		setInterval(function() {
			var idx = $("#imgIndex").val();
			
			if(idx == '3') {
				$("#mainimg").attr("src",$("#mainimg").attr("src").replace(idx+".png","1.png"));
				$("#imgIndex").val("1");
			}
			else {
				$("#mainimg").attr("src",$("#mainimg").attr("src").replace(idx+".png",(idx*1+1)+".png"));
				$("#imgIndex").val((idx*1+1)+"");
			}
			
		},30000);
	});

</script>
</head>

<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">	
	<input id="imgIndex" type="hidden" value="1">
     <div id="content" class="pdT10 pdL10 pdR10" >
     	<img id="mainimg" style="height:500px;" src="${root}${HTML_IMG_DIR}/arc/gwtpMain.jpg"/>
     </div>
</body>
</html>


