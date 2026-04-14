<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- Script -->

<script type="text/javascript">
	
	$(document).ready(function() {
		 var data = "&itemClassCode=${itemClassCode}";
		fnSelectNone('FltpCode', data, 'fltpCode', '${fileMap.FltpCode}'); 
		$("#Description").disabled=false;
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function fnOpenItemDetail(){ 
		var ItemID = "${fileMap.DocumentID}";
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${fileMap.DocumentID}&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function goBack(){
		fnGoList();
	}
	
	function fnCallBack(){opener.doSearchList(); self.close();};
	function fnGoList(){ 
		try{	
			window.opener.doSearchList();
		}catch(e){}
		/* var url = "goFileList.do";
		var data = "&pageNum=${pageNum}&itemId=${fileMap.ItemID}&frmType=documentDetailFrm";
		var target = "documentDetailFrm";
		ajaxPage(url, data, target); */
	}
	
	function fnSave(){
		if(confirm("${CM00001}")){	
		// if(!fnCheckValidation()){return;}
			var url  = "saveItemFileDetail.do";
			ajaxSubmit(document.documentDetailFrm, url,"saveFrame");
		}
	}
	
	function fnBlock(avg){
		if(confirm("${CM00001}")){	
			$("#Blocked").val(avg);
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
		else{openPopup(url+"?"+data,490,410, "Attach File");}
	}
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	function fnAttacthFileHtml(seq, fileName){
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteFileHtml('+seq+')">'+
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
		
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		$('#RefFileID').val("");
		var data="scrnType=ITM&mgtId="+""+"&id="+$('#ItemID').val();
		openPopup(url+"?"+data,480,450, "Attach File");
	}
	
	function fnAdd(){ 
		var url="addFilePopV4.do";
		$('#RefFileID').val(${fileMap.RefFileID});
		var data="scrnType=ITM&mgtId="+""+"&id="+$('#ItemID').val()+"&refFileID="+$('#RefFileID').val();
		openPopup(url+"?"+data,480,450, "Attach File");
	}	

</script>
 <body style="overflow: auto;">
<div style="padding: 10px 0 10px 0;margin:0 auto;width:98%;">
<form name="documentDetailFrm" id="documentDetailFrm" action="*"  enctype="multipart/form-data"  method="post" onsubmit="return false;">
	<input type="hidden" id="SysFile" name="SysFile" value="${fileMap.SysFile}" >
	<input type="hidden" id="ItemID" name="ItemID" value="${fileMap.DocumentID}" >
	<input type="hidden" id="DocumentID" name="DocumentID" value="${fileMap.DocumentID}" >
	<input type="hidden" id="Seq" name="Seq" value="${fileMap.Seq}" >
	<input type="hidden" id="DocCategory" name="DocCategory" value="${fileMap.DocCategory}" >
	<input type="hidden" id="Blocked" name="Blocked" value="${fileMap.Blocked}" >
	<input type="hidden" id="FltpCode" name="FltpCode" value="${fileMap.FltpCode}" >
	<input type="hidden" id="RefFileID" name="RefFileID" value="" >
<div  style="border-bottom:1px solid #ccc;padding-bottom:5px;"><img src="${root}${HTML_IMG_DIR}/sc_file.png"></img>&nbsp;${menu.LN00019}&nbsp;${menu.LN00108}</div>

<table style="table-layout:fixed;" class="tbl_blue01 mgT10" width="100%" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="15%">
		<col width="35%">
		<col width="15%">
		<col width="35%">
	</colgroup>
	<tr>
		<th>${menu.LN00101}</th>
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
			<a href="#" style="color:#0054FF;text-decoration:underline;" OnClick="fnOpenItemDetail()"> ${fileMap.Path}</a>
		</td>
		
	</tr>	
	<tr>
		<th>${menu.LN00091}</th>
		<td align="left">${fileMap.FltpName}</td>
		<th>${menu.LN00131}</th>
		<td class="last" align="left">${fileMap.ProjectName} / ${fileMap.CsrName}</td>
	
	</tr>
	<tr>
		<th>${menu.LN00060}</th>
		<td align="left">${fileMap.WriterName}(${fileMap.TeamName})</td>
		
		<th>${menu.LN00017}</th>
		<td class="last"  align="left">${fileMap.CSVersion }</td>
	</tr>
	<tr>
		<th>${menu.LN00078}</th>
		<td align="left">${fileMap.CreationTime}</td>		
		<th>${menu.LN00070}</th>
		<td class="last"  align="left">${fileMap.LastUpdated}</td>
	</tr>
	<tr>
		<td colspan="4" style="height:180px;" class="last">
		<textarea class="edit" id="Description" name="Description" style="width: 100%; height: 160px;" >${fileMap.Description}</textarea>		
		</td>
	</tr>
	<tr>
		<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="4">
		<c:if test="${selectedItemBlocked == '0' && fileMap.Blocked ne 2 && (selectedItemAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == '1')}" >		
		<span class="btn_pack medium icon"><span class="add"></span><input value="New" type="submit" onclick="fnAdd()"></span>
		<span class="btn_pack medium icon"><span class="upload"></span><input value="Modify" type="submit" onclick="doAttachFileV4()"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSave()"></span>			
		</c:if>
		</td>
	</tr>
</table>
<div id="fileLogDiv">
<div  id = TOT_CNT  style="border-bottom:1px solid #ccc;padding-top:5px;padding-bottom:5px;"><img src="${root}${HTML_IMG_DIR}/sc_file.png"></img>&nbsp;${menu.LN00019}&nbsp;기록 </div>
<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10 clear">
			<div id="layout" style="width:100%"></div>
				<div id="pagination"></div>	
		</div>
<!-- END :: LIST_GRID -->
</div>




</form>	
</div>
<!-- START :: FRAME -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
		
<script type="text/javascript">
var useFileLog = "<%=GlobalVal.USE_FILE_LOG%>";

if(useFileLog != "Y"){
	$("#fileLogDiv").attr('style', 'display: none');
	$("#filelogBtn").attr('style', 'display: none');
}else{
	if(${selectedItemBlocked == '0' && fileMap.Blocked ne 2 && (selectedItemAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == '1')}){
		$("#layout").attr("style","height:"+(setWindowHeight() - 507)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 507)+"px;");
		};
		var pagination;
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		var gridData = ${gridData};
		var grid = new dhx.Grid("grid", {
		    columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" }, 
		        { id: "Time", header: [{ text: "${menu.LN00335}", align: "center" } ], align: "center" },
		        { width: 100, id: "Name", header: [{ text: "${menu.LN00072}", align: "center" } ], align: "center" },
			    { width: 150, id: "TeamName", header: [{ text: "${menu.LN00098}", align: "center" } ], align: "center" },
		        { width: 100, id: "FileOption", header: [{ text: "${menu.LN00042}", align: "center" } ], align: "center" },

		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		layout.getCell("a").attach(grid);
		 pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 5,
		});
		 $("#TOT_CNT").append("(Total " + grid.data.getLength() + ")");
	}
} </script>