<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = "${resultMap.RegUserID}";
	var NEW = "${NEW}";
	var screenType = "${screenType}";	
	
</script><!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var ClosingDT = "${resultMap.ClosingDT}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		fnSelect('project', data, 'getPjtMbrRl', '${resultMap.ProjectID}', 'Select');
		fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
		
		if( ClosingDT != "" && ClosingDT != null){
			var checkObj = document.all("noticeYN");
			checkObj.checked=true;
			$("#closingCalDp").attr('style', 'display: done');	
			$("#noticeYN").val("Y");
		}
	});
	function doSave(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		var url  = "saveMboard.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}

	function doLike(likeInfo){
		if(likeInfo == 'N'){
			if(!confirm("${CM00001}")){ return;}
		}
		else if(likeInfo == 'Y') {
			if(!confirm("Do you really cancel Like ?")){ return;}
		}
		var url  = "saveMboardLike.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		if(isNotEmptyById("Subject", true)==false){return false;}
		return isCheck;
	}
	function doDelete(){
		if(confirm("${CM00002}")){
			var url = "deleteMboard.do";
			ajaxSubmit(document.boardFrm, url,"blankFrame");
		}
	}	
	
	function doReturn(BoardMgtID, screenType){ 	
		var url = "mboardList.do";
		var data = "pageNum=${pageNum}&url=${url}&screenType=${screenType}&s_itemID=${projectID}"; 
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnGoList(){
		var back = "&scStartDt=${scStartDt}"
					+"&searchKey=${searchKey}"
					+"&searchValue=${searchValue}"
					+"&scEndDt=${scEndDt}";
					
		var url = "mboardList.do";
		var data = "BoardMgtID=${BoardMgtID}&pageNum=${pageNum}"
						+"&url=${url}&screenType=${screenType}"
						+"&s_itemID=${projectID}&defBoardMgtID=${defBoardMgtID}" 
						+"&category=${category}"
						+back
						+"&categoryIndex=${categoryIndex}"
						+"&categpryCnt=${categoryCnt}"; 
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnRealod(){
		var isNew="N"; var boardMgtID=$("#BoardMgtID").val(); var boardID=$('#BoardID').val();
		goDetail(isNew,boardMgtID, boardID);
	}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=BRD&gubun=MBRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
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
	
	function fnCheckNoticeYN(){
		var checkObj = document.all("noticeYN");
		if( checkObj.checked == true){ 
			$("#closingCalDp").attr('style', 'display: done');	
			$("#noticeYN").val("Y");
		} else {
			$("#closingDT").val("");
			$("#closingCalDp").attr('style', 'display: none');
			$("#noticeYN").val("N");
		}
	}
</script>
<!-- BEGIN :: DETAIL -->
<div>

	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${resultMap.BoardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${resultMap.BoardID}">
		<input type="hidden" id="screenType" name="screenType" value="${screenType}">
		<input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${defBoardMgtID}" >
		<input type="hidden" id="likeInfo" name="likeInfo" value="${resultMap.LikeInfo}" >
		<input type="hidden" id="RegUserID" name="RegUserID" value="${resultMap.RegUserID}" >
		<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
			<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${boardMgtName}&nbsp;${menu.LN00108}</h3>
		</div><div style="height:10px"></div>
		<div id="boardDiv" class="hidden" style="width:100%;height:500px;">
		<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>		
			<tr>
				<th>${menu.LN00002}</th>
				<td class="sline tit last" >
					<input type="text" class="text" id="Subject" name="Subject" value="${resultMap.Subject}" size="60"  />
				</td>
				<th>${menu.LN00131}</th>
				<td class="sline tit last">
					<select id="project" name="project" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>		
			</tr>			
			<!-- 신규 등록 일때, 작성자 등록일 화면 표시 안함 -->
			<c:if test="${NEW == 'N'}">
				<tr>
					<th class="sline" style="height:20px;">${menu.LN00212}</th>
					<td id="TD_WRITE_USER_NM" class="alignL pdL10 " >
						${resultMap.WriteUserNM}
					</td>
					<th class="sline">${menu.LN00070}</th>
					<td class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
						${resultMap.ModDT}
					</td>
				</tr>
			</c:if>
			<c:if test="${CategoryYN == 'Y'}">
				<tr>				
					<th style="height:20px;">${menu.LN00033}</th>
					<td class="sline tit last">	
						<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
					</td>
					
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last">Yes&nbsp;
						<input type="checkbox" id="noticeYN" name="noticeYN" value="" onClick="fnCheckNoticeYN();" >&nbsp;
						<span id="closingCalDp" style="display:none;">
						<font>Expiration date&nbsp;&nbsp;
							<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
							style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
						</font>
						</span>
					</td>	
				</tr>
			</c:if>
			<c:if test="${CategoryYN != 'Y'}">
				<tr>				
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last" colspan="3">Yes&nbsp;
						<input type="checkbox" id="noticeYN" name="noticeYN" value="" onClick="fnCheckNoticeYN();" >&nbsp;
						<span id="closingCalDp" style="display:none;">
							<font>Expiration date&nbsp;&nbsp;
								<input type="text" id="closingDT" name="closingDT" value="${resultMap.ClosingDT}"	class="input_off datePicker stext" size="8"
								style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							</font>
						</span>
					</td>	
				</tr>
			</c:if>
			<tr>
				<!-- 첨부문서 -->
				<th style="height:53px;">첨부 동영상</th>
				<td colspan="3" style="height:53px;" class="alignL pdL5 last">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
						<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
							<span id="fileName">${fileList.FileRealName}</span>
							<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}"><img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></c:if>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			</table>
			<table width="100%"  cellpadding="0"  cellspacing="0">
			<tr>
				<td colspan="4" style="height: 400px;" align="center" class="tit last">
					<textarea class="tinymceText" id="Content" name="Content" style="width:100%;height:400px">${resultMap.Content}</textarea>
				</td>
			</tr>			
			</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN">
			<c:if test="${NEW == 'N' && LikeYN == 'Y'}">
				<span id="saveLike" style="float:left;">
					<img src="${root}${HTML_IMG_DIR}/Like${resultMap.LikeInfo}.png" onclick="doLike('${resultMap.LikeInfo}')" style="width:25px;height:25px;cursor:pointer;">
				</span>
				<span style="float:left;padding-top:5px;">(${likeCNT})</span>
			</c:if>&nbsp;&nbsp;
			<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>&nbsp;&nbsp;
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="doSave()"></span>&nbsp;&nbsp;
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
		</div>
	<!-- END :: Button -->
	</div>

	</form>

</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>