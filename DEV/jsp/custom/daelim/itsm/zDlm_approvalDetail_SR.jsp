<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00036" var="WM00036" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Approval path"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049" />

<script type="text/javascript">
	$(document).ready(function(){		
		
		document.getElementById('apprDetailDiv').style.height = (setWindowHeight() - 10)+"px";			
		window.onresize = function() {
			document.getElementById('apprDetailDiv').style.height = (setWindowHeight() - 10)+"px";	
		};
	});	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
	var menuIndex = "${menuIndex}";
	
	function fnOpenApprComment(wfStepInstStatus,svcCompl){	
		var url = "openApprCommentPop.do?projectID=${projectID}"
					+ "&stepInstID=${stepInstID}"
					+ "&actorID=${actorID}"
					+ "&stepSeq=${stepSeq}"
					+ "&wfInstanceID=${wfInstanceID}"
					+ "&lastSeq=${lastSeq}"
					+ "&srID=${srID}"
					+ "&documentID=${documentID}"
					+ "&wfStepInstStatus="+wfStepInstStatus
					+ "&svcCompl="+svcCompl
					+ "&docNo=${getSRInfoMap.SRCode}";
					
		var w = 620;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}

	function fnOpenApprTransfer(){		
		var url = "openApprTransferPop.do?projectID=${projectID}"
					+ "&stepInstID=${stepInstID}"
					+ "&actorID=${actorID}"
					+ "&stepSeq=${stepSeq}"
					+ "&wfInstanceID=${wfInstanceID}"
					+ "&lastSeq=${lastSeq}"
					+ "&wfID=${wfInstInfo.WFID}";
		var w = 400;
		var h = 300;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	// [Previous]
	function goPrevious() {	
		setSubFrame(menuIndex);
	}
	
	function fnCallBack(){
		opener.doSearchList();
		self.close();
	}
	
	function fnProcessCallBackSubmit(url, data) {
		var screenType = "${screenType}";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	// Submit CallBack
	function fnCallBackSubmit() {
		setSubFrame(menuIndex);	
	}
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.apprDetailFrm, url,"saveFrame");
	}	
	
	/* 첨부문서 다운로드 */
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
		var url = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.apprDetailFrm, url,"saveFrame");
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
	
	function fnOpenCsrDetail(){
		var s_itemID = "${projectID}";
		var projectID = "${projectID}";
		var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=V" + "&s_itemID="+s_itemID;
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}

	function fnOpenViewVersionItemInfo(changeSetID, avg1, avg2, avg3, avg4, avg5){
		
		var url = "viewVersionItemInfo.do?s_itemID="+avg1
					+"&changeSetID="+changeSetID
					+"&projectID="+avg2
					+"&authorID="+avg3
					+"&status="+avg4
					+"&version="+avg5;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	// [Item] click
	/* function goItemPopUp(avg1,avg2) {
		var url = "olmChangeSetLink.do?olmLoginid=${sessionScope.loginInfo.sessionLoginId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&keyID="+avg1+"&scrnType=pop&linkID="+avg2;
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	} */
<%-- 
	function goCSInfoView(avg1){
		var url = "<%=GlobalVal.OLM_SERVER_URL%>olmLink.do?olmLoginid=guest&object=itm&linkType=id&linkID="+avg1+"&languageID=1042&option=AR000004";
		var w = 1200;
		var h = 700; 
		itmInfoPopup(url,w,h);
	} 
 --%>
	function fnReApproval() {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = "${wfURL}.do";
		var data = "isNew=Y&wfDocType=${wfDocType}&isMulti=Y&isPop=Y&categoryCnt=1&preWfInstanceID="+$("#preWfInstanceID").val();
				
		ajaxPage(url,data,"wfInstListDiv");
	}
	
	/* function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${srID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup+"&srType=${getSRInfoMap.SRType}";
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	} */
	
	// 상세 페이지 이동
	function fnSRDetail(){
		var isPopup = "true";
		var url = "esrInfoMgt.do";
		var srID = "${srID}";
		var data = "scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup+"&srType=${getSRInfoMap.SRType}";
		
		window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes");
	}
	
	// [승인재요청]
	async function fnReqITSApproval(){ //zDlm_wfDocMgt.do
		var msg = "";
		const msgObj = await getDicData("ERRTP", "ZLN0025");
		msg = msgObj.LABEL_NM;
		
		if (confirm(msg)) {		// "승인 재요청 하시겠습니까?"
			var url = "zDlm_wfDocMgt.do";
			var data = "srID=${getSRInfoMap.SRID}" 
					+ "&docSubClass=${getSRInfoMap.Status}&docCategory=SPE"
					+ "&WFDocURL=${WFDocURL}&ProjectID=${getSRInfoMap.ProjectID}&defWFID=${getSRInfoMap.DefWFID}"				
					+ "&srRequestUserID=${getSRInfoMap.RequestUserID}"
					+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
					+ "&speCode=${getSRInfoMap.Status}&customerNo=${getSRInfoMap.ClientID}"
					
					+ "&activityLogID=${activityLogInfo.ActivityLogID}"
					+ "&actorID=${activityLogInfo.ActorID}"
					
					+ "&srCode=${getSRInfoMap.SRCode}"
					
					+ "&documentID=${activityLogInfo.ActivityLogID}"
					
					+ "&documentNo=${getSRInfoMap.SRCode}"
					+ "&inhouse=Y"
					+ "&category=${getSRInfoMap.Category}"
					+ "&wfInstanceID=${wfInstInfo.WFInstanceID}"
					+ "&reqReApproval=Y";
		
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	
	function fnCallBackSR() {
	    window.location.reload(); 
	}
	
</script>
</head>
<body>
<div id="apprDetailDiv" style="padding: 0px 5px 0px 5px;overflow-x:hidden;overflow-y:auto;">
<form name="apprDetailFrm" id="apprDetailFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<!-- 화면 타이틀 : 결재경로 생성-->
	<div class="cop_hdtitle mgB10">
		<ul>
			<li class="floatL mgB10">
				<h3>
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00196}
				</h3>
			</li>			
	        <li class="floatR mgB10">  
	       
	     	 	 <c:if test="${wfMode == 'CurAprv'}">
					<c:if test="${transYN eq 'Y' }">
						<span class="btn_pack medium icon mgR6"><span class="confirm"></span><input value="Transfer" onclick="fnOpenApprTransfer();" type="button"></span>
					</c:if>       
					<c:if test="${wfInstInfo.Status == '1' }" >
						<span class="btn_pack medium icon mgR6"><span class="confirm"></span><input value="${actorWFStepName}" onclick="fnOpenApprComment('2','');" type="button"></span>
						<span class="btn_pack medium icon"><span class="cancel"></span><input value="${menu.LN00395}" onclick="fnOpenApprComment('3','Y');" type="button"></span>
					</c:if>  
				</c:if>
				<c:if test="${wfInstInfo.Status == '-1' }" >
					<span class="btn_pack medium icon mgR6"><span class="confirm"></span><input value="${menu.ZLN0191}" onclick="fnReqITSApproval();" type="button"></span>
				</c:if>
			</li> 
		</ul>	
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
		<table class="tbl_blue01" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="20%">
				<col width="12%">
				<col width="20%">			
			</colgroup>
			<tr>
				<!-- WF Instance 코드 -->
				<th class="viewline alignL pdL10">${menu.LN00134} No.</th>	
				<td class="alignL pdL10">${wfInstInfo.WFInstanceID}</td>
				<!-- 문서유형 -->
				<th class="alignL pdL10">${menu.LN00091}</th>
				<td class="alignL pdL10 ">${getSRInfoMap.SRTypeName}</td>	
				<!-- 기안자 -->
				<th class="alignL pdL10">${menu.LN00065}</th>
				<td class="alignL pdL10 last">${wfInstInfo.StatusName}</td>			
			</tr>	
			<tr>
				<th class="viewline alignL pdL10">${menu.LN00140}</th>
				
				<td class="alignL pdL10 last" colspan = 5 >
					${wfStepInstInfo}
				</td>					
			</tr>		
		</table>
		<div class="cop_hdtitle mgT10"></div>
		<table class="tbl_blue01 mgT10 mgB10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="20%">
				<col width="12%">
				<col width="20%">
			</colgroup>
			
			
			<tr>	
				<th class="alignL pdL10">Ticket No.</th>
				<td class="alignL pdL10">
					<span OnClick="fnSRDetail();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${getSRInfoMap.SRCode}</span>
				</td>
				<th class="alignL pdL10">${getSRInfoMap.SRArea1NM}/${getSRInfoMap.SRArea2NM}</th>
				<td class="alignL pdL10">${getSRInfoMap.SRArea1Name}/${getSRInfoMap.SRArea2Name}</td>
				<th class="alignL pdL10">${menu.LN00004}</th>
				<td class="alignL pdL10 last">${getSRInfoMap.ReceiptName}(${getSRInfoMap.ReceiptTeamName})</td>
			</tr>
			<tr>	
			    <th class="alignL pdL10">${menu.LN00025}</th>
				<td class="alignL pdL10">${getSRInfoMap.ReqUserNM}</td>
				<th class="alignL pdL10">${menu.LN00093}</th>
				<td class="alignL pdL10">${getSRInfoMap.RegDate}</td>
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="alignL pdL10 last">${getSRInfoMap.DueDate}</td>
			</tr>
			 <tr>
				<!-- 제목  -->
				<th class="viewline alignL pdL10">${menu.LN00002}</th>	
				<td class="viewline alignL pdL10 last"  colspan = 5>${wfInstInfo.Subject}</td>				
			</tr>
			
		 	<tr>
			 	<th class="viewline alignL pdL10">${menu.LN00035}</th>
				<td class=" alignL pdL10 last" colspan="5" style="width:100%;height:100px;">${getSRInfoMap.Description}</td>
			</tr>
			<tr>
			 	<th class="viewline alignL pdL10">${menu.LN00290}</th>
				<td class=" alignL pdL10 last" colspan="5" style="width:100%;height:100px;">${wfInstInfo.Description}</td>
			</tr>
			<c:if test="${wfDocType != 'SR' && wfDocType != 'SCR'}">
			<tr>
				<!-- 첨부문서  -->
				<th class="viewline alignL pdL10">${menu.LN00111}</th>
				<td class="alignL pdL10 last"  colspan="5" >
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<div class="floatR pdR20" id="divFileImg">
					<c:if test="${fileList.size() > 0}">
						<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
						<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
					</c:if>
					</div>
					<c:forEach var="fileList" items="${fileList}" varStatus="status">
						<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						</div>
					</c:forEach>
					</div>
				</td>	
			</tr>	
			</c:if>
		</table>
	
	* Approval History
	<table class="tbl_blue01 mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col width="15%">
		    <col width="10%">
		 	<col width="10%">
		    <col width="20%">
		 	<col width="35%">
		</colgroup>		
		<tr>
		  <th class="viewline">${menu.LN00004}</th> <!-- 진행단계 -->
		  <th class="viewline">${menu.LN00104}</th> <!-- 담당조직 -->
		  <th class="viewline">${menu.LN00120}</th> 
		  <th class="viewline">${menu.LN00027}</th>
		  <th class="viewline">Approval Date</th>
		  <th class="viewline last">Comment</th>
		</tr>
		<c:forEach var="list" items="${wfInstList}" varStatus="status">
			<tr style="height:26px;">
				<td class="last" style="border-left:1px solid #ddd">${list.ActorName}</td>
				<td class="last" >${list.TeamName}</td>
				<td class="last" >${list.WFStepName}</td>
				<td class="last" >${list.StatusNM}</td>
				<td class="last" >${list.ApprovalDate}</td>
				<td class="last alignL" >${list.Comment}</td>
			</tr>
		</c:forEach>
		<c:forEach var="list" items="${wfRefInstList}" varStatus="status">
			<tr style="height:26px;">
				<td class="last" style="border-left:1px solid #ddd">${list.ActorName}</td>
				<td class="sline tit last alignC " >${list.TeamName}</td>
				<td class="sline tit last alignC " >${list.WFStepName}</td>
				<td class="sline tit last alignC " >${list.StatusNM}</td>
				<td class="sline tit last alignC " >${list.ApprovalDate}</td>
				<td class="sline tit last alignL " >${list.Comment}</td>
			</tr>
		</c:forEach>
	</table>
	</div>	
	</form>	
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
</body>
</html>