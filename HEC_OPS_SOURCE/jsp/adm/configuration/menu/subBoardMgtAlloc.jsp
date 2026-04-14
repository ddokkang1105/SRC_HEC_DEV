<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
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
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ARC}/");
		p_gridArea.setColumnHidden(4, true);
		p_gridArea.setColumnHidden(5, true);
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}

	function setOTGridData(){ 
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getBoardMgtAlloc";
		result.header = "${menu.LN00024},#master_checkbox,Code,Name,TemplCode,TemplName,Sort No";
		result.cols = "CHK|BoardMgtID|BoardMgtName|TemplCode|TemplName|SortNum";
		result.widths = "50,50,80,200,80,200,80";
		result.sorting = "int,int,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode=${templCode}";
		return result;
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
		$("#sortNum").val(p_gridArea.cells(id,6).getValue());
		$("#sortNum").focus();
		$("#boardMgtID").val(p_gridArea.cells(id,2).getValue());
	}
	
	function fnGoBack(){
		var url = "defineTemplateView.do";
		var target = "tempListDiv";
		var data = "&templCode=${templCode}&languageID=${languageID}" 
					+"&pageNum=${pageNum}&viewType=${viewType}";
		
		ajaxPage(url,data,target);
	}
	
	function fnOpenBoardMgtPop(){
		var url = "openBoardMgtPop.do?templCode=${templCode}";
		var option = "width=700,height=500,left=400,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function fnDeletBoardMgtAlloc(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}else{
			if(confirm("${CM00004}")){
				var boardMgtID = new Array();
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var j = 0;
				for ( var i = 0; i < checkedRows.length; i++) {
					boardMgtID[j] = p_gridArea.cells(checkedRows[i],2).getValue(); 
					j++;
				}
				var url = "deleteBoardMgtAlloc.do";
				var data = "&boardMgtID="+boardMgtID+"&templCode=${templCode}";
				var target = "subFrame";
				ajaxPage(url, data, target); 
			}
		}
	}
	
	function fnSaveStNum(){
		if(confirm("${CM00001}")){
			var sortNum = $("#sortNum").val();
			var boardMgtID = $("#boardMgtID").val();
			var url = "updateBoardMgtAllocStNum.do";
			var data = "&boardMgtID="+boardMgtID+"&templCode=${templCode}&sortNum="+sortNum; 
			var target = "subFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveStNum").attr('style', 'display: none');
		$("#sortNum").val("");
		$("#boardMgtID").val("");
		
		gridOTInit();
		doOTSearchList();
	}
	
</script>
<body>
<form name="AddClassTypeList" id="AddClassTypeList"	action="*" method="post" onsubmit="return false;">
	<div class="child_search mgL10 mgR10">
		<div class="floatR pdR20 pdB10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnOpenBoardMgtPop()" ></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeletBoardMgtAlloc()" ></span>
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
			</c:if>
		</div>	
	</div>
</form>
	<div class="countList">
          <li class="count">Total <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
    </div>	
	<div id="gridDiv" class="mgB10 mgL10 mgR10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	
	<div class="mgT5 mgL10 mgR10">
	<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="boardMgtID" name="boardMgtID" >
			</td>
		</tr>
	</table>
    </div>
	<div  class="alignBTN" id="divSaveStNum" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveStNum()"  type="submit"></span>
		</c:if>		
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="subFrame" id="subFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>

</html>