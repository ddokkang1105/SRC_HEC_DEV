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
<script type="text/javascript">
	//var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/> <!-- 명칭 체크  -->
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="documentNo"/> <!-- documentNo 체크  -->
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00125}"/> <!-- 모델 체크  -->
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00191}"/> <!-- 모델 체크  -->
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_4" arguments="${menu.LN00063}"/> <!-- 시작일 체크  -->
 <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_5" arguments="${menu.LN00233}"/> <!-- 종료일 체크  -->
 
<script type="text/javascript">
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
	});

	function fnCreateTS() {
		if(confirm("${CM00001}")){
			if($("#instName").val() == ""){alert("${WM00034_1}"); return;}
			if($("#documentNo").val() == ""){alert("${WM00034_2}"); return;}
			if($("#modelList").val() == ""){alert("${WM00025_2}"); return;}
			if($("#csrList").val() == ""){alert("${WM00025_3}"); return;}
			if($("#startDate").val() == ""){alert("${WM00025_4}"); return;}
			if($("#endDate").val() == ""){alert("${WM00025_5}"); return;}
			var url = "createTCInstance.do";
			ajaxSubmit(document.procInstFrm, url);
		}
	}
	
	function fnCallBackSubmit() {
		var url = "tsList.do";
		var data = "masterItemID=${p_itemID}";
		var target = "actFrame";
	
		ajaxPage(url, data, target);
	}
</script>
</head><body>
<form name="procInstFrm" id="procInstFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="p_itemID" name="p_itemID"  value="${p_itemID}" />
	<div class="cop_hdtitle">
		<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Create Test  Scenario</h3>
	</div>
	<table class="tbl_brd">
		<colgroup>
			<col width="15%">
			<col>
			<col width="15%">
			<col>
		</colgroup>
		<tr>
			<th class="alignL pdL10">${menu.LN00028}</th>
			<td class="sline tit last"><input type="text" class="text" id="instName" name="instName"></td>
			<th class="alignL pdL10">Document No</th>
			<td class="sline tit last">
				<input type="text" class="text" id="documentNo" name="documentNo">
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00125}</th>
			<td class="sline tit last">
				<select id="modelList" name="modelList" class="sel">
			    		<option value=''>Select</option>
	           	   		<c:forEach var="i" items="${modelList}">
	                   		<option value="${i.ModelID}">${i.Name}</option>
	           	    	</c:forEach>
				</select>
			</td>
			<th class="alignL pdL10">${menu.LN00191}</th>
			<td class="sline tit last">
					<select id="csrList" name="csrList" class="sel">
					<option value="">Select</option>
					<c:forEach var="i" items="${csrList}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>				
					</select>
				</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00063}</th>
			<td class="sline tit last">
				<input type="text" id="startDate" name="startDate" class="input_off datePicker stext" size="8"
				style="width:80px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			</td>
			<th class="alignL pdL10">${menu.LN00233}</th>
			<td class="sline tit last">
				<input type="text" id="endDate" name="endDate" class="input_off datePicker stext" size="8"
				style="width:80px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			</td>
		</tr>
	</table>
	<div class="alignBTN mgB5 mgR10">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCreateTS()" type="button"></span>
	</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>