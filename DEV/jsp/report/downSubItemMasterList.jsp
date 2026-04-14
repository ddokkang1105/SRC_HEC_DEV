<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00147}"/> 

<script>
	var p_excelGrid;				

	$(document).ready(function(){	
		doSearchAttr1List();
		doSearchAttr2List();
		fnSelect('selectLanguageID', '&otherLangType=${sessionScope.loginInfo.sessionCurrLangType}', 'langType');
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
	
	// 왼쪽 그리드 데이터 호출 및 주입
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
	
	// 오른쪽 그리드 데이터 호출 및 주입
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
	            result.subdata += "#'" + item.AttrType + "'";
	            result.attrName += "#'" + item.AttrName + "'";
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
	
	// 조회
	function doSearchList(){  
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		var d = setGridData();
		//var itemTypeCode = "${itemTypeCode}";
		var url = "subItemMasterListExcel.do";
		
		fnGetRadioValue('radioDownLoad', 'downLoadMode');
		fnGetCheckBox('checkLinefeed');
		
		if ($('#downLoadMode').val() == 2) {
			url = "subItemMasterListWithStr.do";
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
		
	//선택된 라디오 버튼 value 취득
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
	
	function handleHeaderCheckboxClick(state, targetGrid, checkboxName, headerCheckboxID) {
	    event.stopPropagation();
	    targetGrid.data.forEach(function(row) {
	        targetGrid.data.update(row.id, {
	            [checkboxName]: state
	        });
	    });  
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
		<input type="hidden" id="defDimValueID" name = "defDimValueID" value="${defDimValueID}" >
		<input type="hidden" id="showInvisible" name = "showInvisible" value="${showInvisible}" >
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
						<input type="checkbox" name="checkLinefeed" id="checkLinefeed" value="">&nbsp;Include line feed data of name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Max Level&nbsp;
						<select name="maxLevel" style="width:60px;">
							<option value="">Select</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
						</select>
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
