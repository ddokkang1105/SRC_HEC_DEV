<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="프로젝트"/>

<script type="text/javascript">
	var schdlType = "${schdlType}";
	var mySchdl = "${mySchdl}";
	var chkReadOnly = false;
	var isReadOnly = "N";
	
	var scheduleId = "${resultMap.ScheduleID}";
	var userID = "${sessionScope.loginInfo.sessionUserId}";
	var regUserID = "${resultMap.RegUserID}";
	var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
	var screenType = "${screenType}";
	var sessionMlvl = "${sessionScope.loginInfo.sessionMlvl}";
	var projectAuthorID = "${projectMap.ProjectAuthorID}";
	var categoryData = "&category=DOCCAT&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode='PJT','SR','CSR'";

</script>

<script type="text/javascript">
	
	$(document).ready(function(){

	});

	// 삭제 
	function fnDelete(){
		//$add("scheduleId", "${resultMap.ScheduleID}", schedlFrm);
		if(confirm("${CM00002}")){
			var url = "deleteSchdlDetail.do";
			ajaxSubmit(document.schedlFrm, url);
		}
	}
	
	/* 
	// 목록
	function fnGoList(){
		var url = "goSchdlList.do";
		var data, target = "";
		if(screenType == "mainV3"){
			data="pageNum=${pageNum}&screenType=${screenType}&parentID=${parentID}";
			target = "help_content";
		}else{
			data = "&schdlType="+schdlType+"&mySchdl="+mySchdl;
			target = (mySchdl == "Y" ? "help_content" : "subBFrame");
		}
		ajaxPage(url, data, target);
	}
	 */
	 
	function selfClose(returnflag){
		self.close();
		if(returnflag == "T"){window.opener.doSearchList();}
	}
	
	function fnGoEditForm(){
		var url = "editSchdl.do";
		var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&scheduleId="+scheduleId;
		var target="";
		ajaxSubmitNoAdd(document.schedlFrm, url,"");
	}
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}

		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SCHDL";
		ajaxSubmitNoAdd(document.schedlFrm, url,"saveFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SCHDL";
		ajaxSubmitNoAdd(document.schedlFrm, url,"saveFrame");
	}
	
	function fnOpenCsrDetail(){
		var s_itemID = "${resultMap.documentID}";
		var projectID = "${resultMap.documentID}";
		var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=V" + "&s_itemID="+s_itemID;
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${resultMap.documentID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	function fnPJTDetail(){
		var screenType = "myPJT";
		var pjtMode = "R";
		var isNew = "N";
		var s_itemID = "${resultMap.documentID}";
		var url = "viewProjectInfo.do?screenType="+screenType+"&s_itemID="+s_itemID+"&pjtMode="+pjtMode+"isNew="+isNew;
		window.open(url,'','width=1100, height=430, left=200, top=100,scrollbar=yes,resizable=yes');
	}
</script>

<!-- BEGIN :: DETAIL -->
<div class="mgT10 mgL10 mgR10">
	<div class="cop_hdtitle mgB5" style="border-bottom:1px solid #ccc;">
		<h3 style="padding-bottom: 6px;"><img src="${root}${HTML_IMG_DIR}/icon_schedule.png">&nbsp;&nbsp;Schedule&nbsp;${menu.LN00108}</h3>
	</div>
	<table class="tbl_brd" id="projList" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
			<col width="35%">
			<col width="15%">
			<col width="35%">
		</colgroup>
		<tr>
			<th>${menu.LN00002}</th>
			<td  class="tit last" colspan="3">
				${resultMap.Subject}
			</td>
		</tr>
		<tr>
			<th>${menu.LN00336}</th>
			<td  class="tit last" colspan="3">
				<div style="overflow-y:scroll; height:70px; width:100%">
				<%-- <c:out value="${resultMap.Content}" escapeXml="false" /> --%>
				<pre>${resultMap.Content}</pre>
				</div>
			</td>
		</tr>
		<tr>
			<th>${menu.LN00237}</th>
			<td  class="tit last" colspan="3">
				${resultMap.Location}
			</td>
		</tr>
		<tr>
			<th>${menu.LN00324}</th>
			<td  class="tit">
				 <font> 
					${resultMap.start_date}
				</font>
				${resultMap.startTime}
			</td>
			<th>${menu.LN00325}</th>
			<td class="tit last" align="left">
				<font> 
					${resultMap.end_date}
				</font>
				${resultMap.endTime}
			</td>
		</tr>
		<tr>
			<th>${menu.LN00337}</th>
			<td  class="tit">
				<c:choose>
					<c:when test="${resultMap.disclScope eq 'PUB'}">전체</c:when>
					<c:when test="${resultMap.disclScope eq 'SHR'}">공유자</c:when>
					<c:when test="${resultMap.disclScope eq 'PJT'}">프로젝트 / ${resultMap.ProjectName}</c:when>
				</c:choose>
			</td>
			<th>
				${menu.LN00334}
			</th>
			<td class="tit last" align="left" >
				<c:choose>
					<c:when test = "${resultMap.alarmOption == 30}">
						30 minutes
					</c:when>
					<c:when test = "${resultMap.alarmOption == 60}">
						1 hour
					</c:when>
					<c:otherwise>
						N/A
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr id="share">
			<th>
				<a onclick="addSharer();">${menu.LN00245}</a>
			</th>
			<td  class="tit">
				<div style="overflow-y:scroll; height:35px; width:100%">
					${resultMap.sharerNames}
				</div>
			</td>
			<th>${menu.LN00033}</th>
			<td  class="tit last">		
				${resultMap.docCategoryName}
				<c:if test="${!empty(resultMap.docNO)}">
					 / 
					<c:choose>							 
						<c:when test="${resultMap.docCategory eq 'SR'}">
							<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnSRDetail();">
						</c:when>
						<c:when test="${resultMap.docCategory eq 'CSR'}">
							<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnOpenCsrDetail();">
						</c:when>
						<c:when test="${resultMap.docCategory eq 'PJT'}">
							<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnPJTDetail();">
						</c:when>
					</c:choose>
					 ${resultMap.docNO}</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<th  class="sline">${menu.LN00078} <c:if test="${!empty(resultMap.ModDT)}"> / ${menu.LN00070}</c:if></th>
			<td class="tit last" id="TD_REG_DT">
				${resultMap.RegDT} <c:if test="${!empty(resultMap.ModDT)}"> / ${resultMap.ModDT}</c:if> 
			</td>
			<th  class="sline">${menu.LN00212}</th>
			<td id="TD_WRITE_USER_NM" class="tit last">
				${resultMap.WriteUserNM}
			</td>
		</tr>
		<tr>
		<!-- 첨부문서 -->
			<th style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${schdlFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${schdlFiles}" varStatus="status">
				<div id="divDownFile${fileList.Seq}"  class="mm"  name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>				
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
	</table>
	<div class="alignBTN">		
		<c:if test="${screenType != 'mainV3'}">		
			<c:if test="${resultMap.editYN eq 'N' && ((sessionScope.loginInfo.sessionUserId == resultMap.RegUserID && sessionScope.loginInfo.sessionAuthLev < 4))}">
			<span id="viewSave" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnGoEditForm()"></span>&nbsp;&nbsp;
			</c:if>
			<c:if test="${(sessionScope.loginInfo.sessionUserId == resultMap.RegUserID && sessionScope.loginInfo.sessionAuthLev < 4)}">
				<span id="viewDel"  class="btn_pack medium icon"><span class="delete"></span><input value="Del" type="button" onclick="fnDelete()"></span>&nbsp;&nbsp;
			</c:if>
		</c:if>
	
		<!-- <span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="button"  onclick="fnGoList(true)"></span> -->
		<span id="close" class="btn_pack medium icon"><span class="close"></span>
			<input value="Close" type="submit" onclick="selfClose('F')" />
		</span>
	</div>
</div>
<form name="schedlFrm" id="schedlFrm" action="" method="post">
	<input type="hidden" id="scheduleId" name="scheduleId" 		value="${resultMap.ScheduleID}">
</form>
<!-- END :: DETAIL -->
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>