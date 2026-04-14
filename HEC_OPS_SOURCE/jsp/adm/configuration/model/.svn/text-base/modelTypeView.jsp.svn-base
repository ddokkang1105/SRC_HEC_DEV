<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {		
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Selet');
		fnSelect('itemTypeCode','','itemTypeCode','${resultMap.ItemTypeCode}','Select');
		
		//ZoomOption select
		$("#zoomOption").val("${resultMap.ZoomOption}").prop("selected",true);
	});

	function updateModelType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;			
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}
			if (checkConfirm) {			
				var url = "updateModelType.do";				
				ajaxSubmit(document.ModelTypeViewList, url);
			}
		}

	}

	function goBack() {
		var url = "modelType.do";
		var data = "&pageNum=" + $("#CurrPageNum").val();
		var target = "modelTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){		
		var chk1 = document.getElementsByName("check1");		
		if(chk1[0].checked == true){			
			$("#objIsModel").val("1");
		}else{		
			$("#objIsModel").val("0");
		}
	}

	function ModelTypeReload(){		
		var url    = "modelTypeView.do"; // 요청이 날라가는 주소
		var data   = "ModelTypeCode=${resultMap.ModelTypeCode}" +
					"&languageID="+$("#getLanguageID").val() +
					 "&pageNum=" + $("#currPage").val() +
					 "&Name=" + $("#Name").val();
		var target = "ModelTypeList";		
		ajaxPage(url,data,target);
	}
	
	function WorkFlowAllocation(){				
		var url = "subTab.do"; // 요청이 날라가는 주소
		var data = "url=modelTypeMenu&filter=${resultMap.ModelTypeCode}" + "&pageNum=" + $("#CurrPageNum").val() + "&languageID=" 
						+ $("#getLanguageID").val() + "&Name=${Name}";
		var target = "ModelTypeViewList";
		ajaxPage(url, data, target);
	}
</script>

<div id="groupListDiv">
	<form name="ModelTypeViewList" id="ModelTypeViewList" action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="Name" name="Name" value="${Name}">  
		<input type="hidden" id="ModelTypeCode" name="ModelTypeCode" value="${resultMap.ModelTypeCode}"> 
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
		<input type="hidden" id="objIsModel" name="objIsModel" value="${resultMap.IsModel}">
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;Edit Model Type</li>
		<li class="floatR pdR20 pdT10">
		 <select id="getLanguageID" name="getLanguageID"  onchange="ModelTypeReload()"></select>
		</li>
	</div><br>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>			
			<col width="10%">
			<col width="17%">
			<col width="10%">
			<col width="17%">
			<col width="10%">
			<col width="17%">	
			<col width="10%">
			<col width="19%">				
		</colgroup>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>
			<td class="viewtop">${resultMap.ModelTypeCode}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop"><input type="text" class="text" id="objName" name="objName" value="${resultMap.Name}" /></td>
			<th class="viewtop">${menu.LN00021}</th>
			<td class="viewtop"><select id="itemTypeCode" name="itemTypeCode" style="width:100%;" ></select></td>
			<th class="viewtop">ArisTypeNum</th>
			<td class="viewtop last">
				<input type="text" class="text" id="ArisTypeNum" name="ArisTypeNum" value="${resultMap.ArisTypeNum}" />
			</td>			
		</tr>
		<tr>	
			<th>IsModel</th>
			<td><input type="checkbox" name="check1" 
				<c:if test="${resultMap.IsModel == '1'}">checked="checked"</c:if>
			value="${resultMap.IsModel}" onclick="CheckBox1()">
			</td>		
			<th>${menu.LN00105}</th>
			<td>${resultMap.LastUserName}</td>
			<th>${menu.LN00070}</th>
			<td>${resultMap.LastUpdated}</td>
			<th>ZoomOption</th>
			<td>
				<select id="zoomOption" name="zoomOption" style="width:100%;" >
					<option value=''>Select</option>
					<option value="FTW">Fit To Window</option>
					<option value="FTP">Fit To Page</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="8" style="height:180px;" class="tit last">
			<textarea id="objDescription" name="objDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"> 
						<span class="allocation"></span> 
							<input value="Allocation" type="submit" id="Allocation" 
							onclick="WorkFlowAllocation()"></span> 
					<span class="btn_pack medium icon"> 
						<span class="list"></span> 
							<input value="List" type="submit" onclick="goBack()"></span>
					 <span class="btn_pack medium icon"> <span class="save"></span> 
					 	<input value="Save" type="submit" onclick="updateModelType()"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>	
</div>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
