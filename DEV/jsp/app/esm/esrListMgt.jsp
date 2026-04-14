<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var jsonData = JSON.parse('${jsonData}');
	$(document).ready(function(){
		setEsrFrame(jsonData.srType);
	});
	
	function setEsrFrame(srType){
		var url = "";
		var target = "esrListMgt";
		var data = "";

		var key = Object.getOwnPropertyNames(jsonData);
		for(var i=0; i< key.length;i++){
			if(key[i] == "searchStatus" && jsonData[key[i]]=="NEW"){
				if(srType == "ITSP" || srType == "CSP") 	data += "&searchStatus=SPE001"
				if(srType == "ISP") 	data += "&searchStatus=SPE018"
			} else {
				data += "&"+key[i]+"="+jsonData[key[i]];
			}
		}
		
		switch(srType){
			case "ITSP":		url = "itspList.do"; 	break;
			case "ISP":		url = "ispList.do";	break;
			case "CSP":	url = "cspList.do";	break;
		}
		ajaxPage(url, data, target);
	}
</script>
<div id="esrListMgt"></div>



