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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00072}"/> <!-- 사용자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="항목"/> <!-- 항목 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var impl = "";
	
	jQuery(document).ready(function() {
		impl = tinyMCE.get('description');
		$("input.datePicker").each(generateDatePicker);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('category',data+"&level=2", 'getESMSRCategory', '', 'Select', 'esm_SQL');
		
		$('#reqDueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
		
		if("${itemID}" != null && "${itemID}" != ""){
			$("#actFrame").css("overflow-y","auto");
		}
	});
	
	function fnCheckValidation(){
		var isCheck = true;
		var category = $("#category").val();
		var subject = $("#subject").val();
		var rootItemID = $("#rootItemID").val();
		var description = impl.getContent();
				
		var reqdueDate = $("#reqdueDate").val().replaceAll("-","");
		var currDate = "${thisYmd}";
		var requestUser = $("#requestUserID").val();
		
		if(requestUser == "" || requestUser == null ){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(rootItemID == "" ){ alert("${WM00034_6}"); isCheck = false; return isCheck;}
		if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(reqdueDate == ""){alert("${WM00034_5}"); isCheck = false; return isCheck;}
		
		if(parseInt(reqdueDate) < parseInt(currDate) ){ 	
			alert("${WM00014}"); isCheck = false; return isCheck;
		} 
	 
		return isCheck;
	}
	
	function fnSaveSR(){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		$('#srMode').val('N');
		var url  = "createIcpMst.do";
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}

	function fnGoSRList(){ 
		if( "${itemID}" == "" ) {
			var url = "icpList.do";
			var data = "srType=${srType}&scrnType=${scrnType}&srMode=${srMode}&category=${category}&searchSrCode=${searchSrCode}"
								+ "&itemProposal=${itemProposal}&subject=${subject}&varFilter=${varFilter}&itemID=${itemID}";
			var target = "icp_content";
			ajaxPage(url, data, target);
		} else {
// 			var target = "actFrame";
			fnItemMenuReload();
		}
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
		var data="scrnType=SR&browserType="+browserType+"&fltpCode=SRDOC";
		
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
	
	function addSharer(){
		var projectId = $("#project").val();
		var sharers = $("#sharers").val();
		
		var url = "selectMemberPop.do?docCategory=SR&projectId="+projectId+"&s_memberID="+sharers;
		window.open(url,"srFrm","width=900 height=700 resizable=yes");					
	}
	
	function fnGetTreePop(){
		var url = "searchRootItemTreePop.do";
		var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}&conTypeCode=CN00001";
		
		fnOpenLayerPopup(url,data,doCallBackMove,617,436);
	}
	
	function doCallBackMove(){}
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
	<c:choose>
	<c:when test="${itemID eq '' || itemID eq null }">
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00280}</h3>
		</div>
	</c:when>
	<c:otherwise>
		<div class="child_search01 pdL10">
			<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;<b>${menu.LN00280}</b>
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
			<th class="alignL pdL10">${menu.LN00002}</th><!-- 제목 -->
			<td class="sline tit last" <c:if test='${itemID ne "" && itemID ne null}'>colspan="3"</c:if>>
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active;" />
			</td>
			<c:if test="${itemID eq '' || itemID eq null }">
		    <th class="alignL pdL10" style="height:15px;">항목</th>
		  	<td class="sline tit last">
		  		<input type="text" class="text" id="rootItemName" name="rootItemName" OnClick="fnGetTreePop()" />
		  	</td>
		  	</c:if>
			<input type="hidden" class="text" id="rootItemID" name="rootItemID" value="${itemID }"/>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
			</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}</th>
			<td class="sline tit last" >
				<font><input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
				<input type="text" id="reqDueDateTime" name="reqDueDateTime" class="input_off text mgL5" size="8" style="width:70px; text-align: center;" maxlength="10" value="18:00:00">
			</td>
		</tr>
	</table>
	<table  width="100%"  cellpadding="0"  cellspacing="0">
		<tr>
			<td style="height:300px;" class="tit last">
				<textarea  class="tinymceText" id="description" name="description" style="width:100%;height:300px;"></textarea>					
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
			<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}</a></th>
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
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>
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
