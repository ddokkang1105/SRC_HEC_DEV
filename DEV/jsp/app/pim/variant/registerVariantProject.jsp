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
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var p_gridArea;				//그리드 전역변수
$(document).ready(function(){
	$("input.datePicker").each(generateDatePicker);
	var aprvOption = "${getMap.AprvOption}";
	var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('Priority', '&Category=PRT', 'getDicWord', '03', 'Select');

	// 화면별 화면 전체 폭 제어
	if ("${pjtMode}" == "N") {
		$("#screenType").attr('style', 'margin:20px;');
	}
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
		var url = "saveVariantInfo.do"; // 요청이 날라가는 주소
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
	var data = "";
	var isNew = "${isNew}";
	var target = "help_content";
	if ("N" == isNew) {
		data = "projectID=${getMap.ProjectID}&listEditable=N&isNew=${isNew}";
	}
	ajaxPage(url, data, target);
}


// [List] click : 조회 또는 편집 모드
function goProjectList(){
	var url = "variantProjectList.do";
	var data = "screenType=${screenType}&masterProjectID=${parentID}&variantClass=${variantClass}&refPGID=${refPGID}&parentItemID=${parentItemID}&myProject=${myProject}";
	var target = "objectInfoDiv";
	ajaxPage(url, data, target);
}

// [Edit][Back] click
function goMyPjtInfo(avg) {
	var url = "variantProjectList.do";
	var data = "screenType=${screenType}&projectID=${parentID}&variantClass=${variantClass}";
	var target = "objectInfoDiv";
	ajaxPage(url, data, target);
}

function fnAttacthFileHtml(seq, fileName){ 
	display_scripts=$("#tmp_file_items").html();
	display_scripts = display_scripts+
		'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
		'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
		'	<br>'+
		'</div>';		
	document.getElementById("tmp_file_items").innerHTML = display_scripts;		
}

function doAttachFile(){
	var browserType="";
	//if($.browser.msie){browserType="IE";}
	var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
	if(IS_IE11){browserType="IE11";}
	var url="addFilePop.do";
	var data="scrnType=VAR&browserType="+browserType+"&id="+$('#s_itemID').val();
	//fnOpenLayerPopup(url,data,"",400,400);
	if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
	else{openPopup(url+"?"+data,490,360, "Attach File");}
}

function fnDeleteFileHtml(seq){	
	var divId = "divDownFile"+seq;
	$('#'+divId).hide();
	
	//$('#divFileImg').hide();
	
}

// 담당자 설정 팝업창 표시
function searchPopupWf(avg){
	var url = avg + "&projectID=${ProjectID}";
	window.open(url,'window','width=500, height=400, left=300, top=300,scrollbar=yes,resizble=0');
}

function setSearchMember(userID,userName,teamName,teamID){
	$("#AuthorID").val(userID);
	$("#AuthorName").val(userName);
	$("#OwnerTeamID").val(teamID);
	$("#OwnerTeamName").val(teamName);
}	
</script>

<div id="objectInfoDiv" >
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="saveVariantInfo.do" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="pjtMode" name="pjtMode"  value="${pjtMode}" />
	<input type="hidden" id="editBtn" name="editBtn"  value="" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="pjtType" name="pjtType"  value="PJT" />
	<input type="hidden" id="variantPjtType" name="variantPjtType"  value="${variantPjtType}" />
	<input type="hidden" id="parentID" name="parentID"  value="${parentID}" />
	<input type="hidden" id="variantClass" name="variantClass"  value="${variantClass}" />
	<input type="hidden" id="parentItemID" name="parentItemID"  value="${parentItemID}" />
	<input type="hidden" id="refPGID" name="refPGID"  value="${refPGID}" />
	<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />
	<input type="hidden" id="projectCode" name="projectCode"  value="${projectCode}" />
	
	<input type="hidden" id="refID" name="refID"  value="${refID}" />
	<input type="hidden" id="AuthorID" name="AuthorID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="OwnerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}" />
	
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />

<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">
		&nbsp; 프로젝트 등록 
</div>
	     
			<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="10%">
					<col width="23%">
					<col width="10%">
					<col width="23%">
					<col width="10%">
					<col width="23%">
					<col>
				</colgroup>
				<tr>
					<!-- 코드 -->
					<th class="alignL pdL5">${menu.LN00131}</th>
					<td class="alignL pdL5">
						${ProjectPath}
					</td>
					<!-- 담당부서 -->
					<th class="alignL pdL5">${menu.LN00018}</th>
					<td class="alignL pdL5">
						<input type="text" class="text" id="OwnerTeamName" name="OwnerTeamName" value="${sessionScope.loginInfo.sessionTeamName}" readOnly="readonly"/>
					</td>			
					<th class="alignL pdL5 ">${menu.LN00266}</th>
					<td  class="alignL pdL5 last">
						<input type="text" class="text" id="AuthorName" name="AuthorName" value="${sessionScope.loginInfo.sessionUserNm}" onClick="searchPopupWf('searchPjtMemberPop.do?objId=resultID&objName=resultName')" readOnly="readonly"/>
					</td>
				</tr>
				<tr>
					<!-- 실행기간 : 시작일 -->
					<th class="alignL pdL5">${menu.LN00063}</th>
					<td class="alignL pdL5">
						<input type="text" id="StartDate" name="StartDate" value="" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</td>	
					<!-- 실행기간 : 종료 예정일 -->				
					<th class=" alignL pdL5"> ${menu.LN00221}</th>	
					<td class="alignL pdL5">
						<input type="text" id="DueDate" name="DueDate" value="" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</td>		
					<!-- 우선순위 -->	
					<th class=" alignL pdL5">${menu.LN00067}</th>
					<td class=" alignL pdL5 last">
						<select id="Priority" name="Priority" style="width:92%;" ><option value=''>Select</option></select>		
						
					</td>
				</tr>
				<tr>
					<th class="alignL pdL5">${menu.LN00002}</th>
					<td colspan="5" class="alignL last" >
							<input type="text" class="text" id="ProjectName" name="ProjectName" value=""/>
						
					</td>
				</tr>	
				<tr> 
					<!-- 개요 -->
					<th class="alignL pdL5">${menu.LN00035}</th>
					<td colspan="5" class="alignL last" >
						<div style="width:100%;height:200px;">	
							<textarea class="tinymceText" id="Description" name="Description" ></textarea>
						</div>
					</td>
				</tr>
				<!-- 첨부문서 잠시 대기
				<tr>
					<th style="height:53px;">${menu.LN00111}</th>
					<td colspan="5" style="height:53px;" class="alignL pdL5 last">
						<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
							<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
								<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></c:if>
								<br>
							</div>
						</c:forEach>
						</div>
					</td>
				</tr>
				 -->
				<!-- [Edit] 버튼 제어 -->
           	    <tr>
          			<td colspan="6" class="alignR pdR20 last" bgcolor="#f9f9f9">    
						<!--  <span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>&nbsp;&nbsp;-->
              		 	<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="savePrj()" type="submit"></span>	
               		</td>          
             	</tr>
			</table>
	</form>
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
