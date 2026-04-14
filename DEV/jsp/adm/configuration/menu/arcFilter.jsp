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
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
			// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 320)+"px;"+"margin-bottom:5%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 320)+"px;"+"margin-bottom:5%;");
		};
		
		var data = "&LanguageID=${languageID}";
		fnSelect('conTypeCode', data, 'conTypeCode', '', 'Select'); 
		
	});	
	
	function fnAddArcFilter(){
		$("#newArcFilter").attr('style', 'display: block');	
		$("#newArcFilter").attr('style', 'width: 100%');	
		$("#divSaveArcFilter").attr('style', 'display: block');	
	}
	
 	function fnDeleteArcFilter(){
		var selectedCell = grid.data.findAll(function (data){
			return data.checkbox;
		});
		if(!selectedCell.length){
			alert("${WM00023}");
			return;
		}else{	
				var conTypeCodeArr = new Array;
				var rootItemIDArr = new Array;
				for(idx in selectedCell){
					conTypeCodeArr[idx] = selectedCell[idx].ConTypeCode;
					rootItemIDArr[idx] = selectedCell[idx].RootItemID;
				}
							
		}
		if(confirm("${CM00004}")){
			var url = "deleteArcFilter.do";
			var data = "&arcCode=${ArcCode}&conTypeCode="+conTypeCodeArr+"&rootItemID="+rootItemIDArr;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}

	}
 	
	function fnGetTreePop(){
		var url = "searchRootItemTreePop.do";
		var conTypeCode = $("#conTypeCode").val();
		var data = "LanguageID=${languageID}&ArcCode=${ArcCode}&conTypeCode="+conTypeCode;
		
		fnOpenLayerPopup(url,data,doCallBackMove,617,436);
	}
	
	function doCallBackMove(){}
	
	function fnSaveArcFilter(){
		if(confirm("${CM00012}")){
			var rootItemId = $("#rootItemID").val();
			var conTypeCode = $("#conTypeCode").val();
			
			var url = "saveArcFilter.do";
			var data = "rootItemId=" + rootItemId + "&conTypeCode="+conTypeCode+"&arcCode=${ArcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
</script>
</head>
<body>
	<form name="arcFilterFrm" id="arcFilterFrm" action="*" method="post" onsubmit="return false;" class="mgL10 mgR10">
<!-- 	<div class="cfgtitle"> -->
<!-- 		<ul> -->
<%-- 			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Filter</li> --%>
<!-- 		</ul> -->
<!-- 	</div> -->
	<div class="floatR pdR10 mgB7">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
<!-- 				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		 -->
			
			<button class="cmm-btn mgR5 mgT10 floatR" style="height: 30px;"  onclick="fnDeleteArcFilter()" value="Del">Delete</button>
			<button class="cmm-btn mgR5 mgT10 floatR" style="height: 30px;"  onclick="fnAddArcFilter()" value="Add">Add Filter</button>
			
		</c:if>
	</div>
		
	<div id="gridDiv" class="mgT10">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	
     <div class="mgT10">
	<table id="newArcFilter" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">ConTypeCode</th>
			<th class="viewtop last">RootItem</th>
		</tr>
		<tr>
			<td class="last"><select id="conTypeCode" name="conTypeCode" class="sel" ></select></td>
			<td class="last">
				<input type="text" class="text" id="rootItemName" name="rootItemName" OnClick="fnGetTreePop()" />
				<input type="hidden" class="text" id="rootItemID" name="rootItemID" />
			</td>
		</tr>
	</table>
    </div>
    
	<div class="alignBTN" id="divSaveArcFilter" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveArcFilter()"  type="submit"></span>
		</c:if>		
	</div>	
	</form>
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	
<script type = "text/javascript">	
	var layout = new dhx.Layout("grdGridArea", {
		rows : [ {
			id : "a",
		}, ]
	});	


	var gridData = ${gridData};
	var grid = new dhx.Grid("grdGridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 150, id: "ConTypeCode", header: [{ text: "ConType Code" , align: "center" }], align: "center" },
	        { fillspace: true, id: "ConTypeName", header: [{ text: "ConType Name", align: "center" }], align: "center" },
	        { width: 150, id: "RootItemID", header: [{ text: "Root Item ID", align: "center" }], align: "center" },
	        { fillspace: true, id: "RootItemName", header: [{ text: "Root Item Name", align: "center" }], align: "center" }

	       
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	
	
	function fnCallBack(){ 
		$("#newArcFilter").attr('style', 'display: none');	
		$("#divSaveArcFilter").attr('style', 'display: none');	
			
		var sqlID = "config_SQL.getArcFilterList";		
		var param = "ArcCode=${ArcCode}&LanguageID=${languageID}"
		           +"&sqlID="+sqlID;
		           
		   	$.ajax({
					url:"jsonDhtmlxListV7.do",
					type:"POST",
					data:param,
					success: function(result){
						console.log("result: "+result);
						fnReloadGrid(result);				
					},error:function(xhr,status,error){
						console.log("ERR :["+xhr.status+"]"+error);
					}
				});	
	}
	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 	}
	</script>
	
	
</body>
</html>