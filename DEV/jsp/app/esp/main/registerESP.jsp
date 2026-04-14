<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
 
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${srAreaLabelNM1}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${srAreaLabelNM2}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00072}"/> <!-- 사용자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="요청 목적 및 사유"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" />
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var esType = "${esType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}";
	
	jQuery(document).ready(function() {
		
		// 00. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('#reqDueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
  		
		// 01. select option setting
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		fnSelectSetting();
  		
		// 02. customer change event
  		$("#customerNo").on("change", function(){
  			fnSelectSetting();
  		});
		
  		// 03. category change event
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 04. subCategory change event
  		$("#subCategory").on("change", function(){
  			var subCategory = $("#subCategory").val();
  			//fnGetSRArea1(subCategory);
  		});

  		// 05. srArea1 change event
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
		fnSelect('category', selectData +"&srType=${srType}&level=1&customerNo="+ $("#customerNo").val(), 'getESPSRCategory', '${category}', 'Select','esm_SQL');
		fnGetSubCategory('');
		// 02. srArea1 setting
		fnSelect('srArea1', selectData + "&srType=${esType}&customerNo=" + $("#customerNo").val(), srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
		fnGetSRArea2('');
	}

	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srType}&parentID="+parentID + "&customerNo=" + $("#customerNo").val(), 'getESPSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// srArea2 setting ( * customerNo / srArea1 )
	function fnGetSRArea2(SRArea1ID){
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		}else{
			if(srType != "REQ") selectData += "&srMode=myRole";
			fnSelect('srArea2', selectData+ "&parentID="+SRArea1ID + "&srType=${esType}&customerNo=" + $("#customerNo").val(), 'getSrArea2', '', 'Select');
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
	
	function fnCheckValidation(){
		var isCheck = true;		
		var srArea1 = $("#srArea1").val();
		var srArea2 = $("#srArea2").val();
		var category = $("#category").val();
		var subCategory = $("#subCategory").val();
		var subject = $("#subject").val();
		var opinion = $("#opinion").val();
		var description = tinyMCE.get('description').getContent();
		$("#description").val(description);
		
		var reqdueDate = $("#reqdueDate").val().replaceAll("-","");
		var currDate = "${thisYmd}";
		var requestUser = $("#requestUserID").val();
		
		if(requestUser == "" || requestUser == null ){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(srArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(srArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subCategory == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(reqdueDate == ""){alert("${WM00034_5}"); isCheck = false; return isCheck;}
		
		if(parseInt(reqdueDate) < parseInt(currDate) ){ 	
			alert("${WM00014}"); isCheck = false; return isCheck;
		} 
	 
		return isCheck;
	}
	
	/*** SR Button function start ***/
	// [Register]
	function fnSaveSR(startEventCode){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		var url  = "createESP.do";
		
		if(startEventCode!= null && startEventCode!= '' && startEventCode !== undefined){
			$("#startEventCode").val(startEventCode)
		}
		
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}
	
	// [List]
	function fnGoSRList(){ 
		var fromSRID = $("#fromSRID").val();
		var url = "espList.do";
		var data = "esType=${esType}&srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
				+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
				+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"; 
		var target = "mainLayer";
		
		ajaxPage(url, data, target);
	}

	// [요청자 팝업]
	function fnCheckRequest(){
		var checkObj = document.all("self");
		if( checkObj.checked == true){ 
			$("#searchRequestBtn").attr('style', 'display: none');
			$("#ReqUserNM").val("${sessionScope.loginInfo.sessionUserNm}");
			$("#requestUserID").val("${sessionScope.loginInfo.sessionUserId}");
			$("#customerNo").val("${sessionScope.loginInfo.sessionClientId}");
		} else {
			$("#searchRequestBtn").attr('style', 'display: done');
			$("#ReqUserNM").val("");
			$("#requestUserID").val("");
			$("#customerNo").val("");
		}
	}
	function searchPopupWf(avg){
		var searchValue = $("#ReqUserNM").val();
		if(searchValue == ""){
			alert("${WM00034_3}");
			return;
		}
		var url = avg + "&searchValue=" + encodeURIComponent($('#ReqUserNM').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7,avg8){
		$("#ReqUserNM").val(avg2+"("+avg3+")");
		$("#requestUserID").val(avg1);
		$("#customerNo").val(avg8);
		
		fnSelectSetting();
	}
	
	// [참조]
	function addSharer(){
		var sharers = $("#sharers").val();
		var url = "selectMemberPop.do?mbrRoleType=R&projectID=${projectID}&s_memberIDs="+sharers;
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
	}
	/*** SR Button function end ***/
	
	/*** SR Callback function start ***/
	function fnGoDetail(srID){ 
		var url = "processRFCP.do";
		var srType = "${srType}";
		if(srType == "REQ") url = "processVOCP.do";
		
		var data = "esType=${esType}&srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
				+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
				+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"
				+ "&srID=" + srID; 
		var target = "mainLayer";
		
		ajaxPage(url, data, target);
	}
	/*** SR Callback function end ***/
	
</script>
</head>

<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
</style>

<body>
<div>
	<form name="srFrm" id="srFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="esType" name="esType" value="${esType}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srStatus" name="srStatus" value="${srStatus}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="customerNo" name="customerNo" value="${sessionScope.loginInfo.sessionClientId}" />
	<input type="hidden" id="startEventCode" name="startEventCode" value="${startEventCode}">
	<div class="cop_hdtitle mgT">
		<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00280}</h3>
	</div>
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>		
		<tr>
		    <th class="alignL pdL10" style="height:15px;">${menu.LN00025}(&nbsp;self : <input type="checkbox" id="self" name="self" OnClick="fnCheckRequest()" checked>&nbsp;) </th>
		  	<td class="sline tit last" >
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${sessionScope.loginInfo.sessionUserNm}" style="ime-mode:active;width:250px;" />
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<input type="image" class="image" id="searchRequestBtn" name="searchRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL')" value="검색">
			</td>
			<th class="alignL pdL10">${menu.LN00212}</th>
			<td class="sline tit last">${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})</td>
		</tr>
		<tr>
			<!-- 접수자 Assign -->
			<th class="alignL pdL10" style="height:15px;">접수자</th>
			<td class="sline tit last">
				<input type="checkbox" id="receiveAssigned" name="receiveAssigned" value="true" checked> Assigned
			</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input type="text" id="reqDueDateTime" name="reqDueDateTime" class="input_off text" size="8" style="width:20%; text-align: center;" maxlength="10" value="18:00:00">
			</td>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;">
					<option value=''>Select</option>
				</select>
			</td>
			<th class="alignL pdL10">${menu.LN00273}</th>
			<td class="sline tit last">
				<select id="subCategory" name="subCategory" class="sel" style="width:250px;margin-left=5px;">
					<option value=''>Select</option>
				</select>
			</td>
		</tr>
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10">${srAreaLabelNM1}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<select id="srArea1" Name="srArea1" style="width:250px">
	       			<option value=''>Select</option>
	     	  	</select>
			</td>
			<!-- 시스템 -->
			 <th class="alignL pdL10">${srAreaLabelNM2}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="srArea2" Name="srArea2" style="width:250px">
         		   <option value=''>Select</option>
         		  </select>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th><!-- 제목 -->
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active; " />
			</td>
		</tr>		
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td style="height:300px;" class="tit last">
				<div style="width:100%;height:300px;"> 
					<textarea  class="tinymceText" id="description" name="description" ></textarea>					
				</div>
			</td>
		</tr>	
	</table>
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>	
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10" style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items" style="display:none;"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${itemFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
					<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></c:if>
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="sharerNames" name="sharerNames" />			
				<input type="hidden" class="text" id="sharers" name="sharers" size="10"/>
			</td>
		</tr>	
	</table>
	
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">	
	<tr> 
		 <th class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="4"  style="vertical-align:middle;" >
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="임시저장" type="submit" onclick="fnSaveSR()"></span>&nbsp;&nbsp;
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="서비스 요청 완료" type="submit" onclick="fnSaveSR('REQ0005')"></span>&nbsp;&nbsp;
		 </th>		 
	</tr>
	</table>
	<div class="alignR pdL10">${menu.LN00291}</div>

</form>
	
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>

<script>
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}	
	
</script>
</body>
</html>
