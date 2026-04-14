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
</script><script type="text/javascript" src="path/to/ext-all.js"></script>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function() {
	  var attrRevYN = "${attrRevYN}";
	  var isPossibleEdit = "${isPossibleEdit}";
	  var sessionLogintype = "${sessionScope.loginInfo.sessionLogintype}";
	  var myItem = "${myItem}"; // 실제로는 서버에서 전달된 값으로 처리
	  // 조건에 맞는지 확인
	  if ("${fn:length(manual)}"> 0 && attrRevYN !== 'Y' && isPossibleEdit === 'Y') {
	    if (sessionLogintype === 'editor' && myItem === 'Y') {
	      // 버튼 추가
	      $('#editBTN').html(
	        '<div class="btns floatR"  style="margin-top: -2px;">' +
	        '<span class="btn_pack small icon">' +
	        '<span class="edit"></span>' +
	        '<input value="Edit" onclick="editPopup()" type="submit">' +
	        '</span>' +
	        '</div>'
	      );
	    }
	  }
	  function formatDate(dateStr) {
		  if(dateStr){
		        var year = dateStr.substring(0, 4);
		        var month = dateStr.substring(4, 6);
		        var day = dateStr.substring(6, 8); 
		        return year + '.' + month + '.' + day;
		  }
	    }
	  
	  var DT_BEGN = "${manual[0].DT_BEGN}";
	  $('#DT_BEGN').text(formatDate(DT_BEGN));
	  var DT_END = "${manual[0].DT_END}";
	  $('#DT_END').text(formatDate(DT_END));
	  var DT_PLN_BEGN = "${manual[0].DT_PLN_BEGN}";
	  $('#DT_PLN_BEGN').text(formatDate(DT_PLN_BEGN));
	  var DT_PLN_END = "${manual[0].DT_PLN_END}";
	  $('#DT_PLN_END').text(formatDate(DT_PLN_END));
	  var DT_ACPT_BEGN = "${manual[0].DT_ACPT_BEGN}";
	  $('#DT_ACPT_BEGN').text(formatDate(DT_ACPT_BEGN));
	  var DT_ACPT_END = "${manual[0].DT_ACPT_END}";
	  $('#DT_ACPT_END').text(formatDate(DT_ACPT_END));

	});

var isPossibleEdit = "${isPossibleEdit}";
var itemStatus = "${itemStatus}";
var serviceCode
if("${manual[0].CD_MNOF}"=="P"){
	serviceCode = "Dab40_10_PSiteActivityDtil0001";
}else{
	serviceCode = "Dab40_10_CSiteActivityDtil0001";
}

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
			  "https://manualdev.dlenc.co.kr/sso/linkViewWithParam.jsp?_q=" + qsEnc,
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
				<col width="10%">
				<col width="15%">
				<col width="75%">
				<col>
			</colgroup>
			<c:choose>
	   		<c:when test="${accRight eq 'N' and sessionScope.loginInfo.sessionMlvl ne 'SYS'}" >
	   			<tr>
					<td  class="alignC" colspan = 3>
						 You don't have the access right for this item.
					</td>
				</tr>
			</c:when>
	   		<c:otherwise>
			<c:if test="${itemInfo eq '' }"> 
				<tr>
					<td colspan = 2 class="viewtop alignC" colspan = 2>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			<tr>
				<th colspan = 2 class="alignC">${menu.LN00106}</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].ID_ACTY}</td>
			</tr>
			<tr>	
				<th colspan = 2 class="alignC">Activity 명</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_ACTY}</td>
			</tr>
			<tr>
				<th colspan = 2 class="alignC">공종</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].MAP_VAXIS}</td>
			</tr>	
			<c:if test="${manual[0].CD_MNOF == 'P'}">
			<tr>
				<th colspan = 2 class="alignC">단계</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_PHS}</td>
			</tr>
			</c:if>	
			<tr>
				<th colspan = 2 class="alignC">일반/Milestone
				/Core</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NM_ACTY_TYPE}</td>
			</tr>
			<c:if test="${manual[0].CD_MNOF == 'A' or manual[0].CD_MNOF == 'C'}">
				<tr>
			        <th colspan = 2 class="alignC">Group No</th>
			        <td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NO_GR}</td>
			    </tr>
			</c:if>
			<c:if test="${manual[0].CD_MNOF == 'A' or manual[0].CD_MNOF == 'C'}">
				<tr>
			        <th colspan = 2 class="alignC">Body No</th>
			        <td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NO_BODY}</td>
			    </tr>
				<tr>
			        <th colspan = 2 class="alignC">Sub No</th>
			        <td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].NO_SUB}</td>
			    </tr>
			</c:if>

			<tr>
				<th rowspan=2 class="alignC">Plan</th>
				<th class="alignC">Start</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].DISP_DR_BEGN}</td>
			</tr>
			<tr>
				<th class="alignC">Finish</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">${manual[0].DISP_DR_END}</td>
			</tr>
			<tr>
			    <th colspan="3" class="alignC">일정</th>
			</tr>
			<tr>
				<c:choose>
				    <c:when test="${manual[0].CD_MNOF == 'P'}">
				        <th rowspan="2" class="alignC">Plan</th>
				    </c:when>
				    <c:otherwise>
				        <th rowspan="2" class="alignC">Base</th>
				    </c:otherwise>
				</c:choose>
				<th class="alignC">Start</th>
				<td class="alignL last" id="DT_BEGN"  style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th class="alignC">Finish</th>
				<td class="alignL last" id="DT_END" style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<c:choose>
				    <c:when test="${manual[0].CD_MNOF == 'P'}">
				        <th rowspan="2" class="alignC">Forecast</th>
				    </c:when>
				    <c:otherwise>
				        <th rowspan="2" class="alignC">Plan</th>
				    </c:otherwise>
				</c:choose>
				<th class="alignC">Start</th>
				<td class="alignL last" id="DT_PLN_BEGN" style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th class="alignC">Finish</th>
				<td class="alignL last" id="DT_PLN_END" style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th rowspan=2 class="alignC">Actual</th>
				<th class="alignC">Start</th>
				<td class="alignL last" id="DT_ACPT_BEGN"  style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th class="alignC">Finish</th>
				<td class="alignL last" id="DT_ACPT_END" style="padding:5px 0 5px 10px;"></td>
			</tr>
			<tr>
				<th colspan="2" class="alignC">목적</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;" >
				<textarea id = "CNTS_PPS" style="width:100%;height:100px;" readonly="readonly">${manual[0].CNTS_PPS}</textarea></td>
			</tr>	
			<tr>
				<th colspan="2" class="alignC">방법</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;">
				<textarea id = "CNTS_MTHD" style="width:100%;height:150px;" readonly="readonly">${manual[0].CNTS_MTHD}</textarea></td>
			</tr>	
			<tr>
				<th colspan="2" class="alignC">주관부서</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;" id = "NM_BIC_MA">${manual[0].NM_BIC_MA}</td>
			</tr>	
			<tr>
				<th colspan="2" class="alignC">협업부서</th>
				<td class="alignL last" style="padding:5px 0 5px 10px;" id = "NM_BIC_RN">${manual[0].NM_BIC_RN}</td>
			</tr>
		</c:otherwise>
		</c:choose>
		</table>
<%-- 		 <c:if test="${fn:length(manual) > 0 && attrRevYN ne 'Y' && isPossibleEdit eq 'Y'}">
		 	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
				<div class="alignBTN">
					<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" onclick="editPopup()" type="submit"></span>
				</div>
			</c:if>
		</c:if> --%>
	</div>			
	</div>
</form>
</body></html>
