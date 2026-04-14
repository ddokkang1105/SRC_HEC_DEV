<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00093" var="WM00093_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00093" var="WM00093_2" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00131" var="WM00131"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>

<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var p_gridArea;				//그리드 전역변수
$(document).ready(function(){
	$("input.datePicker").each(generateDatePicker);
	var aprvOption = "${getMap.AprvOption}";
	var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('Status', data+"&category=PJTSTS", 'getDictionaryOrdStnm', '${getMap.Status}', 'Select');
	fnSelect('company',data+'&teamType=2','getTeam','${getMap.CompanyID}','Select');
	fnSelect('aprvOption', data+"&category=APRVOPTION", 'getDictionaryOrdStnm', aprvOption);
	// 화면별 화면 전체 폭 제어
	if ("${pjtMode}" == "N") {
		$("#screenType").attr('style', 'margin:20px;');
	}
});

function savePrj(){
	// 명칭 & 담당자 필수 Check
	if ($('#ProjectName').val() == "") {
		//alert("생성 할 프로젝트 명칭을 입력 해 주세요.");
		alert("${WM00093_1}");
		return;
	}
			
	if(confirm("${CM00001}")){
		var url = "editVariantInfo.do"; // 요청이 날라가는 주소
		ajaxSubmit(document.projectInfoFrm, url);
	}
}


// [Back] click
function goBack() {
	var url = "variantDetail.do";
	var data = "isNew=${isNew}&s_itemID=${projectID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&pjtMode=R&screenType=${screenType}";
	var target = "objectInfoDiv";
	
	ajaxPage(url, data, target);
}

</script>

<div id="objectInfoDiv" >
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="editVariantInfo.do" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="pjtMode" name="pjtMode"  value="${pjtMode}" />
	<input type="hidden" id="editBtn" name="editBtn"  value="" />
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="variantItemID" name="variantItemID" value="${variantID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="pjtType" name="pjtType"  value="PJT" />
	
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />

	<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">
		${menu.LN00249}
	</div>
	     
	<table class="tbl_blue01 mgT10" width="98%" border="0" cellpadding="0" cellspacing="0" ><!-- style="table-layout:fixed;" -->
		<colgroup>
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col width="13%">
			<col>
		</colgroup>
		<tr>
			<!-- 코드 -->
			<th class="alignL pdL5">${menu.LN00015}</th>
			<td class="alignL pdL5">
				<input type="text" id="ProjectCode" name="ProjectCode" value="${getMap.ProjectCode}" class="text" style="width: 70px;">
			</td>
			<!-- company  -->
			<th class="alignL pdL5">${menu.LN00014}</th>
			<td class="alignL pdL5">
				${getMap.CompanyName}
			</td>
			<!-- 처리옵션 -->
			<th class="alignL pdL5">${menu.LN00293}</th>
			<td class="alignL pdL5 last">
				${getMap.AprvOptionName}
			</td>
		</tr>
		<tr>
			<!-- 담당부서 -->
			<th class="alignL pdL5">${menu.LN00018}</th>
			<td class="alignL pdL5">
				${getMap.TeamName}
			</td>
			<!-- 담당자 -->				
			<th class="alignL pdL5 ">${menu.LN00004}</th>
			<td  class="alignL pdL5">
				${getMap.AuthorName}
			</td>
			<!-- 진행상태 -->					
			<th class=" alignL pdL5"> ${menu.LN00065}</th>	
			<td class="alignL pdL5 last ">
				<select id="Status" name="Status" style="width:90%"></select>
			</td>	
		</tr>
		<tr>
			<!-- 실행기간 : 시작일 -->
			<th class=" alignL pdL5">${menu.LN00063}</th>
			<td class=" alignL pdL5">
				<input type="text" id="StartDate" name="StartDate" value="${getMap.StartDate}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</td>
			<!-- 실행기간 : 종료 예정일 -->
			<th class="alignL pdL5">${menu.LN00062}</th>
			<td class="alignL pdL5">
				<input type="text" id="DueDate" name="DueDate" value="${getMap.DueDate}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</td>		
			<th class="alignL pdL5">${menu.LN00064}</th>
			<td class="alignL pdL5 last">${getMap.EndDate}</td>	
		</tr>
		<tr><!-- 명칭  -->
			<th class="alignL pdL5">${menu.LN00028}</th>
			<td colspan="5" class="alignL last" >
				<input type="text" class="text" id="ProjectName" name="ProjectName" value="${variantInfo.Name}"/>
			</td>
		</tr>	
		<tr>
			<!-- 개요 -->
			<th class="alignL pdL5">${menu.LN00035}</th>
			<td colspan="5" class="alignL last" >
				<div style="width:100%;height:200px;">
					<textarea class="tinymceText"  id="Description" name="Description" >${variantInfo.Description}</textarea>
				</div>
			</td>
		</tr>
		
		<!-- [Edit] 버튼 제어 -->
        <tr>
       		<td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9">
       			<span class="btn_pack medium icon"><span class="save"></span><input value="save" onclick="savePrj();" type="submit"></span>
       		</td>          
        </tr>
	</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>