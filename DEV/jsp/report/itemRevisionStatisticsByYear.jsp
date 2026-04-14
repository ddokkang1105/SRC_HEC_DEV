<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00017" var="WM00017" />

<script>
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSearchProchSum(){
		if($("#fromYear").val() > $("#toYear").val()){
			alert("${WM00017}"); return;
			return false;
		}
		var url = "itemRevisionStatisticsByYear.do";
		var target = "help_content";
		var data = "fromYear="+$("#fromYear").val()+"&toYear="+$("#toYear").val()+"&itemTypeCodeList=${itemTypeCodeList}&reportCode=${reportCode}";
		ajaxPage(url, data, target);
	}	
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${itemRevisionByYearList};
	var grid = new dhx.Grid("grid", {
		columns: [
	    	{ width: 150, id: 'Date', align:'center' ,header: [{ text: 'Year',rowspan: 2, align:'center'}] }
	    	,{ width: 100, id: 'Q1', align:'center' ,header: [{ text: 'Quarter', colspan: 4, align:'center'},{ text: 'Q1', align:'center'}]} 
	    	
	    	,{ width: 100, id: 'Q2', align:'center' ,header: ["", { text: 'Q2', align:'center'}]} 
	    	,{ width: 100, id: 'Q3', align:'center' ,header: ["", { text: 'Q3', align:'center'}]} 
	    	,{ width: 100, id: 'Q4', align:'center' ,header: ["", { text: 'Q4', align:'center'}]} 
	
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: true,
	    data: gridData
	});	
	
	 layout.getCell("a").attach(grid);
	
</script>

<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${title}</h3>
</div>
<div class="child_search">
	<ul>
		<li>&nbsp;&nbsp;From&nbsp;&nbsp;
			<select id="fromYear" name="fromYear" class="sel01">
				<option value="0" >select</option>
				<c:forEach var="i" begin="0" end="${curYear - minYear}">
					<c:set var="yearOption" value="${curYear - i}" />
					<option <c:if test="${ yearOption eq fromYear }"> selected="selected" </c:if> value="${yearOption}">${yearOption}</option>
				</c:forEach>
			</select>
			
		</li>
	   <li>&nbsp;&nbsp;To&nbsp;&nbsp;
			<select id="toYear" name="toYear">
				<c:forEach var="i" begin="0" end="${curYear - minYear}">
				<c:set var="yearOption" value="${curYear - i}" />
				<option <c:if test="${ yearOption eq toYear }"> selected="selected" </c:if> value="${yearOption}">${yearOption}</option>
			</c:forEach>
			</select>
			
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()" />
		</li>
		<li class="floatR pdR20">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</ul>
</div>
<div>	
	<div style="width: 100%;" id="layout"></div>
</div>