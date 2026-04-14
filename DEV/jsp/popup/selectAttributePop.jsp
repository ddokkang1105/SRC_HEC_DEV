<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00043" var="CM00043"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
 
<script type="text/javascript">
$(document).ready(function(){		
	$("input.datePicker").each(generateDatePicker);
	document.getElementById('selAttr').style.height = (setWindowHeight() - 100)+"px";	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


// [save] 이벤트
function editAttrCheckedAllItems(){ 
	getCheckedAttr();
	if ($('#attrCode').val() == "") {
		alert("${WM00023}");
		return;
	} 
	openEditPop();
}

// 체크된 AttributeCode 취득
function getCheckedAttr() { 
	var attrCode = "";
	<c:forEach var="i" items="${getAttrList}" varStatus="iStatus">
		var checkBoxId = "${i.AttrTypeCode}";
		
		if ($("input:checkbox[id='${i.AttrTypeCode}']").is(":checked") == true) {
			if (attrCode == "") {
				attrCode = "'" + checkBoxId + "'";
			} else {
				attrCode = attrCode + "," + "'" + checkBoxId + "'";
			}
		}
	</c:forEach>
	$('#attrCode').val(attrCode);
}

// Attribute 편집창 열기
function openEditPop(){
    /*
    var itemArray = new Array();
	itemArray[0] = $('#items').val();
    var url = "editAttrOfItemsPop.do?";
	var data = "attrCode="+$('#attrCode').val()+"&classCodes="+$('#classCodes').val();
    var option = "width=850px,height=400px;";
    var modal = window.open(url + data, null, option);
    modal.dialogArguments = itemArray; 
    */
    var items = opener.$('#items').val();
    $('#items').val(items);
    var url = "editAttrOfItemsPop.do?attrCode="+$('#attrCode').val()+"&classCodes="+$('#classCodes').val()+"&items="+$('#items').val();
	var w = 600;
	var h = 500;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
    
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	//var opener = window.dialogArguments;
	opener.urlReload();
	self.close();
	event.returnValue = false;
}

</script>
<form name="OAIPFrm" id="OAIPFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="items" name="items"  value="" />
	<input type="hidden" id="classCodes" name="classCodes"  value="${classCodes}" />
	<input type="hidden" id="attrCode" name="attrCode"  value="" />
	
	<input type="hidden" id="getList" name="getList"  value="" />
	
	
<div id="objectInfoDiv" class="hidden" style="width:100%;margin:auto;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Select Attribute</p>
	</div>
	
	
    <ul id="breadcrumb">
        <li><span>Attribute List</span></li>
    </ul>
	
	<div id="selAttr" style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">
		<div class="attr">
	         <c:forEach var="i" items="${getAttrList}" varStatus="iStatus">
	         	<input type="checkbox" id="${i.AttrTypeCode}">&nbsp;${i.Name}&nbsp;&nbsp; <br>
	         		
	         </c:forEach>
		</div>
		<div class="alignBTN mgB5 mgR10">
			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="editAttrCheckedAllItems();"></span>
		</div>
	</div>	
</div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>