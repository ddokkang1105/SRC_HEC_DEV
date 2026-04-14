<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
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
				var url = "updateFileType.do";
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
	
</script>

<form name="fileTypeViewList" id="fileTypeViewList" action="*" method="post" onsubmit="return false;">	
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
			<td colspan="6" style="height:180px;" class="tit last">
			<textarea id="fltpDescription" name="fltpDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
					 <span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="updateFileType()"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

