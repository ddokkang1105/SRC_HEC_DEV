<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00098" var="WM00098"/>


<script type="text/javascript">
	var returnFlag = "${returnFlag}";
	var olm={};
	olm.pages={};
	olm.url={};
	var baseLayout;
	var cntnLayout;
	var menuTreeLayout;
	var treeImgPath="csh_organization";
	var topMenuCnt={};
	var currItemId="";
	var mainLayout;
	var tmplCode="";
	var isTempLoad={};
	var homeUrl;
	var mbrRoleType = "${mbrRoleType}";
	window.onload=setConfFrmInit;
	jQuery(document).ready(function() {
		gridInit1();

// 		gridInit2();
		var unfold = "${unfold}";
		getCategory("AR000002");
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});
		
		const searchInput = document.getElementById("searchValue");
	    /* searchInput.addEventListener("keydown", function (event) {
	        if (event.key === "Enter") {
	        	doSearchList2();
	        }
	    }); */
	    
		
		gridArea1.attachEvent("onRowSelect",function(rowId,cellIndex){
			fnAssignMember();
		});

		
// 		if("${searchValue}" !== "") doSearchList1();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	function fnSetUnfoldTree(){if(olm.menuTree!=null){olm.menuTree.closeAllItems(0);var ch = olm.menuTree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);olm.menuTree.openItem(lev1);}}}
	
	function setConfFrmInit(){
		//document.all.container.width = getWidth() + "px"; 
		//document.all.container.height =  getHeight() + "px"; 
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	}	
	function getHeight(){return (document.body.clientHeight);}
	function getWidth(){return (document.body.clientWidth);}
	function setScreenResize(){ 
		//document.all.container.width = getWidth() + "px"; 
		//document.all.container.height = getHeight() + "px"; 
		if( baseLayout==null){
			if(cntnLayout!=null && cntnLayout!=undefined){
				cntnLayout.setSizes();
			}
		}else{
			var minWidth=lMinWidth+rMinWidth;
			var wWidth=document.body.clientWidth;
			if(minWidth>wWidth){
				baseLayout.items[0].setWidth(lMinWidth);			
			} baseLayout.setSizes();}
	}
	function setInitMenu(isLeft, isMain){if(isMain){$("#menusection").attr("style","display:block;");}else{$("#menusection").attr("style","display:none;");}setScreenResize();}
	function fnCallTreeInfo(){var treeInfo = new Object(); treeInfo.data=olm.menuTree.serializeTreeToJSON(); treeInfo.imgPath=treeImgPath; return treeInfo;}	
	function setInitControl(isSchText, isSchURL, menuName, menuIcon){	
		if(menuName == undefined){ menuName = "";}
		if(menuIcon == undefined || menuIcon == ""){ menuIcon = "icon_home.png";}else{ menuIcon = "root_" +menuIcon;}
		var fullText = "<img src='${root}${HTML_IMG_DIR}/"+menuIcon+"'>&nbsp;&nbsp;"+menuName;$("#menuFullTitle").val(fullText);
		//$("#cntnTitle").html("<span style=color:#333;font-size:12px;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");
		if(isSchText){if($('#schTreeText').length>0){$('#schTreeText').val('');}}		
		if(isSchURL){olm.url={};}	
	}
	
	var dhx_cell_hdr_height = 43;
	function setInitTwoLayout(){	
		//document.getElementById('container').style.height=getHeight()+'px';
		var scrpt = fnSetScriptMasterDiv();
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}		
		baseLayout=new dhtmlXLayoutObject("container",layout_1C,dhx_skin_skyblue);
		// baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
		//baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(250);
		baseLayout.items[0].setText(scrpt.treeTop);
		//baseLayout.items[1].hideHeader();	
		olm.menuTree = baseLayout.items[0].attachTree(0);
		olm.menuTree.setSkin(dhx_skin_skyblue);
		olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});
		olm.menuTree.enableDragAndDrop(false);olm.menuTree.enableSmartXMLParsing(true);	
		cntnLayout = baseLayout.items[1];
		mainLayout = baseLayout.items[1];
	}
	
	function setLayoutResize(){	 
		var minWidth=lMinWidth+rMinWidth;
		var lWidth=baseLayout.items[0].getWidth(); 
		var rWidth=baseLayout.items[1].getWidth();
		var wWidth=document.body.clientWidth;
		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}
	}	
		
	olm.getMenuUrl=function(id){
		$("#searchValue").val("");
		var ids = id.split("_"); 
// 		currItemId=ids[0];	
		doSearchList1(ids[0]);
		//mainLayout.attachURL("managePjtMember.do?projectID=${projectID}&teamID="+currItemId+"&selectMemberID="+$("#selectMemberID").val());		
		//var ifr = mainLayout.getFrame();
		//ifr.scrolling="no";
		//ifr.margin="5px";
		
	};
	
	function getCategory(avg){ 
		setInitTwoLayout();
		menuOption = avg;
		olm.menuTree.getSelectedItemId();
		olm.menuTree.deleteChildItems(0);
		var data="&userID=${sessionScope.loginInfo.sessionUserId}&notCompanyIDs=${notCompanyIDs}&myWorkspace=${myWorkspace}";
		if("${myClient}") data += "&tFilterCode=CSRORG";
		var d=fnSetMenuTreeData(data);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 

	}
	
	function searchTreeText(type){var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);
		}else if(type=="2"){olm.menuTree.findItem(schText,true,false);
		}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){
		var d = fnSetMenuTreeData();var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}if(itemId == null || itemId == 'undefined' || itemId == "null"){itemId = olm.menuTree.getSelectedItemId();}
// 		currItemId = itemId;
		olm.menuTree.deleteChildItems(0);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		if(isReload){olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}
	}
	
	function setLoadingEndTree(prtItemId){
		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
		olm.menuTree.openItem(prtItemId);if(currItemId == null || currItemId == 'undefined'){return false;}else{olm.menuTree.selectItem(currItemId,true,false);}
	}	
	

	function gridInit1(){		
		var d = setGridData1("");	
		gridArea1 = fnNewInitGrid("gridArea1", d);
		gridArea1.setImagePath("${root}${HTML_IMG_DIR}/");
		//gridArea1.setIconPath("${root}${HTML_IMG_DIR_MEMBER}/");
		gridArea1.setColumnHidden(0, true);
		gridArea1.setColumnHidden(1, true);
		gridArea1.setColumnHidden(3, true);
		gridArea1.setColumnHidden(4, true);
		gridArea1.setColumnHidden(5, true);
		gridArea1.setColumnHidden(6, true);
		gridArea1.setColumnHidden(7, true);
		fnSetColType(gridArea1, 1, "ch");
		//fnSetColType(gridArea1, 2, "img");
		if("${searchValue}" !== "") doSearchList1();
	}
	
	function setGridData1(tid = ""){// 선택할 멤버
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getMemberList";		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberID,MemberName,Name,TeamName,CompanyName,TeamID, ClientID";
		result.cols = "CHK|MemberInfo|MemberID|MemberName|Name|TeamName|CompanyName|TeamID|ClientID";
		result.widths = "30,70,*,0,0,0,0,0,0,0";
		result.sorting = "int,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL&userID=${sessionScope.loginInfo.sessionUserId}&myClient=${myClient}";
		result.data +=  "&teamID="+tid;
		
		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
			result.data = result.data +"&searchKey="+ $("#searchKey").val();
			result.data = result.data +"&searchValue="+ $("#searchValue").val();
			result.data +=  "&teamID=";
		}
		return result;
	}

	function doSearchList1(NT){
		var d = setGridData1(NT);
		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
	}
	
	function doSearchList2(){
		var d = setGridData1();

		var selectMember = ($('#selectMember').val() == undefined ? "" : $('#selectMember').val());

		d.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL&userID=${sessionScope.loginInfo.sessionUserId}&myClient=${myClient}"
			+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
			+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
			+ "&selectMember="+selectMember
			+ "&assignmentYN=Y";
		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
			d.data = d.data +"&searchKey="+ $("#searchKey").val();
			d.data = d.data +"&searchValue="+ $("#searchValue").val();
		} else {
			alert("${WM00098}");
			return;
		}
		
		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
	}
	
	function clearSearchCon() {
		$("#searchKey").val("1").attr("selected", "selected");
		$("#searchValue").val("");
	}
	
	function fnAssignMember() {
		var idx = gridArea1.getSelectedRowId();
		var memberID = gridArea1.cells(idx,3).getValue();
		var memberName = gridArea1.cells(idx,5).getValue();
		var teamName = gridArea1.cells(idx,6).getValue();
		var companyName = gridArea1.cells(idx,7).getValue();
		var teamID = gridArea1.cells(idx,8).getValue();
		var clientID = gridArea1.cells(idx,9).getValue();
		
// 		console.log(idx, memberID, memberName, teamName, companyName)

		if(!idx) {
			alert("${WM00042}");
			return;
		}

		if(confirm("${CM00001}")){			
			opener.searchMemberCallback(memberID, memberName, teamName, companyName,teamID, clientID);
			self.close();
		}
	}
</script>

<style>
	#container table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhxcont_global_content_area{
		top:44px!important;
	}	
	table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoBarLabel{
		top:6px;
		margin-left:10px;
	}
	div.gridbox_dhx_web{
		margin-left:0px;
	}
	table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar{
		border-left:0px solid #fff;
		height:40px;
	}
	
	table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhxcont_global_content_area{
		top:33px!important;
	}
	#container{border-top:1px solid #ccc!important;}
	.objbox{
		overflow-x:hidden!important;
		overflow-y:scroll;
	}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr td {
	    line-height: 21px;
	}
</style>
</head>
<body style="width:100%; height:100%; margin;auto;">
<div id="selectDiv">
<form name="cfgFrm" id="cfgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="selectMember" name="selectMember" value="${s_memberIDs}" />
<div>	
	<ul class="align-center cmm_member_bar flex justify-between">
		<li class="floatL"><p>* Search Member</p></li>
		<li class="floatR mgR10">
			<!-- <span id="save" class="btn_pack medium icon">
				<span class="save"></span>
				<input value="Save" type="submit" onclick="fnAssignMember()" />
			</span> -->
		</li>
	</ul>
	
	<div class="cmm_member_listBox">
		<div class="container" id="container" style="width:100%;height:650px;"></div>
	</div>
	
	<div class="cmm_member_selectBox mgL20">
		<div class="child_search01 floatL" style="width:100%; ">
			<li class="pdL0 pdR0" style="width:100%; ">
				<select id="searchKey" name="searchKey" class="pdL5 mgR5">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext mgR30" style="width: calc(100% - 250px);">
				<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onClick="doSearchList2();">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">
			</li>
    	</div>
		<table class="floatL" width="100%" border="0"  cellpadding="0" cellspacing="0">
			<tr>
				<td width="100%" align="left" class="pdT5" >
					<div id="gridArea1" style="height:600px!important;width:100%;overflow-x:hidden; border-bottom:0px solid #fff;"></div>
				</td>				
			</tr>
		</table>
	</div>
	
</div>	
</form>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
</div>
</body>
</html>
