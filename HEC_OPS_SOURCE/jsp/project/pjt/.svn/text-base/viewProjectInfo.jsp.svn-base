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
	$("#screenType").attr('style', 'margin:20px;');
	
});

//===============================================================================
	
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
		var url = "savePrjInfo.do"; // 요청이 날라가는 주소
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

function searchTaskType(url){
	var data = "projectId=${getMap.ProjectID}&listEditable=N";
	var target = "objectInfoDiv";
	ajaxPage(url, data, target);
}


// [List] click : 조회 또는 편집 모드
function goProjectList(){
	var url = "myProjectList.do";
	var data = "screenType=${screenType}&projectID=${refID}";
	var target = "objectInfoDiv";
	ajaxPage(url, data, target);
}

// [Edit][Back] click
function goMyPjtInfo(avg) {
	var url = "editProjectInfo.do";
	var target = "objectInfoDiv";
	var data = "pjtMode=" + avg + "&screenType=${screenType}&s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&refID=${refID}&isNew=N";
	ajaxPage(url, data, target);
}

// [Member] click
function searchMember(url){
	var data = "";
	var isNew = "${isNew}";
	var target = "objectInfoDiv";
	if ("N" == isNew) {
		data = "projectId=${getMap.ProjectID}&listEditable=Y&isNew=N&screenType=${screenType}&authorID=${getMap.AuthorID}";
	}
	ajaxPage(url, data, target); 
}

function addSchedule(){
	var url="registerSchdl.do?";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=Y&documentID=${getMap.ProjectID}&parentID=${getMap.ProjectID}&docCategory=PJT&docNO=${getMap.ProjectCode}";
	url = url + data;
	var w = 880;
	var h = 420;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}
function fnCallBack(){
	self.close();
}
</script>

<div id="objectInfoDiv" >
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="savePrjInfo.do" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="pjtMode" name="pjtMode"  value="${pjtMode}" />
	<input type="hidden" id="editBtn" name="editBtn"  value="" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="pjtType" name="pjtType"  value="PJT" />
	<input type="hidden" id="AuthorID" name="AuthorID" value="${getMap.AuthorID}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getMap.OwnerTeamID}" />	
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">
		&nbsp;${menu.LN00249}
	</div>
	     
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col width="13%">				
			</colgroup>
			<tr>
				<!-- 코드 -->
				<th class="alignL pdL5 viewline">${menu.LN00015}</th>
				<td class="alignL pdL5"">
						${getMap.ProjectCode}
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
				<th class="alignL pdL5 viewline">${menu.LN00018}</th>
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
						${getMap.StatusName}
				</td>	
			</tr>
			<tr>
				<!-- 실행기간 : 시작일 -->
				<th class=" alignL pdL5 viewline">${menu.LN00063}</th>
				<td class=" alignL pdL5">
						${getMap.StartDate}
				</td>
				<!-- 실행기간 : 종료 예정일 -->
				<th class="alignL pdL5">${menu.LN00062}</th>
				<td class="alignL pdL5">
						${getMap.DueDate}
				</td>	
				<th class="alignL pdL5">${menu.LN00064}</th>
				<td class="alignL pdL5 last">${getMap.EndDate}	</td>	
			</tr>
			<tr><!-- 명칭  -->
				<th class="alignL pdL5 viewline">${menu.LN00028}</th>
				<td colspan="5" class="alignL last" >
						${getMap.ProjectName}
				</td>
			</tr>	
			<tr>
				<!-- 개요 -->
				<th class="alignL pdL5 viewline">${menu.LN00035}</th>
				<td colspan="5" class="alignL last" >
						<textarea  id="Description" name="Description" style="width:100%;height:200px;" readonly="readonly" >${getMap.Description}</textarea>
				</td>
			</tr>
			
			<!-- [실행 버튼 제어 ] screenType = pjtTemplate 화면 or Not -->
          	    <tr>
         			<td colspan="6" class="alignR pdR20 last line" bgcolor="#f9f9f9">
         				<c:if test="${screenType != 'PJT' }">  
         				  <span class="btn_pack medium icon"><span class="list"></span><input value="List" onclick="goProjectList()" type="submit"></span>
           				</c:if>
           				 <span class="btn_pack medium icon"><span class="add"></span><input value="Worker" onclick="searchMember('selectPjtMember.do');" type="submit"></span>  
	   	           		 <c:if test="${getMap.Status != 'CLS' && sessionScope.loginInfo.sessionUserId == getMap.AuthorID}">	
								<span class="btn_pack medium icon"><span class="add"></span><input value="Task Type" onclick="searchTaskType('selectPjtTaskType.do');" type="submit"></span> 			
		     	 				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goMyPjtInfo('E');"></span> 
		     	 				<span class="btn_pack medium icon"><span class="add"></span><input value="Register Schedule" type="submit"  onclick="addSchedule();" style="cursor:hand;"></span>
		     	 		 </c:if>  			
              		</td>          
            	</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
