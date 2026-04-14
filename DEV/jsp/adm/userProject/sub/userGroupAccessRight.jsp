<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 그릅 Templet(AcessRight) 연동 관리  -->
<!-- 
	@RequestMapping(value="/userGroupAccessRight.do")
	* user_SQL.xml - userGroupAccessRight_gridList
	* Action
	  - Save  :: setUserGroupAccessRight.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00018" var="CM00018"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">
$(document).ready(function() {
	// SKON CSRF 보안 조치
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			}
	})	
})

	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 50, id: "CHK", header: [{ text: "선택" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	    	{ width: 150, id: "TemplCode", header: [{ text: "TemplateID", align: "center" } ], align: "center" },
	        { width: 200, id: "TemplName", header: [{ text: "선택", align: "center" } ], align: "left" },
	        { hidden : true, id: "ArcID", header: [{ text: "ArcID", align: "center" } ], align: "center" },
	        { hidden : true, id: "ArcName", header: [{ text: "ArcName", align: "center" } ], align: "center" },
	        { hidden : true, id: "SetProject", header: [{ text: "E-SetProject", align: "center" } ], align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);
	
	//조회
	function doSearchList(){
		var sqlID = "user_SQL.userGroupAccessRight";
		var param =  "memberID=${s_itemID}"				
	        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"	
	        + "&userType=2"
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
 	}
	
	//Asign
	function setGroupAccessRight(){
		
		var url = "admin/setUserGroupAccessRight.do";
		var data = "memberID=${s_itemID}";
		var target = "blankFrame";
		var selectedCell = grid.data.findAll(function (data) {
	        return data.CHK;
		});
		if(!selectedCell.length){
			//if(confirm("그릅에 할당 된 Templet이 없습니다. \n기존에 할당 되었던 Templet은 모두 지워 집니다.")){
			if(confirm("${CM00018}")){
				//alert(data);
				ajaxPage(url, data, target);
			}
		}else{
			//if(confirm("저장 하시겠습니까?")){
			if(confirm("${CM00001}")){	
				var items = selectedCell.map(function(cell) {
			    	return cell.TemplCode;
				}).join(",");
				data = data + "&items="+items;
				//alert(data);
				ajaxPage(url, data, target);
			}
		}
	}	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
<!-- 
	<select id="getCode" name="getCode" onchange="doSearchList()"></select>
 -->
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setGroupAccessRight()"></span>	
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->