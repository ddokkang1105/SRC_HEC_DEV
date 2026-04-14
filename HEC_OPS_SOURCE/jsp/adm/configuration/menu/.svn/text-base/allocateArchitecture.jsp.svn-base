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

<!-- 2. Script -->
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		//Grid 초기화
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
		result.key = "config_SQL.getAllocatedArchitectureList";
		result.header = "${menu.LN00024},#master_checkbox,SortNum,ArcCode,ArcName,Style,Icon";
		result.cols = "CHK|SortNum|ArcCode|ArcName|Style|Icon";
		result.widths = "50,50,60,80,200,180,120";
		result.sorting = "int,int,str,str,str,str,str,str"; 
		result.aligns = "center,center,center,center,center,center,left";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}";
		return result;
	}
	
	function fnAddArc(){
		var url = "addArcListPop.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}";
		var w = 700;
		var h = 700;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		
	}
	
	function fnDeleteArc(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var arcArr = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				arcArr[j]= p_gridArea.cells2(i, 3).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteParentArc.do";
			var data = "&arcCode="+arcArr;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
			
	//조회
	function doOTSearchList(){ 
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){ 
		$("#editStNum").attr('style', 'display: block');	
		$("#editStNum").attr('style', 'width: 100%');	
		$("#divSaveStNum").attr('style', 'display: block');	
		$("#sortNum").val(p_gridArea.cells(id,2).getValue());
		$("#sortNum").focus();
		$("#arcCode").val(p_gridArea.cells(id,3).getValue());
	}
	
	function fnGoBack(){
		var url = "architectureView.do";
		var target = "ArchitecturDetail";
		var data = "&ArcCode=${ArcCode}&pageNum=${pageNum}&languageID=${languageID}&viewType=${viewType}";		
		ajaxPage(url,data,target);
	}
	
	function fnSaveStNum(){
		if(confirm("${CM00001}")){
			var sortNum = $("#sortNum").val();
			var arcCode = $("#arcCode").val();
			var url = "updateArcStNum.do";
			var data = "&arcCode="+arcCode+"&sortNum="+sortNum; 
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveStNum").attr('style', 'display: none');
		$("#sortNum").val("");
		$("#arcCode").val("");
		
		gridOTInit();
		doOTSearchList();
	}

	
</script>
</head>
<body>
	<form name="AllocArcList" id="AllocArcList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Allocation</li>
		</ul>
	</div>
	<div class="child_search">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArc()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteArc()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10 clear">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="arcCode" name="arcCode" >
			</td>
		</tr>
	</table>
	<div  class="alignBTN" id="divSaveStNum" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveStNum()"  type="submit"></span>
		</c:if>		
	</div>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>