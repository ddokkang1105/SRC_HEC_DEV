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
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "procConfig_SQL.getAllocateItemWF";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},Status,${menu.LN00070},${menu.LN00105}";
		result.cols = "CHK|WFID|Name|Status|LastUpdate|LastUser"; 
		result.widths = "50,30,120,200,80,120,120"; 
		result.sorting = "int,int,str,str,str,str,str,str"; 
		result.aligns = "center,center,center,left,center,center,center"; 
		result.data = "languageID=${languageID}&s_itemID=${s_itemID}";
		return result;
	}
	
	function fnAddArcMenu(){
		viewType = "N";
		$("#newWFMenu").attr('style', 'display: block');	
		$("#newWFMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');	
		
		$("#name").text("");
		$("#WFID").val("");
		$("#status").val("");
		
	}
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		$("#newWFMenu").attr('style', 'display: block');	
		$("#newWFMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');
		
		viewType = "E";
		$("#old_WFID").val(p_gridArea.cells(id,2).getValue());
		$("#WFID").val(p_gridArea.cells(id,2).getValue());
		$("#name").text(p_gridArea.cells(id,3).getValue());
		$("#status").val(p_gridArea.cells(id,4).getValue());
		
	}
	
	function fnSaveArcMenu(){
		if(confirm("${CM00012}")){
			var old_WFID = $("#old_WFID").val();
			var WFID = $("#WFID").val();
			var status = $("#status").val();

			var url = "pim_SaveAllocItemWF.do";
			var data = "&old_WFID="+old_WFID + "&WFID="+WFID + "&s_itemID=${s_itemID}"
					+"&status="+status + "&viewType=" + viewType;
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#newWFMenu").attr('style', 'display: none');	
		$("#divSaveArcMenu").attr('style', 'display: none');
		
		$("#name").text("");
		$("#old_WFID").val("");
		$("#WFID").val("");
		$("#status").val("");

		gridOTInit();
		doOTSearchList();
		
	}
	
	function fnDeleteArcMenu(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var WFID = new Array;
	
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				WFID[j]= p_gridArea.cells2(i,2).getValue();
				j++;
			}
		}

		if(confirm("${CM00004}")){
			var url = "pim_DeleteAllocItemWF.do";
			var data = "&WFID="+WFID + "&s_itemID=${s_itemID}";
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnOpenWFListPop(){
		var url = "pim_AddAllocItemWFPop.do?languageID=${languageID}&s_itemID=${s_itemID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(WFID, Name){
		$("#WFID").val(WFID);
		$("#name").text(Name);
	}
	
</script>
</head>
<body>
	<form action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="old_WFID" name="old_WFID" >
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
	<table id="newWFMenu" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="33%">
		    <col width="33%">
		    <col width="33%">
		</colgroup>
		<tr>
			<th class="viewtop last">${menu.LN00015}</th>
			<th class="viewtop last">${menu.LN00028}</th>
			<th class="viewtop last">Status</th>
		</tr>
		<tr>
			<td class="last"><input type="text" id="WFID" name="WFID" OnClick="fnOpenWFListPop()" class="text" ></td>
			<td class="last"><span id="name"></span></td>
			<td class="last"><input type="text" id="status" name="status"  class="text"  value=""/></td>
		</tr>
		
	</table>
	</div>
	
	<div  class="alignBTN" id="divSaveArcMenu" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveArcMenu()"  type="submit"></span>
		</c:if>		
	</div>	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>