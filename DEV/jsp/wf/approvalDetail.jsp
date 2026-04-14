<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
		
// 		document.getElementById('apprDetailDiv').style.height = (setWindowHeight() - 10)+"px";			
// 		window.onresize = function() {
// 			document.getElementById('apprDetailDiv').style.height = (setWindowHeight() - 10)+"px";	
// 		};
	});	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
	var menuIndex = "${menuIndex}";
	
	function fnOpenApprComment(wfStepInstStatus, newProcPathID){	
		var url = "openApprCommentPop.do?projectID=${projectID}"
					+ "&stepInstID=${stepInstID}"
					+ "&actorID=${actorID}"
					+ "&stepSeq=${stepSeq}"
					+ "&wfInstanceID=${wfInstanceID}"
					+ "&lastSeq=${lastSeq}"
					+ "&srID=${srID}"
					+ "&wfStepInstStatus="+wfStepInstStatus
					+ "&newProcPathID="+newProcPathID
					+ "&fixedPath=${getPJTMap.FixedPath}"
					+ "&aprvOption=${getPJTMap.AprvOption}";
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
		
	 console.log("fnCallBack!!!");
	   opener.doSearchList();
	   pageClose();
	}
	
	function fnProcessCallBackSubmit(url, data) {
		var screenType = "${screenType}";
		var target = "saveFrame";
		if(screenType == "csrDtl"){ target = "projectInfoFrm"; }
		ajaxPage(url, data, target);
		/* setTimeout(function() {
			if($.isFunction(opener.doSearchList)){
				opener.doSearchList();
			}
			if($.isFunction(opener.doCallBack)){
				opener.doCallBack();
				
			}
			pageClose();
		}, 1000); */
	}
	
	function pageClose() {
		   self.opener = self;
		   self.close();
		   
	}
	
	// Submit CallBack
	function fnCallBackSubmit() {		
		setSubFrame(menuIndex);	
		// self.close();
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
	}  */
	
	function goItemPopUp(avg1,avg2){
		var param = {           
			olmLoginid : "${sessionScope.loginInfo.sessionLoginId}",
			languageID : "${sessionScope.loginInfo.sessionCurrLangType}",
			keyID : avg1,
			scrnType : "pop",
			linkID : avg2
		};
		
		fnPostWindowOpen('POST', '/olmChangeSetLink.do', param , 'pop');
	}
	
	function fnPostWindowOpen(verb, url, data, target) {     
		window.open("",target,"toolbar=no, width=1200, height=900, directories=no, status=no,scrollorbars=no, resizable=no"); 
        var form = document.createElement("form");
        form.action = url;
        form.method = verb;
        form.target = target;
        if (data) {
          for (var key in data) {
            var input = document.createElement("input");
            input.id = key;
            input.name = key;
            input.type = "hidden";
            input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
            form.appendChild(input);
          }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
	}

	/* function fnReApproval() {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = "${wfURL}.do";
		var data = "isNew=Y&wfDocType=${wfDocType}&isMulti=Y&isPop=Y&categoryCnt=1&preWfInstanceID="+$("#preWfInstanceID").val();
				
		ajaxPage(url,data,"wfInstListDiv");
	} */
	
	function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${srID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
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
			
		        <li class="floatR">  
		     	   <!-- 
					<c:if test="${wfInstInfo.Status == '3' }" >
						<span class="btn_pack medium icon"><span class="confirm"></span><input value="Re-Approval" onclick="fnReApproval();" type="button"></span>
					</c:if>
					 -->
					<!--  
		        	<c:if test="${screenType ne 'csrDtl' }">
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" onclick="goPrevious()" type="button"></span> 
		        	</c:if>
		        	 -->
					 <c:if test="${wfMode == 'CurAprv'}">
						<c:if test="${transYN eq 'Y' }">
							<span class="btn_pack medium icon mgR6"><span class="confirm"></span><input value="Transfer" onclick="fnOpenApprTransfer();" type="button"></span>
						</c:if>       
						<c:if test="${wfInstInfo.Status == '1' && stepSeq eq wfInstInfo.CurSeq}" >
							<span class="btn_pack medium icon mgR6"><span class="confirm"></span><input value="${actorWFStepName}" onclick="fnOpenApprComment('2','');" type="button"></span>
							<span class="btn_pack medium icon"><span class="cancel"></span><input value="Reject" onclick="fnOpenApprComment('3','5000694');" type="button"></span>
						</c:if>  
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
				<td class="alignL pdL10">${getPJTMap.WFInstanceID}</td>
				<!-- 문서유형 -->
				<th class="alignL pdL10">${menu.LN00091}</th>
				<td class="alignL pdL10 ">${getPJTMap.WFDocType}</td>	
				<!-- 기안자 -->
				<th class="alignL pdL10">${menu.LN00065}</th>
				<td class="alignL pdL10 last">${wfInstInfo.StatusName}</td>			
			</tr>	
			<tr>
				<th class="viewline alignL pdL10">${menu.LN00140}</th>
				<c:if test="${wfDocType ne 'SR'}"><td class="alignL pdL10" colspan = 3 ></c:if>
				<c:if test="${wfDocType eq 'SR'}"><td class="alignL pdL10 last" colspan = 5 ></c:if>
					${wfStepInstInfo}${wfInstInfo.Path}
				</td>	
				<c:if test="${wfDocType ne 'SR'}">	
					<th class="alignL pdL10">${menu.LN00045}</th>
					<td class="alignL pdL10 last">${wfStepInstRELInfo}</td>	
				</c:if>
			</tr>		
			<!-- tr>
				<th class="alignL pdL10">Agreement</th>
				<td class="last alignL pdL10"  colspan = 5>${wfStepInstAGRInfo}</td>
			</tr> -->	
			<tr>
				<th class="viewline alignL pdL10">${menu.LN00245}</th>
				<td class="alignL pdL10 last" colspan = 5>${wfStepInstREFInfo}</td>
			</tr>	
			<c:if test="${wfDocType ne 'SR'}">			
			<tr>
				<th class="viewline alignL pdL10">${menu.LN00117}</th>
				<td class="alignL pdL10 last" colspan = 5>${wfStepInstRECInfo}</td>
			</tr>	
			</c:if>							
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
				<!-- 제목  -->
				<th class="viewline alignL pdL10">${menu.LN00002}</th>				
				<c:if test="${wfDocType == 'PJT' || wfDocType == 'CSR'}">
					<td class="alignL pdL10 "  colspan = 3 >${getPJTMap.ProjectName}</td>
					<th class="alignL pdL10">CSR Code</th>
					<td class="alignL pdL10 last"   >
						<span OnClick="fnOpenCsrDetail();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${getPJTMap.ProjectCode}
							<input type="hidden" id="preWfInstanceID" name="preWfInstanceID" value="${getPJTMap.ProjectCode}" />
						</span>
					</td>
				</c:if>	
				<c:if test="${wfDocType == 'SR'}">
					<td class="viewline alignL pdL10 "  colspan = 3 >${getPJTMap.Subject}</td>
					<th class="alignL pdL10">SR Code</th>
					<td class="alignL pdL10 last"   >
						<span OnClick="fnSRDetail();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${getPJTMap.SRCode}
							<input type="hidden" id="preWfInstanceID" name="preWfInstanceID" value="${getPJTMap.ProjectCode}" />
						</span>
					</td>
				</c:if>	
				<c:if test="${wfDocType == 'CS'}">
					<td class="alignL pdL10 last"  colspan = 5 >${getPJTMap.Subject}</td>
				</c:if>
			</tr>
			<c:if test="${wfDocType == 'PJT' || wfDocType == 'CSR' }">
			<tr>	
				<th class="viewline alignL pdL10">
					${menu.LN00131}
				</th> 
			</c:if>	
			<c:if test="${wfDocType == 'SR'}">
			<tr>	
				<th class="viewline alignL pdL10">
					${menu.LN00131}
				</th> 
			</c:if>
			<c:if test="${wfDocType == 'PJT' || wfDocType == 'CSR' }">
				<td class="alignL pdL10" >
					${getPJTMap.Path}
				</td>
			</c:if>	
			<c:if test="${wfDocType == 'SR'}">
				<td class=" alignL pdL10" >
					${getPJTMap.SRType}
				</td>
			</c:if>		
		
			<c:if test="${wfDocType == 'PJT' || wfDocType == 'CSR'}">
			
				<th class="alignL pdL10">${menu.LN00063}</th>
				<td class="alignL pdL10">	
				${getPJTMap.StartDate}
				</td>
			</c:if>	
			<c:if test="${wfDocType == 'SR'}">
				<th class="alignL pdL10">${menu.LN00063}</th>
				<td class="alignL pdL10">	
				${getPJTMap.RegDate}
				</td>
			</c:if>		
		
			<c:if test="${wfDocType == 'PJT' || wfDocType == 'CSR'}">
			
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="alignL pdL10 last">	
				${getPJTMap.DueDate}
				</td>
			</tr>
			</c:if>	
			<c:if test="${wfDocType == 'SR'}">
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="alignL pdL10 last">	
				${getPJTMap.ReqDueDate}
				</td>
			</tr>
			</c:if>	
			
		 	<tr>
			 	<th class="viewline alignL pdL10">${menu.LN00035}</th>
				<td class=" alignL pdL10 last" colspan="5" style="width:100%;height:100px;">${getPJTMap.Description}</td>
			</tr>
			<c:if test="${wfDocType != 'SR'}">
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
	<c:if test="${wfInstInfo.DocCategory == 'CS' }">
	* Changed Item List
	<table class="tbl_brd mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="5%">
			<col width="5%">
		    <col width="10%">
		 	<col width="24%">
		    <col width="8%">
		 	<col width="8%">
		 	<col width="8%">
		 	<col width="8%">
		</colgroup>		
		<tr>
		  <th class="alignC">${menu.LN00024}</th> 
		  <th class="alignC">${menu.LN00017}</th> 
		  <th class="alignC">${menu.LN00106}</th> 
		  <th class="alignC">${menu.LN00028}</th>
		  <th class="alignC">${menu.LN00004}</th>
		  <th class="alignC">${menu.LN00022}</th>
		  <th class="alignC">${menu.LN00064}</th>
		  <th class="alignC">${menu.LN00296}</th>
		</tr>
		<c:forEach var="csInstList" items="${csInstList}" varStatus="status">
			<tr style="height:26px;">
				<td class="alignC last" >${csInstList.RNUM}</td>
				<td class="alignC last" >${csInstList.Version}</td>
				<td class="alignC last" >${csInstList.Identifier}</td>
				<td class="alignC last" ><span style="color:#0054FF;text-decoration:underline;cursor:pointer" onclick="goItemPopUp('${csInstList.ItemID}','${csInstList.ChangeSetID}')">${csInstList.ItemName}</span></td>
				<td class="alignC last" >${csInstList.AuthorName}</td>
				<td class="alignC last" >${csInstList.ChangeType}</td>
				<td class="alignC last" >${csInstList.CompletionDT}</td>
				<td class="alignC last" >${csInstList.ValidFrom}</td>
		</tr>
		</c:forEach>	
	</table>
	</c:if>
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
				<td class="sline tit last alignC " >${list.ActorName}</td>
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