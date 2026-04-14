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

<!-- 2. Script -->
<script type="text/javascript">
var OT_gridArea;				//그리드 전역변수
$(document).ready(function() {	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
	};
	$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
	gridOTInit();
	doOTSearchList();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
//BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();	
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	fnSetColType(OT_gridArea, 1, "ch");
	
	OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
	
}  

function setOTGridData(){
	
	var result = new Object();
	result.title = "${title}";
	
	result.key = "config_SQL.pointType";
	result.header = "${menu.LN00024},#master_checkbox,PointTypeID,Name,Description,FunctionNM,POINT";
	result.cols = "CHK|PointTypeID|Name|Description|FunctionNM|POINT";
	result.widths = "50,50,150,200,300,100,50";
	result.sorting = "int,int,str,str,str,str,int";
	result.aligns = "center,center,center,center,center,center,center";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&TypeCode=${s_itemID}" + "&pageNum=" + $("#currPage").val();
	return result;

}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind){		
	$("#PointType").val(OT_gridArea.cells(id, 2).getValue());
	$("#FunctionNM").val(OT_gridArea.cells(id, 5).getValue());
	$("#Point").val(OT_gridArea.cells(id, 6).getValue());			
}

function setOTLayout(type){
	if( schCntnLayout != null){
		schCntnLayout.unload();
	}
	schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
	schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
	schCntnLayout.items[0].setHeight(350);
}

function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}

//END ::: GRID
//===============================================================================
	
function savePointType(){
	if(confirm("${CM00001}")){			
		
		var url = "savePointType.do";
		ajaxSubmit(document.processList, url,"blankFrame");
		
	}
}

function fnDeletePointType(){
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		alert("${WM00023}");
		return;
	}
	var cnt  = OT_gridArea.getRowsNum();
	var typeCodeArr = new Array;
	var categoryCodeArr = new Array;
	var j = 0;
	for ( var i = 0; i < cnt; i++) { 
		chkVal = OT_gridArea.cells2(i,1).getValue();
		if(chkVal == 1){
			typeCodeArr[j]= OT_gridArea.cells2(i, 3).getValue();
			j++;
		}
	}
	
	if(confirm("${CM00004}")){
		var url = "deletePointType.do";
		var data = "&typeCode="+typeCodeArr;
		var target = "blankFrame";
		ajaxPage(url, data, target);	
	}
}
function urlReload() {
	doOTSearchList();
}

function fnCallBack(stat){ 
	gridOTInit();
	doOTSearchList();
	if(stat == "del"){
		$("#objType").val("");
		$("#objName").val("");
		$("#getLanguageID").val("");
		$("#orgTypeCode").val("");
		$("#categoryType").val("");
		$("#Description").val("");
		$("#sortNum").val("");	 
	}
}


</script>

</head>

<body>
<div id="pointTypeDiv" style="margin:0 10px;">
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Point Type</li>

		</ul>
	</div>	

	<div class="child_search">
		<ul>
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<!-- 엑셀 다운 아이콘  -->
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			<!-- 삭재 아이콘 -->
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delPointType();" ></span>
			</c:if>	
		</li>
		</ul>
	</div>
	<div class="countList">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridOTDiv" class="mgB10 clear">
		<div id="grdOTGridArea" style="height:140px; width:98%"></div>
	</div>
	<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<tr>
			<th class="last">PointType</th>
			<th class="last">FunctionNM</th>
			<th class="last">Point</th>
		</tr>
		<tr>
			<td class="last"><input type="text" class="text" id="PointType" name="PointType"  readonly=true/></td>
			<td class="last"><input type="text" class="text" id="FunctionNM" name="FunctionNM" /></td>
			<td class="last"><input type="text" class="text" id="Point" name="Point" /></td>
		</tr>	
	</table>
	<div class="alignBTN">
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="savePointType()"></span>
	</div>	
</form>
</div>
	
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
<!-- END :: FRAME -->	
		
</body>
</html>