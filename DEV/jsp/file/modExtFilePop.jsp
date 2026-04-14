<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">
$(document).ready(function(){
	document.getElementById('editArea').style.height = (setWindowHeight() - 80)+"px";	
	if("${isNew}"=="Y"){
		var data = "&itemClassCode=${itemClassCode}";
		var fltpName = "";//$('#fltpName').val();
		fnSelectNone('fltpCode', data, 'fltpCode', fltpName); 
	};
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//[save] 이벤트
function saveEditExtFile() {
	if(confirm("${CM00001}")){
		var url = "saveEditExtFile.do";	
		ajaxSubmit(document.editExtFileFrm, url, "saveFrame");
	}
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	opener.fnReload();
	self.close();
}

</script>
<form name="editExtFileFrm" id="editExtFileFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="itemClassCode" name="itemClassCode" value="${itemClassCode }" />
<input type="hidden" id="isNew" name="isNew" value="${isNew}" />
<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}" />
<div id="objectInfoDiv" class="hidden" style="width:100%;height:300px;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;
		<c:if test="${isNew == 'Y' }">${menu.LN00301}</c:if>
		<c:if test="${isNew != 'Y' }">${menu.LN00302}</c:if>
		</p>
	</div>
	
	<div id="editArea" style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">
	<table class="tbl_blue01 mgT2" width="85%"  border="0" cellspacing="0" cellpadding="0">
        	<colgroup>
			<col width="8%">
			<col width="25%">
			<col width="45%">
			<col>
		</colgroup>
		<c:if test="${isNew == 'Y' }">
		<tr>
			<td colspan="3">
				<div style="margin-top:3px;margin-right:10px;text-align:left;">
					<span style="margin-right:18px;">${menu.LN00091}</span>
					<span>
					<select id="fltpCode" name="fltpCode" style="width:200px;" ></select>
					</span>
				</div>
			</td>
		</tr>
		</c:if>
		<tr>
			<th class="viewtop last">No</th>
			<th class="viewtop last">${menu.LN00101}</th>
			<th class="viewtop last">URL</th>
		</tr>
		<c:if test="${isNew == 'Y' }">
			<tr>
				<td class="last">New
				</td>
				<td class="last">
					<input type="text" id="Name_0" name="Name_0" value="" class="text">
				</td>
				<td class="last">
					<input type="text" id="Path_0" name="Path_0" value="" class="text">
				</td>
				<input type="hidden" id="maxCount" name="maxCount" value="1">
			</tr>	
		</c:if>
		<c:if test="${isNew != 'Y' }">
			<c:forEach var="i" items="${fileList}" varStatus="iStatus">	
			<tr>
				<td class="last">${iStatus.index+1} 
				</td>
				<td class="last">
					<input type="hidden" id="ID_${iStatus.index}" name="ID_${iStatus.index}" value="${i.Seq}">
					<input type="hidden" id="Code_${iStatus.index}" name="Code_${iStatus.index}" value="${i.FltpCode}">
					<input type="text" id="Name_${iStatus.index}" name="Name_${iStatus.index}" value="${i.FileRealName}" class="text">
				</td>
				<td class="last">
					<input type="text" id="Path_${iStatus.index}" name="Path_${iStatus.index}" value="${i.FilePath}" class="text">
				</td>
				<c:if test="${iStatus.last }">
					<input type="hidden" id="maxCount" name="maxCount" value="${fn:length(fileList)}">
				</c:if>
			</tr>
			</c:forEach>	
		</c:if>
			
	</table>
	</div>
	
	<div id="btnSave" class="alignBTN" >
		&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveEditExtFile()" type="submit"></span>
	</div>
	
</div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>