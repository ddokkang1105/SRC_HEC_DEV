<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<!--  script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script-->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var srType = "${srType}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		jQuery("#Subject").focus();

		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data, 'getSrArea1', '', 'Select');
		fnSelect('category',data+"&level=1", 'getSrCategory', '', 'Select');
	});
	
	function fnSaveSRCR(){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		var url  = "saveNewSRCR.do";
		ajaxSubmit(document.regiSRCRFrm, url,"saveFrame");
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var srArea1 = $("#srArea1").val();
		var srArea2 = $("#srArea2").val();
		var category = $("#category").val();
		var subject = $("#subject").val();
		var description = $("#description").val();
		
		if(srArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(srArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		//if(description == ""){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		
		return isCheck;
	}
	
	function doDelete(){
		if(confirm("${CM00002}")){
			var url = "deleteBoard.do";
			ajaxSubmit(document.boardFrm, url,"saveFrame");
		}
	}	

	function fnGoSRList(){ 
		var url = "srList.do";
		var data = "srType=${srType}&screenType=${screenType}&srMode=${srMode}"; 
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		//if($.browser.mozilla){browserType="MZL";}else if($.browser.mozilla){browserType="MZL";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		//fnOpenLayerPopup(url,data,"",400,400);
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,360,360, "Attach File");}
	}
	
	function fnDeleteItemFile(BoardID, seq){
		var url = "boardFileDelete.do";
		var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");
		
		fnDeleteFileHtml(seq);
	}
	
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
		
		//$('#divFileImg').hide();
		
	}
	function fnAttacthFileHtml(seq, fileName){ 
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
			'	<br>'+
			'</div>';		
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
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
	
	function searchPopupWf(avg){	
		var url = avg + "&searchValue=" + encodeURIComponent($('#ReqUserNM').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3){
		$("#ReqUserNM").val(avg2+"("+avg3+")");
		$("#requestUserID").val(avg1);
	}
	
</script>
</head>

<body>
<div>
	<form name="regiSRCRFrm" id="regiSRCRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="screenType" name="screenType" value="${screenType}">
	<input type="hidden" id="srMode" name="srMode" value="">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00280}(with CR) </h3>
	</div>
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>		
		<tr>
		    <th class="alignL pdL10">${menu.LN00025}</th>
			<td class="sline tit last" >
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="" style="ime-mode:active;width:250px;" />
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<input type="image" class="image" id="searchRequestBtn" name="searchRequestBtn"  src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL')" value="검색">
			</td>
			<!-- 등록자 -->
			<th class="alignL pdL10">${menu.LN00212}</th>
			<td class="sline tit last">${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})</td>
		</tr>
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10"><font color="red">*</font> ${menu.LN00274}</th>
			<td class="sline tit last" >
				<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:250px">
	       			<option value=''>Select</option>
	     	  	</select>
			</td>
			<!-- 시스템 -->
			 <th class="alignL pdL10"><font color="red">*</font> ${menu.LN00185}</th>
			<td class="sline tit last">
				<select id="srArea2" Name="srArea2" style="width:250px">
         		   <option value=''>Select</option>
         		  </select>
			</td>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10"><font color="red">*</font> ${menu.LN00272}</th>
			<td class="sline tit last">
				<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
			</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}</th>
			<td class="sline tit last" >${thisYmd}</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th><!-- 제목 -->
			<td class="sline tit last" colspan="3" >
				<input type="text" class="text" id="subject" name="subject" value="${resultMap.Subject}" style="ime-mode:active;width:80%" />
			</td>
		</tr>
		
		<tr>
			<th class="alignL pdL10">${menu.LN00035}</th><!-- 개요 -->
			<td colspan="3" style="height:180px;" class="tit last">
					<textarea class="edit" id="description" name="description" style="width:99%;height:200px;"></textarea>					
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
				<th style="height:53px;">${menu.LN00111}</th>
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
	</table>
	
	<div class="alignBTN">
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="fnSaveSRCR()"></span>&nbsp;&nbsp;
	</div>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
