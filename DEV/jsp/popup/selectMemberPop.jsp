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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>

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
	var returnFlag = "${returnFlag}";
	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var mbrRoleType = "${mbrRoleType}";
	
	let icon_set = {
			csh_organization : {
				folder: "dxi icon-csh_organization-closed",
				openFolder: "dxi icon-csh_organization-open",
				file: "dxi icon-csh_organization"
		    }
		}
	
	window.onload=setConfFrmInit;
	jQuery(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		gridInit1();
		gridInit2();
		
		var unfold = "${unfold}";
		getCategory("${arcCode}");
// 		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});
		$("#searchValue").val("");
		
		$('.cmm_member_btnList').height(setWindowHeight() - 49);
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
// 	function fnSetUnfoldTree(){if(tree!=null){tree.closeAllItems(0);var ch = tree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = tree.getChildItemIdByIndex(0,i);tree.openItem(lev1);}}}
	
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
	function fnCallTreeInfo(){var treeInfo = new Object(); treeInfo.data=tree.serializeTreeToJSON(); treeInfo.imgPath=treeImgPath; return treeInfo;}	
	function setInitControl(isSchText, isSchURL, menuName, menuIcon){	
		if(menuName == undefined){ menuName = "";}
		if(menuIcon == undefined || menuIcon == ""){ menuIcon = "icon_home.png";}else{ menuIcon = "root_" +menuIcon;}
		var fullText = "<img src='${root}${HTML_IMG_DIR}/"+menuIcon+"'>&nbsp;&nbsp;"+menuName;$("#menuFullTitle").val(fullText);
		//$("#cntnTitle").html("<span style=color:#333;font-size:12px;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");
		if(isSchText){if($('#schTreeText').length>0){$('#schTreeText').val('');}}		
		if(isSchURL){olm.url={};}	
	}
	
	var dhx_cell_hdr_height = 36;
	function setInitTwoLayout(){
		console.log("setInitTwoLayout")
		//document.getElementById('container').style.height=getHeight()+'px';
		var scrpt = fnSetScriptMasterDiv();
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}		
// 		baseLayout=new dhtmlXLayoutObject("container",layout_1C,dhx_skin_skyblue);
		// baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
		//baseLayout.setAutoSize("b","a;b");
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
	
// 	function setLayoutResize(){	 
// 		var minWidth=lMinWidth+rMinWidth;
// 		var lWidth=baseLayout.items[0].getWidth(); 
// 		var rWidth=baseLayout.items[1].getWidth();
// 		var wWidth=document.body.clientWidth;
// 		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
// 		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}
// 	}	
		
	olm.getMenuUrl=function(id){
		console.log(id)
// 		var ids = id.split("_"); 
		currItemId = id;
		doSearchList1(currItemId);
		//mainLayout.attachURL("managePjtMember.do?projectID=${projectID}&teamID="+currItemId+"&selectMemberID="+$("#selectMemberID").val());		
		//var ifr = mainLayout.getFrame();
		//ifr.scrolling="no";
		//ifr.margin="5px";
		
	};
	
	function getCategory(avg){ 
		console.log("getCategory")
		setInitTwoLayout();
		menuOption = avg;
// 		tree.getSelectedItemId();
// 		tree.deleteChildItems(0);
		var data="";
		var d=fnSetMenuTreeData(data);
// 		fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, avg); // 트리로드 
		setTreeData("menuId="+d.key+"&SelectMenuId="+avg+"&"+d.data+"&cols="+d.cols)
	}
	
	function setTreeData(queryData, isReload){
		console.log("setTreeData")
		fetch("jsonDhtmlxTreeListData.do?"+new URLSearchParams(queryData).toString())
		.then(res => res.json())
		.then(res => {
			console.log(tree)
			console.log(res)
			tree.data.parse(res);
			
			if(isReload) {
				var prtItemId = 1;
				
				if(currItemId == null || currItemId == 'undefined') return false;
				else {
// 					tree.selectItem(currItemId,true,false);
					tree.focusItem(currItemId);
		   			tree.selection.add(currItemId);
		   			tree.expand(currItemId);
				}
			}
		})
	}
	
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
		
	function fnRefreshTree(itemId,isReload){
		var d = fnSetMenuTreeData();
		var noMsg = "";
		if(isReload == null || isReload == 'undefined' || isReload == "null"){
			isReload=false;
		}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
// 			itemId = tree.getSelectedItemId();
			itemId = tree._focusId;
		}
		currItemId = itemId;
// 		tree.deleteChildItems(0);
// 		fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, menuOption,noMsg);
		setTreeData("menuId="+d.key+"&SelectMenuId="+menuOption+"&"+d.data+"&cols="+d.cols, isReload)
// 		if(isReload){
// 			tree.setOnLoadingEnd(setLoadingEndTree);
// 		}
	}
	
// 	function setLoadingEndTree(prtItemId){
// 		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
// 		tree.openItem(prtItemId);
// 		if(currItemId == null || currItemId == 'undefined'){return false;}
// 		else{tree.selectItem(currItemId,true,false);}
// 	}	
	
	var gridArea1 = ""
	// 조직별 사원 표시
	function gridInit1(){
// 		var d = setGridData1("");
		
		gridArea1 = new dhx.Grid("gridArea1",  {
			columns: [
		        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk1(checked)'></input>", htmlEnable: true, align:"center" }], align: "center", type: "boolean", editable: true, sortable: false},
		        { gravity: 1, id: "MemberInfo", header: [{ text: "${menu.LN00037}", align:"center"}], htmlEnable: true,
		        	template: function (text, row, col) {
		        		return row.MemberInfo;
		            }
		        }, 
		    ],
		    selection: "row",
		    autoWidth: true,
		    rowHeight: 60
		});
	}
	
	var gridArea2 = ""
	// 우측 선택된 멤버 표시
	function gridInit2(){
// 		gridArea2 = fnNewInitGrid("gridArea2", d);
// 		gridArea2.setImagePath("${root}${HTML_IMG_DIR}/"); //path to images required by grid
// 		gridArea2.setColumnHidden(0, true);
// 		gridArea2.setColumnHidden(3, true);
// 		gridArea2.setColumnHidden(4, true);
// 		gridArea2.setColumnHidden(5, true);
// 		gridArea2.setColumnHidden(6, true);
// 		fnSetColType(gridArea2, 1, "ch");

		
		var s_memberIDs = "${s_memberIDs}"; 

		if(s_memberIDs != ""){
// 			fnLoadDhtmlxGridJson(gridArea2, d.key, d.cols, d.data);
			doSearchList2();
		}

		gridArea2 = new dhx.Grid("gridArea2",  {
			columns: [
		        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk2(checked)'></input>", htmlEnable: true, align:"center" }], align: "center", type: "boolean", editable: true, sortable: false},
		        { gravity: 1, id: "MemberInfo", header: [{ text: "${menu.LN00037}", align:"center"}], htmlEnable: true,
		        	template: function (text, row, col) {
		        		return row.MemberInfo;
		            }
		        }, 
		    ],
		    selection: "row",
		    autoWidth: true,
		    rowHeight: 60
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
	
	function doSearchList1(teamID = ""){// 선택할 멤버 
		console.log(teamID)
		var selectMember = ($('#selectMember').val() == undefined ? "" : $('#selectMember').val());
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "project_SQL.getMemberList";		
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberID,MemberName,Name,TeamName";
// 		result.cols = "CHK|MemberInfo|MemberID|MemberName|Name|TeamName";
// 		result.widths = "30,70,*,0,0,0,0";
// 		result.sorting = "int,str,str,str,str,str,str";
// 		result.aligns = "center,center,left,center,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 					+ "&teamID="+tid+"&projectID=${projectID}"
// 					+ "&selectMember="+selectMember+"&notInRoleCat=${notInRoleCat}";
					
// 					if($("#searchValue").val() != '' && $("#searchValue").val() != null){
// 						result.data = result.data +"&searchKey="+ $("#searchKey").val();
// 						result.data = result.data +"&searchValue="+ $("#searchValue").val();
// 					}
// 		return result;
		$('#loading').fadeIn(100);
		
		var sqlID = "project_SQL.getMemberList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
				+ "&teamID="+teamID+"&projectID=${projectID}"
				+ "&selectMember="+selectMember+"&notInRoleCat=${notInRoleCat}"
				+ "&sqlID="+sqlID;
				
				// 검색 버튼 누를 경우
				if(!teamID) {
					param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
					param += "&&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
					param += "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
					param += "&selectMember="+selectMember
					param += "&assignmentYN=Y"
					param += "&sqlID="+sqlID;
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
	
	
	function doSearchList2(){// 선택된 멤버
		
		var selectMember = ($('#selectMember').val() == undefined ? "" : $('#selectMember').val());
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "user_SQL.userList"; 
// 		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberID,UserName,TeamName,TeamName";
// 		result.cols = "CHK|MemberInfo|MemberID|UserNAME|TeamNM|TeamID";
// 		result.widths = "30,30,*,1,1,1,1";
// 		result.sorting = "int,int,str,str,str,str,str";
// 		result.aligns = "center,center,left,center,center,center,center";
// 		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_memberIDs="+selectMember;
// 		return result;
		
		var sqlID = "user_SQL.userList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_memberIDs="+selectMember
					+ "&sqlID="+sqlID;
		
					if($("#searchValue").val() != '' && $("#searchValue").val() != null){
						param += "&searchKey="+ $("#searchKey").val();
						param += "&searchValue="+ $("#searchValue").val();
					}
		
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

// 	function doSearchList1(NT){
// 		var d = setGridData1(NT);
// 		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
// 	}
// 	function doSearchList2(){
// 		var d = setGridData1();

// 		var selectMember = ($('#selectMember').val() == undefined ? "" : $('#selectMember').val());

// 		d.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
// 			+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
<%-- 			+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>" --%>
// 			+ "&selectMember="+selectMember
// 			+ "&assignmentYN=Y";
// 		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
// 			d.data = d.data +"&searchKey="+ $("#searchKey").val();
// 			d.data = d.data +"&searchValue="+ $("#searchValue").val();
// 		}
		
// 		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
// 	}
	
	function clearSearchCon() {
		$("#searchKey").val("1").attr("selected", "selected");
		$("#searchValue").val("");
	}
			
	function doClickMove(toRight){
		var sourceGrid, targetGrid;
		if(toRight){
			sourceGrid = gridArea1;
			targetGrid = gridArea2;
		}else{	
			sourceGrid = gridArea2;
			targetGrid = gridArea1;
		}		
// 		var moveRowStr = sourceGrid.getCheckedRows(1);
		var moveRowStr = sourceGrid.data.findAll(e => e.checkbox).length;
		if(moveRowStr == null || moveRowStr.length == 0){alert("${WM00029}");return;}
		var sourceGridData = sourceGrid.data.findAll(e => e.checkbox);
		
		if(toRight){
			for(var i = 0 ; i < sourceGridData.length ; i++){

// 				if(checkSelectItem(gridArea1.cells(sourceGridData[i],3).getValue())) {
				if(checkSelectItem(sourceGridData[i].MemberID)) {
// 					var temp = gridArea1.cells(sourceGridData[i],4).getValue();
					var temp = sourceGridData[i].MemberName;
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+temp+"'/>";
					alert("${WM00162}");
					continue;
				}
				
// 				var newId = Math.random();
// 				targetGrid.addRow(newId, [newId
// 				                          ,"0"
// 				                          ,sourceGrid.cells(sourceGridData[i],2).getValue()
// 				                          ,sourceGrid.cells(sourceGridData[i],3).getValue() 
// 				                          ,sourceGrid.cells(sourceGridData[i],5).getValue()
// 				                          ,sourceGrid.cells(sourceGridData[i],6).getValue()			                          
// 				                          ]				
// 										  , targetGrid.getRowsNum());

				targetGrid.data.add({
					...sourceGridData[i],
					TeamNM : sourceGridData[i].TeamName,
					UserNAME : sourceGridData[i].Name,
				});
		
				if ($('#selectMember').val() == "" || $('#selectMember').val() == undefined) {
					$('#selectMember').val(sourceGridData[i].MemberID);
				} else {
					$('#selectMember').val($('#selectMember').val() + "," + sourceGridData[i].MemberID);
				}
			}
		}else{			
			var tempVal = "";
			for(var i = 0 ; i < sourceGridData.length ; i++){
				var newId = (new Date()).valueOf();

				var beforeDelArray = $('#selectMember').val().split(',');
// 				var delArray = sourceGrid.cells(sourceGridData[i],3).getValue();
				var delArray = sourceGridData[i].MemberID;
				for (var j in beforeDelArray) {
					if (beforeDelArray[j] == delArray) {
						beforeDelArray.splice(j,1);
						break;
					}
				}				
				$('#selectMember').val(beforeDelArray);

// 				if(!checkDeleteItem(gridArea2.cells(sourceGridData[i],3).getValue())) {
				if(!checkDeleteItem(sourceGridData[i].MemberID)) {
					targetGrid.data.add(sourceGridData[i]);
// 					targetGrid.addRow(newId, [newId
// 											  ,"0"
// 											  ,sourceGrid.cells(sourceGridData[i],2).getValue() 
// 											  ,sourceGrid.cells(sourceGridData[i],3).getValue() 
// 											  ,sourceGrid.cells(sourceGridData[i],4).getValue()	
// 											  ,sourceGrid.cells(sourceGridData[i],4).getValue()		
// 											  ,sourceGrid.cells(sourceGridData[i],5).getValue()	
// 											  ], targetGrid.getRowsNum());
					
				}


// 				sourceGrid.deleteRow(sourceGridData[i]);
				sourceGrid.data.remove(sourceGridData[i].id);
			}
				
		}
		
// 		gridArea1.uncheckAll();
// 		gridArea2.uncheckAll();

		// 체크박스 초기화
		gridArea1.data.forEach(e => {
		    gridArea1.data.update(e.id, {checkbox : false})
		});
		
		gridArea2.data.forEach(e => {
		    gridArea2.data.update(e.id, {checkbox : false})
		}) 
		
	}	
	
	function fnAssignMember() {
	
		if(confirm("${CM00001}")){
// 			var checkedRows = gridArea2.getAllRowIds().split(",");
			var checkedRows = gridArea2.data.getRawData();
			 
			var memberIds = "";
			var teamIds = "";
			var memberNames ="";
			
			if(checkedRows.length > 0) {
				for(var i = 0 ; i < checkedRows.length; i++ ){
// 					if (checkedRows[i] != null && checkedRows[i] != '') {
// 						if (memberIds == "") {
// 							memberIds = gridArea2.cells(checkedRows[i], 3).getValue();
// 						} else {
// 							memberIds = memberIds + "," + gridArea2.cells(checkedRows[i], 3).getValue();
// 						}
// 						if (teamIds == "") {
// 							teamIds = gridArea2.cells(checkedRows[i], 6).getValue();
// 						} else {
// 							teamIds = teamIds + "," + gridArea2.cells(checkedRows[i], 6).getValue();
// 						}
		
// 						if (memberNames == "") {
// 							memberNames = gridArea2.cells(checkedRows[i], 4).getValue()+"("+gridArea2.cells(checkedRows[i], 5).getValue()+")";
// 						} else {
// 							memberNames += ", "+gridArea2.cells(checkedRows[i], 4).getValue()+"("+gridArea2.cells(checkedRows[i], 5).getValue()+")";
// 						}
// 					}

					memberIds = checkedRows.map(e => e. MemberID).join(",");
					teamIds = checkedRows.map(e => e. TeamID).join(",");
					memberNames = checkedRows.map(e => e.UserNAME + "(" + e.TeamNM + ")").join(",")
				}
			}
			

			if(mbrRoleType == "R"){ // 참조
				opener.setSharer(memberIds,memberNames);
				self.close();
			} else if(mbrRoleType == "APRV"){ // SR - 추가승인자
				opener.setApprovers(memberIds,memberNames,teamIds);
				self.close();
			} else if(mbrRoleType == "ACTOR"){ // Test Case - 담당자
				opener.setCheckedActors(memberIds,memberNames,teamIds);
				self.close();
			
			} else if(mbrRoleType == "ATTRMBR"){ // ATTR MBR 
				opener.setAttrMbr(memberIds,memberNames,teamIds,"${attrTypeCode}");
				self.close();
			
			} else{
				var url = "admin/assignMembers.do";
				var data = "projectID=${projectID}&teamID=${teamID}&memberIds="+memberIds; 
				var target = "saveFrame";
				
				ajaxPage(url, data, target);
			}
		}	
				
	}
		
	function fnCallBack(){
		parent.opener.searchMember("selectPjtMember.do");
		self.close();
		
	}

	function checkSelectItem(id) {
		return gridArea2.data.map(e => e.MemberID).includes(id);
// 		var gridIDs = gridArea2.getAllRowIds();
// 		var gridIDs = gridArea2.data.map(e => e.MemberID).join(",");

// 		if(gridIDs != null && gridIDs != "") {
// 			gridIDs = gridIDs.split(',');
			
// 			for(var i=0; i < gridIDs.length; i++) {
// 				var check = gridArea2.cells(gridIDs[i],3).getValue();
// 				if(check == id) {
// 					return true;
// 				}
				
// 			}
// 		}
	}

	
	function checkDeleteItem(id) {
		return gridArea1.data.map(e => e.MemberID).includes(id);
// 		var gridIDs = gridArea1.getAllRowIds();

// 		if(gridIDs != null && gridIDs != "") {
// 			gridIDs = gridIDs.split(',');
			
// 			for(var i=0; i < gridIDs.length; i++) {
// 				var check = gridArea1.cells(gridIDs[i],3).getValue();
// 				if(check == id) {
// 					return true;
// 				}
				
// 			}
// 		}
	}

</script>
</head>
<body style="width:100%; height:100%; margin;auto;">
<div id="selectDiv">
<input type="hidden" id="selectMember" name="selectMember" value="${s_memberIDs}" />
<div id="contentwrapper" style="position:absolute;">	
	
	<div class="cmm_member_bar">
		<li class="floatL"><p>* Select members</p></li>
	</div>
	
	<div class="cmm_member_listBox">
		<div class="container" id="container" style="width:100%;float:left;height:320px;"></div>
		<div class="child_search01 floatL" style="width:100%; margin-left:-2px;border-right:0px solid #dfdfdf;">
			<li style="margin-left:10px;padding-left:0px;padding-right:0;">	
				<select id="searchKey" name="searchKey" class="pdL5">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
				<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" OnClick="doSearchList1();">&nbsp;
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">
			</li>
    	</div>
		<table class="floatL" width="100%" border="0"  cellpadding="0" cellspacing="0">
			<tr>
				<td width="100%" align="left" class="pdT5" >
					<div id="gridArea1" style="height:240px!important;width:100%;overflow-x:hidden; border-bottom:0px solid #fff;"></div>
				</td>				
			</tr>
		</table>
	</div>
	
	<div class="cmm_member_btnList">
		<ul>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="Add" type="submit" onclick="doClickMove(true);"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_del.png" /><input value="Del" type="submit" onclick="doClickMove(false);"></li>
		</ul>
	</div>
	
	<div class="cmm_member_selectBox">
		<table class="floatL" width="100%">	
			<tr>				
				<td class="floatL pd0" width="100%" align="left">
					<div id="gridArea2" style="height:500px; width:100%; overflow-x:hidden; border-top:1px solid #dfdfdf;"></div>
				</td>
				<td class="cmm_member_save">
					<span id="save" class="btn_pack medium icon"><span class="save"></span>
					<input value="Save" type="submit" onclick="fnAssignMember()">
					</span>
				</td>
			</tr>
		</table>
	</div>
	
</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
</div>
</body>
</html>
