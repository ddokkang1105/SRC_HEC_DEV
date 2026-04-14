<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00072}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00148}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00018}"/>

<script>
	$(document).ready(function(){
		//초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function custDel(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00004}")){
				var url = "deleteCust.do";
				var items = "";
				for(idx in selectedCell){
					grid.data.remove(selectedCell[idx].id);
				    if (items == "") {
				    	items = selectedCell[idx].TeamID;
					} else {
						items += ","+selectedCell[idx].TeamID;
					}
				};
				var data = "items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function clickNewBtn(){
		var url = "registerCust.do"; // 요청이 날라가는 주소
		var data = "arcCode=${arcCode}";
		var target = "custList";
		ajaxPage(url,data,target);
	}
</script>
</head>

<body>
<form name="custList" id="custList" action="#" method="post" onsubmit="return false;">
	<div id="custListDiv" class="pdT10 pdL10 pdR10" style="height:100%;">
		<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionAuthId}">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
		
		<div class="msg mgB5"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${arcMap.ParentArcName} - ${arcMap.ArcName}</div>
			<div class="child_search01 mgB5">
				<li class="floatR">
						<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
						<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="newButton"  onclick="clickNewBtn()"></span>&nbsp;
						&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" id="delButton"  onclick="custDel()"></span>&nbsp;
						</c:if>
				</li>
			</div>			
			<div style="width: 100%" id="layout"></div>
			<div id="pagination"></div>
	</div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;border: 0;" ></iframe>

<script>	
	var layout = new dhx.Layout("layout", { rows: [{id: "a",}]});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
	        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
	        { width: 200, id: "CustomerNM", header: [{ text: "${menu.ZLN0200}" }, { content: "inputFilter" }] },
	        { width: 120, id: "CustTypeNM", header: [{ text: "${menu.ZLN0203}" }, { content: "selectFilter" }] },
	        { width: 120, id: "CustLvlNM", header: [{ text: "${menu.ZLN0204}" }, { content: "selectFilter" }]},
	        { width: 120, id: "BizType", header: [{ text: "${menu.ZLN0207}" }, { content: "inputFilter" }] },
	        { width: 200, id: "BizItem", header: [{ text: "${menu.ZLN0210}" }, { content: "inputFilter" }] },
	        { width: 140, id: "LastUpdated", header: [{ text: "${menu.LN00070}" }, { content: "inputFilter" }] },
	        { width: 120, id: "RegUser", header: [{ text: "${menu.LN00212}" }, { content: "inputFilter" }] },
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit-button": function (e, data) {
	            	fnLoadWindow(data.row);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 30,
	});
	
	//첫 로드 페이지에서 filtering 되도록 하는 부분
	/*
	var changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);
	
	var CustType = grid.getHeaderFilter("CustTypeNM");
	var element;
	element = CustType.querySelector("select");
	element.value = "${custType}";
	element.dispatchEvent(changeEvent);
	
	var CustLvl = grid.getHeaderFilter("CustLvlNM");
	element = CustLvl.querySelector("select");
	element.value = "${custLvl}";
	element.dispatchEvent(changeEvent);
	*/
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox") parent.fnGoTreeMgt(row.CustomerNo,row.CustGRNo,"",row.CustLvl,row.CustType);
	});	
</script>
</body>
</html>