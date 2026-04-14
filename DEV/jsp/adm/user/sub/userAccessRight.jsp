<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<!-- 관리자 : 사용자 연관 Templet(ArcCode) 관리 -->
<!-- 
	@RequestMapping(value="/userAccessRight.do")
	* user_SQL.xml - userAccessRight_gridList
	* Action
	  - Update :: setUserGroupAccessRight.do
 -->

<!-- 화면 표시 메세지 취득  -->
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00028"
	var="WM00028" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00018"
	var="CM00018" />

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
        	{ width: 150, id: "TemplCode", header: [{ text: "Template ID" , align: "center" }], align: "center" },
        	{ width: 150, id: "TemplName", header: [{ text: "Template Name" , align: "center" }], align: "center" },
        	{ width: 70, id: "userChk", header: [{ text: "User" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
    		{ width: 70, id: "groupChk", header: [{ text: "Group", align: "center" } ], align: "center", type: "boolean", editable: true, sortable: false },
        	{ width: 70, id: "IsDefault", header: [{ text: "Is Default", align: "center" } ], align: "center", type: "boolean", editable: true, sortable: false },
        	{ width: 80, hidden: true, width: 80, id: "MemberID", header: [{ text: "MemberID", align: "center" } ], align: "center" },
    	],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});

	layout.getCell("a").attach(grid);
	
	let searchCheck = false; // doSearchList 실행시 true
	let sharedValue = null;	 // 클릭 했을 때 값
	//체크박스 값이 바뀔때
	grid.events.on("change", function() {
		if(!searchCheck){  // doSearchList 할때 실행X
			let { row, column, e } = sharedValue;
			if (column.id=="IsDefault") {
		            if (row.userChk == '' && row.groupChk == '1') {
		                alert('${WM00028}');
		                row.IsDefault = 0;
		            }else{
		            	if(row.IsDefault == 0){
		            		fnUnselectAllIsDefault();
		            	}else{
		            		fnUnselectAllIsDefault();
		            		row.IsDefault = 1
		            	}
		            	var memberID = row.MemberID;
		            	var templCode = row.TemplCode;
		            	var isDefault = row.IsDefault;
		            	$("#memberID").val(memberID);
						$("#templCode").val(templCode);
						$("#isDefault").val(isDefault);
		            }
		        }else if(column.id=="userChk"){ //Group 수정 불가
		        	if(row.userChk == ''&&  row.IsDefault==true){
		        		row.IsDefault = 0;
		        	}
		        }else if(column.id=="groupChk"){
		        	alert('${WM00028}');
		        	if(row.groupChk ==''){
		        		row.groupChk = 1;
		        	}else{
		        		row.groupChk = 0;
		        	}
		        	return false;
		        }
		}
	});
	
	grid.events.on("cellClick", function(row, column, e) {
		sharedValue = { row, column, e };
	    // 클릭된 엘리먼트가 체크박스 엘리먼트인 경우에만 반응
 	    if ($(e.target).hasClass("dhx_checkbox__input")) {
 	    	sharedValue = { row, column, e };
	    } 
	});
	
	function fnUnselectAllIsDefault() {
	    grid.data.forEach(function (row) {
	    	row.IsDefault=false;
	    });
	}

	//조회
	function doSearchList(){
		var sqlID = "user_SQL.userAccessRight";
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
		searchCheck = true;
 		grid.data.parse(newGridData);
 		searchCheck = false;
 	}
	
	//Asign
	 function setGroupAccessRight(){
		
		var templCode = $("#templCode").val();
		var isDefault = $("#isDefault").val();
		
		var url = "admin/setUserGroupAccessRight.do";
		var data = "memberID=${memberID}";
		var target = "blankFrame";
		var selectedUserChk = grid.data.findAll(function (data) {
	        return data.userChk;
	    });
		var selectedIsDefault = grid.data.findAll(function (data) {
	        return data.IsDefault;
	    });
		if(!selectedUserChk.length && !selectedIsDefault.length){
			if(confirm("${CM00018}")){
				ajaxPage(url, data, target);
			}
		}else if(!selectedUserChk.length && selectedIsDefault.length){
			if(confirm("저장 하시겠습니까?")){
				data = data + "&defaultTemplCode="+templCode + "&isDefault="+isDefault;
				ajaxPage(url, data, target);
			}
		}
		else{
			if(confirm("저장 하시겠습니까?")){
				var items = selectedUserChk.map(function(cell) {
			    	return cell.TemplCode;
				}).join(",");
				
				if(!selectedIsDefault.length){
					data = data + "&items="+items;
				} else{
					data = data + "&items="+items + "&defaultTemplCode="+templCode + "&isDefault="+isDefault;
				}
				ajaxPage(url, data, target);
			}
		}
	}	 
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<input type="hidden" id="memberID" name="memberID" value=""> <input
		type="hidden" id="templCode" name="templCode" value=""> <input
		type="hidden" id="isDefault" name="isDefault" value="">
	<div id="grdGridArea" style="height: 250px; width: 100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input
		value="Assign" type="submit" onclick="setGroupAccessRight()"></span>
	<!-- <span class="btn_pack small icon mgT10"><span class="assign"></span><input value="isDefault" type="submit" onclick="fnClickedIsDefault()"></span> -->
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank"
		frameborder="0" style="display: none"></iframe>
</div>
<!-- END :: FRAME -->