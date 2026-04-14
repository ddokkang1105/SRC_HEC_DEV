<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<% 
	String languageID = request.getParameter("languageID") == null ? "" : request.getParameter("languageID");
	String s_itemID = request.getParameter("s_itemID") == null ? "" : request.getParameter("s_itemID");
	String modelID = request.getParameter("modelID") == null ? "" : request.getParameter("modelID");
	String scrnType = request.getParameter("scrnType") == null ? "" : request.getParameter("scrnType"); 
	String modelName = request.getParameter("modelName") == null ? "" : request.getParameter("modelName");
	String MTCategory = request.getParameter("MTCategory") == null ? "" : request.getParameter("MTCategory");
	String ModelTypeName = request.getParameter("modelTypeName") == null ? "" : request.getParameter("modelTypeName");
	String option = request.getParameter("option") == null ? "" : request.getParameter("option");
	String newElementIDs = request.getParameter("newElementIDs") == null ? "" : request.getParameter("newElementIDs");
	String delElementIDs = request.getParameter("delElementIDs") == null ? "" : request.getParameter("delElementIDs");
	String menuUrl = request.getParameter("menuUrl") == null ? "" : request.getParameter("menuUrl");
	String selectedTreeID = request.getParameter("selectedTreeID") == null ? "" : request.getParameter("selectedTreeID");
	String focusedItemID = request.getParameter("focusedItemID") == null ? "" : request.getParameter("focusedItemID");
	String changeSetID = request.getParameter("changeSetID")== null ? "" : request.getParameter("changeSetID");
	String instanceNo = request.getParameter("instanceNo")== null ? "" : request.getParameter("instanceNo");
	
%> 
<title><%=ModelTypeName%> - <c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript">

var languageID="<%=languageID%>";
var s_itemID="<%=s_itemID%>";
var modelID="<%=modelID%>";
var scrnType="<%=scrnType%>";
var MTCategory="<%=MTCategory%>";
var arcCode="<%=option%>";
var newElementIDs = "<%=newElementIDs%>";
var delElementIDs = "<%=delElementIDs%>";
var srcUrl;
var browserType="";
var menuUrl = "<%=menuUrl%>";
var selectedTreeID = "<%=selectedTreeID%>";
var focusedItemID = "<%=focusedItemID%>";
var changeSetID = "<%=changeSetID%>";
var instanceNo = "<%=instanceNo%>";

jQuery(document).ready(function() {
	//if($.browser.msie){browserType="IE";}
	var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
	if(IS_IE11){browserType="IE11";}
	
	if(scrnType == "view"){
		if(instanceNo != ""){
			srcUrl = "viewProcInstModel.do?instanceNo="+instanceNo+"&scrnMode='C','V'";
		}else{
			if(menuUrl != "") srcUrl = menuUrl+".do?scrnMode='C','V'"; else srcUrl = "newDiagramViewer.do?scrnMode='C','V'";	
		}
	}else{srcUrl = "newDiagramEditor.do?scrnMode='C','E'";	}
	
	srcUrl = srcUrl + "&languageID="+languageID
					+ "&s_itemID="+s_itemID
					+ "&modelID="+modelID
					+ "&scrnType="+scrnType
					+ "&MTCategory="+MTCategory
					+ "&otpion="+arcCode
					+ "&focusedItemID="+focusedItemID
					+ "&newElementIDs="+newElementIDs
					+ "&delElementIDs="+delElementIDs
					+ "&selectedTreeID="+selectedTreeID
					+ "&changeSetID="+changeSetID
					+ "&pop=Y";
	$('#main').attr('src',srcUrl);});
	
	function fnViewModelInfo(menuUrl){		
		var srcUrl = menuUrl + ".do?scrnMode='C','V'"
					+ "&languageID="+languageID
					+ "&s_itemID="+s_itemID
					+ "&modelID="+modelID
					+ "&scrnType="+scrnType
					+ "&MTCategory="+MTCategory
					+ "&otpion="+arcCode
					+ "&focusedItemID="+focusedItemID
					+ "&newElementIDs="+newElementIDs
					+ "&delElementIDs="+delElementIDs
					+ "&selectedTreeID="+selectedTreeID
					+ "&changeSetID="+changeSetID
					+ "&pop=Y";
		$('#main').attr('src',srcUrl);

	}
	
</script>
</head><body>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
