<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016" />

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		gridOTInit();
		doOTSearchList();
		
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcFilterClsList";
		result.header = "${menu.LN00024},#master_checkbox,Class,Included,IsSecondary,ItemClassCode,ItemTypeCode";
		result.cols = "CHK|Class|Included|IsSecondary|ItemClassCode|ItemTypeCode"; 
		result.widths = "50,30,180,80,80,0,0"; 
		result.sorting = "int,int,str,str,str,str,str"; 
		result.aligns = "center,center,center,center,center,center,center"; 
		result.data = "arcCode=${arcCode}&languageID=${languageID}";
		return result;
	}
	
	function fnAddArcClass(){
		$("#divUpdateArcClass").attr('style', 'display: none');
		$("#newArcClass").attr('style', 'display: block');	
		$("#newArcClass").attr('style', 'width: 100%');	
		$("#divSaveArcClass").attr('style', 'display: block');
		$("input[name=chkbox]:checkbox").each(function() {
			$(this).attr('checked',false);
		});
		
		var data = "&LanguageID=${languageID}";		
		fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');
		fnGetClassCode();
	}
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		$("#divSaveArcClass").attr('style', 'display: none');
		$("#newArcClass").attr('style', 'display: block');	
		$("#newArcClass").attr('style', 'width: 100%');	
		$("#divUpdateArcClass").attr('style', 'display: block');
		var ClassCode = p_gridArea.cells(id,5).getValue();
		var Included = p_gridArea.cells(id,3).getValue();
		var IsSecondary = p_gridArea.cells(id,4).getValue();
		var ItemTypeCode = p_gridArea.cells(id,6).getValue();
		
		$("#ItemClassCode").val(ClassCode);
		
		var data = "&LanguageID=${languageID}";		
		fnSelect('itemTypeCode', data, 'itemTypeCode',ItemTypeCode, 'Select');
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+ItemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', ClassCode, 'Select'); 
		
		if(Included == 'Y'){
			$("input[id=IncludedCode]:checkbox").attr("checked",true);
		} else{
			$("input[id=IncludedCode]:checkbox").attr("checked",false);
		}
		if(IsSecondary == 'Y'){
			$("input[id=IsSecondaryCode]:checkbox").attr("checked",true);
		} else{
			$("input[id=IsSecondaryCode]:checkbox").attr("checked",false);
		}
		
	}
	
	function fnSaveArcClass(){
		if(confirm("${CM00012}")){
			$("input[name=chkbox]:checkbox").each(function() {
				if($(this).attr("checked") == true){
					$(this).val('Y');
				}else{
					$(this).val('N');
				};
			});
			var ClassCode = $("#ClassCode").val();
			var IncludedCode = $("#IncludedCode").val();
			var IsSecondaryCode = $("#IsSecondaryCode").val();
			
			var url = "saveArcClass.do";
			var data = "ClassCode=" + ClassCode + "&IncludedCode="+IncludedCode+"&IsSecondaryCode="+IsSecondaryCode+"&arcCode=${arcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUpdateArcClass(){
		if(confirm("${CM00016}")){
			$("input[name=chkbox]:checkbox").each(function() {
				if($(this).attr("checked") == true){
					$(this).val('Y');
				}else{
					$(this).val('N');
				};
			});
			var ClassCode = $("#ClassCode").val();
			var IncludedCode = $("#IncludedCode").val();
			var IsSecondaryCode = $("#IsSecondaryCode").val();
			var ItemClassCode = $("#ItemClassCode").val();
			
			var url = "updateArcClass.do";
			var data = "ClassCode=" + ClassCode + "&ItemClassCode="+ItemClassCode+"&IncludedCode="+IncludedCode+"&IsSecondaryCode="+IsSecondaryCode+"&arcCode=${arcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#newArcClass").attr('style', 'display: none');	
		$("#divSaveArcClass").attr('style', 'display: none');	
		doOTSearchList();
		var itemTypeCode = $("#ItemTypeCode").val();
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+itemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', '', 'Select'); 
	}
	
	function fnDeleteArcClass(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var ClassCode = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				ClassCode[j]= p_gridArea.cells2(i,5).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteArcClass.do";
			var data = "&arcCode=${arcCode}&ClassCode="+ClassCode;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnGetClassCode(){		
		var itemTypeCode = $("#itemTypeCode").val();
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+itemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', '', 'Select'); 
		
	}
	
	
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<%-- <input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}"> --%>
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Filter Class</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcClass()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteArcClass()"></span>
			</c:if>
		</li>		
	</div>
	</form>
	<div id="gridDiv" class="mgT10 mgL10 mgR10">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	
	<div class="mgT10 mgL10 mgR10">
	<table id="newArcClass" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">ItemType</th>
			<th class="viewtop last">Class</th>
			<th class="viewtop last">Included</th>
			<th class="viewtop last">IsSecondary</th>
		</tr>
		<tr>
			<input type="hidden" value="" name="ItemClassCode" id="ItemClassCode" />
			<td class="last"><select id="itemTypeCode" name="itemTypeCode" class="sel" OnChange="fnGetClassCode()" style="width:100%;" ></select></td>
			<td class="last"><select id="ClassCode" name="ClassCode" class="sel" style="width:100%;" ></select></td>
			<td class="last"><input type="checkbox" id="IncludedCode" name="chkbox" class="sel"></td>
			<td class="last"><input type="checkbox" id="IsSecondaryCode" name="chkbox" class="sel"></td>
		</tr>
	</table>
	</div>
	
	<div  class="alignBTN" id="divSaveArcClass" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveArcClass()" type="submit"></span>
		</c:if>		
	</div>
	
	<div  class="alignBTN" id="divUpdateArcClass" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnUpdateArcClass()" type="submit"></span>
		</c:if>		
	</div>	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>