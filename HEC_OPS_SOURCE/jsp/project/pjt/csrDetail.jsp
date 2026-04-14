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


<script type="text/javascript">
	var useCR = "${useCR}";
	$(document).ready(function(){	
		$("input.datePicker1").each(generateDatePicker);
		

		// 초기 표시 화면 크기 조정 
		$("#csrDetailDiv").attr("style","padding: 0 6px 6px 6px; overflow:scroll;overflow-y;overflow-x:hidden;height:"+(setWindowHeight() - 10)+"px;");
	
		
		var priority = "${getMap.Priority}";
		
		
		fnSelect('Reason','&Category=CR','dictionyCode','${getMap.Reason}', 'Select');
		fnSelect('Priority', '&Category=PRT', 'dictionyCode', priority, 'Select');
		fnSelect('AprvOption', "&Category=APRVOPTION", 'getDictionaryOrdStnm', '${getMap.AprvOption}');
		$('#ParentID').val("${getMap.ParentID}");
		
		// 탭메뉴 로딩
		fnClickedTab('selectPjtMember',1);
	});
	
	function changeWindowHeight() {
		$("#csrDetailDiv").attr("style","padding: 0 6px 6px 6px; overflow:scroll;overflow-y;overflow-x:hidden;height:"+(setWindowHeight() - 10)+"px;");
	}

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	// [Save]
	function savePrj() {
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
			var url = "saveCSRInfo.do?screenMode=${screenMode}&srID=${srID}&fromSR=${fromSR}&screenType=${screenType}&quickCheckOut=${quickCheckOut}&itemID=${itemID}";
			ajaxSubmit(document.projectInfoFrm, url, "saveFrame");
		}
	}
	
	// [after Save]
	function goEdit(pjtId, parentID, fromSR, quickCheckOut, itemID, itemAuthorID) { 
		goChangeInfoEdit(pjtId,parentID,"E",fromSR); 
	}
	
	function searchPopup(url){
		var param = "?csrId=${ProjectID}&parentId=" + $("#ParentID").val();
		window.open(url + param,'window','width=650, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [Edit] click : 변경오더 조회 화면 일때
	function goChangeInfoEdit(avg,parentID,screenMode,fromSR) {
		// login user가 Creator 인경우 : [변경오더 편집] 화면으로 이동
		var projectId = avg;
	   	var url = "csrDetail.do";
		var data = "ProjectID=" + projectId + "&screenMode=" + screenMode 
		+ "&srID=${getMap.SRID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
		+ "&refPjtID=" + parentID + "&screenType=csrDtl&authorID=${getMap.AuthorID}&listEditable=Y&fromSR="+fromSR;
		var target = "csrDiv";
		ajaxPage(url, data, target);
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goSetWfStepInfo() {
		var url = "createWFDocCSR.do";
		var data = "ProjectID=${ProjectID}&isNew=Y&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
				+"&s_itemID=${s_itemID}&screenType=csrDtl&fromSR=${fromSR}&srID=${getMap.SRID}";
		var target = "projectInfoFrm";
		ajaxPage(url, data, target);
	}
	
	// [Create CR] 버튼 이벤트
	function CreateCR() {		
		var url = "addNewCr.do"; // CR 등록 화면
		var data = "crMode=CSR&screenType=CSR&srID=${getMap.SRID}"
					+ "&CSRID=${getMap.ProjectID}&ProjectID=${s_itemID}"
					+ "&isCrEdit=NEW&mainMenu=${mainMenu}";	
		var target = "projectInfoFrm";
		ajaxPage(url, data, target);	
	
	}
	
	function fnClickedTab(avg, avg2) { 
		$("#fileFrame").attr('style', 'display: none');
		$("#tabFrame").attr('style', 'display: none');
		var csrEditable = "${csrEditable}";
		var listEditable = "";
		if(csrEditable == "Y"){ listEditable="Y"; }
		
		if(avg2 == 7){
			goMenu('getViewSR');
		}else if(avg2 == 3){
			goMenu('changeInfo');	
		}else if(avg2 == 4){
			goMenu('issueInfo');			
		}else if(avg2 == 5){
			goMenu('approveInfo');		
		}else if(avg2 == 6){
			goMenu('getCrMstList');	
		}else if(avg2 == 1){
			var screenMode = "${screenMode}"; 		
			var url = avg + ".do";
			var data = "projectId=${ProjectID}&screenMode="+screenMode+"&listEditable="+listEditable+"&screenType=csrDtl&parentID=${refPjtID}&authorID=${getMap.AuthorID}";
			var target="tabFrame";
			
			ajaxPage(url, data, target);			
		}else{
			var screenMode = "${screenMode}"; 
			var url = avg + ".do";
			var data = "projectId=${ProjectID}&DocCategory=PJT&screenType=csrDtl&isPublic=N&screenMode="+screenMode+"&csrEditable="+csrEditable+"&isMember=${isMember}";
			var target="tabFrame";
			
			ajaxPage(url, data, target);
		}
	
		var realMenuIndex = "1 2 3 4 5 6 7".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg2) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
	

	// [Menu 아이콘]Click : 변경오더 조회, 편집 화면인 경우
	function goMenu(avg) {
		
	//	var carUrl = "<%=GlobalVal.CAR_APPROVAL_PATH%>";
		if (avg == "approveInfo" ) {
			var url = "wfInstanceList.do";
			var data ="projectID=${ProjectID}&screenType=csrDtl&filter=csr";
		
		}else if (avg == "changeInfo") {
			// 변경항목 목록으로 이동
			var url = "changeInfoList.do";
			var data = "csrStatus=${getMap.Status}&screenType=CSR&csrID=${ProjectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=Y&isMember=${isMember}&closingOption=${getMap.ClosingOption}";
		}else if (avg == "issueInfo") {
			// Issue 목록으로 이동
			var url = "issueSearchList.do";
			var data = "ProjectID=${ProjectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
					+ "&Creator=${getMap.Creator}&ParentID=${getMap.ParentID}&issueMode=PjtMgt&screenType=csrDtl";	
		}else if (avg == "getCrMstList") {
			var url = "crList.do";
			var data = "crMode=CSR&csrID=${ProjectID}&projectID=${s_itemID}&closingOption=${getMap.ClosingOption}";	
		}else if (avg == "getViewSR") {
			var srID = "${getMap.SRID}";
			if(srID == ""){
				return;
			}else{
				var url = "processItsp.do";
				var data = "srID=${getMap.SRID}&srType=ITSP&isPop=Y&isPopup=Y";
			}
		}
		
		var target = "tabFrame";
		ajaxPage(url, data, target);
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
		self.close();
		
		/* if("${srID}"==""){
			parent.opener.doSearchPjtList();
			parent.self.close();
		}else {	
			parent.self.close();
		} */
	}
	
	// CSR Complet 진행
	function fnCompleteCSR(){	
		var url = "updateCSRStatus.do";
		var data = "csrID=${ProjectID}&status=CLS&srID=${getMap.SRID}&screenType=csrDtl";	
		var target = "projectInfoFrm";
		ajaxPage(url, data, target);	
	}
	
	// CSR 취소 
	function fnWithdrawCSR(){
		if(confirm("${CM00055}")){
			var url = "widthdrawCSR.do";
			var data = "csrID=${ProjectID}&srID=${getMap.SRID}";	
			var target = "saveFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	// 담당자 설정 팝업창 표시
	function searchPopupWf(avg){
		var url = avg + "&projectId=${ProjectID}";
		window.open(url,'window','width=500, height=400, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchMember(authorID){
		var url = "changePjtAuthor.do";
		var data = "csrID=${ProjectID}&authorID="+authorID;	
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}	
	
	function fnAddChangeSet(csrID, itemID){
		var url = "checkOutItem.do";		
		var data = "projectId="+csrID+"&itemIds="+itemID;
		var target = "saveFrame";
			
		ajaxPage(url, data, target);
	}
	
	function thisReload(){
		parent.opener.fnReload();
		parent.self.close();
	}
	
	function addSchedule(){
		var url="registerSchdl.do?";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&documentID=${ProjectID}&parentID=${getMap.ParentID}&docCategory=CSR&docNO=${getMap.ProjectCode}";
		url = url + data;
		var w = 880;
		var h = 420;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	function fnCallBack(){
		self.close();
	}
</script>
</head>
<body>
<div id="csrDiv">
<div id="csrDetailDiv" name="csrDetailDiv" style="padding: 0 6px 6px 6px; height:790px; overflow:scroll;overflow-y;overflow-x:hidden;"> 
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
	
	<!-- 화면 타이틀(변경 오더) : N - 편집, Y - 등록, R - 조회 -->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
			<c:if test="${mainMenu == 1 || mainMenu == 4}">
				<c:if test="${screenMode == 'E'}"> 
					${menu.LN00181}   
				</c:if>
				<c:if test="${screenMode == 'V'}">
					${menu.LN00203}    
				</c:if>
			</c:if>		
		</h3>
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
					<c:if test="${screenMode == 'E'}">
						<select id="ParentPjt" name="ParentPjt" style="width:92%" onchange="clearMember();">
							<c:forEach var="i" items="${parentPjtList}">
								<option value="${i.CODE}" <c:if test="${i.CODE == getMap.ParentID}">selected="selected"</c:if>>${i.NAME}</option>
							</c:forEach>
						</select> 
					</c:if>
					<c:if test="${screenMode == 'V'}">  
						${getMap.PjtPath}
					</c:if>
				</td>
					
			   <!-- 담당자 -->
				<th class="alignL pdL10">${menu.LN00266}</th>
				<td class=" alignL pdL10 last">${getMap.AuthorName}(${getMap.AuthorTeamName})</td>
				 
			   <!-- 결제옵션  -->
			   <th class=" alignL pdL10">${menu.LN00293}</th>				  
			   <td class=" alignL pdL10 last" > ${getMap.AprvOptionNM}</td>							
			</tr>	
		 	<tr>					
			   <!-- 우선순위 -->
		       <th class="alignL pdL10 viewline">${menu.LN00067}</th>
		       <td class="alignL pdL10 " > 
			       <c:if test="${screenMode == 'E'}">    
	    			   	<select id="Priority" name="Priority" style="width:92%;" ><option value=''>Select</option></select>		
			       </c:if>
			       <c:if test="${screenMode == 'V'}">${getMap.PriorityName}</c:if>
			   </td>
			   <!-- 시작일 -->
				<th class="alignL pdL10">${menu.LN00063}</th>
				<td class="alignL pdL10">
					<c:if test="${screenMode == 'E'}"> 
						<input type="text" id="StartDate" name="StartDate" value="${getMap.StartDate}" class="text datePicker1" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					</c:if>					
					<c:if test="${screenMode == 'V'}">${getMap.StartDate}
					</c:if>
				</td>
				<!-- 예정완료일 -->
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td  class=" alignL pdL10 last">
					<c:if test="${screenMode == 'E'}"> 
						<input type="text" id="DueDate" name="DueDate" value="${getMap.DueDate}" class="text datePicker1" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</c:if>
					<c:if test="${screenMode == 'V'}">${getMap.DueDate}
					</c:if>
				</td> 		
			</tr>
		<c:if test="${screenMode == 'V'}"> 
			<tr>
				<!-- CSR Code -->
				<th class="alignL pdL10 viewline ">CSR No.</th>
				<td class="alignL pdL10 ">${getMap.ProjectCode}</td>					
				<!-- 상태  -->
				<th class="alignL pdL10">${menu.LN00027}</th>
				<td class="alignL pdL10 ">${getMap.StatusName}</td>	
				<!-- 완료일 -->
				<th class="alignL pdL10 ">${menu.LN00064}</th> 		
				<td class="alignL pdL10 last">${getMap.EndDate}</td>
									
			</tr>
		</c:if>
		<tr>
			<!-- 제목  -->
				<th class=" alignL pdL10 viewline">${menu.LN00002}</th>
				<td class=" alignL pdL10 last" colspan="5">
					<c:if test="${screenMode == 'E'}">
						<input type="text" class="text" id="ProjectName" name="ProjectName" value="${getMap.ProjectName}"  style="ime-mode:active;width:98%;" />
					</c:if>
					<c:if test="${screenMode == 'V'}">${getMap.ProjectName}</c:if>
				</td>
		</tr>		
	 	<tr>
		 <th class="alignL pdL10 viewline">${menu.LN00290}</th>
			<td class="alignL pdL10 last" colspan="5" style="height:120px;" valign="Top"> 
				<c:if test="${screenMode == 'E'}"> 
					<textarea class="tinymceText"  id="Description" name="Description" style="width:100%;height:160px;outline:none;">${getMap.Description}</textarea>
				</c:if>
				<c:if test="${screenMode == 'V'}"> 
				${getMap.Description}
				</c:if>
			</td>
		</tr>
	  	<tr>
		    <td class="alignR pdR20 last line" bgcolor="#f9f9f9" colspan="6">
		    <c:if test="${isManager == 'Y'}">
			    <c:if test="${screenMode == 'V'}">	   			
			     	 	<c:if test="${getMap.Status == 'CSR' or getMap.Status == 'CNG' or getMap.Status == 'HOLD'}">
			     			&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="Register Schedule" type="submit"  onclick="addSchedule();" style="cursor:hand;"></span>   
			     			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goChangeInfoEdit('${ProjectID}', '${refPjtID}', 'E');"></span>   
			     	  	</c:if>    		
	        	</c:if> 
	        	<!-- 변경제안 결재 요청-->
	        	<c:if test="${getMap.Status == 'CSR' && (getMap.AprvOption == 'PRE' or getMap.AprvOption =='PRENPOST')}">
	        		 &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goSetWfStepInfo();"></span>
	        	</c:if>
	        	<!-- CS 전체 변경완료 후 CSR 결재요청 -->
	        	<c:if test="${ ((getMap.Status == 'CNG' || getMap.Status == 'HOLD') && (getMap.AprvOption == 'POST' or getMap.AprvOption =='PRENPOST') && getMap.ChangeStatus == 'Y') && getMap.ClosingOption == '04'}">
	        	      &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goSetWfStepInfo();"></span>        
			    </c:if>
		        <c:if test="${getMap.Status == 'CNG' && getMap.SRID != null && useCR == 'Y'}">
			       	&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="Create CR" type="submit" onclick="CreateCR();"></span>
			    </c:if>	
			    <c:if test="${(getMap.Status == 'CNG' || getMap.Status == 'QA') && (getMap.ClosingOption != '04' && getMap.ChangeStatus ne 'N')}"> 
			       	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompleteCSR();"></span>
			    </c:if> 
			    
				 <c:if test="${getMap.ChangeStatus == 'N/A' && (getMap.Status == 'CSR'or getMap.Status == 'CNG' or getMap.Status == 'HOLD') }"> 
			      &nbsp;<span id="btnDel" class="btn_pack small icon"><span class="del"></span><input value="Withdraw" type="submit" onclick="fnWithdrawCSR()"></span>        		
	            </c:if>
	       </c:if> 
	        <c:if test="${(getMap.Status == 'CSR' or  getMap.Status =='CNG' or getMap.Status == 'HOLD') && refPjtAuthorID == sessionScope.loginInfo.sessionUserId && screenMode == 'V'}">
	            &nbsp;<span id="viewSave" class="btn_pack medium icon"><span class="gov"></span>
					<input value="Change manager" type="button" onclick="searchPopupWf('searchPjtMemberPop.do?objId=resultID&objName=resultName')"></span>
			</c:if>
            <c:if test="${screenMode == 'E'}">        
			      &nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="savePrj()" type="submit"></span> 
		    </c:if>
	          
	        </td>
		</tr>
  	</table>	
		
      	<div class="subtabs">
			<ul>
				<c:if test="${getMap.SRID != null}" >
				<li id="pliugt7"><a href="javascript:fnClickedTab('getVeiwSR','7');"><span>${menu.LN00286}</span></a></li> 
				</c:if>
				<li id="pliugt1"  class="on"><a href="javascript:fnClickedTab('selectPjtMember','1');"><span>${menu.LN00288}</span></a></li> 
				<li id="pliugt2"><a href="javascript:fnClickedTab('documentGridList','2');"><span>${menu.LN00111}</span></a></li>
				<li id="pliugt3"><a href="javascript:fnClickedTab('cngSet','3');"><span>${menu.LN00082}</span></a></li>
				<li id="pliugt4" style="display:none;"><a href="javascript:fnClickedTab('issus','4');"><span>Issue</span></a></li>
         		<!-- 변경승인 내역 -->
         		<c:if test="${getMap.CurWFInstanceID ne '' && getMap.Status ne 'CSR' && getMap.Status ne 'WTR'}">
					<li id="pliugt5"><a href="javascript:fnClickedTab('approveInfo','5');"><span>${menu.LN00135}</span></a></li>
				</c:if>
				<c:if test="${CRCNT != '0'}">
				<li id="pliugt6"><a href="javascript:fnClickedTab('getCrMstList','6');"><span>${menu.LN00276}</span></a></li> 
				</c:if>				
			</ul>
		</div>
		<div id="tabFrame" style="width:1000px;overflow:auto;"></div>	
	</div>
	</form></div></div>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>