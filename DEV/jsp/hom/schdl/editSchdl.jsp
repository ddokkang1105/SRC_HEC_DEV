<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM000341" arguments="${menu.LN00002}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM000342" arguments="${menu.LN00063}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM000343" arguments="${menu.LN00324}${menu.LN00335}"/>
<!-- 시작시간  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM000344" arguments="${menu.LN00233}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM000345" arguments="${menu.LN00325}${menu.LN00335}"/>
<!-- 종료시간  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00131}"/>

<script type="text/javascript">
	var schdlType = "${schdlType}";
	var mySchdl = "${mySchdl}";
	var chkReadOnly = false;
	var isReadOnly = "N";
	var userID = "${sessionScope.loginInfo.sessionUserId}";
	var regUserID = "${resultMap.RegUserID}";
	var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
	var screenType = "${screenType}";
	var sessionMlvl = "${sessionScope.loginInfo.sessionMlvl}";
	var projectAuthorID = "${projectMap.ProjectAuthorID}";
		
	
	if(screenType == "mainV3"){
		if(sessionMlvl == 'SYS' || projectAuthorID == userID){
			isReadOnly = "N";
			chkReadOnly = false;
		}else{
			isReadOnly = "Y";
			chkReadOnly = true;
		}		
	}else{
		if(userID == regUserID && authLev < 3){
			isReadOnly = "N";
			chkReadOnly = false;
		}else{ 
			isReadOnly = "Y";
			chkReadOnly = true;
		}
	}
	
</script>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript">
if("${parentID}" == null || "${parentID}" == ''){
	var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('project', data, 'getProject', '${resultMap.ProjectID}','Select'); 
}else{
	$("#project").attr('disabled', 'disabled: disabled');
}
fnRadio('disclScopeList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=DISCSCP&radioID=disclScope','getDictionary','${resultMap.disclScope}','disclScope','N');
	$(document).ready(function(){
		var categoryData = "&category=DOCCAT&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode='${docCategory}'";
		fnSelect('docCategory',categoryData,'getDictionary',('${resultMap.docCategory}' == '' ? '${docCategory}' : '${resultMap.docCategory}'),'Select');
		
		$("input.datePicker").each(generateDatePicker);
		$('#start_time, #end_time').timepicker({
            timeFormat: 'H:i',
            minTime : '08:00am',
            maxTime : '08:00pm',
        });
 
/* 		if("${parentID}" == null || "${parentID}" == ''){
			var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('project', data, 'getProject', '${resultMap.ProjectID}','Select'); 
		}else{
			$("#project").attr('disabled', 'disabled: disabled');
		}
 */
 		if(isReadOnly == "Y"){
			$("#Subject").attr('disabled', 'disabled: true'); $("#Subject").attr('style', 'background-color:#fff');
			$("#Location").attr('disabled', 'disabled: true'); $("#Location").attr('style', 'background-color:#fff');
			$("#start_time").attr('disabled', 'disabled: true');	
			$("#end_time").attr('disabled', 'disabled: true');	
			//$("#project").attr('disabled', 'disabled: true');	
			$("#Content").attr('disabled', 'disabled: true');	
			$("#SC_END_DT").attr('disabled', 'disabled: true');
			$("#SC_STR_DT").attr('disabled', 'disabled: true');
		}
		$( "#alarmOption" ).change(function() {
			setScheduleAlarm();
		});
		
		$(document).on('change', 'input[type=radio][name=disclScope]', function (event) {
			var radioValue = $(this).val();
			$('input:radio[name="disclScope"]:checked').prop("checked", false);
			if( radioValue == "PJT"){
				$("#project").css("display","");
				$("#pjtName").css("display","");
			}else{
				$("#project").val("");
				$("#projectName").val("");
				$("#project").css("display","none");
				$("#pjtName").css("display","none");
			}
		    $('input:radio[name=disclScope]:input[value=' + radioValue + ']').prop("checked", true);
		    
		});
		
		var timer = setTimeout(function() {
			if("${resultMap.ProjectID}" == "" || "${resultMap.disclScope}" != "PJT"){
				$("#project").css("display","none");	
			}
			$("#disclScopeList").css("display","inline-block");
		}, 250); //1000 = 1초
	});
	
	function setScheduleAlarm(){
		if($("#SC_STR_DT").val() == "" || $("#start_time").val() == ""){
			$("#alarmOption").val("");
			alert("${WM00166}");
			return false;
		}
		var start_time = new Date($("#SC_STR_DT").val() + " " + $("#start_time").val());
		var end_time = new Date($("#SC_END_DT").val() + " " + $("#end_time").val());
		if($("#alarmOption").val() != ""){
			start_time.setMinutes(start_time.getMinutes() - $("#alarmOption").val());
			end_time.setMinutes(end_time.getMinutes() - $("#alarmOption").val());
			$("#startAlarm").val(DateToString(start_time));
			$("#endAlarm").val(DateToString(end_time));
		}else{
			$("#startAlarm").val("");
			$("#endAlarm").val("");
		}
	}
	
	function DateToString(pDate) {
	    var yyyy = pDate.getFullYear();
	    var mm = pDate.getMonth() < 9 ? "0" + (pDate.getMonth() + 1) : (pDate.getMonth() + 1); // getMonth() is zero-based
	    var dd  = pDate.getDate() < 10 ? "0" + pDate.getDate() : pDate.getDate();
	    var hh = pDate.getHours() < 10 ? "0" + pDate.getHours() : pDate.getHours();
	    var min = pDate.getMinutes() < 10 ? "0" + pDate.getMinutes() : pDate.getMinutes();
	    return "".concat(yyyy).concat("-").concat(mm).concat("-").concat(dd).concat(" ").concat(hh).concat(":").concat(min);
	};
	
	function fnSave(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		setScheduleAlarm();
		
		var projectName = ($("#project").val() == '' ? $("#project").val() : $("#project option:selected").text());
		$("#projectName").val(projectName);
		var radioValue = $('input:radio[name="disclScope"]:checked').val();
		var disclScopeName = $("label[for='"+radioValue+"']").text();		
		$("#disclScopeName").val(disclScopeName);
		if(radioValue == "PJT" && $("#project").val() == ""){
			alert("${WM00025}");
			return false;
		}
		var alarmOptionName = ($("#alarmOption").val() == '' ? $("#alarmOption").val() : $("#alarmOption option:selected").text());
		$("#alarmOptionName").val(alarmOptionName);
		
		var url  = "updateSchedulDetail.do";
		ajaxSubmit(document.schedlFrm, url);
	}
	
	function fnCheckValidation(){
		var isCheck = true;

		var startDate = $("#SC_STR_DT").val().replaceAll("-","");
		var endDate = $("#SC_END_DT").val().replaceAll("-","");
		var starttime = $("#start_time").val().replaceAll(":","");
		var endtime = $("#end_time").val().replaceAll(":","");
		if($("#Subject").val() == ""){alert("${WM000341}");return false;}
		if(startDate == ""){alert("${WM000342}");return false;}
		if(starttime == ""){alert("${WM000343}");return false;}
		if(endDate == ""){alert("${WM000344}");return false;}
		if(endtime == ""){alert("${WM000345}");return false;}
		
		if(parseInt(startDate+starttime) > parseInt(endDate+endtime)){					
			alert("${WM00132}"); return;					
		}
		
		//if($("#project").val() == ""){alert("${WM00025}");return false;}
		if(!fnTypingCheck("Content", 5000)){ return false;}			
		
		return isCheck;
	}
	
	// 삭제 
	function fnDelete(){
		$add("scheduleId", "${resultMap.ScheduleID}", schedlFrm);
		if(confirm("${CM00002}")){
			var url = "deleteSchdlDetail.do";
			ajaxSubmit(document.schedlFrm, url);
		}
	}
	/* 
	function fnGoList(){
		var url = "goSchdlList.do";
		var data, target = "";
		if(screenType == "mainV3"){
			data="pageNum=${pageNum}&screenType=${screenType}&parentID=${parentID}";
			target = "help_content";
		}else{
			data += "&schdlType="+schdlType+"&mySchdl="+mySchdl;
			target = (mySchdl == "Y" ? "help_content" : "subBFrame");
		}
		ajaxPage(url, data, target);
	}
	 */
	
	 function selfClose(returnflag){
		self.close();
		if(returnflag == "T"){window.opener.doSearchList();}
	 }
	 
	// [Add] 버튼 Click
	function addSharer(){
		var projectID = $("#project").val();
		var sharers = $("#sharers").val();
		
		//var url = "selectMemberPop.do?docCategory=SCH&projectID="+projectID+"&s_memberIDs="+sharers;
		var url = "selectMemberPop.do?mbrRoleType=R&&s_memberIDs="+sharers;
		window.open(url,"schedlFrm","width=900 height=700 resizable=yes");			
		
	}
	
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
		$("#sharerNamesText").text(memberNames);
	}
	
	//browser detect
	var browser = (function() {
	var s = navigator.userAgent.toLowerCase();
	var match = /(webkit)[ \/](\w.]+)/.exec(s) ||
	              /(opera)(?:.*version)?[ \/](\w.]+)/.exec(s) ||
	              /(msie) ([\w.]+)/.exec(s) ||               
	              /(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) ||
	             [];
	  return { name: match[1] || "", version: match[2] || "0" };
	}());

	function doAttachFile(){
		var browserType="";
		if(browser.name == 'msie'){browserType="IE";}
		var url="addFilePop.do";
		var data="scrnType=SCHDL&browserType="+browserType+"&fltpCode=SCHDOC";
		
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	function fnDeleteItemFile(realFile, seq, tempF){
		var url = "deleteSCHDLFile.do";
		var data = "realFile="+realFile;
		if(tempF == 'F'){data+="&scheduleId=${resultMap.ScheduleID}&fltpCode=SCHDOC&Seq="+seq;}
		ajaxPage(url, data, "blankFrame");
		$('#divDownFile'+seq).remove();	
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
		//alert(url);
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
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
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}
	
	//스케쥴 상세화면 이동
	function goSchdlDetail(scheduleId){ 
		var url = "selectSchedulDetail.do?";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&scheduleId="+scheduleId;
		data += "&schdlType="+schdlType+"&mySchdl="+mySchdl;
		ajaxSubmitNoAdd(document.schedlFrm, url,"");		
	}
	
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SCHDL&fltpCode=SCHDOC";
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
<style>
	a:hover{
		text-decoration:underline;
		cursor:pointer;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
	
</style>
<!-- BEGIN :: DETAIL -->
<div class="mgT10 mgL10 mgR10">
<form name="schedlFrm" id="schedlFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="userId" 		name="userId" 		value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="scheduleId" 	name="scheduleId" 	value="${resultMap.ScheduleID}">
	<input type="hidden" id="usergroupId" 	name="usergroupId" 	value="${resultMap.usergroupId}">
	<input type="hidden" id="templCode" 	name="templCode" 	value="${resultMap.templCode}">
	<input type="hidden" id="regDT" 	name="regDT" 	value="${resultMap.RegDT}">
	<input type="hidden" id="MLVL" 			name="MLVL" 		value="${resultMap.MLVL}">
	<input type="hidden" id="pageNum" 		name="pageNum" 		value="${pageNum}">	
	<input type="hidden" id="parentID" name="parentID" value="${parentID}">
	<input type="hidden" id="screenType" name="screenType" value="${screenType}">

	<div class="cop_hdtitle mgB5" style="border-bottom:1px solid #ccc;">
		<h3 style="padding: 0 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_schedule.png">&nbsp;&nbsp;Schedule&nbsp;
		${menu.LN00103}       
	   </h3>
	</div>
	<table class="tbl_brd mgT5" id="" style="" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
			<col width="35%">
			<col width="15%">
			<col width="35%">
		</colgroup>
		<tr>
			<th>${menu.LN00002}</th>
			<td  class="tit last" colspan="3">
				<input type="text" class="text" id="Subject" name="Subject" value="${resultMap.Subject}" size="10"/>
			</td>
		</tr>	
		<tr>
			<th>${menu.LN00336}</th>
			<td  class="tit last" colspan="3">
				<textarea id="Content" name="Content" style="width:98%; height:70px; border: 1px solid #ddd;" >${resultMap.Content}</textarea>
			</td>
		</tr>	
		<tr>
			<th>${menu.LN00237}</th>
			<td  class="tit last" colspan="3">
				<input type="text" class="text" id="Location" name="Location" value="${resultMap.Location}" size="10"/>
			</td>
		</tr>
		<tr>
			<th>${menu.LN00324}</th>
			<td  class="tit">
				<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
				 
					<input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${resultMap.start_date}"	class="text datePicker" size="10"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input name="start_time" id="start_time" value="${resultMap.startTime}" style="width: 60px;">
			</td>
			<th>${menu.LN00325}</th>
			<td class="tit last" align="left">
				 
					<input type="text" id=SC_END_DT	name="SC_END_DT" value="${resultMap.end_date}"	class="text datePicker" size="10"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input name="end_time" id="end_time" value="${resultMap.endTime}" style="width: 60px;">
			</td>
		</tr>
		<tr>
			<th>${menu.LN00337}</th>
			<td  class="tit">
				<div id="disclScopeList" style="padding-bottom:5px;"></div>
				<input type="hidden" class="text" id="disclScopeName" name="disclScopeName" value=""/>
				<c:choose>
					<c:when test="${parentID ne null && parentID ne ''}">
						<span id="pjtName" <c:if test="${resultMap.disclScope ne 'PJT'}">style="display:none;"</c:if> >&nbsp;&nbsp;/&nbsp;&nbsp;${projectMap.ProjectName}</span>
						<input type="hidden" id="project" name="project" value="${projectMap.ProjectID}">
					</c:when>
					<c:when test="${parentID eq null || parentID eq ''}">
						<select id="project" name="project">
							<option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option>
						</select>	
					</c:when>
				</c:choose>
				<input type="hidden" class="text" id="projectName" name="projectName" value="${projectMap.ProjectName}" size="10"/>
			</td>
			<th>
				${menu.LN00334}
			</th>
			<td  class="tit last">
				<select id="alarmOption" name="alarmOption" class="sel">
					<option value="" <c:if test="${resultMap.alarmOption == ''}">selected="true"</c:if>>N/A</option>
					<option value="30" <c:if test="${resultMap.alarmOption == '30'}">selected="true"</c:if>>30 minutes</option>
					<option value="60" <c:if test="${resultMap.alarmOption == '60'}">selected="true"</c:if>>1 hour</option>
				</select>
				<input type="hidden" class="text" id="alarmOptionName" name="alarmOptionName" value="" size="10"/>
				<input type="hidden" class="text" id="startAlarm" name="startAlarm" value="${resultMap.startAlarm}" size="10"/>
				<input type="hidden" class="text" id="endAlarm" name="endAlarm" value="${resultMap.endAlarm}" size="10"/>
			</td>
		</tr>
		<tr id="share">
			<th>
				<a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a>
			</th>
			<td  class="tit">
				<div style="overflow-y:scroll; height:35px; width:100%">
					<span id="sharerNamesText">${resultMap.sharerNames}</span>
				</div>
				<input type="hidden" class="text" id="sharerNames" name="sharerNames" value="${resultMap.sharerNames}" size="5" readonly/>			
				<input type="hidden" class="text" id="sharers" name="sharers" value="${resultMap.sharers}" size="10"/>
			</td>
			<th>${menu.LN00033}</th>
			<td  class="tit last">		
				${resultMap.docCategoryName}<c:if test="${!empty(resultMap.docNO)}">&nbsp;&nbsp;/&nbsp;&nbsp;${resultMap.docNO}</c:if>
				<input type="hidden" class="text" id="docCategory" name="docCategory" value="${resultMap.docCategory}"/>
				<input type="hidden" class="text" id="docCategoryName" name="docCategoryName" value="${resultMap.docCategoryName}"/>
				<input type="hidden" class="text" id="docNO" name="docNO" value="${resultMap.docNO}"/>
			</td>
		</tr>
		<tr>
			<!-- 첨부문서 -->
			<th>${menu.LN00111}</th>
			<td colspan="5" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${schdlFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${schdlFiles}" varStatus="status">
					<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.FileName}','${fileList.Seq}','F')"></c:if>
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		
	</table>
	
		<div class="alignBTN">		
			<c:if test="${screenType != 'mainV3'}">		
				<c:if test="${(sessionScope.loginInfo.sessionUserId == resultMap.RegUserID && sessionScope.loginInfo.sessionAuthLev < 4)}">
				<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
				<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="button" onclick="fnSave()"></span>&nbsp;&nbsp;				
				</c:if>
				<c:if test="${(sessionScope.loginInfo.sessionUserId == resultMap.RegUserID && sessionScope.loginInfo.sessionAuthLev < 4)}">
					<span id="viewDel"  class="btn_pack medium icon"><span class="delete"></span><input value="Del" type="button" onclick="fnDelete()"></span>&nbsp;&nbsp;
				</c:if>
			</c:if>
			<c:if test="${screenType == 'mainV3'}">	
				<c:if test="${projectMap.ProjectAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionMlvl < 3}">
				<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
				<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="button" onclick="fnSave()"></span>&nbsp;&nbsp;				
				</c:if>
				<c:if test="${(projectMap.ProjectAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionMlvl < 3) }">	
					<span id="viewDel"  class="btn_pack medium icon"><span class="delete"></span><input value="Del" type="button" onclick="fnDelete()"></span>&nbsp;&nbsp;
				</c:if>
			</c:if>
		
			<!-- <span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="button"  onclick="fnGoList()"></span> -->
			<span id="close" class="btn_pack medium icon"><span class="close"></span>
				<input value="Close" type="submit" onclick="selfClose('F')" />
			</span>
		</div>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>