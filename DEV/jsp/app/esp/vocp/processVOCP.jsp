<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00273}"/> <!-- 서브카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00067}"/> <!-- 우선순위 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="Comment"/> <!-- Comment 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.LN00221}"/> <!-- 완료예정일  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_8" arguments="SR Classfication"/> <!-- SR Classfication  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00071" var="CM00071"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00171" var="WM00171"/>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var esType = "${esType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	var customerNo = "${srInfoMap.ClientID}";
	var srAre1 = "${srInfoMap.SRArea1}"
	
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=" + customerNo;

	jQuery(document).ready(function() {
		
		// 00. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('#dueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
		
		// 01. select option setting
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		fnSelectSetting();
		
  		// 02. category change event
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 03. subCategory change event
  		$("#subCategory").on("change", function(){
  			var subCategory = $("#subCategory").val();
  			//fnGetSRArea1(subCategory);
  		});

  		// 04. srArea1 change event
  		$("#srArea1").on("change", function(){
  			var srArea1 = $("#srArea1").val();
  			fnGetSRArea2(srArea1);
  		});
		
		
	});
	
	/*** SR Select function start ***/
	function fnSelectSetting() {
		// 00. reset
		resetSelect();
		// 01. category setting
		fnSelect('category', selectData +"&srType=${srType}&level=1", 'getESPSRCategory', '${srInfoMap.Category}', 'Select','esm_SQL');
		fnGetSubCategory('${srInfoMap.Category}');
		// 02. srArea
		fnGetSRArea1('${srInfoMap.Category}');
		fnGetSRArea2('${srInfoMap.SRArea1}')
	}

	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srType}&parentID="+parentID, 'getESPSRCategory', '${srInfoMap.SubCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// srArea1 setting ( * customerNo / subCategory )
	function fnGetSRArea1(category){
		if(category == ''){
			$("#srArea1 option").not("[value='']").remove();
		}else{
			fnSelect('srArea1', selectData + "&category=" + category + "&srType=${esType}", srArea1ListSQL, '${srInfoMap.SRArea1}', 'Select','esm_SQL');
			fnGetSRArea2('');
		}
	}
	
	// srArea2 setting ( * customerNo / srArea1 )
	function fnGetSRArea2(SRArea1ID){
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		}else{
			fnSelect('srArea2', selectData+ "&parentID="+SRArea1ID + "&srType=${esType}", 'getSrArea2','${srInfoMap.SRArea2}', 'Select');
		}
	}
	
	// select option reset
	function resetSelect(){
		$("#srArea1").val("");
		$("#srArea2").val("");
		$("#category").val("");
		$("#subCategory").val("");
		return;
	}
	/*** SR Select function end ***/
	
	/*** SR Button function start ***/
	// [Save]
	function fnSaveInfo(){
		var comment = tinyMCE.get('comment').getContent();
		if(comment == ""){ alert("${WM00034_6}"); return false;}
		
		$('#srMode').val('N');
		$('#srLogType').val('N');
		
		var priority = $("#priority").val() ; if(priority == ""){ $("#priority").val("03")}
		var url  = "updateESPInfo.do";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}

	// [Send Mail]
	function fnSendMailSR() {
		if(!confirm("${CM00071}")){
			return;
		}else {
			var url = "sendMailSRMST.do";
			var data = "&srID=${srInfoMap.SRID}&srType=${srType}";
			var target = "processSRDIV";
			ajaxPage(url, data, target);
		}
	}
	
	// [Receive]
	function fnReceive(url,varFilter){
		if(!confirm("${CM00001}")){ return;}

		var subCategory = $("#subCategory").val();
		var comment = tinyMCE.get('comment').getContent();
		
		if(subCategory == ""){ alert("${WM00034_4}"); return false;}
		if(comment == ""){ alert("${WM00034_6}"); return false;}
		
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Self - CheckOut]
	function fnSelfCheckOut(url,varFilter){		
		if(!confirm("${CM00054}")){ return;}
		url += "?srID=${srID}"  + varFilter; 
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Transfer]
	function fnOpenTransferESPPop(url,varFilter){ 	
		url += "?srID=${srInfoMap.SRID}&esType=${esType}&srType=${srType}&srArea1ListSQL=" + srArea1ListSQL + varFilter;
		window.open(url,'window','width=1100, height=320, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	// [Complete]
	function fnCompletion(url,varFilter){		
		if(!confirm("${CM00054}")){ return;}
		if(!fnCheckValidation()){return;}
		url += "?srRoleTP=${srInfoMap.ProcRoleTP}" + varFilter;
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Change]
	function fnChangeESPPop(url,varFilter){ 	
		url += "?srID=${srInfoMap.SRID}&esType=${esType}&srType=${srType}" + varFilter;
		window.open(url,'window','width=1100, height=320, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	// [참조]
	function addSharer(){
		var projectID = $("#projectID").val();
		var sharers = $("#sharers").val();
		
		var url = "selectMemberPop.do?mbrRoleType=R&projectID="+projectID+"&s_memberIDs="+sharers;
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
	}
	
	// [List]
	function fnGoSRList(){
		
		if("${option}" != "modifyCMP"){
			var url = "vocpList.do";
			var data = "srType=${srType}&esType=${esType}&scrnType=${scrnType}&srMode=${srMode}&pageNum=${pageNum}&projectID=${projectID}"
						+ "&status=${status}&category=${category}&subCategory=${subCategory}&subject=${subject}"
						+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
						+ "&regStartDate=${regStartDate}&regEndDate=${regEndDate}&searchSrCode=${searchSrCode}"
						+ "&stSRDueDate=${stSRDueDate}&endSRDueDate=${endSRDueDate}&stCRDueDate=${stCRDueDate}&endCRDueDate=${endCRDueDate}"
						+ "&srReceiptTeam=${srReceiptTeam}&crReceiptTeam=${crReceiptTeam}&searchStatus=${searchStatus}&srStatus=${srStatus}"
						+"&varFilter=${varFilter}&itemID=${itemID}&multiComp=${multiComp}&itemTypeCode=${itemTypeCode}&srArea1=${srArea1}&srArea2=${srArea2}";
		} else {
			var url = "processVOCP.do";
			var data = "srCode=${srInfoMap.srCode}&srID=${srInfoMap.SRID}"  
				+ "&srMode=${srMode}&esType=${esType}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}"
				+ "&projectID=${projectID}"
				+ "&itemID="+itemID + "&varFilter=${varFilter}&itemTypeCode=${itemTypeCode}"
				+ "&multiComp=${multiComp}"
				+ "&srStatus=${srStatus}&status=${status}"
				+ "&defCategory=${defCategory}&category=${category}&subCategory=${subCategory}"
				+ "&regStartDate=${regStartDate}&regEndDate=${regEndDate}&searchSrCode=${searchSrCode}"
				+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
				+ "&srReceiptTeam=${srReceiptTeam}&searchStatus=${searchStatus}"
				+ "&srArea1=${srArea1}&srArea2=${srArea2}"
				+ "&subject=${subject}"
				+ "&option=";
		}
		
		if( "${itemID}" == "" ) {
			if( "${projectID}" == "" ) var target = "mainLayer";
			else var target = "tabFrame";
		} else {
			var target = "actFrame";
		}
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		}
		ajaxPage(url, data, target);
	}
	/*** SR Button function end ***/
	
	/*** SR callback function start ***/
	function fnCallBackSR(){
		var url = "processVOCP.do";
		var data = "srCode=${srCode}&pageNum=${pageNum}&srMode=${srMode}&srType=${srType}&esType=${esType}&scrnType=${scrnType}"
						+"&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}&status=${status}&projectID=${projectID}"
						+"&itemID=${itemID}&varFilter=${varFilter}&searchStatus=${searchStatus}&srStatus=${srStatus}";
		if( "${itemID}" == "" ) {
			if( "${projectID}" == "" ) var target = "mainLayer";
			else var target = "tabFrame";
		} else {
			var target = "srListDiv";
		}
		
		if("${scrnType}"=="ITM"){
			target = "processSRDIV";
		}
		ajaxPage(url, data, target);
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		
		var category = $("#category").val() ;
		var comment = tinyMCE.get('comment').getContent();
		var dueDate = $("#dueDate").val() ; 
	
		if(category == ""){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(comment == ""){ alert("${WM00034_6}"); isCheck = false; return isCheck;}
		if(dueDate == ""){ alert("${WM00034_7}"); isCheck = false; return isCheck;}
		
		return isCheck;
	}
	
	function fnReload(){
		fnCallBackSR();
	}
	
	function fnCallBack(){
		fnCallBackSR();
	}
	/*** SR callback function end ***/
	
</script>
</head>
<body>
<div id="processSRDIV"> 
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="crCnt" name="crCnt" value="${crCnt}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}">
	<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<input type="hidden" id="srArea3" name="srArea3" value="">
	<input type="hidden" id="status" name="status" value="">	
	<input type="hidden" id="projectID" name="projectID" value="" >
	<input type="hidden" id="srRoleTP" name="srRoleTP" value="${srInfoMap.ProcRoleTP}" >
	<input type="hidden" id="srLogType" name="srLogType" value="" />
	
	
	<div class="cop_hdtitle">
		<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00282}</h3>
	</div>
	
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="23%">
		</colgroup>		
		<tr>
			<!-- 제목 -->
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit last" id="subject">${srInfoMap.Subject}</td>	
			<!-- 요청자 -->
			<th class="alignL pdL10" >${menu.LN00025}</th>
			<td class="sline tit last" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})</td>
		</tr>	
		<tr>
			<td colspan="4" class="tit last"><div style="height:230px; overflow: auto;" >${srInfoMap.Description}</div></td>
		</tr>
		<tr>	
			<!-- SR No -->
			<th class="alignL pdL10">${menu.LN00396}</th>
			<td class="sline tit last">${srInfoMap.SRCode}</td>
			<!-- 완료예정일 -->
			<th class="alignL pdL10">${menu.LN00221}</th>
			<td class="sline tit last" >
				<c:if test="${srInfoMap.DueDate !=  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.DueDate}"	class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.DueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
				<c:if test="${srInfoMap.DueDate ==  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.ReqDueDate}" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.ReqDueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
			</td>	
		</tr>
		<tr>
			<th class="alignL pdL10">프로세스 명</th>
			<td class="sline tit last">${srInfoMap.SRTypeName}</td>	
			<!-- SR status -->		
			<th class="alignL pdL10">${menu.LN00065}</th>
			<td class="sline tit last alignL " >
				<c:choose>
					<c:when test="${fn:length(procStatusList) > 0}">
						<c:forEach var="list" items="${procStatusList}" varStatus="statusList">	
						<c:choose>					
								<c:when test="${list.TypeCode == srInfoMap.Status && list.RNUM == prSeq }">
									<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
								</c:when>
								<c:otherwise>				
									<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
								</c:otherwise>				  
						</c:choose>	
						<c:if test="${statusList.last != true}">
							>&nbsp;
						</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						${srInfoMap.SRStatusName}
					</c:otherwise>
				</c:choose>
				
			</td>
		</tr>
		
		<c:choose>
			<c:when test="${srInfoMap.Status eq 'SPE001'}">
				<tr>
					<!-- 카테고리 -->
					<th class="alignL pdL10">${menu.LN00272}</th>
					<td class="sline tit last">
						<select id="category" name="category" class="sel"  style="width:90%;"></select>
					</td>
					<!-- 서브카테고리 -->
					<th class="alignL pdL10">${menu.LN00273}</th>
					<td class="sline tit last">
						<select id="subCategory" name="subCategory" class="sel" style="width:90%;"></select>
					</td>
				 </tr>
				<tr>
					<!-- SR Area 1 -->
					<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
					<td class="sline tit last" >
						<select id="srArea1" Name="srArea1"  style="width:90%"> <option value=''>Select</option></select>
					</td>		
					<!-- SR Area 2 -->
					<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
					<td class="sline tit last" >
						<select id="srArea2" Name="srArea2"  style="width:90%"> <option value=''>Select</option></select>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<!-- 카테고리 -->
					<th class="alignL pdL10">${menu.LN00272}</th>
					<td class="sline tit last">${srInfoMap.CategoryName eq null ? 'N/A' : srInfoMap.CategoryName}</td>
					<!-- 서브카테고리 -->
					<th class="alignL pdL10">${menu.LN00273}</th>
					<td class="sline tit last">${srInfoMap.SubCategoryName eq null ? 'N/A' : srInfoMap.SubCategoryName}</td>
				</tr>
				
				<tr>
					<!-- SRARea 1 -->
					<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
					<td class="sline tit last" >${srInfoMap.SRArea1Name eq null ? 'N/A' : srInfoMap.SRArea1Name}</td>
					<!-- SR Area 2 -->
					<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
					<td class="sline tit last" >${srInfoMap.SRArea2Name eq null ? 'N/A' : srInfoMap.SRArea2Name}</td>
				</tr>
			</c:otherwise>
		</c:choose>
			
	</table>
	
	
	<!-- comment 테이블 -->
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0">
		<colgroup>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		  	<th class="alignL pdL10">Comment</th>		  
			<td style="height:150px;" class="tit last alignL pdL5 pdR5">
				<div style="width:100%;height:150px;">
					<textarea class="tinymceText" id="comment" name="comment" >${srInfoMap.Comment}</textarea>
				</div>
			</td>
		</tr>
	</table>
	
	<!-- 첨부문서 & 참조 테이블  -->
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
			<col width="10%">
			<col>
		</colgroup>	
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10" style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${SRFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${SRFiles}" varStatus="status">
					<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						<c:if test="${sessionScope.loginInfo.sessionUserId == srInfoMap.RegUserID}">
						<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteSRFile('${fileList.SRID}','${fileList.Seq}','${fileList.FileName}','${srFilePath}');">
						</c:if>
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		<!-- 참조 -->
		<tr>
			<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="sharerNames" name="sharerNames" value="${srSharerName}" readOnly style="border:0px;"/>			
				<input type="hidden" class="text" id="sharers" name="sharers" value="${srSharerID}" size="10"/>
			</td>
		</tr>	
	</table>
	
	<div class="alignBTN">	
	   	<span class="btn_pack medium icon"><span class="list"></span><input value="Talk" type="submit"  onclick="fnForumList();"></span>		
	   	<!-- [Attach] [Save] ::: 만족도 평가 단계가 아닐 때 가능  -->
	   	<c:if test="${(srInfoMap.Status != 'SPE012' && srInfoMap.Status != 'SPE013')}" >
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4();"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveInfo()"></span>
		</c:if>
		
		<!-- ** EVENT BUTTON -->
	   	
	   	<c:forEach var="statusList" items="${nextStatusList}" varStatus="status">
		    <!-- [self CheckOut] :: 2선 이관 후 그룹원이 접수 시 -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00012' && checkOutYN eq 'Y'}">
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="self CheckOut" type="submit" onclick="fnSelfCheckOut('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
			</c:if>
		    <!-- [Receive/접수] 다음 단계의 프로그램 ID = PG00001 (담당자 접수) && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00001' && statusList.SRNextStatus ne srInfoMap.LastSpeCode }" >
				<span class="btn_pack medium icon">
					<span class="confirm"></span>
					<input value="Receive" type="submit" onclick="fnReceive('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')">
				</span>		
			</c:if>
			
			<!-- [Transfer/2선 이관] 상태 = 담당자 접수 / 1선 담당자 = sessionUserID / AuthLev == 3  --> 
		   	<c:if test="${(statusList.SRNextSpePgrID eq 'PGR00011')}" >
		   		<span class="btn_pack medium icon">
		   			<span class="gov"></span>
		   			<input value="Transfer" type="submit" onclick="fnOpenTransferESPPop('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}');">
		   		</span>  
		   	</c:if>
			
			<!-- [Complete/완료] ::: 다음 단계의 프로그램 ID = PG00002 (ITS 조치완료) && 상태 != 완료   -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00002' && srInfoMap.SvcCompl eq 'N'}" >
				<span class="btn_pack medium icon">
					<span class="confirm"></span>
					<input value="Complete" type="submit" onclick="fnCompletion('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')">
				</span>
			</c:if>	
			
			<!-- [Change/변경] ::: 다음 단계의 프로그램 ID = PG00013 (프로그램 변경) && 상태 != 완료   -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00013' && srInfoMap.SvcCompl eq 'N'}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Change" type="submit" onclick="fnChangeESPPop('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>		
			</c:if>
		
	   	</c:forEach>
		
		
	    
	    
	    <!-- ** BASIC BUTTON -->
		<!-- [Send Mail/메일발송] ::: 상태 != ITS 조치완료 && 만족도 평가완료 ( 화면 상 내용 x , 저장된 내용으로 ) -->
		<c:if test="${(srInfoMap.Status != 'SPE012' && srInfoMap.Status != 'SPE013') && option ne 'modifyCMP'}" >
			<span class="btn_pack small icon"><span class="word"></span><input value="Send Mail" type="submit" onclick="fnSendMailSR();"></span>
		</c:if>

		<!-- [Back/뒤로가기] ::: 팝업이 아닐 때  -->
		<c:if test="${isPopup != 'Y'}" >
			<span id="viewList" class="btn_pack medium icon"><span class="pre" style="filter: grayscale(100%); opacity:88%;"></span><input value="Back" type="submit"  onclick="fnGoSRList();"></span>
		</c:if>	
			
	</div>
	
	<!-- Log -->	
	<div id="forumListDiv" style="width:100%;"></div>
</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>

<script>
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
	var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
	ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
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
	var originalFileName = new Array();
	var sysFileName = new Array();
	var filePath = new Array();
	var seq = new Array();
	seq[0] = avg1;
	var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
	ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
}
//************** addFilePop V4 설정 START ************************//

function doAttachFileV4(){
	var url="addFilePopV4.do";
	var data="scrnType=SR&fltpCode=SRDOC";
	openPopup(url+"?"+data,490,450, "Attach File");
}

var fileIDMapV4 = new Map();
var fileNameMapV4 = new Map();
function fnAttacthFileHtmlV4(fileID, fileName){ 
	fileID = fileID.replace("u","");
	fileIDMapV4.set(fileID,fileID);
	fileNameMapV4.set(fileID,fileName);
}

// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
function fnDeleteFileMapV4(fileID){ 
	fileID = fileID.replace("u","");		
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
}

function fnDisplayTempFileV4(){				
	display_scripts=$("#tmp_file_items").html(); 
	fileIDMapV4.forEach(function(fileID) {			  
		  display_scripts = display_scripts+
			'<div id="'+fileID+'"  class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
				'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+')">'+
				'	<br>'+
				'</div>';		
	});
	document.getElementById("tmp_file_items").innerHTML = display_scripts;		
	$("#tmp_file_items").attr('style', 'display: done');

	fileIDMapV4 = new Map();
	fileNameMapV4 = new Map();
}
 
//  dhtmlx v 4.0 delete file  
function fnDeleteFileHtmlV4(fileID){		
	var fileName = document.getElementById(fileID).innerText;		
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
	
	if(fileName != "" && fileName != null && fileName != undefined){
		$("#"+fileID).remove();
		var url  = "removeFile.do";
		var data = "fileName="+fileName;	
		ajaxPage(url,data,"blankFrame");
	}
} 
//************** addFilePop V4 설정 END ************************//
</script>

</body>
</html>