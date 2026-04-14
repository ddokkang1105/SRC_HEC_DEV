<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00020" var="CM00020" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		var data = "&category=DOCCAT&languageID=${languageID}";
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect('category',data,'getDictionary','${resultMap.DocCategory}','Select');
	});

	function updateFileType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}

			if(checkConfirm) {
				var url = "admin/updateFileType.do";
				ajaxSubmit(document.fileTypeViewList, url, "blankFrame");
			}
		}

	}

	function goBack() {
		var url = "fileType.do";
		var data =   "pageNum=" + $("#currPage").val();
		var target = "fileTypeDiv";
		ajaxPage(url, data, target);
	}
	
	
	function fltpReload(){
		var url = "fileTypeView.do";
		var data = "FltpCode="+ $("#FltpCode").val() 
			+ "&pageNum=" + $("#currPage").val() 
			+ "&getLanguageID=" + $("#getLanguageID").val();			 
		var target = "fileTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function fnCheckIsPublic(){ 
		var chk = document.getElementsByName("isPublic");
		if(chk[0].checked == true){
			$("#isPublic").val("1");
		}else{
			$("#isPublic").val("0");
		}
	}
	
	function fnCheckRevisionYN(){ 
		var chk = document.getElementsByName("revisionMgt");
		if(chk[0].checked == true){
			$("#revisionMgt").val("Y");
		}else{
			$("#revisionMgt").val("N");
		}
	}
	
	function fnSave(){ 
		var file = document.getElementById("FD_FILE_PATH").files[0];
		if(confirm("${CM00020}")){ // if(!fnCheckValidation()){return;} 
		
		var url = "admin/saveFltpFile.do?fltpCode=${resultMap.FltpCode}"; 
		ajaxSubmitNoAdd(document.uploadForm, url, "blankFrame");
		} 
	}	
	
	function fnFileDownload() {
	    var seq = "${resultMap.TemplateFileID}";

	    if (!seq) {
	        alert("파일이 존재하지 않습니다.");
	        return;
	    }

	    var url = "fileDownload.do?seq=" + seq;
	    ajaxSubmitNoAdd(document.uploadForm, url, "blankFrame");
	}
	
	function fnDeleteFltpFile(){
		var seq = "${resultMap.TemplateFileID}";
	    var url = "deleteFltpFile.do?seq=" + seq +"&fltpCode=${resultMap.FltpCode}";
	    ajaxSubmitNoAdd(document.uploadForm, url, "blankFrame");
	}
	
</script>

<form name="fileTypeViewList" id="fileTypeViewList" action="*" method="post" onsubmit="return false;">	
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
		<input type="hidden" id="FltpCode" name="FltpCode" value="${resultMap.FltpCode}"/> 
		
	</div>
			
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit File Type</li>
		<li class="floatR pdR20 pdT10">
		  <select id="getLanguageID" name="getLanguageID" onchange="fltpReload();"></select>
		</li>
	</div>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="14%">
			<col width="37%">
			<col width="14%">
			<col width="37%">
			<col width="14%">
			<col width="37%">
		</colgroup>
		<tr>
			<th class="viewtop">FileTypeCode</th>
			<td class="viewtop">${resultMap.FltpCode}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop">
			<input type="text" class="text" id="fltpName" name="fltpName" value="${resultMap.Name}" maxlength="255" /></td>
			<th class="viewtop">${menu.LN00033}</th>
			<td class="viewtop last">
				<select id="category" name="category" style="width:100%;" >
				</select>
			</td>
		</tr>
		<tr>
			<th>File Path</th>
			<td><input type="text" class="text" id="fltpPath" name="fltpPath" value="${resultMap.FilePath}"/></td>
			<th>IsPublic</th>
			<td><input type="checkbox" id="isPublic" name="isPublic" 
				<c:if test="${resultMap.IsPublic == '1'}"> checked="checked" </c:if>				
			value="${resultMap.IsPublic}" onclick="fnCheckIsPublic()" /> </td>
			<th>Revision Mgt.</th>
			<td class="last"><input type="checkbox" id="revisionMgt" name="revisionMgt" 
				<c:if test="${resultMap.RevisionYN == 'Y'}"> checked="checked" </c:if>				
			value="${resultMap.RevisionYN}" onclick="fnCheckRevisionYN()" /> </td>
		</tr>
		<tr>
		  <th>${menu.LN00019}</th>
		  <td colspan="5" class="last" style="padding:0;">
		    <div class="tbl-file-row" 
		         style="display:flex; justify-content:space-between; align-items:center; width:100%; padding:6px 10px; box-sizing:border-box; min-height:36px;"> 
		      
		      <c:if test="${not empty resultMap.FileRealName}">
		        <span style="display:flex; align-items:center; overflow:hidden;">
		          <a href="javascript:void(0);" 
		             onclick="fnFileDownload()" 
		             class="file-name"
		             style="display:block; text-align:left; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; text-decoration:none; color:#000;">
		            ${resultMap.FileRealName}
		          </a>
		          <img src="${root}${HTML_IMG_DIR}/btn_filedel.png" 
		               style="cursor:pointer;width:13;height:13;padding-left:10px" 
		               onclick="fnDeleteFltpFile()"/>
		        </span>
		        <span class="file-download-wrap btn_pack medium icon">
		          <span class="download"></span>
		          <input value="Download" type="button" onclick="fnFileDownload()">
		        </span>
		      </c:if>
		      
		    </div>
		  </td>
		</tr>
		<tr>
			<td colspan="6" style="height:180px;" class="tit last">
			<textarea id="fltpDescription" name="fltpDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
				<button class="cmm-btn mgR5" style="height:30px;" onclick="document.getElementById('FD_FILE_PATH').click();">Upload</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="goBack()" value="List" >List</button>
				<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="updateFileType()" value="Save">Save</button>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>

<form id="uploadForm" name="uploadForm" action="" method="post" enctype="multipart/form-data" style="display:inline;">
   	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
    <input type="file" id="FD_FILE_PATH" name="uploadFile" style="display:none;"
           onchange="fnSave()">
		<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
		<input type="hidden" id="fltpCode" name="fltpCode" value="${resultMap.FltpCode}">
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

