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
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect("rptAuthority","&Category=MLVL","dictionyCode","${resultMap.Authority}","Select");		
	});

	function UpdateReportType() {
		/* get checkbox value */
		var chkIsPublic = document.all("rptIsPublic");
		var chkDeactivated = document.all("rptDeactivated");
		if (chkIsPublic.checked) {
			$("#hidIsPublic").val(1);
		} else {
			$("#hidIsPublic").val(0);
		}
		if (chkDeactivated.checked) {
			$("#hidDeactivated").val(1);
		} else {
			$("#hidDeactivated").val(0);
		}

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
				var url = "UpdateReportType.do";
				ajaxSubmit(document.reportTypeViewList, url, "blankFrame");
			}
		}

	}

	function goBack() {
		var url = "ReportType.do";
		var data =   "&pageNum=" + $("#currPage").val();
		var target = "reportTypeDiv";
		ajaxPage(url, data, target);
	}
	
	
	function rptReload(){
		var url = "reportTypeView.do";
		var data = "ReportCode="+ $("#ItemTypeCode").val() 
			+ "&pageNum=" + $("#currPage").val() 
			+ "&getLanguageID=" + $("#getLanguageID").val();		 
		var target = "reportTypeDiv";
		ajaxPage(url, data, target);
	}
	
</script>

<form name="reportTypeViewList" id="reportTypeViewList" action="*" method="post" onsubmit="return false;">	
	<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
		<input type="hidden" id="reportCode" name="reportCode" value="${resultMap.ReportCode}"/> 
		
		<input type="hidden" id="hidDeactivated" name="hidDeactivated" /> 
		<input type="hidden" id="hidIsPublic" name="hidIsPublic" /> 
		
	</div>
			
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Report Type</li>
		<li class="floatR pdR20 pdT10">
		  <select id="getLanguageID" name="getLanguageID" onchange="rptReload();"></select>
		</li>
	</div>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="6%">
			<col width="10%">
			<col width="6%">
			<col width="10%">
			<col width="6%">
			<col width="10%">
			<col width="6%">
			<col width="10%">
		</colgroup>
		<tr>
			<th class="viewtop">ReportCode</th>
			<td class="viewtop">${resultMap.ReportCode}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop">
				<input type="text" class="text" id="rptName" name="rptName" value="${resultMap.Name}" maxlength="255" />
			</td>
			<th class="viewtop">Report Type</th>
			<td class="viewtop">
				<select id="reportType" Name="reportType" class="sel" style="width:100%;">
					<option value="" >Select</option>
	       			<option value='ITM' <c:if test="${resultMap.ReportType == 'ITM'}">selected="selected"</c:if>>ITM</option>
	       			<option value='PJT' <c:if test="${resultMap.ReportType == 'PJT'}">selected="selected"</c:if>>PJT</option>
	       		</select>
			</td>
			<th class="viewtop">Authority</th>
			<td class="viewtop last"><select id="rptAuthority" name="rptAuthority" class="sel" style="width:100%;"></select></td>
		</tr>
		<tr>
			<th>Is Public</th>
			<td>
				<input type="checkbox" id="rptIsPublic" <c:if test="${resultMap.IsPublic == '1'}">checked="checked"</c:if> value="${resultMap.IsPublic}">
			</td>
			<th>Deactivated</th>
		    <td>
				<input type="checkbox" id="rptDeactivated" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}">
			</td>
			<th>Function</th>
			<td><input type="text" class="text" id="rptUrl" name="rptUrl" value="${resultMap.ReportURL}"/></td>	
			<th>Action Type</th>
			<td class="alignL last">
				<select id="actionType" name="actionType" class="sel" style="width:100%;">
					<option value="" >Select</option>
					<option value="EXE" <c:if test="${resultMap.ActionType == 'EXE'}">selected="selected"</c:if> >EXE</option>
					<option value="LPOP" <c:if test="${resultMap.ActionType == 'LPOP'}">selected="selected"</c:if> >LPOP</option>
					<option value="POP" <c:if test="${resultMap.ActionType == 'POP'}">selected="selected"</c:if> >POP</option>
				</select>
			</td>
		</tr>		
		<tr>	
		    <th>Output Type</th>
			<td class="alignL">
				<select id="rptOutputType" name="rptOutputType" class="sel" style="width:100%;">
					<option value="" >Select</option>
					<option value="doc" <c:if test="${resultMap.OutputType == 'doc'}">selected="selected"</c:if> >doc</option>
					<option value="scrn" <c:if test="${resultMap.OutputType == 'scrn'}">selected="selected"</c:if> >screen</option>
					<option value="pdf" <c:if test="${resultMap.OutputType == 'pdf'}">selected="selected"</c:if> >pdf</option>
				</select>
			</td>
			<th>Icon</th>
			<td class="alignL">
				<select id="icon" name="icon" class="sel" style="width:100%;">
					<option value="" >Select</option>
					<option value="doc" <c:if test="${resultMap.Icon == 'doc'}">selected="selected"</c:if> >doc</option>
					<option value="scrn" <c:if test="${resultMap.Icon == 'scrn'}">selected="selected"</c:if> >screen</option>
					<option value="xls" <c:if test="${resultMap.Icon == 'xls'}">selected="selected"</c:if> >xls</option>
					<option value="pdf" <c:if test="${resultMap.Icon == 'pdf'}">selected="selected"</c:if> >pdf</option>
				</select>
			</td>
			<th>Popup Width</th>
			<td class="alignL">
				<input type="text" class="text" id="pWidth" name="pWidth" value="${resultMap.PWidth}"/>
			</td>
			<th>Popup Height</th>
			<td class="alignL last">
				<input type="text" class="text" id="pHeight" name="pHeight" value="${resultMap.PHeight}"/>
			</td>
		</tr>
		<tr>	
			<th>Message Code</th>
			<td class="last alignL">
				<input type="text" class="text" id="messageCode" name="messageCode" value="${resultMap.MessageCode}"/>
			</td>
		 	<th>${menu.LN00060}</th>
			<td>${resultMap.Creator}</td>
			<th>${menu.LN00013}</th>
			<td>${resultMap.CreationTime}</td>
			<th>${menu.LN00070}</th>
			<td class="last">${resultMap.LastUpdated}</td>
		</tr>
		<tr>
			<td colspan="8" style="height:180px;" class="tit last">
			<textarea id="rptDescription" name="rptDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
					 <span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="UpdateReportType()"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

