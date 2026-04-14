<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1; charset=utf-8"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00170" var="WM00170"/>

<script type="text/javascript">

	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var showPreNextIcon = "Y";
    var treeImgFullPath = "${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/";
	window.onload=setItmFrmInit;
	jQuery(document).ready(function() { 
		var unfold = "${unfold}";
		if("${filterType}" != "CUSSTR" && "${udfSTR}" != "Y"){ 
			fnGetCategory("${arcCode}");
		}
		if("${nodeID}" == "" && (unfold != "false" || unfold == '')){setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		var arcDefPage = "${arcDefPage}";
		var pageUrl = "${pageUrl}";
		var defMenuItemID = "${defMenuItemID}";
		
		if(defMenuItemID == "")
			defMenuItemID = "${nodeID}";
			
		if(arcDefPage != '' && arcDefPage != null){
			fnArcDefPage("${arcCode}",arcDefPage,pageUrl,defMenuItemID);
		}
		
		setCookie('itemIDs', '', -1);
		
		if("${popupUrl}"){
			fnOpenPopupUrl("${popupUrl}?arcCode=${arcCode}&defaultClassCodes=${defaultClassCodes}&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}");
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
	var dhx_cell_hdr_height = 43;
	if("${loadType}" == "multi"){ dhx_cell_hdr_height = 73; }
	function setInitTwoLayout(){	
		document.getElementById('containerItm').style.height=getHeight()+'px';		
		
		if("${loadType}" == "multi"){
			var scrpt = new Object();
			scrpt.treeTop = "<div id='selectTreeArea' class='selectTreeArea' style='padding: 0 15px 10px 5px;border-bottom:1px solid #dfdfdf;'>";
			<c:forEach var="list" items="${arcList}" varStatus="sts">
				if("${arcCode}" == "${list.ArcCode}"){
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);' checked='checked' >&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}else{
					scrpt.treeTop = scrpt.treeTop+"<input type='radio' value='${list.ArcCode}' id='${list.ArcCode}' name='arcCode' OnClick='fnCheckArc(this.value);'>&nbsp;<label for='${list.ArcCode}'>${list.ArcName}</label>&nbsp;&nbsp;&nbsp;";
				}
			</c:forEach>
			scrpt.treeTop= scrpt.treeTop+"</div>";
			
			scrpt.treeTop = scrpt.treeTop + "<div id='schTreeArea' style='margin-top:5px;'>";
			scrpt.treeTop = scrpt.treeTop +"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a> <a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
			scrpt.treeTop = scrpt.treeTop +"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop = scrpt.treeTop +"</div>";
			scrpt.cntnTop = "";
		}else{
			// var scrpt = fnSetScriptMasterDiv();			
			var scrpt = new Object();
			scrpt.treeTop="<div id='schTreeArea'>";
			scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;' placeholder='Search' value='' text=''/>&nbsp;&nbsp;";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
			scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a>|<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnOpenAllItems(-1)'><img src='${root}cmm/common/images/tree_close.png' id='forderImg' style='margin-left:5px;margin-top:3px;cursor:pointer;' title='Collapse'></a>";
			scrpt.treeTop=scrpt.treeTop+"<a onclick='fnOpenAllItems(1)'><img src='${root}cmm/common/images/tree_open.png' id='forderImg' style='margin-left:5px;margin-top:3px;cursor:pointer;' title='Expand'></a>";
			scrpt.treeTop=scrpt.treeTop+"</div>";scrpt.cntnTop="";
			
		}
		
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();} 
		if("${loadType}" == "multi"){	if($("#selectTreeArea").length>0){$("#selectTreeArea").remove();} }
		/*$("#divCntnTop").show();*/
		baseLayout=new dhtmlXLayoutObject("containerItm",layout_2U,dhx_skin_skyblue);
		// if("${loadType}" == "multi"){ baseLayout.skinParams.dhx_skyblue.cpanel_height = 75; } else { baseLayout.skinParams.dhx_skyblue.cpanel_height = 44; }
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height+"px");

		baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(300);
		//baseLayout.items[0].setHeight(getHeight());
		baseLayout.items[0].setText(scrpt.treeTop);
		baseLayout.cells("b").hideHeader();
		//baseLayout.items[1].hideHeader();	
		//baseLayout.items[1].setHeight(getHeight());
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
		
		// Item AccessOption 
		if( '${loginInfo.sessionMlvl}' != "SYS" && id != -1 ){
			fnCheckUserAccRight(id, "fnTreeload('"+id+"','"+preNext+"','"+currIdx+"')", "${WM00033}", "${WM00170}");
		} else {
			fnTreeload(id, preNext, currIdx);
		}
	};
		
	function fnTreeload(currItemId, preNext, currIdx){
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
		var data = "&itemID="+itemID+"&currIdx="+currIdx+"&strType=${strType}";
		
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID, currIdx, strItemID, mstItemID, actionYN){		
		var url = menuURL+".do?itemID="+itemID+"${arcVarFilter}&strType=${strType}&scrnMode=${scrnMode}"
				+"&showTOJ=${showTOJ}&showVAR=${showVAR}&ownerType=${ownerType}&accMode=${accMode}"
				+"&itemClassMenuUrl="+menuURL+"&currIdx="+currIdx+"&strItemID="+strItemID+"&arcCode=${arcCode}"+"&s_itemID="+itemID
				+"&showPreNextIcon="+showPreNextIcon+"&tLink=${tLink}&mstItemID="+mstItemID+"&showLink=${showLink}"
				+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}";
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
		//creatMenuTab(currItemId,"1");
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
	function creatMenuTab(id,level,varFilter,currIdx,strItemID,mstItemID,actionYN){	
		var fullId = "";
		var text = "";
		try{ var openItemIDs = getCookie('itemIDs').split(','); }catch(e){}

		var url = "setItemTabMenu.do?option="+menuOption
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
				+"&sqlXmlCode=${sqlXmlCode}";
		
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
		
	function fnGetCategory(avg, avg2, avg3){
		$("#loading").fadeOut(50);
		setInitTwoLayout();
		menuOption = avg;
		olm.menuTree.getSelectedItemId();
		olm.menuTree.deleteChildItems(0);
		$("div.dhx_cell_hdr").css("height",dhx_cell_hdr_height + "px");
		var data="sortOption=${sortOption}&showTOJ=${showTOJ}&showVAR=${showVAR}&defDimValueID=${defDimValueID}&myItemOnly=${myItemOnly}&ownerTeamOnly=${ownerTeamOnly}"
					//+"&defaultClassCodes=${defaultClassCodes}&classCodes="+classCodes+"&levels="+levels+"&arcCode="+avg
					+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&udfStructureIDs="+avg2+"&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}&strType=${strType}";
		var d=fnSetMenuTreeData(data);
		
		if(avg2 != "" && avg2 != undefined ){
			$("#udfStructureIDs").val(avg2);
			fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg, '', 'setLoadingEndTree('+avg3+')'); // 트리로드 
		}else{
			fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 
		}
	}
	
	function fnOpenTree(){
		setTimeout(function() {fnSetUnfoldTree();}, 1500);
	}
	
	function searchTreeText(type){
		var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,false,true);}else if(type=="2"){olm.menuTree.findItem(schText,true,false);}else if(type=="3"){olm.menuTree.findItem(schText,false,false);}
	}
	
	function fnRefreshTree(itemId,isReload){ 	
		var data="sortOption=${sortOption}&showTOJ=${showTOJ}&showVAR=${showVAR}&defDimValueID=${defDimValueID}&myItemOnly=${myItemOnly}&ownerTeamOnly=${ownerTeamOnly}"
			//+"&defaultClassCodes=${defaultClassCodes}&classCodes="+classCodes+"&levels="+levels+"&arcCode="+avg
			+"&myCSR=${myCSR}&csrIDs=${csrIDs}&udfSTR=${udfSTR}&udfStructureIDs="+$("#udfStructureIDs").val()+"&multiDimType=${multiDimType}&sqlXmlCode=${sqlXmlCode}";
		var d = fnSetMenuTreeData(data);
		var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}
		if(itemId == null || itemId == 'undefined' || itemId == "null"){
			itemId = olm.menuTree.getSelectedItemId();
		}
		currItemId = itemId;olm.menuTree.deleteChildItems(0);		
		if(isReload){
			fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption, noMsg, 'setLoadingEndTree('+currItemId+')');
		}else{
			fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption, noMsg, '');
		}
	}
	
	function setLoadingEndTree(currItemId){ 
		getTreeSubItems(''); 
		if(currItemId == null || currItemId == 'undefined'){
			return false;
		}else{
			olm.menuTree.selectItem(currItemId,false,false);
			olm.getMenuUrl(String(currItemId));
			olm.menuTree.openItem(currItemId);
		}
	}	

	function fnArcDefPage(arcCode,def,pageUrl,itemID){
		var url = "viewArcDefPage.do?arcDefPage="+def+"&pageUrl="+pageUrl+"&defMenuItemID="+itemID+"&arcCode="+arcCode
													+"&defDimTypeID=${defDimTypeID}&defDimValueID=${defDimValueID}";
		mainLayout.attachURL(url);
		var ifr = mainLayout.getFrame();ifr.scrolling="no";
	}
	
	function fnRefreshPage(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
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
	
	function fnOpenAllItems(state){
		var selectedItemID = olm.menuTree.getSelectedItemId();
		
		//var state= olm.menuTree.getOpenState(selectedItemID); // 1:펄쳐짐, -1:닫힘  
		// console.log("selectedItemID :"+selectedItemID+", state :"+state);
		
		if(state == ""){
		    //alert("프로세스를 선택하세요."); return;
		//	olm.menuTree.openAllItems(selectedItemID); return;
		}
		//var forderImg = document.getElementById("forderImg");
		//var newImageUrl = "${root}cmm/common/images/";
		 
		if(state == 1){ // open
			olm.menuTree.openAllItems(selectedItemID);
			//newImageUrl += "/tree_open.png"; 		    
			//forderImg.src = newImageUrl;
		}else{ // close
			olm.menuTree.closeAllItems(selectedItemID);
			//newImageUrl += "/tree_close.png"; 		    
			//forderImg.src = newImageUrl;
		}
	}
		
</script>
</head>
<body style="width:100%; height:100%;">
<form name="orgFrm" id="orgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="menuID" name="menuID"></input>
<input type="hidden" id="udfStructureIDs" name="udfStructureIDs" ></input>
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
