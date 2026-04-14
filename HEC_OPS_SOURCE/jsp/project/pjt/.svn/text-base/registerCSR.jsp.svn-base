<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_2" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_3" arguments="${menu.LN00201}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" arguments="${menu.LN00082}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00028" var="CM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00131" var="WM00131"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00146" var="WM00146"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00147" var="WM00147"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00051" var="CM00051"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00015" var="CM00015" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_4" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00055" var="CM00055" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />


<script type="text/javascript">
	var useCR = "${useCR}";
	$(document).ready(function(){	
		$("input.datePicker1").each(generateDatePicker);
		
		var priority = "${getMap.Priority}";
		
		
		fnSelect('Reason','&Category=CR','dictionyCode','${getMap.Reason}', 'Select');
		fnSelect('Priority', '&Category=PRT', 'dictionyCode', priority, 'Select');
		fnSelect('AprvOption', "&Category=APRVOPTION", 'getDictionaryOrdStnm', '${getMap.AprvOption}');
	
		
		// 기존의 담당자 화면 표시
		if ('${screenMode}' == 'V' || '${screenMode}' == 'E') {
			var pjtMemberInfos = '${getMap.PjtMemberInfos}';
			$('#memberIds').val('${getMap.PjtMemberIDs}');
			var curMemberArray = $('#memberIds').val().split(', ');
			var memberInfoArray = pjtMemberInfos.split(', ');
			
			for (var i in curMemberArray) {
				var memberId = curMemberArray[i];
				var memberInfo = memberInfoArray[i];
				var display_script = '<a href="#" id=user_'+memberId+' onclick=removeMember('+memberId+')>'+ memberInfo + ', '  + '</a>';
				if ('${screenMode}' == 'V') {
					display_script = '<span id=user_'+memberId+'>'+ memberInfo + ', '  + '</span>';
				}
				$('#membersDiv').append(display_script);
			}
			
			$('#ParentID').val("${getMap.ParentID}");
		} else {
			// 신규등록
			$('#ParentID').val($("#ParentPjt").val());
		}
		// 탭메뉴 로딩
		if('${screenMode}' != 'Y'){
			fnClickedTab('selectPjtMember',1);
		}
	});
	
	// [Save]
	function fnSaveNewCSR() {
		// 명칭 , 사유, 담당자 필수 Check
		if ($('#ProjectName').val() == "") {
			alert("${WM00086_1}");
			return;
		}
		if ($('#Reason').val() == "") {
			alert("${WM00086_3}");
			return;
		}
		if($('#ParentPjt').val() == "" || $('#ParentPjt').val() == null){
			alert("${WM00086_4}");
			return;
		}
				
		var ProjectName = $("#ProjectName").val();
		var projectID = $("#ProjectID").val();
		var StartDate = $("#StartDate").val();
		var DueDate = $("#DueDate").val();
		var Priority = $("#Priority").val();
		var AprvOption = $("#AprvOption").val();
		var Reason = $("#Reason").val();
		var Description = $("#Description").val();
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		var ParentPjt = $("#ParentPjt").val();
	
		if(confirm("${CM00001}")){
			var url = "saveNewCSRInfo.do?srID=${srID}&fromSR=${fromSR}&screenType=${screenType}"
					+"&quickCheckOut=${quickCheckOut}&itemID=${itemID}&speCode=${speCode}&blockSR=${blockSR}&srType=${srType}";
			ajaxSubmit(document.projectInfoFrm, url, "saveFrame");
		}
	}
	
	// [after Save]
	function goEdit(pjtId, parentID, fromSR, quickCheckOut, itemID, itemAuthorID) { 
		if(quickCheckOut == "Y"){
			fnAddChangeSet(pjtId, itemID);
		}else{
			if("${srID}"==""){ parent.opener.doSearchPjtList(); }
			goChangeInfoEdit(pjtId, parentID,"V",fromSR); 
		}
	}
	
	function searchPopup(url){
		var param = "?csrId=${ProjectID}&parentId=" + $("#ParentID").val();
		window.open(url + param,'window','width=650, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [Edit] click : 변경오더 조회 화면 일때
	function goChangeInfoEdit(avg,parentID,screenMode,fromSR) {
		// login user가 Creator 인경우 : [변경오더 편집] 화면으로 이동
		var projectId = avg;
		var listEditable = "N";
		var url = "csrDetail.do";
		var data = "ProjectID=" + projectId 
					+ "&screenMode=" + screenMode 
					+ "&srID=${getMap.SRID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
					+"&s_itemID=" + parentID + "&refPjtID=" + parentID + "&screenType=csrDtl&listEditable="+listEditable
					+"&fromSR="+fromSR;
		var target = "csrDiv";
		ajaxPage(url, data, target);
		window.resizeTo(1200,(window.outerHeight-window.innerHeight)+800);
	}

	
	// [프로젝트] : parent 프로젝트 선택시 추가된 담당자 정보를 clear (변경오더 등록인 경우만)
	function clearMember() {
		if ($('#memberIds').val() != "") {
			if(confirm("${CM00051}")){
				$('#memberIds').val('');
				$('#cngCount').val('');
				$('#membersDiv').html('');
				$('#ParentID').val($("#ParentPjt").val());
			} else {
				// 선택 바꾸기전의 프로젝트 값으로 재설정
				$("#ParentPjt").val($('#ParentID').val()).attr("selected", "selected");
			}
		} else {
			$('#ParentID').val($("#ParentPjt").val());
		}
	}
	
	// screenType==csrDtl 일때 저장후 callBack 
	function fnCallBack(){ 		
		parent.opener.fnReload();
		parent.self.close();			
	}
			
	function setSearchMember(authorID){
		if(confirm("${CM00001}")){
			var url = "changePjtAuthor.do";
			var data = "csrID=${ProjectID}&authorID="+authorID;	
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}	
	
	function fnAddChangeSet(csrID, itemID){
		var url = "checkOutItem.do";		
		var data = "projectId="+csrID+"&itemIds="+itemID;
		var target = "saveFrame";
			
		ajaxPage(url, data, target);
	}
		
	function thisReload(){
		parent.opener.thisReload();
		parent.self.close();
	}
	
	
</script>
</head>
<body>
<div id="csrDiv">
<div id="csrDetailDiv" name="csrDetailDiv" style="padding: 0 6px 6px 6px; height:700px; overflow:scroll;overflow-y;overflow-x:hidden;"> 
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID"  value="${ProjectID}" />
	<input type="hidden" id="ParentID" name="ParentID"  value="" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="ProjectCode" name="ProjectCode" value="${ProjectCode}" />
	<input type="hidden" id="screenMode" name="screenMode" value="${screenMode}"/>
	<input type="hidden" id="btn" name="btn" value="${btn}"/>
	<input type="hidden" id="memberIds" name="memberIds"  value="${memberIds}" />
	<input type="hidden" id="cngCount" name="cngCount"  value="${cngCountOfmember}" />
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00180}</h3>
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:hidden;">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="24%">
				<col width="10%">
				<col width="23%">
				<col width="10%">
				<col width="23%">
			</colgroup>
			<tr>							
				<!-- Project 선택 -->
				<th class=" alignL pdL10 viewline">${menu.LN00131}</th> 
				<td class=" alignL pdL10 " >
					<select id="ParentPjt" name="ParentPjt" style="width:92%" onchange="clearMember();">
						<c:forEach var="i" items="${parentPjtList}">
							<option value="${i.CODE}" <c:if test="${i.CODE == getMap.ParentID}">selected="selected"</c:if>>${i.NAME}</option>
						</c:forEach>
					</select> 
				</td>
					
			    <!-- 담당자 -->
				<th class="alignL pdL10">${menu.LN00266}</th>
			    <td class=" alignL pdL10 ">${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})</td>
			    <!-- 결제옵션  -->
			    <th class=" alignL pdL10">${menu.LN00293}</th>				  
			    <td class=" alignL pdL10 last" >N/A</td>							
			</tr>	
		 	<tr>					
			    <!-- 우선순위 -->
		        <th class="alignL pdL10 viewline">${menu.LN00067}</th>
		        <td class="alignL pdL10 " >    
	    		  	<select id="Priority" name="Priority" style="width:92%;" ><option value=''>Select</option></select>		
			    </td>
			    <!-- 시작일 -->
				<th class="alignL pdL10">${menu.LN00063}</th>
				<td class="alignL pdL10">
					<input type="text" id="StartDate" name="StartDate" value="${thisYmd}" class="text datePicker1" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10"> 
				</td>
				<!-- 예정완료일 -->
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td  class=" alignL pdL10 last">
					<c:if test="${srInfoMap.SRID != null}">	
						<input type="text" id="DueDate" name="DueDate" value="${srInfoMap.DueDate}" class="text datePicker1" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				    </c:if>
					<c:if test="${srInfoMap.SRID == null}">	
						<input type="text" id="DueDate" name="DueDate" value="${dueYmd}" class="text datePicker1" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</c:if>
				</td> 		
			</tr>
			<tr>
				<!-- 제목  -->
				<th class=" alignL pdL10 viewline">${menu.LN00002}</th>
				<td class=" alignL pdL10 last" colspan="5">
					<input type="text" class="text" id="ProjectName" name="ProjectName" value="${srInfoMap.Subject}"  style="ime-mode:active;width:100%;" />
				</td>
			</tr>		
	 		<tr>
		 		<th class="alignL pdL10 viewline">${menu.LN00290}</th>
				<td class="alignL pdL10 last" colspan="5" style="height:120px;" valign="Top"> 
					<textarea class="tinymceText" id="Description" name="Description" style="width:100%;height:160px;">${srInfoMap.Comment}</textarea>
				</td>
			</tr>
	  		<tr>
		    <td class="alignR pdR20 line last" bgcolor="#f9f9f9" colspan="6">
		    	<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveNewCSR()" type="submit"></span> 
	        </td>
		</tr>
  	</table>	
	</div>
	</form></div></div>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>