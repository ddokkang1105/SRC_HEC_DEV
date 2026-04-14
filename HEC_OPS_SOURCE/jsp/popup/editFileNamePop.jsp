<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">
$(document).ready(function(){
	document.getElementById('editArea').style.height = (setWindowHeight() - 80)+"px";	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//[save] 이벤트
function saveEditIdName() {
	if(confirm("${CM00001}")){
		var url = "editFileName.do";	
		ajaxSubmit(document.editIDNameFrm, url, "saveFrame");
	}
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	opener.doSearchList();
	self.close();
}

</script>
<form name="editIDNameFrm" id="editIDNameFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="documentID" name="documentID" value="${s_itemID}" />
<div id="objectInfoDiv" class="hidden" style="width:100%;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit File Name</p>
	</div>
	
	<div id="editArea" style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">
	<table class="tbl_blue01 mgT2" width="85%"  border="0" cellspacing="0" cellpadding="0">
        	<colgroup>
			<col width="8%">
			<col width="24%">
			<col width="50%">
			<col>
		</colgroup>
		<tr>
			<th class="viewtop last">No.</th>
			<th class="viewtop last">${menu.LN00091}</th>
			<th class="viewtop last">${menu.LN00101}</th>
		</tr>
	<c:forEach var="i" items="${getList}" varStatus="iStatus">	
		<tr>
			<td class="last">${i.RNUM} </td>
			<td class="last">
				<input type="text" id="ID_${i.Seq}" name="ID_${i.Seq}" value="${i.FltpName}" class="text" disabled  >
			</td>
			<td class="last">
				<input type="text" id="Name_${i.Seq}" name="Name_${i.Seq}" value="${i.FileRealName}" class="text">
			</td>
		</tr>
	</c:forEach>		
	</table>
	</div>
	
	<div id="btnSave" class="alignBTN" >
		&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveEditIdName()" type="submit"></span>
	</div>
	
</div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>