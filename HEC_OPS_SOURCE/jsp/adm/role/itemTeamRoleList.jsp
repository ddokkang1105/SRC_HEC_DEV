<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<script>
	var p_gridArea;	
	var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
	var  UserId = "${sessionScope.loginInfo.sessionUserId}";
	
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		};
				
		$('.searchList').click(function(){
			doSearchRoleList();
			return false;
		});
		
		$("#memberName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
				
				return false;
			}			
		});
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		gridInit();	
		doSearchRoleList();
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
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		
		p_gridArea.setPagingSkin("bricks");
		
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);
		fnSetColType(p_gridArea, 1, "ch");
	}
	
	function setGridData(avg){
		var result = new Object();
		result.title = "${title}";
		result.key = "role_SQL.getItemTeamRoleList";
	    result.header = "${menu.LN00024},#master_checkbox,${menu.LN00164},${menu.LN00247},${menu.LN00162},${menu.LN00119},${menu.LN00078},${menu.LN00004},teamRoleType,teamRoleID,roleManagerID,TeamID";
		result.cols = "CHK|TeamCode|TeamNM|TeamPath|TeamRoleNM|AssignedDate|RoleManagerNM|TeamRoletype|TeamRoleID|RoleManagerID|TeamID";
		result.widths = "30,30,80,150,*,120,100,100,50,50,50,50";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&itemID=${itemID}"
					+ "&assigned=1";
		return result;
	}
		
	function doSearchRoleList(avg){
		var d = setGridData(avg);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridOnRowSelect(id, ind){
		var teamID = p_gridArea.cells(id, 11).getValue();
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnDeleteTeamRole(){	
		var checkedRows = p_gridArea.getCheckedRows(1).split(",").length;		
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		if(confirm("${CM00002}")){
			var cnt  = p_gridArea.getRowsNum();
			var teamRoleIDs =  new Array;			
			var chkVal;
			
			var j = 0;		
			for ( var i = 0; i < cnt; i++) { 
				chkVal = p_gridArea.cells2(i,1).getValue();
				if(chkVal == 1){
					teamRoleIDs[j] = p_gridArea.cells2(i, 9).getValue();
					j++;
				}
			}
			var url = "deleteTeamRole.do";
			var target = "saveRoleFrame";		
			var data = "teamRoleIDs="+teamRoleIDs; 
			ajaxPage(url, data, target);
		}
	}
	
	function fnTeamRoleCallBack(){
		gridInit();	
		doSearchRoleList();
		$("#roleDetail").attr('style', 'display: none');
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
		var data = "teamIDs="+teamIDs+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&roleTypeCode="+roleTypeCode+"&itemID=${itemID}&assigned=1";
		ajaxPage(url, data, target);
	}
	
	function fnUpdateTeamRoleInfo(){
		if(!confirm("${CM00001}")){ return;}
		var roleManagerID = $("#memberID").val();
		var teamRoleID = $("#teamRoleID").val();
		var teamRoleType = $("#roleType").val();
		
		var url = "updateTeamRoleInfo.do";
		var target = "saveRoleFrame";		
		var data = "teamRoleID="+teamRoleID+"&roleManagerID="+roleManagerID+"&teamRoleType="+teamRoleType;
		ajaxPage(url, data, target);
	}
	
	function fnRemoveTeamRole(){	
		var checkedRows = p_gridArea.getCheckedRows(1).split(",").length;		
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		if(confirm("${CM00005}")){
			var cnt  = p_gridArea.getRowsNum();
			var teamRoleIDs =  new Array;			
			var chkVal;
			
			var j = 0;		
			for ( var i = 0; i < cnt; i++) { 
				chkVal = p_gridArea.cells2(i,1).getValue();
				if(chkVal == 1){
					teamRoleIDs[j] = p_gridArea.cells2(i, 9).getValue();
					j++;
				}
			}
			var url = "updateTeamRoleInfo.do";
			var target = "saveRoleFrame";		
			var data = "teamRoleIDs="+teamRoleIDs+"&assigned=0"; 
			ajaxPage(url, data, target);
		}
	}
	
	
</script>

<div id="roleAssignDiv">
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="roleTypeCode" name="roleTypeCode" >
	<div class="countList pdB5 " >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
       		<c:if test="${itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1}" >
               	<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onClick="fnGoTeamRoleTypePop();" ></span>
        	   	&nbsp;
        	   	<span class="btn_pack small icon"><span class="edit"></span><input value="Remove" type="submit" onclick="fnRemoveTeamRole()" ></span>
        	   	&nbsp;
        	   	<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
        	   		<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteTeamRole()" ></span>
        	   	</c:if>
        	</c:if>
        		&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
       </li>
    </div>    
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<div  id="roleDetail" style="display:none;">
	<table class="tbl_blue01 mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
		    <col width="20%">
		    <col width="35%">
		 	<col width="20%">
		 	<col width="20%">
		</colgroup>		
		<tr>
			<th class="last pdL10">Code</th>			
			<th class="last pdL10">${menu.LN00247}</th>
			<th class="last pdL10">${menu.LN00162}</th>
			<th class="last pdL10">${menu.LN00119}</th>	
			<th class="last pdL10">${menu.LN00004}</th>	
		</tr>
		<div id="teamRoleListTbl"></div>
		<tr>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="teamCode" name="teamCode" readOnly />
				<input type="hidden" id="teamID" name="teamID" />
			</td>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="teamName" name="teamName" readOnly />
			</td>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="teamPath" name="teamPath" readOnly />
			</td>
			<td class="last alignL">
				<select id="roleType" name="roleType" class="sel" style="width:95%;"></select>
			</td>
			<td class="last">
				<input type="text" class="text" id="memberName" name="memberName" style="ime-mode:active;width:80%;" />
				<input type="hidden" class="text" id="memberID" name="memberID" />
				<input type="hidden" class="text" id="teamRoleID" name="teamRoleID" />
				<input type="image" class="image" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search">
			</td> 
		</tr>
	</table>
	<div class="countList pdT5 pdB5 " >
        <li class="floatR">
         	   	<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnUpdateTeamRoleInfo()"></span>&nbsp;
       	</li>
        </li>
    </div>   
    </div> 
</form>
<div style="width:0px;height:0px;display:none;">
<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</div>