<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
		border: 1px solid #ccc;
		width:100%;
	}
	#maintext th{
		text-align: left;
		padding: 10px;
		color: #000;
		font-weight: bold;
	}
	#maintext td{
	    display: block;
	    padding: 10px;
	    overflow-x: auto;
	    line-height: 18px;
	}
	#maintext  textarea {
		width: 100%;
		resize:none;
	}
	#itemNameAndPath, #functions{
		display:inline;
	}
</style>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script src="<c:url value='/cmm/js/tinymce_v4.3/tinymce.min.js'/>" type="text/javascript"></script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript">
	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
// 		var height = setWindowHeight();
// 		document.getElementById("htmlReport").style.height = (height)+"px";
// 		window.onresize = function() {
// 			height = setWindowHeight();
// 			document.getElementById("htmlReport").style.height = (height)+"px";	
// 		};
		modelView();
			 
		var currIdx = "${currIdx}";
		if(currIdx == "" || currIdx == "undefined"){currIdx = "0";}
		
		var itemIDs = getCookie('itemIDs').split(','); 
	    fnOpenItems(currIdx,itemIDs);
	});
	
	function fnGoBackNextPage(pID,preNext,currIdx){
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId,preNext,currIdx);
		} 
	}
	
// 	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function modelView(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = "newDiagramViewer.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${itemID}"
					+"&width="+$("#model2").width()
					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&varFilter=${revViewOption}"
					+"&displayRightBar=none";
		var src = url +"?" + data+"&browserType="+browserType;
//  		document.getElementById('model2').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
// 		$("#model2").attr("style", "display:block;height:600px;border: 0;");
	}
	
	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
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
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
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
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "Mnado", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	
	// 관련항목 팝업
	function clickItemEvent(trObj) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+$(trObj).find("#ItemID").text()
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function clickItemEvent2(trObj) {
		var classCode = $(trObj).find("#classCode").text()		
		var masterIden = $(trObj).find("#masterKey").text();
		// var url = "https://vell.hec.co.kr/ll/LLMasterInfo.View?s_InterfaceYn=Y&s_ObjectId="+$(trObj).find("#masterKey").text();
		/*
		VE :  https://ivell.hec.co.kr/member-popup/ve-pj/qi/detail?masterIden=11936
		LL :  https://ivell.hec.co.kr/member-popup/ll/master-detail-view?masterIden=20560 
		*/
		var url = "https://ivell.hec.co.kr/member-popup/ve-pj/qi/detail?masterIden="+masterIden; // VE : CL12002
		if(classCode == "CL12003"){ // LL 
			url = "https://ivell.hec.co.kr/member-popup/ll/master-detail-view?masterIden="+masterIden;
		}
		
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 변경이력 팝업
	function clickChangeHistoryEvent(trObj) {
		var url = "viewItemChangeInfo.do?"
				+"changeSetID="+$(trObj).find("#ChangeSetID").text()
 				+"&StatusCode="+$(trObj).find("#ChangeStsCode").text()
				+"&ProjectID"+$(trObj).find("#ChangeStsCode").text()
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&isItemInfo=Y&seletedTreeId=${itemID}&isStsCell=Y";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
// 	function fnChangeMenu(menuID,menuName) {
// 		$("#itemDescriptionDIV").css('display','block');
// 		$("#itemDiv").css('display','none');
// 		$("#viewPageBtn").css('display','block');
// 		if(menuID == "management"){
// 			parent.fnGetMenuUrl("${itemID}", "Y");
// 		}else if(menuID == "file"){
// 			var url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}"; 
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "report"){
// 			var url = "objectReportList.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "changeSet"){
// 			var url = "itemHistory.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N&myItem=${myItem}&itemStatus=${itemStatus}";
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "dimension"){
// 			var url = "dimListForItemInfo.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&backBtnYN=N";
// 		 	ajaxPage(url, data, target);
// 		}
// 	}
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}
	}
	
	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
	}
	
	function fnMenuReload(){
		$("#itemDescriptionDIV").html("");
		$("#itemDiv").css('display','block');
	}
	
	function fnOpenParentItemPop(pID){// ParentItem Popup
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId);
		} else {
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+pID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	}
	
	function fnSubscribe(){
		if(confirm("Do you really subscibe this item?")){
			var url = "saveRoleAssignment.do";
			var data = "itemID=${itemID}&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUnsubscribe(){
		if(confirm("Do you really unsubscibe this item?")){
			var url = "deleteRoleAssignment.do";
			var data = "seqArr=${myItemSeq}";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnGoReportList() {
		var url = "objectReportList.do";
		var target = "itemDescriptionDIV";
		var accMode = $("#accMode").val();
		var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&accMode="+accMode; 
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	
	function fnEditItemInfo() {
		var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&editScrn=${editScrn}&viewScrn=${viewScrn}&accMode=DEV&scrnMode=E&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"; 
		ajaxPage(url, data, "processItemInfo");
	}
	
	
	function fnGoChangeMgt() {
		var url = "itemHistory.do";
		var target = "itemDescriptionDIV";
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	
	function fnGoForumMgt(){
		var url = "forumMgt.do";
		var target = "itemDescriptionDIV";
		var data = "&s_itemID=${itemID}&BoardMgtID=4";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	function fnGoForumMgt2(){
		var url = "forumMgt.do";
		var target = "itemDescriptionDIV";
		var data = "&s_itemID=${itemID}&BoardMgtID=BRD110&varFilter=BRD110";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
<div id="processItemInfo">
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">

<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">	
<input type="hidden" id="viewScrn" name="viewScrn" value="${viewScrn}">	
<input type="hidden" id="editScrn" name="editScrn" value="${editScrn}">	
<input type="hidden" id="defAccMode" name="defAccMode" value="${defAccMode}">	
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}">	
<input type="hidden" id="option" name="option" value="${option}">	
<input type="hidden" id="accMode" name="accMode" value="${accMode}">	

	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="cont_Header">	
			<div class="pdL10 pdT10 pdB10" id="titWrap" style="width:99%;">
				<ul style="display: inline-block;">
					<li>
						<c:if test="${showPreNextIcon eq 'Y'}" >
						<div id="openItemsli" style="font-family:arial;" class="floatL">
							<span id="preAbl" name="preAbl"><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn.png" width="26" height="24" OnClick="fnGoBackItem();"></span>
							<span id="preDis" name="preDis" disabled=true><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn_.png" width="26" height="24"></span>
							<input type="hidden" id="openItemName" name="openItemName" size="8">	
							<input type="hidden" id="openItemID" name="openItemID" size="8">		
							<span id="nextAbl" name="nextAbl" ><img style="cursor:auto;" src="${root}cmm/common/images/icon_next_btn.png"  width="26" height="24" OnClick="fnGoNextItem();"></span>	
							<span id="nextDis" name="nextDis"><img style="cursor:auto;" src="${root}cmm/common/images//icon_next_btn_.png"  width="26" height="24"></span>	
						</div>&nbsp;
						</c:if>
					<div id="itemNameAndPath">
					<c:choose>
				   		<c:when test="${itemInfo.CategoryCode eq 'MCN' || itemInfo.CategoryCode eq 'CN' || itemInfo.CategoryCode eq 'CN1' }" >
				   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;">&nbsp;${itemInfo.FromItemName}
				   		 --> 
				   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;">&nbsp;${itemInfo.ToItemName}
						 <c:if test="${itemInfo.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${itemInfo.ItemName}</b></font> </c:if>
				   		</c:when>
				   		<c:otherwise>
				   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;">
						  	<font color="#3333FF"><b style="font-size:13px;">${itemInfo.Identifier}&nbsp;${itemInfo.ItemName}</b></font>&nbsp;
						  		   	
							<c:forEach var="path" items="${itemPath}" varStatus="status">
							
								<c:choose>
									<c:when test="${status.first}">
									(<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
									</c:when>
									<c:when test="${status.last}">
									>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
									</c:when>
									<c:otherwise>>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span></c:otherwise>
								</c:choose>
								
								
							</c:forEach>		  	
						  	<c:if test="${itemPath != null && itemPath.size() > 0 }">)</c:if>
				   		</c:otherwise>
				   	</c:choose>
				   	</div>
				   	&nbsp;
						<div id="functions">
						<!-- 251104 나의관리항목(ownerType=author) 인경우에만 SYS or (편집자이상 and 담당자) edit 버튼 출력 되도록 수정 -->
						<!--c:if test="${sessionScope.loginInfo.sessionLogintype eq 'editor' && myItem eq 'Y'}" > 	-->
						<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'	
						             or (ownerType eq 'author'
						                 and sessionScope.loginInfo.sessionLogintype eq 'editor'
						                 and myItem eq 'Y')}">								  		
					        <span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
					    </c:if>
						<c:choose>
					   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
			        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
					   		</c:when>
					   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
			        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
					   		</c:when>
				   		</c:choose>			   		
					        <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
				        <c:if test="${itemInfo.ChangeMgt eq '1'}">
					  		 <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>
					  	</c:if>
				  		<span class="btn_pack small icon"><span class="isp"></span><input value="Q&A" type="button" onclick="fnGoForumMgt()"></span>
				  		<span class="btn_pack small icon"><span class="isp"></span><input value="Review" type="button" onclick="fnGoForumMgt2()"></span>
				   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span>
				   		</div>
				   		<div class="floatR">
							<ul>
								<li  id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
									<c:if test="${empPhotoItemDisPlay ne 'N' && roleAssignMemberList.size() > 0 }" >		   	
										<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
										 <span id="authorInfo${status.index}" name="authorInfo${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetAuthorInfo('${author.MemberID}');"></span>
										</c:forEach>
									</c:if>
									
								</li> 
							</ul>
						</div> 
				   	</li>
				</ul>
				<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
					<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
				</c:if>
			</div>
		</div>
		
		<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>

				
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR5 chkbox" name="process" checked>기본정보&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="maintext" checked>본문&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="relProcess" checked>관련 Process/SOP/STP&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="vell" checked>관련 VELL&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="file" checked>첨부파일&nbsp;
					</li>
				</ul>
			</div>
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">기본 정보</p>
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>SOP No.</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>
						<th>Rev. No.</th>
						<td class="alignL pdL10">${itemInfo.Version}</td>
						<th>Rev. Date</th>
						<td class="alignL pdL10">${prcList.ValidFrom}</td>
						<th>${menu.LN00060}</th>
						<td class="alignL pdL10">${prcList.Name}</td>
					</tr>
					<tr>
						<th>조직구분</th>
						<td class="alignL pdL10">
						</td>
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10" colspan="5">${prcList.Path}</td>
					</tr>
					<tr>
						<th>${menu.ZLN019}</th>
						<td class="alignL pdL10">${prcList.CurOwnerTeamName}</td>
						<th>${menu.ZLN021}</th>
						<td class="alignL pdL10" colspan="5">
						<c:set value="1" var="no"/>
						<c:forEach var="list" items="${roleList}">
							<c:if test="${list.TeamRoletype eq 'REL'}"><c:if test="${no ne 1}">&#44; </c:if>${list.TeamNM}<c:set var="no" value="${no+1}"/></c:if>
						</c:forEach>
						</td>
					</tr>
				</table>
			</div>
			
			<!-- BIGIN :: 본문 -->
			<div id="maintext" class="mgB30">
				<p class="cont_title">${menu.LN00145}</p>
				<table>
					<tr>
				   		<td>
                         <textarea class="tinymceText" id="AT00501" name="AT00501" style="width:100%;height:300px;">${attrMap.AT00501}</textarea>
						
						
						</td>
					</tr>
				</table>
			</div>
						
			<!-- BIGIN :: 관련 SOP / STP -->
			<div id="relProcess" class="mgB30">
				<p class="cont_title">관련 Process / SOP /STP</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="30%">
						<col width="65%">					
					</colgroup>	
					<tr>
						<th>${menu.LN00042}</th>
						<th>ID</th>
						<th>${menu.ZLN018}</th>
					
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
						<c:if test="${relItemList.ItemTypeCode ne 'OJ00012' }">
						<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
							<td>${relItemList.TypeName}</td>
							<td>${relItemList.Identifier}</td>
							<td class="alignL pdL10">${relItemList.ItemName}</td>
							
							<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
						</tr>
						<c:set var="no" value="${no+1}"/>
						</c:if>
					</c:forEach>
				</table>	
			</div>
			
			<!-- BIGIN :: 관련 VELL -->
			<div id="vell" class="mgB30">
				<p class="cont_title">관련 VELL</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="15%">
						<col width="30%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>${menu.LN00042}</th>
						<th>No.</th>
						<th>사업명</th>
						<th>Phase</th>
						<th>Title</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00012' }">
					<tr onclick="clickItemEvent2(this)" style="cursor: pointer;">
						<td>${relItemList.ClassName}</td>
						<td>${relItemList.Identifier}</td>
						<td>${relItemList.ZAT0001}</td>
						<td>${relItemList.ZAT0002}</td>
						<td class="alignL pdL10"><font style="color: blue; border-bottom: 1px solid blue;">${relItemList.ItemName}</font></td>
						
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
						<td class="tdhidden" id="masterKey">${relItemList.AT00014}</td>
						<td class="tdhidden" id="classCode">${relItemList.ClassCode}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>
						
			<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgB30">
				<p class="cont_title">${menu.LN00111}</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>${menu.LN00101}</th>
					    <th>${menu.LN00060}</th>
						<th>${menu.LN00078}</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<tr>
							<td>${no }</td>
							<td class="alignL pdL10">
									<span class="btn_pack small icon mgR20">
									<c:set var="FileFormat" value="${fileList.FileFormat}" />
										<span class="
												<c:choose>
													<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
													<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
													<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
													<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
													<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
													<c:otherwise>log</c:otherwise>
												</c:choose>
														"></span>
									</span>
									<span style="cursor:pointer;" onclick="fileNameClick('','','','${fileList.Seq}','');">${fileList.FileRealName}</span>
									<!-- (<span id="fileSize">${fileList.FileSize}</span>) -->
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.LastUpdated}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</head>
