<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<script>

	$(document).ready(function(){	
		var data = "&ItemTypeCode=${ItemTypeCode}";
		fnSelect('MTCTypeCode', '', 'MTCTypeCode', '', 'Select');
		fnSelect('ModelTypeCode', data, 'getMDLTypeCode', '', 'Select'); 
		
		if("${modelID}" != ""){
			setTimeout(function() {fnSetModelInfo();}, 800);
		}
	});
	
	function fnSetModelInfo(){
		$("#refModelID").val("${modelID}");
		$("#refModelName").val("${modelInfo.Name}");
		$("#MTCTypeCode").val("${modelInfo.MTCategory}");
		$("#ModelTypeCode").val("${modelInfo.ModelTypeCode}");
		
		$("#refModelName").attr('readOnly','true');
		$("#MTCTypeCode").attr('disabled','true');
		$("#ModelTypeCode").attr('disabled','true');
	}
	
	function callbackSave(){
		self.close();
		opener.reloadList();		
	}
	
	// 참조모델 팝업오픈
	function openModelGridList(){
		if("${modelID}" != ""){return;}
		var url = "searchModelGridList.do?ItemID=${ItemID}";
		var w = 900;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function doClickedCheckBox(){		
		if ($("input:checkbox[id='checkWidthItemMaster']").is(":checked") == true) {
			$("#checkWidthItemMaster").val("Y");
		}else{
			$("#checkWidthItemMaster").val("N");
		}
	}
	
	// refModelIdSetting
	function doSetModelID(ModelID, refModelName){		
		$("#refModelID").val(ModelID);
		$("#refModelName").val(refModelName);
	}
	
	function refModelInsert(){		
		if($("#newModelName").val()==""){ alert("${WM00034}"); return; }
		if($("#MTCTypeCode").val()==""){ alert("${WM00041_1}"); return; }
		if($("#ModelTypeCode").val()==""){ alert("${WM00041_2}"); return; }
		if($("#refModelID").val()==""){ alert("${WM00041_3}"); return; }
		
		if("${modelID}" != ""){
			var checkElmts = $("#checkElmts").val();
			var newModelName = $("#newModelName").val();
			var MTCTypeCode = $("#MTCTypeCode").val();
			var ModelTypeCode = $("#ModelTypeCode").val();
			opener.fnSetCopyModelInfo(checkElmts, newModelName, MTCTypeCode,ModelTypeCode);
			self.close();
		}else{		
			var blocked = "${Blocked}";
			var itemAthId = "${itemAthId}";
			var userId = "${sessionScope.loginInfo.sessionUserId}";
			if(confirm("${CM00009}")){	
				var url = "saveRefModel.do";
				var target = "blankFrame";		
				ajaxSubmitNoAdd(document.mdListFrm, url, target);
			}
		}
	}
	
	function fnOpenObjectList(){		
		var refModelID = $("#refModelID").val();
		var url = "elementObjectList.do?refModelID="+refModelID;
		var w = 800;
		var h = 500;
		
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

</script>
	
<body>
	<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}" >
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
		<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionUserId}">
		<input type="hidden" id="checkElmts" name="checkElmts" value="" >
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;${menu.LN00154}</p>
	</div>
	<div id="objectInfoDiv" style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00028}</th>
				<td width="70%" align="left" class="last">
					<input type="text" id="newModelName" name="newModelName" value=""  class="text"  style="width:250px;margin-left=5px;">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00033}</th>
				<td width="70%" align="left"  class="last">
					<select id="MTCTypeCode" name="MTCTypeCode" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00032}</th>
				<td width="70%" align="left" class="last">
					<select id="ModelTypeCode" name="ModelTypeCode" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00126}</th>
				<td width="70%" align="left" class="last">
					<input type="Text" id="refModelName" name="refModelName"  class="text" onclick="openModelGridList()" style="width:250px;margin-left=5px;">	
					<input type="hidden" id="refModelID" name="refModelID" >
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00146}</th>
				<td width="70%" align="left" class="last">
				<span class="btn_pack small icon"><span class="save"></span>
				<input value="Reuse Item Master" type="submit" onclick="fnOpenObjectList()"></span>
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN mgR15" id="divUpdateModel" >
			<span class="btn_pack small icon"><span class="save"></span>
				<input value="Save" type="submit" onclick="refModelInsert()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>