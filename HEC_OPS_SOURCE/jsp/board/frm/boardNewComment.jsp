<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />

<script type="text/javascript">
//script에러 방지용 cosole선언
var console = console || {
	log:function(){},
	warn:function(){},
	error:function(){}
};

////////////////////////////////////////////////////
//파일 업로드 처리 이동 [fileAttachHelper.js]
////////////////////////////////////////////////////
var screenType = "${screenType}";
$(document).ready(function() {
	$("#send").click(function(e) {
		if(confirm("${CM00001}")){
			var actionUrl = "boardForumMake.do";
			ajaxSubmit(document.editRelyFrm, actionUrl);
		}
	});
	$('#back').click(function(e){
		doReturn();
	});
});

function fnDeleteItemFile(seq){
	var fileListDiv = document.getElementById("fileList" + seq);
	document.getElementById("deleteSeq").value = document.getElementById("deleteSeq").value + "," + seq;
	fileListDiv.style.display = "none";
}

function doReturn(){
	var listType = "${listType}";
	var url = "boardForumDetail.do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
		+ "&noticType=${noticType}" 
		+ "&boardID=${parentID}" 
		+ "&BoardMgtID=${BoardMgtID}" 
		+ "&s_itemID="+$('#s_itemID').val()
		+ "&ItemID="+$('#ItemID').val()
		+ "&userId="+$('#userId').val()
		+ "&privateId="+$('#privateId').val()
		+ "&filter=editEnd"
		+ "&pageNum=${pageNum}"
		+ "&isMyCop=${isMyCop}"
		+ "&screenType=${screenType}"
		+ "&projectID=${projectID}"
		+" &scStartDt=${scStartDt}"+"&scEndDt=${scEndDt}"
		+" &searchType=${searchType}&listType=${listType}&srID=${srID}";
	if(listType == 1){data = data + "&s_itemID="+$('#s_itemID').val();}		
		
	var target = "help_content";
	ajaxPage(url, data, target);
}

function fileNameClick(avg1){
	var url  = "fileDown.do?seq=" + avg1 + "scrnType=BRD";
	ajaxSubmitNoAdd(document.editRelyFrm, url,"saveFrame");
}

</script>

<div class="mgL10 mgR10">
	<form name="editRelyFrm" id="editRelyFrm" enctype="multipart/form-data" action="boardForumMake.do" method="post" onsubmit="return false;">
			<input type="hidden" id="noticType" name="noticType" value="${noticType}">
			<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
			<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
			<input type="hidden" id="parentID" name="parentID" value="${parentID}">
			<input type="hidden" id="boardID" name="boardID" value="${boardID}">
			<input type="hidden" id="boardID" name="BoardMgtID" value="${BoardMgtID}">
			<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
			<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}">
			<input type="hidden" id="deleteSeq" name="deleteSeq">
			<input type="hidden" id="replyLev" name="replyLev" value="1">
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
			<input type="hidden" id="parentRefID" name="parentRefID" value="${parentRefID}">
			<input type="hidden" id="searchType" name="searchType" value="${searchType}" />
			<input type="hidden" id="searchValue" name="searchValue" value="${searchValue}" />
			<input type="hidden" id="scStartDt" name="scStartDt" value="${scStartDt}" />
			<input type="hidden" id="scEndDt" name="scEndDt" value="${scEndDt}" />	
			<input type="hidden" id="screenType" name="screenType" value="${screenType}" />	
			<input type="hidden" id="listType" name="listType" value="${listType}" />	
			<input type="hidden" id="memberID" name="memberID" value="${memberID}" />	
			<input type="hidden" id="subject" name="subject" value="${subject}" />	
			
		<div id="commentDiv" class="hidden" style="width: 100%;" align="center">	
				
		<!--  cop reply -->
		<div>
			<c:if test="${empty boardID}">			
				<div class="cop_hdtitle">
					<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/comment_user.png">&nbsp;&nbsp;Write Reply&nbsp;</h3>
				</div>
			</c:if>
			<c:if test="${!empty boardID}">			
				<div class="cop_hdtitle mgB5" style="border-bottom:1px solid #ccc;">
					<h3><img src="${root}${HTML_IMG_DIR}/${icon}">&nbsp;&nbsp;Edit Reply&nbsp;</h3>
				</div>
			</c:if>
			<div>
				<table class="tbl_brd" id="projList" style="table-layout:fixed;" width="100%"	cellpadding="0" cellspacing="0" >
					<colgroup>
						<col>
						<col width="85%">
					</colgroup>
					<tr>
						<th class="viewtop">
						<div style="position:relative;">${menu.LN00111}
							<img src="${root}${HTML_IMG_DIR}/btn_file_attach.png" style="cursor:pointer;width:11;height:11;padding-top:3px;" align="absmiddle">
							<div id="file_item_P">
							<div id='file_items' onclick="check()"></div>
							<span id="file_item0" class="file_attach">
									<input type="file" name='file0' id='file0' onchange='attach("1", this)' size='1' >
							</span>			
							</div>
						</div>
						</th>
						
						<td class="tit last" style="position:relative;height:40px">
						<c:if test="${0 != fileList.size()}">
							<c:set value="${fileList.size()}" var="f_count" />
							<c:set value="0" var="f_size" />
							<c:forEach var="f_result" items="${fileList}" varStatus="status">
								<div id="fileList${f_result.Seq}" style="height:20px; " class="mm">
									
									<a href="#" onclick="fileNameClick('${f_result.Seq}')">
									<img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" onclick="" style="cursor:pointer;width:11;height:11;padding-right:10px;" alt="Download" align="absmiddle">${f_result.FileRealName}</a>
									<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:11;height:11;padding-left:10px;" alt="Delete" align="absmiddle" onclick="fnDeleteItemFile('${f_result.Seq}')">
								</div>
								<c:set var="f_size" value="${f_size+1}"/>
								<c:set var="f_count" value="${f_count-1}" />
							</c:forEach>
						</c:if>
						<div id='display_items'></div>
						<input type="hidden" id="items" name="items" />
						<input type="hidden" id="isNew" name="isNew" />	
						</td>
					</tr>
					<tr>
						<td colspan="2" style="height: 260px;padding:5px 5px 5px 5px;" align="center" class="tit last">
							<textarea class="edit" name="content_new" id="content_new" style="width:100%;height:260px" >${content}</textarea>
						</td>
					</tr>		
							
				</table>

		</div>	
		<div class="clear"></div>
			<div class="alignBTN">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="send"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" id="back"></span>
			</div>
		<!-- //cop reply -->			
				
				
				
		</div>
		</div>	
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</div>