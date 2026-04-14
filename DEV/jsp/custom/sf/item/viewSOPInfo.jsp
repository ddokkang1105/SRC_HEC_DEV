<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<head>
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
	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
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
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	// Model 팝업
	function clickModelEvent(trObj) {
		var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID=${itemID}"
				+"&modelID="+$(trObj).find("#ModelID").text()
				+"&scrnType=view"
 				+"&MTCategory="+$(trObj).find("#MTCategory").text()
				+"&modelName="+encodeURIComponent($(trObj).find("#ModelName").text())
			    +"&modelTypeName="+encodeURIComponent($(trObj).find("#modelTypeName").text())
				+"&menuUrl="+$(trObj).find("#ModelURL").text()
				+"&changeSetID="+$(trObj).find("#ModelCSID").text()
				+"&selectedTreeID=${itemID}";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
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
		var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo"; 
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
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
</script>
<!-- BIGIN :: -->
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;"></div>
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR5 chkbox" name="process" checked>기본정보&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="file" checked>첨부파일&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="maintext">문서개요&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="relProcess">관련 Process&nbsp;					
					
					</li>
				</ul>
			</div>
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">기본 정보</p>
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="8%">
						<col width="25%">
						<col width="8%">
						<col width="28%">
						<col width="8%">
						<col width="26%">							
					</colgroup>
					<tr>
						<th>No.</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>
						<th>Version</th>
						<td class="alignL pdL10">${prcList.Version}</td>
						<th>Rev. Date</th>
						<td class="alignL pdL10">${prcList.LastUpdated}</td>
						
					</tr>				
					<tr>	
						<th>작성자</th>
						<td class="alignL pdL10">${prcList.Name}</td>			
						<th>주관조직</th>
						<td class="alignL pdL10">${prcList.OwnerTeamName}</td>		
						<th>유관조직</th>
						<td class="alignL pdL10">${attrMap.AT00054}</td>
					
					</tr>
				</table>
			</div>
			
			<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgB30">
				<p class="cont_title">첨부파일</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>문서유형</th>
						<th>문서명</th>
						<th>작성자</th>
						<th>등록일</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<tr>
							<td>${no }</td>
							<td>${fileList.FltpName}</td>
							<td class="alignL pdL10 flex align-center">
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
								<p style="cursor:pointer;" class="mgL5" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</p>
								(<span id="fileSize">${fileList.FileSize}</span>)
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.LastUpdated}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
			
			<!-- BIGIN :: 본문 -->
			<div id="maintext" class="mgB30">
				<p class="cont_title">문서 개요</p>
				<table>
					<tr><td><div <c:choose><c:when test="${attrMap.AT00501 ne ''}"> style="height:300px;" </c:when>
			   		<c:otherwise>style="height:100px;"</c:otherwise></c:choose>>${attrMap.AT00501}</div></td></tr>
				</table>
			</div>
						
			<!-- BIGIN :: 관련 SOP / STP -->
			<div id="relProcess" class="mgB30">
				<p class="cont_title">관련 Process</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="55%">
						<col width="20%">
					</colgroup>	
					<tr>
						<th>구분</th>
						<th>Process ID</th>
						<th>프로세스명</th>
						<th>관련 Activity No.</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00001' }">
					<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
						<td>${relItemList.TypeName}</td>
						<td>${relItemList.Identifier}</td>
						<td class="alignL pdL10">${relItemList.ItemName}</td>
						<td>-</td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00016' }">
					<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
						<td>${relItemList.TypeName}</td>
						<td>${relItemList.Identifier}</td>
						<td class="alignL pdL10">${relItemList.ItemName}</td>
						<td>
						<c:forEach var="relCxnList" items="${relItemList.cxnList}" varStatus="status">
						<c:if test="${status.last }">
						${relCxnList.RNUM }
						</c:if>
						</c:forEach>
						</td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>		
			
		</div>
	</div>
</form>
</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
