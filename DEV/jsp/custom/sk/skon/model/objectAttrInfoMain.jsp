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
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script src="${root}cmm/js/tinymce_v5/tinymce.min.js" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120" />
<script type="text/javascript">
	var chkReadOnly = true;
</script>

<head>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">

$(document).ready(function(){
});


	
	function fnUrlReload(){
		var screenType = "${screenType}";
		if(screenType=="model"){		
			reload();
		}else{
			parent.document.getElementById("diagramInfo").src="zSKON_elmInfoTabMenu.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
		}
	} 
	
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function editPopup(url){
	   	var data = "?itemID=${s_itemID}&s_itemID=${s_itemID}&option=${option}"
	   		+"&itemEditPage=custom/sk/skon/model/editActivityInfoPop"
	   		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
			+"&languageID="+$('#languageID').val();  	
	    var w = 940;
		var h = 700;
		window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
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
				filePath[0] = checkObjVal[2]
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
			 var viewerForm = document.viewerForm;
			 var url = "openViewerPop.do";
			 window.open("" ,"viewerForm", "width="+screen.width+", height="+screen.height); 
			 viewerForm.action =url;
			 viewerForm.method="post";
			 viewerForm.target="viewerForm";
			 viewerForm.seq.value = +seq[0];
//			var url = "openViewerPop.do?seq="+seq[0];
//			var w = screen.width;
//			var h = screen.height;
			
			if(avg5 != "") { 
				viewerForm.isNew.value = "N";
//				url = url + "&isNew=N";
			}
			else {
				viewerForm.isNew.value = "Y";
//				url = url + "&isNew=Y";
			}
//			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
//			//window.open(url,1316,h); 
			
			 viewerForm.submit();
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}


	
</script>
<style>
	.textAreaResize {	 
	  resize: both !important; /* 사용자 변경이 모두 가능 */
	}
	
	.link {
	color: #193598;
	text-decoration: underline;
	cursor:pointer;
	}
	
	.cxnLink {
		flex-direction: column; !important;
	}
</style>
<form name ="viewerForm" >
	<input type="hidden" id="seq" name="seq" value="">
	<input type="hidden" id="isNew" name="isNew" value="">
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:100%;">
	<div id="obAttrDiv" style="margin-bottom:20px;overflow-x:hidden;overflow-y:hidden;" >
	 	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
			<div class="alignBTN">
				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" onclick="editPopup('processItemInfo.do')" type="submit"></span>
			</div>
		</c:if>

		<table class="tbl_blue01 pdL10" style="width:100%;margin:5px;" >
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col>
			</colgroup>
			
			<c:forEach var="activity" items="${activityListData}">
					<!-- Activity명 -->
					<tr>
						<th class="alignC last">${menu.ZLN0109}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;" onclick="doDetail(${activity.ItemID})">${activity.Activity}</td>
							
					<tr>			
						<td class="alignC last" colspan="4" >
						<textarea class="tinymceText" style="height:600px;" readonly="readonly">
							<div class="mceNonEditable">${activity.Outline}</div>		
							</textarea>
						</td>
					</tr>			
					<!-- R / A / S / I -->
					<tr>
						<th class="alignC last">${menu.ZLN0126}</th>
						<th class="alignC last">${menu.ZLN0127}</th>
						<th class="alignC last">${menu.ZLN0128}</th>
						<th class="alignC last">${menu.ZLN0129}</th>
					</tr>
					<tr>
						<td class="alignC last cxnLink">${r_text}</td>
						<td class="alignC last cxnLink">${a_text}</td>
						<td class="alignC last cxnLink">${s_text}</td>
						<td class="alignC last cxnLink">${i_text}</td>
					</tr>	
					<!-- 입력물 -->	
					<tr>
						<th class="alignC last">${menu.ZLN0110}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.Input}</td>
					</tr>	
					<!-- 출력물 -->	
					<tr>
						<th class="alignC last">${menu.ZLN0111}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.Output}</td>
					</tr>	
					<!-- 수행 시스템 -->		
					<tr>
						<th class="alignC last">${menu.ZLN0112}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.PerformanceSystem}</td>
					</tr>	
		
					<c:if test="${itemFileOption ne 'VIEWER' and itemFileOption ne 'PDFCNVT' }">
						<tr>
							<!-- 첨부문서 --> 
							<th style="height:53px;">${menu.LN00019}</th>
							<td style="height:53px;" class="tdLast alignL pdL5" colspan="3">
								<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
									<div class="floatR pdR20">
									<c:if test="${attachFileList.size() > 0}">
										<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
										<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
									</c:if>
									</div>					
										<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
											<input type="checkbox" name="checkedFile" value="${fileList.FileName}/${fileList.FileRealName}//${fileList.Seq}" class="mgL2 mgR2">
											<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
										</c:forEach>								
								</div>
							</td> 
						</tr>
					</c:if>			
					<c:if test="${itemFileOption eq 'VIEWER' || itemFileOption eq 'PDFCNVT' }">
					<tr>
						<!-- 첨부문서 --> 
						<th style="height:53px;">${menu.LN00019}</th>
						<td style="height:53px;" class="tdLast alignL pdL5" colspan="3">
							<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
							<div class="floatR pdR20"></div>
							
							<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
								&nbsp;&nbsp;
								<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
								&nbsp;
								<%-- <c:if test="${myItem == 'Y'}"> --%>
								<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
								<%-- </c:if> --%>
								<br>
							</c:forEach>
						</div>
						</td> 
					</tr>
					</c:if> 
			 </c:forEach>
		</table>
	</div>			
	</div>
</form>

</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
