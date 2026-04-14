<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; charset=utf-8"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>

<script type="text/javascript">

	var olm={};	olm.pages={};olm.url={};
	var menuText = "";
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var dp;
	var showPreNextIcon = "Y";
	var showTOJ = "${showTOJ}";
	var scrnMode = "${scrnMode}";
	
	window.onload=setItmFrmInit;
	jQuery(document).ready(function() {
		var unfold = "${unfold}";
		fnGetCategory("${arcCode}"); 
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree('${nodeID}');}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		var arcDefPage = "${arcDefPage}";
		var pageUrl = "${pageUrl}";
		var defMenuItemID = "${defMenuItemID}";
		var defDimTypeID = "${defDimTypeID}";
		var defDimValueID = "${defDimValueID}";
		
		if(defMenuItemID == "")
			defMenuItemID = "${nodeID}";
			
		if(arcDefPage != '' && arcDefPage != null){
			fnArcDefPage("${arcCode}",arcDefPage,pageUrl,defMenuItemID,defDimTypeID,defDimValueID);
		}

		setCookie('itemIDs', '', -1);
		
		if("${popupUrl}"){
			fnOpenPopupUrl("${popupUrl}");
		}
	});
	
	function fnSetUnfoldTree(nodeID){
		if(olm.menuTree!=null){
			olm.menuTree.closeAllItems(0);
			var ch = olm.menuTree.hasChildren(0);
			if(nodeID != ''){
				olm.menuTree.openItem(nodeID);
			}else{
				for(var i=0; i<ch; i++){
					var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);
					olm.menuTree.openItem(lev1);
					}
				}
			}
		}
	
	function setItmFrmInit(){
		$("#containerItm").attr("style", "display:block;width:"+getWidth()+"px;height:"+getHeight()+"px;border: 0;");
		document.getElementById('containerItm').style.height=getHeight()+'px';
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setItmFrmScreenResize();},200);}
	}
	function getHeight(){return (document.body.clientHeight);}
	function getWidth(){return (document.body.clientWidth);}
	function setItmFrmScreenResize(){ 
		document.getElementById('containerItm').style.height=getHeight()+'px';
		document.getElementById('containerItm').style.width=getWidth()+'px';
		if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);}baseLayout.setSizes();}
	}
	function setInitMenu(isLeft, isMain){if(isMain){$("#menusection").attr("style","display:block;");}else{$("#menusection").attr("style","display:none;");}setItmFrmScreenResize();}
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
		cntnLayout = new dhtmlXLayoutObject("containerItm",viewType);	
	}	
	var nodeID = "${nodeID}";
	function setInitTwoLayout(){	
		document.getElementById('containerItm').style.height=getHeight()+'px';
		var scrpt = fnSetScriptMasterDiv();		
		if("${loadType}" == "multi"){if($("#selectTreeArea").length>0){$("#selectTreeArea").remove();} }
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();} 
		/*$("#divCntnTop").show();*/
		baseLayout=new dhtmlXLayoutObject("containerItm",layout_2U,dhx_skin_skyblue);
		if("${loadType}" == "multi"){baseLayout.skinParams.dhx_skyblue.cpanel_height = 75;}else{
			baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;
		}
		baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(250); 
		//baseLayout.items[0].setHeight(getHeight());
		baseLayout.items[0].setText(scrpt.treeTop);
		baseLayout.items[1].hideHeader();	
		//baseLayout.items[1].setHeight(getHeight());
		olm.menuTree = baseLayout.items[0].attachTree(0);
		olm.menuTree.setSkin(dhx_skin_skyblue);
		olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id,'','',olm.menuTree.getSelectedItemText()); return true;});
		olm.menuTree.enableDragAndDrop(true);
		olm.menuTree.enableSmartXMLParsing(true);		

		olm.menuTree.loadXML("${root}" + "${xmlFileName}");	
		if( nodeID != ""){olm.menuTree.setOnLoadingEnd(fnSetLoading);}
		cntnLayout = baseLayout.items[1];
		mainLayout = baseLayout.items[1];
		
		dp = new dataProcessor("saveTreeData.do"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.init(olm.menuTree); // link dataprocessor to the grid  
		dp.attachEvent("fnGetCategory", function(){});
	}
	
	function setLayoutResize(){	 
		var minWidth=lMinWidth+rMinWidth;
		var lWidth=baseLayout.items[0].getWidth(); 
		var rWidth=baseLayout.items[1].getWidth();
		var wWidth=document.body.clientWidth;
		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}
	}	
	var selectedItemID  ="";
	olm.getMenuUrl=function(id, preNext, currIdx, mText){ 
		var ids = id.split("_");  
		selectedItemID = ids;
		menuText = mText;
		
		getTreeSubItems('');
		currItemId=ids[0];
		$('#menuID').val(currItemId); 
		fnGetItemClassMenuURL(currItemId, currIdx); // itemClass menuID
		
		if(preNext != "Y"){
			var itemIDs = getCookie('itemIDs'); 
			fnAddCookie(currItemId, itemIDs, 'itemIDs');
		}
	};
	
	fnGetMenuUrl=function(id){ 
		creatMenuTab(id,"1");
	};
	
	function fnGetItemClassMenuURL(itemID, currIdx){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID+"&currIdx="+currIdx;
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID, currIdx){
		var openItemIDs = getCookie('itemIDs').split(',');
		var url = menuURL+".do?regFlg=${regFlg}&itemID="+itemID+"&itemClassMenuUrl="+menuURL+"&showPreNextIcon="+showPreNextIcon
				+"&currIdx="+currIdx+"&option="+menuOption+"&openItemIDs="+openItemIDs+"&scrnMode="+scrnMode+"&showTOJ=${showTOJ}&showVAR=${showVAR}&ownerType=${ownerType}&accMode=${accMode}";
		
		mainLayout.attachURL(url);
		scrnMode = "";
		var ifr = mainLayout.getFrame();
		ifr.scrolling="no";
	}
	
	function fnSetLoading(){
		if(nodeID == '' ){return;}
		var id = "${nodeID}"; 		
		if(id == '' || id == 'undefined' || id == '' || selectedItemID != ''){
			if(id != selectedItemID){return; }
		}
		var ids = id;
		getTreeSubItems('');
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
	
	function getTreeSubItems(subItems){
		var itemId = "";
		if( subItems == 'undefined' || subItems == null || subItems == ''){ 
			if( olm.menuTree != null){
				subItems = olm.menuTree.getSubItems(olm.menuTree.getSelectedItemId());
			}else{subItems = "";}
		}
		if( olm.menuTree != null){itemId = olm.menuTree.getSelectedItemId();}
		var url = "setSessionParameter.do";
		var target = "blankDiv";
		var data = "subItems="+subItems+"&ItemId="+itemId;

		ajaxPage(url, data, target);
	}	
	
	var menuOption = "";	
	function creatMenuTab(id,level,varFilter,currIdx){	
		var fullId = "";
		var text = "";
		var openItemIDs = getCookie('itemIDs').split(','); 
		var url = "setItemTabMenu.do?option="+menuOption
				+"&level="+level+varFilter
				+"&openItemIDs="+openItemIDs
				+"&currIdx="+currIdx
				+"&showTOJ="+showTOJ
				+"&accMode=${accMode}"
				+"&showPreNextIcon="+showPreNextIcon;  
		if(id!="null" && id!=""){url=url+"&id="+id;}
		olm.create_tab(id, fullId, text, url, true);
	}	
	
	/* function creatMenuTab(id,level){
		var fullId = "";
		var text = "";
		var url = "setVariantTabMenu.do?option="+menuOption+"&level="+level
				+"&masterProjectID=${refPGID}&variantClass=${variantClass}"
				+"&refPGID=${refPGID}&myProject=${myProject}&focusedItemID=${focusedItemID}";
		if(selectedItemID[1] == "PJT") {
			url = "variantProjectList.do?masterProjectID=${refPGID}&variantClass=${variantClass}&refPGID=${refPGID}&variantProjectType=${variantProjectType}"
					+"&myProject=${myProject}&parentItemID="+id+"&focusedItemID=${focusedItemID}";
		}
		if(selectedItemID[1] == "CL01005") {
			return false;
		}
		if(id!="null" && id!=""){url=url+"&id="+id;} 
		
		olm.create_tab(id, fullId, text, url, true);
	}	
	 */
	olm.create_tab=function(id,fullId,text,url,isInclude){ 
		if(id == ""){id=menuOption;}
		fullId=id;
		var cntnTitle=""; 
		if(olm.menuTree==null){cntnTitle=text;
		}else{cntnTitle=text||olm.menuTree.getItemText(id);}
		var fullText=$("#menuFullTitle").val();
		fullText=fullText + "&nbsp;>&nbsp;" + cntnTitle;
		if(!olm.url[fullId]){
			olm.url[fullId]=fullId+"^"+url;
			mainLayout.attachURL(url);
		}else{
			olm.url[fullId]=fullId+"^"+url;
			mainLayout.attachURL(url);
		}
		
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	};	
		
	function fnGetCategory(avg){ 
		setInitTwoLayout();
		menuOption = avg;
		olm.menuTree.getSelectedItemId();
		olm.menuTree.deleteChildItems(0);
		if("${loadType}" == "multi")$("table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar").css("height","73px");
	}
	
	function searchTreeText(type){
		var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){
		fnGetCategory("${arcCode}"); 
	}
	
	function fnCreateRefreshTree(itemId,isReload){ 		
		var d = fnSetMenuTreeData();var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
			itemId = olm.menuTree.getSelectedItemId();
		}
		currItemId = itemId;olm.menuTree.deleteChildItems(0);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		if(isReload){olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}
	}
	
	function setLoadingEndTree(prtItemId){ 
		getTreeSubItems(''); 
		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
		olm.menuTree.openItem(prtItemId);
		if(currItemId == null || currItemId == 'undefined'){return false;
		}else{olm.menuTree.selectItem(currItemId,false,false);}
	}	

	/* function fnArcDefPage(def){
		var url = "viewArcDefPage.do?page="+def;
		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	} */
	
	function fnArcDefPage(arcCode,def,pageUrl,itemID,defDimTypeID,defDimValueID){
		var url = "viewArcDefPage.do?arcDefPage="+def+"&pageUrl="+pageUrl
				+"&defMenuItemID="+itemID+"&arcCode="+arcCode
				+"&defDimTypeID="+defDimTypeID+"&defDimValueID="+defDimValueID
				+"&showTOJ=${showTOJ}&showVAR=${showVAR}&accMode=${accMode}&ownerType=${ownerType}"
				+"&objClassList=${objClassList}&nodeID=${nodeID}&scrnUrl=${scrnUrl}";

		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	}
	
	function fnSaveTreeData(){		
		var list = olm.menuTree.getAllSubItems(0); //0 is root id
		var ids = list.split(","); //array of all items
		//var level = p_tree.getLevel(749718);
		//var index = olm.menuTree.getItemIdByIndex(725477,0);
		//alert(index);
		
		for(var i=0; i < ids.length; i++){
			dp.setUpdated(ids[i], true, "updated");
			olm.menuTree.setUserData(ids[i],"level",olm.menuTree.getLevel(ids[i]));
		}

		dp.sendData(); 
	}
	
	function fnSetScriptMasterDiv(){	
		if("${loadType}" == "multi"){
			var scrpt = new Object();
			scrpt.treeTop = "<div id='selectTreeArea' style='padding-right: 1000px; padding-bottom: 10px; border-bottom:1px solid #dfdfdf;'>";
			<c:forEach var="list" items="${arcList}" varStatus="sts">
				if("${arcCode}" == "${list.ArcCode}"){
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);' checked='checked' >&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}else{
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);'>&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}
			</c:forEach>
			scrpt.treeTop= scrpt.treeTop+"</div>";
			
			scrpt.treeTop = scrpt.treeTop + "<div id='schTreeArea' style='margin-top:5px;'>";
			scrpt.treeTop = scrpt.treeTop +"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a> <a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
			scrpt.treeTop = scrpt.treeTop+"<a onclick='fnRefreshPage()'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop = scrpt.treeTop +"</div>";
			scrpt.cntnTop = "";
			return scrpt;
		}else{
			var divScpt = new Object();
			divScpt.treeTop="<div id='schTreeArea'>";
			divScpt.treeTop=divScpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;&nbsp;";
			divScpt.treeTop=divScpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>";
			//divScpt.treeTop=divScpt.treeTop+"<a onclick='fnSaveTreeData(\"1\")'><img src='${root}${HTML_IMG_DIR}/btn_fileadd.png'></a>";    
			divScpt.treeTop=divScpt.treeTop+"<a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
			// divScpt.treeTop = divScpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			divScpt.treeTop = divScpt.treeTop+"<a onclick='fnRefreshPage()'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			divScpt.treeTop=divScpt.treeTop+"</div>";divScpt.cntnTop="";
			return divScpt;
		}
	}
	
	/* function fnSetScriptMasterDiv(){
		var divScpt = new Object();
		divScpt.treeTop="<div id='schTreeArea'>";
		divScpt.treeTop=divScpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;&nbsp;";
		divScpt.treeTop=divScpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>";
		//divScpt.treeTop=divScpt.treeTop+"<a onclick='fnSaveTreeData(\"1\")'><img src='${root}${HTML_IMG_DIR}/btn_fileadd.png'></a>";    
		divScpt.treeTop=divScpt.treeTop+"<a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
		// divScpt.treeTop = divScpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
		divScpt.treeTop = divScpt.treeTop+"<a onclick='fnRefreshPage()'><img src='${root}cmm/common/images/img_refresh.png'></a>";
		divScpt.treeTop=divScpt.treeTop+"</div>";divScpt.cntnTop="";
		return divScpt;
	}
 */
	function fnRefreshPage(arcCode,id) { 
		if(arcCode == "" || arcCode == undefined) {
			arcCode = "${arcCode}";
		}
		
		if(id == "" || id == undefined) {
			id = olm.menuTree.getSelectedItemId();
		}

		var avg= "";
		scrnMode = "";
    	parent.clickMainMenu(arcCode,'','','','csh_process','','', '','','','','','Y',id,avg);
	}
	
	function fnRefreshPageCall(arcCode,s_itemID,avg) {
		if(avg == "")
			avg = "E";
		
		scrnMode = "";
		
    	parent.clickMainMenu(arcCode,'','','','csh_process','','', '','','','','','Y',s_itemID,avg);
	}
	
	function fnCheckArc(arcCode){
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
	
</script>
</head>
<body style="width:100%; height:100%;">
<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="menuID" name="menuID"></input>
<div id="contentwrapper" style="position:absolute;">		
		<div id="contentcolumn" >		
			<div  class="containerItm" id="containerItm" name="containerItm" scrolling='no'>
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0"></iframe>
			 </div>	
		</div>
	</div>	
</form>
</body>
</html>
