<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00038" var="CM00038"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00039" var="CM00039"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
 
<script type="text/javascript">

	var groupID = "${userGrMgtList[0].GroupID}";
	
	$(document).ready(function() {	

		// 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 360)+"px;");
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 360)+"px;");
		};	
		
		doSearchList();
		
		$("#userGroup").change(function(){
			fnChangeUserGroup($(this).val());
		})
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnReloadGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
 		$("#TOT_CNT").html(targetGrid.data.getLength());
	}
	
	function doSearchList(){

		const sqlID = "user_SQL.allocateUsers"
		const param = "s_itemID=" + groupID
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&sqlID=" + sqlID;
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(newGridData){
 				fnReloadGrid(grid, newGridData);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function fnChangeUserGroup(id){
		groupID = id;
		doSearchList();
	}
	
	function fnChangeAuthority(){
		
        var checkedRows = [];
        grid.data.forEach(function(row) {
            if (row.CHK) { 
            	checkedRows.push(row.id);
            }
        });
		
		if(checkedRows.length == 0){
			alert("${WM00023}");
			return;
		}

		var memberIDs = [];
		for(var i = 0 ; i < checkedRows.length; i++ ){
            const rowId = checkedRows[i];
            const rowData = grid.data.getItem(rowId);
            memberIDs.push(rowData.MemberID);
		}
		
		// 시스템 관리자 제외
		var url  = "setUserAuthority.do?groupManagerYN=Y&memberIDs="+memberIDs;
		window.open(url,'window','width=400, height=250, left=300, top=300,scrollbar=no,resizble=0');
	}
	
// 	====================================[[아래는 미사용 함수]]====================================
	
	// 미사용 함수
	function fnSearchUser(){
		var data = "groupID=${s_itemID}"; 
		var url = "searchUser.do";
		var target = "allocUserDiv";
		ajaxPage(url, data, target);
	}
	
	// 미사용 함수
	function fnCallBack(){ 
		au_gridInit();
		doSearchList();
	}
</script>
<div id="allocUserDiv" >
	<h3 class="mgT10 mgB12" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;User Group</span></h3>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="8%">
	    <col>
    </colgroup>
    <tr>
   		<!-- 프로젝트 그룹 -->
       	<th class="alignL pdL10">Group</th>       	
       	<td class="alignL pdL10"> 
       		<select id="userGroup" Name="userGroup" style="width:15%">
       	    	<c:forEach var="list" items="${userGrMgtList}">
	            	<option value="${list.GroupID}">${list.GroupName }</option>
	            </c:forEach>
	       	</select> 
		</td>
	</tr>
	</table>
	
	<div class="countList">
    	<li  class="count pdT10">Total  <span id="TOT_CNT"></span></li>     
    	<li class="floatR pdR20 mgB10">	
    		&nbsp;<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Authority" onclick="fnChangeAuthority();" type="submit"></span>
    	</li>  	
   	</div>
	<div id="gridDiv" style="clear: both;">
		<div id="gridArea" style="width:100%"></div>
	</div>	
	
	<!-- START :: PAGING -->
	<div id="pagination" class="mgT20"></div>	
	<!-- END :: PAGING -->	
			
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
	</div>
</div>
<script>

	function handleHeaderCheckboxClick(state, targetGrid, checkboxName, headerCheckboxID) {
		    event.stopPropagation();
		    targetGrid.data.forEach(function(row) {
		        targetGrid.data.update(row.id, {
		            [checkboxName]: state
		        });
		    });  
	    }

	var pagination;
	

	const gridArea = new dhx.Layout("gridArea", {
		rows: [ { id: "a" } ] });

	var grid = new dhx.Grid("gridArea", {
	    columns: [
	    	{ width: 40, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 40, id: "CHK",
	        	header: [{ htmlEnable: true,
	        		id: 'CHKHeader1',
	        		text: "<input type='checkbox' onclick=\"handleHeaderCheckboxClick(checked, grid, 'CHK')\"></input>",
	        		align: "center",
	        		htmlEnable: true}],
	    		align: "center", type: "boolean", editable: true, sortable: false},
	        { hidden: true, id: "MemberID", header: [{ text: "MemberID", align: "center" },], align: "left"},
	        { width: 100, id: "LoginID", header: [{ text: "ID", align: "center" },], align: "center"},
	        { id: "UserName", header: [{ text: "Name", align: "left" },], align: "left"},
	        { width: 200, id: "TeamName", header: [{ text: "${menu.LN00018}", align: "left" },], align: "left"},
	        { width: 120, id: "CompanyName", header: [{ text: "${menu.LN00014}", align: "left" },], align: "left"},
	        { width: 100, id: "AuthorityName", header: [{ text: "${menu.LN00042}", align: "center" },], align: "center"},
        	{ width: 80, id: "SuperiorTypeImg", header: [{ align:"center" }], htmlEnable: true, align: "center",
        		template: function (text, row, col) {
        			return '<img src="${root}${HTML_IMG_DIR}/'+row.SuperiorTypeImg+'" width="18" height="18">';
            	}
        	},
	        { width: 200, id: "DefaultTemplate", header: [{ text: "DefaultTemplate", align: "center" },], align: "center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});

	gridArea.getCell("a").attach(grid);
	
	grid.events.on("cellClick", (row,column,e) => gridOnRowSelect(row,column,e)); 
	
	if(pagination){pagination.destructor();}
	 
	pagination = new dhx.Pagination("pagination", {
		data: grid.data,
	    pageSize: 50,
	});

</script>