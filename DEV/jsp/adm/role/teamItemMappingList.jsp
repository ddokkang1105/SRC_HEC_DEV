<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/jqueryJsInc.jsp" %>
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%> <!-- tagInc.jsp include 시 dhtmlx tooltip 안됨 -->
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/sf/css/content.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/pagination.css?v=7.1.8">
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>

<!-- dataset -->
<script>
	function fnSelect(id, code, menuId, defaultValue, isAll, headerKey, debug) {
		url = "<c:url value='/ajaxCodeSelect.do'/>";
		data = "ajaxParam1="+code+"&menuId="+menuId+"&headerKey="+headerKey;
		if(isAll==null) {isAll = 'select';}ajaxSelect(url, data, id, defaultValue, isAll, headerKey, debug);}

	$(document).ready(function(){
		/* var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&teamType=2&assignmentType=TEAMROLETP";
		fnSelect('companyID', data, 'getTeam', '', 'Select');	
		fnSelect('teamRoleType', data, 'getOLMRoleType', '', 'Select'); */
		
		fnInitTreeGrid();
		fnTreeGridLoad();
		$('.searchList').click(function(){
			fnTreeGridLoad();
			return false;
		});
		
		$("#excel").click(function(){ fnDownload(); });
	});
	
	var treeGrid;
	function fnInitTreeGrid(){
		treeGrid = new dhx.Grid("treegrid_container", {
			type: "tree",
			columns: [				
				{ width: 200, id: "value", type: "string", header: [{ text: "${menu.LN00028}", align:"center"}],  htmlEnable: true},
				{ id: "Path", type: "string", header: [{ text: "Path", align:"center"}], gravity:1},
				{ width: 120, id: "ClassName", type: "string", header: [{ text: "${menu.LN00016}" , align:"center"}, {content:"selectFilter"}]},
				{ width: 100, id: "ItemStatusNM", type: "string", header: [{ text: "Item ${menu.LN00027}" , align:"center"}, {content:"selectFilter"}]},
				{ width: 100, id: "LastUpdated", type: "string", header: [{ text: "LastUpdated" , align:"center"}]},
				{ width: 150, id: "CompanyNM", type: "string", header: [{ text: "Company", align: "center"}, {content:"selectFilter"}]},
				{ width: 120, id: "TeamRoleNM", type: "string", header: [{ text: "${menu.LN00119}" , align:"center"}, {content:"selectFilter"}]},
				{ width: 140, id: "RoleManagerNM", type: "string", header: [{ text: "${menu.LN00004}", align:"center"}, {content:"inputFilter"}]},				
				{ width: 80,  id: "StatusNM", type: "string", header: [{ text: "${menu.LN00027}" , align:"center"}, {content:"selectFilter"}]},
				
				{ hidden: true, width: 100, id: "parent", type: "string",  header: [{ text: "parent"}] },
				{ hidden: true,  width: 100, id: "id", type: "string",  header: [{ text: "id" }] },
				{ hidden: true,  width: 100, id: "ItemID", type: "string",  header: [{ text: "ItemID"}] },
				{ hidden: true,  width: 100, id: "TeamID", type: "string",  header: [{ text: "TeamID"}] }
			],
			autoWidth: true,
			selection: "row"
		});
		
		treeGrid.collapseAll();
		const pagination = new dhx.Pagination("pagination", {
		    css: "dhx_widget--bordered",
		    data: treeGrid.data,
		    pageSize: 10,
		});
		
		const change = [ "change" ];
		change.forEach(function (event) {
            pagination.events.on(event, function () {
            	fnTreeGridLoad();
            });
        });
		
		treeGrid.events.on("cellDblClick", function(row,column,e){
		     var parent = JSON.stringify(row.parent).replace(/\"/g, "");
		     if(parent == "treegrid_container"){ // 조직
		    	 var teamID = JSON.stringify(row.TeamID).replace(/\"/g, "");
		     
		    	 var w = "1200";
			 	 var h = "800";
			 	 var url = "orgMainInfo.do?id="+teamID;
			 	 window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		     }else{ //Item
		    	 var itemID = JSON.stringify(row.ItemID).replace(/\"/g, "");
		     	 var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		 		 var w = 1200;
		 		 var h = 900; 
		 		 window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		     }
		});
	} 
	
	function fnGetTeamList(companyID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&teamType=4&companyID="+companyID;
		fnSelect('teamID', data, 'getTeam', '', 'Select');
	}
	
	function fnTreeGridLoad(){
		var d=fnSetMenuTreeGridDataV7();
		fnLoadDhtmlxTreeGridJsonV7(d.key, d.cols, d.data); 
	}
	
	function fnSetMenuTreeGridDataV7(){
		var result = new Object();
		result.key = "role_SQL.getTeamListTeamRole";
		result.cols = "id|parent|value|Path|ClassName|ItemStatusNM|LastUpdated|CompanyNM|TeamRoleNM|RoleManagerNM|ItemName|StatusNM|ItemID|TeamID";
		result.data = "";
		/* result.data = "&companyID="+$("#companyID").val()
					+ "&teamID="+$("#teamID").val()
					+ "&assigned="+$("#assigned").val()
					+ "&teamRoleType="+$("#teamRoleType").val(); */
		
		return result;
	}
	
	function fnLoadDhtmlxTreeGridJsonV7(key, cols, value, select, noMsg, callbackFnc) {
		var msg = "${WM00018}";
		var data = "menuId="+key;
		data += "&cols=" + cols;
		data += "&SelectMenuId=" + select;
		data += "&" + value;

		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
		fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}
		ajaxTreeGridLoadV7("<c:url value='/getTeamItemMappingList.do'/>", data, "", false, noMsg, msg, callbackFnc);
	}
	
	function ajaxTreeGridLoadV7(url, data, target, debug, noMsg, msg, callback) {
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut();
				if(debug){alert(result);}	
				if(result == 'error' || result == ""){
					if(noMsg != 'Y'){
						alert(msg); 
						treeGrid.data.parse([]);
					}
				}else{
					result = JSON.parse(result);
					treeGrid.data.parse(result);
					treeGrid.collapseAll();
				}
				if(callback== null || callback==""){}
				else if (typeof callback === "function") {
			        callback(); 
			    }
			}
		});
	}
		
	function fnDownload() {
		treeGrid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};
	
</script>

<style>
  	html, body {
		height:100%;
		padding:0;
		margin:0;
		overflow:hidden;
	}

    .custom-tooltip {
        display: flex;
    }
    
    .custom-tooltip > *:last-child {
        margin-left: 12px;
    }
    
    .custom-tooltip img {
        width: 62px;
        height: 62px;
    }

</style>

<body>
    <div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/img_process.png">&nbsp;${reportName}</h3>
	</div>
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
	<div class="child_search">
		<%-- <li>
			<span style="font-weight:bold;">${menu.LN00014}&nbsp;</span>
			<select class="sel" id="companyID" name="companyID" style="width:120px;" OnChange="fnGetTeamList(this.value);">
				<option value="">Select</option>
			</select>
		</li>
		<li>
			<span style="font-weight:bold;">Team&nbsp;</span>
			<select class="sel" id="teamID" name="teamID" style="width:120px;">
				<option value="">Select</option>
			</select>
		</li>
		<li>
			<span style="font-weight:bold;">Status&nbsp;</span>
			<select id="assigned" name="assigned" class="sel" style="width:120px;">
				<option value="1">Active</option>
				<option value="0">Removed</option>
				<option value="">All</option>
			</select>
		</li>
		<li>
			<span style="font-weight:bold;">${menu.LN00119}&nbsp;</span>
			<select id="teamRoleType" name="teamRoleType" class="sel" style="width:120px;">
				<option value="">Select</option>
			</select>
		</li> --%>
		<%-- <li style="float:right;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
			&nbsp;<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" OnClick="fnDownload();"></span>
		</li> --%>
		
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
		
	</div>
   
   <div id="gridDiv" style="width:100%;" class="clear" >
		<div id="treegrid_container" style="height: 600px; padding: 10px 10px 0;"></div>
		<div id="pagination" style="padding: 0 10px;"  class="dhx_sample-container__widget"></div>
	</div> 
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>