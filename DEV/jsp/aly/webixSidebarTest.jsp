<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- statisticsMainManu.jsp 에서 webix component 테스트 -->

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<link rel="stylesheet" href="${root}cmm/js/webix/codebase/webix.css" type="text/css" charset="utf-8">
<script src="${root}cmm/js/webix/codebase/webix.js" type="text/javascript"></script>
<link rel="stylesheet" href="//cdn.webix.com/materialdesignicons/5.8.95/css/materialdesignicons.min.css?v=8.4.2" type="text/css" charset="utf-8">

<style>
.foldcontent {
    left: 44px;
}
</style>
<script type="text/javascript">
var menuIndex = "1 2 3 4 5 6 8 9 10 11 12 13 14 15 51 52 53 54";
var bmenuIndex = "1 2 3 4";
	
	$(document).ready(function(){
		var menu_data = [
			{id: "ITEM", icon: "mdi mdi-view-dashboard", value: "ITEM",  data:[
				{ id: "1", value: "Process", "image": "http://smartfactory.co.kr/img/sf_logo_new.png"},
				{ id: "5", value: "Deleted List(Item)"},
				{ id: "11", value: "Deleted List(Connection)"},
				{ id: "12", value: "Translation"}
			]},
			{id: "Change", icon: "mdi mdi-view-column", value:"Change", data:[
				{ id: "3", value: "Change Set"},
				{ id: "8", value: "Task(Plan/Actual)"},
				{ id: "4", value: "Task"}
			]}
		];

			webix.ready(function(){
				webix.ui({
					cols:[
						{ rows : [
							{ 
								css: "menu", 
								padding: 2, 
								view: "form",
								cols:[
									{ view: "button", align: "left",
										value: '<img src="${root}${HTML_IMG_DIR}/icon_fold.png"/><span class="title">통계</span>',
										css: "app_button menu", 
										click: function(){
											$$("$sidebar1").toggle();

											if(!$(".webix_sidebar").hasClass("webix_sidebar_expanded")){
												$("#foldframe").attr("style","display:none;");
												$("#foldframeTop").addClass('foldframeTop');
												$("#foldcontent").removeClass('unfoldcontent');
												$("#foldcontent").addClass('foldcontent');	
												$("#title1").attr("style","display:none;");	
												$("#title2").attr("style","display:block;");
												fnSetGridResizing(45);
											} else {
												$("#foldframe").attr("style","display:block;");
												$("#foldframeTop").addClass('unfoldframeTop');
												$("#foldcontent").removeClass('foldcontent');
												$("#foldcontent").addClass('unfoldcontent');
												$("#title1").attr("style","display:block;");
												$("#title2").attr("style","display:none;");				
												fnSetGridResizing(200);
											}
										}
									}
								]
							},
							{
								view: "sidebar",
								width:200,
								data: menu_data,
								on:{
									onAfterSelect: function(id){
										var regex = /[^0-9]/g;
										var result = id.replace(regex, "");
										if(result) setSubFrame(id)
									}
								}
							}
						]},
						{ template: "html->foldcontent", autoheight: true }
					]
				});
			});
			
			
// 		clickOpenClose(1);
// 		//setSubFrame(1); // process report
		
// 		$("#btnFold").click(function(){
// 			$("#foldframe").attr("style","display:none;");
// 			$("#foldframeTop").addClass('foldframeTop');
// 			$("#foldcontent").removeClass('unfoldcontent');
// 			$("#foldcontent").addClass('foldcontent');	
// 			$("#title1").attr("style","display:none;");	
// 			$("#title2").attr("style","display:block;");
// 			fnSetGridResizing();
			
// 	     });
// 		$("#btnUnfold").click(function(){
// 			$("#foldframe").attr("style","display:block;");
// 			$("#foldframeTop").addClass('unfoldframeTop');
// 			$("#foldcontent").removeClass('foldcontent');
// 			$("#foldcontent").addClass('unfoldcontent');
// 			$("#title1").attr("style","display:block;");
// 			$("#title2").attr("style","display:none;");				
// 			fnSetGridResizing(230);
// 	     });
	});
	
	function test(id){
		alert(id)
	}
	
	function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	} 
	
	function fnSetGridResizing(avg){
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 메뉴 color 변경
		
		var target = "help_content";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}";
		var url = "";
		
		if(avg == "1") {  // ITEM --> Process
			url = "admin/newItemStatistics.do";
			data = data + "&isMainMenu=Y";
		}		
		if(avg == "2") {
			//url = "visitLogStatistics.do";
			url = "visitLogStatisticsByDay.do?haederL1=OJ00001";
		}
		if(avg == "3") { // Change --> Change Set
			url = "changeSetStatistics.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "4") {  // Change --> Task
			url = "taskStatistics.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "5") { // process Deleted List
			url = "itemDeletedList.do";
		}
		if(avg == "6") { // Model Object
			url = "modelObjectSearch.do";
		}
		if(avg == "8") {  // Change --> Task(Plan/Actual)
			//data = data + "&isMainMenu=Y";
			url = "taskPAresult.do";
		}
		if(avg == "9") {  // Change --> Task Monitoring
			url = "taskMonitoringList.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "10") {  // Change --> Task SearchList
			url = "taskSearchList.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "11"){
			url = "connectionList.do";
			data = data + "&DeletedYN=Y";
		}
		if(avg == "12"){
			url = "tranAttrList.do";
		}
		if(avg == "13"){
			url = "itemAuthorLogMgt.do";
		}
		if(avg == "14"){
			url = "teamItemMappingList.do?reportCode=RP00040";
		}
		if(avg == "15"){
			url = "teamChangeLogMgt.do";
		}
		if(avg == "99") {  // SR Dashboard
			url = "srDashboard.do";//"srMonitoring.do";//
		}
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
		var data = "s_itemID=${projectID}";
		ajaxPage(url, data, target);
	}
	
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuStt";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	
	// [+][-] button event
	function clickOpenClose(avg) {
		if ($(".smenu" + avg).css("display") == "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); // 그외 내용을 닫아줌
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
	}
	function setOtherArea(avg) {
		var indexArray = bmenuIndex.split(' ');
		for(var i = 0 ; i < indexArray.length; i++){
			var index = i + 1;
			if(index != avg){
				$(".smenu" + index).css("display", "none");
				$(".plus" + index).css("display", "block");
				$(".minus" + index).css("display", "none");
			}
		}
	}
	
	
</script>
</head>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
<!-- 	 <div id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div> -->
<div  id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div>
</body>
</html>


