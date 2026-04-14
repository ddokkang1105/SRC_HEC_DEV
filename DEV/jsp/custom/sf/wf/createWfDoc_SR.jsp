<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${backMessage}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00036" var="WM00036" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Approval path info."/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Approval path"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00154" var="WM00154" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00154" var="WM00155" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_1" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007_2" arguments="${menu.LN00290}"/>

<script type="text/javascript">
	$(document).ready(function(){		

		$("input.datePicker").each(generateDatePicker);
		var aprvOption = "${getMap.AprvOption}";
		
		fnSetAprvOption(aprvOption);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfDocType=${wfDocType}";
		var wfAllocListCNT = "${wfAllocListCNT}";
		$("#resultRefName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultRefName','resultRefName');
				return false;
			}			
		});	

		if("${pathFlg}" == "Y") {			
			$("#wfList").html("${wfStepInfo}");
			$("#createPath").attr("style","display:none");
// 			$("#pathTD").attr("rowspan","2");
			
			fnGetWFStepPath();
		}
		
	});

	function fnGetWFStepPath(){ 

		$("#wfStepInfo").val("${wfStepInfo}");
		$("#wfStepMemberIDs").val("${memberIDs}");
		$("#wfStepRoleTypes").val("${roleTypes}");
	}	

	// [dimValue option] 설정
	function changeDimValue(GRID){
		var url    = "getAprvGroupList.do"; // 요청이 날라가는 주소
		var data   = "GRID="+GRID+"&GRType=MGT"; //파라미터들
		var target = "wfMGT";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		//setTimeout(appendDimOption,1000);
	}
	
	
	function fnGetWFStep(wfID){
		if(wfID == ""){ alert("${WM00041}");return; }
		wfID = wfID.split("(SPLIT)");
		
		$("#wfDescription").html(wfID[2]);
		
		if(wfID[3] != "NULL" && wfID[3] != "0") {
			changeDimValue(wfID[3]);			
			//$("#grDIV").attr("style","");
		}
		
	}
	
	function fnSetWFStepInfo(wfStepInfo,memberIDs,roleTypes,agrCnt,agrYN){
		$("#wfStepInfo").val(wfStepInfo);
		$("#wfStepMemberIDs").val(memberIDs);
		$("#wfStepRoleTypes").val(roleTypes);
		$("#agrCnt").val(agrCnt);
		$("#agrYN").val(agrYN);
	}
	
	function fnSetWFStepInfo2(wfStepRefIDs,wfStepRefInfo,wfStepRecIDs,wfStepRecInfo,wfStepRecTeamIDs){
		$("#wfStepRefMemberIDs").val(wfStepRefIDs);
		$("#wfStepRefInfo").val(wfStepRefInfo);
		$("#wfStepRecMemberIDs").val(wfStepRecIDs);
		$("#wfStepRecInfo").val(wfStepRecInfo);
		$("#wfStepRecTeamIDs").val(wfStepRecTeamIDs);
	}
	
	function fnCreateWF(flg){
		
		//	$("#wfDescription").html(wfID[2]);
			if(flg == "C") { 
						
				var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&wfID=WF001&agrYN=N&flg="+flg;
				var w = 900;
				var h = 700;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
			
			}
			else {
				var url = "selectWFMemberPop.do?projectID=${ProjectID}&createWF=1&flg="+flg;
				var w = 900;
				var h = 700;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
			}
		}
	
	function fnSetAprvOption(aprvOption){
		$('#aprvOption').val(aprvOption);
	}
	
	
	// 임시저장
	function fnSaveWfInstInfo(){		
		if(confirm("${CM00001}")){			
			var wfStepMemberIDs = $("#wfStepMemberIDs").val();
			if(wfStepMemberIDs == ""){alert("${WM00034}"); return;}
			var url = "saveWFInstInfo.do";
			ajaxSubmit(document.wfInstInfoFrm, url);
		}
	}
	
	// 저장 전 check
	function fnAfterCheck(){		
	
		var agrYN = $("#agrYN").val();
		var agrCnt = $("#agrCnt").val();
		if(agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}
// 		var wfID = $("#wfID").val();
// 		if(wfID == ""){ alert("${WM00041}");return; }
// 		wfID = wfID.split("(SPLIT)");
	

		var temp = tinyMCE.get('description').getContent();
		if(temp == "") {alert("${WM00007_2}"); return;}
		
		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == ""){alert("${WM00034}"); return;}
		var wfStepRoleTypes = $("#wfStepRoleTypes").val();
		var wfStepRefMemberIDs = $("#wfStepRefMemberIDs").val();
		var url = "afterSubmitCheck.do?wfStepMemberIDs="+wfStepMemberIDs+"&wfStepRoleTypes="+wfStepRoleTypes+"&wfStepRefMemberIDs="+wfStepRefMemberIDs;
		var w = 400;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
	}
	
	
	// Submit 상신
	function fnSubmitWfInstInfo(){				
		var wfStepMemberIDs = $("#wfStepMemberIDs").val();
		if(wfStepMemberIDs == "" || wfStepMemberIDs == undefined){alert("${WM00034}"); return;}
		var agrYN = $("#agrYN").val();
		var agrCnt = $("#agrCnt").val();
		if(agrYN == "Y" && agrCnt < 1){alert("${WM00155}"); return;}
		
		var wfID = $("#wfID").val();
		if(wfID == "" || wfStepMemberIDs == undefined){ alert("${WM00041}");return; }
		wfID = wfID.split("(SPLIT)");
		wfID = wfID[0];
		$("#wfID").val(wfID);
		var url = "submitOLMWfInst.do";
		ajaxSubmit(document.wfInstInfoFrm, url);
		
	}
	
	// [Previous]
	function goPrevious() {		 
		 if(confirm("${CM00029}")){
			var screenType = "${screenType}";
			var url = "${backFunction}";
			var callbackData = "${callbackData}";
			var data = "screenMode=V&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}"+callbackData;
			var target = setTarget("${wfDocType}");			

			ajaxPage(url, data, target);
		} 
	}
		
	function fnCallBack(){
		goSetWfStepInfo();
	}
	
	function fnNoSubmitCallBack(grName){
		msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00153' var='WM00153' arguments='"+ grName +"'/>";
		alert("${WM00153}");
	}
	
	// Submit CallBack
	function fnCallBackSubmit() {	
		opener.fnCallBackSR();
		self.close();
	}
	
	function searchPopupWf(avg,type){		
		var url = avg + "&searchValue=" + encodeURIComponent($('#'+type).val()) + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}

	function setTarget(docType) {
		if(docType == "CSR" || docType == "PJT"){ return "projectInfoFrm"; }
		else if(docType == "CS"){ return  "changeInfoViewFrm"; }
		else if(docType == "SR"){ return  "receiptSRFrm"; }
		else { return "help_content"; }
	}
	
	function setSearchNameWf(memberID, memberName, teamName, teamID, objId, objName, teamPath, wfStepID, wfStepTxt){ 
	
		$('#' + objName).val(memberName);		

		var wfStepMemberIDsTemp = "";
		var wfStepInfoTemp = "";
		var nameTemp = "";
				
		if(objName == "resultAgrName") 
			nameTemp = "Agr";
		else if(objName == "resultRefName")
			nameTemp = "Ref";
		
		wfStepMemberIDsTemp = $("#wfStep"+nameTemp+"MemberIDs").val();
		wfStepInfoTemp = $("#wfStep"+nameTemp+"Info").val();
		
		if(wfStepMemberIDsTemp != ""){
			wfStepMemberIDsTemp = wfStepMemberIDsTemp +","+memberID;
			wfStepInfoTemp = wfStepInfoTemp +","+ memberName+"("+teamName+")";
		}else{
			wfStepMemberIDsTemp = memberID;
			wfStepInfoTemp = memberName+"("+teamName+")";
		}
		
		$("#wfStep"+nameTemp+"Info").val(wfStepInfoTemp);
		$("#wfStep"+nameTemp+"MemberIDs").val(wfStepMemberIDsTemp);
	}	
	
	function fnDeleteRefInfo(){
		if(confirm("${CM00002}")){
			$("#wfStepRefMemberIDs").val("");
			$("#wfStepRefInfo").val("");
			$("#resultRefName").val("");
		}
	}
	
	function fnDeleteAgrInfo(){
		if(confirm("${CM00002}")){
			$("#wfStepAgrMemberIDs").val("");
			$("#wfStepAgrInfo").val("");
			$("#resultAgrName").val("");
		}
	} 
	

	// 유저 검색 text clear
	function schResultAgrClear() {
		$('#resultAgrName').val("");
	}
	

	// 유저 검색 text clear
	function schResultRefClear() {
		$('#resultRefName').val("");
	}
	

	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function goCSRDetail(){
		var projectID = "${ProjectID}";
		
		var isNew ="R";
		var mainMenu = "${mainMenu}";
		var s_itemID = "${s_itemID}";
		var url = "csrDetailPop.do?ProjectID=" + projectID + "&isNew=" + isNew + "&mainMenu=" + mainMenu + "&s_itemID="+s_itemID;	
		
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function goWFListCheck(){
		var projectID = "${ProjectID}";
		var wfDocumentIDs = "${wfDocumentIDs}";
		
		var wfDocType = $("#wfDocType").val();
		
		if(wfDocType == "CS") 
			projectID = wfDocumentIDs;
		
		var url = "getWFApprovalCheckList.do?documentIDs=" + projectID + "&wfDocType=" + wfDocType;	
		
		var w = 1200;
		var h = 400;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	
</script>

<style>
.btn_pack.nobg a.add {
	width: 17px;
	height: 17px;
	background-position: -96px -155px;
}

</style>

</head>
<body>
<div id="wfStepInfoDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
<form name="wfInstInfoFrm" id="wfInstInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="projectID" name="projectID"  value="${ProjectID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="wfID2" name="wfID2" />
	<input type="hidden" id="isNew" name="isNew" value="${isNew}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>
	<input type="hidden" id="aprvOption" name="aprvOption" />
	<input type="hidden" id="srID" name="srID" value="${srID}"/>
	<input type="hidden" id="Status" name="Status" value="${getPJTMap.Status}"/>
	<input type="hidden" id="createWF" name="createWF" value=""/>
	<input type="hidden" id="wfDocType" name="wfDocType" value="${wfDocType}"/>
	<input type="hidden" id="wfStepMemberIDs" name="wfStepMemberIDs" value="${wfStepMemberIDs}"/>
	<input type="hidden" id="wfStepRoleTypes" name="wfStepRoleTypes" value="${wfStepRoleTypes}"/>
	<input type="hidden" id="wfStepRefMemberIDs" name="wfStepRefMemberIDs" value="" />
	<input type="hidden" id="wfStepRecTeamIDs" name="wfStepRecTeamIDs" value="" />
	<input type="hidden" id="wfStepAgrMemberIDs" name="wfStepAgrMemberIDs" value="${wfStepAgrMemberIDs}" />
	<input type="hidden" id="wfDocumentIDs" name="wfDocumentIDs" value="${wfDocumentIDs}" />
	<input type="hidden" id="isMulti" name="isMulti" value="${isMulti}" />
	<input type="hidden" id="agrYN" name="agrYN" value="${agrYN }" />
	<input type="hidden" id="agrCnt" name="agrCnt" value="${agrCnt }" />
	<input type="hidden" id="blockSR" name="blockSR" value="${blockSR}"/>
	<input type="hidden" id="wfID" name="wfID" value="${wfID eq null ? defWFID : wfID }">
	<input type="hidden" id="speCode" name="speCode" value="${speCode eq null ? getPJTMap.SRNextStatus : speCode }"/>
	<input type="hidden" id="procRoleTP" name="procRoleTP" value="${procRoleTP eq null ? getPJTMap.ProcRoleTP : procRoleTP }"/>
	
	<input type="hidden" id="docSubClass" name="docSubClass" value="${docSubClass}">
	<c:choose>
		<c:when test="${wfDocType eq 'SCR'}">
			<input type="hidden" id="documentID" name="documentID" value="${scrInfo.SCRID}"/>
			<input type="hidden" id="documentNo" name="documentNo" value="${scrInfo.SCRCode}">
		</c:when>
		<c:otherwise>
			<input type="hidden" id="documentID" name="documentID" value="${srID}"/>
			<input type="hidden" id="documentNo" name="documentNo" value="${getPJTMap.SRCode}">
			<input type="hidden" id="esType" name="esType" value="${getPJTMap.ESType}">
		</c:otherwise>
	</c:choose>

	<!-- 화면 타이틀 : 결재경로 생성-->	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<ul>
			<li>
				<h3 style="padding: 6px 0 6px 0">
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00211}
				</h3>
			</li>
	        <li class="floatR mgT5">  
	        	<c:if test="${isPop != 'Y' }">
					<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goPrevious()" type="button"></span>      
				</c:if>  
					
				<!-- <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveWfInstInfo()" type="button"></span> -->
				<span class="btn_pack medium icon"><span class="save"></span><input value="Submit" onclick="fnAfterCheck()" type="button"></span> 
			</li> 
		</ul>	
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
		<table class="tbl_blue01" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="88%">						
			</colgroup>
			<tr>
				<!-- 결재선 생성 -->
				<th class="viewline alignL pdL10">${menu.LN00140}&nbsp;&nbsp;&nbsp;<span class="btn_pack nobg" style="float:right;padding-right:25px;" id="createPath"><a class="add"onclick="fnCreateWF('C');" title="Add"></a></span></th>
				<td class="alignL pdL10 last" >
					<input type="text" id="wfStepInfo" name="wfStepInfo" value="" style="border:0px;width:100%;"  >
				</td>		
			</tr>			
			<tr id="grDIV" style="display:none;">
				<!-- 주관조직 담당자 -->
				<th class="alignL pdL10" >${menu.LN00045}</th>
				<td class="alignL last">					
				 	<select id="wfMGT" name="wfMGT" style="width:40%;"></select>
				 </td>
			</tr>
			<!-- 
			<tr>
				<th class="viewline alignL pdL10">${menu.LN00245}<span class="btn_pack nobg" style="float:right;padding-right:30px;"><a class="add"onclick="fnCreateWF('R');" title="Add"></a></span></th>
				<td class="last alignL" >
					<input type="text" id="wfStepRefInfo" name="wfStepRefInfo" value="${srRequestUserInfo}" style="width:55%;border:0px;" readOnly>
				</td>
			</tr>
			 -->		
		</table>
	
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="22%">
			</colgroup>
			<tr>
				<!-- SR 코드 -->
				<th class="viewline alignL pdL10">
					Document No.
				</th>
				<td class="alignL pdL10 ">
					${getPJTMap.SRCode}
				</td>
				<!-- 문서유형 -->
				<th class="alignL pdL10">${menu.LN00091}</th>
				<td class="alignL pdL10 ">${getPJTMap.SRTypeName}</td>				
				<!-- 담당자 -->
				<th class="alignL pdL10">${menu.LN00004}</th>
				<td class="alignL pdL10 last">
					${getPJTMap.ReceiptName}(${getPJTMap.ReceiptTeamName})
				</td>
			</tr>	
			 <tr>		
		 		<!-- Project -->
				<th class="viewline alignL pdL10">System</th> 
				<td class=" alignL pdL10" >${getPJTMap.SRArea1Name}/${getPJTMap.SRArea2Name}</td>
			
				<th class="alignL pdL10">${menu.LN00222}</th>
				<td class="alignL pdL10">${getPJTMap.ReqDueDate}</td>
			
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="alignL pdL10 last">${getPJTMap.DueDate}</td>
			</tr>
			
			<!-- SCR 내용 -->
			<c:set var="subject" value="[${wfName}] ${getPJTMap.Subject}" />
			<c:if test="${wfDocType eq 'SCR'}">
				<c:set var="subject" value="[${wfName}] ${scrInfo.Subject}" />
				<!-- SCR 코드 -->
				<th class="viewline alignL pdL10">
					SCR No.
				</th>
				<td class="alignL pdL10 ">
					${scrInfo.SCRCode}
				</td>
				<!-- 제목 -->
				<th class="alignL pdL10">SCR ${menu.LN00002}</th>
				<td class="alignL pdL10 ">${scrInfo.Subject}</td>				
				<!-- 요청자 -->
				<th class="alignL pdL10">${menu.LN00004}</th>
				<td class="alignL pdL10 last">
					${scrInfo.RegTeamUserName}
				</td>
			</c:if>
			
			
			<tr>
				<!-- 제목  -->
				<th class="viewline alignL pdL10">${menu.LN00002}</th>
				<td class="alignL pdL10 last"  colspan = 5 >
					<input type="text" class="text" id="subject" name="subject" value='<c:out value="${subject}" />' style="ime-mode:active;" >
				</td>				
			</tr>	
		 	<tr>
				<th class="viewline alignL pdL10">${menu.LN00290}</th>
			 	<td class="alignL pdL10 last" colspan="5" style="width:100%;height:350px;">
			 		<div style="width:100%;height:350px">		
						<textarea class="tinymceText" id="description" name="description" >${getPJTMap.Comment}</textarea>	
					</div>
				</td>
			</tr>
	</table>
	</div>	
	</form>	
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
</body>
</html>