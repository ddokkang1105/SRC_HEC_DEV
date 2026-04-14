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
	
	if	(sessionUserId == RegUserId || sessionAuthLev == 1 || NEW == 'Y') {
			var chkReadOnly = false;
		}else{
			var chkReadOnly = true;
		}
	
</script><!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var projectCategory = "${projectCategory}";
	
	jQuery(document).ready(function() {
	//	jQuery("#Subject").focus();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		//templProjectIDfnSelect('project', data, 'getPjtMbrRl', '${resultMap.ProjectID}', 'Select');
		fnSelect('project', data, 'getPjtMbrRl', templProjectID, 'Select');
		fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
	});
	function doLike(likeInfo){
		if(likeInfo == 'N'){
			if(!confirm("${CM00001}")){ return;}
		}
		else if(likeInfo == 'Y') {
			if(!confirm("Do you really cancel Like ?")){ return;}
		}
		var url  = "saveBoardLike.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}
	
	function doDelete(){
		//$add("BoardID", "${resultMap.BoardID}", boardFrm);
		if(confirm("${CM00002}")){
			var url = "zDlm_deleteBoard.do";
			ajaxSubmit(document.boardFrm, url,"blankFrame");
		}
	}
	
	function doReturn(BoardMgtID, screenType){ 	
		var url = "boardList.do";
		var data = "pageNum=${pageNum}&url=${url}&screenType=${screenType}&s_itemID=${projectID}"; 
		var target = "help_content";
		ajaxPage(url, data, target);
	}

	var back = "&scStartDt=${scStartDt}"
				+"&searchKey=${searchKey}"
				+"&searchValue=${searchValue}"
				+"&scEndDt=${scEndDt}"
				+"&projectCategory="+projectCategory
				+"&boardTypeCD=MN194";
				
	function fnGoList(){
		if(screenType == "Admin"){
			goList(false, screenType, "${projectID}","${category}","${categoryIndex}","${categoryCnt}",back);
		}else{
			var url = "boardList.do";
			var data = "pageNum=${pageNum}"
						+"&url="+ encodeURIComponent("${url}")
						+"&screenType="+encodeURIComponent("${screenType}")
						+"&s_itemID="+encodeURIComponent("${projectID}")
						+"&defBoardMgtID="+encodeURIComponent("${defBoardMgtID}") 
						+"&category="+encodeURIComponent("${category}")
						+back
						+"&categoryIndex="+encodeURIComponent("${categoryIndex}")
						+"&categpryCnt=${categoryCnt}"
						+"&projectIDs="+ encodeURIComponent("${projectIDs}"); 
			if(screenType != "cust"){
				data = data + "&BoardMgtID="+encodeURIComponent("${BoardMgtID}");
			}
			var target = "help_content";
			ajaxPage(url, data, target);
		}
	}
	
	function doEdit(){
		var url = "zDlm_editBoard.do"; 
		var data = "NEW=N&BoardID=${resultMap.BoardID}"
					+"&BoardMgtID=${resultMap.BoardMgtID}&url=${url}"
					+"&screenType=${screenType}&pageNum=${currPage}"
					+"&projectID=${projectMap.CODE}&category=${category}"
					+"&categoryIndex=${categoryIndex}"
					+back
					+"&categpryCnt=${categoryCnt}"
					+"&templProjectID=${templProjectID}"
					+"&faqID=${resultMap.FadID}";
					debugger;
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnRealod(){
		var isNew="N"; var boardMgtID=$("#BoardMgtID").val(); var boardID=$('#BoardID').val();
		goDetail(isNew,boardMgtID, boardID);
		//document.location.reload();
	}
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		debugger;
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
		var url  = "zDlm_fileDownload.do?seq="+seq+"&scrnType=BRD";
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
		var url  = "zDlm_fileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}
	
</script>
<style>
	strong,em{font-size:inherit;}
</style>
<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10">
	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="faqID" name="faqID" value="${resultMap.FadID}">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${resultMap.BoardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${resultMap.BoardID}">
		<input type="hidden" id="screenType" name="screenType" value="${screenType}">
		<input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${defBoardMgtID}" >
		<input type="hidden" id="likeInfo" name="likeInfo" value="${resultMap.LikeInfo}" >
		<input type="hidden" id="RegUserID" name="RegUserID" value="${resultMap.RegUserID}" >
		<div class="cop_hdtitle">
			<%-- <h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${boardMgtName}&nbsp;${menu.LN00108}</h3> --%>
			<h3 style="padding: 8px 0;">
				<span id="viewList" class="btn_pack medium icon"><span class="list"></span>
				<input value="${menu.ZLN0028}" type="submit"  onclick="fnGoList();"></span>
			</h3>
		</div>
		
		<div id="boardDiv" class="hidden" style="width:100%;">
		<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>		
			<tr>
				<th>${menu.LN00002}</th>
				<td colspan="7" class="sline tit last">
					${resultMap.Subject}
				</td>
			</tr>
			<tr>
				<th>${menu.LN00131}</th>
				<td class="sline tit last">
					<input type="hidden" id="project" name="project" value="${projectMap.CODE}">${projectMap.NAME}
				</td>
				<th>${menu.ZLN0020}</th>
				<td class="sline tit last">
					<select id="division" name="division" class="sel" style="width:100%; max-width:190px;" disabled>
       					 <option value="FAQ00001" ${resultMap.FAQ_TYPE == 'FAQ00001' ? 'selected' : ''}>FAQ</option>
      					 <option value="FAQ00002" ${resultMap.FAQ_TYPE == 'FAQ00002' ? 'selected' : ''}>소프트웨어자료</option>
      					 <option value="FAQ00003" ${resultMap.FAQ_TYPE == 'FAQ00003' ? 'selected' : ''}>시스템매뉴얼</option>
					</select>
				</td>
				<th>${menu.LN00078}</th>
				<td class="sline tit last" id="modDT" name="modDT">
						${resultMap.FRST_REGIST_PNTTM}
				</td>
				<th>${menu.ZLN0017}</th>
				<td class="sline tit last">
					<input type="checkbox" id="urgncyYN" name="urgncyYN" ${resultMap.UrgncyYN == 'Y' ? 'checked' : ''} disabled>&nbsp&nbsp긴급</input>
				</td>	
			</tr>	
			<!-- 신규 등록 일때, 작성자 등록일 화면 표시 안함 -->
<%-- 				<tr>
					<th class="sline" style="height:20px;">${menu.LN00212}</th>
					<td id="TD_WRITE_USER_NM" class="alignL pdL10 " >
						${resultMap.WriteUserNM}
					</td>
					<th class="sline">${menu.LN00070}</th>
					<td class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
						${resultMap.ModDT}
					</td>
				</tr>
			<c:if test="${CategoryYN == 'Y'}">
				<tr>				
					<th style="height:20px;">${menu.LN00033}</th>
					<td class="sline tit last" <c:if test="${resultMap.ClosingDT == null && NEW != 'Y'}"> colspan="3" </c:if> >
						<input type="hidden" id="project" name="category" value="${resultMap.category}">${resultMap.CategoryNM}
					</td>
					<c:if test='${resultMap.ClosingDT != null && resultMap.ClosingDT != ""}' >				
					<th class="sline">Notice</th>
					<td class="alignL pdL10 last">~ ${resultMap.ClosingDT}</td>	
					</c:if>	
				</tr>
			</c:if>
			<c:if test="${CategoryYN != 'Y'}">
				<tr>				
				  <c:if test='${resultMap.ClosingDT != null && resultMap.ClosingDT != ""}' >				
						<th class="sline">Notice</th>
						<td class="alignL pdL10 last" colspan="3">
							~ ${resultMap.ClosingDT}
						</td>	
					</c:if>	
				</tr>
			</c:if> --%>
			<tr>
				<!-- 첨부문서 -->
				<th style="height:53px;">${menu.LN00111}</th>
				<td colspan="7" style="height:53px;" class="alignL pdL5 last">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<div class="floatR pdR20" id="divFileImg">
					<c:if test="${itemFiles.size() > 0}">
						<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
						<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
					</c:if>
					</div>
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
						<div id="divDownFile${fileList.fileSn}"  class="mm" name="divDownFile${fileList.fileSn}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.fileSn}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.fileSn}');">${fileList.orignlFileNm}</span>
							<br>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			</table>
			<table class="tbl_brd"  width="100%"  cellpadding="0"  cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>		
			<tr>
				<th>${menu.LN00003}</th>
		  		<td colspan="4" style="height: 400px;vertical-align:top;overflow:auto;border-left:1px solid #ddd;border-right:1px solid #ddd;border-bottom:1px solid #ddd;" class="tit last pdL10 pdR10">
					<br>${resultMap.Content}
				</td>	
			</tr>		
			<tr>
				<th>${menu.ZLN0021}</th>
		  		<td colspan="4" style="height: 400px;vertical-align:top;overflow:auto;border-left:1px solid #ddd;border-right:1px solid #ddd;border-bottom:1px solid #ddd;" class="tit last pdL10 pdR10">
					<br>${resultMap.Answer}
				</td>	
			</tr>	
			</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN" style="margin-bottom:10px;">
			<c:if test="${NEW == 'Y'}">
				<c:if test="${NEW == 'N' && LikeYN == 'Y'}">
					<span id="saveLike" style="float:left;">
						<img src="${root}${HTML_IMG_DIR}/Like${resultMap.LikeInfo}.png" onclick="doLike('${resultMap.LikeInfo}')" style="width:25px;height:25px;cursor:pointer;">
					</span>
					<span style="float:left;padding-top:5px;">(${likeCNT})</span>
				</c:if>&nbsp;&nbsp;
			</c:if>
			<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID || sessionScope.loginInfo.sessionAuthLev == 1}">
			<span id="viewEdit" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="doEdit()"></span>&nbsp;
			<span id="viewDel" class="btn_pack medium icon"><span class="delete"></span><input value="Delete" type="submit" onclick="doDelete()"></span>&nbsp;
			</c:if>
<%-- 	<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}">
				<span id="viewEdit" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="doEdit()"></span>&nbsp;
			</c:if>
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1 && NEW == 'N'}">				
				<span id="viewDel" class="btn_pack medium icon"><span class="delete"></span><input value="Delete" type="submit" onclick="doDelete()"></span>&nbsp;
			</c:if> --%>
			<!-- <span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span> -->
		</div>
	<!-- END :: Button -->
	</div>
	</form>

</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>