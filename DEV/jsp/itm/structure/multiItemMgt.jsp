<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<style>
table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar{height:73px;}
</style>
<script type="text/javascript">

	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var showPreNextIcon = "Y";
	window.onload=setItmFrmInit;
	jQuery(document).ready(function() { 
		$("#varFilter").val("{grArcInfo.VarFilter}");
		var nodeID = "${grArcInfo.nodeID}";
	
		if("${nodeID}" != "") {
			nodeID = "${nodeID}";
		}
		$("#arcFilterType").val("${grArcInfo.FilterType}");
		setInitTwoLayout("${grArcInfo.ArcCode}","${grArcInfo.MenuStyle}",nodeID,"${grArcInfo.arcDefPage}","${grArcInfo.SortOption}");
		var arcDefPage = "${grArcInfo.arcDefPage}";
		var pageUrl = "${grArcInfo.pageUrl}";
		
		var defMenuItemID = "${defMenuItemID}";
		
		if(defMenuItemID == "")
			defMenuItemID = "${grArcInfo.nodeID}";
			
		if(nodeID == "" && arcDefPage != '' && arcDefPage != null){
			fnArcDefPage("${grArcInfo.ArcCode}",arcDefPage,pageUrl,defMenuItemID);
		}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		
		setCookie('itemIDs', '', -1);
		
	});
	
	function fnSetUnfoldTree(){
		if(olm.menuTree!=null){
			olm.menuTree.closeAllItems(0);
			var ch = olm.menuTree.hasChildren(0);
			for(var i=0; i<ch; i++){
				var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);
				olm.menuTree.openItem(lev1);
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
	
	function setInitTwoLayout(arcCode, style, nodeID, arcDefPage, sortOption){	
		document.getElementById('containerItm').style.height=getHeight()+'px';
		var scrpt = new Object();
		scrpt.treeTop = "<div id='selectTreeArea' style='padding-right: 1000px; padding-bottom: 10px; border-bottom:1px solid #dfdfdf;'>";
		<c:forEach var="list" items="${arcList}" varStatus="sts">
			if(arcCode == "${list.ArcCode}"){
				scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);' checked='checked' >&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
			}else{
				scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);'>&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
			}
		</c:forEach>
		scrpt.treeTop= scrpt.treeTop+"</div>"; 
		
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();} 
		baseLayout=new dhtmlXLayoutObject("containerItm",layout_2U,dhx_skin_skyblue);
		baseLayout.skinParams.dhx_skyblue.cpanel_height = 75;
		baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(250);
		baseLayout.items[0].setText(scrpt.treeTop);
		baseLayout.items[1].hideHeader();	

		fnGetCategory(arcCode, scrpt, style, nodeID, arcDefPage, sortOption);
	}
	
	function fnGetCategory(avg, avg2, avg3, avg4, avg5, sortOption){ 
		setInitTwoLayoutTreeLoad(avg2, avg3, avg4, avg5);
		
		menuOption = avg;
		olm.menuTree.getSelectedItemId();
		olm.menuTree.deleteChildItems(0);
		var data="sortOption="+sortOption;
		var d=fnSetMenuTreeData(data);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 
	}
	
	var nodeID = "";
	function setInitTwoLayoutTreeLoad(scrpt, treeImgPath, avg, arcDefPage){
		nodeID = avg;
		scrpt.treeTop = scrpt.treeTop + "<div id='schTreeArea' style='margin-top:5px;'>";
		scrpt.treeTop = scrpt.treeTop +"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a> <a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
		scrpt.treeTop = scrpt.treeTop +"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
		scrpt.treeTop = scrpt.treeTop +"</div>";
		scrpt.cntnTop = "";
		
		baseLayout.items[0].setText(scrpt.treeTop);
		olm.menuTree = baseLayout.items[0].attachTree(0);
		olm.menuTree.setSkin(dhx_skin_skyblue);
		olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});
		olm.menuTree.enableDragAndDrop(false);
		olm.menuTree.enableSmartXMLParsing(true);	
		if( nodeID != ""){ olm.menuTree.setOnLoadingEnd(fnSetLoading); }else{ setTimeout(function() {fnSetUnfoldTree();}, 2000); }
		cntnLayout = baseLayout.items[1];
		mainLayout = baseLayout.items[1];		
	}
	
	function fnCheckArc(arcCode){
		$("#checedArcCode").val(arcCode);
		<c:forEach var="list" items="${arcList}" varStatus="sts">
		if(arcCode == "${list.ArcCode}"){	
			$("#varFilter").val("${list.VarFilter}");
			$("#arcFilterType").val("${list.FilterType}");
			setInitTwoLayout(arcCode, "${list.MenuStyle}", "${list.nodeID}","${list.arcDefPage}", "${list.SortOption}");
			if("${list.arcDefPage}" != "" && "${list.arcDefPage}" != null){
				fnArcDefPage("${list.ArcCode}","${list.arcDefPage}","${list.pageUrl}","${list.nodeID}");
			}
		}
		</c:forEach>		
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
		
	function setLayoutResize(){	 
		var minWidth=lMinWidth+rMinWidth;
		var lWidth=baseLayout.items[0].getWidth(); 
		var rWidth=baseLayout.items[1].getWidth();
		var wWidth=document.body.clientWidth;
		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}
	}	
	var selectedItemID  ="";
	olm.getMenuUrl=function(id, preNext, currIdx){
		var ids = id.split("_"); 
		selectedItemID = ids;
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
		var arcFilterType = $("#arcFilterType").val();
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID+"&currIdx="+currIdx+"&arcFilterType="+arcFilterType;
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID, currIdx){
		var arcCode = $("#checkedArcCode").val();
		var url = menuURL+".do?scrnMode=${scrnMode}&showTOJ=${showTOJ}&showVAR=${showVAR}&ownerType=${ownerType}&accMode=${accMode}&itemID="+itemID+"&itemClassMenuUrl="+menuURL 
				+"&currIdx="+currIdx
				+"&showPreNextIcon="+showPreNextIcon
				+"&option="+arcCode;
		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();
		ifr.scrolling="no";
	}
	
	function getTreeSubItems(subItems){
		var arcFilterType = $("#arcFilterType").val();
		var visitLogYN = "Y";
		if(arcFilterType == "ORGITM" || arcFilterType == "ORG"){	
			visitLogYN = "N";
		}
		var itemId = "";
		if( subItems == 'undefined' || subItems == null || subItems == ''){ 
			if( olm.menuTree != null){
				subItems = olm.menuTree.getSubItems(olm.menuTree.getSelectedItemId());
			}else{subItems = "";}
		}
		if( olm.menuTree != null){itemId = olm.menuTree.getSelectedItemId();}
		var url = "setSessionParameter.do";
		var target = "blankDiv";
		var data = "subItems="+subItems+"&ItemId="+itemId+"&visitLogYN="+visitLogYN;

		ajaxPage(url, data, target);
	}	
	
	var menuOption = "";	
	function creatMenuTab(id,level,varFilter,currIdx,strItemID,actionYN){	
		var arcFilterType = $("#arcFilterType").val();
		var fullId = "";
		var text = "";
		var url = "setItemTabMenu.do?option="+menuOption+"&level="+level
				+"&currIdx="+currIdx
				+"&showPreNextIcon="+showPreNextIcon
				+"&showTOJ=${showTOJ}"; 
		if(arcFilterType == "ORGITM" || arcFilterType == "ORG"){		
			if(actionYN == 'N'){ return; }
			
			url = "orgMainInfo.do?option="+menuOption+"&level="+level
				+"&currIdx="+currIdx
				+"&showPreNextIcon="+showPreNextIcon
				+"&showTOJ=${showTOJ}"
				+"&defMenuItemID=${defMenuItemID}";
		}
		
		if(id < 0){ return; }
		if(id!="null" && id!=""){url=url+"&id="+id;} 
		
		olm.create_tab(id, fullId, text, url, true);
	}	
	
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
	
	function searchTreeText(type){
		var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){ 		
		var d = fnSetMenuTreeData();var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
			itemId = olm.menuTree.getSelectedItemId();
		}
		currItemId = itemId;olm.menuTree.deleteChildItems(0);
		
		var data="sortOption=${sortOption}";
		var d=fnSetMenuTreeData(data);
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

	function fnArcDefPage(arcCode,def,pageUrl,itemID){
		$("#checkedArcCode").val(arcCode);
		var url = "viewArcDefPage.do?arcDefPage="+def+"&pageUrl="+pageUrl+"&defMenuItemID="+itemID+"&arcCode="+arcCode;
		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	}
	function fnRefreshPageMulti(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','multiItemTreeMgt.do?&nodeID='+id);
	}
	function fnRefreshPage(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
	}
	
	
</script>
</head>
<body style="width:100%; height:100%;">
<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="menuID" name="menuID"></input>
<input type="hidden" id="varFilter" name="varFilter"></input>
<input type="hidden" id="arcFilterType" name="arcFilterType"></input>
<input type="hidden" id="checkedArcCode" name="checkedArcCode"></input>

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
