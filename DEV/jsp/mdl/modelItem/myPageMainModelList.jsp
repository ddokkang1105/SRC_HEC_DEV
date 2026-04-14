<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00112" var="WM00112"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>

<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	
	$(document).ready(function(){		
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		};		
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		$('#searchKey').change(function(){
			//$('input:text[id^=search]').each(function(){$(this).hide();});
			if($(this).val() != ''){$('#search' + $(this).val()).show();}
		});
		
		fnSelect('mtCategory', '', 'MTCTypeCode', '', 'Select');
		fnSelect('modelType', '', 'getMDLTypeCode', '', 'Select'); 
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>
</head>
<body>
	<form name="taskResultFrm" id="taskResultFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${menu.LN00058}	</h3>
	</div><div style="height:10px"></div>
	<div class="child_search">
		<li>
			${menu.LN00033}
	 	 	<select id="mtCategory" name="mtCategory" class="sel" style="width:150px;"></select>			
	   	</li>
		<li>
			${menu.LN00032}
	 	 	<select id="modelType" name="modelType" class="sel" style="width:150px;"></select>			
	   	</li>
	   	<li>
	 	 	<select id="searchKey" name="searchKey">
				<option value="Name">Name</option>
				<option value="ID" <c:if test="${!empty searchID}"> selected="selected" </c:if> >ID</option>
			</select>			
			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnReload()" value="검색">
	   	</li>
	</div>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
     </div>
   	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	     
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
			// 1
	        { width: 80, id: "ModelID", header: [{ text: "${menu.LN00015}", align:"center" }], align: "center"},
	        { width: 700, id: "Name", header: [{ text: "${menu.LN00028}", align:"center" }], align: "left"},
	        { width: 130, id: "ModelTypeName", header: [{text: "${menu.LN00032}", align:"center"}], align: "center"},
	        { width: 100, id: "MTCName", header: [{text: "${menu.LN00033}", align:"center"}], align: "center"},
	        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center"},	
	        { width: 80, id: "Creator", header: [{ text: "${menu.LN00004}", align:"center"}], align:"center", hidden : true},
	        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00013}", align:"center" }], align:"center", hidden : true},
	        { width: 150, id: "UserName", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center"},
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 70, id: "ItemID", header: [{ text: "ItemID", align:"center" }], align:"center", hidden : true},
	        { width: 80, id: "BtnControl", header: [{ text: "${menu.LN00125}", align:"center" }], htmlEnable: true, align:"center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/' + row.BtnControl + '"  border="0" style="max-height:27px" title="btn_gedit.png">';
	            }	        	
	        },
	        /* 13 */ { width: 70, id: "Blocked", header: [{ text: "Blocked", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "MTCategory", header: [{ text: "${menu.LN00031}", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "StatusCode", header: [{ text: "${menu.LN00031}", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "IsPublic", header: [{ text: "IsPublic", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "ItemAuthorID", header: [{ text: "ItemAuthorID", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "ItemBlocked", header: [{ text: "ItemBlocked", align:"center" }], align:"center", hidden : true},
	        { width: 70, id: "ItemStatus", header: [{ text: "ItemStatus", align:"center" }], align:"center", hidden : true},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());

 	grid.events.on("cellClick", function(row,column,e){
		var modelBlocked = row.Blocked;
		var modelId = row.ModelID;
		var itemId = row.ItemID;
		var MTCategory = row.MTCategory;
		var ModelStatus= row.StatusName;
		var Creator	= row.Creator;
		var CreationTime = row.CreationTime;
		var UserName = row.UserName;
		var LastUpdated = row.LastUpdated;
		var modelName = row.ModelTypeName;
		var ModelStatusCode = row.StatusCode;
		var ModelTypeName = row.ModelTypeName;
		var ModelIsPublic = row.IsPublic;
		var itemBlocked = row.ItemBlocked;
		var itemAthId = row.ItemAuthorID;
		var selectedItemStatus = row.ItemStatus;
 		
		if(column.id != "BtnControl"){
 			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ItemID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		} else {
			if(MTCategory == "VER" || itemBlocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
				var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&scrnType=view&MTCategory="+MTCategory+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
				var w = 1200;
				var h = 900;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}else{	
				if(ModelIsPublic == 1){
					var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&blocked="+itemBlocked+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName+"&scrnType=model";
					var w = 1200;
					var h = 900;
					window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
				} else{
					if(itemAthId == userId && modelBlocked == "0" || '${sessionScope.loginInfo.sessionMlvl}' == "SYS"){
						var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&blocked="+itemBlocked+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName+"&scrnType=model";
						var w = 1200;
						var h = 900;
						window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
					} else{
						 var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&scrnType=view&MTCategory="+MTCategory+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
						 var w = 1200;
						 var h = 900;
						 window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
					}
				}
				
			}

		}
		
	 });
	
	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	 
 	function fnReload(){ 
		var sqlID = "model_SQL.getModelList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	        + "&searchKey=" + $("#searchKey").val()
	        + "&searchValue=" + $("#searchValue").val()
			+ "&screenType=${screenType}"
			+ "&modelTypeCode=" + $("#modelType").val()
			+ "&MTCategory=" + $("#mtCategory").val()
			+ "&sqlID="+sqlID;
	        
	        
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}	 

</script>	

</body></html>