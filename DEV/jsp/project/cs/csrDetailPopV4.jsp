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
		var projectID = "${projectID}";
		var screenMode = "${screenMode}";
		var mainMenu = "${mainMenu}";
		var refPjtID = "${refPjtID}";
		var srcUrl = "csrDetail.do?projectID=" + projectID 
				+ "&screenMode=" + screenMode 
				+ "&mainMenu=" + mainMenu 
				+ "&refPjtID="+refPjtID
				+ "&screenType=${screenType}&srID=${srID}&fromSR=${fromSR}"
				+ "&quickCheckOut=${quickCheckOut}&itemID=${itemID}";
		$('#main').attr('src',srcUrl);
		
		window.onresize = function() {
			$("#main").get(0).contentWindow.changeWindowHeight();
		};
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

</script>
</head><body>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="yes" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
