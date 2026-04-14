<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="WFStepID"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="WFStepID"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

$(document).ready(function() {
	// PreStepID의 default값 설정 
	var defaultPreStepId = "";
	if ("${editMode}" == "insert") {
		defaultPreStepId = "${preStepId}";
	} else {
		defaultPreStepId = "${infoMap.PreStepID}";
	}
	
	fnSelect('wfStepID', '&Category=WFSTEP', 'dictionyCode', '${infoMap.WFStepID}', 'Select');
	fnSelect('preStepID', '&Category=WFSTEP', 'dictionyCode', defaultPreStepId, 'Select');
});	


// [Save] click
function saveWfStepRel(){
	
	if ("${editMode}" == "insert") {
		// WFStepID 필수 체크[Insert]
		var selectedWfStepId = $("#wfStepID").val();
		if (selectedWfStepId == "") {
			alert("${WM00041}");
			return false;
		}
		// WFStepID 중복 체크[Insert]
		var arrayWfStepId = "${arrayWfStepId}".split(",");
		for (var i = 0; i < arrayWfStepId.length; i++) {
			var wfStepId = arrayWfStepId[i];
			if (wfStepId == selectedWfStepId) {
				alert("${WM00116}");
				return false;
			}
		}
	}
	
	if (confirm("${CM00001}")) {
		var url = "saveWorkFlowStepRel.do";
		$("#relWfStepID").val($("#wfStepID").val());
		$("#relPreStepID").val($("#preStepID").val());
		checkBox1(); // Deactivated값 설정
		ajaxSubmit(document.addWorkFlowStepRelFrm, url, "blankFrame");
	}
	
}

//[save] 이벤트 후 처리
function selfClose() {
	var opener = window.dialogArguments;
	opener.urlReload();
	self.close();
}

function checkBox1(){
	var chk1 = document.getElementsByName("check1");
	if(chk1[0].checked == true) {
		$("#relDeactivated").val("1");
	} else {
		$("#relDeactivated").val("0");
	}
}

</script>
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->
<body>
<div class="child_search_head">
	<c:if test="${editMode == 'insert'}">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp; <!-- ${wfName} > -->Add Work Flow Step Rel</p>
	</c:if>
	<c:if test="${editMode == 'update'}">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;<!-- ${wfName} > --> Edit Work Flow Step Rel</p>
	</c:if>
	
</div>

<form name="addWorkFlowStepRelFrm" id="addWorkFlowStepRelFrm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="relWFID" name="relWFID" value="${WFID}"> 
	<input type="hidden" id="editMode" name="editMode" value="${editMode}"> 
	<input type="hidden" id="relDeactivated" name="relDeactivated" value="${infoList.Deactivated}">
	<input type="hidden" id="relWfStepID" name="relWfStepID" value=""> 
	<input type="hidden" id="relPreStepID" name="relPreStepID" value=""> 
	 
	<div style="width:100%; height:100%;margin:5px;">

		<table style="table-layout:fixed;"  cellpadding="0" cellspacing="0" class="tbl_blue01">
		<colgroup>
			<col width="30%">
			<col width="50%">
		</colgroup>
		<tr>
			<th class="viewtop">ID</th>
			<td  class="last viewtop">${WFID}</td>
		</tr>
		 
		<tr>
			<th>WFStepID</th>
			<td  class="last">
				<c:if test="${editMode == 'insert'}">
					<select id="wfStepID" name="wfStepID" class="sel">
						<option value="">Select</option>
						<c:forEach var="i" items="${wfStepList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>	
					</select>
				</c:if>
				<c:if test="${editMode == 'update'}">
					<select id="wfStepID" name="wfStepID" disabled="disabled" class="sel"></select>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>PreStepID</th>
			<td  class="last">
				<select id="preStepID" name="preStepID" disabled="disabled" class="sel"></select>
			</td>
		</tr>
		<tr>
			<th>SortNum</th>
			<td  class="last">
				<c:if test="${editMode == 'insert'}">
					<input type="text" class="text" id="sortNum" name="sortNum" value="${maxSortNum}" readonly="readonly"/>
				</c:if>
				<c:if test="${editMode == 'update'}">
					<input type="text" class="text" id="sortNum" name="sortNum" value="${infoMap.SortNum}" readonly="readonly"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>Deactivated</th>
			<td  class="last">
				<input type="checkbox" name="check1" <c:if test="${infoMap.Deactivated == '1'}">checked="checked"</c:if> value="${infoMap.Deactivated}" onclick="checkBox1()">
			</td>	
		</tr>
	
	</table>
	
</div>
	
	<div class="alignBTN">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveWfStepRel();" type="submit"></span>
	</div>
	
</form>

	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
	</body>
