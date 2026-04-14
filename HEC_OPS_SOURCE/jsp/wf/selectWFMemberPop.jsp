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
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00155" var="WM00155"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00094}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">
	var olm={};	olm.pages={};olm.url={};
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var agrSeq = "${agrSeq}";
	var gridArea1;
	var gridArea2;
	var memberID = "${sessionScope.loginInfo.sessionUserId}";
	var memberName = "${sessionScope.loginInfo.sessionUserNm}";
	var teamName = "${sessionScope.loginInfo.sessionTeamName}";
	var agreeYN = "${agrYN}";
	var agreeCnt = 0;
	var aprvCnt = 0;
	var selTeamID = "";
	var selTeamName = "";
	var searchMember = "";
	
	window.onload=setConfFrmInit;
	jQuery(document).ready(function() {	
		gridInit1("");
		gridInit2();
		var unfold = "${unfold}";
		getCategory("${arcCode}");
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				searchTreeText("1");
				return false;
			}
		});	
		$("#searchValue").val("");
		
		$('.cmm_member_btnList').height(setWindowHeight() - 47);
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSetUnfoldTree() { 
		if (olm.menuTree != null) {
			olm.menuTree.closeAllItems(0);
			var ch = olm.menuTree.hasChildren(0);
			for (var i = 0; i < ch; i++) {
				var lev1 = olm.menuTree.getChildItemIdByIndex(0, i);
				olm.menuTree.openItem(lev1);
			}
		}
	}

	function setConfFrmInit() {
		if (window.attachEvent) {
			window.attachEvent("onresize", resizeLayout);
		} else {
			window.addEventListener("resize", resizeLayout, false);
		}
		var t;
		function resizeLayout() {
			window.clearTimeout(t);
			t = window.setTimeout(function() {
				setScreenResize();
			}, 200);
		}
	}
	function getHeight() {
		return (document.body.clientHeight);
	}
	function getWidth() {
		return (document.body.clientWidth);
	}
	function setScreenResize() {
		//document.all.container.width = getWidth() + "px";
		//document.all.container.height = getHeight() + "px";
		if (baseLayout == null) {
			if (cntnLayout != null && cntnLayout != undefined) {
				cntnLayout.setSizes();
			}
		} else {
			var minWidth = lMinWidth + rMinWidth;
			var wWidth = document.body.clientWidth;
			if (minWidth > wWidth) {
				baseLayout.items[0].setWidth(lMinWidth);
			}
			baseLayout.setSizes();
		}
	}

	function setInitTwoLayout() {		
		//document.getElementById('container').style.height=getHeight()+'px';
		var scrpt = fnSetScriptMasterDiv();
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}		
		baseLayout=new dhtmlXLayoutObject("container",layout_1C,dhx_skin_skyblue);
		baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;
		//baseLayout.setAutoSize("b","a;b");
		baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});
		baseLayout.items[0].setWidth(250);
		baseLayout.items[0].setText(scrpt.treeTop);
		//baseLayout.items[1].hideHeader();	
		olm.menuTree = baseLayout.items[0].attachTree(0);
		olm.menuTree.setSkin(dhx_skin_skyblue);
		olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");
		olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});
		olm.menuTree.enableDragAndDrop(false);olm.menuTree.enableSmartXMLParsing(true);	
		cntnLayout = baseLayout.items[1];
		mainLayout = baseLayout.items[1];
	}

	function setLayoutResize() {
		var minWidth = lMinWidth + rMinWidth;
		var lWidth = baseLayout.items[0].getWidth();
		var rWidth = baseLayout.items[1].getWidth();
		var wWidth = document.body.clientWidth;
		if (lWidth < lMinWidth) {
			baseLayout.items[0].setWidth(lMinWidth);
		}
		if (wWidth >= minWidth && rWidth < rMinWidth) {
			baseLayout.items[1].setWidth(rMinWidth);
		}
	}

	olm.getMenuUrl = function(id) {
		var ids = id.split("_");
		selTeamName = olm.menuTree.getItemText(id);
		selTeamID = ids[0];
		currItemId = ids[0];
		
		doSearchList1(currItemId);

	};

	function getCategory(avg) {
		setInitTwoLayout();
		menuOption = avg;
		olm.menuTree.getSelectedItemId();
		olm.menuTree.deleteChildItems(0);
		var data = "";
		var d = fnSetMenuTreeData(data);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg); // 트리로드 
	}

	function searchTreeText(type) {
		var schText = $("#schTreeText").val();
		if (schText == "") {
			alert("${WM00045}");
			return false;
		}
		if (type == "1") {
			olm.menuTree.findItem(schText, 0, 1);
		} else if (type == "2") {
			olm.menuTree.findItem(schText);
		} else if (type == "3") {
			olm.menuTree.findItem(schText, 1);
		}
	}

	function fnRefreshTree(itemId, isReload) {
		var d = fnSetMenuTreeData();
		var noMsg = "";
		if (isReload == null || isReload == 'undefined' || isReload == "null") {
			isReload = false;
		}
		if (itemId == null || itemId == 'undefined' || itemId == "null") {
			itemId = olm.menuTree.getSelectedItemId();
		}
		currItemId = itemId;
		olm.menuTree.deleteChildItems(0);
		fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,
				noMsg);
		if (isReload) {
			olm.menuTree.setOnLoadingEnd(setLoadingEndTree);
		}
	}

	function setLoadingEndTree(prtItemId) {
		if (prtItemId == null || prtItemId == 'undefined') {
			prtItemId = 1;
		}
		olm.menuTree.openItem(prtItemId);
		if (currItemId == null || currItemId == 'undefined') {
			return false;
		} else {
			olm.menuTree.selectItem(currItemId, true, false);
		}
	}

	function fnAssignInfo(wfStepInfo, memberIDs, roleTypes) {
		var rowIDs = gridArea2.getAllRowIds().split(",");
		var afterSI = "";
		var afterID = "";
		var afterRT = "";
		var beforeSI = "";
		var beforeID = "";
		var beforeRT = "";
		var tempSI = "";
		var tempID = "";
		var tempRT = "";
		var mgrCnt = 0;
		var rewCnt = 0;

		for (var i = 0; i < rowIDs.length; i++) {
			
			var rt = gridArea2.cells(rowIDs[i],9).getValue();
			if (rt == "PAGR") {											
				tempSI = tempSI +(mgrCnt == 0 ? " >> " : ", ") + gridArea2.cells(rowIDs[i],7).getValue()+"("+gridArea2.cells(rowIDs[i],4).getValue()+"/${wfLabel.PAGR})";
				tempID = tempID + "," + gridArea2.cells(rowIDs[i],6).getValue();
				tempRT = tempRT + "," + gridArea2.cells(rowIDs[i],9).getValue();

				mgrCnt++;
			} else if (rt == "REW" && mgrCnt == 0) {											
				afterSI = afterSI +(rewCnt == 0 ? " >> " : ", ") + gridArea2.cells(rowIDs[i],7).getValue()+"("+gridArea2.cells(rowIDs[i],4).getValue()+"/${wfLabel.REW})";
				afterID = afterID + "," + gridArea2.cells(rowIDs[i],6).getValue();
				afterRT = afterRT + "," + gridArea2.cells(rowIDs[i],9).getValue();

				rewCnt++;
			} else if (rt == "REW" && mgrCnt > 0 ) {											
				beforeSI = beforeSI +(rewCnt == 0 ? " >> " : ", ") + gridArea2.cells(rowIDs[i],7).getValue()+"("+gridArea2.cells(rowIDs[i],4).getValue()+"/${wfLabel.REW})";
				beforeID = beforeID + "," + gridArea2.cells(rowIDs[i],6).getValue();
				beforeRT = beforeRT + "," + gridArea2.cells(rowIDs[i],9).getValue();

				rewCnt++;
			} else if (rt != "PAGR" && mgrCnt == 0) {
				afterSI = afterSI + " >> " + gridArea2.cells(rowIDs[i],7).getValue()+"("+gridArea2.cells(rowIDs[i],4).getValue()+(rt == "AGR" ? "/${wfLabel.AGR})" : "/${wfLabel.APRV})");
				afterID = afterID + "," + gridArea2.cells(rowIDs[i],6).getValue();
				afterRT = afterRT + "," + gridArea2.cells(rowIDs[i],9).getValue();
				rewCnt = 0;
			} else if (rt != "PAGR"  && mgrCnt > 0 ) {
				beforeSI = beforeSI + " >> " + gridArea2.cells(rowIDs[i],7).getValue()+"("+gridArea2.cells(rowIDs[i],4).getValue()+(rt == "AGR" ? "/${wfLabel.AGR})" : "/${wfLabel.APRV})");
				beforeID = beforeID + "," + gridArea2.cells(rowIDs[i],6).getValue();
				beforeRT = beforeRT + "," + gridArea2.cells(rowIDs[i],9).getValue();
				rewCnt = 0;
			}
		}
		
		wfStepInfo = memberName+"("+teamName+")" + afterSI + tempSI + beforeSI;
		memberIDs = memberID + afterID + tempID + beforeID;
		roleTypes = "AREQ" + afterRT + tempRT + beforeRT;
		
		window.opener.fnSetWFStepInfo(wfStepInfo, memberIDs, roleTypes,
				mgrCnt, "${agrYN}");
		
		window.self.close();
	}

	function fnSetWFOtherInfo() {

		window.opener.fnSetWFStepInfo2($("#wfStepRefIDs").val(),$("#wfStepRefInfo").val(),$("#wfStepRecIDs").val(),$("#wfStepRecInfo").val(),$('#wfStepRecTeamIDs').val());
		window.self.close();
	}

	function gridInit1(){		
		var d = setGridData1();		
		gridArea1 = fnNewInitGrid("gridArea1", d);
		gridArea1.setImagePath("${root}${HTML_IMG_DIR}/");
		//gridArea1.setIconPath("${root}${HTML_IMG_DIR_MEMBER}/");
		gridArea1.setColumnHidden(0, true);	
		//gridArea1.setColumnHidden(2, true);
		gridArea1.setColumnHidden(3, true);
		//gridArea1.setColumnHidden(4, true);	
		gridArea1.setColumnHidden(5, true);	
		gridArea1.setColumnHidden(6, true);		
		gridArea1.setColumnHidden(7, true);		
		fnSetColType(gridArea1, 1, "ch");
	}
	function gridInit2(){		
		var d = setGridData2();
		
		gridArea2 = fnNewInitGrid("gridArea2", d);
		gridArea2.setImagePath("${root}${HTML_IMG_DIR}/"); //path to images required by grid
		gridArea2.setColumnHidden(0, true);
		//gridArea2.setColumnHidden(1, true);
		gridArea2.setColumnHidden(2, true);
		//gridArea2.setColumnHidden(3, true);
		gridArea2.setColumnHidden(4, true);
		//gridArea2.setColumnHidden(5, true);
		gridArea2.setColumnHidden(6, true);
		gridArea2.setColumnHidden(7, true);
		//gridArea2.setColumnHidden(8, true);
		gridArea2.setColumnHidden(9, true);
		fnSetColType(gridArea2, 1, "ch");
	}
	
	function setGridData1(teamID){// 선택할 멤버 
		var result = new Object();
		result.title = "${title}";
		result.key = "wf_SQL.getWfMemberList";		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberName,${menu.LN00247},TeamPath,MemberID,Name";
		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name";
		result.widths = "30,30,210,100,150,50,50,0";
		result.sorting = "int,int,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
					+ "&teamID="+teamID
					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
					+ "&assignmentYN=Y"
					+ "&selectMember=${selectMember}";
					
		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
			result.data = result.data +"&searchKey="+ $("#searchKey").val();
			result.data = result.data +"&searchValue="+ $("#searchValue").val();
		}
		
		return result;
	}
	
	function setGridData2(){// 선택된 멤버
		var result = new Object();
		result.title = "${title}";
		result.key = "wf_SQL.getWfMemberList";		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},${menu.LN00037},TeamName,${menu.LN00247},MemberID,Name,Role,RoleCode";
		result.cols = "CHK|MemberInfo|MemberName|TeamName|TeamPath|MemberID|Name|Role|RoleCode";
		result.widths = "30,30,30,120,10,200,30,50,30";
		result.sorting = "int,int,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
						+ "&teamId=${teamID}"
						+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
						+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
						+ "&assignmentYN=Y"
						+ "&selectMember=${selectMember}"
						+ "&tmpSelSHR=${tmpSelSHR}"						
						+ "&secYN=Y";
		return result;
	}

	
	function doSearchList1(NT){
		var d = setGridData1(NT);
		var selectMember = searchMember;

		if(NT == "NT") {

			d.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
				+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.jpg"
				+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
				+ "&selectMember="+selectMember
				+ "&assignmentYN=Y";
				
				if($("#searchValue").val() != '' && $("#searchValue").val() != null){
					d.data = d.data +"&searchKey="+ $("#searchKey").val();
					d.data = d.data +"&searchValue="+ $("#searchValue").val();
				}
		}
		
		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
	}
	
	function doSearchList2(){
		var d = setGridData2();
		fnLoadDhtmlxGridJson(gridArea2, d.key, d.cols, d.data);
	}
	

	function doClickMove(toRight){ 
		var sourceGrid, targetGrid;
		if(toRight == 'D'){
			sourceGrid = gridArea2;
			targetGrid = gridArea1;
		}else{
			sourceGrid = gridArea1;
			targetGrid = gridArea2;
			
		}

		var moveRowStr = sourceGrid.getCheckedRows(1);
		if((moveRowStr == null || moveRowStr.length == 0) && toRight != 'C'){alert("${WM00029}");return;}
		var moveRowArray = moveRowStr.split(',');

		if(toRight == 'H'){
			for(var i = 0 ; i < moveRowArray.length ; i++){		

				if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
				}
				else {
					searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
				}
				
				if ($('#actor').val() == ""  || $('#actor').val() == undefined) {	
					$('#actor').val(memberID+","+gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val("AREQ,AGR");
					wfStepInfo = memberName+"("+teamName+") >>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.AGR})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {						
					$('#actor').val($('#actor').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val($('#wfStepID').val()+ "," + "AGR" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.AGR})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
				                          ,"${wfLabel.AGR}"	       
				                          ,"AGR"
				                          ]				
										  , targetGrid.getRowsNum());
			}
		} else if(toRight == 'P'){
			for(var i = 0 ; i < moveRowArray.length ; i++){		

				if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
				}
				else {
					searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
				}
				
				if ($('#actor').val() == ""  || $('#actor').val() == undefined) {	
					$('#actor').val(memberID+","+gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val("AREQ,PAGR");
					wfStepInfo = memberName+"("+teamName+") >>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.PAGR})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {						
					$('#actor').val($('#actor').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val($('#wfStepID').val()+ "," + "PAGR" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.PAGR})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
				                          ,"${wfLabel.PAGR}"	       
				                          ,"PAGR"                        
				                          ]				
										  , targetGrid.getRowsNum());				
			}
		}else if(toRight == 'S'){
			for(var i = 0 ; i < moveRowArray.length ; i++){	

				if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}
				
				if(searchMember == "") {
					searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
				}
				else {
					searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
				}
				
				if ($('#actor').val() == "" || $('#actor').val() == undefined) {
					$('#actor').val(memberID+","+gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val("AREQ,APRV");
					wfStepInfo = memberName+"("+teamName+") >>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.APRV})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {	
					$('#actor').val($('#actor').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val($('#wfStepID').val()+ "," + "APRV" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.APRV})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
				                          ,"${wfLabel.APRV}"	           
				                          ,"APRV"                    
				                          ]				
										  , targetGrid.getRowsNum());
				aprvCnt++;

			}
		}else if(toRight == 'W'){
			for(var i = 0 ; i < moveRowArray.length ; i++){	

				if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}

				if(searchMember == "") {
					searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
				}
				else {
					searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
				}
				
				if ($('#actor').val() == "" || $('#actor').val() == undefined) {
					$('#actor').val(memberID+","+gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val("AREQ,REW");
					wfStepInfo = memberName+"("+teamName+") >>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.REW})";
					$('#wfStepInfo').val(wfStepInfo);
				} else {	
					$('#actor').val($('#actor').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepID').val($('#wfStepID').val()+ "," + "REW" );
					wfStepInfo = $('#wfStepInfo').val()+ ">>"+gridArea1.cells(moveRowArray[i],7).getValue()+"("+gridArea1.cells(moveRowArray[i],4).getValue()+"/${wfLabel.REW})";
					$('#wfStepInfo').val(wfStepInfo);
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
				                          ,"${wfLabel.REW}"	           
				                          ,"REW"                    
				                          ]				
										  , targetGrid.getRowsNum());
				aprvCnt++;

			}
		}else if(toRight == 'R'){
			for(var i = 0 ; i < moveRowArray.length ; i++){		

				if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
					alert("${WM00162}");
					continue;
				}

				if(searchMember == "") {
					searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
				}
				else {
					searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
				}
				
				if ($('#wfStepRefInfo').val() == "" || $('#wfStepRefInfo').val() == undefined) {
					$('#wfStepRefIDs').val(gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepRefInfo').val(gridArea1.cells(moveRowArray[i],7).getValue());
					
				} else {				
					$('#wfStepRefIDs').val($('#wfStepRefIDs').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());
					$('#wfStepRefInfo').val($('#wfStepRefInfo').val() + "," + gridArea1.cells(moveRowArray[i],7).getValue());
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
				                          ,"${wfLabel.REF}"	         
				                          ,"REF"                      
				                          ]				
										  , targetGrid.getRowsNum());

			}
		}else if(toRight == 'C'){
			if((moveRowStr == null || moveRowStr.length == 0) && selTeamID != "") {		
				if(checkSelectItem(selTeamID)) {
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ selTeamName +"'/>"
					alert("${WM00162}");
					return false;
				}
				
				if ($('#wfStepRecTeamIDs').val() != "" && $('#wfStepRecTeamIDs').val() != undefined) {
					
					$('#wfStepRecTeamIDs').val($('#wfStepRecTeamIDs').val() + "," + selTeamID);
				}
				else {
					$('#wfStepRecTeamIDs').val(selTeamID);
				}
				
				if ($('#wfStepRecInfo').val() == "" || $('#wfStepRecInfo').val() == undefined) {
					$('#wfStepRecInfo').val(selTeamName);					
				} else {				
					$('#wfStepRecInfo').val( $('#wfStepRecInfo').val() + "," + selTeamName);
				}
				
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,selTeamID
				                          ,selTeamName
				                          ,selTeamID
				                          ,selTeamName
				                          ,selTeamID
				                          ,selTeamName
				                          ,"${wfLabel.REC}"	       
				                          ,"REC"                        
				                          ]				
										  , targetGrid.getRowsNum());

				selTeamID = "";
				selTeamName = "";
			}
			else {
				for(var i = 0 ; i < moveRowArray.length ; i++){		
					if(checkSelectItem(gridArea1.cells(moveRowArray[i],6).getValue())) {
					var id = gridArea1.cells(moveRowArray[i],7).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00162' var='WM00162' arguments='"+ id + "'/>";
						alert("${WM00162}");
						continue;
					}

					if(searchMember == "") {
						searchMember = gridArea1.cells(moveRowArray[i],6).getValue();
					}
					else {
						searchMember += "," + gridArea1.cells(moveRowArray[i],6).getValue();
					}
					
					if ($('#wfStepRecIDs').val() != "" && $('#wfStepRecIDs').val() != undefined) {		
						$('#wfStepRecIDs').val($('#wfStepRecIDs').val() + "," + gridArea1.cells(moveRowArray[i],6).getValue());			
					}
					else {
						$('#wfStepRecIDs').val(gridArea1.cells(moveRowArray[i],6).getValue());
					}
										
					if ($('#wfStepRecInfo').val() == "" || $('#wfStepRecInfo').val() == undefined) {						
						$('#wfStepRecInfo').val(gridArea1.cells(moveRowArray[i],7).getValue());
					} else {				
									
						$('#wfStepRecInfo').val($('#wfStepRecInfo').val() + "," + gridArea1.cells(moveRowArray[i],7).getValue());
					}
					
					var newId = (new Date()).valueOf();
					targetGrid.addRow(newId, [newId
					                          ,"0"
					                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
					                          ,sourceGrid.cells(moveRowArray[i],3).getValue()
					                          ,sourceGrid.cells(moveRowArray[i],4).getValue()
					                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
					                          ,sourceGrid.cells(moveRowArray[i],6).getValue() 
					                          ,sourceGrid.cells(moveRowArray[i],7).getValue()
					                          ,"${wfLabel.REC}"	
					                          ,"REC"
					                          ]				
											  , targetGrid.getRowsNum());
	
				}
			}
		}else if(toRight == 'D'){			
			var beforeSearchMember = searchMember.split(',');
			
			if(beforeSearchMember.length == 1)
				beforeSearchMember = "";

			for(var i = 0 ; i < moveRowArray.length ; i++){			
				var newId = (new Date()).valueOf();				
				
				var beforeDelArray = $('#actor').val().split(',');
				var beforeWfStepArray = $('#wfStepID').val().split(',');
				var delArray = gridArea2.cells(moveRowArray[i],6).getValue();
				for (var j in beforeDelArray) {
					if (beforeDelArray[j] == delArray) {
						beforeDelArray.splice(j,1);
						beforeWfStepArray.splice(j,1);

						break;
					}
				}

				if(beforeSearchMember != "") {
					for (var l in beforeSearchMember) {
						if (beforeSearchMember[l] == delArray) {
							beforeSearchMember.splice(l,1);
							alert(beforeSearchMember);
							break;
						}
					}
				}

				$('#actor').val(beforeDelArray);
				$('#wfStepID').val(beforeWfStepArray);
				
				if(agreeYN == "Y" && gridArea2.cells(moveRowArray[i],8).getValue()  == "${wfLabel.AGR}")
					agreeCnt--;
				
				sourceGrid.deleteRow(moveRowArray[i]);

			}

			searchMember = beforeSearchMember;
		}
		
		gridArea1.uncheckAll();
		gridArea2.uncheckAll();
	}	

	function fnAssignMember() {		
		if(agreeYN == "Y" && agreeCnt < 1) {
			alert("${WM00155}");
			return;
		}
		if(aprvCnt < 1) {
			alert("${WM00041}");
			return;
		}
		if(confirm("${CM00001}")){
			fnAssignInfo($("#wfStepInfo").val(),$("#actor").val(),$("#wfStepID").val());
		}		
	}
		
	function selfClose(){
		self.close();
	}
	
	function checkSelectItem(id) {

		var gridIDs = gridArea2.getAllRowIds();
		
		if(gridIDs != null && gridIDs != "") {
			gridIDs = gridIDs.split(',');
			
			for(var i=0; i < gridIDs.length; i++) {
				var check = gridArea2.cells(gridIDs[i],6).getValue();
				
				if(check == id) {
					return true;
				}
				
			}
		}
	}
</script>

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
	#schTreeArea a:nth-child(3){margin-left:30px;}
	#schTreeArea a:nth-child(4){margin-left:15px;}
	#schTreeArea a:nth-child(5){margin-left:30px;}
	
	table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhxcont_global_content_area{
		top:33px!important;
	}
	#container{border-top:1px solid #ccc!important;}
	.objbox{
		overflow-x:hidden!important;
	}
</style>
</head>
<body style="width:100%; height:98%; margin;auto;">
<form name="cfgFrm" id="cfgFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />	
<input type="hidden" id="wfID" name="wfID" value="1"/>
<input type="hidden" id="wfStep" name="wfStep" value=""/>
<input type="hidden" id="wfStepID" name="wfStepID" value=""/>
<input type="hidden" id="wfStepTxt" name="wfStepTxt" value=""/>
<input type="hidden" id="actor" name="actor" value=""/>
<input type="hidden" id="createWF" name="createWF" value="${createWF}" />
<input type="hidden" id="wfStepInfo" name="wfStepInfo">
<input type="hidden" id="wfStepRefInfo" name="wfStepRefInfo"/>
<input type="hidden" id="wfStepRefIDs" name="wfStepRefIDs"/>
<input type="hidden" id="wfStepRecInfo" name="wfStepRecInfo"/>
<input type="hidden" id="wfStepRecTeamIDs" name="wfStepRecTeamIDs"/>
<input type="hidden" id="wfStepRecIDs" name="wfStepRecIDs"/>
<div id="contentwrapper" style="position:absolute;">	
	
	<div class="cmm_member_bar">
		<li class="floatL">
			<p>
			<c:if test="${flg eq 'C' }">
				* ${menu.LN00140}
			</c:if>
			<c:if test="${flg eq 'R' }">
				* ${menu.LN00117} / ${menu.LN00245}
			</c:if>
			</p>
		</li>
	</div>	 	
	
	<div class="cmm_member_listBox">
		<div class="container" id="container" style="width:100%;float:left;height:350px;"></div>
			<div class="child_search floatL" style="width:100%; margin-left:-2px;border-right:0px solid #dfdfdf;">
				<li style="margin-left:10px;padding-left:0px;padding-right:0;">	
					<select id="searchKey" name="searchKey" class="pdL5">
						<option value="Name">Name</option>
						<option value="ID">ID</option>
					</select>
					<input type="text" id="searchValue" name="searchValue" value="" class="stext" style="width:150px;ime-mode:active;">
					<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" OnClick="doSearchList1('NT');">
				</li>
	    	</div>    
		    <table class="floatL" width="100%" border="0"  cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" align="left" class="pdT5" >
						<div id="gridArea1" style="height:250px!important;width:100%;overflow-x:hidden; border-bottom:0px solid #fff;"></div>
					</td>				
				</tr>
			</table>
	</div>
	
	<div class="cmm_member_btnList">
		<ul>
			<c:if test="${flg eq 'C' }">
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.AGR}" type="submit" onclick="doClickMove('H');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.PAGR}" type="submit" onclick="doClickMove('P');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.APRV}" type="submit" onclick="doClickMove('S');"></li>	
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REW}" type="submit" onclick="doClickMove('W');"></li>	
			</c:if>
			<c:if test="${flg eq 'R' }">
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REF}" type="submit" onclick="doClickMove('R');"></li>
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_add.png" /><input value="${wfLabel.REC}" type="submit" onclick="doClickMove('C');"></li>
			</c:if>				
			<li class="cmm_member_btn">&nbsp;<img src="${root}cmm/common/images/icon_del.png" /><input value="Del" type="submit" onclick="doClickMove('D');"></li>
		</ul>
	</div>
  	
  	<div class="cmm_member_selectBox">
		<table class="floatL" width="100%">	
			<tr>				
				<td class="floatL pd0" width="100%" align="left">
					<div id="gridArea2" style="height:500px; width:100%; overflow-x:hidden; border-top:1px solid #dfdfdf;"></div>
						<div class="cmm_member_sort">
							<div style="cursor:pointer;" onclick="gridArea2.moveRowUp(gridArea2.getSelectedId())">
								<img src="${root}cmm/common/images/btn_arrow_up.png" />
								<span>Up</span>
							</div>
							<div style="cursor:pointer;" onclick="gridArea2.moveRowDown(gridArea2.getSelectedId())">
								<img src="${root}cmm/common/images/btn_arrow_down.png" />
								<span>Down</span>
							</div>
						</div>
				</td>
				<td class="cmm_member_save">
						<c:if test="${flg eq 'C' }">
						<span id="save" class="btn_pack medium icon"><span class="save"></span>
						<input value="Save" type="submit" onclick="fnAssignMember()"/></span>
						</c:if>
						<c:if test="${flg eq 'R' }">
						<span id="save" class="btn_pack medium icon"><span class="save"></span>
						<input value="Save" type="submit" onclick="fnSetWFOtherInfo()"/></span>
						</c:if>
						<span id="close" class="btn_pack medium icon"><span class="close"></span>
						<input value="Close" type="submit" onclick="selfClose()" /></span>
				</td>
			</tr>
		</table>
	</div>
	
</div>
	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
</body>
</html>
