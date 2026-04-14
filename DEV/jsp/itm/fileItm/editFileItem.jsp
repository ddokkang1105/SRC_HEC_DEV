<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html> 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00191}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00139" var="WM00139" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<head>
<style>
	#editFileItemDiv > div {
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
	 width: 97%;
    border: 1px solid #ccc;
    display: block;
    padding-top: 10px;
    padding-left: 10px;
    margin: 0px auto 15px;
    overflow-x: auto;
    line-height: 18px;
	}
	#maintext  textarea {
	width: 100%;
	resize:none;
	}
	
	#attr_content {
      width: 100%;
      height: 430px;
      border: 1px solid #ccc;
    }
</style>
<script type="text/javascript">

	$(document).ready(function(){	
		var height = setWindowHeight();
		document.getElementById("htmlReport").style.height = (height - 20)+"px";
		window.onresize = function() {
			height = setWindowHeight();
			document.getElementById("htmlReport").style.height = (height - 20)+"px";	
		};
		
		$("#tdClass").attr("colspan",3);
		$("#dimY1").attr('style', 'display:none');
		$("#dimY2").attr('style', 'display:none');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${itemID}&AuthorID=${sessionScope.loginInfo.sessionUserId}";
		fnSelect('classCode', data, 'getClassOption', '${itemInfo.ClassCode}', 'Select',"item_SQL");	
		fnSelect('csrID', data, 'getCsrListWithMember', '${itemInfo.ProjectID}', 'Select',"project_SQL");
		fnSelectHasDimension("${itemInfo.ClassCode}","Y");
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnCheckIdentifier(){
		var identifier = $("#identifier").val();
		if(identifier == "${itemInfo.Identifier}"){
			fnReturnCheckID(0);			
		}else{
			if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
			var url = "checkIdentifier.do";
			var data = "identifier="+identifier+"&itemTypeCode=${itemTypeCode}";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnReturnCheckID(CNT){
		if(CNT == "0"){			
			$('#idCheckYN').val('Y');
			$("#checkID").html("사용할 수 있는 ID 입니다.");
			$("#checkID").attr("color","green");
		}else{
			$('#idCheckYN').val('N');
			$("#checkID").html("사용할 수 없는 ID 입니다.");
			$("#checkID").attr("color","red");
		}
		return;
	}
	
	function fnSelectHasDimension(classCode, loadYN){ 
		if(classCode == "") return;		
		if(loadYN == "Y" || classCode == "${classCode}"){
			fnLoadAttrTypeFrame(classCode); 
		} 
		// else { fnChangeClassAttrTypeFrame(classCode);}
		var url = "getHasDimension.do";
		var data = "itemClassCode="+classCode;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}

	function fnSetDimension(hasDimension, autoID, preFix){ 
		$("#autoID").val(autoID);
		$("#preFix").val(preFix);
		if(autoID == "Y"){
			$("#identifier").attr('readOnly', true);
			$("#idCheck").attr('style', 'display:none');
		}else{
			$("#identifier").attr('readOnly', false);
			$("#idCheck").attr('style', 'display:done');
		}
		
		if(hasDimension == "1"){
			$("#tdClass").attr("colspan",0);
			$("#dimY1").attr('style', 'display:done;');
			$("#dimY2").attr('style', 'display:done;');
			
			var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
			fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
		}else{
			$("#tdClass").attr("colspan",3);
			$("#dimY1").attr('style', 'display:none');
			$("#dimY2").attr('style', 'display:none');
		}
	}
	
	function fnLoadAttrTypeFrame() {
		if($('#isSubmit').val() == 'true') $('#isSubmit').remove(); 
		var url = "editFileItemAttrFrame.do";
		var target = "attrFrame";
		ajaxSubmit(document.editFileItemFrm, url, target);
	}
	
	function fnChangeClassAttrTypeFrame() {
		if($('#isSubmit').val() == 'true') $('#isSubmit').remove(); 
		var url = "editFileItemAttrFrame.do"; 
		var target = "attrFrame";
		ajaxSubmit(document.editFileItemFrm, url, target);
	}
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR"; // &fltpCode=SRDOC
		openPopup(url+"?"+data,490,450, "Attach File");
	} 
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	function fnAttacthFileHtmlV4(fileID, fileName){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID);
		fileNameMapV4.set(fileID,fileName);
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
	}
	
	function fnDisplayTempFileV4(){				
		display_scripts=$("#tmp_file_items").html(); 
		fileIDMapV4.forEach(function(fileID) {			  
			  display_scripts = display_scripts+
				'<div id="'+fileID+'"  class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+')">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){		
		var fileName = document.getElementById(fileID).innerText;		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}
	} 
	//************** addFilePop V4 설정 END ************************//
	
	function fnSaveItem(){	
		var csrID = $("#csrID").val();
		var classCode = $("#classCode").val();
		var identifier = $("#identifier").val();
		var idCheckYN = $("#idCheckYN").val();
		var itemName = $("#itemName").val();
		var autoID = $("#autoID").val();
		
		if(identifier == "${itemInfo.Identifier}"){
			idCheckYN = "Y";	
		}
		
		if(csrID == ""){alert("${WM00041_2}");$("#csrID").focus();return false;}		
		if(classCode == ""){alert("${WM00041_1}");$("#classCode").focus();return false;}		
		if(autoID != "Y"){ if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
						   if(idCheckYN != "Y"){alert("${WM00139}");return false;} 
						 }
		if(itemName == ""){alert("${WM00034_2}");$("#itemName").focus();return false;}
		
		if(confirm("${CM00001}")){	
		  	$('#attrFrame').get(0).contentWindow.fnSaveItemMst('${itemID}','${s_itemID}');
		}
	}
	
	function fnCallBackSaveItemMST(itemID){
		if("pop" == "pop"){
			opener.doSearchList();			
			var url = "viewFileItem.do?s_itemID=${s_itemID}&classCode=${itemInfo.ClassCode}&itemID="+itemID;
			var target = "editFileItemDiv";
			var data = "s_itemID=${s_itemID}&classCode=${classCode}&itemID=${itemID}";		
			ajaxPage(url, data, target);
		}else{
			parent.fnRefreshTree(s_itemID,true);
		}
	}
		
</script>
</head>
<form name="editFileItemFrm" id="editFileItemFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="itemID" name="itemID" value="${itemID}">
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
 	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="editFileItemDiv">
			<div id="process" class="mgT10">
				<ul class="floatL pdB5">
					<p class="cont_title">${menu.LN00005} &nbsp; ${menu.LN00046}</p>
				</ul>
				<ul class="floatR pdB5">	
					<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>&nbsp;&nbsp;
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveItem();"></span>&nbsp;&nbsp;
				</ul>
				
				<table class="tbl_preview mgB10">
					<colgroup>
						<col width="15%">
						<col width="35%">
						<col width="15%">
						<col width="35%">
					</colgroup>
					<tr>
						<th>${menu.LN00191}</th>
						<td class="alignL pdL10">
							<select id="csrID" name="csrID" class="mgR10" style="width:290px"></select>
						</td>						
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10">${itemInfo.Path}</td>
					</tr>
					<tr>
						<th>${menu.LN00016}</th>
						<td id="tdClass" class="alignL pdL10">
							<select id="classCode" name="classCode" OnChange="fnSelectHasDimension(this.value)" class="mgR10" style="width:290px"></select>
						</td>
						
						<th id="dimY1">Dimension</th>
						<td id="dimY2" class="alignL pdL10">
							<select id="dimTypeID" name="dimTypeID" OnChange="fnGetDimTypeValue(this.value);" style="width:47%"></select>
							<select id="dimTypeValueID" name="dimTypeValueID" style="width:45%"></select>
						</td>
					</tr>
					<tr>
						<th>Code</th>
						<td class="alignL pdL10">
							<input type="text" id="identifier" name="identifier" class="text"  style="width:287px" value="${itemInfo.Identifier}">							
							<span id="idCheck" name="idCheck"  class="btn_pack medium icon"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier()" type="submit"></span>
							<input type="hidden" id="idCheckYN" name="idCheckYN">
							<font id="checkID" size=2></font>
						</td>
						<th>${menu.LN00028}</th>
						<td class="alignL pdL10">
							<input type="text" id="itemName" name="itemName" class="text" style="width:92%" value="${itemInfo.ItemName}" >
						</td>
					</tr>
					<tr>
					<!-- 첨부문서 -->
					<th style="height:53px;">${menu.LN00111}</th>
					<td colspan="3" style="height:53px;" class="alignL pdL5 last">
						<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:if test="${itemFiles.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
						</c:if>
						</div>
						</div>
					</td>
				</tr>
				</table>
			</div>
			
			<div id="maintext" class="mgB10">
				<p class="cont_title">${menu.LN00031}</p>
				 <div id="attr_content">
			        <iframe name="attrFrame" id="attrFrame" style="width:100%;height:100%;" frameborder="0"></iframe> 
			     </div>			     
			</div>
			
			<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgL10 mgB10 mgT10 mgR10">
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
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
								(<span id="fileSize">${fileList.FileSize}</span>)
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
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</form>
