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
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
var isPossibleEdit = "${isPossibleEdit}";
var itemStatus = "${itemStatus}";
$(document).ready(function() {
	var std = '${manual[0].GIDE_TYPE_STD_LIST}';
	if (std && std !== "null" && std !== "") {
	    std = JSON.parse(std);
	    $.each(std, function(index, item) {

	        var qsMap = {
	            serviceCode: 'Dab40_10_AiManualWikiP0001',
	            gubun: item.gubun,
	            docId: item.URL_GIDE_PAPE,
	            chaptId : item.ID_SECT
	        };
	        var qsStr = JSON.stringify(qsMap);
	        var qsEnc = btoa(qsStr);
	        // a 태그 대신 버튼처럼 동작하는 링크 생성
	        var $link = $('<a>', {
	            href: '#',
	            text: item.NM_GIDE_PAPE,
	            css: { display: 'block', textDecoration: 'underline', cursor: 'pointer' },
	            click: function(e) {
	                e.preventDefault(); // a의 기본 이동 막기
	                window.open(
	                    "https://manual.dlenc.co.kr/sso/linkViewWithParam.jsp?_q=" + qsEnc,
	                    "popupWindow",
	                    "width=940,height=700,top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes,noopener,noreferrer"
	                );
	            }
	        });

	        $link.appendTo($('#GIDE_TYPE_STD_LIST'));
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

function fnUrlReload(){
	var screenType = "${screenType}";
	if(screenType=="model"){		
		reload();
	}else{
		parent.document.getElementById("diagramInfo").src="zDlenc_ElmInfoTabMenu.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
	}
} 

var serviceCode = "Dab40_10_CSiteActivityDtil0001";

function editPopup(){
	var qsMap = {
			"serviceCode": serviceCode,
			"CD_SITE": "${projectCode}",
			"CD_MNOF": "${manual[0].CD_MNOF}",
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
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col>
			</colgroup>
			<c:choose>
	   		<c:when test="${accRight eq 'N' and sessionScope.loginInfo.sessionMlvl ne 'SYS'}" >
	   			<tr>
					<td  class="alignC" colspan = 4>
						 You don't have the access right for this item.
					</td>
				</tr>
			</c:when>
	   		<c:otherwise>
			<c:if test="${itemInfo eq '' }"> 
				<tr>
					<td  class="viewtop alignC" colspan = 4>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			<tr>
				<th rowspan = 3 class="alignC">Plan</th>
				<th class="alignC">Base</th>
				<th class="alignC">Plant</th>
				<th class="alignC">Actual</th>
				
			</tr>
			<tr>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_BEGN}</td>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_PLN_BEGN}</td>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_ACPT_BEGN}</td>
			</tr>
			<tr>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_END}</td>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_PLN_END}</td>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_DT_ACPT_END}</td>
			</tr>
			<tr>
				<th class="alignC">유관시스템</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_CNTN_STATUS}</td>
			</tr>
			<tr>
				<th class="alignC">진행상태</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_STAT}</td>
			</tr>
			<tr>
				<th class="alignC">주관부서</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_BIC_MA}</td>
			</tr>
			<tr>
				<th class="alignC">협업부서</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_BIC_RN}</td>
			</tr>
			<tr>
				<th class="alignC">Gate Keeper</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_GK_TYPE}</td>
			</tr>
			<tr>
				<th class="alignC">최종승인</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_GK_MA}</td>
			</tr>
			<tr>
				<th class="alignC">Done 처리 사용</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].PROP_YN_CPLT_USE}</td>
			</tr>
			<tr>
			    <th class="alignC">표준서</th>
			    <td colspan = 3 class="alignL last" id="GIDE_TYPE_STD_LIST" style="padding:5px 0 5px 10px;">
			    </td>
			</tr>
			<tr>
				<th class="alignC">수행지침</th>
				<td colspan = 3 class="alignL last" id="GIDE_TYPE_EXC_LIST" style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th class="alignC">New 여부</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].YN_NEW}</td>
			</tr>
			<tr>
				<th class="alignC">알림여부</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].YN_NTFC}</td>
			</tr>
			<tr>
				<th class="alignC">알림주기</th>
				<td colspan = 3 class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_NTFC_CYCL}</td>
			</tr>
			
		</c:otherwise>
		</c:choose>
		</table>
	</div>			
	</div>
</form>
</body></html>
