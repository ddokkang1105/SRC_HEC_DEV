<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

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
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ARC}/");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcTemplList";
		result.header = "${menu.LN00024},#master_checkbox,Code,Name,Sort No,ProjectID,Type";
		result.cols = "CHK|ArcCode|ArcName|SortNum|ProjectID|Type"; 
		result.widths = "50,50,100,150,60,80,70";
		result.sorting = "int,int,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode=${templCode}";
		return result;
	}

	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}

	function fnGoBack(){
		var url = "defineTemplateView.do";
		var target = "tempListDiv";
		var data = "&templCode=${templCode}&languageID=${languageID}" 
					+"&pageNum=${pageNum}&viewType=${viewType}";
		ajaxPage(url,data,target);
	}
	
	function fnOpenArcListPop(){
		var url = "openArcListPop.do?templCode=${templCode}";
		var option = "width=520,height=500,left=500,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function fnDeletArcTempl(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}else{
			if(confirm("${CM00004}")){
				var arcCode = new Array();
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var j = 0;
				for ( var i = 0; i < checkedRows.length; i++) {
					arcCode[j] = p_gridArea.cells(checkedRows[i],2).getValue(); 
					j++;
				}
				var url = "deleteArcTemplAlloc.do";
				var data = "&arcCode="+arcCode+"&templCode=${templCode}&pageNum=${pageNum}";
				var target = "subFrame";
				ajaxPage(url, data, target); 
			}
		}
	}
	
	function fnCallBack(){
		$("#modSortNum").attr('style', 'display: none');		
		$("#divSaveTemplArc").attr('style', 'display: none');	
		gridOTInit();
		doOTSearchList();
	}
	
	function gridOnRowSelect(id, ind){
		var arcCode = p_gridArea.cells(id, 2).getValue();
		var arcName = p_gridArea.cells(id, 3).getValue();
		var sortNum = p_gridArea.cells(id, 4).getValue();
		
		$("#modSortNum").attr('style', 'display: block');	
		$("#modSortNum").attr('style', 'width: 100%');	
		$("#divSaveTemplArc").attr('style', 'display: block');	
		
		$("#sortNum").val(sortNum);
		$("#arcCode").val(arcCode);
		$("#arcName").val(arcName);
	}
	
	function fnSaveSortNum(){
		if(confirm("${CM00001}")){
			var arcCode = $("#arcCode").val();
			var sortNum = $("#sortNum").val();
			var arcName = $("#arcName").val();
			
			var url = "saveTemplArcSortNum.do";
			var data = "arcCode=" + arcCode + "&templCode=${templCode}&sortNum=" + sortNum + "&arcName="+arcName + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
			var target = "subFrame";
			ajaxPage(url, data, target);
		}
	}
	
</script>
<body>
<form name="architectureAlloc" id="architectureAlloc" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
	   <div class="child_search mgL10 mgR10">
	
		<div class="floatR pdR20 pdB10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnOpenArcListPop()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeletArcTempl()" ></span>
			<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
		</c:if>
		</div>	
	</div>
	</form>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
    </div>		
	<div id="gridDiv" class="mgB10 mgL10 mgR10"">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	
	<div class="mgT5 mgL10 mgR10">
	<table id="modSortNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">Architecture Name</th>
			<th class="viewtop last">SortNum</th>
		</tr>
		<tr>
			<td class="last"><input type="text" class="text" id="arcName" name="arcName" />
							 <input type="hidden" class="text" id="arcCode" name="arcCode" /></td>
			<td class="last"><input type="text" class="text" id="sortNum" name="sortNum" /></td>
		</tr>
	</table>
	</div>
	
	
	<div  class="alignBTN" id="divSaveTemplArc" style="display: none;">
		<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveSortNum()"  type="submit"></span>
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="subFrame" id="subFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>