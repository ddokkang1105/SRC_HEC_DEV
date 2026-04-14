<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--1. Include JSP -->
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="PlanStartDT"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="PlanEndDT"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="M/D"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="Subject"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="ChangeScope"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014_1" arguments="${menu.LN00061}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014_2" arguments="${menu.LN00221}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00064" var="CM00064" arguments="개발진행 승인자" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00065" var="CM00065" arguments="Test" />
<script type="text/javascript">
	var tabNo = "${tabNo}";
	var scrStatus = "${scrInfo.Status}";
	
	$(document).ready(function(){	
		$("input.datePicker1").each(generateDatePicker);
		if(tabNo == null || tabNo == ''){
	 		if(scrStatus == "TSREQ"){
				fnClickedTab(3);
			} else {
				fnClickedTab(1);
			}
		} else {
			fnClickedTab(tabNo);
		}
		if("${screenMode}"=="E") {
			$("#btmContent").css("height","300px");
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srInfo.SRType}";
			fnSelect('scrArea1', data, 'getESMSRArea1', '${scrInfo.SCRArea1}', 'Select', 'esm_SQL');
			fnGetSCRArea2("${scrInfo.SCRArea1}");
		}
	});
	
	function fnGetSCRArea2(SCRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srInfo.SRType}&parentID="+SCRArea1ID;
		fnSelect('scrArea2', data, 'getSrArea2', '${scrInfo.SCRArea2}', 'Select');
	}
	
	function fnClickedTab(avg) { 
		$("#tabFrame").attr('style', 'display: none');
		
		var data = "srID=${srID}&scrID=${scrID}&srType=${srType}";
		
		if(avg == 1){ // 투입인력 
			var url = "scrMbrRoleList.do";
			data = data + "&scrUserID="+"${scrInfo.RegUserID}"+"&scrStatus="+"${scrInfo.Status}";
		}else if(avg == 2){ // 영향도분석
			var url = "viewScrImpAnal.do";
			data = data + "&scrUserID="+"${scrInfo.RegUserID}"+"&scrStatus="+"${scrInfo.Status}";
		}else if(avg == 3){ // 테스트
			var url = "viewScrTestResult.do";
			data = data + "&scrUserID="+"${scrInfo.RegUserID}"+"&scrStatus="+"${scrInfo.Status}"+"&finTestor="+"${scrInfo.FinTestor}";
		}else if(avg == 4){ // 처리내역
			var url = "viewScrProcResult.do";
			data = data + "&scrUserID="+"${scrInfo.RegUserID}"+"&scrStatus="+"${scrInfo.Status}";
		}else if(avg == 5){ // CTS
			var url = "ctrList.do";
			data = data + "";		
		}else if(avg == 6){ // SCR 첨부파일
			var url = "scrFileList.do";
			data = data + "&screenType=csrDtl&finTestor="+"${scrInfo.FinTestor}"+"&scrUserID="+"${scrInfo.RegUserID}"+"&scrStatus="+"${scrInfo.Status}";		
		}
		/*
		else if(avg == 7){ // change set
			var url = "csListBySCR.do";
			data = data + "&csrID=${csrID}&scrRegUser=${scrInfo.RegUserID}";
		}else if(avg == 8){ // 분석설계
			var url = "viewScrAnalysisDesign.do";
			data = data + "&scrUserID=${scrInfo.RegUserID}&scrStatus=${scrInfo.Status}&fltpCode=SCR003";
		}
		*/
		else if(avg == 9){ // 개발
			var url = "viewScrDevelopment.do";
			data = data + "&scrUserID=${scrInfo.RegUserID}&scrStatus=${scrInfo.Status}&fltpCode=SCR001";
		}
		var target = "tabFrame";
		ajaxPage(url, data, target);
		
		var realMenuIndex = "1 2 3 4 5 6 7 8 9 10".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
	
	function fnEditScrDetail(){
	   	var url = "viewScrDetail.do";
		var data = "scrID=${scrID}&screenMode=E&srID=${srID}";
		
		var target = "scrDiv";
		ajaxPage(url, data, target);
	}
	
	function fnSaveSCR() {
		if(confirm("${CM00001}")){
			if(!fnCheckValidation()){return;}
			var url = "updateSCRInfo.do?srID=${srID}&scrID=${scrID}&srType=${srType}&srCategory=${srInfo.Category}";
			
			if( document.all("impAnalYN").checked == true){ $("#impAnalYN").val("Y"); }else{ $("#impAnalYN").val("N"); }
			//if( document.all("cmYN").checked == true){ $("#cmYN").val("Y"); }else{ $("#cmYN").val("N"); }
			if( document.all("urgencyYN").checked == true){ $("#urgencyYN").val("Y"); }else{ $("#urgencyYN").val("N"); }
			if( document.all("finTestYN").checked == true){ $("#finTestYN").val("Y"); }else{ $("#finTestYN").val("N"); }
			if( document.all("CTRYN").checked == true){$("#CTRYN").val("Y"); }else{$("#CTRYN").val("N"); }
			url += "&impAnalYN=" + $("#impAnalYN").val() + "&urgencyYN=" + $("#urgencyYN").val() + "&finTestYN=" + $("#finTestYN").val() + "&CTRYN=" + $("#CTRYN").val();
			
			ajaxSubmit(document.scrFrm, url, "saveFrame");
		}
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var planStartDT = $("#planStartDT").val();
		var planEndDT = $("#planEndDT").val();
		var planManDay = $("#planManDay").val();
		var subject = $("#subject").val();
		
		 $("#planStartDT").val(planStartDT.replaceAll("/","-"));
		 $("#planEndDT").val(planEndDT.replaceAll("/","-"));
		/* var changeScope = $("#changeScope").val();
		if (typeof(tinyMCE) != "undefined"){
			changeScope =  tinyMCE.get('changeScope').getContent();
			$("#changeScope").val(changeScope);
		} */
	
		//if(planStartDT == "" ){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(planEndDT == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(planManDay == ""){ alert("${WM00034_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		//if(changeScope == ""){ alert("${WM00034_5}"); isCheck = false; return isCheck;}
		
		var planStartDT = parseInt(planStartDT.replaceAll("/","").replaceAll("-",""));
		var planEndDT = parseInt(planEndDT.replaceAll("/","").replaceAll("-",""));
		var currDate = parseInt("${thisYmd}");
		
		if(planStartDT != ""){
			if(planStartDT < currDate){
				alert("${WM00014_1}"); isCheck = false; return isCheck;
			} else if(planEndDT < currDate){
				alert("${WM00014_2}"); isCheck = false; return isCheck;
			} else if(planStartDT > planEndDT){
				alert("${WM00132}"); isCheck = false; return isCheck;
			}
		}

		return isCheck;
	}
	
	function fnCallBack(){
	   	var url = "viewScrDetail.do";
		var data = "scrID=${scrID}&screenMode=V&srID=${srID}";
		
		var target = "scrDiv";
		ajaxPage(url, data, target);
	}
	
	function fnCallBackClose(){
		self.close();
	}
	
	function fnViewSRDetail(){		
		var url = "processItsp.do";		
		var data = "srID="+srID; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}

	
	function fnReqApprove(){
		//if(confirm("${scrInfo.ApproverName} ${CM00064}")){
			var url = "wfDocMgt.do";
			//var url = "reqSCRApproval.do";
			
			var data = "actionType=create&srID=${srID}&scrID=${scrID}&srID=${srInfo.SRID}&docSubClass=${srInfo.SRType}&ProjectID=${srInfo.ProjectID}"
				+ "&WFDocURL=${WFDocURL}&wfDocType=SCR&speCode=${srInfo.SRNextStatus}&srRoleTP=${srInfo.ProcRoleTP}"
				+ "&isPop=Y&blockSR=Y" + "${srInfo.SRNextSpePgrVarFilter}";
			
			//var data = "scrID=${scrID}&screenMode=${screenMode}&aprvStatus=1&scrStatus=APREQ&srID=${srID}&speCode=SPE006";		
			var target = "scrDiv";
			ajaxPage(url, data, target);
		//}
	}
	
	function fnHideTable() {
		var tempSrc = $("#fitWindow").attr("src");
		if($("#fitWindow").hasClass("frame_show")) {
			var height = $("#wrapView").height();
			
			$("#wrapView").attr("style","visibility:hidden");
			$("#bottomView").attr("style","position:relative;top:-" + height + "px;");
			$("#scrDiv").scrollTop(0);
			$("#fitWindow").attr("class","frame_hide");
			$("#fitWindow").attr("alt","${WM00159}");
// 			$("#btmContent").css("height","100%");
		}
		else {
			$("#wrapView").attr("style","visibility:visible");
			$("#bottomView").attr("style","position:relative;top:" + height + "px;");
			$("#fitWindow").attr("class","frame_show");
			$("#fitWindow").attr("alt","${WM00158}");
// 			if("${screenMode}" == "V"){
// 				$("#btmContent").css("height","330px");				
// 			} else if ("${screenMode}" == "E"){
// 				$("#btmContent").css("height","300px");
// 			} 
		}
	}
	
	function fnReqTest(){
			var url = "requestTestPop.do";
			var data = "scrID=${scrID}&screenMode=${screenMode}&scrStatus=TSREQ&srID=${srID}&srStatus=SPE008&srRequestUserID=${srInfo.RequestUserID}";		
			var w = 500;
			var h = 300;
			window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
		
	/* 
	WF 로 변경
	function fnApprove(scrStatus,aprvStatus,svcCompl){
		var url = "approveSCRCommentPop.do";
		var data = "scrID=${scrID}&screenMode=${screenMode}&aprvStatus="+aprvStatus
					+"&svcCompl="+svcCompl+"&scrStatus="+scrStatus
					+"&srID=${srID}&srType=${srInfo.SRType}";		
		var w = 500;
		var h = 300;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	} */
	
	function fnCompletionSCR(){		
		if(!confirm("${CM00054}")){ return;}
		
		const SRCMPYN = "${SRCMPYN}";
		let srCmpYN = "";
		
		/*
		if(SRCMPYN == "Y"){
			if(!confirm("해당 SCR의 SR도 완료 처리 하시겠습니까?")){ srCmpYN = "N"; }else{
				srCmpYN = "Y";
			}
		}
		*/
		
		var url = "${srInfo.SRNextSpePgrURL}";
		var data = "scrID=${scrID}&screenMode=${screenMode}&scrStatus=CLS&srID=${srID}&srCmpYN="+srCmpYN+"&srLastCode=${srInfo.LastCode}";		
		var target = "scrDiv";
		ajaxPage(url, data, target);
	}
	
	function fnSCRUpate(){
		var url = "${srInfo.SRNextSpePgrURL}";
		var data = "scrID=${scrID}&screenMode=${screenMode}&srID=${srID}&srType=${srInfo.SRType}&srStatus=${srInfo.Status}" + "${srInfo.SRNextSpePgrVarFilter}";
		var target = "scrDiv";
		ajaxPage(url, data, target);
	}
	
	function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${srID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup+"&srType=${srInfo.SRType}";
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	/* CTS 신규 화면 */
	function registerCTR() {
		var url = "${srInfo.SRNextSpePgrURL}?srID=${srID}&scrID=${scrID}";
	    window.open(url,'ctsNew','width=850, height=615, left=300, top=100,scrollbars=yes,resizable=yes');
	}
	
</script>
</head>
<body>
<div id="scrDiv">
<div style="padding: 0px 5px 0px 5px;height:100%;overflow-x:hidden;overflow-y:auto;"> 
<form name="scrFrm" id="scrFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="screenMode" name="screenMode" value="${screenMode}"/>
	
	<div class="cop_hdtitle pdB10">
		<span class="floatL" ><h3 class="floatL" style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${title}</h3>
		</span>
		<span class="floatR mgT10 mgB5 mgR20" >
			<c:if test="${screenMode eq 'V' && scrInfo.Status eq 'EDT' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >
				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditScrDetail();"></span>
			</c:if>   
			<c:if test="${screenMode eq 'E'}" >
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveSCR()" type="submit"></span>
			</c:if>
			<c:if test="${srInfo.SRNextSpePgrID eq 'PGR00003' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId && scrInfo.AprvStatus eq ''}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Request Approval" type="submit" onclick="fnReqApprove();"></span>
			</c:if>
			<c:if test="${srInfo.SRNextSpePgrID eq 'PGR00008' && ((scrInfo.Status eq 'APREL' && scrInfo.FinTestYN ne 'Y')|| scrInfo.Status eq 'TSCMP' || scrInfo.Status eq 'CTR') && ctrCLSYN eq 'Y' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}">
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletionSCR();"></span>
			</c:if>
			<c:if test="${scrInfo.FinTestYN eq 'Y' && scrInfo.Status eq 'APREL' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId && srInfo.SRNextSpePgrID eq 'PGR00006'}" >
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Request Test" type="submit" onclick="fnReqTest();"></span>
			</c:if>
			<!-- CTR 생성 (SCR당 하나만 생성) -->
			<c:if test="${srInfo.SRNextSpePgrID eq 'PGR00010' && ctrYN ne 'Y' && scrInfo.Status ne 'EDT' && scrInfo.Status ne 'APRV' && scrInfo.Status ne 'APRJT' }">
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Register CTR" type="submit" onclick="registerCTR();"></span>
			</c:if>
			<!-- 임시 생성 -->
			<c:if test="${srInfo.SRNextSpePgrID eq 'PGR00009' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Next" type="submit" onclick="fnSCRUpate();"></span>
			</c:if>
		</span>
	</div><br><br>
	
	<div style="border-top:1px solid #ccc;">	
	<div id="wrapView" class="wrapView floatC" style="width:100%;">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
			</colgroup>
			<tr>						
				<th class="alignL pdL10 viewline">SR ${menu.LN00025}</th> 
				<td class="alignL pdL10">${srInfo.ReqUserNM}(${srInfo.ReqTeamNM})</td>
				
				<th class="alignL pdL10">${srInfo.SRArea1NM}</th>	
				<td class="alignL pdL10">
					<c:if test="${screenMode eq 'V'}">${scrInfo.SCRArea1Name}</c:if>
					<c:if test="${screenMode eq 'E'}">  
						<select id="scrArea1" Name="scrArea1" OnChange="fnGetSCRArea2(this.value);" style="width:140px"></select>
					</c:if>		
				</td>
			    
			    <th class="alignL pdL10">${srInfo.SRArea2NM}</th>	
				<td class="alignL pdL10">
					<c:if test="${screenMode eq 'V'}">${scrInfo.SCRArea2Name}</c:if>
					<c:if test="${screenMode eq 'E'}">  
						<select id="scrArea2" Name="scrArea2" style="width:140px"></select>
					</c:if>
				</td>
			    
			    <th class="alignL pdL10">SR No.</th>				  
			    <td class="alignL pdL10 last">
			    	<span OnClick="fnSRDetail();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${srInfo.SRCode}</span>
			    </td>							
			</tr>
			<tr>						
				<th class="alignL pdL10 viewline">${menu.LN00004}</th> 
				<td class="alignL pdL10">${scrInfo.RegTeamUserName}</td>
				
				<th class="alignL pdL10">${menu.LN00061}</th> 
				<td class="alignL pdL10">
					<c:if test="${screenMode eq 'V'}">${scrInfo.PlanStartDT}</c:if>
					<c:if test="${screenMode eq 'E'}">  					
						<input type="text" id="planStartDT" name="planStartDT" value="${scrInfo.PlanStartDT}" class="text datePicker1" style="width:80%;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					</c:if>
				</td>
				<th class="alignL pdL10">${menu.LN00221}</th>
			    <td class="alignL pdL10">
			    	<c:if test="${screenMode eq 'V'}">${scrInfo.PlanEndDT}</c:if>
					<c:if test="${screenMode eq 'E'}">  					
						<input type="text" id="planEndDT" name="planEndDT" value="${scrInfo.PlanEndDT}" class="text datePicker1" style="width:80%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</c:if>
				</td>	
				
				<th class="alignL pdL10">M/D</th> 
				<td class="alignL pdL10 last" >
					<c:if test="${screenMode eq 'V'}">${scrInfo.PlanManDay}</c:if>
			    	<c:if test="${screenMode eq 'E'}">  	
			    		<input type="text" class="text" id="planManDay" name="planManDay" value="${scrInfo.PlanManDay}"  style="ime-mode:active;width:100%;" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			    	</c:if>
				</td>			
			</tr>
			
			<tr>						
			   <th class="alignL pdL10 viewline">진행승인자</th>				  
			   <td  class="alignL pdL10">${scrInfo.ApproverName}</td>
				
				<th class="alignL pdL10">SCR ${menu.LN00027}</th> 
				<td  class="alignL pdL10">${scrInfo.StatusName}</td>
				
				<th class="alignL pdL10">${menu.LN00095}</th> 
				<td class="alignL pdL10">${scrInfo.AprvDT}</td>
			
			    <th class="alignL pdL10">${menu.LN00064}</th> 
				<td class="alignL pdL10 last" >${scrInfo.ActualEndDT}</td>			
				
					
			</tr>	
			<tr>
				<th class="alignL pdL10 viewline">${menu.LN00042}</th>									  
			    <td class="alignL pdL10" colspan="5">
			    	긴급 &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="urgencyYN" name="urgencyYN" value="${scrInfo.UrgencyYN}" <c:if test="${scrInfo.UrgencyYN == 'Y'}">checked</c:if> <c:if test="${screenMode eq 'V'}">disabled=true</c:if> /> </span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	영향도분석 &nbsp;&nbsp;<input type="checkbox" id="impAnalYN" name="impAnalYN" value="${scrInfo.ImpAnalYN}" <c:if test="${scrInfo.ImpAnalYN == 'Y'}">checked</c:if> <c:if test="${screenMode eq 'V'}">disabled=true</c:if> />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<%-- 형상관리 &nbsp;&nbsp;<input type="checkbox" id="cmYN" name="cmYN" value="${scrInfo.CMYN}" <c:if test="${scrInfo.CMYN == 'Y'}">checked</c:if> <c:if test="${screenMode eq 'V'}">disabled=true</c:if> /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --%>
			    	<%-- 현업 테스트 &nbsp;&nbsp;<input type="checkbox" id="finTestYN" name="finTestYN" disabled=true value="${scrInfo.FinTestYN}" <c:if test="${scrInfo.FinTestYN == 'Y'}">checked</c:if> /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --%>
			    	<%-- 운영이관 &nbsp;&nbsp;<input type="checkbox" id="CTRYN" name="CTRYN" value="${scrInfo.CTRYN}" <c:if test="${scrInfo.CTRYN == 'Y'}">checked</c:if> disabled=true/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --%>
			    </td>	
			<th class="alignL pdL10">SCR No.</th>	
			<td class="alignL pdL10 last">${scrInfo.SCRCode}</td>					
			</tr>
			<tr>
				<!-- 제목  -->
				<th class="alignL pdL10 viewline">${menu.LN00002}</th>
				<td class="alignL pdL10 last" colspan="7">
					<c:if test="${screenMode eq 'V'}">${scrInfo.Subject}</c:if>
					<c:if test="${screenMode eq 'E'}">
						<input type="text" class="text" id="subject" name="subject" value="${scrInfo.Subject}"  style="ime-mode:active;width:100%;" />
					</c:if>					
				</td>	
			
			</tr>
			<tr>
		 		<th class="alignL pdL10 viewline">${menu.LN00290}</th>
				<td class="alignL last pdL10" colspan="7" style="height:80px;" valign="Top"> 
					<c:if test="${screenMode eq 'V'}">${scrInfo.ChangeScope}</c:if>
					<c:if test="${screenMode eq 'E'}">
						<div style="width:100%;height:70px;">
						<textarea class="tinymceText" id="changeScope" name="changeScope" >${scrInfo.ChangeScope}</textarea>
						</div>
					</c:if>
				</td>
			</tr>		
	 		<tr>
		 		<th class="alignL pdL10 viewline">업무할당</th>
				<td class="alignL last pdL10" colspan="7" style="height:50px;" valign="Top"> 
					<c:if test="${screenMode eq 'V'}">
					<textarea style="width:100%;height:50px;background: #fff;" disabled>${scrInfo.JobDescription}</textarea>
					</c:if>
					<c:if test="${screenMode eq 'E'}">
						<textarea class="edit" id="jobDescription" name="jobDescription" style="width:100%;height:50px;">${scrInfo.JobDescription}</textarea>
					</c:if>
				</td>
			</tr>			
			<tr>
		 		<th class="alignL pdL10 viewline">이슈사항</th>
				<td class="alignL last pdL10" colspan="7" style="height:50px;" valign="Top"> 
					<c:if test="${screenMode eq 'V'}">
					<textarea style="width:100%;height:50px;background: #fff;" disabled>${scrInfo.SCRIssue}</textarea>
					</c:if>
					<c:if test="${screenMode eq 'E'}">
						<textarea class="edit" id="scrIssue" name="scrIssue" style="width:100%;height:50px;">${scrInfo.SCRIssue}</textarea>
					</c:if>
				</td>
			</tr>
  		</table> 
  		</div>   
		<div id="bottomView">
	  		<div class="subtabs">
				<ul>
					<li id="pliugt1" class="on"><a href="javascript:fnClickedTab('1');"><span>투입인력</span></a></li> 					
						<c:if test="${scrInfo.ImpAnalYN eq 'Y'}"  >
							<li id="pliugt2"><a href="javascript:fnClickedTab('2');"><span>영향도분석</span></a></li>
						</c:if>
					<c:if test="${scrInfo.Status ne 'EDT' && scrInfo.Status ne 'APRV' && scrInfo.Status ne 'APRJT' }"  >						
						<li id="pliugt4"><a href="javascript:fnClickedTab('4');"><span>처리내역</span></a></li>	
					</c:if>
					<c:if test="${scrInfo.FinTestYN == 'Y'}">
						<li id="pliugt3"><a href="javascript:fnClickedTab('3');"><span>테스트</span></a></li>
					</c:if>
					<c:if test="${scrInfo.Status ne 'EDT' && scrInfo.Status ne 'APRV' && scrInfo.Status ne 'APRJT' }"  >
						<c:if test="${ctrYN eq 'Y'}"  >		
							<li id="pliugt5"><a href="javascript:fnClickedTab('5');"><span>CTS</span></a></li> 
						</c:if>
						<li id="pliugt6"><a href="javascript:fnClickedTab('6');"><span>${menu.LN00019}</span></a></li>
					</c:if>
					<!-- 
						<li id="pliugt7"><a href="javascript:fnClickedTab('7');"><span>Change Set</span></a></li>
						<li id="pliugt8"><a href="javascript:fnClickedTab('8');"><span>분석설계</span></a></li>
					 -->
					<li id="pliugt9"><a href="javascript:fnClickedTab('9');"><span>개발</span></a></li>
				</ul>
				<div class="instance_top_btn mgR2" style="padding-bottom:2px;" ><a id="fitWindow" class="frame_show" onclick="fnHideTable()"><img src="${root}${HTML_IMG_DIR}/icon_fitwindow.png" /></a></div>
			</div>
			<div id="btmContent" style="width:100%;overflow: auto;">
				<div id="tabFrame" style="width:100%;"></div>	
			</div>
		</div>	
	</div>
	</form>		
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>