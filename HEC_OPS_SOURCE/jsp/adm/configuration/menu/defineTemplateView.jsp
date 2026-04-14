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
		var data = "&languageID=${languageID}&menuCat=TMPL";
		fnSelect('LanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect('menuID', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		fnSelect('defLanguage','','langType', '${resultMap.DefLanguageID}', 'Select');
		var projectType = '${resultMap.ProjectType}';
		$("#projectType").val(projectType.trim());
		fnSelect('project', data+'&projectType=${resultMap.ProjectType}', 'getProject', '${resultMap.ProjectID}', 'Select');
		$("#style").val("${resultMap.Style}").attr("selected", "selected");
	});

	function updateTemplate() {
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
				var url = "updateTemplate.do?viewType=${viewType}";
				ajaxSubmit(document.templateList, url,"saveFrame");
			}
		}
	}

	function goBack(){
		var url = "defineTemplateGrid.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#CurrPageNum").val();
		var target = "tempListDiv";
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
	function fnGetProject(avg){
		var data = "&projectType="+avg;
		fnSelect('project', data, 'getProject', '${resultMap.ProjectID}', 'Select');
	}
	
	
</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="templateList" id="templateList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
		<div class="cfg">
			<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Template</li>
			<li class="floatR pdR20 pdT10"><span><select id="LanguageID" name="LanguageID" onchange="TemplateReload()"></select></span>
			</li>
		</div><br>
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
			</colgroup>
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
					<td class="viewtop"><input type="text" class="text"  id="templCode" name="templCode" value="${templCode}"/></td>
				<th class="viewtop">${menu.LN00028}</th>
					<td class="viewtop"><input type="text" class="text"  id="templName" name="templName" value="${resultMap.TemplateName}"/></td>
				<th class="viewtop">Style</th>
					<td class="viewtop">
						<select id="style" name="style" style="width:100%;">
							<option value="">Select</option>
							<option value="slidemenu1">Blue</option>
							<option value="slidemenu2">Light Blue</option>
							<option value="slidemenu3">Green</option>
							<option value="slidemenu4">Red</option>
							<option value="slidemenu5">Gray</option>
						</select>	
					</td>	
			</tr>
			<tr>
				<th>Project Type ${resultMap.ProjectType}</th>
				<td>
					<select id="projectType" name="projectType" style="width:100%;" OnChange="fnGetProject(this.value);" >
						<option value="">Select</option>
						<option value="PG">PG</option>
						<option value="PJT" selected>PJT</option>
					</select>	
				</td>
					<th>${menu.LN00131}</th>
				<td>
					<select id="project" name="project" style="width:100%;" ></select>	
				</td>
				<th>Menu</th>
				<td>
					<select id="menuID" name="menuID" style="width:100%;" ></select>
				</td>
				
			</tr>	
			<c:if test="${viewType == 'E'}">
				<tr>
					<th>SortNum</th>
					<td class="last"><input type="text" class="text" id="sortNum" name="sortNum" value="${resultMap.SortNum}" /></td>
					<th>Def. Language</th>
					<td><select id="defLanguage" name="defLanguage" style="width:100%;" ></select></td>
					<th>Deactivated</th>
					<td><input type="checkbox" name="deactivated" id="deactivated" 
						<c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if>
						value="${resultMap.Deactivated}" onclick="checkBox1()">
					</td> 
				</tr>
			</c:if>
			<tr>
			<tr>
				<th>VarFilter </th>
				<td class="last" colspan="5"><input type="text" class="text" id="varFilter" name="varFilter" value="${resultMap.VarFilter}" /></td>
			</tr>
				<td colspan="6" style="height:180px;" class="last">
				<textarea id="description" name="description" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff">${resultMap.Description}</textarea></td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="6">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${viewType == 'E' }">
						<span class="btn_pack medium icon"><span class="allocation"></span><input value="Allocation" type="submit" onclick="fnAllocTempl()"></span>
						</c:if>
						<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
						<span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="updateTemplate()"></span>
					</c:if>
				</td>
			</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>