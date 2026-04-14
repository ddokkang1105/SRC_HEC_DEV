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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	var height = 300;
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
	};
	
	//Grid 초기화
	gridOTInit();
	doOTSearchList();	
	
});	

function setWindowHeight(){
	var size = window.innerHeight;
	var height = 0;
	if( size == null || size == undefined){
		height = document.body.clientHeight;
	}else{
		height=window.innerHeight;
	}return height;
}

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	
	p_gridArea = fnNewInitGrid("grdGridArea", d);
	
	fnSetColType(p_gridArea, 1, "ch");
	fnSetColType(p_gridArea, 5, "img");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	p_gridArea.setIconPath("${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/");
	p_gridArea.setColumnHidden(2, true);
	p_gridArea.setColumnHidden(4, true);
	p_gridArea.setColumnHidden(7, true);
	p_gridArea.setColumnHidden(8, true);
	p_gridArea.setColumnHidden(9, true);
	p_gridArea.setColumnHidden(10, true);
	p_gridArea.setColumnHidden(11, true);
	p_gridArea.setColumnHidden(12, true);
	p_gridArea.setColumnHidden(13, true);
// 	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
// 		gridOnRowPSelect(id,ind);
// 	});
	
}

function setOTGridData(){

	var result = new Object();
	result.title = "${title}";
	
	result.key = "config_SQL.SelectSimbolType";
	result.header = "${menu.LN00024},#master_checkbox,ModelTypeCode,${menu.LN00015},ItemTypeCode,${menu.LN00176},${menu.LN00028},${menu.LN00035},ArisTypeNum,FromSymType,ToSymType,ImagePath,Creator,CreationTime,Category,${menu.LN00021},${menu.LN00016},Sort No."; 
	// #master_checkbox =  check box 전체선택
	
	result.cols = "CHK|ModelTypeCode|SymTypeCode|ItemTypeCode|SymbolIcon|Name|Description|ArisTypeNum|FromSymType|ToSymType|ImagePath|Creator|CreationTime|Category|ItemTypeName|Class|SortNum"; 
	
	result.widths = "50,50,100,100,100,80,100,200,100,100,100,300,100,100,100,100,100,100"; 
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str"; 
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center"; 
	
	result.data = "&LanguageID=${LanguageID}&ModelTypeCode=${ModelTypeCode}"  ;
					
	
	return result;
	
	/*	, ST.FromSymType
			, ST.ToSymType*/
}

// END ::: GRID	
//===============================================================================
	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

function AddWorkStep(){
	var url = "AddSimbolTypePop.do";
	
	var data = "&ModelTypeCode=${ModelTypeCode}" + 
				"&LanguageID="+$("#getLanguageID").val() + 
				"&Name=" + escape(encodeURI('${Name}'));
	
	url += "?" + data;

	var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
    	
}

function DeleteSymbolType(){
	
	if (p_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {	
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			for ( var i = 0; i < checkedRows.length; i++) {
				var url = "DeleteSymbolType.do";

				var data = "&ModelTypeCode=" + p_gridArea.cells(checkedRows[i], 2).getValue() +
						 	"&SymTypeCode=" + p_gridArea.cells(checkedRows[i], 3).getValue() +
						 	"&gubun=0";
						
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ArcFrame";
				
				ajaxPage(url, data, target);
				p_gridArea.deleteRow(checkedRows[i]);
			}
		}
	}
}
	
function Back(){
	
	var url = "modelTypeView.do";
	var target = "ModelTypeList";
	var data = "&ModelTypeCode=${ModelTypeCode}&LanguageID=${LanguageID}" + "&pageNum="+ $("#CurrPageNum").val() + "&Name=${Name}"; 
	
	ajaxPage(url,data,target);
}

function fnEditSortNum(){
	var checkedRows = p_gridArea.getCheckedRows(1).split(",");	;
	if(p_gridArea.getCheckedRows(1).length == 0){	
		alert("${WM00020}");		
		return;
	}
	
	var symTypes = new Array;
	for(var i = 0 ; i < checkedRows.length; i++ ){
		symTypes[i] = "'"+p_gridArea.cells(checkedRows[i], 3).getValue()+"'";
	}

	var url = "openEditSymAllocSortNum.do?symTypes="+symTypes+"&ModelTypeCode=${ModelTypeCode}";
	var w = 600;
	var h = 600;
	itmInfoPopup(url,w,h);
}
</script>
<body>
	<form name="SimbolTypeList" id="SimbolTypeList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
		<input type="hidden" id="Name" name="Name" value="${Name}">
		<input type="hidden" id="ModelTypeCode" name="ModelTypeCode" value="${ModelTypeCode}">
		<input type="hidden" id="getLanguageID" name="getLanguageID" value="${LanguageID}">
	</form>	
	<div class="cfgtitle">					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"id="subTitle_baisic">&nbsp;${Name}</li>
		</ul>
	</div>
	<div class="child_search mgB5 mgL10 mgR10">
		<ul>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">			
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" onclick="fnEditSortNum()" type="submit"></span>
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddWorkStep()"></span>
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteSymbolType()"></span>
			</c:if>
			</li>
		</ul>
	</div>
	<div id="grdGridArea"  class="mgL10 mgR10" style="width:100%;" class="clear"></div>	
	<div id="testDiv"></div>
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
	<!-- END :: BOARD_ADMIN_FORM -->
</body>
</html>