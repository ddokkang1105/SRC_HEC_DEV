<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<title>${fileRealName}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<script type="text/javascript">

$(document).ready(function(){
	/*
	var data = "fileType=URL&convertType=1&filePath=http://gbpmsdev.mando.com/viewerFileDownload.do?seq=${seq}&refererUrl=http://gbpms.mando.com&downloadUrl=&fid=${seq}&force=true&sync=true&urlEncoding=UTF-8";
	var url= "${actionURL}" + "?" + data; 
	openFullPopup(url, "Mando Web Viewer");
	window.self.close();*/

	var isNew = "${isNew}";
	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	var data = 	{
			
		    fileType: "URL",

		   // convertType:  "0",
		    filePath: "<%=GlobalVal.OLM_SERVER_URL%>/viewerFileDownload.do?seq=${seq}", 		   
		    refererUrl: "<%=GlobalVal.OLM_SERVER_URL%>",
		    downloadUrl: "",
		    fid: "GBPMS_${seq}",
		    force: true,		    
		    sync : false,
		    urlEncoding: "UTF-8" 

	}
	
	if(isNew == "Y") {
		//var data = "fileType=URL&convertType=1&filePath=http://gbpmsdev.mando.com/viewerFileDownload.do?seq=${seq}&refererUrl=http://gbpms.mando.com&downloadUrl=&fid=${seq}&force=true&sync=true&urlEncoding=UTF-8";
		
		ajaxFileViewer("${actionURL}",data,"${seq}");
	}
	else {
		var checkUrl = "${actionURL}";
		
		var key = checkUrl.substring(checkUrl.indexOf('=')+1,checkUrl.indexOf('&'));
		var url = "<%=GlobalVal.DOC_VIEWER_URL%>/SynapDocViewServer/status/" + key; 
		
		if(ajaxCheckFile(url)) {
			$('#fileDownLoading').addClass('file_down_off');
			$('#fileDownLoading').removeClass('file_down_on');
			location.href = "${actionURL}";
		}
		else {
			ajaxFileViewer("<%=GlobalVal.DOC_VIEWER_URL%>/SynapDocViewServer/jobJson",data,"${seq}"); 			
		}                   
	}
});

function fnCallback(url) {
	$('#fileDownLoading').addClass('file_down_off');
	$('#fileDownLoading').removeClass('file_down_on');
	$("#help_content").attr("style","width:100%;height:100%");
	
	location.href = url;
	window.opener.urlReload();
}

</script>
<body>
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>
<div id="help_content"></div>

</body>
</html>