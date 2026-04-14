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
	window.onload=setItmFrmInit;
	jQuery(document).ready(function() {
		var unfold = "${unfold}";
		fnGetCategory("${arcCode}"); 
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		var arcDefPage = "${arcDefPage}";
		if(arcDefPage != '' && arcDefPage != null){
			fnArcDefPage(arcDefPage);
		}
	});
	
	function fnSetUnfoldTree(){if(olm.menuTree!=null){olm.menuTree.closeAllItems(0);var ch = olm.menuTree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);olm.menuTree.openItem(lev1);}}}
	
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
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();} 
		/*$("#divCntnTop").show();*/
		baseLayout=new dhtmlXLayoutObject("containerItm",layout_2U,dhx_skin_skyblue);
		baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;
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
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id,olm.menuTree.getSelectedItemText()); return true;});
		olm.menuTree.enableDragAndDrop(false);
		olm.menuTree.enableSmartXMLParsing(true);		

		olm.menuTree.loadXML("${root}" + "${xmlFilName}");
		if( nodeID != ""){olm.menuTree.setOnLoadingEnd(fnSetLoading);}
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
	var selectedItemID  ="";
	olm.getMenuUrl=function(id, mText){ 
		var ids = id.split("_");  
		selectedItemID = ids;
		menuText = mText;
		
		getTreeSubItems('');
		currItemId=ids[0];
		$('#menuID').val(currItemId); 
		fnGetItemClassMenuURL(currItemId); // itemClass menuID
		
	};
	
	fnGetMenuUrl=function(id){ 
		creatMenuTab(id,"1");
	};
	
	function fnGetItemClassMenuURL(itemID){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID;
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID){
		var url = menuURL+".do?itemID="+itemID+"&itemClassMenuUrl="+menuURL;
		mainLayout.attachURL(url);
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
	function creatMenuTab(id,level,varFilter){
		var fullId = "";
		var text = "";
		var url = "setItemTabMenu.do?option="+menuOption+"&level="+level+varFilter; 
		/*  var url = "setVariantTabMenu.do?option="+menuOption+"&level="+level
				+"&masterProjectID=${refPGID}&variantClass=${variantClass}"
				+"&refPGID=${refPGID}&myProject=${myProject}&focusedItemID=${focusedItemID}";  */
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
	}
	
	function searchTreeText(type){
		var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){
		fnGetCategory("${arcCode}"); 
	}
	
	function setLoadingEndTree(prtItemId){ 
		getTreeSubItems(''); 
		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
		olm.menuTree.openItem(prtItemId);
		if(currItemId == null || currItemId == 'undefined'){return false;
		}else{olm.menuTree.selectItem(currItemId,false,false);}
	}	

	function fnArcDefPage(def){
		var url = "viewArcDefPage.do?page="+def;
		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
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
