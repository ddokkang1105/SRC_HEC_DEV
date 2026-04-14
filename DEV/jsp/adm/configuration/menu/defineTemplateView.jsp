<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득    -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="Menu"/>


<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
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
			} else if($("#menuID").val() == null || $("#menuID").val() == ""){
				alert("${WM00025}");
				checkConfirm = false;
				return false;
			} else {
				checkConfirm = true;
			}
			
			if(checkConfirm) {
				var url = "admin/updateTemplate.do?viewType=${viewType}";
				ajaxSubmit(document.templateList, url,"saveFrame");
			}
		}
	}

	function thisReload(viewType){
		if(viewType == "N") {
			var url = "defineTemplateGrid.do";
			var data = "&cfgCode=${cfgCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#CurrPageNum").val();
			var target = "tempListDiv";
		} else {
			var url = "defineTemplateView.do";
			var data = "templCode=${templCode}&viewType=${viewType}";
			var target = "arcFrame";
		}
		ajaxPage(url, data, target);
	}
	
	function checkBox1(){			
		var chk1 = document.getElementsByName("deactivated");
		if(chk1[0].checked == true){ $("#deactivated").val("1");
		}else{	$("#deactivated").val("0"); }
	}
	
	function fnGetProject(avg){
		var data = "&projectType="+avg;
		fnSelect('project', data, 'getProject', '${resultMap.ProjectID}', 'Select');
	}
	
	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
	
	function goBackList() {
		var url = "defineTemplateGrid.do";
		var data = "cfgCode=${cfgCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#CurrPageNum").val();
		var target = "tempListDiv";
		ajaxPage(url, data, target);
	}
</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="templateList" id="templateList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
		<c:if test="${viewType == 'N'}">
		<div class="title-section flex align-center justify-between">
			<span class="flex align-center">
				<span class="back" onclick="goBackList()"><span class="icon arrow"></span></span>
				<span id="title">Add Template</span>
			</span>
		</div>
		</c:if>

		<div class="contents_body_inner mgL30">
			<ul class="detail_settings_list mgT10">
				<li class="item">
					<h4 class="title">${menu.LN00147}</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="LanguageID" name="LanguageID" class="lw_btn_select" onchange="TemplateReload()"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">${menu.LN00015}</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input"  id="templCode" name="templCode" value="${templCode}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
						</div>
					</div>
					<h4 class="title">${menu.LN00028}</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input"  id="templName" name="templName" value="${resultMap.TemplateName}"/>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Style</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="style" name="style" class="lw_btn_select">
								<option value="">Select</option>
								<option value="slidemenu1">Blue</option>
								<option value="slidemenu2">Light Blue</option>
								<option value="slidemenu3">Green</option>
								<option value="slidemenu4">Red</option>
								<option value="slidemenu5">Gray</option>
							</select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Project Type</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="projectType" name="projectType" class="lw_btn_select" OnChange="fnGetProject(this.value);" >
								<option value="">Select</option>
								<option value="PG">PG</option>
								<option value="PJT" selected>PJT</option>
							</select>
						</div>
					</div>
					<h4 class="title">${menu.LN00131}</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="project" name="project" class="lw_btn_select"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Menu</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="menuID" name="menuID" class="lw_btn_select"></select>
						</div>
					</div>
					<c:if test="${viewType == 'E'}">
						<h4 class="title">SortNum</h4>
						<div class="option_area">
							<div class="input_cover">
								<input type="text" class="lw_input" id="sortNum" name="sortNum" value="${resultMap.SortNum}" />
							</div>
						</div>
						<li class="item">
							<h4 class="title">Def. Language</h4>
							<div class="option_area">
								<div class="input_cover">
									<select id="defLanguage" name="defLanguage" class="lw_btn_select"></select>
								</div>
							</div>
							<h4 class="title">Deactivated</h4>
							<div class="option_area">
								<div class="input_cover">
									<input type="checkbox" name="deactivated" id="deactivated" class="lw_toggle" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}" onclick="checkBox1()">
									<label for="deactivated"></label>
								</div>
							</div>
						</li>
					</c:if>
				</li>
				<li class="item">
					<h4 class="title">Var Filter</h4>
					<div class="option_area">
						<div class="input_cover single">
							<input type="text" class="lw_input" id="varFilter" name="varFilter" value="${resultMap.VarFilter}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Description</h4>
					<div class="option_area">
						<div class="input_cover single">
							<input type="text" class="lw_input" id="description" name="description" value="${resultMap.Description}" />
						</div>
					</div>
				</li>
			</ul>
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<button class="cmm-btn2 mgR5 mgT10 floatR" style="height: 30px;"  onclick="updateTemplate()" value="Save">Save</button>
			</c:if>
		</div>

	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>