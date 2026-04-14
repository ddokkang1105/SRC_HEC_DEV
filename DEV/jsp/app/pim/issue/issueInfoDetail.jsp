<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	chkReadOnly = true;
</script>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		
		
	});
	
	//================================================================================================================================================
	
	// [List]
	function goBack() {
		var url = "issueSearchList.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
			+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
			+ "&Creator=${Creator}&ParentID=${ParentID}&issueMode=${issueMode}"
			+ "&currPageI=${currPageI}&screenType=${screenType}";
		var target = "help_content";
		if("${screenType}"=="csrDtl"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [Edit]
	function goEdit() {
		// Issue 편집 화면으로 이동
		var url = "addNewIssue.do"; // 변경 오더 등록 화면
		var data = "issueMode=${issueMode}&isIssueEdit=Y"
				+ "&issueId=${getMap.IssueID}"
				+ "&currPageI=${currPageI}"
				+ "&ParentID=${ParentID}"
				+ "&screenType=${screenType}";
		var target = "help_content"; if("${screenType}"=="csrDtl"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [Receive]
	function goReceive() {
		var url = "receiveIssue.do"; // 변경 오더 등록 화면
		var data = "issueMode=${issueMode}&isIssueEdit=${isIssueEdit}"
				+ "&issueId=${getMap.IssueID}"
				+ "&currPageI=${currPageI}"
				+ "&ParentID=${ParentID}"
				+ "&screenType=${screenType}";
		var target = "help_content"; if("${screenType}"=="csrDtl"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [Action]
	function goAction() {
		var url = "actionIssue.do"; // 변경 오더 등록 화면
		var data = "issueMode=${issueMode}&isIssueEdit=${isIssueEdit}"
				+ "&issueId=${getMap.IssueID}"
				+ "&currPageI=${currPageI}"
				+ "&ParentID=${ParentID}"
				+ "&screenType=${screenType}";
		var target = "help_content";if("${screenType}"=="csrDtl"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [편집 모드 일때] 첨부파일 다운로드 관련
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ISSUE";
		//alert(url);
		ajaxSubmitNoAdd(document.issueInfoDetailFrm, url,"saveFrame");
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
	function fileNameClick(avg1, avg2, avg3, avg4){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ISSUE";
		ajaxSubmitNoAdd(document.issueInfoDetailFrm, url,"saveFrame");
	}
		
</script>

<form name="issueInfoDetailFrm" id="issueInfoDetailFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	
	<!-- 화면 타이틀 : Issue 상세 -->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 0 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
				${menu.LN00226}   
		</h3>
	</div>
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;">
		<!-- button table  -->
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
        <tr>
           <td class="alignR pdR20 last" bgcolor="#f9f9f9">
           		<c:if test="${issueMode == 'ARC' || issueMode == 'PjtMgt'}">
	           		<c:if test="${getMap.Status == '01'}">
		           		<c:if test="${sessionScope.loginInfo.sessionUserId == getMap.Requestor}">
		           			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goEdit()"></span>
		           		</c:if>
		           		<c:if test="${sessionScope.loginInfo.sessionUserId == getMap.Receiver}">
		           			&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Receive" onclick="goReceive()" type="submit"></span>
		           		</c:if>
	           		</c:if>
	           		<c:if test="${getMap.Status == '02'}">
	           			<c:if test="${sessionScope.loginInfo.sessionUserId == getMap.Actor}">
		           			&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Action" onclick="goAction()" type="submit"></span>
		           		</c:if>
	           		</c:if>
           		</c:if>
	            &nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
      		</td>
      	</tr>
      	</table>
		
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
			</colgroup>
			<tr>
				<!-- 제목  -->
				<th class="viewtop">${menu.LN00002}</th>
				<td class="viewtop alignL pdL5 last" colspan="7">
					${getMap.Subject}
				</td>
			</tr>
			<tr>
				<!-- 프로젝트 -->
		       	<th>${menu.LN00131}</th>
		        <td> 
		        	${getMap.ProjectName}
		       	</td>
		       	
		       	<!-- 변경 오더 -->
		       	<th>${menu.LN00191}</th>
		        <td>
		        	${getMap.CSRName}
		       	</td>
		       	
		       	<!-- 유형  -->
				<th>${menu.LN00217}</th>
				<td>
					${getMap.ItemTypeName}
				</td>
				
				<!-- 상태  -->
				<th>${menu.LN00027}</th>
				<td class="last">
					${getMap.StatusName}
				</td>
			</tr>
			<tr>
				<!-- 요청조직  -->
				<th>${menu.LN00026}</th>
				<td>
					${getMap.ReqTeamName}
				</td>
				
				<!-- 요청자  -->
				<th>${menu.LN00025}</th>
				<td>
					${getMap.RequestorName}
				</td>
				
				<!-- 요청일  -->
				<th>${menu.LN00093}</th>
				<td>
					${getMap.CreationTime}
				</td>
				
				<!-- 완료요청일 -->
				<th>${menu.LN00222}</th>
				<td class="last">
					${getMap.ReqDueDate2}
				</td>
			</tr>
			<!-- 첨부파일 -->	
			<tr>
				<th>${menu.LN00111}</th>
				<td colspan="7" class="alignL pdL5 last">
					<div style="height:80px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:if test="${issueFiles.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
						</c:if>
						</div>
						<c:forEach var="fileList" items="${issueFiles}" varStatus="status">
							<div id="divDownFile${fileList.Seq}" class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}');">${fileList.FileRealName}</span>
								<br>
							</div>
						</c:forEach>
					</div>
				</td>
			</tr>
			
			<!-- 개요 -->			
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="7" class="last">
					<textarea class="textgrow" id="Description" name="Description" style="width:100%;height:100px;">${getMap.Content}</textarea>
				</td>
			</tr>
		</table>
		<table class="tbl_blue01" style="table-layout:fixed;">
			<colgroup>
				<col width="5.4%">
				<col width="17%">
				<col width="5.4%">
				<col width="17%">
				<col width="5.4%">
				<col width="17%">
			</colgroup>	
			<tr>
				<!-- 접수조직  -->
				<th class="viewtop">${menu.LN00227}</th>
				<td class="viewtop">
					${getMap.RecTeamName} 
				</td>
				
				<!-- 접수자  -->
				<th class="viewtop">${menu.LN00219}</th>
				<td class="viewtop">
					${getMap.ReceiverName} 
				</td>
				
				<!-- 완료예정일 -->
				<th class="viewtop">${menu.LN00221}</th>
				<td class="viewtop last">
					${getMap.DueDate}
				</td>
			</tr>
			<!-- 대응방안 -->			
			<tr>
				<th>${menu.LN00229}</th>
				<td colspan="5" class="last">
					<textarea class="textgrow" id="Response" name="Response" style="width:100%;height:100px;">${getMap.Response}</textarea>
				</td>
			</tr>
			<tr>
				<!-- 처리조직  -->
				<th class="viewtop">${menu.LN00218}</th>
				<td class="viewtop">
					${getMap.ActTeamName}
				</td>
				
				<!-- 처리자  -->
				<th class="viewtop">${menu.LN00220}</th>
				<td class="viewtop">
					${getMap.ActorName} 
				</td>
				
				<!-- 처리완료일 -->
				<th class="viewtop">${menu.LN00223}</th>
				<td class="viewtop last">
					${getMap.ActionDate}
				</td>
			</tr>
			<!-- 처리결과 -->			
			<tr>
				<th>${menu.LN00228}</th>
				<td colspan="5" class="last">
					<textarea class="textgrow" id="Result" name="Result" style="width:100%;height:100px;">${getMap.Result}</textarea>
				</td>
			</tr>
			
		</table>
	</div>
	
	</form>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>
