<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>

<script>
	var p_excelGrid;				//그리드 전역변수
	var p_attr1Grid;
	var p_attr2Grid;	
	fnRadio('MTCategoryList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=DISCSCP&radioID=MTCategorySel','MTCTypeCode','BAS','MTCategorySel','N');
	
	$(document).ready(function(){	
// 		gridAttr1Init();
// 		gridAttr2Init();
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
	
	function fnReloadGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function setGridConfig(avg){
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
		const currentGridConfig = setGridConfig(1);
		var param = "";
		param += currentGridConfig.data + "&sqlID="+currentGridConfig.key
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(newGridData){
 				fnReloadGrid(attr1Grid, newGridData);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	function doSearchAttr2List(){		
		const currentGridConfig = setGridConfig(2);
		var param = "";
		param += currentGridConfig.data + "&sqlID="+currentGridConfig.key
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(newGridData){
 				fnReloadGrid(attr2Grid, newGridData);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	function doClickMove(toRight){
// 		var sourceGrid, targetGrid;
// 		if(toRight){sourceGrid = p_attr1Grid;targetGrid = p_attr2Grid;
// 		}else{	sourceGrid = p_attr2Grid;targetGrid = p_attr1Grid;}		
// 		var moveRowStr = sourceGrid.getCheckedRows(1);
// 		if(moveRowStr == null || moveRowStr.length == 0){alert("${WM00029}");	return;}
// 		var moveRowArray = moveRowStr.split(',');		
// 		for(var i = 0 ; i < moveRowArray.length ; i++){			
// 			var newId = (new Date()).valueOf();
// 			targetGrid.addRow(newId, [newId,"0",sourceGrid.cells(moveRowArray[i],2).getValue(),sourceGrid.cells(moveRowArray[i],3).getValue()], targetGrid.getRowsNum());
// 		}
// 		for(var i = 0 ; i < moveRowArray.length ; i++){
// 			sourceGrid.deleteRow(moveRowArray[i]);
// 		}
		
		const sourceGrid = toRight ? attr1Grid : attr2Grid;
		const targetGrid = toRight ? attr2Grid : attr1Grid;
	
		var moveRowArray = [];
	    sourceGrid.data.forEach(function(row) {
	        if (row.CHK) { 
	        	moveRowArray.push(row.id);
	        }
	    });
  
        if(moveRowArray.length < 1 ){alert("${WM00029}");	return;}
		

        moveRowArray.forEach(rowId => {
            const row = sourceGrid.data.getItem(rowId);
            const newRow = {
                ...row,
                CHK: 0,
            };
            targetGrid.data.add(newRow);
        });


        sourceGrid.data.remove(moveRowArray);
	}	
	//==========================================================================
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function setGridData(){
	    var result = {
	            subcols: "",
	            data: "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=" + $("#s_itemID").val(),
	            subdata: "",
	            attrName: "",
	            header: "",
	            cols: "",
	            widths: "",
	            sorting: "",
	            aligns: ""
	        };

		
	    var count = attr2Grid.data.getLength();
		if( count > 0){
	        attr2Grid.data.forEach(function(item) {
	            result.header += "," + item.AttrName;
	            result.cols += "|" + item.AttrType;
	            result.subcols += "|" + item.AttrType;
	            result.widths += ",100";
	            result.sorting += ",str";
	            result.aligns += ",center";
	            result.subdata += ",'" + item.AttrType + "'";
	            result.attrName += ",'" + item.AttrName + "'";
	        });

	        result.header = result.header.substring(1);
	        result.cols = result.cols.substring(1);
	        result.subcols = result.subcols.substring(1);
	        result.widths = result.widths.substring(1);
	        result.sorting = result.sorting.substring(1);
	        result.aligns = result.aligns.substring(1);
	        result.subdata = result.subdata.substring(1);
	        result.attrName = result.attrName.substring(1);
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
	
	function handleHeaderCheckboxClick(state, targetGrid, checkboxName, headerCheckboxID) {
	    event.stopPropagation();
	    targetGrid.data.forEach(function(row) {
	        targetGrid.data.update(row.id, {
	            [checkboxName]: state
	        });
	    });  
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
<script>
	const attr1GridArea = new dhx.Layout("attr1GridArea", {
		rows: [ { id: "a" } ] });
	
	var attr1Grid = new dhx.Grid("attr1GridArea", {
	    columns: [
	        { width: 60, id: "CHK",
	        	header: [{ htmlEnable: true,
	        		id: 'CHKHeader1',
	        		text: "<input type='checkbox' onclick=\"handleHeaderCheckboxClick(checked, attr1Grid, 'CHK')\"></input>",
	        		align: "center",
	        		htmlEnable: true}],
	    		align: "center", type: "boolean", editable: true, sortable: false},
	        { id: "AttrName", header: [{ text: "${menu.LN00114}", align: "center" },], align: "left"},
	        { hidden: true, id: "AttrType", header: [{ text: "${menu.LN00114}", align: "center" },], align: "left"},
	
	    ],
	    autoHeight: true,
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	attr1GridArea.getCell("a").attach(attr1Grid);
	
	const attr2GridArea = new dhx.Layout("attr2GridArea", {
		rows: [ { id: "b" } ] });
	
	var attr2Grid = new dhx.Grid("attr2GridArea", {
	    columns: [
	        { width: 60, id: "CHK",
	        	header: [{ htmlEnable: true,
	        		id: 'CHKHeader1',
	        		text: "<input type='checkbox' onclick=\"handleHeaderCheckboxClick(checked, attr2Grid, 'CHK')\"></input>",
	        		align: "center",
	        		htmlEnable: true}],
	    		align: "center", type: "boolean", editable: true, sortable: false},
	        { id: "AttrName", header: [{ text: "${menu.LN00115}", align: "center" },], align: "left"},
	        { hidden: true, id: "AttrType", header: [{ text: "${menu.LN00114}", align: "center" },], align: "left"},
	
	    ],
	    autoHeight: true,
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	attr2GridArea.getCell("b").attach(attr2Grid);
</script>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
