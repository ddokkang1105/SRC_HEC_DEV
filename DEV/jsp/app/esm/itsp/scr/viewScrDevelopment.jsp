<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script>
	
	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=SCR&docCategory=SCR&id=${scrId}&fltpCode=${fltpCode}";
		openPopup(url+"?"+data,480,450, "Attach File");
	}	
	
	function setSubFrame(){
		parent.fnClickedTab(9);
	}
	
	function fnSaveScrDevComment(){		
		if(!confirm("${CM00001}")){ return;}
		let url = "saveScrDevComment.do";
		ajaxSubmit(document.scrADFrm, url, "saveFrame");
	}
	
	function fnFileDownLoad(seq){	
		let url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.scrADFrm, url,"saveFrame");
	}

</script>
<div id="viewScrDiv">
	<form name="scrADFrm" id="scrADFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="scrID" name="scrID" value="${scrId}" >
		<div class="floatC" style="overflow:auto;overflow-x:hidden;">
			<div class="floatR mgR10 mgB20">
				<span class="btn_pack nobg"><a class="upload" onclick="fnMultiUploadV4()" title="Upload"></a></span>
				<span class="btn_pack nobg"><a class="save" onclick="fnSaveScrDevComment()" title="Save"></a></span>
			</div>
			<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col width="85%">
				</colgroup>
				<tr>
					<th class="alignL pdL10 viewline">Development Comment</th>
					<td colspan=3 class="last">				
					<textarea class="txt_file_upload" name="developmentComment" id="developmentComment" style="width:100%;height:100px;resize: none;">${scrInfo.DevelopmentComment}</textarea>
					</td>
				</tr>
				
				
				<tr>
					<th class="alignL pdL10 viewline">산출물</th>
					<td class="last">
						<table class="tbl_blue01" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="5%">
								<col width="15%">
								<col width="20%">
								<col width="35%">
								<col width="10%">
							</colgroup>
							<tr>
								<th class="">No</th>
								<th class="viewline">${menu.LN00091}</th>
								<th class="viewline">${menu.LN00101}</th>
								<th class="viewline">${menu.LN00070}</th>
								<th class="viewline last">${menu.LN00060}</th>
							</tr>
							<c:forEach var="fileList" items="${fileList}" varStatus="status">
							<tr>
								<td class="last">${fileList.RNUM}</td>
								<td class="last">${fileList.FltpName}</td>
								<td class="alignL pdL10 last"><span onclick="fnFileDownLoad('${fileList.FileID}')" style="color:#1236b7; font-weight:bold; cursor:pointer;">${fileList.FileRealName2}</span></td>
								<td class="last">${fileList.LastUpdated}</td>
								<td class="last">${fileList.LastUser}</td>
							</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
				
			</table>
		</div>
	</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>