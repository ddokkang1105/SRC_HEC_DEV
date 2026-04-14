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
	var chkReadOnly = true;
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
		document.getElementById("htmlReport").style.height = (height - 95)+"px";
		window.onresize = function() {
			height = setWindowHeight();
			document.getElementById("htmlReport").style.height = (height - 95)+"px";	
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnCheckIdentifier(){
		var identifier = $("#identifier").val();
		if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
		var url = "checkIdentifier.do";
		var data = "identifier="+identifier+"&itemTypeCode=${itemTypeCode}";
		var target = "blankFrame";
		ajaxPage(url, data, target);
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
	
	function fnSelectHasDimension(classCode){ 
		if(classCode == "") return;		
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
	
	function fnEditFileItem(){
		var url = "editFileItem.do";
		var target = "itemDiv";
		var data = "s_itemID=${s_itemID}&classCode=${classCode}&itemID=${itemID}";		
		ajaxPage(url, data, target);
	}
	
		
</script>
</head>
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
 	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div id="process" class="mgT10">
				<ul class="floatL pdB5">
					<p class="cont_title">${menu.LN00005}&nbsp;${menu.LN00108}</p>
				</ul>
				<%-- <ul class="floatR pdB5">	
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
						<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditFileItem();"></span>&nbsp;&nbsp;
						</c:if>
					</c:if>
				</ul> --%>
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
							${itemInfo.ProjectName}
						</td>						
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10">${itemInfo.Path}</td>
					</tr>
					<tr>
						<th>${menu.LN00016}</th>
						<td id="tdClass" class="alignL pdL10">
							${itemInfo.ClassName}
						</td>
						<td id="dimY2" class="alignL pdL10" colspan="2">
							<c:forEach var="dimList" items="${dimResultList}" varStatus="status">
								<c:if test="${status.count > 1}" >,</c:if>${dimList.dimTypeName}/${dimList.dimValueNames}
							</c:forEach>							
						</td>
					</tr>
					<tr>
						<th>Code</th>
						<td class="alignL pdL10">${itemInfo.Identifier}
						</td>
						<th>${menu.LN00028}</th>
						<td class="alignL pdL10">
							${itemInfo.ItemName}
						</td>
					</tr>					
				</table>
			</div>
			
			<div id="process" class="mgT10">
			<p class="cont_title">${menu.LN00031}</p>		
		    <c:if test="${attributesList.size() > 0}">
			<div id="attrList">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
					<c:forEach var="attrList" items="${attributesList}" varStatus="status">
						<c:choose>
				   		<c:when test="${columnNum2YN eq 'N' }" >
				   			<colgroup>	
								<col width="15%">
								<col width="85%">
							</colgroup>
				   		</c:when>
				   		<c:otherwise>
				   			<colgroup>	
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
							</colgroup>
				   		</c:otherwise>
			   		</c:choose>				
					<tr>
						<th>
							<c:if test="${attrList.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name}
						</th>
						<td class="td Last alignL pdL5"
						<c:if test="${attrList.DataType eq 'Text'}">style="height:${attrList.AreaHeight}px;" </c:if>
						<c:if test="${attrList.ColumnNum2 ne '2' }"> colspan="3" </c:if>
						>
							<c:if test="${attrList.HTML eq '1'}">
							<div style="width:100%;height:${attrList.AreaHeight}px;">
								<textarea class="tinymceText" readonly="readonly">
									${attrList.PlainText}		
								</textarea>
							</div>
							</c:if>
							<c:if test="${attrList.HTML ne '1'}">	
								<c:if test="${attrList.Link == null}">
								<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText}</textarea></c:if>
								<c:if test="${attrList.Link != null || attrUrl != null}" >
									<a onClick="fnRunLink('${attrList.URL}','${attrUrl}', '${attrList.AttrTypeCode}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
									${attrList.PlainText}
									</a>
								</c:if>
							</c:if>
						</td>
						<!-- 두번째 컬럼   -->
						<c:if test="${attrList.ColumnNum2 eq '2' }">
						<th>
							<c:if test="${attrList.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name2}
						</th>
						<td class="tdLast alignL pdL5"
						<c:if test="${attrList.DataType2 eq 'Text'}">style="height:${attrList.AreaHeight}px;" </c:if>
						>
							<c:if test="${attrList.HTML2 eq '1'}">
								<div style="width:100%;height:${attrList.AreaHeight}px;">
									<textarea class="tinymceText"  readonly="readonly">${attrList.PlainText2}</textarea>
								</div>
							</c:if>
							<c:if test="${attrList.HTML2 ne '1'}">	
								<c:if test="${attrList.Link2 == null}">
								<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText2}</textarea></c:if>
								<c:if test="${attrList.Link2 != null || attrUrl != null}" >
									<a onClick="fnRunLink('${attrList.URL2}','${attrUrl}', '${attrList.AttrTypeCode2}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
									${attrList.PlainText2}
									</a>
								</c:if>
							</c:if>
						</td>
						</c:if>
					</tr>													
				</c:forEach>		
			</table>				
			</div>
			</c:if>
		</div>	
		
		<!-- 첨부 및 관련 문서 --> 
		<div id="file" class="mgB10 mgT10">
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
		
		</div>
	</div>		  
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</form>
