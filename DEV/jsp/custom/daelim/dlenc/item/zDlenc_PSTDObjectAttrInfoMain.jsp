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
<script src="${root}cmm/js/tinymce_v5/tinymce.min.js" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120" />
<script type="text/javascript">
	var chkReadOnly = true;
</script><script type="text/javascript" src="path/to/ext-all.js"></script>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function() {
	// 모든 td와 th 요소에 대해 user-select: text 스타일을 부여
	const cells = document.querySelectorAll('td, th');
	cells.forEach(function(cell) {
	    cell.style.setProperty('user-select', 'text');
	});
	// 버튼 추가
	$('#editBTN').html(
	  '<div class="btns floatR"  style="margin-top: -2px;">' +
	  '<span class="search"></span>' +
	  '<input  type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_view2.png" value="View" onclick="editPopup()" type="submit">' +
	  '</span>' +
	  '</div>'
	);
	
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

var serviceCode = "Dab40_10_PStdActivityDtil0001";

function editPopup(){
	var qsMap = {
			"serviceCode": serviceCode,
			"NO_STD_MNAL": "${manual[0].NO_STD_MNAL}",
			"ID_ACTY": "${manual[0].ID_ACTY}"
	};
	var qsStr = JSON.stringify(qsMap);
	var qsEnc = btoa(qsStr);
	window.open(
			  "https://manual.dlenc.co.kr/sso/linkViewWithParam.jsp?_q=" + qsEnc,
			  "popupWindow", 
			  "width=940,height=700,top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes,noopener,noreferrer"
			);

}

function fnUrlReload(){
	var screenType = "${screenType}";
	if(screenType=="model"){		
		reload();
	}else{
		parent.document.getElementById("diagramInfo").src="zDlenc_ElmInfoTabMenu.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
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
					<td class="viewtop alignC" colspan = 2>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			<tr>
				<th class="alignC">Activity 명칭</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_NM_ACTY}</td>
			</tr>
			<tr>
				<th class="alignC">Activity ID</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].ID_ACTY}</td>
			</tr>
			<tr>
				<th class="alignC">Level</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].LVL_PATH}</td>
			</tr>
			<tr>
				<th class="alignC">${menu.LN00386}</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;" >
				<textarea id = "CNTS_PPS" style="width:100%;height:100px;" readonly="readonly">${manual[0].PROP_CNTS_PPS}</textarea></td>
			</tr>	
			<tr>
				<th class="alignC">방법</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">
				<textarea id = "CNTS_MTHD" style="width:100%;height:150px;" readonly="readonly">${manual[0].PROP_CNTS_MTHD}</textarea></td>
			</tr>
			<tr>
				<th class="alignC">${menu.LN00199}</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].CNTS_OPUT_GIDE}</td>
			</tr>
			<tr>
				<th class="alignC">기준일</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DR_STD}</td>
			</tr>
			<tr>
				<th class="alignC">Main Process 선행</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_MP_LINK}</td>
			</tr>
			<tr>
				<th class="alignC">Core Process 여부</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].YN_IADV_PRSS}</td>
			</tr>
			<tr>
				<th class="alignC">P6 여부</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].YN_P6}</td>
			</tr>
			<tr>
				<th class="alignC">유관시스템</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_CNTN_SYS}</td>
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
