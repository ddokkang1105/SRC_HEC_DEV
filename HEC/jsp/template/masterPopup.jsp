<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set value='<%= request.getParameter("retfnc") %>' var="retfnc"/>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>function closeLoading(){$("#resultDiv").html('');$("#loading").fadeOut(50);}</script>
<c:if test="${!empty title}"><script>parent.document.title="::: XBOLT ::: ${title}";</script></c:if>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>	
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/menuOnloader.jsp"%>

<script type="text/javascript">
	
	var dba={};
	dba.pages={};
	dba.url={};
    var skin = "dhx_skyblue";
    var treeImgPath = "";
	
	jQuery(document).ready(function() {			
		//화면 초기화
		fnInit();
		$('.logout').click(function(){logout();});
		$('#LANGUAGE').change(function(){changeLanguage($(this).val());});
		$('#schClickedURL').change(function(){changeClickedTreeURL($(this).val());});		
		$('#schTreeMenuText').keypress(function(onkey){if(onkey.keyCode == 13){fnSearchTreeText('1');}});		
	});	
	function fnInit(){
		fnSelect('LANGUAGE', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select Language');
		clickMenu('${menuType}', "Home");	
	}	
	//=========================================================================
	//BEGIN ::: LOGIN-LOGOUT	
	function logout() {
		var url = "<c:url value='/login/logout.do'/>";
		var target = "resultLogOut";
		var data = "1=1";
		ajaxPage(url, data, target);
	}
	function fnLoginForm() {parent.fnLoginForm();}
	//END ::: LOGIN-LOGOUT
	//=========================================================================
	function changeLanguage(langType) {
		var url = "languageSetting.do";		
		document.langFrm.action = url;
		document.langFrm.target="blankFrame";
		document.langFrm.submit();
	}
	function doReturnLanguage(){
		location.reload();	
	}		
	function fnCallLanguage(){
		return $('#LANGUAGE option:selected').val();
	}		
	function setInitControl(isSchText, isSchURL, menuName, menuIcon){		
		if(menuName == undefined) menuName = "";
		if(menuIcon == undefined || menuIcon == "") menuIcon = "icon_home.png";
		else menuIcon = "root_" +menuIcon;
		
		var fullText = "<img src='${root}${HTML_IMG_DIR}/"+menuIcon+"'>&nbsp;&nbsp;"+menuName;
		$("#menuFullTitle").val(fullText);
		$("#cntnTitle").html("<span style=color:#0D65B7;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");  /*제목 요기*/

		if(isSchText) $('#schTreeMenuText').val();
			
		if(isSchURL){			
			//Clicked된 URL 초기화
			dba.url={};
			var size = $('#schClickedURL option').size();
			if(size>0 )	$('#schClickedURL').empty();		
		}		
	}	
	//=========================================================================
/** Loyout 초기화  */
	function fnInitOneLayout(){
		
		$("#divSchTreeMenu").hide();
		
		dba.cntnLayout = new dhtmlXLayoutObject("container","2E",skin);
		dba.cntnLayout.items[0].setHeight(30);
		dba.cntnLayout.items[0].fixSize(false, true);	
		dba.cntnLayout.items[0].hideHeader();
		dba.cntnLayout.items[1].hideHeader();
		
		dba.cntnTopObj = dba.cntnLayout.items[0].attachObject("divCntnTop");
	}

	
	function fnInitTwoLayout(){
		
		$("#divSchTreeMenu").show();
		
		dba.layout=new dhtmlXLayoutObject("container","2U",skin);
		dba.layout.setAutoSize("b","a;b"); //가로, 세로		

		dba.layout.items[0].setWidth(250);
		dba.layout.items[1].hideHeader();	

		dba.menuTreeLayout = new dhtmlXLayoutObject(dba.layout.items[0], "2E");		
		dba.menuTreeLayout.items[0].setHeight(30);
		dba.menuTreeLayout.items[0].fixSize(false, true);	
		dba.menuTreeLayout.items[0].hideHeader();
		dba.menuTreeLayout.items[1].hideHeader();
		//dba.menuTreeLayout.items[1].setText("Contents");
		dba.menuSchObj = dba.menuTreeLayout.items[0].attachObject("divSchTreeMenu");
		
		//Tree Setting
		dba.menuTree = dba.menuTreeLayout.items[1].attachTree(0);		
		dba.menuTree.setSkin(skin);
		//dba.menuTree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/csh_winstyle/");
		dba.menuTree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
	  dba.menuTree.attachEvent("onClick",function(id){dba.getMenuUrl(id); return true;});
		dba.menuTree.enableDragAndDrop(false);
		dba.menuTree.enableSmartXMLParsing(true);		
		
		dba.cntnLayout = new dhtmlXLayoutObject(dba.layout.items[1], "2E");
		dba.cntnLayout.items[0].setHeight(30);
		dba.cntnLayout.items[0].fixSize(false, true);	
		dba.cntnLayout.items[0].hideHeader();
		dba.cntnLayout.items[1].hideHeader();
		
		dba.cntnTopObj = dba.cntnLayout.items[0].attachObject("divCntnTop");
	}	
	
	
	function fnInitDtlLayout(type){
		
		dba.dtlBaseLayout = new dhtmlXLayoutObject(dba.cntnLayout.items[1],"2E");
		alert(2);
		dba.dtlBaseLayout.items[0].setHeight(30);
		dba.dtlBaseLayout.items[0].fixSize(false, true);	
		dba.dtlBaseLayout.items[0].hideHeader();
		dba.dtlBaseLayout.items[1].hideHeader();
		
		fnChangeDtlLayout(type);
	}
	dba.get_id_chain=function(tree,id){
		var chain=[id];
		while(id=tree.getParentId(id))
			chain.push(id);
		return chain.reverse().join("|");
	};	
	dba.getMenuUrl=function(id){
		var ids = id.split("_");$('#MENU_ID').val(ids[0]);		
		var url = "menuURL.do";		
		document.menuFrm.action = url;
		document.menuFrm.target="blankFrame";
		document.menuFrm.submit();
	};
	
	//Top메뉴 : Content에 의한 subMain 변경시 쓰일 변수
	var menuOption = "";	
	function creatMenuTab(menuId, menuURL, level)
	{
		var id = menuId;
		var fullId = "";
		var text = "";
		var url = menuURL;		
		if(url == 'null' || url == ''){
			url = "subMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+menuId+"&option="+menuOption+"&url="+menuURL+"&level="+level;
		}
		if( menuURL.length > 0 )	dba.create_tab(id, fullId, text, url, true); 
	}
	
	dba.create_tab=function(id,fullId,text,url,isInclude){
		fullId = id;
		var cntnTitle = text||dba.menuTree.getItemText(id);
		var fullText = $("#menuFullTitle").val();
		fullText = fullText + "&nbsp;::&nbsp;" + cntnTitle;
		$("#cntnTitle").html("<span style=color:#0D65B7;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");  /*제목 요기*/
		
		if(!dba.url[fullId]){
			dba.url[fullId]=fullId+"^"+url;
			dba.cntnLayout.items[1].attachURL(url);			
			if( isInclude){
				$("#schClickedURL").prepend("<option value='"+fullId+"' selected>"+cntnTitle+"</option>");
				$("#schClickedURL").val(fullId);
			}
		}else{
			dba.url[fullId]=fullId+"^"+url;
			dba.cntnLayout.items[1].attachURL(url);
			$("#schClickedURL").val(fullId);
		}
	};	
	function fnGetTreeSubItems(){
		return dba.menuTree.getSubItems(dba.menuTree.getSelectedItemId());
	}	
	//END ::: Contents
	//=========================================================================

	//=============================================================
	//BEGIN ::: MENU
	//트리 메뉴 받아오기
	function getMenu(avg){
		var url = "contentMenu.do";
		var target = "ulmajor";
		var data = "languageID="+avg;
		ajaxPage(url, data, target);
	}
	
	//트리 메뉴 조회 정보
	function setMenuTreeData(data) {

		if(data == undefined) data = "";
		
		var result = new Object();
		result.title = "${title}";
		result.key = "menu_SQL.menuTreeList";
		result.header = "TREE_ID, PRE_TREE_ID,TREE_NM";
		result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM";
		result.data = data ;

		return result;
	}	
	//메뉴 선택
	function clickMenu(menuType, menuName, menuIcon, defDimValueID, menuStyle){
		
		$("#MENU_SELECT").val(menuType);

		var url = "";
		var name = "";
		//var isChangeTop = false;
		var isChangeTop = 1;
		var isChangeLayout = true;
		var changeCheck = true;
		
		if(defDimValueID == undefined) defDimValueID = "";
		
		if(menuStyle == undefined || menuStyle =="") menuStyle = "csh_winstyle";
		treeImgPath = menuStyle;
		
		if( menuType == undefined || menuType == ""){
			alert("현재 개발중입니다.");
		} else if(menuType == "HOME"){  
			url = "boardMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType=1";
			name = "게시판";
		} else if(menuType == "ADMIN"){
			isChangeTop = 3;
			url = "boardAdminMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType=1";
			name = "게시판";		
		} else if(menuType == "SEARCH"){
			changeCheck = false;
			url = "searchList.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			name = "검색";
		} else if(menuType == "FORUM"){
			changeCheck = false;
			url = "forumMgt.do?noticType=100";
			name = "포럼";
		} else if(menuType == "ANALYSIS"){
			changeCheck = false;
			url = "analysisMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&reportType=1";
			name = "분석/보고서";		
		} else if(menuType == "MYPAGE"){
			isChangeTop = 2;
			url = "reportMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&reportType=1";
			name = "MYPAGE";
		} else if(menuType == "ChangeManagement"){
			changeCheck = false;
			url = "changeManagement.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&reportType=1";
			name = "ChangeManagement";
		} else if(menuType == "AR040210"){
			changeCheck = false;
			url = "ProcessNew.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=PC1";
			name = "ChangeManagement";
		} else {
			changeCheck = false;
			getCategory(menuType, defDimValueID);			
		}		
		if(url.length > 0){
			goMenu(url, name, isChangeTop, isChangeLayout, changeCheck);
			setInitControl(false, true, menuName, menuIcon);
		} else{
			setInitControl(true, true, menuName, menuIcon);
		}

	}
	function goMenu(url, name, isChangeTop, isChangeLayout, changeCheck){
		if( isChangeLayout) fnInitOneLayout();
		fnChangeTopMenuStyle(isChangeTop, changeCheck);
		dba.create_tab(100, "", name, url, false);		
	}
	//대메뉴 선택시 트리 메뉴 조회
	function getCategory(avg, defDimValueID){
		fnInitTwoLayout();		
		menuOption = avg;
		dba.menuTree.getSelectedItemId();
		dba.menuTree.deleteChildItems(0);//초기화
		
		var data = "";
		if( defDimValueID != "") data = "DefDimValueID="+defDimValueID;
		var d = setMenuTreeData(data);
		fnLoadDhtmlxTreeJson(dba.menuTree, d.key, d.cols, d.data, avg);
	}
	function fnChangeTopMenuStyle(isHeader, changeCheck){	
		if(changeCheck){
			for(var i=1; i<5 ; i++){
				if(isHeader == i){
					$("#slidemenu0"+i).attr("style", "display:block");
				}else{
					$("#slidemenu0"+i).attr("style", "display:none");
				}
			}
		}
	}
	//END ::: MENU
	//=============================================================	
	
	//트리 메뉴에서 '이전', '다음' 검색
	function fnSearchTreeText(type){
		//1:검색, 2:다음, 3:이전
		if(type == "1") dba.menuTree.findItem(document.getElementById('schTreeMenuText').value,0,1);
		else if(type == "2") dba.menuTree.findItem(document.getElementById('schTreeMenuText').value);
		else if(type == "3") dba.menuTree.findItem(document.getElementById('schTreeMenuText').value,1);		
	}	
	function changeClickedTreeURL(avg)
	{
		var fullId = avg;
		var chkIdx = $("#schClickedURL option").index( $('#schClickedURL option:selected'));
		var idxSize = 0;

		if(avg == "PRE"){
			idxSize = $('#schClickedURL option:selected').nextAll().size();
			if(  idxSize > 0){ 
				chkIdx = chkIdx +1;
				$('#schClickedURL option:eq('+chkIdx+')').attr("selected", "selected");				
			}
		} else if(avg == "POST"){
			idxSize = $('#schClickedURL option:selected').prevAll().size();
			if(  idxSize > 0){ 
				chkIdx = chkIdx -1;
				$('#schClickedURL option:eq('+chkIdx+')').attr("selected", "selected");
			}
		}
		fullId = $('#schClickedURL option:selected').val();

		url = dba.url[fullId].split("^");
		dba.cntnLayout.items[1].attachURL(url[1]);
		
		dba.menuTree.selectItem(fullId,true,false);
	}

	//해당되는 itemId로 트리 리로드
	var currItemId = "";
	function fnSearchTreeId(itemId){
		if(itemId == null || itemId == undefined){itemId = dba.menuTree.getSelectedItemId();}	
		currItemId = itemId;		
		dba.menuTree.deleteChildItems(0);//초기화
		
		var d = setMenuTreeData();
		var noMsg = "";
		fnLoadDhtmlxTreeJson(dba.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		
		dba.menuTree.setOnLoadingEnd(fnEndLoadTree);
	}
	function fnEndLoadTree(){
		dba.menuTree.openItem(1);
		if(currItemId == null || currItemId == undefined){return false;}
		else dba.menuTree.selectItem(currItemId,true,false);
	}
	 
</script>
</head>

<body>
<input type="hidden" id="menuFullTitle"></input>
<div id="maincontainer">
	<!-- BEGIN ::: TOP -->
	<div id="topsection">
		<div class="floatL"><img src="${root}${HTML_IMG_DIR}/logo.png" onclick="fnChangeTopMenuStyle('1', true)" /></div>
		<div id="MemInfo">
			<ul>
				<li><font style="color:#0D65B7;font-weight:bold;"><u>${sessionScope.loginInfo.sessionUserNm}</u></font> Loged In</li>
				<li><form name="langFrm" id="langFrm" action="#" method="post" onsubmit="return false;">
					<select name="LANGUAGE" id="LANGUAGE" class="text" style="height:20px;width:120px"></select>
					</form>
				</li>
				<li onclick="fnChangeTopMenuStyle('4', true)"><span class="btn_pack small icon">
					<span class="mypage"></span><a href="#">My page</a>
					</span>
				</li>				
				<li><span class="btn_pack small icon">
					<span class="faq"></span><a href="#">Help</a>
					</span>
				</li>
				<li class="logout">				
					<span class="btn_pack small icon">
					<span class="logoutB"></span><a href="#">Logout</a>
					</span>
				</li>
			</ul>
		</div>
	</div>
	<!--END::TOP -->	
	<!-- BEGIN ::: MENU -->
	<!-- END ::: MENU -->
	<!-- BEGIN ::: CONTENTS -->
	<div id="contentwrapper">		
		<!-- BEGIN ::: SHORT MENU -->
		<div id="leftcolumn">
		</div>
		<!-- END ::: SHORT MENU -->		
		<div id="nonecontentcolumn">		
			<div class="container" id="container">
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
			 </div>	
	
			<div id="divSchTreeMenu" style="display:block">
				<input type="text" class="text" id="schTreeMenuText" style="width:120px;ime-mode:active;"/><a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a><a onclick="fnSearchTreeText('2')"> 다음</a> |<a onclick="fnSearchTreeText('3')"> 이전 </a>
			</div>	
			
			<div id="divCntnTop" style="display:block;">
				<div class="floatL" id="cntnTitle" ></div>
				<div class="cntnTitleR">
					<ul>
						<li>
							<a href="javascript:void(0)" onclick="changeClickedTreeURL('PRE')"><img src="${root}${HTML_IMG_DIR}/icon_page_pre.png" alt="이전"/></a>
						</li>
						<li>
							<select id="schClickedURL" name="schClickedURL" style="width:150px"></select>
						</li>
						<li>
							<a href="javascript:void(0)" onclick="changeClickedTreeURL('POST')"><img src="${root}${HTML_IMG_DIR}/icon_page_next.png" alt="다음"/></a>
						</li>
					</ul>
				</div>
			</div>
			<div id="divCntn" ></div>
		</div>
	</div>
<!-- END ::: CONTENTS -->
</div>
<div id="resultLogOut"></div>
</body>
</html>