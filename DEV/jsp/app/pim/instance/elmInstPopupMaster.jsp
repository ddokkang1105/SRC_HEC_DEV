<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript">
	
	jQuery(document).ready(function() {		
		fnPageLoad();
	});
	
	function fnPageLoad(){
		var srcUrl = "${elmInstUrl}?procInstNo=${procInstNo}&elmInstNo=${elmInstNo}&instanceClass=${instanceClass}&instanceNo=${procInstNo}";
		$('#main').attr('src',srcUrl);		
	}
	
	
</script>
</head>
<body style="margin:0; text-align:center;margin-right:10px;">
<iframe name="main" id="main" width="100%" height="99%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0" align="center"></iframe>
</body>
</html>
