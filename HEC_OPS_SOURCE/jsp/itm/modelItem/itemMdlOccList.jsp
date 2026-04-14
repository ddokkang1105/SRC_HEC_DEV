<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034"   arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00112" var="WM00112"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>

<script>
	var p_gridMLArea;				//그리드 전역변수
	var itemAthId = "${selectedItemAuthorID}";
	var blocked = "${selectedItemBlocked}";
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var selectedItemStatus = "${selectedItemStatus}";
	
	$(document).ready(function(){		
		// 초기 표시 화면 크기 조정 
		$("#grdGridMLArea").attr("style","height:"+(setWindowHeight() - 120)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridMLArea").attr("style","height:"+(setWindowHeight() - 120)+"px;");
		};
		
		$("#excel").click(function(){p_gridMLArea.toExcel("${root}excelGenerate");});
		$('#searchKey').change(function(){
			//$('input:text[id^=search]').each(function(){$(this).hide();});
			if($(this).val() != ''){$('#search' + $(this).val()).show();}
		});
		gridMLInit();		
		doSearchMLList();
		//alert("${url}");
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function doSearchMLList(){
		var d = setGridMLData();
		fnLoadDhtmlxGridJson(p_gridMLArea, d.key, d.cols, d.data);
	}
	function gridMLInit(){	
		var d = setGridMLData();
		p_gridMLArea = fnNewInitGrid("grdGridMLArea", d);
		p_gridMLArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridMLArea.setIconPath("${root}${HTML_IMG_DIR}/");
		//p_gridMLArea.setColumnHidden(1, true);
		p_gridMLArea.setColumnHidden(7,true);
		p_gridMLArea.setColumnHidden(8,true);
		p_gridMLArea.setColumnHidden(11, true);
		p_gridMLArea.setColumnHidden(13, true);
		p_gridMLArea.setColumnHidden(14, true);
		p_gridMLArea.setColumnHidden(15, true);
		p_gridMLArea.setColumnHidden(16, true);
		p_gridMLArea.setColumnHidden(17, true);
		
		p_gridMLArea.setColumnHidden(18, true);
		p_gridMLArea.setColumnHidden(19, true);
		p_gridMLArea.setColumnHidden(20, true);
		p_gridMLArea.setColumnHidden(21, true);
		p_gridMLArea.setColumnHidden(22, true);
		
		fnSetColType(p_gridMLArea, 1, "ch");//ra : radio
		
		p_gridMLArea.attachEvent("onRowSelect", function(id,ind){gridMLOnRowSelect(id,ind);});
		//p_gridMLArea.attachEvent("onRowDblClicked", gridMLOnRowDblClicked);
		fnSetColType(p_gridMLArea, 12, "img");
		fnSetColType(p_gridMLArea, 14, "img");
	}
	
	
	function setGridMLData(){
		var myItem = "${myItem}";
		var viewYN = "Y";
		if((itemAthId == userId || "${sessionScope.loginInfo.sessionUserId}" == userId) && myItem == 'Y' ){viewYN = "N";}
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getItemMdlOccList"; // model_SQL.getModelList
		result.header = "${menu.LN00024},#master_checkbox,Model No.,${menu.LN00028},${menu.LN00032},${menu.LN00033},${menu.LN00027},${menu.LN00004},${menu.LN00013},${menu.LN00060},${menu.LN00070},ItemID,${menu.LN00125},Blocked,${menu.LN00031},${menu.LN00031},${menu.LN00027},IsPublic,ItemAuthorID,ItemBlocked,ItemStatus,URL,ChangeSetID";
		result.cols = "CHK|ModelID|ItemName|ModelTypeName|MTCName|StatusName|Creator|CreationTime|UserName|LastUpdated|ItemID|BtnControl|Blocked|BtnControl|MTCategory|StatusCode|IsPublic|ItemAuthorID|ItemBlocked|ItemStatus|URL|ChangeSetID";
		result.aligns = "center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
	
		result.widths = "30,30,80,*,130,100,100,80,100,100,80,70,70,70,70,70,70,70,70,70,70,70";
		result.sorting = "int,int,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.data = "s_itemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			        + "&searchKey="     + $("#searchKey").val()
			        + "&searchValue="     	+ $("#searchValue").val()
			        + "&viewYN="+viewYN;
					
		return result;
	}
	
	function gridMLOnRowSelect(id, ind){
		$("#newModel").attr('style', 'display: none');
		$("#divTabModelAdd").attr('style', 'display: none');
	
		var modelBlocked = p_gridMLArea.cells(id,13).getValue();
		var modelId = p_gridMLArea.cells(id, 2).getValue();
		var itemId = p_gridMLArea.cells(id, 11).getValue();
		var ItemTypeCode = $("#ItemTypeCode").val(); 
		var MTCategory = p_gridMLArea.cells(id,15).getValue();
		var ModelStatus= p_gridMLArea.cells(id,6).getValue();
		var Creator	= p_gridMLArea.cells(id,7).getValue();
		var CreationTime = p_gridMLArea.cells(id,8).getValue();
		var UserName = p_gridMLArea.cells(id,9).getValue();
		var LastUpdated = p_gridMLArea.cells(id,10).getValue();
		var modelName = p_gridMLArea.cells(id,3).getValue();
		var ModelStatusCode = p_gridMLArea.cells(id,16).getValue();
		var ModelTypeName = p_gridMLArea.cells(id,4).getValue();
		var ModelIsPublic = p_gridMLArea.cells(id,17).getValue(); 
		var myItem = "${myItem}";
		var menuUrl = p_gridMLArea.cells(id,21).getValue(); 
		var changeSetID = p_gridMLArea.cells(id,22).getValue(); 
		var scrnType = "";
		
		itemAuthId = p_gridMLArea.cells(id,18).getValue(); 
		blocked = p_gridMLArea.cells(id,19).getValue(); 
		selectedItemStatus =  p_gridMLArea.cells(id,20).getValue(); 
		
		if(ind == 12){// Model PopUp		
			if(MTCategory == "VER" || blocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
			   scrnType =  "view";
			}else{	
				if(ModelIsPublic == 1){
					scrnType = "edit";					
				} else{
					if((itemAthId == userId || "${sessionScope.loginInfo.sessionUserId}" == userId) && modelBlocked == "0" && myItem == 'Y' ){
						scrnType = "edit";	
					} else{
						scrnType = "view";
					}
				}
				
			}
			var url = "popupMasterMdlEdt.do?"
					+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID="+itemId
					+"&modelID="+modelId
					+"&scrnType="+scrnType
					+"&MTCategory="+MTCategory
					+"&modelName="+encodeURIComponent(modelName)
				    +"&modelTypeName="+encodeURIComponent(ModelTypeName)
					+"&menuUrl="+menuUrl
					+"&selectedTreeID=${s_itemID}"
					+"&changeSetID="+changeSetID;
			
			var w = 1200;
			var h = 900;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}else{
			// [rowClick] 이벤트 : 개요 화면 Occurrence
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,itemId);
		}
	}
	
	// END ::: GRID	
	//===============================================================================
		
	function callbackDelete(){
		reloadList();
	}	
		
	function reloadList(){
		doSearchMLList();
		parent.top.fnSearchTreeId('${s_itemID}', true);
	}
		
	// [back] click
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}	
	
</script>
<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
	<div id="divMDList" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="itemID" name="itemID">
	<input type="hidden" id="ItemID" name="ItemID">
	<input type="hidden" id="checkIdentifierID" name="checkIdentifierID">
	<input type="hidden" id="itemDelCheck" name="itemDelCheck" value="N">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="level" name="level" value="${request.level}">
	<input type="hidden" id="Auth" name="Auth" value="${sessionScope.loginInfo.sessionLogintype}">	
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" />	
	<input type="hidden" id="fromItemID" name="fromItemID" >	
	<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="itemAuthID" name="itemAuthID" value="${itemAthId}">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}" >
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
	<input type="hidden" id="ModelIDS" name="ModelIDS" >
	<input type="hidden" id="projectID" name="projectID" value="${itemInfo.ProjectID}" >
	<input type="hidden" id="changeSetID" name="changeSetID" value="${itemInfo.CurChangeSet}" >
	<div style="overflow:auto;overflow-x:hidden;">			
		<div class="child_search">
		 <li class="shortcut">
		 	<img src="${root}${HTML_IMG_DIR}/img_folderClosed.png"></img>&nbsp;&nbsp;<b>Occurrence list</b>&nbsp;&nbsp;&nbsp;
	 	 </li>
		</div>
		<div class="countList">
	         <li class="count">Total  <span id="TOT_CNT"></span></li>
	         <li class="floatR">&nbsp;</li>
			 <li style="padding-left:100px !important;float:left;">
	           <select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID" <c:if test="${!empty searchID}"> selected="selected" </c:if> >ID</option>
				</select>			
				<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchMLList()" value="검색">
		   	 </li>
			 <li class="floatR pdR20">	
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goNewItemInfo();" type="submit"></span>	
			</li>
	    </div>
		<div id="gridMLDiv" class="mgB10 clear">
			<div id="grdGridMLArea" style="width:100%"></div>
		</div>
	</div>
 </div>
</form>
<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
	