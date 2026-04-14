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

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
	};

	//Grid 초기화
	gridOTInit();
	doOTSearchList();	
});	

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	p_gridArea = fnNewInitGrid("grdGridArea", d);	
	fnSetColType(p_gridArea, 1, "ch");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	p_gridArea.setColumnHidden(8, true);
	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
}

function setOTGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.getClassAttrLocateList";
	result.header = "${menu.LN00024},#master_checkbox,Sort No.,Code,${menu.LN00028},Mandatory,Invisible,Link,Link,RowNum,ColumnNum,Height,VarFilter,Allocation";
	result.cols = "CHK|SortNum|AttrTypeCode|Name|Mandatory|Invisible|LinkName|Link|RowNum|ColumnNum|AreaHeight|VarFilter|AllocationType";
	result.widths = "50,50,60,120,160,100,100,100,80,80,80,80,80,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,left,center,center,center,center,center,center,center,center,center,center";
	result.data =  "ItemClassCode=${s_itemID}"	
	 			+ "&languageID=${languageID}";
	return result;
}

function AddAttributeType(){
	var url = "addAttrTypeCode.do";
	var data = "&TypeCode=${s_itemID}" + 
				"&languageID=${languageID}"+ 
				"&ItemTypeCode=${ItemTypeCode}"+
				"&ClassName=" + escape(encodeURIComponent('${ClassName}'));			
	url += "?" + data;
	var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

// END ::: GRID	
//===============================================================================
	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

function DelteAttrType(){
	if (p_gridArea.getCheckedRows(1).length == 0){
		alert("${WM00023}");
	} else {
		if (confirm("${CM00004}")) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			for ( var i = 0; i < checkedRows.length; i++) {
				var url = "DeleteAttrType.do";

				var data = "&SortNum=" + p_gridArea.cells(checkedRows[i], 2).getValue()
						+ "&AttrTypeCode=" + p_gridArea.cells(checkedRows[i], 3).getValue()
						+ "&ItemClassCode=${s_itemID}" 
						+ "&ItemTypeCode=${ItemTypeCode}";
						
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ArcFrame";
				ajaxPage(url, data, target);	
			}
		}
	}
	
}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	var url    = "SubAttributeType_SortNum.do"; // 요청이 날라가는 주소
	var data   = "&SortNum="+ p_gridArea.cells(id, 2).getValue() +
				 "&AttrTypeCode="+ p_gridArea.cells(id, 3).getValue() +
				 "&Mandatory=" + p_gridArea.cells(id, 5).getValue() +
				 "&Invisible=" + p_gridArea.cells(id, 6).getValue() +
				 "&Link=" + p_gridArea.cells(id, 8).getValue() +
				 "&ItemClassCode=${s_itemID}" +
				 "&ClassName=${ClassName}" +
				 "&languageID=${languageID}" +
				 "&areaHeight=" + p_gridArea.cells(id, 11).getValue()+
				 "&rowNum="+ p_gridArea.cells(id, 9).getValue()+
				 "&columnNum="+ p_gridArea.cells(id, 10).getValue()+
				 "&varFilter=" + p_gridArea.cells(id, 12).getValue().replace(/&/gi,"%26")+
				 "&allocationType=" + p_gridArea.cells(id, 13).getValue()+
				 "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
			
	var target = "testDiv";
	ajaxPage(url, data, target);	
}

function Back(){
	var url = "ClassTypeView.do";
	var target = "classTypeDiv";
	var data = "&ItemClassCode=${s_itemID}&LanguageID=${languageID}"
		+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
	ajaxPage(url,data,target);
}

function urlReload(){
	var url = "SubAttributeTypeAllocation.do";
	var data = "&languageID=${languageID}&s_itemID=${s_itemID}&ClassName=${ClassName}"
		+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
	var target = "ArcFrame";
	ajaxPage(url, data, target);
}

</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">	
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${ClassName}</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>								
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="AddAttributeType()"></span>	
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="DelteAttrType()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10 mgL10 mgR10">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div id="testDiv"></div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>