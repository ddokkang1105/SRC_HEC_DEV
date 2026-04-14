<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3"/>

<!-- 2. Script -->
<script type="text/javascript">
	
	var OT_gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		
		fnSelect('SRType', '', 'getSRTypeCode', '', 'Select');
		
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		
		gridOTInit();
		doOTSearchList();
	});
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		OT_gridArea.setColumnHidden(4, true); 
 		OT_gridArea.setColumnHidden(9, true); 
		OT_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});
		
		//START - PAGING
		OT_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}

	function setOTGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getAllSRAreaList";
		result.header = "${menu.LN00024},#master_checkbox,SR Type, Name, Item Class Code, Item Class Name, Level, ${menu.LN00070}, ${menu.LN00105},ItemTypeCode"; 
		result.cols = "CHK|SRTypeCode|SRTypeNM|ItemClassCode|ItemClassName|Level|LastUpdated|LastUserName|ItemTypeCode";
		result.widths = "50,50,100,200,100,150,100,100,100,100";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left,center,center,center,center";
		result.data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		if($("#SRType").val() != '' && $("#SRType").val() != null){
			result.data = result.data +"&srTypeCode="+$("#SRType").val();
		}
		return result;

	}

	
	// END ::: GRID	
	//===============================================================================

	//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}
 
//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	viewType = "E";
	$("#NewSRArea").attr('style', 'display: table');
	$("#divSaveSRArea").attr('style', 'display: block');
	$(".addTd").attr('style', 'display: none');
	$(".modTd").attr('style', 'display: table-cell');
	
	$("#SRTypeTd").text(OT_gridArea.cells(id,2).getValue());
	$("#SRTypeNameTd").text(OT_gridArea.cells(id,3).getValue());
	var ItemTypeCode = OT_gridArea.cells(id,9).getValue();
	var ItemClassCode = OT_gridArea.cells(id,4).getValue();
	var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&option=" + ItemTypeCode;
	fnSelect('ItemClassNameTd', data, 'classCodeOption', ItemClassCode, 'Select');
	$("#ItemClassCode").val(ItemClassCode);
	$("#ItemClassCodeNew").val($("#ItemClassNameTd").val());
	$("#Level").val(OT_gridArea.cells(id, 6).getValue());
	$("#LevelTd").val(OT_gridArea.cells(id, 6).getValue());
}

function fnAddSRAreaList(){
	viewType = "N";
	$("#NewSRArea").attr('style', 'display: table');	
	$("#divSaveSRArea").attr('style', 'display: block');
	$(".addTd").attr('style', 'display: table-cell');
	$(".modTd").attr('style', 'display: none');

	fnSelect('SRTypeNameNew', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}', 'getNameFromSRTypeCode','', 'Select');
 	$("#SRTypeNameNew").val("");
	$("#ItemClassNameNew").val("");
	$("#LevelNew").val(""); 
 	$("#SRTypeNameNew").change(function(){
		 var SRTypeCode = $("#SRTypeNameNew").val();
		 var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&srTypeCode=" + SRTypeCode;
		fnSelect('ItemClassNameNew', data, 'classCodeOption','', 'Select');
	}); 
	 $("#ItemClassNameNew").change(function(){
		$("#ItemClassCodeNew").val($("#ItemClassNameNew").val());
	}); 
}

function saveSRArea(){
	var ItemClassCode = $("#ItemClassCode").text();
	
	
	if(viewType == "N" ){	// add일 경우
		var SRTypeCode = $("#SRTypeNameNew").val();
		var ItemClassCodeNew = $("#ItemClassCodeNew").val();
		var LevelNew = $("#LevelNew").val();
		// [OBJECT 필수 체크]		
		if(LevelNew == ""){
			alert("${WM00034_3}");
			return false;
		}
		if(ItemClassCodeNew == ""){
			alert("${WM00034_1}");
			alert("${WM00034_2}");
			return false;
		}
	} else {		//edit일 경우
		var SRTypeCode = $("#SRTypeTd").text();
		var ItemClassCodeNew = $("#ItemClassNameTd").val();
		var LevelTd = $("#Level").val();
		var LevelNew = $("#LevelTd").val();
		var ItemClassCode = $("#ItemClassCode").val();
	}
	
	var url = "saveSRArea.do";
	var data = "viewType="+viewType+"&SRTypeCode="+SRTypeCode+"&ItemClassCodeTd="+ItemClassCode+"&LevelTd="+LevelTd+"&Level="+LevelNew
	+"&ItemClassCode="+ItemClassCodeNew+"&languageID=${languageID}&lastUser=${sessionScope.loginInfo.sessionUserId}"; 
	var target = "saveDFrame";
	ajaxPage(url, data, target);
}

function fnCallBack(){ 
	$("#NewSRArea").attr('style', 'display: none');
	$("#divSaveSRArea").attr('style', 'display: none');
	$("#SRTypeNew").val("");
	$("#ItemClassCode").val("");
	$("#ItemClassName").val("");
	
	gridOTInit();
	doOTSearchList();
	
}

 function fnDelSRAreaList(){		
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		alert("${WM00023}");
		return;
	}
	var cnt  = OT_gridArea.getRowsNum();
	var ItemClassCode = new Array;
	var Level = new Array;
	var j = 0;
	var chkVal;
	for ( var i = 0; i < cnt; i++) { 
		chkVal = OT_gridArea.cells2(i,1).getValue();
		if(chkVal == 1){
			ItemClassCode[j] = OT_gridArea.cells2(i, 4).getValue();
			Level[j] =  OT_gridArea.cells2(i, 6).getValue();
			j++;
		}
	}	
	var url = "deleteSRAreaList.do";
	var data = "&ItemClassCode="+ItemClassCode+"&Level="+Level+"&pageNum=" + $("#currPage").val();	
	var target = "saveDFrame";	
	ajaxPage(url,data,target);	
}
 
 function thisReload(){
		fnCallBack();
		var url    = "defineSRArea.do"; // 요청이 날라가는 주소
		var data   = "&languageID="+$("#languageID").val()
					+ "&pageNum=${pageNum}"
					+ "&SRType="+$("#SRType").val();
		var target = "srAreaDiv";
		ajaxPage(url,data,target);	
	}
	
</script>
</head>
<body>
<div id="srAreaDiv">
	<form name="srAreaList" id="srAreaList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input>
	<input type="hidden" id="Level" name="Level" value="${Level}"></input> 
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${ItemClassCode}" />
	<input type="hidden" id="ItemClassCodeNew" name="ItemClassCodeNew" value="" />
	<input type="hidden" id="ItemClassName" name="ItemClassName" value="${ItemClassName}" />
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Area List</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="pdL10">
			SR Type
			<select id="SRType" name="SRType" onchange="doOTSearchList()" style="width:120px;margin-left:5px;">
			</select>
		</li>
		<li class="floatR pdR10">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="New" onclick="fnAddSRAreaList()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelSRAreaList()" ></span>
		</li>
	</div>
	<div class="countList pdL10">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR">&nbsp;</li>
 	</div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:360px; width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	
	<div class="mgT10 mgL10 mgR10">
	<table id="NewSRArea" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" style="display:none">

		<colgroup>
		</colgroup>
		
		<tr>
			<th width="25%" class="viewtop last">SR Type</th>
			<th width="25%" class="viewtop last modTd">Name</th>
			<th width="25%" class="viewtop last">클래스</th>
			<th width="25%" class="viewtop last">Level </th>
		</tr>
		<tr>
			<!-- <td width="" class="last addTd">
				<select id="SRTypeNew" name="SRTypeNew" class="sel"></select>
			</td> -->
			<td width="" class="last modTd" id="SRTypeTd"></td>
			<td width="" class="last addTd"><select id="SRTypeNameNew" name="SRTypeNameNew" class="sel" ></select></td>
			<td width="" class="last modTd" id="SRTypeNameTd"></td>
			<td width="" class="last addTd"><select id="ItemClassNameNew" name="ItemClassNameNew" class="sel" ></select></td>
			<td width="" class="last modTd"><select id="ItemClassNameTd" name="ItemClassNameTd" class="sel" ></select></td>
			<td width="" class="last addTd">
				<select id="LevelNew" name="LevelNew" class="sel">
					<option value="">Select</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
				</select>
			</td>
			<td width="" class="last modTd">
				<select id="LevelTd" name="LevelTd" class="sel">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
				</select>
			</td>
		</tr>
	</table>
</div>
<div class="alignBTN" id="divSaveSRArea" style="display: none;">
	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="saveSRArea()"  type="submit"></span>
	</c:if>		
</div>	
	
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>
