<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> 
<script type="text/javascript">
	var chkReadOnly = false;
</script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">
$(document).ready(function(){	
	$("input.datePicker").each(generateDatePicker);
	document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";			
	window.onresize = function() {
		document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";	
	};
	if("${autoID}" == "Y"){
		$("#identifier").attr('disabled',true);
	}else{
		$("#identifier").attr('disabled',false);
	}
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function changeItemTypeCode(avg, avg2){
	var url    = "getSelectOption.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들
				+"&s_itemID="+avg
				+"&itemID=${s_itemID}";
	var target = avg; // avg;             // selectBox id
	var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
	var isAll  = "";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	ajaxSelect(url, data, target, defaultValue, isAll);
}
function doReturnObjectAttrInfo(){
	//alert(1);	
}
function saveObjAttrInfo(){
	if(confirm("${CM00001}")){
		var mLovCode = "";
		var AttrTypeValue;
		var mLovCodeValue;
		var k;
		var dataType = "";
		<c:forEach var="i" items="${getList}" varStatus="iStatus">
		    AttrTypeValue = new Array;
		    mLovCodeValue = new Array;
		    k=0;
		    dataType = "${i.DataType}";
			<c:if test="${i.DataType == 'MLOV'}" >
				<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
					mLovCode = "${mLovList.AttrTypeCode}"+"${mLovList.CODE}";
					var checkObj = document.all(mLovCode);
					if (checkObj.checked) {
						AttrTypeValue[k] = $("#"+mLovCode).val();
						mLovCodeValue[k] = $("#"+mLovCode).val();
						k++;
					}				
				</c:forEach>
				$("#"+"${i.AttrTypeCode}").val(mLovCodeValue);
			</c:if>
			//}
		</c:forEach>
		ajaxSubmit(document.OAIPFrm, "saveItemAttr.do");
	}
}

function actionComplet(){
	opener.fnUrlReload();
	self.close();
}
	
function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
	if(subAttrCode != "" && subAttrCode != null){			
		var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
		fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
	}
}

function selfClose(){
	self.close();
}

</script>
</head><body>
<form name="OAIPFrm" id="OAIPFrm" enctype="multipart/form-data" action="saveItemAttr.do" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />	
	<input type="hidden" id="mLovAttrTypeCode" name="mLovAttrTypeCode" value="${mLovAttrTypeCode}" />
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:420px;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00031}</p>
	</div>
	
	<div id="editArea" style="width:100%;height:100%;overflow:auto;overflow-x:hidden;margin:5px 5px 5px 5px;">
		<table class="tbl_blue01" style="table-layout:fixed;width:99%;" >
			<colgroup>
				<col width="12%">
				<col>
			</colgroup>
		<!-- AttrList is null -->
		<c:if test="${fn:length(getList) eq 0 }">
			<tr>
				<td  class="viewtop alignC" colspan = 2> 
					 No attribute type allocated 
				</td>
			</tr>
		</c:if>
		<tr>
			<th class="viewline alignC">${menu.LN00028}</th>
			<td class="alignL last">
				<input type="text" id="AT00001" name="AT00001" value="${itemMap.ItemName}" class="text" style="padding-left: 5px;">
			</td>
		</tr>
		<tr>
			<th class="viewline alignC">${menu.LN00106}</th>
			<td class="alignL last">
				<input type="text" id="identifier" name="identifier" value="${identifier}" class="text" style="padding-left: 5px;">
			</td>
		</tr>
		<!-- AttrList is not null -->
		<!-- First Attr Value-->			
		<c:forEach var="i" items="${getList}" varStatus="iStatus">
			<tr>
			
				<th class="viewline alignC">${i.Name}</th>
				<td class="tit last">				

			<!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
			<!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT -->	
			<c:choose>
			<c:when test="${i.DataType eq 'Text'}">	
				<c:choose>
					<c:when test="${i.HTML eq '1'}">
						<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:${i.AreaHeight}px;">${i.PlainText}</textarea>
					</c:when>
					<c:when test="${i.HTML ne '1'}">
						<textarea class="edit" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:99%;height:${i.AreaHeight}px; padding-left: 5px;">${i.PlainText}</textarea>
					</c:when>
				</c:choose>
			</c:when>
			<c:when test="${i.DataType eq ''}">	
				<c:choose>
					<c:when test="${i.HTML eq '1'}">
						<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:${i.AreaHeight}px;">${i.PlainText}</textarea>
					</c:when>
					<c:when test="${i.HTML ne '1'}">
						<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
					</c:when>
				</c:choose>
			</c:when>
			<c:when test="${i.DataType eq 'LOV'}">					
				 <select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="sel" style="width:100%;"  OnChange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);">
				 </select>
			<script>
			changeItemTypeCode('${i.AttrTypeCode}','${i.LovCode}');
			</script>					 
			</c:when>
			
			<c:when test="${i.DataType eq 'MLOV'}">
				<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" />
				 <c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">				 
				 <input type="checkbox" id="${mLovList.AttrTypeCode}${mLovList.CODE}" name="${mLovList.AttrTypeCode}${mLovList.CODE}" value="${mLovList.CODE}"
				 <c:if test="${mLovList.LovCode == mLovList.CODE}" > checked </c:if>>&nbsp;${mLovList.NAME} &nbsp;&nbsp;
				 </c:forEach>			 
			</c:when>	
								
			<c:when test="${i.DataType eq 'URL'}">
				<a href="${i.PlainText}" target="_blank">${i.PlainText}</a>
				<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
			</c:when>
			<c:when test="${i.DataType eq 'Date'}">
			<!-- 2013-11-15 Datapicker확인중 -->
				<ul>
					<li>
						<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
						<font> <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"value="${i.PlainText}"	class="text datePicker" size="8"
								style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
						</font>
					</li>
				</ul>
			</c:when>
			</c:choose>					
							</td>				
						</tr>
			</c:forEach>
			<!-- 
			<script>
			$("textarea").autoGrow();
			</script>
			 -->
		</table>
		 <c:if test="${fn:length(getList) > 0 and sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
			<div class="alignBTN mgB5 mgR10">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjAttrInfo()" type="submit"></span>
				<span id="close" class="btn_pack medium icon"><span class="close"></span><input value="Close" type="submit" onclick="selfClose()" /></span>
			</div>
		</c:if>
	</div>			
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>