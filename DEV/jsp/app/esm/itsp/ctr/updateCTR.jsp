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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>


<script type="text/javascript">
var ctrDataStatus = "${ctrData.status}";
var status = "";
var ctrDataUrgencyYN = "${ctrData.urgencyYN}";
var curWorkerID = "";


$(document).ready(function(){		
	$("input.datePicker").each(generateDatePicker);
	$('#oprApTime').timepicker({
        timeFormat: 'H:i',
    });
	document.getElementById('editArea').style.height = (setWindowHeight() - 45);
	
	$('input:radio[name=CTResultTP]').change(function() {
		var radioValue = $(":input:radio[name=CTResultTP]:checked").val();
		if(radioValue == "3"){
			$('#CTRemarkArea').removeAttr("style"); 
		}else{
			$('#CTRemarkArea').css("display","none");
			$('#CTRemark').val('');
		}
	});



	
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
	var aprvStatus = $('#aprvStatus').val();
	
	if ($('#rewComment').val() == "") {
		alert("검토 내용을 입력하여 주십시오.");
		$('#rewComment').focus();
		return false;
	}
	if ($('#aprvComment').val() == "") {
		alert("내용을 입력하여 주십시오.");
		$('#aprvComment').focus();
		return false;
	}
	
	if ($('#CTResult').val() == "") {
		alert("실행 결과를 입력하여 주십시오.");
		$('#CTResult').focus();
		return false;
	}
	
	if(ctrDataUrgencyYN == "N"){
		if(ctrDataStatus == "CTSREQ"){
			//2.일반 검토 작성	
			status = "CTSREW";
			curWorkerID = "${ctrData.approverID}";
		}else if(ctrDataStatus == "CTSREW"){
			//승인 작성			
			if(aprvStatus == "2"){
		    	//3-1.일반 승인 완료
				status = "CTSAPRV";	
				curWorkerID = "${ctrData.CTUserID}";
		    }else{
		    	//3-2.일반 승인 거절
				status = "CTSCLS";
				curWorkerID = null;
		    }
		}else if(ctrDataStatus == "CTSAPRV"){
			//2.일반 실행	
			status = "CTSCLS";
			curWorkerID = null;
		}else if(ctrDataStatus == "CTSCMP"){
			status = "CTSCLS";
			curWorkerID = null;
		}
	}else{
		if(ctrDataStatus == "CTSREQ"){
			status = "CTSCMP";
			curWorkerID = "${ctrData.reviewerID}";
		}else if(ctrDataStatus == "CTSCMP"){
			status = "CTSREW";
			curWorkerID = "${ctrData.approverID}";
		}else if(ctrDataStatus == "CTSREW"){
			//승인 작성
				status = "CTSCLS";
			curWorkerID = null;
		}else if(ctrDataStatus == "CTSAPRV"){
			if(aprvStatus == "2"){
				status = "CTSCLS";
				curWorkerID = null;
		    }
		}
	}
	
	$("#status").val(status);	
	$("#curWorkerID").val(curWorkerID);
	
	if(confirm("${CM00001}")){
		var url = "updateCTRInfo.do";
		ajaxSubmit(document.ctrFrm, url);
	}
}

function returnUpdatectr(){
	opener.returnDoSearchctrList();
	opener.location.reload();
	self.close();
}

</script>
</head>
<body style="width: 100%; height: 100%; margin: 0; padding: 0; overflow: auto; overflow-X:hidden;">
<div id="ctrDiv" style="padding: 0 10px 0 10px">
	<form name="ctrFrm" id="ctrFrm" method="post" enctype="multipart/form-data" action="#" onsubmit="return false;">	
		<input type="hidden" id="loginUserId" name="loginUserId" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="srID" name="srID" value="${ctrData.srID}" />
		<input type="hidden" id="scrID" name="scrID" value="${ctrData.scrID}" />
		<input type="hidden" id="ctrID" name="ctrID" value="${ctrData.ctrID}" />
		<input type="hidden" id="status" name="status" value="" />
		<input type="hidden" id="curWorkerID" name="curWorkerID" value="" />

		

		<div class="pdT10">
			<span class="floatR mgB5 mgR10" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="javascript:fnSavectr()"></span>
			</span>
		</div>
		<div id="editArea" style="width: 100%; margin-bottom: 5px;">	
			<div id="objectInfoDiv" class="hidden floatC">
					
					<c:if test="${((ctrData.urgencyYN eq 'N' and ctrData.status eq 'CTSREQ') or (ctrData.urgencyYN eq 'Y' and ctrData.status eq 'CTSCMP')) and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">
					<div class="cop_hdtitle">
						<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;CTS 검토 </h3>
					</div>
					<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="14%">
							<col width="36%">
							<col width="14%">
							<col width="36%">
						</colgroup>
						<tr>
							<th class="alignL pdL10 viewline">검토자</th>
							<td class="alignL pdL5">
								${ctrData.reviewerName}(${ctrData.reviewerTeamName})
							</td>
							<th class="alignL pdL10">검토 일자</th>
							<td class="alignL pdL5 last">
								<font>
									<input type="hidden" id="reviewDT" name="reviewDT" value="${thisYmd}"/>
									${thisYmd}
								</font>
							</td>
						</tr>
						<tr>
							<th class="alignL pdL10 viewline">검토 내용</th>
							<td colspan="3" class="alignL pdL5 last"><textarea class="edit"  id="rewComment" name="rewComment" style="width:100%;height:80px;"></textarea></td>
						</tr>
					</table>
					<br>
					</c:if>
					
					<c:if test="${ctrData.status eq 'CTSREW' and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">
					<input type="hidden" id="approvalDT" name="approvalDT" value="${thisYmd}"/>
					<c:if test="${registerType eq '2'}">
						<input type="hidden" id="aprvStatus" name="aprvStatus" value="2">
						<input type="hidden" id="ifStatus" name="ifStatus" value="1">
					<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;CTS 승인 </h3>
					</c:if>
					<c:if test="${registerType eq '3'}">
						<input type="hidden" id="" name="aprvStatus" value="3">
					<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;CTS 거절 </h3>
					</c:if>
					<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" height="200px" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="10%">
							<col width="90%">
						</colgroup>
						
						<tr>
							<th class="alignL pdL10 viewline">Comment</th>
							<td class="alignL pdL5 last"><textarea class="edit" id="aprvComment" name="aprvComment" style="width:100%;height:100%;">${ctrData.aprvComment}</textarea></td>
						</tr>
					</table>
					<br>
					</c:if>
					<c:if test="${((ctrData.status eq 'CTSREQ' and ctrData.urgencyYN eq 'Y')  or (ctrData.status eq 'CTSAPRV' and ctrData.aprvStatus eq '2')) and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">	
					<div class="cop_hdtitle">
						<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;CTS 실행</h3>
					</div>
					<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="11%">
							<col width="15%">
							<col width="8%">
							<col width="14%">
							<col width="10%">
							<col width="17%">
						</colgroup>
						<tr>
							<th class="alignL pdL10 viewline">실행 일자</th>
							<td class="alignL pdL5">
									
									<input type="text" id="CTExeDT" name="CTExeDT" value="${thisYmd}"	class="input_off datePicker text" size="8"
										style="width:80%; text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" readonly="readonly">
								
							</td>
							<th class="alignL pdL10">실행 시간</th>
							<td class="alignL pdL5 last">
									
									<input type="text" id="oprApTime" name="oprApTime" value="00:00" class="input_off text" size="8"
										style="width:80%; text-align: center;" maxlength="10"">
								
							</td>
							<th class="alignL pdL10">실행결과 종류</th>
							<td class="alignL pdL5 last">
								<input type="radio" name="CTResultTP" value="1" checked>성공
								<input type="radio" name="CTResultTP" value="2">오류발생
								<input type="radio" name="CTResultTP" value="3">비고
							</td>
						</tr>
						<tr>
							<th class="alignL pdL10 viewline">실행 결과</th>
							<td colspan="5" class="alignL pdL5 last"><textarea class="edit"  id="CTResult" name="CTResult" style="width:100%;height:80px;"></textarea></td>
						</tr>
						<tr id="CTRemarkArea" style="display:none">
							<th class="alignL pdL10 viewline">비고</th>
							<td colspan="5" class="alignL pdL5 last">							
								<input type="text" id="CTRemark" name="CTRemark" value="" class="text" style="width:100%;ime-mode:active;" >
							</td>
						</tr>
					</table>
					</c:if>
			</div>
		</div>
	</form>
</div>
	
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>