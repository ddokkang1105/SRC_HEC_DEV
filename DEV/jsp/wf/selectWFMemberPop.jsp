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
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00155" var="WM00155"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00094}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

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
	
	#schTreeArea * {
	    box-sizing: content-box;
	}
	
	#schTreeArea{font-size:0px;display:inline-block;}
	#schTreeArea a:nth-child(2){
	    position: relative;
	    top: 2px;
	    right: 23px;
	    cursor: pointer;
	    
	}
	#schTreeArea a:nth-child(3){
	    position: relative;
	    right: 10px;
	    top: 3px;
	    cursor: pointer;
	    border-right: 1px solid #ccc;
	    display: inline-block;
	    background:#f2f2f2;
	   padding:3px 3px 3px 3px;
	   border-radius:4px 0 0 4px;
	}
	#schTreeArea a:nth-child(4){
	    position: relative;
	    right: 10px;
	    top: 2px;
	    cursor: pointer;
	     background:#f2f2f2;
	   padding:3px 4px 9px;
	   border-radius:0 4px 4px 0;
	}
	#schTreeArea a:nth-child(5){
		top: 2px;
	    right: 5px;
	    position: relative;
	    cursor: pointer;
	}
</style>

<script type="text/javascript">
	let tree = "";
	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var agrSeq = "${agrSeq}";
	var gridArea1;
	var gridArea2;
	var memberID = "${sessionScope.loginInfo.sessionUserId}";
	var memberName = "${sessionScope.loginInfo.sessionUserNm}";
	var teamName = "${sessionScope.loginInfo.sessionTeamName}";
	var agreeYN = "${agrYN}";
	var agreeCnt = 0;
	var aprvCnt = 0;
	var selTeamID = "";
	var selTeamName = "";
	var searchMember = "";
	var dhx_cell_hdr_height = 43;
	var selectMember = "${selectMember}";
	var tmpSelSHR = "${tmpSelSHR}";
	
	let icon_set = {
		csh_organization : {
			folder: "dxi icon-csh_organization-closed",
			openFolder: "dxi icon-csh_organization-open",
			file: "dxi icon-csh_organization"
	    }
	}
	
	window.onload=setConfFrmInit;
	jQuery(document).ready(function() {	
		gridInit1("");
		gridInit2();
		var unfold = "${unfold}";
		getCategory("${arcCode}");
		//if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		$("#searchValue").val("");
		
		$('.cmm_member_btnList').height(setWindowHeight() - 47);
		
		if(selectMember != "") {
			doSearchList2();
			
			aprvCnt = tmpSelSHR.indexOf("S") > -1 ? 1 : 0;
			
		}
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
// 	function fnSetUnfoldTree() { 
// 		if (tree != null) {
// 			tree.closeAllItems(0);
// 			var ch = tree.hasChildren(0);
// 			for (var i = 0; i < ch; i++) {
// 				var lev1 = tree.getChildItemIdByIndex(0, i);
// 				tree.openItem(lev1);
// 			}
// 		}
// 	}

	function setConfFrmInit() {
		if (window.attachEvent) {
			window.attachEvent("onresize", resizeLayout);
		} else {
			window.addEventListener("resize", resizeLayout, false);
		}
		var t;
		function resizeLayout() {
			window.clearTimeout(t);
			t = window.setTimeout(function() {
				setScreenResize();
			}, 200);
		}
	}
	function getHeight() {
		return (document.body.clientHeight);
	}
	function getWidth() {
		return (document.body.clientWidth);
	}
	function setScreenResize() {
		//document.all.container.width = getWidth() + "px";
		//document.all.container.height = getHeight() + "px";
		if (baseLayout == null) {
			if (cntnLayout != null && cntnLayout != undefined) {
				cntnLayout.setSizes();
			}
		} else {
			var minWidth = lMinWidth + rMinWidth;
			var wWidth = document.body.clientWidth;
			if (minWidth > wWidth) {
				baseLayout.items[0].setWidth(lMinWidth);
			}
			baseLayout.setSizes();
		}
	}

	function setInitTwoLayout() {
		//document.getElementById('container').style.height=getHeight()+'px';
		var scrpt = new Object();
		scrpt.treeTop="<div id='schTreeArea'>";
		scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;&nbsp;";
		scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
		scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a>|<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
		scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
		scrpt.treeTop=scrpt.treeTop+"</div>";scrpt.cntnTop="";
			
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}		
// 		baseLayout=new dhtmlXLayoutObject("container",layout_1C,dhx_skin_skyblue);
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
		
// 		baseLayout.setAutoSize("b","a;b");
// 		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
// 		baseLayout.items[0].setWidth(250);
// 		baseLayout.items[0].setText(scrpt.treeTop);
		//baseLayout.items[1].hideHeader();	
// 		tree = baseLayout.items[0].attachTree(0);
// 		tree.setSkin(dhx_skin_skyblue);
// 		tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
// 		tree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});
// 		tree.enableDragAndDrop(false);tree.enableSmartXMLParsing(true);	
// 		cntnLayout = baseLayout.items[1];
// 		mainLayout = baseLayout.items[1];

		baseLayout = new dhx.Layout("container", {
			type: "line",
			cols: [
				{
					id: "leftPanel",
					width: "100%",
					rows: [
						{
							id :"searchArea",
							height: 44
						},
						{
							id: "treeArea",
						},
						
					]
				}
			]
     	});
		
        const treeArea = baseLayout.getCell("treeArea");
    	
        // Tree 붙일 위치 지정된 div에 Tree 생성
        tree = new dhx.Tree(null, {
            icon: {
                folder: icon_set["csh_organization"].folder,
                openFolder: icon_set["csh_organization"].openFolder,
                file: icon_set["csh_organization"].file
            },
        	selection: true,
        	itemHeight: 30,
          data: []
        });
        treeArea.attach(tree);
        
		tree.events.on("itemClick", function(id) {
			console.log(id)
			olm.getMenuUrl(id);
		});
		
		baseLayout.getCell("searchArea").attachHTML(scrpt.treeTop);
	}

// 	function setLayoutResize() {
// 		var minWidth = lMinWidth + rMinWidth;
// 		var lWidth = baseLayout.items[0].getWidth();
// 		var rWidth = baseLayout.items[1].getWidth();
// 		var wWidth = document.body.clientWidth;
// 		if (lWidth < lMinWidth) {
// 			baseLayout.items[0].setWidth(lMinWidth);
// 		}
// 		if (wWidth >= minWidth && rWidth < rMinWidth) {
// 			baseLayout.items[1].setWidth(rMinWidth);
// 		}
// 	}

	olm.getMenuUrl = function(id) {
// 		var ids = id.split("_");
// 		selTeamName = tree.getItemText(id);
// 		selTeamID = ids[0];
// 		currItemId = ids[0];
		currItemId = id;
		doSearchList1(currItemId);

	};

	function getCategory(avg) {
		setInitTwoLayout();
		menuOption = avg;
// 		tree.getSelectedItemId();
// 		tree.deleteChildItems(0);
		var data = "&clientID=${clientID}";
		var d = fnSetMenuTreeData(data);
// 		fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, avg); // 트리로드
		setTreeData("menuId="+d.key+"&SelectMenuId="+avg+"&"+d.data+"&cols="+d.cols)
	}
	
	function setTreeData(queryData, isReload){
		console.log("setTreeData")
		fetch("jsonDhtmlxTreeListData.do?"+new URLSearchParams(queryData).toString())
		.then(res => res.json())
		.then(res => {
			tree.data.parse(res);
			
			if(isReload) {
				var prtItemId = 1;
				
				if(currItemId == null || currItemId == 'undefined') return false;
				else {
					tree.focusItem(currItemId);
		   			tree.selection.add(currItemId);
		   			tree.expand(currItemId);
				}
			}
		})
	}

// 	function searchTreeText(type) {
// 		var schText = $("#schTreeText").val();
// 		if (schText == "") {
// 			alert("${WM00045}");
// 			return false;
// 		}
		
// 		if(type=="1"){tree.findItem(schText,false,true);
// 		}else if(type=="2"){tree.findItem(schText,true,false);
// 		}else if(type=="3"){tree.findItem(schText,false,false);}
// 	}

	function searchTreeText(type){
		var schText=$("#schTreeText").val();
		if(schText==""){alert("${WM00045}"); return false;}
// 		if(type=="1"){tree.findItem(schText,false,true);
// 		}else if(type=="2"){tree.findItem(schText,true,false);
// 		}else if(type=="3"){tree.findItem(schText,false,false);}

		if(type == "1") search()
		else if(type == "2") focusPrev()
		else if(type == "3") focusNext()
	}
	
	const searchState = {
		matches: [],
		index: -1,
		lastQuery: ""
	};

	function normalizeText(text) {
		return String(text ?? "").trim().toLowerCase();
	}

	function clearSearch() {
		searchState.matches = [];
		searchState.index = -1;
		searchState.lastQuery = "";
	}

	function activateMatch(id) {
		if (!id) return;
		tree.selection.add(id);
		tree.focusItem(id);
		olm.getMenuUrl(id);
	}

	function searchText() {
		const input = document.querySelector("#schTreeText");
		if (!input) return;

		const query = normalizeText(input.value);
		if (!query) return;

		clearSearch();

		const matches = [];
		tree.data.forEach((item) => {
			const label = normalizeText(item.value);
			if (label.includes(query)) {
				matches.push(item.id);
			}
		});

		searchState.matches = matches;
		searchState.index = -1;
		searchState.lastQuery = query;
	}

	function ensureSearch() {
		const input = document.querySelector("#schTreeText");
		
		if (!input) return;

		const query = normalizeText(input.value);
		if (!query) return;

		if (
			searchState.lastQuery !== query ||
			!searchState.matches.length
		) {
			searchText();
		}
	}

	function search() {
		ensureSearch();
		if (!searchState.matches.length) return;

		if (searchState.index === -1) {
			searchState.index = 0;
		}

		activateMatch(searchState.matches[0]);
	}

	function focusNext() {
		ensureSearch();
		if (!searchState.matches.length) return;

		if (searchState.index === -1) {
			searchState.index = 0;
		} else {
			searchState.index =
				(searchState.index + 1) % searchState.matches.length;
		}

		activateMatch(searchState.matches[searchState.index]);
	}


	function focusPrev() {
		ensureSearch();
		if (!searchState.matches.length) return;

		if (searchState.index === -1) {
			searchState.index = 0;
		} else {
			searchState.index =
				(searchState.index - 1 + searchState.matches.length) %
				searchState.matches.length;
		}

		activateMatch(searchState.matches[searchState.index]);
	}

	function fnRefreshTree(itemId, isReload) {
		var d = fnSetMenuTreeData();
		var noMsg = "";
		if (isReload == null || isReload == 'undefined' || isReload == "null") {
			isReload = false;
		}
		if (itemId == null || itemId == 'undefined' || itemId == "null") {
// 			itemId = tree.getSelectedItemId();
			itemId = tree._focusId;
		}
		currItemId = itemId;
// 		tree.deleteChildItems(0);
// 		fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, menuOption,noMsg);
		setTreeData("menuId="+d.key+"&SelectMenuId="+menuOption+"&"+d.data+"&cols="+d.cols, isReload)
// 		if (isReload) {
// 			tree.setOnLoadingEnd(setLoadingEndTree);
// 		}
	}

// 	function setLoadingEndTree(prtItemId) {
// 		if (prtItemId == null || prtItemId == 'undefined') {
// 			prtItemId = 1;
// 		}
// 		tree.openItem(prtItemId);
// 		if (currItemId == null || currItemId == 'undefined') {
// 			return false;
// 		} else {
// 			tree.selectItem(currItemId, true, false);
// 		}
// 	}

	function fnAssignInfo() {
// 		var rowIDs = gridArea2.getAllRowIds().split(",");
		var rowIDs = gridArea2.data.getRawData();
		var afterSI = "";
		var afterID = "";
		var afterRT = "";
		var beforeSI = "";
		var beforeID = "";
		var beforeRT = "";
		var tempSI = "";
		var tempID = "";
		var tempRT = "";
		var mgrCnt = 0;
		var rewCnt = 0;

// 		 "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name|Role|RoleCode";
		 
		for (var i = 0; i < rowIDs.length; i++) {
// 			var rt = gridArea2.cells(rowIDs[i],9).getValue();
			var rt = rowIDs[i].RoleCode;
			if (rt == "PAGR") {											
				tempSI = tempSI +(mgrCnt == 0 ? " >> " : ", ") + rowIDs[i].Name+"("+rowIDs[i].TeamName+"/${wfLabel.PAGR})";
				tempID = tempID + "," + rowIDs[i].MemberID
				tempRT = tempRT + "," + rowIDs[i].RoleCode

				mgrCnt++;
			} else if (rt == "REW" && mgrCnt == 0) {											
				afterSI = afterSI +(rewCnt == 0 ? " >> " : ", ") + rowIDs[i].Name+"("+rowIDs[i].TeamName+"/${wfLabel.REW})";
				afterID = afterID + "," + rowIDs[i].MemberID
				afterRT = afterRT + "," + rowIDs[i].RoleCode

				rewCnt++;
			} else if (rt == "REW" && mgrCnt > 0 ) {											
				beforeSI = beforeSI +(rewCnt == 0 ? " >> " : ", ") + rowIDs[i].Name+"("+rowIDs[i].TeamName+"/${wfLabel.REW})";
				beforeID = beforeID + "," + rowIDs[i].MemberID
				beforeRT = beforeRT + "," + rowIDs[i].RoleCode

				rewCnt++;
			} else if (rt != "PAGR" && mgrCnt == 0) {
				afterSI = afterSI + " >> " + rowIDs[i].Name+"("+rowIDs[i].TeamName+(rt == "AGR" ? "/${wfLabel.AGR})" : "/${wfLabel.APRV})");
				afterID = afterID + "," + rowIDs[i].MemberID
				afterRT = afterRT + "," + rowIDs[i].RoleCode
				rewCnt = 0;
			} else if (rt != "PAGR"  && mgrCnt > 0 ) {
				beforeSI = beforeSI + " >> " +rowIDs[i].Name+"("+rowIDs[i].TeamName+(rt == "AGR" ? "/${wfLabel.AGR})" : "/${wfLabel.APRV})");
				beforeID = beforeID + "," + rowIDs[i].MemberID
				beforeRT = beforeRT + "," + rowIDs[i].RoleCode
				rewCnt = 0;
			}
		}
		
		wfStepInfo = memberName+"("+teamName+")" + afterSI + tempSI + beforeSI;
		memberIDs = memberID + afterID + tempID + beforeID;
		roleTypes = "AREQ" + afterRT + tempRT + beforeRT;
		
		window.opener.fnSetWFStepInfo(wfStepInfo, memberIDs, roleTypes,
				mgrCnt, "${agrYN}");
		
		window.self.close();
	}

	function fnSetWFOtherInfo() {

		window.opener.fnSetWFStepInfo2($("#wfStepRefIDs").val(),$("#wfStepRefInfo").val(),$("#wfStepRecIDs").val(),$("#wfStepRecInfo").val(),$('#wfStepRecTeamIDs').val());
		window.self.close();
	}

	function gridInit1(){		
// 		var d = setGridData1();		
// 		gridArea1 = fnNewInitGrid("gridArea1", d);
// 		gridArea1.setImagePath("${root}${HTML_IMG_DIR}/");
// 		//gridArea1.setIconPath("${root}${HTML_IMG_DIR_MEMBER}/");
// 		gridArea1.setColumnHidden(0, true);	
// 		//gridArea1.setColumnHidden(2, true);
// 		gridArea1.setColumnHidden(3, true);
// 		//gridArea1.setColumnHidden(4, true);	
// 		gridArea1.setColumnHidden(5, true);	
// 		gridArea1.setColumnHidden(6, true);		
// 		gridArea1.setColumnHidden(7, true);		
// 		fnSetColType(gridArea1, 1, "ch");

// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberName,${menu.LN00247},TeamPath,MemberID,Name";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name";

		gridArea1 = new dhx.Grid("gridArea1",  {
			columns: [
		        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk1(checked)'></input>", htmlEnable: true, align:"center" }], align: "center", type: "boolean", editable: true, sortable: false},
		        { gravity: 1, id: "MemberInfo", header: [{ text: "${menu.LN00037}", align:"center"}], htmlEnable: true,
		        	template: function (text, row, col) {
		        		return row.MemberInfo;
		            }
		        },
		        { width: 150, id: "TeamName", header: [{ text: "${menu.LN00247}", align:"center" }], align: "center"},
		    ],
		    selection: "row",
		    autoWidth: true,
		    rowHeight: 60,
		    resizable : true
		});
	}
	function gridInit2(){		
// 		var d = setGridData2();
		
// 		gridArea2 = fnNewInitGrid("gridArea2", d);
// 		gridArea2.setImagePath("${root}${HTML_IMG_DIR}/"); //path to images required by grid
// 		gridArea2.setColumnHidden(0, true);
// 		gridArea2.setColumnHidden(2, true);
// 		gridArea2.setColumnHidden(4, true);
// 		gridArea2.setColumnHidden(6, true);
// 		gridArea2.setColumnHidden(7, true);
// 		gridArea2.setColumnHidden(9, true);
// 		fnSetColType(gridArea2, 1, "ch");

// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},${menu.LN00037},TeamName,${menu.LN00247},MemberID,Name,Role,RoleCode";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name|Role|RoleCode";

		gridArea2 = new dhx.Grid("gridArea2",  {
			columns: [
		        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk2(checked)'></input>", htmlEnable: true, align:"center" }], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 120, id: "MemberName", header: [{ text: "${menu.LN00037}", align:"center"}], htmlEnable: true,
		        	template: function (text, row, col) {
		        		return row.MemberName;
		            }
		        },
		        { gravity: 1, id: "TeamPath", header: [{ text: "${menu.LN00247}", align:"center" }]},
		        { width: 100, id: "Role", header: [{ text: "Role", align:"center" }], align: "center"},
		    ],
		    selection: "row",
		    autoWidth: true,
		    resizable : true
		});
	}
	
	function fnMasterChk1(state) {
	    event.stopPropagation();
	    gridArea1.data.forEach(function (row) {
	    	gridArea1.data.update(row.id, { "checkbox" : state })
	    })
	}
	
	function fnMasterChk2(state) {
	    event.stopPropagation();
	    gridArea2.data.forEach(function (row) {
	    	gridArea2.data.update(row.id, { "checkbox" : state })
	    })
	}
	
// 	function setGridData1(teamID){// 선택할 멤버 
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "wf_SQL.getWfMemberList";		
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberName,${menu.LN00247},TeamPath,MemberID,Name";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name";
// 		result.widths = "30,30,210,100,150,50,50,0";
// 		result.sorting = "int,int,str,str,str,str,str";
// 		result.aligns = "center,center,left,center,center,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 					+ "&teamID="+teamID
// 					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
<%-- 					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>" --%>
// 					+ "&assignmentYN=Y"
// 					+ "&selectMember=${selectMember}";
					
// 		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
// 			result.data = result.data +"&searchKey="+ $("#searchKey").val();
// 			result.data = result.data +"&searchValue="+ $("#searchValue").val();
// 		}
		
// 		return result;
// 	}
	
// 	function setGridData2(){// 선택된 멤버
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "wf_SQL.getWfMemberList";		
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},${menu.LN00037},TeamName,${menu.LN00247},MemberID,Name,Role,RoleCode";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name|Role|RoleCode";
// 		result.widths = "30,30,30,120,10,*,30,50,100";
// 		result.sorting = "int,int,str,str,str,str,str,str,str";
// 		result.aligns = "center,center,left,left,left,left,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 						+ "&teamId=${teamID}"
// 						+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
<%-- 						+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>" --%>
// 						+ "&assignmentYN=Y"
// 						+ "&selectMember=${selectMember}"
// 						+ "&tmpSelSHR=${tmpSelSHR}"						
// 						+ "&secYN=Y";
// 		return result;
// 	}

	
	function doSearchList1(teamID){
// 		result.key = "wf_SQL.getWfMemberList";		
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberName,${menu.LN00247},TeamPath,MemberID,Name";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name";
// 		result.widths = "30,30,210,100,150,50,50,0";
// 		result.sorting = "int,int,str,str,str,str,str";
// 		result.aligns = "center,center,left,center,center,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 					+ "&teamID="+teamID
// 					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
<%-- 					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>" --%>
// 					+ "&assignmentYN=Y"
// 					+ "&selectMember=${selectMember}";
					
// 		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
// 			result.data = result.data +"&searchKey="+ $("#searchKey").val();
// 			result.data = result.data +"&searchValue="+ $("#searchValue").val();
// 		}
		
// 		var d = setGridData1(NT);
		var selectMember = searchMember;
		
// 		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);

		$('#loading').fadeIn(100);
		
		var sqlID = "wf_SQL.getWfMemberList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
				+ "&teamID="+teamID
				+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
				+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
				+ "&assignmentYN=Y"
				+ "&selectMember=${selectMember}"
				+ "&sqlID="+sqlID;
				

				if(teamID == "NT") {
					param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
						+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
						+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
						+ "&selectMember="+selectMember
						+ "&assignmentYN=Y"
						+ "&sqlID="+sqlID;
				}
				
				if($("#searchValue").val() != '' && $("#searchValue").val() != null){
					param += "&searchKey="+ $("#searchKey").val();
					param += "&searchValue="+ $("#searchValue").val();
				}
				
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				gridArea1.data.parse(result);
				$('#loading').fadeOut(100);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	function doSearchList2(){		
// 		result.key = "wf_SQL.getWfMemberList";		
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},${menu.LN00037},TeamName,${menu.LN00247},MemberID,Name,Role,RoleCode";
// 		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name|Role|RoleCode";
// 		result.widths = "30,30,30,120,10,*,30,50,100";
// 		result.sorting = "int,int,str,str,str,str,str,str,str";
// 		result.aligns = "center,center,left,left,left,left,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 						+ "&teamId=${teamID}"
// 						+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
<%-- 						+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>" --%>
// 						+ "&assignmentYN=Y"
// 						+ "&selectMember=${selectMember}"
// 						+ "&tmpSelSHR=${tmpSelSHR}"						
// 						+ "&secYN=Y";
						
// 		var d = setGridData2();
// 		fnLoadDhtmlxGridJson(gridArea2, d.key, d.cols, d.data);
		
		var sqlID = "wf_SQL.getWfMemberList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
					+ "&teamId=${teamID}"
					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
					+ "&assignmentYN=Y"
					+ "&selectMember=${selectMember}"
					+ "&tmpSelSHR=${tmpSelSHR}"						
					+ "&secYN=Y"
					+ "&sqlID="+sqlID;
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				gridArea2.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	

	function doClickMove(toRight){ 
		var sourceGrid, targetGrid;
		if(toRight == 'D'){
			sourceGrid = gridArea2;
			targetGrid = gridArea1;
		}else{
			sourceGrid = gridArea1;
			targetGrid = gridArea2;
		}

// 		var moveRowStr = sourceGrid.getCheckedRows(1);
		var moveRowStr = sourceGrid.data.findAll(e => e.checkbox).length;
		if((moveRowStr == null || moveRowStr.length == 0) && toRight != 'C'){alert("${WM00029}");return;}
		var sourceGridData = sourceGrid.data.findAll(e => e.checkbox);

		if(toRight == 'H'){
			for(var i = 0 ; i < sourceGridData.length ; i++) {

// 				if(checkSelectItem(sourceGridData[i].MemberID)) {
				if(checkSelectItem(sourceGridData[i].MemberID)) {	
// 					var id = sourceGridData[i].Name;
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = sourceGridData[i].MemberID.toString()
				}
				else {
					searchMember += "," + sourceGridData[i].MemberID
				}
				
				if ($('#actor').val() == ""  || $('#actor').val() == undefined) {
					$('#actor').val(memberID+","+sourceGridData[i].MemberID);
					$('#wfStepID').val("AREQ,AGR");
					wfStepInfo = memberName+"("+teamName+") >>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.AGR})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {
					$('#actor').val($('#actor').val() + "," + sourceGridData[i].MemberID);
					$('#wfStepID').val($('#wfStepID').val()+ "," + "AGR" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.AGR})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 				                          ,"${wfLabel.AGR}"	       
// 				                          ,"AGR"
// 				                          ]				
// 										  , targetGrid.getRowsNum());

				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.AGR}",
					RoleCode : "AGR"
				});
			}
		} else if(toRight == 'P'){
			for(var i = 0 ; i < sourceGridData.length ; i++){		
				if(checkSelectItem(sourceGridData[i].MemberID)) {	
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = sourceGridData[i].MemberID.toString()
				}
				else {
					searchMember += "," + sourceGridData[i].MemberID
				}
				
				if ($('#actor').val() == ""  || $('#actor').val() == undefined) {	
					$('#actor').val(memberID+","+sourceGridData[i].MemberID);
					$('#wfStepID').val("AREQ,PAGR");
					wfStepInfo = memberName+"("+teamName+") >>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.PAGR})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {						
					$('#actor').val($('#actor').val() + "," + sourceGridData[i].MemberID);
					$('#wfStepID').val($('#wfStepID').val()+ "," + "PAGR" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.PAGR})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 				                          ,"${wfLabel.PAGR}"	       
// 				                          ,"PAGR"                        
// 				                          ]				
// 										  , targetGrid.getRowsNum());				

				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.PAGR}",
					RoleCode : "PAGR"
				});
			}
		}else if(toRight == 'S'){
			for(var i = 0 ; i < sourceGridData.length ; i++){	

				if(checkSelectItem(sourceGridData[i].MemberID)) {
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = sourceGridData[i].MemberID.toString();
				}
				else {
					searchMember += "," + sourceGridData[i].MemberID;
				}
				
				if ($('#actor').val() == "" || $('#actor').val() == undefined) {
					$('#actor').val(memberID+","+sourceGridData[i].MemberID);
					$('#wfStepID').val("AREQ,APRV");
					wfStepInfo = memberName+"("+teamName+") >>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.APRV})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {	
					$('#actor').val($('#actor').val() + "," + sourceGridData[i].MemberID);
					$('#wfStepID').val($('#wfStepID').val()+ "," + "APRV" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.APRV})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 				                          ,"${wfLabel.APRV}"	           
// 				                          ,"APRV"                    
// 				                          ]				
// 										  , targetGrid.getRowsNum());

				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.APRV}",
					RoleCode : "APRV"
				});
				aprvCnt++;

			}
		}else if(toRight == 'W'){
			for(var i = 0 ; i < sourceGridData.length ; i++){	

				if(checkSelectItem(sourceGridData[i].MemberID)) {
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}

				if(searchMember == "") {
					searchMember = sourceGridData[i].MemberID.toString();
				}
				else {
					searchMember += "," + sourceGridData[i].MemberID;
				}
				
				if ($('#actor').val() == "" || $('#actor').val() == undefined) {
					$('#actor').val(memberID+","+sourceGridData[i].MemberID);
					$('#wfStepID').val("AREQ,REW");
					wfStepInfo = memberName+"("+teamName+") >>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.REW})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {	
					$('#actor').val($('#actor').val() + "," + sourceGridData[i].MemberID);
					$('#wfStepID').val($('#wfStepID').val()+ "," + "REW" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+sourceGridData[i].Name+"("+sourceGridData[i].TeamName+"/${wfLabel.REW})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 				                          ,"${wfLabel.REW}"	           
// 				                          ,"REW"                    
// 				                          ]				
// 										  , targetGrid.getRowsNum());

				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.REW}",
					RoleCode : "REW"
				});
				aprvCnt++;

			}
		}else if(toRight == 'R'){
			for(var i = 0 ; i < sourceGridData.length ; i++){		

				if(checkSelectItem(sourceGridData[i].MemberID)) {
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}

				if(searchMember == "") {
					searchMember = sourceGridData[i].MemberID.toString();
				}
				else {
					searchMember += "," + sourceGridData[i].MemberID;
				}
				
				if ($('#wfStepRefInfo').val() == "" || $('#wfStepRefInfo').val() == undefined) {
					$('#wfStepRefIDs').val(sourceGridData[i].MemberID);
					$('#wfStepRefInfo').val(sourceGridData[i].Name);
					
				} else {				
					$('#wfStepRefIDs').val($('#wfStepRefIDs').val() + "," + sourceGridData[i].MemberID);
					$('#wfStepRefInfo').val($('#wfStepRefInfo').val() + "," + sourceGridData[i].Name);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 				                          ,"${wfLabel.REF}"	         
// 				                          ,"REF"                      
// 				                          ]				
// 										  , targetGrid.getRowsNum());
				
				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.REF}",
					RoleCode : "REF"
				});

			}
		}else if(toRight == 'C'){
			if((moveRowStr == null || moveRowStr.length == 0) && selTeamID != "") {		
				if(checkSelectItem(selTeamID)) {
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ selTeamName +"'/>"
					alert("${WM00162}");
					return false;
				}
				
				if ($('#wfStepRecTeamIDs').val() != "" && $('#wfStepRecTeamIDs').val() != undefined) {
					
					$('#wfStepRecTeamIDs').val($('#wfStepRecTeamIDs').val() + "," + selTeamID);
				}
				else {
					$('#wfStepRecTeamIDs').val(selTeamID);
				}
				
				if ($('#wfStepRecInfo').val() == "" || $('#wfStepRecInfo').val() == undefined) {
					$('#wfStepRecInfo').val(selTeamName);					
				} else {				
					$('#wfStepRecInfo').val( $('#wfStepRecInfo').val() + "," + selTeamName);
				}
				
// 				var newId = (new Date()).valueOf();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,selTeamID
// 				                          ,selTeamName
// 				                          ,selTeamID
// 				                          ,selTeamName
// 				                          ,selTeamID
// 				                          ,selTeamName
// 				                          ,"${wfLabel.REC}"	       
// 				                          ,"REC"                        
// 				                          ]				
// 										  , targetGrid.getRowsNum());

				targetGrid.data.add({
					...sourceGridData[i],
					Role : "${wfLabel.REC}",
					RoleCode : "REC"
				});

				selTeamID = "";
				selTeamName = "";
			}
			else {
				for(var i = 0 ; i < sourceGridData.length ; i++){		
					if(checkSelectItem(sourceGridData[i].MemberID)) {
					var id = sourceGridData[i].Name;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
						alert("${WM00162}");
						continue;
					}

					if(searchMember == "") {
						searchMember = sourceGridData[i].MemberID.toString();
					}
					else {
						searchMember += "," + sourceGridData[i].MemberID;
					}
					
					if ($('#wfStepRecIDs').val() != "" && $('#wfStepRecIDs').val() != undefined) {		
						$('#wfStepRecIDs').val($('#wfStepRecIDs').val() + "," + sourceGridData[i].MemberID);			
					}
					else {
						$('#wfStepRecIDs').val(sourceGridData[i].MemberID);
					}
										
					if ($('#wfStepRecInfo').val() == "" || $('#wfStepRecInfo').val() == undefined) {						
						$('#wfStepRecInfo').val(sourceGridData[i].Name);
					} else {				
									
						$('#wfStepRecInfo').val($('#wfStepRecInfo').val() + "," + sourceGridData[i].Name);
					}
					
// 					var newId = (new Date()).valueOf();
// 					targetGrid.addRow(newId, [newId
// 					                          ,"0"
// 					                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
// 					                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
// 					                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
// 					                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
// 					                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
// 					                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
// 					                          ,"${wfLabel.REC}"	
// 					                          ,"REC"
// 					                          ]				
// 											  , targetGrid.getRowsNum());

					targetGrid.data.add({
						...sourceGridData[i],
						Role : "${wfLabel.REC}",
						RoleCode : "REC"
					});
	
				}
			}
		}else if(toRight == 'D'){
			console.log(searchMember);
			var beforeSearchMember = searchMember.split(',');
			
			if(beforeSearchMember.length == 1)
				beforeSearchMember = "";

			for(var i = 0 ; i < sourceGridData.length ; i++){
				var newId = (new Date()).valueOf();				
				
				var beforeDelArray = $('#actor').val().split(',');
				var beforeWfStepArray = $('#wfStepID').val().split(',');
				var delArray = sourceGridData[i].MemberID;
				for (var j in beforeDelArray) {
					if (beforeDelArray[j] == delArray) {
						beforeDelArray.splice(j,1);
						beforeWfStepArray.splice(j,1);

						break;
					}
				}

				if(beforeSearchMember != "") {
					for (var l in beforeSearchMember) {
						if (beforeSearchMember[l] == delArray) {
							beforeSearchMember.splice(l,1);
							break;
						}
					}
				}

				$('#actor').val(beforeDelArray);
				$('#wfStepID').val(beforeWfStepArray);
				
// 				if(agreeYN == "Y" && gridArea2.cells(moveRowArray[i],8).getValue()  == "${wfLabel.AGR}")
				if(agreeYN == "Y" && targetGrid[i].Role  == "${wfLabel.AGR}")
					agreeCnt--;
				
// 				sourceGrid.deleteRow(moveRowArray[i]);
				sourceGrid.data.remove(sourceGridData[i].id);
			}

			searchMember = beforeSearchMember.join(",");
		}
		
// 		gridArea1.uncheckAll();
// 		gridArea2.uncheckAll();

		// 체크박스 초기화
		gridArea1.data.forEach(e => {
		    gridArea1.data.update(e.id, {checkbox : false})
		});
		
		gridArea2.data.forEach(e => {
		    gridArea2.data.update(e.id, {checkbox : false})
		});
	}	

	function fnAssignMember() {		
		if(agreeYN == "Y" && agreeCnt < 1) {
			alert("${WM00155}");
			return;
		}
		if(aprvCnt < 1) {
			alert("${WM00041}");
			return;
		}
		if(confirm("${CM00001}")){
			fnAssignInfo();
		}		
	}
		
	function selfClose(){
		self.close();
	}
	
	
	function checkSelectItem(id) {
		return gridArea2.data.map(e => e.MemberID).includes(id);
// 		var gridIDs = gridArea2.getAllRowIds();
		
// 		if(gridIDs != null && gridIDs != "") {
// 			gridIDs = gridIDs.split(',');
			
// 			for(var i=0; i < gridIDs.length; i++) {
// 				var check = gridArea2.cells(gridIDs[i],6).getValue();
				
// 				if(check == id) {
// 					return true;
// 				}
				
// 			}
// 		}
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
	#container{border-top:1px solid #ccc!important; border-bottom:1px solid #ccc!important;}
	.objbox{
		 overflow-x:hidden!important;
	}
	.cmm_member_btnList{
	    box-sizing: border-box;
	}
	.dhxlayout_base_dhx_skyblue .dhxlayout_cont div.dhx_cell_layout div.dhx_cell_hdr div.dhx_cell_hdr_text{
	    top: 3px;
	}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr td {
	    line-height: 21px;
	}
</style>
</head>
<body style="width:100%; height:98%; margin;auto;">
<form name="cfgFrm" id="cfgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />	
<input type="hidden" id="wfID" name="wfID" value="1"/>
<input type="hidden" id="wfStep" name="wfStep" value=""/>
<input type="hidden" id="wfStepID" name="wfStepID" value=""/>
<input type="hidden" id="wfStepTxt" name="wfStepTxt" value=""/>
<input type="hidden" id="actor" name="actor" value=""/>
<input type="hidden" id="createWF" name="createWF" value="${createWF}" />
<input type="hidden" id="wfStepInfo" name="wfStepInfo">
<input type="hidden" id="wfStepRefInfo" name="wfStepRefInfo"/>
<input type="hidden" id="wfStepRefIDs" name="wfStepRefIDs"/>
<input type="hidden" id="wfStepRecInfo" name="wfStepRecInfo"/>
<input type="hidden" id="wfStepRecTeamIDs" name="wfStepRecTeamIDs"/>
<input type="hidden" id="wfStepRecIDs" name="wfStepRecIDs"/>
<div id="contentwrapper" style="position:absolute;">	
	
	<div class="cmm_member_bar">
		<li class="floatL">
			<p>
			<c:if test="${flg eq 'C' }">
				* ${menu.LN00140}
			</c:if>
			<c:if test="${flg eq 'R' }">
				* ${menu.LN00117} / ${menu.LN00245}
			</c:if>
			</p>
		</li>
	</div>	 	
	
	<div class="cmm_member_listBox">
		<div class="container" id="container" style="width:100%;float:left;height:350px;"></div>
			<div class="child_search floatL" style="width:100%; margin-left:-2px;border-right:0px solid #dfdfdf;">
				<li style="margin-left:10px;padding-left:0px;padding-right:0;">	
					<select id="searchKey" name="searchKey" class="pdL5">
						<option value="Name">Name</option>
						<option value="ID">ID</option>
					</select>
					<input type="text" id="searchValue" name="searchValue" value="" class="stext" style="width:150px;ime-mode:active;">
					<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" OnClick="doSearchList1('NT');">
				</li>
	    	</div>    
<!-- 		    <table class="floatL" width="100%" border="0"  cellpadding="0" cellspacing="0"> -->
<!-- 				<tr> -->
<!-- 					<td width="100%" align="left" class="pdT5" > -->
						<div id="gridArea1" style="height:250px!important;width:100%;overflow-x:hidden; border-bottom:0px solid #fff;"></div>
<!-- 					</td>				 -->
<!-- 				</tr> -->
<!-- 			</table> -->
	</div>
	
	<div class="cmm_member_btnList">
		<ul>
			<c:if test="${flg eq 'C' }">
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.AGR}" type="submit" onclick="doClickMove('H');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.PAGR}" type="submit" onclick="doClickMove('P');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.APRV}" type="submit" onclick="doClickMove('S');"></li>	
			<!-- 검토  -->
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REW}" type="submit" onclick="doClickMove('W');"></li>	
			</c:if>
			<c:if test="${flg eq 'R' }">
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REF}" type="submit" onclick="doClickMove('R');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REC}" type="submit" onclick="doClickMove('C');"></li>
			</c:if>				
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_del.png" /><input value="Del" type="submit" onclick="doClickMove('D');"></li>
		</ul>
	</div>
  	
  	<div class="cmm_member_selectBox">
<!-- 		<table class="floatL" width="100%">	 -->
<!-- 			<tr>				 -->
<!-- 				<td class="floatL pd0" width="100%" align="left"> -->
					<div id="gridArea2" style="height:500px; width:100%; overflow-x:hidden; border-top:1px solid #dfdfdf;"></div>
						<div class="cmm_member_sort">
							<div style="cursor:pointer;" onclick="gridArea2.moveRowUp(gridArea2.getSelectedId())">
								<img src="${root}cmm/common/images/btn_arrow_up.png" />
								<span>Up</span>
							</div>
							<div style="cursor:pointer;" onclick="gridArea2.moveRowDown(gridArea2.getSelectedId())">
								<img src="${root}cmm/common/images/btn_arrow_down.png" />
								<span>Down</span>
							</div>
						</div>
<!-- 				</td> -->
<!-- 				<td class="cmm_member_save"> -->
				<div class="cmm_member_save">
						<c:if test="${flg eq 'C' }">
						<span id="save" class="btn_pack medium icon"><span class="save"></span>
						<input value="Save" type="submit" onclick="fnAssignMember()"/></span>
						</c:if>
						<c:if test="${flg eq 'R' }">
						<span id="save" class="btn_pack medium icon"><span class="save"></span>
						<input value="Save" type="submit" onclick="fnSetWFOtherInfo()"/></span>
						</c:if>
						<span id="close" class="btn_pack medium icon"><span class="close"></span>
						<input value="Close" type="submit" onclick="selfClose()" /></span>
					</div>
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 		</table> -->
	</div>
	
</div>
	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
</body>
</html>
