<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
 
<script type="text/javascript">
	var gridArea;

	$(document).ready(function(){
		$("#grdElmArea").attr("style","height:"+(setWindowHeight() - 50)+"px;");
		window.onresize = function() {
			$("#grdElmArea").attr("style","height:"+(setWindowHeight() - 50)+"px;");
		};
		
		setElmGridList();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setElmGridList(){
		var treePData="${elmTreeXml}";
	    gridArea = new dhtmlXGridObject('grdElmArea');
	    gridArea.selMultiRows = true;
	    gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
	    gridArea.setImagePath("${root}${HTML_IMG_DIR_ITEM}/");
	    gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		gridArea.setHeader("#master_checkbox,${menu.LN00028},${menu.LN00043},Link,CxnItemID,LinkURL,LovCode,AttrTypeCode,ActivityID,ParentID,roleID,${menu.LN00119}");
		gridArea.setInitWidths("50,300,*,60,50,50,50,50,50,50,50,150");
		gridArea.setColAlign("center,left,left,center,left,left,left,left,left,left,left,left");
		gridArea.setColTypes("ch,tree,ro,img,ro,ro,ro,ro,ro,ro,ro,ro");
		gridArea.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str");
   	  	gridArea.init();
		gridArea.setSkin("dhx_web");
		gridArea.attachEvent("onCheck", function(rId,cInd,state){gridOnCheck(rId,cInd,state);});
		gridArea.loadXMLString(treePData);
		gridArea.setColumnHidden(3, true);
		gridArea.setColumnHidden(4, true);
		gridArea.setColumnHidden(5, true);
		gridArea.setColumnHidden(6, true);
		gridArea.setColumnHidden(7, true);
		gridArea.setColumnHidden(8, true);
		gridArea.setColumnHidden(9, true);
		gridArea.setColumnHidden(10, true);
		gridArea.enableTreeCellEdit(false);
		gridArea.checkAll(false);
	}
	
	function gridOnCheck(rId,cInd,state){
		var activityID=gridArea.cells(rId, 8).getValue();
		if(activityID==""){
			gridArea.cells(rId,0).setValue(0);
		}
	}
		
	function fnAddElements(){
		if(gridArea.getCheckedRows(0).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = gridArea.getCheckedRows(0).split(",");	
				var elementID = new Array();
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var programID =  gridArea.cells(checkedRows[i], 4).getValue();
					var activityID =  gridArea.cells(checkedRows[i], 8).getValue();
					var parentID =  gridArea.cells(checkedRows[i], 9).getValue();
					var roleID =  gridArea.cells(checkedRows[i], 10).getValue();
					if(roleID == "") roleID = 0;
					if(activityID){
						elementID.push(programID+"_"+activityID+"_"+parentID+"_"+roleID);
					}
				}

				$("#checkElmts").val(elementID);
				var url = "createTestObject.do";
				ajaxSubmit(document.procInstFrm, url, "saveFrame");
			}
		} 
	}
	
	function fnCallBackSubmit() {
		opener.fnReload();
		self.close();
	}
	
	function fnSearch(){
		var searchValue = $("#searchValue").val();
		var url = "selectElmInstTree.do";
		var data = "modelID=${modelID}&instanceNo=${instanceNo}&processID=${processID}&searchValue="+searchValue;
		var target = "processDIV";
		ajaxPage(url,data,target);
	}
</script>
<style type="text/css">
	div.gridbox_dhx_web.gridbox .odd_dhx_web {background:none;}
	div.gridbox_dhx_web.gridbox table.obj tr.rowselected {background:none;}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr.rowselected td {background:none;}
</style>
</head>
<body>
<div id="processDIV">
<form name="procInstFrm" id="procInstFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="checkElmts" name="checkElmts"  value="" />
	<input type="hidden" id="modelList" name="modelList"  value="${modelID }" />
	<input type="hidden" id="instanceNo" name="instanceNo"  value="${instanceNo }" />
	<div class="child_search_head mgT5">
		<p class="floatL"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Copy Activities</p>
		 <p class="floatR pdR20">
<!-- 			<select id="searchKey" name="searchKey" style="width:85px;"> -->
<!-- 				<option value="Name">Role Name</option> -->
<!-- 			</select>			 -->
<%-- 			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:130px;"> --%>
<%-- 			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearch()" value="Search"> --%>
			<span class="btn_pack medium icon"><span class="add"></span><input value="Copy" onclick="fnAddElements()" type="button"></span>
		 </p>
	</div>
	<div id="gridPtgDiv" class="mgB5 mgT10">
		<div id="grdElmArea" style="width:100%;"></div>
	</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>