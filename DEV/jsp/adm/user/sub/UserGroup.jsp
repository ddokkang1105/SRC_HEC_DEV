<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -그릅 연동 관리 -->
<!-- 
	@RequestMapping(value="/UserGroup.do")
	* user_SQL.xml - UserGroup_gridList
	* Action
	  - Update :: setAllocateUserGroup.do
 -->
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00019" var="CM00019"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00036" var="CM00036"/>
 
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
 
<script type="text/javascript">
$(document).ready(function() {
	// SKON CSRF 보안 조치
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			}
	})	
})

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
        	{ width: 50, id: "CHK", header: [{ text: "${menu.LN00113}" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
    		{ width: 100, id: "MemberID", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "center" },
        	{ width: 200, id: "Name", header: [{ text: "Name", align: "center" } ], align: "left" },
        	{ width: 160, id: "RegDate", header: [{ text: "${menu.LN00013}", align: "center" } ], align: "center" },
    	],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});

	layout.getCell("a").attach(grid);

	function doSearchList(){
		var sqlID = "user_SQL.UserGroup";
		var param =  "memberID=${memberID}"				
	        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
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
 	
	function setAllocateUser(){		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.CHK;
	    });
		if(!selectedCell.length){
			//if(confirm("사용자에 할당 된 그릅이 없습니다. \n기존에 할당 되었던 그릅은 모두 지워 집니다.")){
			if(confirm("${CM00036}")){
				var url = "admin/setAllocateUserGroup.do";
				var data = "memberID=${memberID}";
				var target = "blankFrame";
				ajaxPage(url, data, target);
				//alert(data);
			}
		}else{
			//if(confirm("선택된 그릅을 사용자에 할당 하시겠습니까?")){
			if(confirm("${CM00019}")){
				//$("#blankFrame").attr("action","").submit();				
				//grid의 check된 사용자 items에 id추가하기
				var items = selectedCell.map(function(cell) {
			    	return cell.MemberID;
				}).join(",");
				var url = "admin/setAllocateUserGroup.do";
				var data = "memberID=${memberID}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setAllocateUser()"></span>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->