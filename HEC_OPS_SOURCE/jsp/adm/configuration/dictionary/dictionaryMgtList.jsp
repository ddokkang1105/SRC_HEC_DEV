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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- 2. Script -->
<script type="text/javascript">
	
	var OT_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		};
		//Grid 초기화
		gridOTInit();
		//doOTSearchList();
		//doDetail('');
		fnSelect('getLanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('CategoryCode', '', 'dicCategory', '', 'Select');
		fnSelect('categoryType', '', 'dicCategory', '', 'Select');
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		
		$('.searchList').click(function(){
			doOTSearchList();
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doOTSearchList();
				return false;
			}
		});		
		setTimeout(function() {$('#searchValue').focus();}, 0);	
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setOTLayout(type){
		if( schCntnLayout != null){
			schCntnLayout.unload();
		}
		schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
		schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
		schCntnLayout.items[0].setHeight(350);
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setColumnHidden(8, true);		
		OT_gridArea.setColumnHidden(9, true);	
		OT_gridArea.setColumnHidden(10, true);
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "dictionary_SQL.selectDictionaryCode";
		result.header = "${menu.LN00024},#master_checkbox,CategoryCode,Category,Code,Name,Language Code,SortNum,Description,LanguageID,Editable";	//9
		result.cols = "CHK|Category|CategoryName|CODE|NAME|LanguageCode|SortNum|Description|LanguageID|Editable";
		result.widths = "50,50,100,150,150,250,100,80,80,80,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,left,center,left,center,left";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					  + "&searchKey="     + $("#searchKey").val()
				      + "&searchValue="     	+ $("#searchValue").val();
		
		if($("#CategoryCode").val() != null){
			result.data = result.data +"&CategoryCode="+$("#CategoryCode").val();			
		}
		
		 
		return result;	
	}
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){		
		$("#objType").val(OT_gridArea.cells(id, 4).getValue());
		$("#objName").val(OT_gridArea.cells(id, 5).getValue());
		$("#getLanguageID").val(OT_gridArea.cells(id, 9).getValue());
		$("#orgTypeCode").val(OT_gridArea.cells(id, 2).getValue());
		$("#categoryType").val(OT_gridArea.cells(id, 2).getValue());
		$("#Description").val(OT_gridArea.cells(id, 8).getValue());
		$("#sortNum").val(OT_gridArea.cells(id, 7).getValue());		

		if(OT_gridArea.cells(id, 10).getValue() == "1")
			$("#Editable").attr("checked","check");
		else
			$("#Editable").attr("checked","");
			
	}
	
	// END ::: GRID	
	//===============================================================================

	
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}

	function saveDictionary(){
		if(confirm("${CM00001}")){			
			var checkConfirm = false;
			if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
				if(confirm("${CM00006}")){
					checkConfirm = true;
				}
			}else{
				checkConfirm = true;
			}
			if(checkConfirm){
				var url = "saveDictionary.do";
				ajaxSubmit(document.DictionaryList, url,"saveDFrame");
			}
		}
	}


	function fnDeleteDictionary(){
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
				typeCodeArr[j]= OT_gridArea.cells2(i, 4).getValue();
				categoryCodeArr[j]= OT_gridArea.cells2(i, 2).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteDictinary.do";
			var data = "&typeCode="+typeCodeArr+"&categoryCode="+categoryCodeArr;
			var target = "saveDFrame";
			ajaxPage(url, data, target);	
		}
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
<body>
<div id="DictionaryMgtList"  style="margin:0 10px;" >

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="DictionaryList" id="DictionaryList" action="saveDictionary.do" method="post" onsubmit="return false;">
	<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
	<input type="hidden" id="orgCategoryCode" name="orgCategoryCode" />
	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Dictionary</li>

		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="pdL10">
			Code Category
			<select id="CategoryCode" name="CategoryCode"  onchange="doOTSearchList()">
			</select>
		</li>
		<li>
			<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="CODE">Code</option>
				<option value="NAME" 
					<c:if test="${searchKey == 'NAME'}"> selected="selected"</c:if>>
					Name
				</option>					
			</select>
		</li>
		<li>
			<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
		</li>
		<li class="floatR pdR10">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteDictionary()" ></span>
		</li>
	</div>	
        <div class="countList pdL10">
               <li class="count">Total <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdOTGridArea" style="height:240px; width:98%"></div>
		</div>
		<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<tr>
				<th class="viewtop last">Category</th>
				<th class="viewtop last">${menu.LN00015}</th>
				<th class="viewtop last" colspan=2>${menu.LN00028}</th>
			</tr>
			<tr>
				<td class="last">
					<select id="categoryType" name="categoryType" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" class="text" id="objType" name="objType" /></td>
				<td class="last" colspan=2><input type="text" class="text" id="objName" name="objName" /></td>
			</tr>
			<tr>
				<th class="last">LanguageID</th>
				<th class="last">SortNum</th>
				<th class="last">${menu.LN00035}</th>
				<th class="last">Editable</th>
			</tr>
			<tr>
				<td class="last">
					<select id="getLanguageID" name="getLanguageID" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" class="text" id="sortNum" name="sortNum" /></td>
				<td class="last"><input type="text" class="text" id="Description" name="Description" /></td>
				<td class="last"><input type="checkbox" class="checkbox" id="Editable" name="Editable" checked value="1"/></td>
			</tr>	
		</table>
		<div class="alignBTN">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="saveDictionary()"></span>
		</div>	
	</form>
</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	<!-- END :: BOARD_ADMIN_FORM -->
</body>
</html>