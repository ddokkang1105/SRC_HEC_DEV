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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var viewType;
	
	$(document).ready(function() {
		gridOTInit();
		doOTSearchList();		
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select');
		
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "procConfig_SQL.getAllocateItemMenu";
		result.header = "${menu.LN00024},#master_checkbox,MenuId,MenuName,Alias,MenuType,Sort,ItemID,VarFilter,DicCode,ItemMenuID,menuTypeCode";
		result.cols = "CHK|MenuID|MenuName|Alias|MenuTypeName|Sort|ItemID|VarFilter|DicCode|ItemMenuID|MenuType"; 
		result.widths = "50,30,120,150,150,80,80,300,150,80,120"; 
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str"; 
		result.aligns = "center,center,center,left,left,center,center,center,center,center,center,center,center,center,center"; 
		result.data = "languageId=${languageID}&s_itemID=${s_itemID}";
		return result;
	}
	
	function fnAddArcMenu(){
		var url = "pim_AddAllocItemMenuPop.do";
		var data = "&s_itemID=${s_itemID}&languageID=${languageID}" 
		url += "?" + data;
		var option = "width=520,height=300,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		viewType = "E";
		$("#newArcMenu").attr('style', 'display: block');	
		$("#newArcMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');

		$("#menuName").val(p_gridArea.cells(id, 3).getValue());
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', p_gridArea.cells(id, 9).getValue(), 'Select');
		$("#varFilter").val(p_gridArea.cells(id, 8).getValue().replace(/&/gi,"%26"));
		$("#sortNum").val(p_gridArea.cells(id, 6).getValue());
		$("#itemMenuID").val(p_gridArea.cells(id, 10).getValue());
		$("#menuId").val(p_gridArea.cells(id, 2).getValue());
		$("#menuType").val(p_gridArea.cells(id, 11).getValue()).attr("selected", "selected");
	}
	
	function fnSaveMenu(){
		if(confirm("${CM00012}")){
			var menuId = $("#menuId").val();
			var sortNum = $("#sortNum").val();
			var dicCode = $("#dicCode").val();
			var varFilter = $("#varFilter").val().replace(/&/gi,"%26");
			var sortNum = $("#sortNum").val();
			var itemMenuID = $("#itemMenuID").val();
			var menuType = $("#menuType").val();
			
			var url = "pim_SaveAllocItemMenu.do";
			var data = "&menuId="+menuId + "&s_itemID=${s_itemID}"
					+"&sortNum="+sortNum+"&dicCode="+dicCode + "&menuType=" + menuType
					+"&varFilter="+varFilter+"&viewType="+viewType+"&itemMenuID="+itemMenuID; 
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#newArcMenu").attr('style', 'display: none');	
		$("#divSaveArcMenu").attr('style', 'display: none');
		
		gridOTInit();
		doOTSearchList();
		
	}
	
	function fnDeleteArcMenu(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var itemMenuID = new Array;
	
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				itemMenuID[j]= p_gridArea.cells2(i, 10).getValue();
				j++;
			}
		}

		if(confirm("${CM00004}")){
			var url = "pim_DeleteAllocItemMenu.do";
			var data = "&itemMenuID="+itemMenuID + "&s_itemID=${s_itemID}";
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnOpenMenuListPop(){
		var url = "pim_menuListPop.do?languageID=${languageID}&menuCat=ITM&s_itemID=${s_itemID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		$("#menuId").val(menuId);
		$("#menuName").val(menuName);
	}
	
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="itemMenuID" name="itemMenuID" >
	<div class="child_search">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcMenu()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteArcMenu()"></span>
			</c:if>
		</li>		
	</div>
	</form>
	<div id="gridDiv" class="mgT10">
		<div id="grdGridArea" style="height:130px; width:100%"></div>
	</div>
	
<div class="mgT10">
	<table id="newArcMenu" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="20%">
		    <col width="20%">
		    <col width="10%">
		 	<col width="30%">
		 	<col width="10%">
		</colgroup>
		<tr>
			<th class="viewtop last">Menu</th>
			<th class="viewtop last">Menu name</th>
			<th class="viewtop last">Menu type</th>
			<th class="viewtop last">VarFilter</th>
			<th class="viewtop last">Sort No.</th>
		</tr>
		<tr>
			<td class="last"><input type="text" id="menuId" name="menuId" OnClick="fnOpenMenuListPop()" class="text" ></td>
			<td class="last"><select id="dicCode" name="dicCode"  OnChange="fnGetDicCode()" class="sel" ></select></td>
			<td class="last">
				<select id="menuType" name="menuType" class="sel">
					<option value="">Select</option>
					<option value="M">Main</option>
					<option value="S">Sub</option>
					<option value="P">Post</option>
				</select>
			</td>
			<td class="last"><input type="text" id="varFilter" name="varFilter"  class="text"  value=""/></td>
			<td class="last"><input type="number" style="text-align:center;" id="sortNum" name="sortNum"  class="text"  value=""/></td>
		</tr>
		
	</table>
	</div>
	
	<div  class="alignBTN" id="divSaveArcMenu" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveMenu()"  type="submit"></span>
		</c:if>		
	</div>	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>