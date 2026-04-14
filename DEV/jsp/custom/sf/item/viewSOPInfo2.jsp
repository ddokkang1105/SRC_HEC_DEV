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
		/* $(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		 */
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
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){	
		var seq = new Array();		
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
	
	function fnDisplayFrame(type){
		if(type == "f"){
			$("#fileDiv").css('display','block');
			$("#historyDiv").css('display','none');
			$("#titleFile").css('box-shadow','0px 2px 0px 0px #4265ee');
			$("#titleHistory").css('box-shadow','0px 2px 0px 0px #fff');
		}else{
			$("#fileDiv").css('display','none');
			$("#historyDiv").css('display','block');
			$("#titleFile").css('box-shadow','0px 2px 0px 0px #fff');
			$("#titleHistory").css('box-shadow','0px 2px 0px 0px #4265ee');
		}
	}
	
	function fnFileDownload(){
		var cnt  = "${fileList.size}";
		var seq = new Array();
		var itemIDs = new Array();
		
		if (cnt == "0") {
			alert("${WM00049}");
			return;
		}
		
		<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
			seq[${status.index}] = "${fileList.Seq}"; 
			itemIDs[${status.index}] = "${fileList.ItemID}";		
		</c:forEach>
				
		if( '${loginInfo.sessionMlvl}' != "SYS"){
			fnCheckItemArrayAccRight(seq, itemIDs); // 접근권한 체크후 DownLoad
		}else{
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"saveFrame");
		}
	}
	
	
</script>

<!-- BIGIN :: -->
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;"></div>
		<div id="itemDiv">
			<!-- BIGIN :: 본문 -->
			<div id="maintext" class="mgT10 mgB30">
				<p class="cont_title" style="border-left: 0px !important;">문서 개요</p>
				<table>
					<tr><td><div <c:choose><c:when test="${attrMap.AT00003 ne ''}"> style="height:300px;" </c:when>
			   		<c:otherwise>style="height:100px;"</c:otherwise></c:choose>>${attrMap.AT00003}</div></td></tr>
				</table>
			</div>
			<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgB30">
				<span id="titleFile" class="cont_title menu_bar file" style="border-left: 0px !important; display: inline-flex;height:25px;box-shadow:0px 2px 0px 0px #4265ee; cursor:pointer;" OnClick="fnDisplayFrame('f');" >${menu.LN00111}</span>&emsp;
				<span id="titleHistory" class="cont_title menu_bar history" style="border-left: 0px !important;cursor:pointer;display: inline-flex;height:25px;" OnClick="fnDisplayFrame('h');">History</span>
				
				<div id="fileDiv" style="border-top: 1px solid rgb(221, 221, 221);" class="mgT_8">
			
				<div class="countList" >
			        <li class="floatR">	
						<button class="cmm-btn mgR5" onclick="fnFileDownload()">Download All</button>
						
					</li>
			    </div>
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
						<th>${menu.LN00091}</th>
						<th>${menu.LN00101}</th>
						<th>${menu.LN00060}</th>
						<th>${menu.LN00078}</th>
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
								<p style="cursor:pointer;" class="mgL10" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</p>
								(<span id="fileSize">${fileList.FileSize}</span>)
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.LastUpdated}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>				
				</div>
				
				<div id="historyDiv" style="display:none;border-top: 1px solid rgb(221, 221, 221);" class="mgT_8 pdT10">
					<table class="tbl_preview ">
						<colgroup>
							<col width="5%">
							<col width="5%">
							<col width="10%">
							<col width="25%">
							<col width="10%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
						</colgroup>	
						<tr>
							<th>No</th>
							<th>Version</th>
							<th>CSR No.</th>
							<th>${menu.LN00131}</th>
							<th>${menu.LN00022}<</th>
							<th>${menu.LN00004}</th>
							<th>${menu.LN00064}</th>
							<th>${menu.LN00095}</th>
							<th>${menu.LN00027}</th>
						</tr>
					<c:forEach var="historyList" items="${historyList}" varStatus="status">
						<tr>
							<td>${historyList.RNUM }</td>
							<td>${historyList.Version}</td>
							<td >${historyList.CSRID}</td> 
							<td>${historyList.ProjectName}</td>
							<td>${historyList.ChangeType}</td>							
							<td>${historyList.RequestUserName}</td>
							<td>${historyList.RequestDate}</td>
							<td>${historyList.CompletionDate}</td>
							<td>${historyList.ChangeSts}</td>							
						</tr>
					</c:forEach>
					</table>
				</div>
				
			</div>
		</div>
	</div>
</form>
</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
