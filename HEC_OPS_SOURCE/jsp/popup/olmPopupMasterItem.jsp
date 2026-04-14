<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String languageID = request.getParameter("languageID") == null ? "" : request.getParameter("languageID");
String id = request.getParameter("id") == null ? "" : request.getParameter("id");
String scrnType = request.getParameter("scrnType") == null ? "" : request.getParameter("scrnType");
String screenMode = request.getParameter("screenMode") == null ? "" : request.getParameter("screenMode");

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript">
jQuery(document).ready(function() {
	var languageID="<%=languageID%>";
	var id= "${itemID}";  
	var scrnType="<%=scrnType%>";
	var screenMode="<%=screenMode%>";	
	var itemClassMenuURL = "${itemClassMenuURL}";
	if(id == ""){
		alert("Can't find the item you requested!"); return;
	}else{		
		if(itemClassMenuURL != ""){
			srcUrl = itemClassMenuURL+".do?itemID="+id
					+"&itemPopYN=Y&ArcCode=${ArcCode}"
					+"&accMode=${accMode}${itemClassMenuVarFilter}";
		}else{
			srcUrl = "itemInfoPop.do?languageID="+languageID
					+"&id="+id+"&scrnType="+scrnType
					+"&screenMode="+screenMode
					+"&ArcCode=${ArcCode}&changeSetID=${changeSetID}"
					+"&accMode=${accMode}${itemClassMenuVarFilter}"; 
		}
		$('#main').attr('src',srcUrl);
	}
	
	});
</script>
</head><body>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
