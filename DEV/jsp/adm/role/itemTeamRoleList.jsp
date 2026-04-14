<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 2025-03-26 소스 취약점 -->
<meta http-equiv="Content-Security-Policy" content="script-src 'self' 'sha256-0lrhsqqzoeiSmJAAXjKhQAnMB+uJl00lJt1tPHDqnzE=';"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script>
	var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
	var  UserId = "${sessionScope.loginInfo.sessionUserId}";
	
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 360)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 360)+"px; width:100%;");
		};
		
		$("#excel").click(function (){
			fnGridExcelDownLoad();
			/* grid.export.xlsx({
		        url: "//export.dhtmlx.com/excel"
		    }); */
		});
				
		$("#TOT_CNT").html(${gridData.length()});
		
		$("#memberName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');				
				return false;
			}			
		});
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
	
   function fnGoTeamRoleTypePop(){
		var url = "goTeamRoleTypePop.do";
		var w = "400";
		var h = "150";
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnGoOrgTreePop(roleTypeCode, roleTypeName){
		$("#roleTypeCode").val(roleTypeCode);
		var url = "orgTeamTreePop.do";
		var data = "?s_itemID=${s_itemID}&teamIDs=${teamIDs}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){}
	
	function fnSaveTeamRole(teamIDs){
		if(!confirm("${CM00001}")){ return;}
		var roleTypeCode = $("#roleTypeCode").val();
		var url = "saveTeamRole.do";
		var target = "saveRoleFrame";		
		var data = "teamIDs="+teamIDs+"&teamRoleCat=${teamRoleCat}"
					+"&roleTypeCode="+roleTypeCode+"&itemID=${s_itemID}&assigned=1";
		ajaxPage(url, data, target);
	}
	
	function fnUpdateTeamRoleInfo(){
		if(!confirm("${CM00001}")){ return;}
		var roleManagerID = $("#memberID").val();
		var teamRoleID = $("#teamRoleID").val();
		var roleDescription = $("#roleDescription").val();
		
		var url = "updateTeamRoleInfo.do";
		var target = "saveRoleFrame";		
		var data = "teamRoleID="+teamRoleID+"&roleManagerID="+roleManagerID+"&roleDescription="+roleDescription;
		ajaxPage(url, data, target);
	}

	function searchPopupWf(avg){
		var searchValue = $("#memberName").val();
		var url = avg + "&searchValue="+encodeURIComponent(searchValue)
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7){
		$("#memberName").val(avg2+"("+avg3+")");
		$("#memberID").val(avg1);
		$("#path").val(avg7);
	}
		
</script>
</head>
<body>
<div id="roleAssignDiv">
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="roleTypeCode" name="roleTypeCode" >
	<div class="countList" style="margin: 3px 0px 3px 0;">
        <li class="count">Total  <span id="TOT_CNT"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <c:if test="${accMode != 'OPS' }" >             
        	<input type="checkbox" id="removed" name="removed" onClick="fnTeamRoleCallBack()">&nbsp;Show hidden</li>
        </c:if>
        <li class="floatR">        	
       		<c:if test="${(itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1) and itemBlocked eq 0}" >             
               	<span class="btn_pack nobg "><a class="add" onclick="fnGoTeamRoleTypePop();" title="Add"></a></span>
        	   	<span class="btn_pack nobg"><a class="remove" onclick="fnRemoveTeamRole()" title="Remove"></a></span>
        	</c:if>        	
        	<span class="btn_pack nobg white"><a class="xls"  title="Excel"  id="excel">></a></span>
       </li>
    </div>    
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
	<div  id="roleDetail" style="display:none;">
	<table class="tbl_blue01 mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
		    <col width="30%">
		 	<col width="30%">
		 	<col width="25%">
		</colgroup>		
		<tr>
			<th class="last pdL10">Code</th>			
			<th class="last pdL10">${menu.LN00247}</th>
			<th class="last pdL10">${menu.LN00119}</th>	
			<th class="last pdL10">${menu.LN00004}</th>	
		</tr>
		<tr>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="teamCode" name="teamCode" readOnly />
				<input type="hidden" id="teamID" name="teamID" />
			</td>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="teamName" name="teamName" readOnly />
			</td>
			<td class="last alignL">
				<input style= "border:0px;"  type="text" class="text" id="roleType" name="roleType" readOnly />
			</td>
			<td class="last">
				<input type="text" class="text" id="memberName" name="memberName"  style="ime-mode:active;width:80%;" />
				<input type="hidden" class="text" id="memberID" name="memberID" />
				<input type="hidden" class="text" id="teamRoleID" name="teamRoleID" />
				<input type="image" class="image" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search">
			</td> 
		</tr>
		<tr>
			<th class="last">${menu.LN00035}</td>		
			<td class="last pdL10" colspan=3>
				<input type="text" class="text" id="roleDescription" name="roleDescription" />
			</td>
		</tr>
	</table>
	<div class="countList pdT5" >
        <li class="floatR">
         	<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnUpdateTeamRoleInfo()"></span>&nbsp;
       	</li>
    </div>   
    </div> 
</form>
<div style="width:0px;height:0px;display:none;">
<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</div>
</body>
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
	        { width: 50,  id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
	        { width: 30,  id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>"  }], align: "center", type: "boolean",  editable: true, sortable: false}, 
	        { width: 60,  id: "TeamCode", header: [{ text: "${menu.LN00164}", align:"center" }], align: "center"},
	        { width: 130, id: "TeamNM", header: [{ text: "${menu.LN00247}", align:"center" }], align: "center"},
	        {id: "TeamPath", header: [{ text: "${menu.LN00162}", align:"center" }], align:"left"},
	        { width: 110, id: "TeamRoleNM", header: [{text: "${menu.LN00119}", align:"center"}], align:"center" },
	        { width: 80,  id: "AssignedDate", header: [{ text: "${menu.LN00078}", align:"center" }], align:"center" },
	        { width: 80,  id: "LastUpdated",   header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
	        { width: 80,  id: "RoleManagerNM", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center" },
	        { width: 80,  id: "TMRStatusNM", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center" },
	        { width: 80,  id: "TeamID", header: [{ text: "TeamID", align:"center" }], hidden:true },
	        { width: 80,  id: "TeamRoleID", header: [{ text: "TeamRoleID", align:"center" }], hidden:true },
	        { width: 80,  id: "RoleDescription", header: [{ text: "RoleDescription", align:"center" }], hidden:true },
	        { id: "Assigned", header: [{text: "Assigned"}], hidden:true}
	    
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,   
	});
	 
	grid.events.on("cellClick", function(row,column,e){
		var teamID = row.TeamID;
		if(column.id == "TeamRoleNM" && (UserId == "${itemIDAuthorID}" || authLev == 1)) {			
			$("#roleDetail").attr('style', '');				 	
			$("#teamCode").val(row.TeamCode);
			$("#teamName").val(row.TeamNM);
			$("#memberName").val(row.RoleManagerNM);
			$("#teamRoleID").val(row.TeamRoleID);
			$("#teamID").val(row.TeamID);
			$("#roleDescription").val(row.RoleDescription);
			$("#roleType").val(row.TeamRoleNM) 
		 } else if(column.id != "checkbox"){
			var w = "1200";
			var h = "800";
			var url = "orgMainInfo.do?id="+teamID;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}  
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	 
	
	/* const changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);
	 
	var headerFilter = grid.getHeaderFilter("Assignment");
	var element = headerFilter.querySelector("select");
	element.value = "Y";
	element.dispatchEvent(changeEvent); */
	    	
 	function fnTeamRoleCallBack(){ 
		$("#roleDetail").attr('style', 'display: none');
		var showRemoved = "N";
		if( document.all("removed").checked == true){
			showRemoved="Y";
		}
		
		var accMode = "${accMode}";
		var asgnOption = "1,2";
		if(accMode == "DEV" || accMode == "" || accMode == null){
			asgnOption = "1,2"; //해제,해제중 미출력 & 신규, 릴리즈 출력			
		}else {
			asgnOption = "2,3"; //해제,신규 미출력 & 릴리즈, 해제중 출력		
		}
		var isSubItem ="${isSubItem}";
		var sqlID = "role_SQL.getItemTeamRoleList";
		if(isSubItem === "Y"){
			sqlID = "role_SQL.getSubItemRoleList";
		}
		
		var param = "&itemID=${s_itemID}"
				+ "&showRemoved="+showRemoved
				+ "&asgnOption="+asgnOption
				+ "&sqlID="+sqlID;
		
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				gridData = JSON.parse(result);
				fnReloadGrid(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 	}
 		
	function fnRemoveTeamRole(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00002}")){
				var url = "deleteTeamRole.do";
				var teamRoleIDs =  new Array;	
				var assigneds =  new Array;	
				
				for(idx in selectedCell){
					teamRoleIDs[idx] = selectedCell[idx].TeamRoleID;
					assigneds[idx] = selectedCell[idx].Assigned;
				};
				var data = "teamRoleIDs="+teamRoleIDs+"&assigneds="+assigneds; 
				var target = "saveRoleFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	 	
</script>