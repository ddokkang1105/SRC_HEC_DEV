<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script>
	var scrID = "${scrId}"; 
	var srID = "${srId}"; 
	
// 	function fnEditScrTest(){
// 		var url = "editScrTestResult.do";
// 		var data = "scrId=${scrId}"
// 		var target = "viewScrDiv";
// 		ajaxPage(url, data, target);
// 	}
	
	// [Attach] 버튼 클릭
	function fnUploadPop(fltpCode,fileID){
		var scrUserID = "${scrUserID}";
		var scrStatus = "${scrStatus}";
		var finTestor = "${finTestor}";
		if(scrStatus == "TSREQ" && finTestor == "${sessionScope.loginInfo.sessionUserId}"){
				var url  = "addScrFilePop.do?scrId="+scrID+"&fltpCode="+fltpCode+"&fileID="+fileID+"&srID="+srID+"&scrStatus=TSCMP";
				window.open(url,'window','width=600, height=300, left=300, top=300,scrollbar=no,resizble=0');
		} else {
			alert("${WM00033}");
			return false;
		}
	}
	
	function fnFileDownLoad(fltpCode){	
		var seq = $("#fileID"+fltpCode).val();
		var url  = "fileDownload.do?seq="+seq;

		ajaxSubmitNoAdd(document.scrTestFrm, url,"saveFrame");
	}
	
	function fnCallBack(scrId,scrStatus){
		if(scrStatus != null && scrStatus != ''){
			var url = "viewScrDetail.do";
			var data = "scrID="+scrID+"&screenMode=V&srID="+srID+"&tabNo=3";
			var target = "scrDiv";
		} else {
			var url = "viewScrTestResult.do";
			var data = "scrID="+scrId;
			var target="scrTestFrm";
		}
		ajaxPage(url, data, target);
	}
</script>
<div id="viewScrDiv">
	<form name="scrTestFrm" id="scrTestFrm" action="#" method="post" onsubmit="return false;">
		<div class="floatC" style="overflow:auto;overflow-x:hidden;">
			<c:forEach var="fileList" items="${fileList}" varStatus="status">
<%-- 			<c:if test="${scrUserID eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'APREL'}"> --%>
<!-- 			<div class="floatR mgR10 mgB10"> -->
<!-- 				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditScrTest()"></span> -->
<!-- 			</div> -->
<%-- 			</c:if> --%>
			<c:if test="${finTestor eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'TSREQ'}">
			<div class="floatR mgR10 mgB10">
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="현업테스트 결과 입력" type="submit"  onclick="fnUploadPop('${fileList.FltpCode}','${fileList.FileID}')"></span>
			</div>
			</c:if>
			<table class="tbl_blue01 mgT10 cb_module" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col width="85%">
				</colgroup>
				<tr>
<!-- 					<th class="alignL pdL10 viewline">테스트서버유무</th> -->
<%-- 					<td class="alignC"><input type="checkbox" value="${scrInfo.TestSvrYN}" <c:if test="${scrInfo.TestSvrYN == 'Y'}">checked</c:if> disabled></td> --%>
<!-- 					<td colspan=2 class="last"></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<th class="alignL pdL10 viewline">동료테스트수행여부</th> -->
<%-- 					<td class="alignC"><input type="checkbox" value="${scrInfo.CoworkerTestYN}" <c:if test="${scrInfo.CoworkerTestYN == 'Y'}">checked</c:if> disabled></td> --%>
<!-- 					<th class="alignL pdL10">동료테스트합격여부</th> -->
<%-- 					<td class="alignC last"><input type="checkbox" value="${scrInfo.CoworkerTestPass}" <c:if test="${scrInfo.CoworkerTestPass == 'Y'}">checked</c:if> disabled></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<th class="alignL pdL10 viewline">동료테스트결과</th> -->
<%-- 					<td colspan=3 class="last"><textarea style="width:100%;height:50px;background: #fff;" disabled>${scrInfo.CoworkerTestResult}</textarea></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
					<th class="alignL pdL10 viewline">개발테스트 결과</th>
					<td colspan=3 class="last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.IntegTestResult}</textarea></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">현업테스트 결과</th>
					<td class="last">
						<textarea style="width:100%;height:75px;background: #fff;" readOnly="true">${scrInfo.FinTestResult}</textarea>
					</td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">현업테스트 산출물</th>
					<td class="last">
						<table class="tbl_blue01" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="5%">
								<col width="15%">
								<col width="20%">
<%-- 								<col width="5%"> --%>
								<col width="35%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<tr>
								<th class="">No</th>
								<th class="viewline">${menu.LN00091}</th>
								<th class="viewline">샘플파일명</th>
<!-- 								<th class="viewline">Upload</th> -->
								<th class="viewline">업로드파일명</th>
								<th class="viewline">수정일</th>
								<th class="viewline">작성자</th>
							</tr>
							<tr>
								<td class="last">${fileList.RNUM}</td>
								<td class="last">${fileList.FltpName}</td>
								<td class="alignL pdL10 last"><span onclick="fnFileDownLoad('${fileList.FltpCode}_1')" style="color:#1236b7; font-weight:bold; cursor:pointer;">${fileList.FileRealName1}</span></td>
<%-- 								<td class="last"><img src="${root}${HTML_IMG_DIR}/icon_attach.png" style="cursor:pointer;" alt="업로드" onclick="fnUploadPop('${fileList.FltpCode}','${fileList.FileID}')"></td> --%>
								<td class="alignL pdL10 last"><span onclick="fnFileDownLoad('${fileList.FltpCode}_2')" style="color:#1236b7; font-weight:bold; cursor:pointer;">${fileList.FileRealName2}</span></td>
								<td class="last">${fileList.LastUpdated}</td>
								<td class="">${fileList.LastUser}</td>
								<input type="hidden" id="fileID${fileList.FltpCode}_1" name="fileID${fileList.FltpCode}_1" value="${fileList.Seq}" >
								<input type="hidden" id="fileID${fileList.FltpCode}_2" name="fileID${fileList.FltpCode}_2" value="${fileList.FileID}" >
							</tr>
						</table>
					</td>
				</tr>
<!-- 				<tr> -->
<!-- 					<th class="alignL pdL10 viewline">형상관리항목등록여부</th> -->
<%-- 					<td class="alignC"><input type="checkbox" value="" <c:if test="${scrInfo.CMYN == '1'}">checked</c:if> disabled></td> --%>
<!-- 					<td colspan=2 class="last"></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<th class="alignL pdL10 viewline">형상관리항목</th> -->
<!-- 					<td colspan=3 class="last"><textarea style="width:100%;height:50px;background: #fff;" disabled></textarea></td> -->
<!-- 				</tr> -->
			</table>
			</c:forEach>
		</div>
	</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>