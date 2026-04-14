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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/common/css/video-js.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/video.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	
	jQuery(document).ready(function() {
		if ($('#my-video').length) {
			var myPlayer = videojs('my-video');
		}
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
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
		var url  = "saveMboardLike.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
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

	var back = "&scStartDt=${scStartDt}"
				+"&searchKey=${searchKey}"
				+"&searchValue=${searchValue}"
				+"&scEndDt=${scEndDt}";
				
	function fnGoList(){
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
	
	function doEdit(){
		var url = "editMboard.do"; 
		var data = "NEW=N&BoardID=${resultMap.BoardID}"
					+"&BoardMgtID=${resultMap.BoardMgtID}&url=${url}"
					+"&screenType=${screenType}&pageNum=${currPage}"
					+"&projectID=${projectID}&category=${category}"
					+"&categoryIndex=${categoryIndex}"
					+back
					+"&categpryCnt=${categoryCnt}"
					+"&templProjectID=${templProjectID}";
					
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnRealod(){
		var isNew="N"; var boardMgtID=$("#BoardMgtID").val(); var boardID=$('#BoardID').val();
		goDetail(isNew,boardMgtID, boardID);
		//document.location.reload();
	}
	
	
</script>
<!-- BEGIN :: DETAIL -->
<div>

	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveMboard.do" method="post" onsubmit="return false;">
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
					${resultMap.Subject}
				</td>
				<th>${menu.LN00131}</th>
				<td class="sline tit last">
					<input type="hidden" id="project" name="project" value="${resultMap.ProjectID}">${resultMap.ProjectName}
				</td>		
			</tr>			
			
			<c:if test="${CategoryYN == 'Y'}">
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
				<c:if test='${resultMap.ClosingDT != null && resultMap.ClosingDT != ""}' >				
					<tr>
						<th class="sline" style="height:20px;">${menu.LN00212}</th>
						<td id="TD_WRITE_USER_NM" class="alignL pdL10 " >
							${resultMap.WriteUserNM}
						</td>
						<th class="sline">${menu.LN00070}</th>
						<td class="alignL pdL10 " style="width:25%;" id="TD_REG_DT">
							${resultMap.ModDT}
						</td>
				    </tr>
					<tr>				
						<th class="sline">Notice</th>
						<td class="alignL pdL10 last" colspan="3">
							~ ${resultMap.ClosingDT}
						</td>	
					</tr>
				</c:if>
				
				<c:if test='${resultMap.ClosingDT == null || resultMap.ClosingDT == ""}' >				
					<tr>
						<th class="sline" style="height:20px;">${menu.LN00212}</th>
						<td id="TD_WRITE_USER_NM" class="alignL pdL10 last" >
							${resultMap.WriteUserNM}
						</td>
						<th class="sline">${menu.LN00070}</th>
						<td class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT">
							${resultMap.ModDT}
						</td>
				    </tr>
				</c:if>	
			</c:if>
			</table>
			<table  width="100%"  cellpadding="0"  cellspacing="0">
			<tr>
		  		<td colspan="4" style="height:400px;vertical-align:top;overflow:auto;border-left:1px solid #ddd;border-right:1px solid #ddd;border-bottom:1px solid #ddd;" class="tit last pdL10 pdR10">
					<br>
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
							<video id="my-video" class="video-js" controls= "" width="640" height="264"
							  preload="auto" data-setup="{}">
							    <source src="/multimedia/${fileList.FileName}" type='video/mp4' />
							</video>
							<br>
						</div>
					</c:forEach>
					<br>${resultMap.Content}
				</td>	
			</tr>			
			</table>
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
		<div class="alignBTN">
			<c:if test="${NEW == 'Y'}">
				<c:if test="${NEW == 'N' && LikeYN == 'Y'}">
					<span id="saveLike" style="float:left;">
						<img src="${root}${HTML_IMG_DIR}/Like${resultMap.LikeInfo}.png" onclick="doLike('${resultMap.LikeInfo}')" style="width:25px;height:25px;cursor:pointer;">
					</span>
					<span style="float:left;padding-top:5px;">(${likeCNT})</span>
				</c:if>&nbsp;&nbsp;
			</c:if>
			<c:if test="${sessionScope.loginInfo.sessionUserId == resultMap.RegUserID}">
				<span id="viewEdit" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="doEdit()"></span>&nbsp;
			</c:if>
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1 && NEW == 'N'}">				
				<span id="viewDel" class="btn_pack medium icon"><span class="delete"></span><input value="Delete" type="submit" onclick="doDelete()"></span>&nbsp;
			</c:if>
			<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
		</div>
	<!-- END :: Button -->
	</div>
	</form>

</div>
<!-- END :: DETAIL -->
<iframe allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true" name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>