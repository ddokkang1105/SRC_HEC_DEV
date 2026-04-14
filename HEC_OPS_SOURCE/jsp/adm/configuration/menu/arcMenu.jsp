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
		var data = "&LanguageID=${languageID}&category=LN";
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select'); 
		fnSelect('classCode', data, 'classCode', '', 'Select');
		fnSelect('itemTypeCode', '', 'itemTypeCode', '${itemTypeCode}', 'Select'); 
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select');
		
		if("${classCode}" != null){
			data += "&itemTypeCode=${itemTypeCode}";		
			fnSelect('searchValue', data, 'classCode', '${classCode}', 'Select');
		}
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		};
		
	});	
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		//p_gridArea.setColumnHidden(6, true);
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		//p_gridArea.setColumnHidden(13, true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcMenuAlloc";
		result.header = "${menu.LN00024},#master_checkbox,ObjectName,ClassName,MenuId,MenuName,Alias,Sort,ClassCode,VarFilter,Screen URL,DicCode,itemTypeCode,Seq,HideOption";
		result.cols = "CHK|ItemTypeName|ClassName|MenuID|MenuName|Alias|Sort|ClassCode|VarFilter|ScrURL|DicCode|ItemTypeCode|Seq|HideOption"; 
		result.widths = "50,30,130,130,80,150,150,80,80,120,120,80,80,80,80,80"; 
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str"; 
		result.aligns = "center,center,left,left,center,left,left,center,center,left,left,left,left,left,center,center"; 
		result.data = "arcCode=${arcCode}&languageId=${languageID}";
		if($("#itemTypeCode").val() != null){
			result.data = result.data +"&itemTypeCode="+$("#itemTypeCode").val();			
		} else if("${itemTypeCode}" != null){
			result.data = result.data +"&itemTypeCode=${itemTypeCode}";
		}
		if($("#searchValue").val() != null){
			result.data = result.data +"&searchValue="+$("#searchValue").val();			
		} else if("${classCode}" != null){
			result.data = result.data +"&searchValue=${classCode}";
		}		
		return result;
	}
	
	function fnAddArcMenu(){
		viewType = "N";
		$("#viewType").val(viewType);
		$("#newArcMenu").attr('style', 'display: block');	
		$("#newArcMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');	
		
		$("#menuName").val("");
		$("#menuId").val("");
		$("#sortNum").val("");
		$("#varFilter").val("");
		$("#seq").val("");
		
		var data = "&LanguageID=${languageID}";
		fnSelect('classCode', data, 'classCode', '', 'Select');
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select');
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select'); 
		$("#hideOption").attr('checked',false);
		
	}
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		viewType = "E";
		$("#viewType").val(viewType);
		$("#hideOption").val("");
		$("#newArcMenu").attr('style', 'display: block');	
		$("#newArcMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');
		
		$("#objTypeCode").val(p_gridArea.cells(id, 12).getValue());
		$("#classCode").val(p_gridArea.cells(id, 8).getValue());
		$("#menuName").val(p_gridArea.cells(id, 5).getValue());
		$("#dicCode").val(p_gridArea.cells(id, 11).getValue());
		$("#varFilter").val(p_gridArea.cells(id, 9).getValue().replace(/&amp;/g,"&"));
		$("#scrURL").val(p_gridArea.cells(id, 10).getValue());
		$("#sortNum").val(p_gridArea.cells(id, 7).getValue());
		$("#seq").val(p_gridArea.cells(id, 13).getValue());
		$("#menuId").val(p_gridArea.cells(id, 4).getValue());
		if(p_gridArea.cells(id, 14).getValue()=='Y'){
			$("#hideOption").attr('checked',true);
		}else{
			$("#hideOption").attr('checked',false);
		}
	}
	
	function fnSaveArcMenu(){
		if($("#hideOption").is(":checked") == true){
			$("#hideOption").val("Y");
		}else{
			$("#hideOption").val("N");
		}
		
		if(confirm("${CM00012}")){		
			var url = "saveArcMenu.do";
			ajaxSubmit(document.SubAttrTypeList, url, "ArcFrame");
		}
	}
	
	function fnCallBack(){ 
		$("#newArcMenu").attr('style', 'display: none');	
		$("#divSaveArcMenu").attr('style', 'display: none');
		
		$("#menuName").val("");
		$("#menuId").val("");
		$("#sortNum").val("");
		$("#seq").val("");
		
		var data = "&LanguageID=${languageID}";
		fnSelect('classCode', data, 'classCode', '', 'Select');
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select');
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select'); 
		
		gridOTInit();
		doOTSearchList();
		
	}
	
	function fnDeleteArcMenu(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var seq = new Array;
	
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				seq[j]= p_gridArea.cells2(i, 13).getValue();
				j++;
			}
		}

		if(confirm("${CM00004}")){
			var url = "deleteArcMenu.do";
			var data = "&seq="+seq;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnOpenMenuListPop(){
		var url = "menuListPop.do?languageID=${languageID}";
		var w = 500;
		var h = 445;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		$("#menuId").val(menuId);
		$("#menuName").val(menuName);
	}
	
	function fnGetClassCode(){		
		var itemTypeCode = $("#objTypeCode").val();
		var data = "&LanguageID=${languageID}&itemTypeCode="+itemTypeCode;		
		fnSelect('classCode', data, 'classCode', '', 'Select');
	}
	
	function fnGetSearchClassCode(){		
		var itemTypeCode = $("#itemTypeCode").val();
		var data = "&LanguageID=${languageID}&itemTypeCode="+itemTypeCode;		
		fnSelect('searchValue', data, 'classCode', '', 'Select');
	}
	
	function fnReload(){
		var itemTypeCode = $("#itemTypeCode").val();
		var classCode = $("#searchValue").val();
		var url = "arcMenu.do"
		var data = "&languageID=${languageID}&ArcCode=${arcCode}&itemTypeCode="+itemTypeCode+"&classCode="+classCode;
		var target = "arcFrame";
		ajaxPage(url, data, target);
	}
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="seq" name="seq" >
	<input type="hidden" id="viewType" name="viewType" value="">
	<input type="hidden" id="arcCode" name="arcCode" value="${arcCode }">
	<input type="hidden" id="languageID" name="languageID" value="${languageID }">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Menu</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="pdL55">
			${menu.LN00021} <select id="itemTypeCode" name="itemTypeCode" OnChange="fnGetSearchClassCode()"></select>
			${menu.LN00016} <select id="searchValue" name="searchValue"></select>						
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doOTSearchList()" value="검색">
		</li>		
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcMenu()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteArcMenu()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10 mgL10 mgR10">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	
<div class="mgT10 mgL10 mgR10">
	<table id="newArcMenu" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="25%">
		    <col width="25%">
		 	<col width="25%">
		 	<col width="25%">		 
		</colgroup>
		<tr>
			<th class="viewtop last">Item Type</th>
			<th class="viewtop last">Item Class</th>
			<th class="viewtop last">Sort No.</th>
			<th class="viewtop last">Hide Option</th>
		
		</tr>
		<tr>
			<td class="last"><select id="objTypeCode" name="objTypeCode"  OnChange="fnGetClassCode()" class="sel" ></select></td>
			<td class="last"><select id="classCode" name="classCode" class="sel" ></select></td>
			<td class="last"><input type="text" id="sortNum" name="sortNum"  class="text"  value=""/></td>
			<td class="last"><input type="checkbox" id="hideOption" name="hideOption" value="" /></td>
			
		</tr>
		<tr>
			<th class="last">Menu</th>
			<th class="last">Menu name</th>
			<th class="last">Variable</th>
			<th class="last">Screen URL</th>
			
		</tr>
		<tr>
			<td class="last"><input type="text" id="menuId" name="menuId" OnClick="fnOpenMenuListPop()" class="text" ></td>
			<td class="last"><select id="dicCode" name="dicCode"  OnChange="fnGetDicCode()" class="sel" ></select></td>
			<td class="last"><input type="text" id="varFilter" name="varFilter"  class="text"  value=""/></td>
			<td class="last"><input type="text" id="scrURL" name="scrURL"  class="text"  value=""/></td>
	
		</tr>
	</table>
	<div  class="alignBTN" id="divSaveArcMenu" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveArcMenu()"  type="submit"></span>
		</c:if>		
	</div>	
	
	</div>
	</form>
	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>