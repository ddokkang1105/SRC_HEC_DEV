<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 그릅 사용자 연관 관리 -->
<!-- 
	@RequestMapping(value="/allocateUsers.do")
	* user_SQL.xml - allocateUsers_gridList
	* Action
	  - Save  :: setUserGroupAllocateUser.do
 -->


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00038" var="CM00038"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00039" var="CM00039"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
 
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

 
<script type="text/javascript">
$(document).ready(function(){
	// SKON CSRF 보안 조치
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			}
	})
	
})

	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("grdAUArea", {
    	rows: [
        	{
            	id: "a",
        	},
    	]
	});
	
	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
    	columns: [
        	{ width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        	{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
   			{ hidden : true, id: "MemberID", header: [{ text: "${menu.LN00106}", align: "center" }, { content: "inputFilter" }], align: "center" },
        	{ width: 100, id: "LoginID", header: [{ text: "${menu.LN00106}", align: "center" }, { content: "inputFilter" }], align: "center" },
        	{ width: 120, id: "UserName", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "center" },
        	{ width: 80, id: "TeamName", header: [{ text: "${menu.LN00018}", align: "center" }, { content: "selectFilter" }], align: "center" },
        	{ width: 90, id: "CompanyName", header: [{ text: "${menu.LN00014}", align: "center" }, { content: "selectFilter" }], align: "center" },
        	{ width: 90, id: "AuthorityName", header: [{ text: "${menu.LN00042}", align: "center" }, { content: "selectFilter" }], align: "center" },
        	{ width: 90, id: "SuperiorTypeImg", header: [{ align:"center" }], htmlEnable: true, align: "center",
        		template: function (text, row, col) {
        			return '<img src="${root}${HTML_IMG_DIR}/'+row.SuperiorTypeImg+'" width="18" height="18">';
            	}
        	},
    	],
    	autoWidth: true,
    	resizable: true,
    	selection: "row",
    	tooltip: false,
    	data: gridData
	});

	layout.getCell("a").attach(grid);

	var pagination = new dhx.Pagination("pagination", {
    	data: grid.data,
    	pageSize: 100,
	});

	$("#TOT_CNT").html(grid.data.getLength());

	function doSearchList(){
		var sqlID = "user_SQL.allocateUsers";
		var param =  "s_itemID=${s_itemID}"				
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
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
	function setAllocateUser(){		
		var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
		if(!selectedCell.length){
			//if(confirm("그릅에 할당 된 사용자가 없습니다. \n기존에 할당 되었던 사용자는 모두 지워 집니다.")){
			if(confirm("${CM00038}")){
				var url = "setUserGroupAllocateUser.do";
				var data = "s_itemID=${s_itemID}";
				var target = "blankFrame";
				ajaxPage(url, data, target);
				//alert(data);
			}
		}else{
			//if(confirm("선택된 사용자를 그릅에 할당 하시겠습니까?")){
			if(confirm("${CM00039}")){
				//$("#blankFrame").attr("action","").submit();				
				var items = selectedCell.map(function(cell) {
			    	return cell.MemberID;
				}).join(",");		
				var url = "setUserGroupAllocateUser.do";
				var data = "s_itemID=${s_itemID}&items="+items;
				var target = "blankFrame";				
				//alert(data);				
				ajaxPage(url, data, target);
			}
		}
	}
			
	function fnSearchUser(){
		var data = "groupID=${s_itemID}"; 
		var url = "searchUser.do";
		var target = "allocUserDiv";
		ajaxPage(url, data, target);
	}
	
	function fnDeleteUser() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		}else {
			if(confirm("${CM00004}")){
				var memberIds = selectedCell.map(function(cell) {
			    	return cell.MemberID;
				}).join(",");
				
				var url = "admin/deleteUserGroup.do";
				var data = "groupID=${s_itemID}&memberIds=" + memberIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	function fnCallBack(){ 
		doSearchList();
	}
	
	function fnChangeAuthority(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		}
		var memberIDs = selectedCell.map(function(cell) {
	    	return cell.MemberID;
		}).join(",");
		var url  = "setUserAuthority.do?memberIDs="+memberIDs;
		window.open(url,'window','width=600, height=250, left=300, top=300,scrollbar=no,resizble=0');
	}
	
	// 그룹 관리자 지정
	function fnAssignManager() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(selectedCell.length!=1){
			alert("${WM00042}");
		}else {
			var memberID = selectedCell[0].MemberID;
			var url  = "admin/assignGroupManager.do";
			var data = "s_itemID=${s_itemID}" + "&memberID="+memberID;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
</script>
<div id="allocUserDiv" >
	<div class="countList">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>     
    	<li class="floatR pdR20 mgB10">	
    		<!-- <span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setAllocateUser()"></span>  -->
    		<span class="btn_pack medium icon"><span class="gov"></span><input value="Assign Manager" onclick="fnAssignManager();" type="submit"></span>
    		&nbsp;<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Authority" onclick="fnChangeAuthority();" type="submit"></span>
			&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="User" onclick="fnSearchUser();" type="submit"></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteUser()"></span>
    	</li>  	
   	</div>
	<div id="gridDiv" class="mgB10" style="height:374px">
		<div id="grdAUArea" style="height:330px; width:100%"></div>
	</div>	
	
		<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
			
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
	</div>	
</div>