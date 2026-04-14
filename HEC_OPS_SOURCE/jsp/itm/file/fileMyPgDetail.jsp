<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>
<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		 var data = "&itemClassCode=${itemClassCode}";
		fnSelectNone('FltpCode', data, 'fltpCode', '${fileMap.FltpCode}'); 
	});
	
	function fnOpenItemDetail(){ 
		var ItemID = "${fileMap.ItemID}";
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${fileMap.ItemID}&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function goBack(){
		if(confirm("${CM00003}")){fnGoList();
		}
	}
	function fnGoList(){
		var url = "goFileMyPgList.do";
		var data = "&pageNum=${pageNum}";
		var target = "documentDetailFrm";
		ajaxPage(url, data, target);
	}
	
	function fnSave(){
		if(confirm("${CM00001}")){	
		// if(!fnCheckValidation()){return;}
			var url  = "saveItemFileDetail.do";
			ajaxSubmit(document.documentDetailFrm, url,"saveFrame");
		}
	}
	
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
		var data="scrnType=ITM&browserType="+browserType+"&mgtId="+""+"&id="+$('#ItemID').val();
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
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
	}	
	function fileNameClick(avg1, avg2, avg3, avg4){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		seq[0] = avg4;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.documentDetailFrm, url,"blankFrame");
	}	
</script>
<form name="documentDetailFrm" id="documentDetailFrm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="SysFile" name="SysFile" value="${fileMap.SysFile}" >
	<input type="hidden" id="ItemID" name="ItemID" value="${fileMap.ItemID}" >
	<input type="hidden" id="Seq" name="Seq" value="${fileMap.Seq}" >
<div class="cfg">
	<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/sc_file.png"></img>&nbsp;${menu.LN00019}&nbsp;${menu.LN00108}</li>
</div><br>
<div style="height:26px;border-bottom:1px solid #ccc"></div>
<table style="table-layout:fixed;" class="tbl_blue01 mgT10" width="100%" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="15%">
		<col width="35%">
		<col width="15%">
		<col width="35%">
	</colgroup>
	<c:if test="${isNew == 'N'}">
	<tr>
		<th class="viewtop">${menu.LN00101}</th>
		<td class="viewtop"  align="left">
			<div style="width:100%;overflow:auto;overflow-x:hidden;">
				<div id="divDownFile${fileMap.Seq}"  class="mm" name="divDownFile${fileMap.Seq}">
					<span style="cursor:pointer;" onclick="fileNameClick('${fileMap.FileName}','${fileMap.FileRealName}','','${fileMap.Seq}');">${fileMap.FileRealName}</span>
					<br>
				</div>
			</div>
		</td>
		<th class="viewtop">${menu.LN00060}</th>
		<td class="viewtop last"  align="left">${fileMap.WriterName}</td>
	</tr>
	<tr>
		<th>${menu.LN00043}</th>
		<td align="left">
			<a href="#"  OnClick="fnOpenItemDetail()"> ${fileMap.Path}</a>
		</td>
		<th>${menu.LN00018}</th>
		<td class="last"  align="left">${fileMap.TeamName}</td>
	</tr>
	<tr>
		<th>${menu.LN00091}</th>
		<td align="left">
			<select id="FltpCode" name="FltpCode" class="sel" value="${fileMap.FltpCode}" style="margin-left=5px;">
			</select>
		</td>
		<th>${menu.LN00070}</th>
		<td class="last"  align="left">${fileMap.LastUpdated}</td>
	</tr>
	</c:if>
	<c:if test="${isNew == 'Y'}">
	<tr>
		<th  class="viewtop">${menu.LN00091}</th>
		<td  align="left" colspan="3"  class="viewtop">
			<select id="FltpCode" name="FltpCode" class="sel" value="${fileMap.FltpCode}" style="margin-left=5px;">
			</select>
		</td>
	</tr>
	</c:if>
	<tr>
		<!-- 첨부문서 -->
		<th>${menu.LN00019}</th>
		<td colspan="3" class="last alignL pdL5">
			<div id="tmp_file_items" name="tmp_file_items"></div>
		</td>
	</tr>	
	<tr>
		<td colspan="8" style="height:180px;" class="tit last">
		<textarea id="Description" name="Description" style="width: 100%; height: 98%" >${fileMap.Description}</textarea></td>
	</tr>
	<tr>
		<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFile()"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSave()"></span>
			<c:if test="${isNew == 'N'}"><span class="btn_pack medium icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span></c:if>
		 	<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
		</td>
	</tr>
</table>
</form>	
<!-- START :: FRAME -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
		
