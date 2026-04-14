<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득    -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />


<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		var data = "&languageID=${languageID}&menuCat=TMPL"+"&itemClassCode=${resultMap.ItemClassCode}";
		fnSelect('LanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('itemClass', data, 'getItemClassCode', '${resultMap.ItemClassCode}', 'Select');
		fnSelect('fltp', data, 'getFltpCode', '${resultMap.FltpCode}', 'Select');
	});

	function saveTaskType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#LanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}
			
			if(checkConfirm) {
				var url = "saveTaskType.do?viewType=${viewType}";
				ajaxSubmit(document.taskTypeDetail, url,"saveFrame");
			}
		}
	}

	function fnCallBack(){
		var url = "taskTypeMgtList.do";
		var data = "&languageID=${languageID}&pageNum=${pageNum}";
		var target = "taskTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function checkBox1(){			
		var chk1 = document.getElementsByName("deactivated");
		if(chk1[0].checked == true){ $("#deactivated").val("1");
		}else{	$("#deactivated").val("0"); }
	}
	
	function fnAllocTempl(){
		var url = "subTab.do";
		var data ="url=defineTemplateMenu&templCode=${templCode}&languageID=${languageID}" 
						+"&pageNum=${pageNum}&viewType=${viewType}&projectID=${resultMap.ProjectID}"; 
		var target = "templateList";
		ajaxPage(url, data, target);
	}
	
</script>

<div id="taskTypeDetailDiv">
	<form name="taskTypeDetail" id="taskTypeDetail" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">	
		<div class="cfg">
			<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit TaskType</li>
			<li class="floatR pdR20 pdT10"><span><select id="LanguageID" name="LanguageID" onchange="taskTypeReload()"></select></span>
			</li>
		</div><br>
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="20%">
				<col width="10%">
				<col width="20%">
				<col width="10%">
				<col width="20%">
			</colgroup>
			<tr>
				<th class="viewtop">TaskTypeCode</th>
				<td class="viewtop">
					<input type="Text" id="taskTypeCode" name="taskTypeCode" value="${taskTypeCode}" style="border:0px" >	
				</td>
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop"><input type="text" class="text" id="taskTypeName" name="taskTypeName" value="${resultMap.TaskTypeName}"/></td>
				<th class="viewtop">${menu.LN00016}</th>
				<td class="viewtop">
					<select id="itemClass" name="itemClass" style="width:100%;" ></select>
				</td>
			</tr>
			<tr>
				<th>FileType</th>
				<td>
					<select id="fltp" name="fltp" style="width:100%;" ></select>
				</td>	
				<th>Deactivated</th>
				<td colspan="3" align="left"><input type="checkbox" name="deactivated" id="deactivated" 
					<c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if>
					value="${resultMap.Deactivated}" onclick="checkBox1()">
				</td>
			</tr>
			<tr>
				<td colspan="6" style="height:180px;" class="last">
				<textarea id="description" name="description" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff">${resultMap.Description}</textarea></td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="6">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${viewType == 'E' }">
						<!-- <span class="btn_pack medium icon"><span class="list"></span><input value="Allocation" type="submit" onclick="fnAllocTempl()"></span>  -->
						</c:if>
						<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="fnCallBack()"></span>
						<span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="saveTaskType()"></span>
					</c:if>
				</td>
			</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>