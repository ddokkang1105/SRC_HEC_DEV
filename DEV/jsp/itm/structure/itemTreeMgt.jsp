<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00170" var="WM00170" />

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
	
	/* 특정 클래스에 색상으로 스타일 주기  */
	/*
	.CL01005 .dhx_tree-list-item__text {
		color : red;
	}
	
	.CL01006 .dhx_tree-list-item__text {
		color : blue;
	}
	 */
</style>
<script type="text/javascript">
let resizer = "";
let left = "";
let container = "";
let iframe = "";
let guide = "";

const iconConvertToClassIcon = ["CL01005", "CL01006"]
const objClassList = "${objClassList}".split(",").filter(e => e !== '');

// 프로세스, 조직도, 다큐먼트(sop에 설정되어있는 스타일, 각 클래스마다 아이콘 다를 수 있음), 폴더(cfg 메뉴 같은 스타일)
let icon_set = {
    csh_process : {
		folder: "dxi icon-csh_process_blue-closed",
		openFolder: "dxi icon-csh_process_blue-open",
		file: "dxi icon-csh_process_blue"
    },
    csh_grayprocess : {
		folder: "dxi icon-csh_process-closed",
		openFolder: "dxi icon-csh_process-open",
		file: "dxi icon-csh_process"
    },
    csh_system : {
		folder: "dxi icon-csh_system-closed",
		openFolder: "dxi icon-csh_system-open",
		file: "dxi icon-csh_system"
    },
    csh_document : {
		folder: "dxi icon-csh_document-closed",
		openFolder: "dxi icon-csh_document-open",
		file: "dxi icon-csh_document"
    },
    csh_document_blue : {
		folder: "dxi icon-csh_document_blue-closed",
		openFolder: "dxi icon-csh_document_blue-open",
		file: "dxi icon-csh_document_blue"
    },
	csh_organization : {
		folder: "dxi icon-csh_organization-closed",
		openFolder: "dxi icon-csh_organization-open",
		file: "dxi icon-csh_organization"
    },
	csh_job : {
		folder: "dxi icon-csh_organization-closed",
		openFolder: "dxi icon-csh_organization-open",
		file: "dxi icon-csh_organization"
    },
    csh_grayorganization : {
		folder: "dxi icon-csh_organization-closed",
		openFolder: "dxi icon-csh_organization-open",
		file: "dxi icon-csh_organization"
    },
    csh_yellowbooks : {
		folder: "dxi icon-csh_yellowbooks-closed",
		openFolder: "dxi icon-csh_yellowbooks-open",
		file: "dxi icon-csh_yellowbooks"
    },
    csh_books : {
		folder: "dxi icon-csh_yellowbooks-closed",
		openFolder: "dxi icon-csh_yellowbooks-open",
		file: "dxi icon-csh_yellowbooks"
    },
    csh_bluebooks : {
		folder: "dxi icon-csh_folder_blue-closed",
		openFolder: "dxi icon-csh_folder_blue-open",
		file: "dxi icon-csh_folder_blue"
    },
    csh_bluefolders : {
		folder: "dxi icon-csh_folder_blue-closed",
		openFolder: "dxi icon-csh_folder_blue-open",
		file: "dxi icon-csh_folder_blue"
    },
    csh_dhx_skyblue : {
		folder: "dxi icon-csh_folder_blue-closed",
		openFolder: "dxi icon-csh_folder_blue-open",
		file: "dxi icon-csh_folder_blue"
    },
    csh_vista : {
		folder: "dxi icon-csh_folder-closed",
		openFolder: "dxi icon-csh_folder-open",
		file: "dxi icon-csh_folder"
    },
    csh_winstyle : {
		folder: "dxi icon-csh_folder-closed",
		openFolder: "dxi icon-csh_folder-open",
		file: "dxi icon-csh_folder"
    },    
}

	var olm={};
	olm.pages={};
	olm.url={};
	olm.menuTree={};
	
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";
	var arcDefPage = "${arcDefPage}";
	var pageUrl = "${pageUrl}";
	var defMenuItemID = "${defMenuItemID}";
	var topMenuCnt={};
	var currItemId="";
	var mainLayout;
	var tmplCode="";
	var isTempLoad={};
	var homeUrl;
	var showPreNextIcon = "Y";
	var scrnMode = "${scrnMode}";
	var strType = "${strType}";
	window.onload=setItmFrmInit;
	
	jQuery(document).ready(function() {
		var unfold = "${unfold}";
		fnGetCategory("${arcCode}");
		if((unfold != "false" || unfold == '')){setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		

		
		if(defMenuItemID == "")
			defMenuItemID = "${nodeID}";
		
		setCookie('itemIDs', '', -1);
		
		if("${popupUrl}"){
			fnOpenPopupUrl("${popupUrl}?arcCode=${arcCode}&defaultClassCodes=${defaultClassCodes}&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}");
		}
	});
	

	// Arc Menu Name
	async function getArcMenuName(languageID, arcCode, dimValueID){
		console.log("getArcMenuName")
		$('#loading').fadeIn(150);
		
	    const requestData = { languageID, arcCode, dimValueID };
	    
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getArcMenuName.do?" + params;
	    
	    try {
	        const response = await fetch(url, {
	            method: 'GET',
	        });
	        
	        if (!response.ok) {
	            throw new Error(`HTTP error! status: ${response.status}`);
	        }
	        
	        const data = await response.json();
	        
	        if(data.data){
	            return data.data.map(e => e.Name).join(" / ");
	        } else {
	        	throw new Error(`Problem with data occured: ${data}`)
	        }
	        
	    } catch (error) {
	    	
	  		Promise.all([
				getDicData("ERRTP", "LN0014"), 
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
	  		
	    	console.error(error.message);
	    } finally {
	    	$('#loading').fadeOut(150);
	    }
	}
	
   	function fnSetUnfoldTree(nodeID){
   		console.log("fnSetUnfoldTree");
   	}
   	
   	function setItmFrmInit(){
   		console.log("setItmFrmInit")
   		$("#containerItm").attr("style", "display:block;width:"+getWidth()+"px;height:"+getHeight()+"px;border: 0;");
//    		document.getElementById('containerItm').style.height=getHeight()+'px';
   		
   		if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
   		else window.addEventListener("resize",resizeLayout, false);
   		
   		var t;
   		function resizeLayout(){
   			window.clearTimeout(t);
   			t=window.setTimeout(function(){setItmFrmScreenResize();},200);
		}
   	}
   	
	function getHeight(){return (document.body.clientHeight);}
	function getWidth(){return (document.body.clientWidth);}
	function setItmFrmScreenResize(){ 
		document.getElementById('containerItm').style.height=getHeight()+'px';
		document.getElementById('containerItm').style.width=getWidth()+'px';
// 		if( baseLayout==null){
// 			if(cntnLayout!=null && cntnLayout!=undefined)cntnLayout.setSizes();
// 		}else{
// 			var minWidth=lMinWidth+rMinWidth;
// 			var wWidth=document.body.clientWidth;
// 			if(minWidth>wWidth) baseLayout.items[0].setWidth(lMinWidth);
// 			baseLayout.setSizes();
// 		}
	}
	function setInitMenu(isLeft, isMain){
		console.log("setInitMenu")
		if(isMain) $("#menusection").attr("style","display:block;");
		else$("#menusection").attr("style","display:none;");
		setItmFrmScreenResize();
	}
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
// 		cntnLayout = new dhtmlXLayoutObject("containerItm",viewType);	
	}
	
	
	var nodeID = "${nodeID}";
	var dhx_cell_hdr_height = 43;
	if("${loadType}" == "multi"){ dhx_cell_hdr_height = 73; }
	
	let isDragging = false;
	let containerLeft = 0;
	
	async function setInitTwoLayout(){
		const arcName = await getArcMenuName("${sessionScope.loginInfo.sessionCurrLangType}", "${arcCode}", "${defDimValueID}");
		console.log("setInitTwoLayout")
		document.getElementById('containerItm').style.height=getHeight()+'px';		
		
		if("${loadType}" == "multi"){
			var scrpt = new Object();
			scrpt.treeTop = "<div id='selectTreeArea' class='selectTreeArea' style='padding: 5px 15px 10px 5px;border-bottom:1px solid #dfdfdf;'>";
			<c:forEach var="list" items="${arcList}" varStatus="sts">
				if("${arcCode}" == "${list.ArcCode}"){
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);' checked='checked' >&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}else{
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);'>&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}
			</c:forEach>
			scrpt.treeTop= scrpt.treeTop+"</div>";
			
// 			scrpt.treeTop = scrpt.treeTop + "<div id='schTreeArea' style='margin-top:5px;'>";
// 			scrpt.treeTop = scrpt.treeTop +"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
// 			scrpt.treeTop = scrpt.treeTop +"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
// 			scrpt.treeTop = scrpt.treeTop +"</div>";
			
			scrpt.treeTop=scrpt.treeTop+"<div id='schTreeArea' class='flex align-center justify-between pdB5 pdT5'>";
			scrpt.treeTop=scrpt.treeTop+"<div style='font-size:0px;' class='align-center flex'>";
			scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnOpenAllItems(1)'><img src='${root}cmm/common/images/tree_open.png' id='forderImg' style='margin-left:5px;cursor:pointer;' title='Expand'></a>";
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button onclick='foldingTreeArea()' data-id='tree-close' class='flex'><div class='dxi dxi-chevron-left'></div></button>"
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button class='none' data-id='tree-open' onclick='foldingTreeArea()' style='height:100%;'><div class='dxi dxi-chevron-right'></div></button>"
			
			scrpt.cntnTop = "";
		}else{
			// var scrpt = fnSetScriptMasterDiv();
			var scrpt = new Object();
			scrpt.treeTop="<div id='schTreeArea' class='flex align-center justify-between pdB5 pdT5'>";
			scrpt.treeTop=scrpt.treeTop+"<div style='font-size:0px;' class='align-center flex'>";
			scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnOpenAllItems(1)'><img src='${root}cmm/common/images/tree_open.png' id='forderImg' style='margin-left:5px;cursor:pointer;' title='Expand'></a>";
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button onclick='foldingTreeArea()' data-id='tree-close' class='flex'><div class='dxi dxi-chevron-left'></div></button>"
			scrpt.treeTop=scrpt.treeTop+"</div>";
			scrpt.treeTop=scrpt.treeTop+"<button class='none' data-id='tree-open' onclick='foldingTreeArea()' style='height:100%;'><div class='dxi dxi-chevron-right'></div></button>"
			scrpt.cntnTop="";
			
		}
		
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();} 
		if("${loadType}" == "multi"){	if($("#selectTreeArea").length>0){$("#selectTreeArea").remove();} }
		/*$("#divCntnTop").show();*/
// 		baseLayout=new dhtmlXLayoutObject("containerItm",layout_2U,dhx_skin_skyblue);
		// if("${loadType}" == "multi"){ baseLayout.skinParams.dhx_skyblue.cpanel_height = 75; } else { baseLayout.skinParams.dhx_skyblue.cpanel_height = 44; }
		
		baseLayout = new dhx.Layout("containerItm", {
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
		container = document.querySelector('#containerItm');
		iframe = document.querySelector("#item-load")
		guide = document.querySelector("#guide")
		
// 		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");
        baseLayout.getCell("searchArea").attachHTML(scrpt.treeTop);
        
        const treeArea = baseLayout.getCell("treeArea");
    	
        // Tree 붙일 위치 지정된 div에 Tree 생성
        olm.menuTree = new dhx.Tree(null, {
//             icon: {
//                 folder: "dxi icon-folderClosed",
//                 openFolder: "dxi icon-folderOpen",
//                 file: "dxi icon-leaf"
//             },
            icon: {
                folder: icon_set[treeImgPath].folder,
                openFolder: icon_set[treeImgPath].openFolder,
                file: icon_set[treeImgPath].file
            },
        	selection: true,
        	itemHeight: 30,
          dragMode: "both", // drag and drop 가능
//           checkbox: false,  // checkbox 비활성화 (원할 경우 true)
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
        
//         if( nodeID != ""){	olm.menuTree.setOnLoadingEnd(fnSetLoading);}
//         if( nodeID != "") fnSetLoading();
        
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
		
		if(arcDefPage != '' && arcDefPage != null){
			fnArcDefPage("${arcCode}",arcDefPage,pageUrl,defMenuItemID);
		}
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
  	
	function foldingTreeArea() {
		// loadType multi 일 경우
		const selectTreeArea = document.querySelector("#selectTreeArea");
		
		const leftPanel = document.querySelector(".dhx_layout-cell[data-cell-id='leftPanel']");
		const opener = document.querySelector("button[data-id='tree-open']");
		if(opener.classList.contains("none")) {
			opener.classList = "block";
			leftPanel.style.width = "auto";
			leftPanel.style.minWidth = "";
			document.querySelector("#schTreeArea").style.display = "none";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "none";
			if (selectTreeArea) selectTreeArea.style.display = "none";
		} else {
			opener.classList = "none";
			leftPanel.style.width = "300px";
			leftPanel.style.minWidth = "200px";
			document.querySelector("#schTreeArea").style.display = "";
			document.querySelector(".dhx_layout-cell[data-cell-id='treeArea']").style.display = "block"
				if (selectTreeArea) selectTreeArea.style.display = "block";
		}
	}
	
// 	function setLayoutResize(){	 
//    		var minWidth=lMinWidth+rMinWidth;
//    		var lWidth=parseInt(baseLayout.getCell("leftPanel").config.width, 10);
//    		var rWidth=parseInt(baseLayout.getCell("rightPanel").config.width, 10);
//    		var wWidth=document.body.clientWidth;
//    		if(lWidth<lMinWidth){
//     		baseLayout.getCell("leftPanel").config.width = lMinWidth;
//     		baseLayout.getCell("rightPanel").config.width = wWidth - lMinWidth;
//     		baseLayout.paint(); // 변경사항 적용
//    		}
//    		if(wWidth >= minWidth && rWidth < rMinWidth){
//    			baseLayout.getCell("leftPanel").config.width = wWidth - rMinWidth;
//    			baseLayout.getCell("rightPanel").config.width = rMinWidth;
//    			baseLayout.paint(); // 변경사항 적용
//    		}
// 	}
	
	var selectedItemID  ="";
	
	olm.getMenuUrl=function(id, preNext, currIdx){
// 		var ids = id.split("_");  
		var ids = id;
		selectedItemID = ids;
		getTreeSubItems('');
		currItemId=ids[0];
		
		// Item AccessOption 
		if( '${loginInfo.sessionMlvl}' != "SYS" && id != -1 ){
			fnCheckUserAccRight(id, "fnTreeload('"+id+"','"+preNext+"','"+currIdx+"')", "${WM00033}", "${WM00170}");
		} else {
			fnTreeload(id, preNext, currIdx);
		}
	};
		
	function fnTreeload(currItemId, preNext, currIdx){
		console.log("fnTreeload")
		$('#menuID').val(currItemId); 
		fnGetItemClassMenuURL(currItemId, currIdx); // itemClass menuID
		
		if(preNext != "Y"){
			var itemIDs = getCookie('itemIDs'); 
			fnAddCookie(currItemId, itemIDs,'itemIDs');
		}
	}
	
	fnGetMenuUrl=function(id){
		creatMenuTab(id,"1");
	};
	
	function fnGetItemClassMenuURL(itemID, currIdx){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";	
		var data = "&itemID="+itemID+"&currIdx="+currIdx+"&strType="+strType;
		
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID, currIdx, strItemID, mstItemID, actionYN){
		var url = menuURL+".do?itemID="+itemID+"${arcVarFilter}&scrnMode="+scrnMode
				+"&showTOJ=${showTOJ}&showVAR=${showVAR}&ownerType=${ownerType}&accMode=${accMode}"
				+"&itemClassMenuUrl="+menuURL+"&currIdx="+currIdx+"&strItemID="+strItemID+"&arcCode=${arcCode}"
				+"&showPreNextIcon="+showPreNextIcon+"&tLink=${tLink}&mstItemID="+mstItemID+"&showLink=${showLink}"
				+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}&strType="+strType;
		scrnMode="";
		mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")
	}
	
	function fnSetLoading(){
		if(nodeID == '' ){return;}
		var id = "${nodeID}";
		if(id == '' || id == 'undefined' || id == '' || selectedItemID != ''){
			if(id != selectedItemID){return; }
		}
		var ids = id;
		currItemId=id;
		$('#menuID').val(currItemId); 
		//creatMenuTab(currItemId,"1");
		if(id != ""){
// 			olm.menuTree.selectItem(currItemId,false,false);
// 			olm.getMenuUrl(id);
// 			olm.menuTree.openItem(id);
//    			olm.getMenuUrl(id);
			olm.menuTree.focusItem("${nodeID}");
   			olm.menuTree.selection.add("${nodeID}");
//    			olm.menuTree.expand("${nodeID}");
   			olm.menuTree.data.eachParent("${nodeID}", e => olm.menuTree.expand(e.id))
		}
// 		getTreeSubItems('');
		nodeID = "";
	}
	
	function getTreeSubItems(subItems){
// 		const selectedId  = olm.menuTree.selection.getId();
		const selectedId  = olm.menuTree._focusId;
		console.log("selectedId", selectedId)
		if( subItems == 'undefined' || subItems == null || subItems == ''){ 
			if( olm.menuTree != null){
// 				subItems = olm.menuTree.getSubItems(olm.menuTree.getSelectedItemId());
				let subItem = [];
				olm.menuTree.data.eachChild(selectedId, item => {
					subItem.push(item.id);
				}, false);
				subItems = subItem.join(",");
			}else{subItems = "";}
		}
		if( olm.menuTree != null){
// 			itemId = olm.menuTree.getSelectedItemId();
			
		}
		var url = "setSessionParameter.do";
		var target = "blankDiv";
		var data = "subItems="+subItems+"&ItemId="+selectedId;

		ajaxPage(url, data, target);
	}	
	
	var menuOption = "";	
	function creatMenuTab(id,level,varFilter = "",currIdx,strItemID,mstItemID,actionYN){
		var fullId = "";
		var text = "";
		try{ var openItemIDs = getCookie('itemIDs').split(','); }catch(e){}
		
		var url = "itemMainMgt.do?option="+menuOption
				+"&level="+level+varFilter
				+"&openItemIDs="+openItemIDs
				+"&currIdx="+currIdx
				+"&showPreNextIcon="+showPreNextIcon
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}"
				+"&accMode=${accMode}"
				+"&defDimValueID=${defDimValueID}"
				+"&strItemID="+strItemID
				+"&mstItemID="+mstItemID
				+"&showLink=${showLink}"
				+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}"
				+"&multiDimType=${multiDimType}"
				+"&sqlXmlCode=${sqlXmlCode}"
				+"&itemID="+id
				+"${arcVarFilter}"
				+"&strType="+strType
				+"&scrnMode="+scrnMode
				+"&showVAR=${showVAR}"
				+"&ownerType=${ownerType}"
				+"&accMode=${accMode}"
				+"&itemClassMenuUrl=itemMainMgt"
				+"&arcCode=${arcCode}"
				
		
		if(id < 0){ return; }
		if(id!="null" && id!=""){url=url+"&id="+id;}
		olm.create_tab(id, fullId, text, url, true);
	}	
	
	olm.create_tab=function(id,fullId,text,url,isInclude){
		console.log("olm.create_tab")
		if(id == "") id=menuOption;
		fullId=id;
		var cntnTitle="";
   		if(olm.menuTree == null) cntnTitle=text;
   		else cntnTitle=text;
		
		var fullText=$("#menuFullTitle").val();
		fullText=fullText + "&nbsp;>&nbsp;" + cntnTitle;
			
		if(!olm.url[fullId]){
			olm.url[fullId]=fullId+"^"+url;
			mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")

		}else{
			olm.url[fullId]=fullId+"^"+url;
			mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")

		}
		
// 		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	};	
		
	async function fnGetCategory(avg, avg2, avg3){
		console.log("fnGetCategory")
		$("#loading").fadeOut(50);
		
		// 레이아웃, 트리 정의
		await setInitTwoLayout();
		menuOption = avg;
// 		olm.menuTree.getSelectedItemId();
// 		olm.menuTree.selection.getId();
// 		olm.menuTree.deleteChildItems(0);
// 		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height + "px");
		var data="sortOption=${sortOption}&showTOJ=${showTOJ}&showVAR=${showVAR}&defDimValueID=${defDimValueID}&myItemOnly=${myItemOnly}&ownerTeamOnly=${ownerTeamOnly}"
					//+"&defaultClassCodes=${defaultClassCodes}&classCodes="+classCodes+"&levels="+levels+"&arcCode="+avg
					+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&udfStructureIDs="+avg2+"&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}&strType="+strType;
		var d=fnSetMenuTreeData(data);
		
		
		
		if(avg2 != "" && avg2 != undefined ){
			$("#udfStructureIDs").val(avg2);
// 			fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, avg, '', 'setLoadingEndTree('+avg3+')'); // 트리로드 
			setTreeData("menuId="+d.key+"&SelectMenuId="+avg+"&"+d.data+"&cols="+d.cols)
		}else{
// 			fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, avg); // 트리로드 
			setTreeData("menuId="+d.key+"&SelectMenuId="+avg+"&"+d.data+"&cols="+d.cols)
		}
	}
	
	function fnOpenTree(){
		setTimeout(function() {fnSetUnfoldTree();}, 1500);
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
				if(objClassList.length > 0) {
					olm.menuTree.config.icon = {
		                folder: icon_set[treeImgPath].folder,
		                openFolder: icon_set[treeImgPath].openFolder,
		                file: icon_set[treeImgPath].folder
		            }
				}
				
	 			res.data.forEach(item => {
					if (iconConvertToClassIcon.includes(item.ClassCode)) {
						item.icon = {
							folder: "dxi icon-" + item.ClassCode,
							openFolder: "dxi icon-" + item.ClassCode,
							file: "dxi icon-" + item.ClassCode
						};
					}
					
					if (objClassList.includes(item.ClassCode)) {
						item.icon = {
							folder: "dxi icon-" + item.ClassIcon.split('.')[0],
							openFolder: "dxi icon-" + item.ClassIcon.split('.')[0],
							file: "dxi icon-" + item.ClassIcon.split('.')[0]
						};
					}
					
				});
				
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
		
// 		fetch("jsonDhtmlxTreeListData.do?"+new URLSearchParams(queryData).toString())
// 		.then(res => res.json())
// 		.then(res => {
// 			res.forEach(item => {
// 				if (iconConvertToClassIcon.includes(item.ClassCode)) {
// 					item.icon = {
// 						folder: "dxi icon-" + item.ClassCode,
// 						openFolder: "dxi icon-" + item.ClassCode,
// 						file: "dxi icon-" + item.ClassCode
// 					};
// 				}
// 			});
			
// 			if(res.length > 0) olm.menuTree.data.parse(res);
// 			else {
// 				Promise.all([
// 					getDicData("BTN", "LN0034"), // 닫기
// 				]).then(results => {
// 					showDhxAlert("${WM00018}", results[0].LABEL_NM);
// 				});
// 			}
			
// 			if(nodeID != "") {
// 				var id = nodeID;
// 				if(id == '' || id == 'undefined' || id == '' || selectedItemID != ''){
// 					if(id != selectedItemID){return; }
// 				}
// 				if(id != ""){
// 					console.log("id", id)
// 					olm.menuTree.focusItem(id);
// 		   			olm.menuTree.selection.add(id);
// 		   			olm.menuTree.expand(id);
// 		   			olm.menuTree.data.eachParent(id, e => olm.menuTree.expand(e.id))
// 		    		olm.getMenuUrl(id);
// 				}
// 				nodeID = "";
// 			}
// 		})
	}
// 	function searchTreeText(type){
// 		var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
// 		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
// 	}
  	let searchItem = [];
  	let oldText = "";
  	let currentIndex = 0;
  	function searchTreeText(type){
  		var schText=$("#schTreeText").val();
  		if(schText==""){alert("${WM00045}"); return false;}

//   		if(oldText !== schText) {
//   			currentIndex = 0;
//   			searchItem = olm.menuTree.data.findAll(function(item) {
//   			    return item.value.includes(schText);
//   			});
//   		}

//   		if(type=="1"){ //search
//   			olm.menuTree.focusItem(searchItem[0].id);
//   			olm.menuTree.selection.add(searchItem[0].id);
//   			olm.getMenuUrl(searchItem[0].id);
//   		} else if(type=="2"){ //prev
//   			currentIndex = oldText === schText ? (currentIndex - 1 + searchItem.length) % searchItem.length : 0;
//   			olm.menuTree.focusItem(searchItem[currentIndex].id);
//   			olm.menuTree.selection.add(searchItem[currentIndex].id)
//   			olm.getMenuUrl(searchItem[currentIndex].id);
//   		}else if(type=="3"){ //next
//   			currentIndex = oldText === schText ? (currentIndex + 1) % searchItem.length : 0;
//   			olm.menuTree.focusItem(searchItem[currentIndex].id);
//   			olm.menuTree.selection.add(searchItem[currentIndex].id)
//   			olm.getMenuUrl(searchItem[currentIndex].id);
//   		}


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
		var data="sortOption=${sortOption}&showTOJ=${showTOJ}&showVAR=${showVAR}&defDimValueID=${defDimValueID}&myItemOnly=${myItemOnly}&ownerTeamOnly=${ownerTeamOnly}"
			//+"&defaultClassCodes=${defaultClassCodes}&classCodes="+classCodes+"&levels="+levels+"&arcCode="+avg
			+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&udfStructureIDs="+$("#udfStructureIDs").val()+"&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}";
		var d = fnSetMenuTreeData(data);
		var noMsg = "";
		if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
// 			itemId = olm.menuTree.getSelectedItemId();
			itemId = olm.menuTree._focusId;
		}
		currItemId = itemId;
// 		olm.menuTree.deleteChildItems(0);		
		if(isReload){
// 			fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, menuOption, noMsg, 'setLoadingEndTree('+currItemId+')');
			nodeID = currItemId;
			setTreeData("menuId="+d.key+"&SelectMenuId="+menuOption+"&"+d.data+"&cols="+d.cols)
		}else{
// 			fnLoadDhtmlxTreeJson(tree, d.key, d.cols, d.data, menuOption, noMsg, '');
			setTreeData("menuId="+d.key+"&SelectMenuId="+menuOption+"&"+d.data+"&cols="+d.cols)
		}
	}

	function fnArcDefPage(arcCode,def,pageUrl,itemID){
		console.log("fnArcDefPage")
		var url = "viewArcDefPage.do?arcDefPage="+def+"&pageUrl="+pageUrl+"&defMenuItemID="+itemID+"&arcCode="+arcCode
													+"&defDimTypeID=${defDimTypeID}&defDimValueID=${defDimValueID}";
// 		mainLayout.attachURL(url);
// 		var ifr = mainLayout.getFrame();ifr.scrolling="no";
console.log(url)
		
// 		mainLayout.attachHTML("<iframe height=100% width=100% style='border: none;' src="+url+"></iframe>")
		mainLayout.attachHTML("<div style='width:100%; height:100%;'><iframe height=100% width=100% style='border: none;' src="+url+" id='item-load'></iframe></div>")
	}
	
	function fnRefreshPage(arcCode,id) {
		if(arcCode == "" || arcCode == undefined) {
			arcCode = "${arcCode}";
		}
		
		if(id == "" || id == undefined) {
			id = olm.menuTree.getSelectedItemId();
		}

		var avg= "";
		scrnMode = "";
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
	}

	function fnRefreshPageCall(arcCode,s_itemID,avg) {
		if(avg == "") avg = "E";		
		scrnMode = "";		
    	parent.clickMainMenu(arcCode,'','','','csh_process','','', '','','','','','Y',s_itemID,avg);
	}
	
	function fnCheckArc(arcCode){
		console.log("fnCheckArc")
		<c:forEach var="list" items="${arcList}" varStatus="sts">
		if(arcCode == "${list.ArcCode}"){	
			if("${list.arcDefPage}" != "" && "${list.arcDefPage}" != null){
				fnArcDefPage("${list.ArcCode}","${list.arcDefPage}","${list.pageUrl}","${list.nodeID}");
			}else{
				parent.clickMainMenu(arcCode,'','','','${list.MenuStyle}','','${list.URL}.do?${list.VarFilter}&loadType=${loadType}');
				
			}
		}
		</c:forEach>
	}
	
	// &popupUrl=goViewSymbolPop.do
	function fnOpenPopupUrl(url){
		var w = "${pWidth}"; var h = "${pHeight}";
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenAllItems(state){
// 		var selectedItemID = olm.menuTree.getSelectedItemId();
		var selectedItemID = olm.menuTree.selection.getId();
		
		//var state= olm.menuTree.getOpenState(selectedItemID); // 1:펄쳐짐, -1:닫힘  
		// console.log("selectedItemID :"+selectedItemID+", state :"+state);
		
		if(state == ""){
		    //alert("프로세스를 선택하세요."); return;
		//	olm.menuTree.openAllItems(selectedItemID); return;
		}
		//var forderImg = document.getElementById("forderImg");
		//var newImageUrl = "${root}cmm/common/images/";
		 
		if(state == 1){ // open
			expandNodeAndChildren(selectedItemID);
// 			olm.menuTree.openAllItems(selectedItemID);
			//newImageUrl += "/tree_open.png"; 		    
			//forderImg.src = newImageUrl;
		}else{ // close
			olm.menuTree.closeAllItems(selectedItemID);
			//newImageUrl += "/tree_close.png"; 		    
			//forderImg.src = newImageUrl;
		}
	}
	
	function expandNodeAndChildren(id) {
	    olm.menuTree.expand(id);

	    const item = olm.menuTree.data.getItem(id);
	    console.log(id, item)
	    if (item && olm.menuTree.data.findAll(e => e.parent == id).length > 0) {
	    	olm.menuTree.data.findAll(e => e.parent == id).forEach(child => {
	            expandNodeAndChildren(child.id);
	        });
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
<body style="width: 100%; height: 100%;">
	<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="menuFullTitle"></input>
		<input type="hidden" id="menuID" name="menuID"></input>
		<input type="hidden" id="udfStructureIDs" name="udfStructureIDs"></input>
		<div id="contentwrapper" style="position: absolute;">
			<div id="contentcolumn">
				<div class="containerItm" id="containerItm" name="containerItm" scrolling='no'></div>
			</div>
		</div>
		<!-- 드래그 중에만 보이는 가이드 -->
		<div id="guide"></div>

		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none; overflow: hidden;" frameborder="0"></iframe>
	</form>
	
</body>
</html>
