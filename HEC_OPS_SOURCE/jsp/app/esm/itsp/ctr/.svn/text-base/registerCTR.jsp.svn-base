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
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="CTS NO." />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00164" var="WM00164" arguments="CTS NO." />


<script type="text/javascript">
var status = "";
var curWorkerID = "";
var ctrCodeCheckFlag ="F";
var ctrCodeCheckedvalue ="";

$(document).ready(function(){		

	$("#urgency").click(function(){
        var chk = $(this).is(":checked");//.attr('checked');
        if(chk){
        	$("#urgencyYN").val("Y");
        	$("#ifStatus").val("1");
        }else{
        	$("#urgencyYN").val("N");
        	$("#ifStatus").val("0");
        }
    });	
	/*
	$("#reviewerName").keypress(function (e) {
		if (e.which == 13){
	         $("#searchREWRequestBtn").click();
		}
	});
	$("#approverName").keypress(function (e) {
		if (e.which == 13){
	         $("#searchAPRVRequestBtn").click();
		}
	});
	$("#CTUserNM").keypress(function (e) {
		if (e.which == 13){
	         $("#searchEXERequestBtn").click();
		}
	});
	*/
//	$("input:text").keydown(function(evt) { if (evt.keyCode == 13) return false; });

	document.getElementById('editArea').style.height = (setWindowHeight() - 45);
});

function setWindowHeight(){
	var size = window.innerHeight;
	var height = 0;
	if( size == null || size == undefined){
		height = document.body.clientHeight;
	}else{
		height=window.innerHeight;
	}
	
	return height;
}

function fnSavectr(){
	if( $("#urgency").is(":checked")){ $("#urgencyYN").val("Y"); }else{ $("#urgencyYN").val("N"); }
	//var aprvStatus = $('input[name="aprvStatus"]:checked').val();
	var aprvStatus = $('#aprvStatus').val();
	
	if(ctrCodeValidCheck("save")){
		if ($('#reviewerName').val() == "") {
			alert("검토자를 지정하여 주십시오.");
			$('#reviewerName').focus();
			return false;
		}
		
		if ($('#approverName').val() == "") {
			alert("승인자를 지정하여 주십시오.");
			$('#approverName').focus();
			return false;
		}
		
		if ($('#CTUserNM').val() == "") {
			alert("실행자를 지정하여 주십시오.");
			$('#CTUserNM').focus();
			return false;
		}
		
		if ($('#reviewerID').val() == "") {
			alert("검토자를 지정하여 주십시오.");
			$('#reviewerName').focus();
			return false;
		}
		
		if ($('#approverID').val() == "") {
			alert("승인자를 지정하여 주십시오.");
			$('#reviewerName').focus();
			return false;
		}
		
		if ($('#CTUserID').val() == "") {
			alert("실행자를 지정하여 주십시오.");
			$('#reviewerName').focus();
			return false;
		}
		
		if ($('#subject').val() == "") {
			alert("제목을 입력하여 주십시오.");
			$('#subject').focus();
			return false;
		}
		
		if ($('#Description').val() == "") {
			alert("설명을 입력하여 주십시오.");
			$('#Description').focus();
			return false;
		}		
		
		status = "CTSREQ";
		if($("#urgencyYN").val() == "N"){
			curWorkerID = $("#reviewerID").val();	
		}else{
			curWorkerID = $("#CTUserID").val();
		}
		
		$("#status").val(status);	
		$("#curWorkerID").val(curWorkerID);
		
		if(confirm("${CM00001}")){
			var url = "createCTRMst.do";	
			ajaxSubmit(document.ctrFrm, url);
		}
	}
}

function returnSavectr(){
	opener.doSearchctrList();
	self.close();
}

function searchPopupWf(avg,target){	
	memberType = target;
	var searchValue = $("#"+memberType).val();
	var url = avg + "&searchValue=" + encodeURIComponent(searchValue) 
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	window.open(url,'new_window1','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
}
function setSearchNameWf(avg1,avg2,avg3,avg4){

	if(memberType == "reviewerName"){			
		$("#reviewerName").val(avg2+"("+avg3+")");
		$("#reviewerID").val(avg1);
		$("#reviewerTeamID").val(avg4);
    } else if(memberType == "approverName"){
		$("#approverName").val(avg2+"("+avg3+")");
		$("#approverID").val(avg1);
		$("#approverTeamID").val(avg4);
    } else if(memberType == "CTUserNM"){
		$("#CTUserNM").val(avg2+"("+avg3+")");
		$("#CTUserID").val(avg1);
		$("#opApTeamID").val(avg4);
    }
}

function fnCheckRequest(target){
	var checkObj = document.all(target);	
	if(target == 'selfRew'){
		if( checkObj.checked == true){ 
			$("#searchREWRequestBtn").attr('style', 'display: none');
			$("#reviewerID").val($("#REWID").val());
			$("#reviewerName").val($("#REWName").val());
			$("#reviewerName").attr("readonly",true);
		} else {
			$("#searchREWRequestBtn").attr('style', 'display: done');
			$("#reviewerID").val("");
			$("#reviewerName").val("");
			$("#reviewerName").attr("readonly",false);
		}	
	}else if(target == 'selfAprv'){
		if( checkObj.checked == true){ 
			$("#searchAPRVRequestBtn").attr('style', 'display: none');
			$("#approverID").val($("#APRVID").val());
			$("#approverName").val($("#APRVName").val());
			$("#approverName").attr("readonly",true);
		} else {
			$("#searchAPRVRequestBtn").attr('style', 'display: done');
			$("#approverID").val("");
			$("#approverName").val("");
			$("#approverName").attr("readonly",false);
		}	
	}else if(target == 'selfExe'){
		if( checkObj.checked == true){ 
			$("#searchEXERequestBtn").attr('style', 'display: none');
			$("#CTUserID").val($("#EXEID").val());
			$("#CTUserNM").val($("#EXEName").val());
			$("#CTUserNM").attr("readonly",true);
		} else {
			$("#searchEXERequestBtn").attr('style', 'display: done');
			$("#CTUserID").val("");
			$("#CTUserNM").val("");
			$("#CTUserNM").attr("readonly",false);
		}	
	}
	
	
}

function ctrCodeValidCheck(action){
	var ctrCode =  $("#ctrCode").val();
	if (ctrCode == "") {
		alert("CTS No.를 입력하여 주십시오.");
		$('#ctrCode').focus();
		return false;
	}

	 if(/[^a-zA-Z0-9]/gi.test(ctrCode))
     {
		alert('CTS No.는 영문과 숫자만 가능합니다.');
		return false;
     }
	 if(action =="save"){
		 if(ctrCodeCheckFlag =="F"){
			alert('CTS No. 중복 확인을 해주세요.');
			$('#ctrCode').focus();
			return false;
		 }else if(ctrCodeCheckFlag =="T"){
			if(ctrCodeCheckedvalue != ctrCode){
				alert("CTS No. 중복 확인을 다시 해주세요.");
				ctrCodeCheckFlag = "F";
				return false;
			}
		 }
	 }
	 return true;
}

function fnCTRCodeCheck(){
	if(ctrCodeValidCheck("")){
		var ctrCode =  $("#ctrCode").val();
		var url = "ctrCodeCheck.do";
		var data = "&ctrCode="+ctrCode;
		var target = "saveFrame";	
		ajaxPage(url,data,target);
	}
}

function returnCTRCodeCheck(returnValue){
	var ctrCode =  $("#ctrCode").val();
	if(returnValue =="N"){
		alert("${WM00116}");
		$("#ctrCode").val('');
		ctrCodeCheckFlag ="F";
	}else{
		alert("${WM00164}");
		ctrCodeCheckFlag ="T";
	}
	ctrCodeCheckedvalue = ctrCode;
}
</script>
</head>
<body style="width: 100%; height: 100%; margin: 0; padding: 0; overflow: auto;">
<div id="ctrDiv" style="padding: 0 10px 0 10px">
	<form name="ctrFrm" id="ctrFrm" method="post" enctype="multipart/form-data" action="#" onsubmit="return false;">	
		<input type="hidden" id="loginUserId" name="loginUserId" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="srID" name="srID" value="${srID}" />
		<input type="hidden" id="scrID" name="scrID" value="${scrID}" />
		<input type="hidden" id="status" name="status" value="" />
		<input type="hidden" id="curWorkerID" name="curWorkerID" value="" />
		<input type="hidden" id="speCode" name="speCode" value="SPE011" />
		
		<div class="cop_hdtitle pdB10">
			<span class="floatR mgT10 mgB5 mgR10" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="javascript:fnSavectr()"></span>
			</span>
		</div>
	<br>
		<div id="editArea" style="width: 100%; margin-bottom: 5px;">	
			<div id="objectInfoDiv" class="hidden floatC">
				
				<input type="hidden" id="sysArea1" name="sysArea1" value="${sysArea1}" />
				<input type="hidden" id="sysArea2" name="sysArea2" value="${sysArea2}" />
				<input type="hidden" id="ifStatus" name="ifStatus" value="0">
				<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
					<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;CTS 요청</h3>
				</div>
				<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="11%">
						<col width="26%">
						<col width="8%">
						<col width="11%">
						<col width="8%">
						<col width="11%">
					</colgroup>
					<tr>
						<th class="alignL pdL10 viewline">CTS No.</th>
						<td class="alignL pdL5">
							<input type="text" id="ctrCode" name="ctrCode" value="" class="text" style="width:70%;ime-mode:active;" maxlength="100">
							<span class="btn_pack medium icon"><span class="confirm"></span><input id="ctrCodeCheck" value="Check" type="submit" onclick="javascript:fnCTRCodeCheck()"></span>
						</td>
						<th class="alignL pdL10">요청자</th>
						<td class="alignL pdL5">
							<input type="hidden" id="regUserID" name="regUserID" value="${sessionScope.loginInfo.sessionUserId}"/>
							<input type="hidden" id="regTeamID" name="regTeamID" value="${sessionScope.loginInfo.sessionTeamID}"/>
							<input type="hidden" class="text"  id="regUserName" name="regUserName" readonly="readonly" value="${sessionScope.loginInfo.sessionUserNm}" style="ime-mode:active;"/>
							${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})
						</td>
						<th class="alignL pdL10">요청일자 </th>
						<td class="alignL pdL5 last">
							<font>${thisYmd}</font>
						</td>
					</tr>
					<tr>
						<!-- 제목 -->
						<th class="alignL pdL10 viewline">제목 </th>
						<td colspan="3" class="alignL pdL5">
							<input type="text" id="subject" name="subject" value="${ctrData.subject}" class="text" style="width:80%;ime-mode:active;" maxlength="100">
						</td>
						<th class="alignL pdL10">긴급 여부 </th>
						<td class="alignL pdL5 last">
							<input type="checkbox" id="urgency" name="urgency">
							<input type="hidden" id="urgencyYN" name="urgencyYN" value="N">
							
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10">설명</th>
						<td colspan="5" class="alignL pdL5 last"><textarea class="edit"  id="Description" name="Description" style="width:100%;height:80px;">${ctrData.Description}</textarea></td>
					</tr>
				</table>
				<br>

				<div class="floatL msg" style="width:100%;">&nbsp;CTS 담당자 정보</div>
				<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="14%">
						<col width="86%">
					</colgroup>
					<tr>
						<th class="alignL pdL10 viewline">검토자(&nbsp;지정 : <input type="checkbox" id="selfRew" OnClick="fnCheckRequest('selfRew')" checked>&nbsp;)</th>
						<td class="alignL pdL5 last">
							<input type="hidden" id="REWID" value="${REW.memberID}" />
							<input type="hidden" class="text"  id="REWName" value="${REW.memberTName}"/>
							<input type="hidden" class="text"  id="REWTeamID" value="${REW.teamID}"/>
								
							<input type="hidden" id="reviewerID" name="reviewerID" value="${REW.memberID}" />
							<input type="hidden" id="reviewerTeamID" name="reviewerTeamID" value="${REW.teamID}" />
							<input type="text" class="text"  id="reviewerName" name="reviewerName" value="${REW.memberTName}" style="ime-mode:active; width:80%;" readonly/>
							<%-- <input type="image" class="image" id="searchREWRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="fnOpenSearchPopup('searchNamePop.do','reviewerName')" value="검색"> --%>
							<input type="image" class="image" id="searchREWRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL','reviewerName')" value="검색">
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">승인자(&nbsp;지정 : <input type="checkbox" id="selfAprv" OnClick="fnCheckRequest('selfAprv')" checked>&nbsp;)</th>
						<td class="alignL pdL5 last">
							<input type="hidden" id="APRVID" value="${APRV.memberID}" />
							<input type="hidden" class="text"  id="APRVName" value="${APRV.memberTName}"/>
							<input type="hidden" class="text"  id="APRVTeamID" value="${APRV.teamID}"/>
							
							<input type="hidden" id="approverID" name="approverID" value="${APRV.memberID}" />
							<input type="hidden" id="approverTeamID" name="approverTeamID" value="${APRV.teamID}" />
							<input type="text" class="text"  id="approverName" name="approverName" value="${APRV.memberTName}" style="ime-mode:active; width:80%;" readonly/>
							<%-- <input type="image" class="image" id="searchAPRVRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="fnOpenSearchPopup('searchNamePop.do','approverName')" value="검색"> --%>
							<input type="image" class="image" id="searchAPRVRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL','approverName')" value="검색">
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">실행자(&nbsp;지정 : <input type="checkbox" id="selfExe" OnClick="fnCheckRequest('selfExe')" checked>&nbsp;)</th>
						<td class="alignL pdL5 last">
							<input type="hidden" id="EXEID" value="${EXE.memberID}" />
							<input type="hidden" class="text"  id="EXEName" value="${EXE.memberTName}"/>
							<input type="hidden" class="text"  id="EXETeamID" value="${EXE.teamID}"/>

							<input type="hidden" id="CTUserID" name="CTUserID" value="${EXE.memberID}" />
							<input type="hidden" id="opApTeamID" name="opApTeamID" value="${EXE.teamID}" />
							<input type="text" class="text"  id="CTUserNM" name="CTUserNM" value="${EXE.memberTName}" style="ime-mode:active; width:80%;" readonly/>
							<%-- <input type="image" class="image" id="searchEXERequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="fnOpenSearchPopup('searchNamePop.do','CTUserNM')" value="검색"> --%>
							<input type="image" class="image" id="searchEXERequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL','CTUserNM')" value="검색">
						</td>
					</tr>
				</table>
				<br>
			</div>
		</div>
	</form>
</div>
	
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>