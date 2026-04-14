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
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" defer src="${root}cmm/js/xbolt/tinyEditorHelper2.js"></script>


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

<!-- auxiliary controls for interacting with the sample -->
<link rel="stylesheet" href="https://snippet.dhtmlx.com/codebase/assets/css/auxiliary_controls.css">

<style>
.dhx_layout-rows {
	flex: 1 auto;
}
</style>

<script type="text/javascript">
var disabled=false;
var csrInfoData;
var dhxWindow;

function ListToSelectOption(list){
	var options 	= new Array();
	
	var json = new Object();
	
	for(idx in list){
		var json = new Object();
	    json.value = list[idx].CODE;
		json.content = list[idx].NAME,
		
		json = JSON.stringify(json);
		options.push(JSON.parse(json));
	};
	return options;
}

if("${screenMode}" == "V") {
	csrInfoData = [
		{
		  cols: [
		   	  {
		   		rows: [
			  	    {
			              name: "project",
			              type: "input",
			              label: "${menu.LN00131}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.PjtPath}",
			          },
			          {
			              name: "DueDate",
			              type: "input",
			              label: "${menu.LN00221}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.DueDate}",
			          },
			          {
			              name: "csrNo",
			              type: "input",
			              label: "${menu.LN00129}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.ProjectCode}",
			          },
			  	  ]
		   	  },
		   	  {
		   		rows: [
			          {
			              name: "aprvOption",
			              type: "input",
			              label: "${menu.LN00293}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.AprvOptionNM}",
			          },
			          {
			              name: "StartDate",
			              type: "input",
			              label: "${menu.LN00063}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.StartDate}",
			          },
			          {
			              name: "StatusName",
			              type: "input",
			              label: "${menu.LN00027}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.StatusName}",
			          },
			  	  ]
		   	  },
		   	  {
		   		  rows: [
		   			  {
		   				  name: "author",
			              type: "input",
			              label: "${menu.LN00266}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.AuthorName}(${getMap.AuthorTeamName})",
			          },
			          {
			              name: "disclScope",    			              
			              type: "radioGroup",
			              label: "${menu.LN00338}",
			              labelPosition: "left",
			              labelWidth: 100,
                          options: {
                              cols: [
                                  {
                                      type: "radioButton",
                                      text: "All",
                                      value: "0",
                                      checked: true,
                                      autoWidth: true,
                                  },
                                  {
                                      type: "radioButton",
                                      text: "CSR",
                                      value: "1",
                                      autoWidth: true,
                                  }
                              ],
                          },
			          },
			          {
			              name: "EndDate",
			              type: "input",
			              label: "${menu.LN00064}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.EndDate}",
			          },
			      ]
		   	  }
		   	  ]
	  },
	  {
		  name: "ProjectName",
          type: "input",
          label: "${menu.LN00002}",
          labelPosition: "left",
          labelWidth: 100,
          value: "${getMap.ProjectName}",
	  },
	  {
		  name: "Description",
          type: "textarea",
          label: "${menu.LN00290}",
          labelPosition: "left",
          labelWidth: 100,
          value: '${getMap.Description}',
          height: "200px",
	  },
  ];
} else {
	csrInfoData = [
		{
		  cols: [
		   	  {
		   		rows: [
		   			{
		   				name: "ParentPjt",
		   				type: "select",
		   				label: "${menu.LN00131}",
		   				labelPosition: "left",
		   				labelWidth: 100,
		   				value: "${getMap.ParentID}",
						options: ListToSelectOption(${pjtData})
			          },
			          {
			              name: "DueDate",
			              type: "datepicker",
			              label: "${menu.LN00221}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.DueDate}",
			              dateFormat: "%Y-%m-%d",
			          },
			  	  ]
		   	  },
		   	  {
		   		rows: [
			          {
			              name: "aprvOption",
			              type: "input",
			              label: "${menu.LN00293}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.AprvOptionNM}",
			              disabled: true,
			          },
			          {
			              name: "StartDate",
			              type: "datepicker",
			              label: "${menu.LN00063}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.StartDate}",
			              dateFormat: "%Y-%m-%d",
			          },
			  	  ]
		   	  },
		   	  {
		   		  rows: [
		   			  {
		   				  name: "author",
			              type: "input",
			              label: "${menu.LN00266}",
			              labelPosition: "left",
			              labelWidth: 100,
			              value: "${getMap.AuthorName}(${getMap.AuthorTeamName})",
			              disabled: true,
			          },
			          {
			              name: "disclScope",    			              
			              type: "radioGroup",
			              label: "${menu.LN00338}",
			              labelPosition: "left",
			              labelWidth: 100,
                          options: {
                              cols: [
                                  {
                                      type: "radioButton",
                                      text: "All",
                                      value: "0",
                                      checked: true,
                                      autoWidth: true,
                                  },
                                  {
                                      type: "radioButton",
                                      text: "CSR",
                                      value: "1",
                                      autoWidth: true,
                                  }
                              ],
                          },
			          },
			      ]
		   	  }
		   	  ]
	  },
	  {
		  name: "ProjectName",
          type: "input",
          label: "${menu.LN00002}",
          labelPosition: "left",
          labelWidth: 100,
          value: "${getMap.ProjectName}",
	  },
	  {
		  name: "Description",
          type: "tinymce",
          label: "${menu.LN00290}",
          labelPosition: "left",
          labelWidth: 100,
          value: '${getMap.Description}',
          height: "200px",
	  }
  ];
}
	
  
  if("${screenMode}" == "V") disabled = true;
	var form = new dhx.Form("projectInfoFrm", {
	  css: "dhx_widget--bg_white",
	  padding: 20,
	  disabled: disabled,
      align: "between",
      rows : csrInfoData
	});
	
	var useCR = "${useCR}";
	$(document).ready(function(){
		$('#ParentID').val("${getMap.ParentID}");

	});
	
// 	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	// [Save]
	function savePrj() {
		// 명칭 , 사유, 담당자 필수 Check
// 		if ($('#ProjectName').val() == "") {
// 			alert("${WM00086_1}");
// 			return;
// 		}
// 		if ($('#Reason').val() == "") {
// 			alert("${WM00086_3}");
// 			return;
// 		}
// 		if($('#ParentPjt').val() == "" || $('#ParentPjt').val() == null){
// 			alert("${WM00086_4}");
// 			return;
// 		}
				
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
		var disclScope = $('input:radio[name="disclScope"]:checked').val();
		$("#itemAccCtrl").val(disclScope);
		
		if(confirm("${CM00001}")){
			var url = "admin/saveCSRInfo.do?screenMode=${screenMode}&srID=${srID}&fromSR=${fromSR}&screenType=${screenType}&quickCheckOut=${quickCheckOut}&itemID=${itemID}";
			ajaxSubmit(document.projectInfoFrm, url, "saveFrame");
		}
	}
	
	// [after Save]
	function goEdit(pjtId, parentID, fromSR, quickCheckOut, itemID, itemAuthorID) { 
		goChangeInfoEdit(pjtId,parentID,"E",fromSR); 
	}
	
// 	function searchPopup(url){
// 		var param = "?csrId=${ProjectID}&parentId=" + $("#ParentID").val();
// 		window.open(url + param,'window','width=650, height=500, left=300, top=300,scrollbar=yes,resizble=0');
// 	}
	
	// [Edit] click : 변경오더 조회 화면 일때
	function goChangeInfoEdit(avg,parentID,screenMode,fromSR) {
		// login user가 Creator 인경우 : [변경오더 편집] 화면으로 이동
		var projectId = avg;
	   	var url = "csrInfoMgt.do";
		var data = "ProjectID=" + projectId + "&screenMode=" + screenMode 
		+ "&srID=${getMap.SRID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
		+ "&refPjtID=" + parentID + "&screenType=csrDtl&authorID=${getMap.AuthorID}&listEditable=Y&fromSR="+fromSR;
		var target = "csrDiv";
		ajaxPage(url, data, target);
	}
	
// 	// [Approval Request] click : 변경오더 조회 화면 일때
// 	function goSetWfStepInfo() {
// 		var url = "createWFDocCSR.do";
// 		var data = "ProjectID=${ProjectID}&isNew=Y&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
// 				+"&s_itemID=${s_itemID}&screenType=csrDtl&fromSR=${fromSR}&srID=${getMap.SRID}";
// 		var target = "projectInfoFrm";
// 		ajaxPage(url, data, target);
// 	}
	
// 	// [Create CR] 버튼 이벤트
// 	function CreateCR() {		
// 		var url = "addNewCr.do"; // CR 등록 화면
// 		var data = "crMode=CSR&screenType=CSR&srID=${getMap.SRID}"
// 					+ "&CSRID=${getMap.ProjectID}&ProjectID=${s_itemID}"
// 					+ "&isCrEdit=NEW&mainMenu=${mainMenu}";	
// 		var target = "projectInfoFrm";
// 		ajaxPage(url, data, target);	
	
// 	}

// 	// [Menu 아이콘]Click : 변경오더 조회, 편집 화면인 경우
// 	function goMenu(avg) {
		
<%-- 	//	var carUrl = "<%=GlobalVal.CAR_APPROVAL_PATH%>"; --%>
// 		if (avg == "approveInfo" ) {
// 			var url = "wfInstanceList.do";
// 			var data ="projectID=${ProjectID}&screenType=csrDtl&filter=csr";
		
// 		}else if (avg == "changeInfo") {
// 			// 변경항목 목록으로 이동
// 			var url = "changeInfoList.do";
// 			var data = "csrStatus=${getMap.Status}&screenType=CSR&csrID=${ProjectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
// 					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=Y&isMember=${isMember}&closingOption=${getMap.ClosingOption}";
// 		}else if (avg == "issueInfo") {
// 			// Issue 목록으로 이동
// 			var url = "issueSearchList.do";
// 			var data = "ProjectID=${ProjectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
// 					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
// 					+ "&Creator=${getMap.Creator}&ParentID=${getMap.ParentID}&issueMode=PjtMgt&screenType=csrDtl";	
// 		}else if (avg == "getCrMstList") {
// 			var url = "crList.do";
// 			var data = "crMode=CSR&csrID=${ProjectID}&projectID=${s_itemID}&closingOption=${getMap.ClosingOption}";	
// 		}else if (avg == "getViewSR") {
// 			var srID = "${getMap.SRID}";
// 			if(srID == ""){
// 				return;
// 			}else{
// 				var url = "processItsp.do";
// 				var data = "srID=${getMap.SRID}&srType=ITSP&isPop=Y&isPopup=Y";
// 			}
// 		}
		
// 		var target = "tabFrame";
// 		ajaxPage(url, data, target);
// 	}
	
// 	// [프로젝트] : parent 프로젝트 선택시 추가된 담당자 정보를 clear (변경오더 등록인 경우만)
// 	function clearMember() {
// 		if ($('#memberIds').val() != "") {
// 			if(confirm("${CM00051}")){
// 				$('#memberIds').val('');
// 				$('#cngCount').val('');
// 				$('#membersDiv').html('');
// 				$('#ParentID').val($("#ParentPjt").val());
// 			} else {
// 				// 선택 바꾸기전의 프로젝트 값으로 재설정
// 				$("#ParentPjt").val($('#ParentID').val()).attr("selected", "selected");
// 			}
// 		} else {
// 			$('#ParentID').val($("#ParentPjt").val());
// 		}
// 	}
	
// 	// screenType==csrDtl 일때 저장후 callBack 
// 	function fnCallBack(){ 		
// 		parent.opener.fnReload();
// 		parent.self.close();
// 		self.close();
		
// 		/* if("${srID}"==""){
// 			parent.opener.doSearchPjtList();
// 			parent.self.close();
// 		}else {	
// 			parent.self.close();
// 		} */
// 	}
	
// 	// CSR Complet 진행
// 	function fnCompleteCSR(){	
// 		var url = "admin/updateCSRStatus.do";
// 		var data = "csrID=${ProjectID}&status=CLS&srID=${getMap.SRID}&screenType=csrDtl";	
// 		var target = "projectInfoFrm";
// 		ajaxPage(url, data, target);	
// 	}
	
// 	// CSR 취소 
// 	function fnWithdrawCSR(){
// 		if(confirm("${CM00055}")){
// 			var url = "admin/widthdrawCSR.do";
// 			var data = "csrID=${ProjectID}&srID=${getMap.SRID}";	
// 			var target = "saveFrame";
// 			ajaxPage(url, data, target);	
// 		}
// 	}
	
	// 담당자 설정 팝업창 표시
	function searchPopupWf(avg){
// 		var url = avg + "&projectID=${ProjectID}";
// 		window.open(url,'window','width=500, height=400, left=300, top=300,scrollbar=yes,resizble=0');
		ajaxPage("searchPjtMemberPopV4.do","objId=resultID&objName=resultName&projectID=${ProjectID}","windowPop");
		var windowHtml = "<div id='windowPop'></div>";
		dhxWindow = new dhx.Window({
		    width: 550,
		    height: 500,
		    title: "Search user",
		    closable: true,
		    movable: true,
		    modal: true,
		    resizable: true
		});

		dhxWindow.attachHTML(windowHtml);
		dhxWindow.show();
	}
	
	function setSearchMember(authorID){
		var url = "admin/changePjtAuthor.do";
		var data = "csrID=${ProjectID}&authorID="+authorID;	
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}	
	
// 	function fnAddChangeSet(csrID, itemID){
// 		var url = "checkOutItem.do";		
// 		var data = "projectId="+csrID+"&itemIds="+itemID;
// 		var target = "saveFrame";
			
// 		ajaxPage(url, data, target);
// 	}
	
// 	function thisReload(){
// 		parent.opener.fnReload();
// 		parent.self.close();
// 	}
	
// 	function addSchedule(){
// 		var url="registerSchdl.do?";
// 		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&documentID=${ProjectID}&parentID=${getMap.ParentID}&docCategory=CSR&docNO=${getMap.ProjectCode}";
// 		url = url + data;
// 		var w = 880;
// 		var h = 420;
// 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
// 	}
	function fnCallBack(){
		dhxWindow.hide()
		goChangeInfoEdit('${ProjectID}', '${refPjtID}', 'V');
	}
</script>
</head>
<body>
	<div id="csrDiv">
		<div class="title-section bordered-bottom">
			<c:if test="${mainMenu == 1 || mainMenu == 4}">
				<c:if test="${screenMode == 'E'}">
					${menu.LN00181}
				</c:if>
				<c:if test="${screenMode == 'V'}">
					${menu.LN00203}
				</c:if>
			</c:if>
		</div>
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
			<input type="hidden" id="itemAccCtrl" name="itemAccCtrl"  value="" />
		</form>
		<div class="floatR pdR20">
			<c:if test="${isManager == 'Y'}">
		    <c:if test="${screenMode == 'V'}">	   			
		     	 	<c:if test="${getMap.Status == 'CSR' or getMap.Status == 'CNG' or getMap.Status == 'HOLD'}">   
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
				<input value="Change manager" type="button" onclick="searchPopupWf('searchPjtMemberPopV4.do?objId=resultID&objName=resultName')"></span>
			</c:if>
			<c:if test="${screenMode == 'E'}">
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="savePrj()" type="submit"></span> 
	    	</c:if>
    	</div>
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>