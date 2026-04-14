<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP/CSS -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120" />
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
var isPossibleEdit = "${isPossibleEdit}";
var itemStatus = "${itemStatus}";
$(document).ready(function() {
	
	var oput = '${manual[0].OPUT_LIST}';
	if (oput && oput !== "null" && oput !== "") {
	    oput = JSON.parse(oput);
	    $.each(oput, function(index, item) {
	        $('<div>', {
	            text: item.NM_FILE_ACTL,
	            target: '_blank',
	            css: { display: 'block'}
	        }).appendTo($('#OPUT_LIST'));
	    });
	}

	var std = '${manual[0].GIDE_TYPE_STD_LIST}';
	if (std && std !== "null" && std !== "") {
	    std = JSON.parse(std);
	    $.each(std, function(index, item) {
	        $('<a>', {
	            href: item.URL_GIDE_PAPE,
	            text: item.NM_GIDE_PAPE,
	            target: '_blank',
	            css: { display: 'block', textDecoration: 'underline' }
	        }).appendTo($('#GIDE_TYPE_STD_LIST'));
	    });
	}

	var exc = '${manual[0].GIDE_TYPE_EXC_LIST}';
	if (exc && exc !== "null" && exc !== "") { 
	    exc = JSON.parse(exc);
	    $.each(exc, function(index, item) {
	        $('<a>', {
	            href: item.URL_GIDE_PAPE,
	            text: item.NM_GIDE_PAPE,
	            target: '_blank',
	            css: { display: 'block', textDecoration: 'underline' }
	        }).appendTo($('#GIDE_TYPE_EXC_LIST'));
	    });
	}

});

function editPopup(url){
   	var data = "?s_itemID=${s_itemID}&languageID="+$('#languageID').val();  	
    	var w = 940;
	var h = 700;
	window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
}

function fnUrlReload(){
	var screenType = "${screenType}";
	if(screenType=="model"){		
		reload();
	}else{
		parent.document.getElementById("diagramInfo").src="zDlenc_ElmInfoTabMenu.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
	}
} 

function fnRunSAP(url, attrUrl, attrTypeCode, varFilter){ 
	var lovCode = "${lovCode}";	
	var itemID = "${s_itemID}";
	if(url == null || url == ""){ 
		url = attrUrl; 
		itemID = "${fromItemID}";
	}
	
	if (url.includes("cxnItemListPop")) {
		url = url+".do?s_itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode + varFilter;
		window.open(url,'','width=750, height=500, left=200, top=100, scrollbar=yes,resizable=yes');					
	}
	else {
		url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
		window.open(url,'_newtab');					
	}

}


</script>
<style>
	.textAreaResize {	 
	  resize: both !important; /* 사용자 변경이 모두 가능 */
	}

</style>
</head><body>
<form name="OAIFrm" id="OAIFrm" action="saveObjAttrChild.do" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:100%;">
	<div id="obAttrDiv" style="margin-bottom:20px;overflow-x:hidden;overflow-y:hidden;">
		<table class="tbl_blue01" style="width:100%;margin-top:5px;" >
			<colgroup>
				<col width="25%">
				<col width="75%">
				<col>
			</colgroup>
			<c:choose>
	   		<c:when test="${accRight eq 'N' and sessionScope.loginInfo.sessionMlvl ne 'SYS'}" >
	   			<tr>
					<td  class="alignC" colspan = 2>
						 You don't have the access right for this item.
					</td>
				</tr>
			</c:when>
	   		<c:otherwise>
			<c:if test="${itemInfo eq '' }"> 
				<tr>
					<td  class="viewtop alignC" colspan = 2>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
						<tr>
				<th class="alignC">산출물 What</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].CNTS_OPUT_GIDE}</td>
			</tr>	
			
			<tr>
				<th class="alignC">산출물 업로드</th>
				<td class="alignL last" id="OPUT_LIST" style="padding:5px 0 5px 10px;"></td>
			</tr>	
			<tr>
			    <th class="alignC">표준서</th>
			    <td class="alignL last" id="GIDE_TYPE_STD_LIST" style="padding:5px 0 5px 10px;">
			    </td>
			</tr>
			<tr>
				<th class="alignC">수행지침</th>
				<td class="alignL last" id="GIDE_TYPE_EXC_LIST" style="padding:5px 0 5px 10px;"></td>
			</tr>
		</c:otherwise>
		</c:choose>
		</table>
	</div>			
	</div>
</form>
</body></html>
