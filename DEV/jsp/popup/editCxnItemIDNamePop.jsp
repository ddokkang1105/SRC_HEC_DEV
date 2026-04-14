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
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//[save] 이벤트
function saveEditIdName() {
	if(confirm("${CM00001}")){
		var url = "updateEditIdName.do";	
		ajaxSubmit(document.editIDNameFrm, url, "saveFrame");
	}
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	opener.urlReload();
	self.close();
}

</script>
<form name="editIDNameFrm" id="editIDNameFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
<div id="objectInfoDiv" class="hidden" style="width:100%;height:300px;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit ID / Name</p>
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
			<th class="viewtop last">${menu.LN00106}</th>
			<th class="viewtop last">${menu.LN00028}</th>
			<th class="viewtop last">${menu.LN00016}</th>
		</tr>
	<c:forEach var="i" items="${getList}" varStatus="iStatus">	
		<tr>
			<td class="last">${i.RNUM} </td>
			<td class="last">
				<input type="text" id="ID_${i.ItemID}" name="ID_${i.ItemID}" value="${i.HrcyNo}" class="text">
			</td>
			<td class="last">
				<input type="text" id="Name_${i.ItemID}" name="Name_${i.ItemID}" value="${i.ItemName}" class="text">
			</td>
			<td class="last">${i.ClassName}</td>
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