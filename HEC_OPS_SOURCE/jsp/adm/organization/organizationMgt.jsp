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
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>

<script type="text/javascript">

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
		if(olm.menuTree!=null){
			olm.menuTree.closeAllItems(0);
			var ch = olm.menuTree.hasChildren(0);
			for(var i=0; i<ch; i++){
				var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);
				olm.menuTree.openItem(lev1);
			}
		}
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
		cntnLayout = new dhtmlXLayoutObject("containerOrg",viewType);	
	}
	var nodeID = "${nodeID}";
	var selectedItemID  ="";
	function setInitTwoLayout(){	
		document.getElementById('containerOrg').style.height = (getHeight()) + "px"; 	
		
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
			scrpt.treeTop = scrpt.treeTop +"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop = scrpt.treeTop +"</div>";
			scrpt.cntnTop = "";
		}else{
			var scrpt = fnSetScriptMasterDiv();
		}
		
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}
		if("${loadType}" == "multi"){if($("#selectTreeArea").length>0){$("#selectTreeArea").remove();}}
		/*$("#divCntnTop").show();*/
		baseLayout=new dhtmlXLayoutObject("containerOrg",layout_2U,dhx_skin_skyblue);
		if("${loadType}" == "multi"){baseLayout.skinParams.dhx_skyblue.cpanel_height = 75;}else{baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;}
		baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(250);
		baseLayout.items[0].setText(scrpt.treeTop);
		baseLayout.items[1].hideHeader();	
		olm.menuTree = baseLayout.items[0].attachTree(0);
		olm.menuTree.setSkin(dhx_skin_skyblue);
		olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});
		olm.menuTree.enableDragAndDrop(false);
		olm.menuTree.enableSmartXMLParsing(true);	
		if( nodeID != ""){	olm.menuTree.setOnLoadingEnd(fnSetLoading);}
		cntnLayout = baseLayout.items[1];
		mainLayout = baseLayout.items[1];
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
	
	function setLayoutResize(){	 
		var minWidth=lMinWidth+rMinWidth;
		var lWidth=baseLayout.items[0].getWidth(); 
		var rWidth=baseLayout.items[1].getWidth();
		var wWidth=document.body.clientWidth;
		if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}
		if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}}	
		
		olm.getMenuUrl=function(id){var ids = id.split("_");  
		currItemId=ids[0];
		$('#menuID').val(currItemId); 
		//creatMenuTab(currItemId,"1");
		fnGetTeamID(currItemId, "1");
		
		//document.orgFrm.action = "organizationInfoView.do";
		//document.orgFrm.target="blankFrame";
		//document.orgFrm.submit();
	};
	
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
		var url = "orgMainInfo.do?defItemTypeCode=${defItemTypeCode}&option="+menuOption+"&level="+level;
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
		var data="";
		var d=fnSetMenuTreeData(data);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 
		if("${loadType}" == "multi")$("table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar").css("height","73px");
	}
	
	function searchTreeText(type){var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){
		var d = fnSetMenuTreeData();var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}if(itemId == null || itemId == 'undefined' || itemId == "null"){itemId = olm.menuTree.getSelectedItemId();}currItemId = itemId;olm.menuTree.deleteChildItems(0);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		if(isReload){olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}
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
	
</script>
</head>
<body style="width:100%; height:100%;">
<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="menuID" name="menuID"></input>
<div id="contentwrapper" style="position:absolute;">				
		<div id="contentcolumn" >		
			<div style="width:100%; height:800px;" class="containerOrg" id="containerOrg" name="containerOrg" scrolling='no'>
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0"></iframe>
			 </div>	
		</div>
	</div>	
</form>
</body>
</html>
