<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="ReportCode"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		fnSelect("rptAuthority","&Category=MLVL","getDicWord","","Select");	
	});

	function saveRptType() {
		/* ReportCode 필수 체크 */
		if ($("#rptItemTypeCode").val() == "") {
			alert("${WM00034}");
			return false;
		}
		
		/* get checkbox value */
		var chkIsPublic = document.all("rptIsPublic");
		if (chkIsPublic.checked) {
			$("#hidIsPublic").val(1);
		} else {
			$("#hidIsPublic").val(0);
		}
		
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){		
			var url = "admin/saveReportType.do";
			ajaxSubmit(document.rptTypePopList, url, "blankFrame");
		}
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.urlReload();
		self.close();
	}

	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="rptTypePopList" id="rptTypePopList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="hidIsPublic" name="hidIsPublic"/> 
		
		 <div class="mgT5 mgL5 mgR5">
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="20%">
				<col width="30%">
				<col width="20%">
				<col width="30%">
			</colgroup>
		
			<!-- ID -->			
			<tr>
				<th class="viewtop">Report Code</th>
				<td colspan="3"  class="viewtop last">
					<input type="text" class="text" id="rptItemTypeCode" name="rptItemTypeCode"   onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
				</td>
			</tr>
			<!-- 명칭 -->
			<tr>
				<th>${menu.LN00028}</th>
				<td colspan="3"  class="last">
					<input type="text" class="text" id="rptName" name="rptName" />
				</td>
			</tr>
			<!-- 개요 -->
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="3"  class="last">
					<input type="text" class="text" id="rptDescription" name="rptDescription">
				</td>
			</tr>
			<tr>
				<th>Report URL</th>
				<td colspan="3"  class="last"><input type="text" class="text" id="rptUrl" name="rptUrl" /></td>
			</tr>
			<tr>
				<th>Report Type</th>
				<td class="last alignL">
					<select id="rptType" name="rptType" class="sel" style="width:140px;">
						<option value="" >Select</option>
						<option value="CLS" >ITM</option>
						<option value="PJT" >PJT</option>
						<option value="TMPL" >TMPL</option>
					</select>
				</td>		
				<th>Output Type</th>
				<td  class="last alignL">
					<select id="rptOutputType" name="rptOutputType" class="sel" style="width:140px;">
						<option value="" >Select</option>
						<option value="doc" >doc</option>
						<option value="scrn" >scrn</option>
						<option value="xls" >xls</option>
						<option value="pdf" >pdf</option>
					</select>
				</td>	
			</tr>
			<tr>
				<th>Action Type</th>
				<td  class="last alignL">
					<select id="actionType" name="actionType" class="sel" style="width:140px;">
						<option value="" >Select</option>
						<option value="EXE" >EXE</option>
						<option value="LPOP" >LPOP</option>
						<option value="POP" >POP</option>
					</select>
				</td>
				<th>Message</th>
				<td class="last">
					<input type="text" class="text" id="messageCode" name="messageCode" />
				</td>
			</tr>
			<tr>
				<th>Popup Width</th>
				<td>
					<input type="text" class="text" id="pWidth" name="pWidth" />
				</td>
				<th>Popup Height</th>
				<td class="last">
					<input type="text" class="text" id="pHeight" name="pHeight" />
				</td>
			</tr>
			<tr>
				<th>Authority</th>
				<td>
					<select id="rptAuthority" name="rptAuthority" class="sel" style="width:140px;"></select>
				</td>
				<th>IsPublic</th>
				<td  class="last">
					<input type="checkbox" id="rptIsPublic">
				</td>
			</tr>
		</table>

		<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveRptType()"></span>
			</c:if>
		</div>
	</div>
	</form>
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>