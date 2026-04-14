<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; charset=utf-8"></meta>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<style>
#schTreeArea * {
	    box-sizing: content-box;
	}
	
    #schTreeArea a:nth-child(2) {
        position: relative;
/*         top: 2px; */
        right: 23px;
        cursor: pointer;
    }

    #schTreeArea a:nth-child(3) {
	    position: relative;
	    right: 10px;
/* 	    top: 3px; */
	    cursor: pointer;
	    /* border-right: 1px solid #ccc; */
	    display: inline-block;
	    background: #f2f2f2;
	    padding: 3px 3px 3px 3px;
	    border-radius: 4px;
    }

    #schTreeArea a:nth-child(4) {
/*         position: relative; */
/*         right: 10px; */
/*         top: 2px; */
/*         cursor: pointer; */
/*         background: #f2f2f2; */
/*         padding: 3px 4px 9px; */
/*         border-radius: 0 4px 4px 0; */

/*         top: 2px; */
        right: 5px;
        position: relative;
        cursor: pointer;
    }

    #schTreeArea a:nth-child(5) {
        top: -1px;
/*         right: 5px; */
        position: relative;
        cursor: pointer;
    }
    
	.resizer {
		cursor: w-resize;
		border: none !important;
	}
	   
	.resizer:after {
		content: "";
		position: absolute;
		z-index: 9999999;
		top: 50%;
		left: 2px;
		height: 25px;
		width: 25px;
		margin-top: -9px;
		border-left: 1px solid #d2d2d2;
	}
	   
	   /* 드래그 가이드 */
	#guide {
		position: absolute;
		top: 0;
		bottom: 0;
		width: 5px;
		background-color: #a4bed4;
		pointer-events: none;
		display: none;
		z-index: 9999;
	}
	
	.resizing #item-load {
		pointer-events: none;
	}
</style>
<script type="text/javascript">
	let resizer = "";
	let left = "";
	let container = "";
	let iframe = "";
	let guide = "";

	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	window.onload=setOrgFrmInit;
	jQuery(document).ready(function() {
		var unfold = "${unfold}";
		fnGetCategory("${arcCode}");
		if("${nodeID}" == "" &&(unfold != "false" || unfold == '')){ setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});		
	});
	function fnSetUnfoldTree(){
// 		if(olm.menuTree!=null){
// 			olm.menuTree.closeAllItems(0);
// 			var ch = olm.menuTree.hasChildren(0);
// 			for(var i=0; i<ch; i++){
// 				var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);
// 				olm.menuTree.openItem(lev1);
// 			}
// 		}
	}
	function setOrgFrmInit(){
		$("#containerOrg").attr("style", "display:block;width:"+getWidth()+"px;height:"+getHeight()+"px;border: 0;");
		document.all.containerOrg.width = (getWidth()) + "px"; 
		document.all.containerOrg.height = (getHeight()) + "px"; 		
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	}	
	function getHeight(){return (document.body.clientHeight);}
	function getWidth(){return (document.body.clientWidth);}
	function setScreenResize(){ 
		document.getElementById('containerOrg').style.height=getHeight()+'px';
		document.getElementById('containerOrg').style.width=getWidth()+'px';
		if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);} baseLayout.setSizes();}
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
	function setInitOneLayout(viewType){
// 		cntnLayout = new dhtmlXLayoutObject("containerOrg",viewType);
	}
	var nodeID = "${nodeID}";
	var selectedItemID  ="";
	var dhx_cell_hdr_height = 43;
	if("${loadType}" == "multi"){ dhx_cell_hdr_height = 73; }
	
	let isDragging = false;
	let containerLeft = 0;
	
	function setInitTwoLayout(){
		document.getElementById('containerOrg').style.height = (getHeight()) + "px"; 	
		
		if("${loadType}" == "multi"){
			var scrpt = new Object();
			scrpt.treeTop = "<div id='selectTreeArea' style='padding: 4px 15px 10px 5px; border-bottom:1px solid #dfdfdf;'>";
			<c:forEach var="list" items="${arcList}" varStatus="sts">
				if("${arcCode}" == "${list.ArcCode}"){
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);' checked='checked' >&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}else{
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);'>&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}
			</c:forEach>
			scrpt.treeTop= scrpt.treeTop+"</div>";
			
// 			scrpt.treeTop = scrpt.treeTop + "<div id='schTreeArea' style='margin-top:3px;'>";
// 			scrpt.treeTop = scrpt.treeTop +"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a> <a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
// 			scrpt.treeTop = scrpt.treeTop +"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
// 			scrpt.treeTop = scrpt.treeTop +"</div>";

			scrpt.treeTop=scrpt.treeTop+"<div id='schTreeArea' class='flex align-center justify-between pdB5 pdT5'>";
			scrpt.treeTop=scrpt.treeTop+"<div style='font-size:0px;' class='align-center flex'>";
			scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button onclick='foldingTreeArea()' data-id='tree-close' class='flex'><div class='dxi dxi-chevron-left'></div></button>"
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button class='none' data-id='tree-open' onclick='foldingTreeArea()' style='height:100%;'><div class='dxi dxi-chevron-right'></div></button>"
			
			scrpt.cntnTop = "";
		}else{
			var scrpt = new Object();
			scrpt.treeTop="<div id='schTreeArea' class='flex align-center justify-between h-100'>";
			scrpt.treeTop=scrpt.treeTop+"<div style='font-size:0px;' class='align-center flex'>";
			scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button onclick='foldingTreeArea()' data-id='tree-close' class='flex'><div class='dxi dxi-chevron-left'></div></button>"
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button class='none' data-id='tree-open' onclick='foldingTreeArea()' style='height:100%;'><div class='dxi dxi-chevron-right'></div></button>"
			scrpt.cntnTop="";
		}
		
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}
		if("${loadType}" == "multi"){if($("#selectTreeArea").length>0){$("#selectTreeArea").remove();}}
		/*$("#divCntnTop").show();*/
		//if("${loadType}" == "multi"){baseLayout.skinParams.dhx_skyblue.cpanel_height = 75;}else{baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;}

		
		baseLayout = new dhx.Layout("containerOrg", {
			type: "line",
			cols: [
				{
					id: "leftPanel",
					width: "300px",
		            minWidth: "230px",
		            maxWidth: "600px",
					type: "line",
// 					collapsable :true,
// 					resizable : true,
// 					header : arcName,
					rows: [
						{
							id :"searchArea",
							height: "auto"
						},
						{
							id: "treeArea",
						},
						
					]
				},
				{
					id : "resizer",
					width : "5px",
					css : "resizer"
				},
				{
				   id: "rightPanel",
				   header: false // 헤더 제거
				 }
			]
     	});
		
		resizer = document.querySelector(".dhx_layout-cell[data-cell-id='resizer']")
		left = document.querySelector(".dhx_layout-cell[data-cell-id='leftPanel']")
		container = document.querySelector('#containerOrg');
		iframe = document.querySelector("#item-load")
		guide = document.querySelector("#guide")
		
// 		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
        baseLayout.getCell("searchArea").attachHTML(scrpt.treeTop);
        
        const treeArea = baseLayout.getCell("treeArea");
    	
        // Tree 붙일 위치 지정된 div에 Tree 생성
        olm.menuTree = new dhx.Tree(null, {
            icon: {
                folder: "dxi icon-csh_organization-closed",
                openFolder: "dxi icon-csh_organization-open",
                file: "dxi icon-csh_organization"
            },
        	selection: true,
        	itemHeight: 30,
          dragMode: "both",
          data: []
        });
        treeArea.attach(olm.menuTree);
        
        olm.menuTree.events.on("itemClick", function(id) {
          const item = olm.menuTree.data.getItem(id);
          olm.getMenuUrl(id, '', '', item.value);
        });
        
        // 우측 레이아웃 셀
        cntnLayout = baseLayout.getCell("rightPanel");
        mainLayout = baseLayout.getCell("rightPanel");
        
		resizer.addEventListener('mousedown', (e) => {
			//     		console.log(e)
			isDragging = true
			containerLeft = container.getBoundingClientRect().left
			
			console.log(resizer.offsetLeft)
			guide.style.display = 'block'
			guide.style.left = resizer.offsetLeft+"px"
			
			document.body.style.userSelect = 'none'
			 	  
			if (iframe) {
				iframe.style.pointerEvents = 'none'
			}
		})
	}
	
	document.addEventListener('mousemove', (e) => {
		if (!isDragging) return
		
		const x = e.clientX - containerLeft
		guide.style.left = x+"px"
		console.log(guide.offsetLeft)
		
		container.classList.add('resizing');
	})

	document.addEventListener('mouseup', () => {
		if (!isDragging) return
		isDragging = false
		
		guide.style.display = 'none'
		document.body.style.userSelect = ''
		
		// 🔥 여기서만 실제 width 계산
		const finalX = guide.style.left;
		console.log(finalX)
		left.style.width = finalX;
		
		container.classList.remove('resizing');
		if (iframe) {
			iframe.style.pointerEvents = ''
		}
	})
  	
	function test() {
		console.log("test");
		const leftPanel = document.querySelector(".dhx_layout-cell[data-cell-id='leftPanel']");
		const opener = document.querySelector("button[data-id='tree-open']");
		if(opener.classList.contains("none")) {
			opener.classList = "block";
			leftPanel.style.width = "auto";
			leftPanel.style.minWidth = "";
			document.querySelector("#schTreeArea").style.display = "none";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "none";
		} else {
			opener.classList = "none";
			leftPanel.style.width = "300px";
			leftPanel.style.minWidth = "200px";
			document.querySelector("#schTreeArea").style.display = "";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "block"
		}
	}
	
	function fnSetLoading(){
		if(nodeID == '' ){return;}
		var id = "${nodeID}"; 		
		if(id == '' || id == 'undefined' || id == '' || selectedItemID != ''){
			if(id != selectedItemID){return; }
		}
		var ids = id;
		//getTreeSubItems('');
		currItemId=id;
		$('#menuID').val(currItemId); 
		creatMenuTab(currItemId,"1");
		
		if(id != ""){			
			olm.menuTree.selectItem(currItemId,false,false);
			olm.getMenuUrl(id);
			olm.menuTree.openItem(id);
		}
		nodeID = "";
	}
	
// 	function setLayoutResize(){
// 		var minWidth=lMinWidth+rMinWidth;
// 		var lWidth=baseLayout.items[0].getWidth(); 
// 		var rWidth=baseLayout.items[1].getWidth();
// 		var wWidth=document.body.clientWidth;
// 		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
// 		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}}	
		
	olm.getMenuUrl=function(id){
		console.log(id)
// 		var ids = id.split("_");  
		var ids = id;
		currItemId=id;
		$('#menuID').val(currItemId); 
		//creatMenuTab(currItemId,"1");
		fnGetTeamID(currItemId, "1");
		
		//document.orgFrm.action = "organizationInfoView.do";
		//document.orgFrm.target="blankFrame";
		//document.orgFrm.submit();
	};
	
	var selectedItemID  ="";
		
	function fnGetTeamID(itemID, level){ 
		var url = "getTeamID.do";
		var target = "blankFrame";	
		var data = "&teamID="+itemID+"&level="+level;
		
		ajaxPage(url, data, target);
	} 
	
	var menuOption = "";	
	function creatMenuTab(id,level,actionYN){ 
		if(actionYN == 'N'){ return; }
		var fullId = "";
		var text = "";
		var url = "orgMainInfo.do?defItemTypeCode=${defItemTypeCode}&option="+menuOption+"&level="+level+"&subTeam=${subTeam}";
		if(id!="null" && id!=""){url=url+"&id="+id;}
		
		olm.create_tab(id, fullId, text, url, true);
	}	
	
	olm.create_tab=function(id,fullId,text,url,isInclude){ 
		if(id == ""){id=menuOption;}
		fullId=id;
		var cntnTitle=""; 
		if(olm.menuTree==null){
			cntnTitle=text;
		}else{
// 			cntnTitle=text||olm.menuTree.getItemText(id);
		}
		
		var fullText=$("#menuFullTitle").val();
		fullText=fullText + "&nbsp;>&nbsp;" + cntnTitle;
			
		if(!olm.url[fullId]){
			olm.url[fullId]=fullId+"^"+url;
// 			mainLayout.attachURL(url);
			mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")
		}else{
			olm.url[fullId]=fullId+"^"+url;
// 			mainLayout.attachURL(url);
			mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")
		}
		
// 		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	};	
		
	function fnGetCategory(avg){
		setInitTwoLayout();
		menuOption = avg;
// 		olm.menuTree.getSelectedItemId();
// 		olm.menuTree.deleteChildItems(0);
		var data="rootTeamID=${rootTeamID}&defItemTypeCode=${defItemTypeCode}";		
		var d=fnSetMenuTreeData(data);
// 		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 
		setTreeData("menuId="+d.key+"&SelectMenuId="+avg+"&"+d.data+"&cols="+d.cols)
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
	}
	
	async function setTreeData(queryData){
		$('#loading').fadeIn(100);
		const url = "jsonDhtmlxTreeListData.do?"+new URLSearchParams(queryData).toString();
		
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}
	
			const res = await response.json();
			// success 필드 체크
			if (!res.success) {
				throw throwServerError(result.message);
			}
	
			if (res && res.data) {				
				if(res.data.length > 0) olm.menuTree.data.parse(res.data);
				else {
					Promise.all([
						getDicData("BTN", "LN0034"), // 닫기
					]).then(results => {
						showDhxAlert("${WM00018}", results[0].LABEL_NM);
					});
				}
				
				if(nodeID != "") {
					var id = nodeID;
					if(id == '' || id == 'undefined' || id == '' || selectedItemID != ''){
						if(id != selectedItemID){return; }
					}
					if(id != ""){
						console.log("id", id)
						olm.menuTree.focusItem(id);
			   			olm.menuTree.selection.add(id);
			   			olm.menuTree.expand(id);
			   			olm.menuTree.data.eachParent(id, e => olm.menuTree.expand(e.id))
			    		olm.getMenuUrl(id);
					}
					nodeID = "";
				}
			} else {
				return;
			}
	
		} catch (error) {
			handleAjaxError(error);
		} finally {
			$('#loading').fadeOut(100);
		}
	}
	
// 	function searchTreeText(type){var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
// 		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
// 	}
	
  	let searchItem = [];
  	let oldText = "";
  	let currentIndex = 0;
  	function searchTreeText(type){
  		var schText=$("#schTreeText").val();
  		if(schText==""){alert("${WM00045}"); return false;}
  		
		if(type == "1") search()
		else if(type == "2") focusPrev()
		else if(type == "3") focusNext()
		
  		oldText = schText;
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
		olm.menuTree.selection.add(id);
		olm.menuTree.focusItem(id);
		olm.getMenuUrl(id);
	}

	function searchText() {
		const input = document.querySelector("#schTreeText");
		if (!input) return;

		const query = normalizeText(input.value);
		if (!query) return;

		clearSearch();

		const matches = [];
		olm.menuTree.data.forEach((item) => {
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
		if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
// 			itemId = olm.menuTree.getSelectedItemId();
			itemId = olm.menuTree._focusId;
		}
		currItemId = itemId;
// 		olm.menuTree.deleteChildItems(0);
// 		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		setTreeData("menuId="+d.key+"&SelectMenuId="+menuOption+"&"+d.data+"&cols="+d.cols)
// 		if(isReload){olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}
	}
	
	function setLoadingEndTree(prtItemId){
		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
		olm.menuTree.openItem(prtItemId);if(currItemId == null || currItemId == 'undefined'){return false;}else{olm.menuTree.selectItem(currItemId,false,false);}}	

	function fnCheckArc(arcCode){
		<c:forEach var="list" items="${arcList}" varStatus="sts">
		if(arcCode == "${list.ArcCode}"){	
			$("#varFilter").val("${list.VarFilter}");
			$("#arcFilterType").val("${list.FilterType}");
			
			parent.clickMainMenu(arcCode,'','','','${list.MenuStyle}','','${list.URL}.do?${list.VarFilter}&loadType=${loadType}');
			
		}
		</c:forEach>
		
	}
	
	function foldingTreeArea() {		
		const leftPanel = document.querySelector(".dhx_layout-cell[data-cell-id='leftPanel']");
		const opener = document.querySelector("button[data-id='tree-open']");
		if(opener.classList.contains("none")) {
			opener.classList = "block";
			leftPanel.style.width = "auto";
			leftPanel.style.minWidth = "";
			document.querySelector("#schTreeArea").style.display = "none";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "none";
		} else {
			opener.classList = "none";
			leftPanel.style.width = "300px";
			leftPanel.style.minWidth = "200px";
			document.querySelector("#schTreeArea").style.display = "";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "block"
		}
	}
	
	/**
	 * @function handleAjaxError
	 * @description 데이터 로드 실패 시 에러 메시지 팝업 출력
	 * @param {Error} err - 발생한 에러 객체
	*/
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
</script>
</head>
<body style="width:100%; height:100%;">
<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="menuID" name="menuID"></input>
<div id="contentwrapper" style="position:absolute;">				
		<div id="contentcolumn" >		
			<div class="containerOrg" id="containerOrg" name="containerOrg" scrolling='no'></div>	
		</div>
	</div>
	<!-- 드래그 중에만 보이는 가이드 -->
	<div id="guide"></div>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0"></iframe>
</form>
</body>
</html>
