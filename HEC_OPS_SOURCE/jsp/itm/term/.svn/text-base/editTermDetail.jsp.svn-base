<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var chkReadOnly = false;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00033}"/> <!-- Category 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/> <!-- Name 입력 체크  -->
<script type="text/javascript">
	jQuery(document).ready(function() {
		var data = "languageID=${languageID}";
		fnSelect('Category', data+"&attrTypeCode=AT00034", 'getAttrTypeLov', '${termDetailInfo.Category}', 'Select');
		fnSelect('Abbreviation', data+"&attrTypeCode=AT00073", 'getAttrTypeLov', '${termDetailInfo.Abbreviation}', 'Select');
	});
	
	function fnChangeLanguage(language){		
		var url = "editTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID=${itemID}&csr=${csr}&languageID="+language;
	 	ajaxPage(url, data, target);
	}
	
	function fnSaveTermDetail(){
		if(confirm("${CM00001}")){
			var itemID = "${itemID}";
			var url = "saveTermDetail.do";	
			if(itemID == ""){
				url = "registerTerm.do";
			}
			
			var category = $("#Category").val();
			var name = $("#Name").val();
			if(category == "" || category == null){
				alert("${WM00034_1}"); return;
			}else if(name == "" || name == null){
				alert("${WM00034_2}"); return;
			} 
			
			ajaxSubmit(document.editTermFrm, url);
		}
	}
	
	function fnCallBack(){
		var url = "viewTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID=${itemID}&csr=${csr}";
	 	ajaxPage(url, data, target);
	}
	
	function fnCallBackAdd(itemID){
		var url = "viewTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID="+itemID+"&csr=${csr}"; 
	 	ajaxPage(url, data, target);
	}
	
</script>
</head>

<body>
<div id="editTermDetailDiv">
<form name="editTermFrm" id="editTermFrm" action="#" method="post" onsubmit="return false;">
<div id="editTermDetailStyle" style="width:98%;height:700px;overflow:auto; overflow-x:hidden; padding: 6px; 6px; 6px; 6px;" >	
<input type="hidden" id="itemID" name="itemID" value="${itemID}" >
<input type="hidden" id="csr" name="csr" value="${csr}" >
<input type="hidden" id="mgt" name="mgt" value="${mgt}" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3>
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">
			<c:if test="${itemID != '' }">&nbsp;&nbsp;Edit ${menu.LN00300}</c:if><c:if test="${itemID == '' }">&nbsp;&nbsp;Add ${menu.LN00300}</c:if>
		</h3>
	</div>
	<div id="tblChangeSet" style="width:99%">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%"/>
				<col width="38%"/>
				<col width="12%"/>
				<col width="38%"/>		
			</colgroup>
			<tr>				
				<!-- Category -->
				<th class="viewtop pdL10">${menu.LN00033}</th>
				<td class="viewtop alignL"><select id="Category" name="Category" style="width:90%"><option value=''>Select</option></select>	
				<!-- 약어 -->
				<th class="viewtop pdL10">${menu.LN00080}</th>
				<td class="viewtop alignL last"><input type="text" class="text" id="Abbreviation" name="Abbreviation"  value="${termDetailInfo.Abbreviation}"/></td>	
			</tr>				
			<tr>				
				<th class="pdL10">${menu.LN00028}</th>
				<td class="alignL pdL5 last" colspan="3"><input type="text" class="text" id="Name" name="Name"  value="${termDetailInfo.Name}"/></td>				
			</tr>	
			<tr>				
				<th class="pdL10">English Name</th>
				<td class="alignL pdL5 last" colspan="3"><input type="text" class="text" id="EnglishNM" name="EnglishNM"  value="${termDetailInfo.EnglishNM}"/></td>				
			</tr>	
		</table>
		
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%"/>
				<col width="88%"/>
			</colgroup>
			<tr>				
				<th class="pdL10">${menu.LN00035}</th>
				<td class="alignL pdL5 last" id="TD_AT00003_1042" name="TD_AT00003_1042">
					<textarea class="tinymceText" style="width:100%;height:150px;" id="Overview" name="Overview">${termDetailInfo.Overview}</textarea>
				</td>			
			</tr>
			<tr>				
				<th class="pdL10">${menu.LN00145}</th>
				<td class="alignL pdL5 last" id="TD_AT00056_1042" name="TD_AT00056_1042" >
					<textarea class="tinymceText" style="width:100%;height:150px;" id="Content" name="Content">${termDetailInfo.Content}</textarea>
				</td>				
			</tr>		
		</table>
		<c:if test="${itemID != ''}" >
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%"/>
				<col width="88%"/>
			</colgroup>
			<tr>				
				<th class="pdL10">${menu.LN00136}</th>
				<td class="alignL pdL5 last">
					<textarea class="edit" style="width:100%;height:50px;" id="changeSetDescription" name="changeSetDescription"></textarea>
				</td>
			</tr>
		</table>
		</c:if>
		<div class="alignBTN">
	    	<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveTermDetail()" type="submit"></span>
	    </div>
	</div>
</div>
</form>
</div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>
