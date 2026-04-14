<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		var data = "&itemClassCode=${classCode}"; 
		fnSelectNone('FltpCode', data, 'fltpCode', '${fileMap.FltpCode}'); 
	
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnOpenItemDetail(){ 
		var ItemID = "${fileMap.DocumentID}";
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${fileMap.DocumentID}&scrnType=pop";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function goBack(){
		/* var url = "documentGridList.do";
		var data = "&pageNum=${pageNum}&DocumentID=${fileMap.DocumentID}&frmType=documentDetailFrm&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}&docType=${docType}&parentID=${parentID}&screenType=${screenType}";
		//var target = "documentDetailFrm";
		var target = "help_content";
		ajaxPage(url, data, target); */
		fnCallBack();
	}
	
	function fnSave(){
		if(confirm("${CM00001}")){	
		// if(!fnCheckValidation()){return;}
			var url  = "saveItemFileDetail.do";
			ajaxSubmit(document.documentDetailFrm, url,"saveFrame");
		}
	}
	
	function fnCallBack(){window.opener.doSearchList(); self.close(); };
	
	function fnDeleteFile(){
		if(confirm("${CM00002}")){
			var url  = "deleteFile.do";
			ajaxSubmit(document.documentDetailFrm, url,"saveFrame");
		}
	}
	function doAttachFile(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=ITM&browserType="+browserType+"&mgtId="+""+"&id="+$('#DocumentID').val();
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,410,410, "Attach File");}
	}
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	function fnAttacthFileHtml(seq, fileName){
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
			'	<br>'+
			'</div>';		
		$("#tmp_file_items").html(display_scripts);		
	}	
	function fileNameClick(avg1, avg2, avg3, avg4){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		seq[0] = avg4;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
	}	
	
</script>
<div style="padding: 10px 20px 10px 20px;margin:0 auto;width:96%;">
<form name="documentDetailFrm" id="documentDetailFrm" action="*"  enctype="multipart/form-data" method="post" onsubmit="return false;">
	<input type="hidden" id="SysFile" name="SysFile" value="${fileMap.SysFile}" >
	<input type="hidden" id="DocumentID" name="DocumentID" value="${fileMap.DocumentID}" >
	<input type="hidden" id="ItemID" name="ItemID" value="${fileMap.DocumentID}" >
	<input type="hidden" id="Seq" name="Seq" value="${fileMap.Seq}" >
	<input type="hidden" id="screenType" name="screenType" value="${screenType}" >
	<input type="hidden" id="DocCategory" name="DocCategory" value="${fileMap.DocCategory}" >
	<input type="hidden" id="FltpCode" name="FltpCode" value="${fileMap.FltpCode}" >
			
<div>
	<ul>
		<li class="floatL"><h3 style="padding: 6px 0 6px 0">
		<img src="${root}${HTML_IMG_DIR}/sc_file.png"></img>&nbsp;${menu.LN00019}&nbsp;${menu.LN00108}
		</li>
	</ul>
</div><br>
<div style="border-bottom:1px solid #ccc;">&nbsp;</div>
<table style="table-layout:fixed;" class="tbl_blue01 mgT10" width="100%" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="15%">
		<col width="35%">
		<col width="15%">
		<col width="35%">
	</colgroup>
	<tr>
		<th class="viewline">${menu.LN00101}</th>
		<td align="left">
			<div style="width:100%;overflow:auto;overflow-x:hidden;">
				<div id="divDownFile${fileMap.Seq}"  class="mm" name="divDownFile${fileMap.Seq}">
					<span style="cursor:pointer;color:#0054FF;text-decoration:underline;" onclick="fileNameClick('${fileMap.FileName}','${fileMap.FileRealName}','','${fileMap.Seq}');">${fileMap.FileRealName}</span>
					<br>
				</div>
			</div>
		</td>
		<th>${menu.LN00043}</th>
		<td class="last"  align="left">
		<a href="#"  OnClick="fnOpenItemDetail()" style="color:#0054FF;text-decoration:underline;">${fileMap.Path}</a>			
		</td>
	</tr>	
	<tr>
		<th class="viewline">${menu.LN00091}</th>
		<td  align="left">
				${fileMap.FltpName}
		</td>
		<th>${menu.LN00131}</th>
		<td class="last" align="left">${fileMap.ProjectName} / ${fileMap.CsrName} </td>	
	</tr>
	</tr>
		<th class="viewline">${menu.LN00060}</th>
		<td  align="left">${fileMap.WriterName}</td>
		<th>${menu.LN00018}</th>
		<td class="last"  align="left">${fileMap.TeamName}</td>
	</tr>
	
	<tr>
	<th class="viewline">${menu.LN00013}</th>
		<td align="left">${fileMap.CreationTime}</td>
		
		<th>${menu.LN00070}</th>
		<td class="last"  align="left">${fileMap.LastUpdated}</td>
		
		
	</tr>
	<c:if test="${docType == 'myDoc'}">
	<tr>
		<!-- 첨부문서 -->
		<th class="viewline">${menu.LN00019}</th>
		<td colspan="3" class="last alignL pdL5">
			<div id="tmp_file_items"></div>
		</td>
	</tr>	
	</c:if>
	<tr>
		<td colspan="8" style="height:180px;" class="tit line last">
		<textarea class="edit" id="Description" name="Description" style="width:100%;height:160px;">${fileMap.Description}</textarea>
		</td>
	</tr>
	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
	 	<c:if test="${docType == 'myDoc' || isMember == 'Y'}">
			<c:if test="${fileMap.DocCategory == 'ITM' || (fileMap.DocCategory == 'PJT' && (fileMap.PjtStatus == 'CNG' || fileMap.PjtStatus == 'CSR'))}">
				<tr>
					<td class="alignR pdR20 line last" bgcolor="#f9f9f9" colspan="8">
					<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSave()"></span>
					<span class="btn_pack medium icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span>
					</td>
				</tr>
			</c:if>
	  	</c:if>			    
	</c:if>	 	
</table>
</form>	
</div>
<!-- START :: FRAME -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
		
