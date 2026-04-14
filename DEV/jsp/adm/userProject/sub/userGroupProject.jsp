<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 그릅  변경관리항목(Project) 연동 관리  -->
<!-- 
	@RequestMapping(value="/userGroupProject.do")
	* user_SQL.xml - userGroupProject_gridList
	* Action
	  - Save  :: setUserGroupChangeSet.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00037" var="CM00037"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

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
        	{ width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 300, id: "ParentName", header: [{ text: "ParentProject", align: "center" } ], align: "left" },
        	{ width: 200, id: "ProjectName", header: [{ text: "${menu.LN00028}", align: "center" } ], align: "left" },
        	{ width: 100, id: "TeamName", header: [{ text: "${menu.LN00018}", align: "center" } ], align: "center" },
        	{ width: 100, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" } ], align: "center" },
        	{ width: 50, id: "StatusName", header: [{ text: "${menu.LN00027}", align: "center" } ], align: "center" },
        	{ hidden : true, id: "ProjectID", header: [{ align: "center" } ], align: "center" },
        	{ hidden : true, id: "ChildCount", header: [{ align: "center" } ], align: "center" },
    	],
    	autoWidth: true,
    	resizable: true,
    	selection: "row",
    	tooltip: false,
    	data: gridData
	});

	layout.getCell("a").attach(grid);

	function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(p_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	}
	//조회
	function doSearchList(){
		var sqlID = "user_SQL.userGroupProject";
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
 		//fnMasterChk('');
 	}
	
	//Asign
	function setGroupAccessRight(){
		var url = "setUserGroupChangeSet.do";
		var data = "memberID=${s_itemID}";
		var target = "blankFrame";
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			//if(confirm("그릅에 할당 된 ChangeSet이 없습니다. \n기존에 할당 되었던 ChangeSet이 모두 지워 집니다.")){
			if(confirm("${CM00037}")){
				//alert(data);
				ajaxPage(url, data, target);
			}
		}else{
			//if(confirm("저장 하시겠습니까?")){
			if(confirm("${CM00001}")){
				
				var items = selectedCell.map(function(cell) {
			    	return cell.ProjectID;
				}).join(",");
				
				//grid의 check된 사용자 items에 id추가하기				
				data = data + "&items="+items;
			
				ajaxPage(url, data, target);
			}
		}
	}
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setGroupAccessRight()"></span>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" frameborder="0" src="about:blank" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->