<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -그릅 연동 관리 -->
<!-- 
	@RequestMapping(value="/userProject.do")
	* user_SQL.xml - userProject_gridList
	* Action
	  - Update :: setUserGroupChangeSet.do
 -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00037" var="CM00037"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00094" var="WM00094"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">		
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
	        { hidden : true, width: 50, id: "CHK", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 100, id: "ProjectCode", header: [{ text: "Project Code", align: "center" } ], align: "center" },
	        { width: 200, id: "ProjectName", header: [{ text: "${menu.LN00028}", align: "center" } ], align: "left" },
	        { width: 150, id: "ParentPjtName", header: [{ text: "Work Space", align: "center" } ], align: "left" },
	        { width: 100, id: "TeamName", header: [{ text: "${menu.LN00018}", align: "center" } ], align: "center" },
	        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" } ], align: "center" },
	        { width: 50, id: "StatusName", header: [{ text: "${menu.LN00027}", align: "center" } ], align: "center" },
	        { hidden : true, width: 0, id: "ProjectID", header: [{ text: "", align: "center" } ], align: "center" },
	        { hidden : true, width: 0, id: "ChildCount", header: [{ text: "", align: "center" } ], align: "center" },
	        { hidden : true, width: 100, id: "chkAuth", header: [{ text: "${menu.LN00084}", align: "center" } ], align: "left" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);

	//그리드ROW선택시
	//function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(p_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	//}
	//checkbox 클릭시 확인
/* 	function gridOnCheckEvent(id, ind){
		if(p_gridArea.cells(id, 10).getValue()=='GROUP'){
			//alert('그릅에서 상속 된 변견관리 권한은 수정 할 수 없습니다.');
			alert('${WM00094}');
			p_gridArea.cells(id, 1).setValue(1);
		}
	} */
	
	//조회
/* 	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	} */	
	//Asign
	/* function setGroupAccessRight(){
				var url = "setUserGroupChangeSet.do";
		var data = "memberID=${memberID}";
		var target = "blankFrame";
		
		if(p_gridArea.getCheckedRows(1).length == 0){
			//if(confirm("그릅에 할당 된 ChangeSet이 없습니다. \n기존에 할당 되었던 ChangeSet이 모두 지워 집니다.")){
			if(confirm("${CM00037}")){
				//alert(data);
				ajaxPage(url, data, target);
			}
		}else{
			//if(confirm("저장 하시겠습니까?")){
			if(confirm("${CM00001}")){
				
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");

				//grid의 check된 사용자 items에 id추가하기
				var items = "";
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if(p_gridArea.cells(checkedRows[i], 10).getValue()!='GROUP'){
						if(items == ""){
							items = p_gridArea.cells(checkedRows[i], 8).getValue();
						}else{
							items += ","+ p_gridArea.cells(checkedRows[i], 8).getValue();
						}
					}
					
				}
				
				data = data + "&items="+items;
				//alert(data);
				ajaxPage(url, data, target);
			}
		}
	} */
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<!-- <span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setGroupAccessRight()"></span> -->
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" frameborder="0" src="about:blank" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->