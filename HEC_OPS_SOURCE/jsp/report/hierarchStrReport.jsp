<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00147}"/> 

<script>
	var p_excelGrid;				//그리드 전역변수
	var p_attr1Grid;
	var p_attr2Grid;	
	
	$(document).ready(function(){	
		gridAttr1Init();
		gridAttr2Init();
		doSearchAttr1List();
		doSearchAttr2List();
		fnSelect('selectLanguageID', '&otherLangType=${sessionScope.loginInfo.sessionCurrLangType}', 'langType');
	});
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridAttr1Init(){		
		var d = setGridAttrData(1);
		
		p_attr1Grid = fnNewInitGrid("attr1GridArea", d);
		p_attr1Grid.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_attr1Grid.setColumnHidden(0, true);				//RNUM
		fnSetColType(p_attr1Grid, 1, "ch");//ra : radio
	}
	function gridAttr2Init(){		
		var d = setGridAttrData(2);
		
		p_attr2Grid = fnNewInitGrid("attr2GridArea", d);
		p_attr2Grid.setImagePath("${root}${HTML_IMG_DIR}/"); //path to images required by grid
		p_attr2Grid.setColumnHidden(0, true); //RNUM
		p_attr2Grid.setColumnHidden(3, true); //RNUM
		fnSetColType(p_attr2Grid, 1, "ch");//ra : radio
	}

	function setGridAttrData(avg){
		var result = new Object();
		result.title = "${title}";
		result.key = "report_SQL.itemAttrHeaderByHierarchStr";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+$("#s_itemID").val();
		
		if (avg == 1) {
			result.header = "${menu.LN00024},#master_checkbox,${menu.LN00114},${menu.LN00015}";
			result.data = result.data +"&itemMstListWLang=${itemMstListWLang}";
		} else {
			result.header = "${menu.LN00024},#master_checkbox,${menu.LN00115},${menu.LN00015}";
			result.data = result.data + "&Mandatory=1";
		}

		result.cols = "CHK|AttrName|AttrType";
		result.widths = "0,60,*,0";
		result.sorting = "int,int,str,str";
		result.aligns = "center,center,left,center";
		
		
		return result;
	}
	
	function doSearchAttr1List(){
		var d = setGridAttrData(1);
		fnLoadDhtmlxGridJson(p_attr1Grid, d.key, d.cols, d.data);
	}
	
	function doSearchAttr2List(){
		var d = setGridAttrData(2);
		fnLoadDhtmlxGridJson(p_attr2Grid, d.key, d.cols, d.data);
	}
	
	function doClickMove(toRight){
		var sourceGrid, targetGrid;
		if(toRight){sourceGrid = p_attr1Grid;targetGrid = p_attr2Grid;
		}else{	sourceGrid = p_attr2Grid;targetGrid = p_attr1Grid;}		
		var moveRowStr = sourceGrid.getCheckedRows(1);
		if(moveRowStr == null || moveRowStr.length == 0){alert("${WM00029}");	return;}
		var moveRowArray = moveRowStr.split(',');		
		for(var i = 0 ; i < moveRowArray.length ; i++){			
			var newId = (new Date()).valueOf() + i;
			targetGrid.addRow(newId, [newId,"0",sourceGrid.cells(moveRowArray[i],2).getValue(),sourceGrid.cells(moveRowArray[i],3).getValue()], targetGrid.getRowsNum());
		}
		for(var i = 0 ; i < moveRowArray.length ; i++){
			sourceGrid.deleteRow(moveRowArray[i]);
		}
	}	
	//==========================================================================
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");		
		p_excelGrid.setColumnHidden(0, true);
	}

	function setGridData(){
		var result = new Object();
		result.subcols = "";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+$("#s_itemID").val();
		result.subdata = "";
		result.attrName = "";
		
		var count=p_attr2Grid.getRowsNum();
		if( count != null && count > 0){
			
			var allRowIds = p_attr2Grid.getAllRowIds().split(",");
			for (var i = 0; i < allRowIds.length; i++) { // grid Id 순으로 데이터를 정렬한다
				result.header += ","+p_attr2Grid.cells(allRowIds[i], 2).getValue();
				result.cols += "|"+p_attr2Grid.cells(allRowIds[i], 3).getValue();
				result.subcols += "|"+p_attr2Grid.cells(allRowIds[i], 3).getValue();
				result.widths += ",100";
				result.sorting += ",str";
				result.aligns += ",center";
				result.subdata += ",'"+p_attr2Grid.cells(allRowIds[i], 3).getValue()+"'";
				result.attrName  += ",'"+p_attr2Grid.cells(allRowIds[i], 2).getValue()+"'";
			}
			
			if(result.subcols.length > 0){
				result.subcols = result.subcols.substring(1);
				result.subdata = result.subdata.substring(1);
				result.attrName = result.attrName.substring(1);
			}
		}
		return result;
	}
	//조회
	function doSearchList(){ 
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		var d = setGridData();
		//var itemTypeCode = "${itemTypeCode}";
		var url = "hierarchStrReportExcel.do";
		
		fnGetRadioValue('radioDownLoad', 'downLoadMode');
		fnGetCheckBox('checkLinefeed');
		
		if ($('#downLoadMode').val() == 2) {
			url = "hierarchStrReportExcelForPrc.do";
		}
		
		$('#subcols').val(d.subcols);
		$('#AttrTypeCode').val(d.subdata);
		$('#AttrName').val(d.attrName);
		
		ajaxSubmit(document.reportFrm, url);
	}
	
	function fnDownLoadExcel(){ 
		if($('#selectLanguageID').val() == ''){
			alert('${WM00025}');
			return;			
		}
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		
		var d = setGridData();
		var url = "downLoadItemMultiLanguageExcelReport.do";
		
		$('#subcols').val(d.subcols);
		$('#AttrTypeCode').val(d.subdata);
		$('#AttrName').val(d.attrName);
		
		ajaxSubmit(document.reportFrm, url);
	}
	
	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg1);
		$('#scrnType').val(avg2);
		
		ajaxSubmitNoAlert(document.reportFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
	
	// END ::: GRID	
	//===============================================================================
		
	//선택된 라디오 버틈 value 취득
	function fnGetRadioValue(radioName, hiddenName) {
		var radioObj = document.all(radioName);
		var isChecked = false;
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				$('#' + hiddenName).val(radioObj[i].value);
				isChecked = true;
				break;
			}
		}
		if (!isChecked) {
			$('#' + hiddenName).val(0);
		}
	}	
	
	function fnGetCheckBox(checkBoxName){
		var checkObj = document.all(checkBoxName);
		if (checkObj.checked) {
			$("#linefeedYN").val("Y");
		}else{
			$("#linefeedYN").val("N");
		}
	}
		
</script>
<!-- BIGIN :: ATTR LIST_GRID -->
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>

<div>
<form name="reportFrm" id="reportFrm" action="#" method="post" onsubmit="return false;">
	<div class="pdT10">
		<input type="hidden" id="subcols" name="subcols" value="">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode" value="">
		<input type="hidden" id="AttrName" name="AttrName" value="">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="ArcCode" name="ArcCode" value="${ArcCode}"/>
		
		<input type="hidden" id="original" name="original" value="">
		<input type="hidden" id="filename" name="filename" value="">
		<input type="hidden" id="downFile" name="downFile" value="">
		
		<input type="hidden" id="downLoadMode" name="downLoadMode" value="">
		<input type="hidden" id="linefeedYN" name="linefeedYN" value="">
		<input type="hidden" id="scrnType" name="scrnType" value="">
	</div>

	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col>
			</colgroup>
			<c:choose>
		   		<c:when test="${itemMstListWLang ne 'Y'}" >
				<tr>
					<!-- Download Option -->
					<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;Download Option</th>
					<td colspan="3" class="pdB5">
						<input type="radio" name="radioDownLoad" value=1 checked="checked">&nbsp;General&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${itemTypeCode eq 'OJ00001'}">
						<input type="radio" name="radioDownLoad" value=2>&nbsp;Hierarchy&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
						<input type="checkbox" name="checkLinefeed" id="checkLinefeed" value="">&nbsp;Include line feed data of name&nbsp;&nbsp;
						<!--  
						<c:if test="${itemTypeCode == 'OJ00001'}">
							<input type="radio" name="radioDownLoad" value=2>&nbsp;Hierarchy&nbsp;&nbsp;		
						</c:if>
						<c:if test="${itemTypeCode != 'OJ00001'}">
							<input type="radio" name="radioDownLoad" value=2 disabled="disabled">&nbsp;Hierarchy&nbsp;&nbsp;		
						</c:if>-->
					</td>
				</tr>
				</c:when>
	   		<c:otherwise>
				<c:if test="${itemMstListWLang eq 'Y'}">
				<tr>
					<th class="pdB5 pdT10" style="text-align:left;">&nbsp;&nbsp;Select additional Language</th>
					<td colspan="3" class="pdB5 pdT10">					
						<select id="selectLanguageID" Name="selectLanguageID" style="width:110px;">
					</td>
				</tr>
				</c:if>
			</c:otherwise>
			</c:choose>
		</table>
	</div>
	</form>
	<table style="width:100%;height:185px;overflow:hidden;" border="0" cellpadding="0" cellspacing="0">
		
		<tr>
			<td width="45%" align="left">
				<div id="attr1GridArea" style="height:250px;width:100%"></div>
			</td>
			<td width="10%" align="center">
				<img src="${root}${HTML_IMG_DIR}/btn_add_attr.png"  onclick="doClickMove(true);" title="추가">
				<!-- <span class="write"></span><input value="추가" type="submit" onclick="doClickMove(true);"></span> --><br><br>
				<img src="${root}${HTML_IMG_DIR}/btn_remove_attr.png"  onclick="doClickMove(false);" title="삭제">
				<!-- <span class="write"></span><input value="삭제" type="submit" onclick="doClickMove(false);"></span> -->
			</td>				
			<td width="45%" align="left"><div id="attr2GridArea" style="height:250px;width:100%"></div></td>
		</tr>
		<tr>
			<td colspan="3" align="right" class="pdT10 pdR20">
			<c:choose>
		   		<c:when test="${itemMstListWLang ne 'Y'}" >
					<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="btnDown" onclick="doSearchList();"></span>
				</c:when>			
				<c:otherwise>
					<c:if test="${itemMstListWLang eq 'Y'}">
						<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="btnDown" onclick="fnDownLoadExcel();"></span>
					</c:if>
				</c:otherwise>	
			</c:choose>		
			</td>
		</tr>
	</table>
</div>
<!-- END :: LIST_GRID -->

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
