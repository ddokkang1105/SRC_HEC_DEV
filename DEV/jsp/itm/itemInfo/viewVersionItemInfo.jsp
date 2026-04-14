<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->

<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>

<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>

<script type="text/javascript">
	
	var isPossibleEdit = "${isPossibleEdit}";
	var itemStatus = "${itemStatus}";
	
	$(document).ready(function(){	
		
		if(document.getElementById('htmlReport')!=null&&document.getElementById('htmlReport')!=undefined){
			document.getElementById('htmlReport').style.height = (setWindowHeight() - 10)+"px";			
			window.onresize = function() {
				document.getElementById('htmlReport').style.height = (setWindowHeight() - 10)+"px";	
			};
		}
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		var classNameArray = strClassName.split(",");
		for (var i = 1; i < classNameArray.length + 1; i++) {
			var subTitleId = "subTitle" + i;
			if(document.getElementById(subTitleId)!=null){document.getElementById(subTitleId).innerHTML = classNameArray[i-1];}
		}
		
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer');
		$('#authorInfo').click(function(){
			var pos = $('#authorInfo').position();  
			LayerPopupView('authorInfo', 'layerPopup', pos.top);
			layerWindow.addClass('open');
			// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
			document.getElementById("htmlReport").onscroll = function() {
				// 본문 레이어 팝업
				layerWindow.removeClass('open');
			};
		});
		
		// 레이어 팝업 닫기
		$('.closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		// 레이어 팝업 닫기
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
	});
	
			
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	/* 프린트 버튼 클릭 이벤트 */
	function printDiv() {
		var url = "NewItemInfoMain.do?";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&kbn=printView"; 
		var w = 700;
		var h = 800;
		openPopup(url+data,w,h,"popUpPrint");
		
	}


	function doCallBack(){}
	
	function urlReload() {
		thisReload();
	}
	
	function afterCar() {
		thisReload();	
	}
	
	
	
	
	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("htmlReport").scrollTop;
		var nTop = 125;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft + 10) + "px";
	} 
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
		
	
	// 최신 changeSet 이전 changSet 정보 
	function fnOpenViewVersionItemInfo(changeSetID){
		var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}&changeSetID="+changeSetID;
		window.open(url,'window','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	function fnOpenCompareAttr() {
 		var url = "compareAttribute.do";
		var data = "?s_itemID=${s_itemID}&preChangeSet=${changeSetID}&changeSet=${nextChangeSetID}"; 
	   
	    var w = "1400";
		var h = "800";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
		
	function fnOpenModel(){
		var modelTypeName = "${ModelTypeName}";
		var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&s_itemID=${s_itemID}"
					+ "&modelID=${modelID}"
					+ "&scrnType=view"
					+ "&modelTypeName="+encodeURIComponent(modelTypeName)
					+ "&MTCategory=${MTCategory}"
					+ "&changeSetID=${changeSetID}"; 
		window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenCngtDetailInfo(){
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var loginUserLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var authorId = "${authorID}"; // cngt authorID
		var status = "${status}"; // cngt status
		var changeSetID = "${changeSetID}"; 
		var projectID = "${projectID}";
		var isAuthorUser = "N";
		var screenMode = "view";
		if (loginUser == authorId) {
			isAuthorUser = "Y";
			if (status != "CLS") {
				screenMode = "edit";
			}
		}	
		
		var url = "viewItemChangeInfo.do?screenMode="+screenMode+"&changeSetID="+changeSetID+"&StatusCode="+status+"&isAuthorUser="+isAuthorUser
					+"&ProjectID="+projectID+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&isItemInfo=Y&seletedTreeId=${s_itemID}&isStsCell=Y";
		
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
	// next changeSet 정보 
	function fnNextViewVersionItemInfo(changeSetID){
		var projectID = "${nextChangeSetInfo.ProjectID}";
		var authorID = "${nextChangeSetInfo.AuthorID}";
		var status = "${nextChangeSetInfo.Status}";
		var version = "${nextChangeSetInfo.Version}";
		var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}"
					+"&changeSetID="+changeSetID
					+"&projectID="+projectID
					+"&authorID="+authorID
					+"&status="+status
					+"&version="+version;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	// previous changeSet 정보 
	function fnPreViewVersionItemInfo(changeSetID){
		var projectID = "${preChangeSetInfo.ProjectID}";
		var authorID = "${preChangeSetInfo.AuthorID}";
		var status = "${preChangeSetInfo.Status}";
		var version = "${preChangeSetInfo.Version}";
		var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}"
					+"&changeSetID="+changeSetID
					+"&projectID="+projectID
					+"&authorID="+authorID
					+"&status="+status
					+"&version="+version;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
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
	
</script>
</head>
<body>
<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${option}"/>
	<input type="hidden" id="onlyMap" name="onlyMap"  value="" />
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="lovCode" name="lovCode"  value="" />
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
<div class="clear"></div>
<div id="htmlReport" style="width:100%;overflow:auto; overflow-x:hidden; padding:0;margin:auto;">
<input type="hidden" id="url" name="url" >
	<!-- BIGIN :: 기본정보 -->
	<div id="processList" class="mgL10 mgR10">
	<div class="mgL10 mgB10 mgT10">
	  <li>
	  	<span style="font-weight:bold;font-size:14px;">
	   	* Version ${selectedCSInfo.Version}&nbsp;Last released on&nbsp;${selectedCSInfo.CompletionDT}&nbsp; 
					by ${selectedCSInfo.AuthorName}
	   	</span>
	   </li>	  
    </div>
	<div class="child_search mgB10">
	  <li class="shortcut">
	  <c:forEach var="prcList" items="${prcList}" varStatus="status">
	  	 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ItemTypeImg}" OnClick="fnOpenParentItemPop();">&nbsp;${prcList.Path}/<font color="#3333FF"><b>${prcList.ItemName}</b></font> 
	  </c:forEach>		  	
	   </li>
	   <li class="floatR pdR20">
	   <span class="icon" alt="CompareAttr" title="Compare Attributes" style="cursor:pointer;_cursor:hand"><img onclick="fnOpenCompareAttr();" src="${root}${HTML_IMG_DIR}/twomodels.png"></span>
	   <c:if test="${modelID != '' && modelID != null}" ><span class="icon" alt="Model" title="Model"  style="cursor:pointer;_cursor:hand"><img onclick="fnOpenModel();" src="${root}${HTML_IMG_DIR}/img_folderClosed.png"></img></span>&nbsp;</c:if>
	   	<span class="icon" alt="CHANGEMGT" title="Change info." style="cursor:pointer;_cursor:hand">
  			<img onclick="fnOpenCngtDetailInfo();" class="topIconImg" alt="imgCHANGEMGT" src="${root}${HTML_IMG_DIR}/sc_change.png"></img></span>
	   </li>
    </div>
	<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
		<c:forEach var="prcList" items="${prcList}" varStatus="status">
		<colgroup>
			<col width="11%">
			<col width="14%">
			<col width="11%">
			<col width="14%">
			<col width="11%">
			<col width="14%">
			<col width="11%">
			<col width="14%">
		</colgroup>
		<tr>
			<!-- 코드 -->
			<th class="viewtop">${menu.LN00106}</th>
			<td class="viewtop">${prcList.Identifier}</td>
			<!-- 항목계층 -->
			<th class="viewtop">${menu.LN00016}</th>
			<td class="viewtop">${prcList.ClassName}</td>
			<!-- 변경구분 -->
			<th class="viewtop">${menu.LN00022}</th>
			<td class="viewtop">${selectedCSInfo.ChangeTypeNM}</td>
			<!-- 시작일 -->
			<th class="viewtop" >${menu.LN00063}</th>
			<td class="tdLast viewtop">${selectedCSInfo.CreationTime}</td>
		</tr>
		<tr>
			<!-- 법인 -->	
			<th>${menu.LN00014}</th>
			<td>${selectedCSInfo.CompanyName}</td>
			<!-- 관리조직 -->
			<th>${menu.LN00018}</th>
			<td>${selectedCSInfo.AuthorTeamName}</td>
			<!-- 담당자 -->	
			<th>${menu.LN00004}</th>			
			<td  id="authorInfo" style="cursor:pointer;_cursor:hand">${selectedCSInfo.AuthorNM}</td>
			<!-- 완료일 -->
			<th>${menu.LN00064}</th>
			<td class="tdLast">${selectedCSInfo.CompletionDT}</td>
		</tr>
		</c:forEach>
		<tr>
			<!-- 첨부 및 관련 문서 --> 
			<th style="height:53px;">${menu.LN00019}</th>
			<td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div class="floatR pdR20">
				<c:if test="${attachFileList.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
					<input type="checkbox" name="checkedFile" value="${fileList.Seq}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
				</c:forEach>
				<c:forEach var="relatedfileList" items="${pertinentFileList}" varStatus="status">
					<input type="checkbox" name="checkedFile" value="${relatedfileList.Seq}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');">${relatedfileList.FileRealName}</span><br>
				</c:forEach>
				</div>
			</td> 
		</tr>
		<tr>
			<td colspan="8" class="hr1">&nbsp;</td>
		</tr>
	</table>
	<!--  //end 기본정보 -->
		<!-- BIGIN :: 속성 -->
		
		<c:if test="${attributesList.size() > 0}"> 
		<div id="attrList">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
				<c:forEach var="attrList" items="${attributesList}" varStatus="status"> 
						<colgroup>
							<col width="11%">
							<col width="89%">
						</colgroup>
						<tr>
							<th>
								<c:if test="${attrList.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name}
							</th>
							<td class="tdLast alignL pdL5"
							<c:if test="${attrList.DataType eq 'Text'}">style="height:${attrList.AreaHeight}px;" </c:if>
							>
								<c:if test="${attrList.HTML eq '1'}">
									<div style="width:100%;height:${attrList.AreaHeight}px;" >
										<textarea class="tinymceText" readonly="readonly">
											${attrList.PlainText}	
										</textarea>
									</div>
								</c:if>
								<c:if test="${attrList.HTML ne '1'}">	
									<c:if test="${attrList.Link == null}">
									<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText}</textarea></c:if>
									<c:if test="${attrList.Link != null || attrUrl != null}" >
										<a href="#" onClick="fnRunLink('${attrList.URL}','${attrUrl}');" style="color:#0054FF;text-decoration:underline;">
										${attrList.PlainText}
										</a>
									</c:if>
								</c:if>
							</td>
						</tr>													
					</c:forEach>
					<c:if test="${relItemRowList.size() > 0}">
					<tr>
						<td colspan="2" class="hr1">&nbsp;</td>
					</tr>
					</c:if>
				</table>				
			</div>
		</c:if>
		<!--  //end 속성 -->		
		
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
			<colgroup>
				<col width="11%">
				<col width="89%">			
			</colgroup>
			<tr>
				<!-- 변경내역 -->	
				<th>${menu.LN00136}</th>
				<td class="last alignL pdL5">				
					<textarea id="description" name="description" style="width:100%;height:150px;" readOnly>${selectedCSInfo.Description}</textarea>				
				</td>	
			</tr>
		</table>
				
		<!-- 최신이전 changeSet 정보   -->
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
			<colgroup>
				<col width="11%">
				<col width="39%">
				<col width="11%">
				<col width="39%">
			</colgroup>
			<tr>
				<td colspan="4" class="hr1">&nbsp;</td>
			</tr>
			<tr>
				<th>Next</th>
				<td class="tdLast alignL pdL5">	
				<c:if test="${nextChangeSetID != '' && nextChangeSetID != lastChangeSetID}">						
					<a href="#" onClick="fnNextViewVersionItemInfo('${nextChangeSetInfo.ChangeSetID}');" style="color:#0054FF;text-decoration:underline;">
					Version ${nextChangeSetInfo.Version}&nbsp; Last updated on&nbsp;${nextChangeSetInfo.CompletionDT}&nbsp; 
					by ${nextChangeSetInfo.AuthorName}
					</a>	
				</c:if>		
				<c:if test="${nextChangeSetID == '' || nextChangeSetID == lastChangeSetID}">
					<a href="#" onClick="fnOpenItemPop('${s_itemID}');" style="color:#0054FF;text-decoration:underline;">
					View current Item 
					</a>		
				</c:if>	
				</td>
				<th>Previous</th>
				<td class="tdLast alignL pdL5">	
					<c:if test="${preChangeSetID != ''}">							
					<a href="#" onClick="fnPreViewVersionItemInfo('${preChangeSetInfo.ChangeSetID}');" style="color:#0054FF;text-decoration:underline;">
					Version ${preChangeSetInfo.Version}&nbsp; Last updated on&nbsp;${preChangeSetInfo.CompletionDT}&nbsp; 
					by ${preChangeSetInfo.AuthorName}
					</a>		
					</c:if>	
				</td>
			</tr>
		</table>	
	</div>
</div>
	<!-- 담당자 레이어 팝업 -->	
	<div class="item_layer" id="layerPopup">
		<div>
		<div class="child_search_head_blue" style="border:0px;">
			<li class="floatL"><p>Employee information</p></li>
			<li class="floatR mgT10 mgR10">
				<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close" >
			</li>
		</div>	 
		<table class="tbl_blue01 mgT5" style="width:100%;height:99%;table-layout:fixed;border:0px;">
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>
				<tr>
					<td rowspan="6" style="border:0px;padding-top:10px;padding-bottom:10px;" >
						<c:if test="${authorInfoMap.Photo == 'blank_photo.jpg' }" >
							<img src='<%=GlobalVal.HTML_IMG_DIR%>${authorInfoMap.Photo}' >
						</c:if>
						<c:if test="${authorInfoMap.Photo != 'blank_photo.jpg' }" >
							<img src='<%=GlobalVal.EMP_PHOTO_URL%>${authorInfoMap.Photo}' >
						</c:if>	
					</td>
					<td class="alignL last" style="border-bottom:2px solid #ddd;border-top:0px;padding-top:10px;padding-bottom:10px;">${authorInfoMap.MemberName}&nbsp;(${authorInfoMap.EmployeeNum})</td>
				</tr>
				<tr>
					<td class="alignL" style="border:0px;">
						<div class="floatL" style="width:22%;font-weight:bold;">${menu.LN00014}</div>
						<div class="floatR" style="width:78%">${authorInfoMap.OwnerTeamName}</div>
					</td>
				</tr>
				<tr>
					<td class="alignL" style="border:0px;">
						<div class="floatL" style="width:22%;font-weight:bold;">${menu.LN00104}</div>
						<div class="floatR" style="width:78%">${authorInfoMap.TeamName}</div>
					</td>
				</tr>
				<tr>
					<td class="alignL" style="border:0px;">
						<div class="floatL" style="width:22%;font-weight:bold;">E-mail</div>
						<div class="floatR" style="width:78%;">${authorInfoMap.Email}</div>
					</td>
				</tr>
				<tr>
					<td class="alignL" style="border:0px;">
						<div class="floatL" style="width:22%;font-weight:bold;">Tel</div>
						<div class="floatR" style="width:78%">${authorInfoMap.TelNum}</div>
					</td>
				</tr>
				<tr>
					<td class="alignL" style="border:0px;">
						<div class="floatL" style="width:22%;font-weight:bold;">Mobile</div>
						<div class="floatR" style="width:78%">${authorInfoMap.MTelNum}</div>
					</td>
				</tr>
			</table> 
		</div>
	</div> 
	
	
</form>

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>	
<!-- END :: FRAME -->
</body>
</html>
