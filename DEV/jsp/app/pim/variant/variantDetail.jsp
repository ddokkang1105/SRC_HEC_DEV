<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00093" var="WM00093_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00093" var="WM00093_2" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00131" var="WM00131"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>

<script type="text/javascript">
	var chkReadOnly = true;
</script>
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
	
	document.getElementById('htmlReport').style.height = (setWindowHeight() - 60)+"px";			
	window.onresize = function() {
		document.getElementById('htmlReport').style.height = (setWindowHeight() - 80)+"px";	
	};
	
});


function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function savePrj(avg){
	// 명칭 & 담당자 필수 Check
	if ($('#ProjectName').val() == "") {
		//alert("생성 할 프로젝트 명칭을 입력 해 주세요.");
		alert("${WM00093_1}");
		return;
	}
	
	if ($('#AuthorID').val() == "") {
		//alert("생성 할 프로젝트 담당자를 입력 해 주세요.");
		alert("${WM00093_2}");
		return;
	}
	
	// Click 된 버튼 설정
	$('#editBtn').val(avg);
	
	//if(confirm("저장하시겠습니까?")){
	if(confirm("${CM00001}")){
		var url = "admin/savePrjInfo.do"; // 요청이 날라가는 주소
		ajaxSubmit(document.projectInfoFrm, url);
	}
}
	
function searchPopup(url){
	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
}

function setSearchName(memberID,memberName){
	$('#AuthorID').val(memberID);
	$('#AuthorName').val(memberName);
}

function setSearchTeam(teamID,teamName){
	$('#ownerTeamCode').val(teamID);
	$('#TeamName').val(teamName);
}

// [Member] click
function searchMember(url){
	var data = "";
	var isNew = "${isNew}";
	var target = "htmlReport";
	
	data = "projectID=${getMap.ProjectID}&parentID=${getMap.ProjectID}&listEditable=N&isNew=N&isProject=Y&screenType=${screenType}&s_itemID=${s_itemID}";
	
	ajaxPage(url, data, target); 
}

//[Edit][Back] click
function editVariant() {
	var url = "editVariantDetail.do";
	var target = "htmlReport";
	var data = "projectID=${getMap.ProjectID}&parentID=${getMap.ProjectID}&listEditable=N&isNew=N&isProject=Y&screenType=${screenType}";
	ajaxPage(url, data, target);
}

</script>

<div id="htmlReport" style="width:100%; overflow:auto; overflow-x:hidden; padding:0;">
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="admin/savePrjInfo.do" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="pjtMode" name="pjtMode"  value="${pjtMode}" />
	<input type="hidden" id="editBtn" name="editBtn"  value="" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="pjtType" name="pjtType"  value="PJT" />
	
	<c:if test="${pjtMode == 'R' || pjtMode == 'E'}"> 
	<input type="hidden" id="AuthorID" name="AuthorID" value="${getMap.AuthorID}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getMap.OwnerTeamID}" />
	</c:if>
	<c:if test="${pjtMode == 'N'}"> 
	<input type="hidden" id="refID" name="refID"  value="${refID}" />
	<input type="hidden" id="AuthorID" name="AuthorID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${sessionScope.loginInfo.sessionTeamId}" />
	</c:if>
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />

    <table class="tbl_blue01 mgT10" style="width:100%;height:40%;"  border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
			<col>
		</colgroup>
		<tr>
			<!-- 코드 -->
			<th class="alignL pdL5">${menu.LN00015}</th>
			<td class="alignL pdL5">
				${getMap.ProjectCode}
			</td>
			<th class="alignL pdL5">${menu.LN00028}</th>
			<td class="alignL pdL5">
				${getMap.Name}
			</td>
			<!-- 진행상태 -->					
			<th class=" alignL pdL5"> ${menu.LN00065}</th>	
			<td class="alignL pdL5 last ">
				${getMap.StatusName}
			</td>				
		</tr>
		<tr>
			<!-- company  -->
			<th class="alignL pdL5">${menu.LN00014}</th>
			<td class="alignL pdL5">
				${getMap.CompanyName}
			</td>
			<!-- 담당부서 -->
			<th class="alignL pdL5">${menu.LN00018}</th>
			<td class="alignL pdL5">
				${getMap.TeamName}
			</td>
			<!-- 담당자 -->				
			<th class="alignL pdL5">${menu.LN00004}</th>
			<td  class="alignL pdL5 last">
				${getMap.AuthorName}
			</td>		
		</tr>
		<tr>
			<!-- 실행기간 : 시작일 -->
			<th class=" alignL pdL5">${menu.LN00063}</th>
			<td class=" alignL pdL5">
				${getMap.StartDate}
			</td>
			<!-- 실행기간 : 종료 예정일 -->
			<th class="alignL pdL5">${menu.LN00062}</th>
			<td class="alignL pdL5">
				${getMap.DueDate}
			</td>	
			<th class="alignL pdL5">${menu.LN00064}</th>
			<td class="alignL pdL5 last">${getMap.EndDate}</td>	
		</tr>		
		<tr>
			<!-- 개요 -->
			<th class="alignL pdL5">${menu.LN00035}</th>
			<td colspan="5" class="alignL last" >
				<textarea  id="Description" name="Description" style="width:100%;height:150px;" readonly="readonly" >${getMap.Description}</textarea>
			</td>
		</tr>
		
		<!-- [Edit] 버튼 제어 -->
        <tr>
       		<td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9">	
       			<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" onclick="editVariant();" type="submit"></span>
       			<span class="btn_pack medium icon"><span class="add"></span><input value="Member" onclick="searchMember('selectPjtMember.do');" type="submit"></span>
       		</td>          
        </tr>
	</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
	</div>
