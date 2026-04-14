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
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>


<script type="text/javascript">
var srID = "${ctrData.srID}";
var scrID = "${ctrData.scrID}";
var ctrID = "${ctrData.ctrID}";
	
$(document).ready(function(){		
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

var memberType = "";

function fnUpdateCTR(registerType) {
    var url = "updateCTRPop.do?srID="+srID+"&scrID="+scrID+"&ctrID="+ctrID+"&registerType="+registerType;
    window.open(url,'registerCTR','width=850, height=320, left=300, top=150,scrollbars=yes,resizable=yes');
}

function returnSavectr(){
	opener.doSearchctrList();
	self.close();
}

function returnDoSearchctrList(){
	opener.doSearchctrList();
}

function returnUpdatectr(){
	location.reload();
}

function fnSavectr(){
	if(confirm("${CM00001}")){
		var url = "updateCTRPop.do";
		ajaxSubmit(document.ctrFrm, url);
	}
}

function fnGoSCRDetail(id, ind){
	var screenMode = "V";
	var url = "viewScrDetail.do";		
	var data = "srID="+srID+"&scrID="+scrID+"&screenMode="+screenMode; 
	var w = 1100;
	var h = 800;
	window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}

function selfClose(){
	self.close();
}
</script>
</head>
<body style="width: 100%; height: 100%; margin: 0; padding: 0; overflow: scroll; overflow-X:hidden;">
<div id="ctrDiv" style="padding: 0 10px 0 10px">
	<form name="ctrFrm" id="ctrFrm" method="post" action="#" onsubmit="return false;">	
		<input type="hidden" id="loginUserId" name="loginUserId" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="srID"      name="srID"      value="${ctrData.srID}" />
	    <input type="hidden" id="scrID"      name="scrID"      value="${ctrData.scrID}" />
	    <input type="hidden" id="ctrID"      name="ctrID"      value="${ctrData.ctrID}" />

		<div class="cop_hdtitle pdB10" style="border-bottom:1px solid #ccc">
			<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;CTS 정보</h3>
		</div>
		<br>
		<div>	
			<div id="objectInfoDiv" class="hidden floatC">
				<div class="floatL mgB10">&nbsp;기본 정보</div>
				<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
					</colgroup>
					<tr>
						<th class="alignL pdL10 viewline">CTS No.</th>
						<td class="alignL pdL5">
							${ctrData.ctrCode}
						</td>
						<th class="alignL pdL10">긴급 여부</th>
						<td class="alignL pdL5">
							<c:if test="${ctrData.urgencyYN eq 'Y'}">
								긴급
							</c:if>
							<c:if test="${ctrData.urgencyYN eq 'N'}">
								일반
							</c:if>
						</td>
						
						<th class="alignL pdL10">상태</th>
						<td class="alignL pdL5 last">
							${ctrData.statusNM}
						</td>	
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">${sysArea1LabelNM}</th>
						<td class="alignL pdL5">
							${ctrData.sysArea1NM}
						</td>
						<th class="alignL pdL10">${sysArea2LabelNM}</th>
						<td class="alignL pdL5">
							${ctrData.sysArea2NM}
						</td>
						<th class="alignL pdL10">SCR No.</th>
						<td class="alignL last">
							
							<a href="javascript:fnGoSCRDetail();">${ctrData.scrCode}</a>
						</td>					
					</tr>						
				</table>
				<br>

				<!-- 요청 정보 --> 
				<div class="floatL mgB10">&nbsp;요청 정보</div>
				<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="14%">
						<col width="36%">
						<col width="14%">
						<col width="36%">
					</colgroup>
					<tr>
						<th class="alignL pdL10 viewline">요청자</th>
						<td class="alignL pdL5">
							${ctrData.regTName}
						</td>
						<th class="alignL pdL10">요청일자 </th>
						<td class="alignL pdL5 last">
							<font>
								${ctrData.regDTM}
							</font>
						</td>
					</tr>
					<tr>
						<!-- 제목 -->
						<th class="alignL pdL10 viewline">제목 </th>
						<td colspan="3" class="alignL pdL5 last">
							${ctrData.subject}
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">설명</th>
						<td colspan="3" class="alignL pdL5 last">	
							<pre><c:out value="${ctrData.Description}" /></pre>
						</td>
					</tr>
				</table>
				<br>
				<c:if test="${ctrData.urgencyYN eq 'Y'}">	
				<!-- 실행 정보 -->
				<div class="floatL mgB10">&nbsp;실행 정보</div>
			<c:if test="${((ctrData.status eq 'CTSREQ' and ctrData.urgencyYN eq 'Y')  or (ctrData.status eq 'CTSAPRV' and ctrData.aprvStatus eq '2')) and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">	
				<div class="floatR">
					<span class="btn_pack medium icon"><span class="confirm"></span><input value="Edit CTS Result" type="submit" onclick="javascript:fnUpdateCTR('');"></span>
				</div>
			</c:if> 
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
						<th class="alignL pdL10 viewline">실행자</th>
						<td class="alignL pdL5">
							${ctrData.CTUserNM2}
						</td>
						<th class="alignL pdL10">실행 일자</th>
						<td class="alignL pdL5 last">
							<font>
								${ctrData.CTExeDTM}
							</font>
						</td>
					
						<th class="alignL pdL10">실행결과 종류</th>
						<td class="alignL pdL5 last">
							${ctrData.CTResultTPName}
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">실행 결과</th>
						<td colspan="5" class="alignL pdL5 last">
							<pre><c:out value="${ctrData.CTResult}" /></pre>
						</td>
					</tr>
					<c:if test="${ctrData.CTResultTP eq '3'}">
					<tr id="CTRemarkArea">
						<th class="alignL pdL10 viewline">비고</th>
						<td colspan="5" class="alignL pdL5 last">							
							${ctrData.CTRemark}
						</td>
					</tr>
					</c:if>
				</table>
				<br>
			</c:if>
				<!-- 검토 정보 -->
				<div class="floatL mgB10">&nbsp;검토 정보</div>
				<c:if test="${((ctrData.urgencyYN eq 'N' and ctrData.status eq 'CTSREQ') or (ctrData.urgencyYN eq 'Y' and ctrData.status eq 'CTSCMP')) and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">
					<div class="floatR">
						<span class="btn_pack medium icon"><span class="confirm"></span><input value="Review" type="submit" onclick="javascript:fnUpdateCTR('');"></span>
					</div>
				</c:if>
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
							${ctrData.reviewerTName}
						</td>
						<th class="alignL pdL10">검토 일자</th>
						<td class="alignL pdL5 last">
							<font>
								${ctrData.reviewDTM}
							</font>
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">검토 내용</th>
						<td colspan="3" class="alignL pdL5 last">
							<pre><c:out value="${ctrData.rewComment}" /></pre>
						</td>
					</tr>
				</table>
				<br>
			
				<!-- 승인 정보 -->
				<div class="floatL mgB10">&nbsp;승인 정보</div>
			<c:if test="${ctrData.status eq 'CTSREW' and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">
				<div class="floatR">
					<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approve" onclick="javascript:fnUpdateCTR('2');" type="button"></span>
					<span class="btn_pack medium icon"><span class="cancel"></span><input value="Reject" onclick="javascript:fnUpdateCTR('3');" type="button"></span>
				</div>
			</c:if>
				<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
					</colgroup>
					<tr>
						<th class="alignL pdL10 viewline">승인자</th>
						<td class="alignL pdL5">
							${ctrData.approverTName}
						</td>
						<th class="alignL pdL10">승인 일자</th>
						<td class="alignL pdL5">
							<font>
								${ctrData.approvalDTM}
							</font>
						</td>
						<th class="alignL pdL10">승인 상태</th>
						<td class="alignL pdL5 last">
							${ctrData.aprvStatusNM}							
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">Commet</th>
						<td colspan="5" class="alignL pdL5 last">
							<pre><c:out value="${ctrData.aprvComment}" /></pre>
						</td>
					</tr>
				</table>
				<br>
			<c:if test="${ctrData.urgencyYN eq 'N'}">	
				<!-- 실행 정보 -->
				<div class="floatL mgB10">&nbsp;실행 정보</div>
			<c:if test="${((ctrData.status eq 'CTSREQ' and ctrData.urgencyYN eq 'Y')  or (ctrData.status eq 'CTSAPRV' and ctrData.aprvStatus eq '2')) and ctrData.curWorkerID eq sessionScope.loginInfo.sessionUserId }">	
				<div class="floatR">
					<span class="btn_pack medium icon"><span class="confirm"></span><input value="Edit CTR Result" type="submit" onclick="javascript:fnUpdateCTR('');"></span>
				</div>
			</c:if> 
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
						<th class="alignL pdL10 viewline">실행자</th>
						<td class="alignL pdL5">
							${ctrData.CTUserNM2}
						</td>
						<th class="alignL pdL10">실행 일자</th>
						<td class="alignL pdL5 last">
							<font>
								${ctrData.CTExeDTM}
							</font>
						</td>
					
						<th class="alignL pdL10">실행결과 종류</th>
						<td class="alignL pdL5 last">
							${ctrData.CTResultTPName}
						</td>
					</tr>
					<tr>
						<th class="alignL pdL10 viewline">실행 결과</th>
						<td colspan="5" class="alignL pdL5 last">
							<pre><c:out value="${ctrData.CTResult}" /></pre>
						</td>
					</tr>
					<c:if test="${ctrData.CTResultTP eq '3'}">
					<tr id="CTRemarkArea">
						<th class="alignL pdL10 viewline">비고</th>
						<td colspan="5" class="alignL pdL5 last">							
							${ctrData.CTRemark}
						</td>
					</tr>
					</c:if>
				</table>
			</c:if>
			</div>
		</div>
		<div class="cop_hdtitle pdB10">
			<span class="floatR mgT10 mgB5 mgR10" >
				<span id="close" class="btn_pack medium icon"><span class="close"></span>
						<input value="Close" type="submit" onclick="selfClose()" /></span>
			</span>
		</div>
	</form>
</div>
	
	
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>