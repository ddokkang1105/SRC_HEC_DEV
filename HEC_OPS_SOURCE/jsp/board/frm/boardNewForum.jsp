<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
 

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script type="text/javascript">
//파일 업로드 처리 이동 [fileAttachHelper.js]
var screenType = "${screenType}";
var fileSize = "${itemFiles.size()}";

$(document).ready(function() { 
	if(document.getElementById('help_content')!=null&&document.getElementById('help_content')!=undefined){
		document.getElementById('help_content').style.height = (setWindowHeight() - 60)+"px";			
		window.onresize = function() {
			document.getElementById('help_content').style.height = (setWindowHeight() - 80)+"px";	
		};
	}
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
	fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
	
	$("#send").click(function(e) {
		if(confirm("${CM00001}")){
			var url  = "boardForumNew.do";
			ajaxSubmit(document.newFormFrm, url);
		}
	});
	
	$('#back').click(function(e){
		doReturn();
	});
	
});

function doReturn(){
	var listType = "${listType}";
	var url = "boardForumList.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&pageNum="+$("#currPage").val()+"&noticType=${noticType}&BoardMgtID=${BoardMgtID}&isMyCop=${isMyCop}"
				+"&scStartDt=${scStartDt}"+"&scEndDt=${scEndDt}"
				+"&searchType=${searchType}"+"&searchValue=${searchValue}"
				+"&screenType=${screenType}&projectID=${projectID}&listType=${listType}&srID=${srID}&instanceNo=${instanceNo}&changeSetID=${changeSetID}"; 
	if(listType == 1){data = data + "&s_itemID=${s_itemID}";}			
	var target = "help_content";
	ajaxPage(url, data, target);
}
	
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
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
		ajaxSubmitNoAdd(document.forumListFrm, url,"saveFrame");
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
		ajaxSubmitNoAdd(document.forumListFrm, url,"saveFrame");
	}

</script>

<div class="mgL10 mgR10">
	<form name="newFormFrm" id="newFormFrm" enctype="multipart/form-data" action="boardForumNew.do" method="post" onsubmit="return false;">
		<div id="forumListDiv" class="hidden" style="width: 100%;" align="center">
			<input type="hidden" id="noticType" name="noticType" value="${noticType}">
			<input type="hidden" id="noticType" name="BoardMgtID" value="${BoardMgtID}">
			<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
			<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
			<input name="userId" id="userId" type="hidden" value="${sessionScope.loginInfo.sessionUserId}" />
			<input name="date" id="date" type="hidden"/> 
			<input type="hidden" id="screenType" name="screenType" value="${screenType}" />
			<input type="hidden" id="projectID" name="projectID" value="${projectID}" />
			<input type="hidden" id="srID" name="srID" value="${srID}" />
			<input type="hidden" id="instanceNo" name="instanceNo" value="${instanceNo}" />
			<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}" />
			<input type="hidden" id="boardMgtName" name="boardMgtName" value="${boardMgtName}" />
			<div id="dvd70reply">
			<div class="cop_hdtitle">
				<h3 style="padding:8px 0;"><img src="${root}${HTML_IMG_DIR}/comment_user.png">&nbsp;&nbsp;Write&nbsp;</h3>
			</div>
			
			<table class="tbl_brd" id="forumList" style="table-layout:fixed;" width="100%"	cellpadding="0" cellspacing="0" >
				<colgroup>
					<col width="12%">
					<col width="38%">
					<col width="12%">
					<col width="38%">
				</colgroup>	
				<c:if test="${CategoryYN == 'Y'}">
				<tr>				
					<th class="viewtop">${menu.LN00002}</th>
					<td class="viewtop sline tit last"><input name="subject" id="subject" type="text" class="text"></td>
					<th class="viewtop" style="height:20px;">${menu.LN00033}</th>
					<td class="viewtop sline tit last">	
						<select id="category" name="category" class="sel" style="width:250px;margin-left=5px;"></select>
					</td>
				</tr>
				</c:if>
				<c:if test="${CategoryYN != 'Y'}">
				<tr>
					<th class="viewtop">${menu.LN00002}</th>
					<td colspan="3" class="viewtop last"><input name="subject" id="subject" type="text" class="text"></td>
				</tr>
				</c:if>
				<c:if test="${!empty s_itemID && s_itemID ne '0'}">
				<tr>
					<th class="viewtop">항목</th>
					<td class="viewtop sline tit last" style="cursor:pointer;" Onclick="fnOpenItemPop(${s_itemID})">${path}</td>
					<th class="viewtop">${menu.LN00004}</th>
					<td class="viewtop sline tit last" >${ItemMgtUserMap.Name}(${ItemMgtUserMap.NameEN})/${ItemMgtUserMap.teamName}<input type="hidden" name="ItemMgtUserID" id="ItemMgtUserID" value="${ItemMgtUserMap.AuthorID}" /></td>
				</tr>
				</c:if>
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
				<tr>
					<td colspan="4" style="height:360px;padding:5px 5px 5px 5px;" align="center" class="tit last">
					<textarea class="tinymceText" id="content" name="content" style="width:100%;height:355px;" ></textarea>
					</td>
				</tr>				
			</table>
			</div>
			<div class="alignBTN">
				<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="send"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" id="back"></span>
			</div>			
		</div>
	</form>

</div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
