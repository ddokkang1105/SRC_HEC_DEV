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
		//Grid 초기화
		gridOTInit();

		fnSelect('categoryType', '&Category=DOCCAT', 'dictionyCode', '${resultMap.Category}', 'Select');
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);

		OT_gridArea.setColumnHidden(4, true);	
		OT_gridArea.setColumnHidden(5, true);	
		OT_gridArea.setColumnHidden(6, true);	
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid

		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "wf_SQL.getWFAllocationList";
		result.header = "${menu.LN00024},#master_checkbox,Document Category,Menu Name,,,";	//9
		result.cols = "CHK|CategoryName|MenuName|DocCategoryCode|MenuID|WFID";
		result.widths = "50,50,150,200,10,10,10";
		result.sorting = "int,int,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					  + "&wfID=${wfID}";
		
		return result;	
	}
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){		
		$("#menuName").val(OT_gridArea.cells(id, 3).getValue());
		$("#menuID").val(OT_gridArea.cells(id, 5).getValue());	
		$("#categoryType").val(OT_gridArea.cells(id, 4).getValue()).prop("selected",true);	

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
			var url = "saveWfMNAlloc.do";
			ajaxSubmit(document.DictionaryList, url,"saveDFrame");
		}
	}


	function fnDeleteDictionary(){
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		
		var cnt  = OT_gridArea.getRowsNum();
		var menuArr = new Array;
		var categoryCodeArr = new Array;
		var wfIDs = new Array;
		var j = 0;
		
		for ( var i = 0; i < cnt; i++) { 
			chkVal = OT_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				menuArr[j]= OT_gridArea.cells2(i, 5).getValue();
				categoryCodeArr[j]= OT_gridArea.cells2(i, 4).getValue();
				wfIDs[j]= OT_gridArea.cells2(i, 6).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteWfMNAlloc.do";
			var data = "&menuIDs="+menuArr+"&categoryCode="+categoryCodeArr+"&wfIDs="+wfIDs;
			var target = "saveDFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnCallBack(stat){ 
		gridOTInit();
		doOTSearchList();
		if(stat == "del"){
			$("#menuID").val("");
			$("#menuName").val("");
			$("#categoryType option:eq(0)").attr("selected",true);
		}
	}
	
	function fnOpenMenuListPop(){
		var url = "menuListPop.do?languageID=${languageID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		$("#menuID").val(menuId);
		$("#menuName").val(menuName);
	}
	
	

</script>
<body>
<div id="DictionaryMgtList"  style="margin:0 10px;" >

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="DictionaryList" id="DictionaryList" action="saveDictionary.do" method="post" onsubmit="return false;">
	<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
	<input type="hidden" id="orgCategoryCode" name="orgCategoryCode" />
	<input type="hidden" id="menuID" name="menuID" />
	<input type="hidden" id="wfID" name="wfID" value="${wfID}"/>
	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Dictionary</li>

		</ul>
	</div>	
	<div class="child_search">
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteDictionary()" ></span>
		</li>
	</div>	
        <div class="countList">
               <li class="count">Total <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdOTGridArea" style="height:240px; width:98%"></div>
		</div>
		<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<tr>
				<th class="viewtop last">Document Category</th>
				<th class="viewtop last">${menu.LN00124}</th>
			</tr>
			<tr>
				<td class="last">
					<select id="categoryType" name="categoryType" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" id="menuName" name="menuName" OnClick="fnOpenMenuListPop()" class="text" ></td>
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