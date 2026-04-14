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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">	
	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		var data = "&LanguageID=${languageID}&category=LN";
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select'); 
		fnSelect('classCode', data, 'classCode', '', 'Select');
		fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select');
				
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 330)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 330)+"px;");
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
		document.querySelector("#hideOption").checked = false;
	}
	
	function fnSaveArcMenu(){
		if($("#hideOption").is(":checked") == true){
			$("#hideOption").val("Y");
		}else{
			$("#hideOption").val("N");
		}
		
		if(confirm("${CM00012}")){		
			var url = "admin/saveArcMenu.do";
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
		
		fnReload();
		
	}
	
	function fnDeleteArcMenu(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		} else {
			if (confirm("${CM00004}")) {
				var seq = "";
				for(idx in selectedCell){
				    if (seq == "") {
				    	seq = selectedCell[idx].Seq;
					} else {
						seq += ","+selectedCell[idx].Seq;
					}
				};

				if(confirm("${CM00004}")){
					var url = "admin/deleteArcMenu.do";
					var data = "&seq="+seq;
					var target = "ArcFrame";
					ajaxPage(url, data, target);	
				}
			}
		}
	}
	
	function fnOpenMenuListPop(){
		var url = "menuListPop.do?languageID=${languageID}";
		var w = 700;
		var h = 550;
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
	
	function fnReload() {
		$('#isSubmit').remove();
		$.ajax({
			url: "getArcMenuList.do",
			data:"&languageID=${languageID}&ArcCode=${arcCode}",
			type:"POST",
			cotentType:"application/json",
			success: function(result){
				if(grid != ""){
					grid.data.parse(result);
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;" class="mgL10 mgR10">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<input type="hidden" id="seq" name="seq" >
	<input type="hidden" id="viewType" name="viewType" value="">
	<input type="hidden" id="arcCode" name="arcCode" value="${arcCode }">
	<input type="hidden" id="languageID" name="languageID" value="${languageID }">
	<div class="child_search01 mgL10 mgR10">		
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
<!-- 				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		 -->
				<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnAddArcMenu()" value="Add">Add Menu</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDeleteArcMenu()" value="Del">Delete</button>
			</c:if>
		</li>		
	</div>
	<div id="layout" style="width:100%;"></div>
	
<div class="mgT10">
	<table id="newArcMenu" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none; padding-top: 30px;">
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
			<td class="last"><select id="dicCode" name="dicCode" class="sel" ></select></td>
			<td class="last"><input type="text" id="varFilter" name="varFilter"  class="text"  value=""/></td>
			<td class="last"><input type="text" id="scrURL" name="scrURL"  class="text"  value=""/></td>
	
		</tr>
	</table>
	<div  class="alignBTN" id="divSaveArcMenu" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn2 mgR5 mgB10" style="height: 30px;" onclick="fnSaveArcMenu()" value="Save">Save</button>
		</c:if>		
	</div>	
	
	</div>
	</form>
	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
		
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center"}], align: "center", editable: false },
	        { width: 50, id: "checkbox", type: "boolean", header: [{ text: "", align:"center" }], editable: true },
	        { width: 150, id: "ItemTypeName", header: [{ text: "Object Name", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 150, id: "ClassName", header: [{ text: "Class Name", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 100, id: "MenuID", header: [{ text: "Menu ID", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { fillspace: true, id: "MenuName", header: [{ text: "Menu Name", align: "center" }, { content: "inputFilter" }] },
	        { width: 150, id: "Alias", header: [{ text: "Alias", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 100, id: "Sort", header: [{ text: "Sort", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { fillspace: true, id: "VarFilter", header: [{ text: "Var Filter", align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 100, id: "HideOption", header: [{ text: "Hide Option", align: "center" }, { content: "selectFilter" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);

	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			gridOnRowOTSelect(row);
		}
	}); 
	
	//그리드ROW선택시
	function gridOnRowOTSelect(row){
		viewType = "E";
		$("#viewType").val(viewType);
		$("#hideOption").val("");
		$("#newArcMenu").attr('style', 'display: block');	
		$("#newArcMenu").attr('style', 'width: 100%');	
		$("#divSaveArcMenu").attr('style', 'display: block');
		
		$("#objTypeCode").val(row.ItemTypeCode);
		$("#classCode").val(row.ClassCode);
		$("#dicCode").val(row.DicCode);
		$("#varFilter").val(row.VarFilter);
		$("#scrURL").val(row.ScrURL);
		$("#sortNum").val(row.Sort);
		$("#seq").val(row.Seq);
		$("#menuId").val(row.MenuID);
		if(row.HideOption=='Y'){
			document.querySelector("#hideOption").checked = true;
		}else{
			document.querySelector("#hideOption").checked = false;
		}
	}

	</script>
</body>
</html>