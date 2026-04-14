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

<script>
	var p_excelGrid;				//그리드 전역변수
	var p_attr1Grid;
	var p_attr2Grid;	
	fnRadio('MTCategoryList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=DISCSCP&radioID=MTCategorySel','MTCTypeCode','BAS','MTCategorySel','N');
	
	$(document).ready(function(){	
		gridAttr1Init();
		gridAttr2Init();
		doSearchAttr1List();
		doSearchAttr2List();

		var $chkboxes = $('input[type=radio][name=MTCategorySel]');
		$chkboxes.click(function() {
		    var currChkbox = this;
		    $chkboxes.each(function() {
		        if (this !== currChkbox) {
		            $(this).prop('checked', false);
		        }
		    });      
		});
		var timer = setTimeout(function() {
			$("#MTCategoryList").css("display","inline-block");
		}, 250); //1000 = 1초
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
			var newId = (new Date()).valueOf();
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
		var multiple = "${multiple}";
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		var d = setGridData();
		var url = "subItemListWithElmInfoSheet.do";
		if(multiple == "Y"){url =  "subItemListWithElmInfoMultiple.do?multiple=Y";}

		$('#subcols').val(d.subcols);
		$('#AttrTypeCode').val(d.subdata);
		$('#AttrName').val(d.attrName);
		$('#MTCategory').val($('input[type=radio][name=MTCategorySel]:checked').val());
		
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
		<input type="hidden" id="MTCategory" name="MTCategory" value="${MTCategory}">
		<input type="hidden" id="ArcCode" name="ArcCode" value="${ArcCode}"/>
		
		<input type="hidden" id="modelItemClass" name="modelItemClass" value="${modelItemClass}"/>
		<input type="hidden" id="elmChildList" name="elmChildList" value="${elmChildList}"/>
		<input type="hidden" id="elmInfoSheet" name="elmInfoSheet" value="${elmInfoSheet}"/>
		<input type="hidden" id="elmClass" name="elmClass" value="${elmClass}"/>
		
		<input type="hidden" id="original" name="original" value="">
		<input type="hidden" id="filename" name="filename" value="">
		<input type="hidden" id="downFile" name="downFile" value="">
		
		<input type="hidden" id="downLoadMode" name="downLoadMode" value="">
		<input type="hidden" id="scrnType" name="scrnType" value="">
	</div>
</form>
	<div id="framecontent" class="mgT10 mgB10">
		<span>${menu.LN00272}&nbsp;&nbsp;:&nbsp;&nbsp;</span><div id="MTCategoryList" style="padding-bottom:5px;"></div>
	</div>
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
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="btnDown" onclick="doSearchList();"></span>
			</td>
		</tr>
	</table>
</div>
<!-- END :: LIST_GRID -->

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
