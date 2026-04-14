<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
 
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css">

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="${menu.LN00021}"/> <!-- 항목 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('itemTypeCd',data+"&level=1", 'getItemTypeListBySRType', '', 'Select', 'esm_SQL');
		fnSelect('srArea1', data + "&itemTypeCode=${itemTypeCode}", srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
		fnSelect('srReason', data+"&category=SRRSN", 'getDictionaryOrdStnm', '${srInfoMap.SRReason}', 'Select');
	//	fnSelect('category',data+"&level=1", 'getESMSRCategory', '', 'Select', 'esm_SQL');
		
	//	$('#reqDueDateTime').timepicker({
    //        timeFormat: 'H:i:s',
    //    });
		
		if("${itemID}" != null && "${itemID}" != ""){
			$("#actFrame").css("overflow-y","auto");
			fnSelect('category',data+"&level=1&itemTypeCode=${itemTypeCode}", 'getESMSRCategory', '', 'Select', 'esm_SQL');
		}
		
		if("${ProjectID}" != null && "${ProjectID}" != ""){
			fnSelect('category',data+"&level=1", 'getESMSRCategory', '', 'Select', 'esm_SQL');
		}
	});
	
	function fnCheckValidation(){
		var isCheck = true;
	//	var category = $("#category").val();
		var subject = $("#subject").val();
		var itemTypeCd = $("#itemTypeCd").val();
		var description = tinyMCE.get('description').getContent();				
  //	var reqdueDate = $("#reqdueDate").val().replaceAll("-","");
		var currDate = "${thisYmd}";
		var requestUser = $("#requestUserID").val();
		
		if(requestUser == "" || requestUser == null ){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(itemTypeCd == "" ){ alert("${WM00034_6}"); isCheck = false; return isCheck;}
	//	if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
	//	if(reqdueDate == ""){alert("${WM00034_5}"); isCheck = false; return isCheck;}
				
	//	if(parseInt(reqdueDate) < parseInt(currDate) ){ 	
	//		alert("${WM00014}"); isCheck = false; return isCheck;
	//	} 
	 
		return isCheck;
	}
	
	function fnSaveSR(){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		var url  = "createESRMst.do";
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}

	function fnGoSRList(){ 
		if( "${itemID}" == "" ) {
			if("${ProjectID}" == ""){
				var url = "ispList.do";
				var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}&category=${srCategory}&searchSrCode=${searchSrCode}"
									+ "&itemProposal=${itemProposal}&subject=${subject}&varFilter=${varFilter}&itemID=${itemID}&defCategory=${defCategory}";
				var target = "mainLayer";
				ajaxPage(url, data, target);
			} else {
				var url = "ispList.do";
				var data = "projectID=${ProjectID}&srType=ISP&srMode=PJT";
				var target = "tabFrame";
				ajaxPage(url, data, target);
			}
		} else {
// 			var target = "actFrame";
			fnItemMenuReload();
		}
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
	
// 	function fnGetTreePop(){
// 		var url = "searchRootItemTreePop.do";
// 		var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}&conTypeCode=CN00001";
		
// 		fnOpenLayerPopup(url,data,doCallBackMove,617,436);
// 	}
	
	function doCallBackMove(){}
	
	function fnCheckRequest(){
		var checkObj = document.all("self");
		if( checkObj.checked == true){ 
			$("#searchRequestBtn").attr('style', 'display: none');
			$("#ReqUserNM").val("${sessionScope.loginInfo.sessionUserNm}");
			$("#requestUserID").val("${sessionScope.loginInfo.sessionUserId}");
		} else {
			$("#searchRequestBtn").attr('style', 'display: done');
			$("#ReqUserNM").val("");
			$("#requestUserID").val("");
		}
	}
	
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
		fnSelect('srArea2', data, 'getSrArea2', '', 'Select');
	}
	
	function setSearchNameWf(avg1,avg2,avg3){
		// window.opener.setSearchNameWf(avg1, avg2, avg3, $('#objId').val(), $('#objName').val());
		$("#ReqUserNM").val(avg2+"("+avg3+")");
		$("#requestUserID").val(avg1);
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
	
	function fnGetSRCategory(itemTypeCode){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srType}";
		fnSelect('category',data+"&level=1&itemTypeCode="+itemTypeCode, 'getESMSRCategory', '', 'Select', 'esm_SQL');
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
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}" />
	<input type="hidden" id="proposal" name="proposal" value="${proposal}" />
	<input type="hidden" id="itemIDs" name="itemIDs" value="" />
	<input type="hidden" id="varFilter" name="varFilter" value="${varFilter }" />
	<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${itemTypeCode}" />
	<input type="hidden" id="projectID" name="projectID" value="${ProjectID}" />
	<input type="hidden" id="category" name="category" value="${category}" />
	<input type="hidden" id="defCategory" name="defCategory" value="${defCategory}" />
	<input type="hidden" class="text" id="rootItemID" name="rootItemID" value="${itemID}"/>
	<c:choose>
	<c:when test="${itemID eq '' || itemID eq null}">
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;Register Issue</h3>
		</div>
	</c:when>
	<c:otherwise>
		<div class="child_search01 pdL10">
			<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;<b>Register Issue</b>
		</div>
	</c:otherwise>
</c:choose>
	
	<table class="tbl_brd mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
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
			<!-- SR Area 1 -->
			<th class="alignL pdL10">${srAreaLabelNM1}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:250px">
	       			<option value=''>Select</option>
	     	  	</select>
			</td>
			 <!-- 이슈 원인 -->
			<th class="alignL pdL10">주요 원인</th>			
			<td class="sline tit last">	
				<select id="srReason" name="srReason" class="sel" style="width:90%;margin-left=5px;"></select>
		    </td>		
		</tr>
		
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th><!-- 제목 -->
			<td class="sline tit last" >
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active;" />
			</td>
			  <!-- IT 연계 SR_MST.itsmIF 값을 Y or N으로 출력 -->
			<th class="alignL pdL10">IT 지원</th>			
			<td class="sline tit last">	
				<select id="itsmIF" name="itsmIF" class="sel" style="width:90%;margin-left=5px;">
					<option value="">Select</option>
					<option value="Y">Y</option>
					<option value="N" >N</option>
				</select>
		    </td>	
			
		</tr>
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td style="height:300px;" class="tit last">
				<div style="width:100%;height:300px;">
					<textarea class="tinymceText" id="description" name="description" ></textarea>		
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
				<div id="tmp_file_items" name="tmp_file_items"></div>
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
			<!-- span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span -->
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="fnSaveSR()"></span>&nbsp;&nbsp;
		 </th>		 
	</tr>
	</table>
	<div class="alignR pdL10">${menu.LN00291}</div>

	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
