<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00018} Search</title>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
$(function(){
	// 초기 표시 화면 크기 조정 
	$("#layout").attr("style","height:"+(setWindowHeight() - 80)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 80)+"px;");
	};
	
	$('.sem001').click(function(){
		$('.sem001').css('background-color', '#ffffff');
		$('.sem001').attr('alt', '');
		$(this).css('background-color', '#eafafc');
		$(this).attr('alt', '1');
	}).mouseover(function(){
		$(this).css('background-color', '#eafafc');
	}).mouseout(function(){
		if($(this).attr('alt') != 1) 
			$(this).css('background-color', '#ffffff');
	});
	
	
});

function setWindowHeight(){
	var size = window.innerHeight;
	var height = 0;
	if( size == null || size == undefined){
		height = document.body.clientHeight;
	}else{
		height=window.innerHeight;
	}return height;
}

$(window).load(function(){
	$("#searchValue").focus();
	
});

function searchFrom(){
	document.getElementById("processList").action = "searchTeamPop.do";
	document.getElementById("processList").submit();
}


function setInfo(avg,avg2){
// 	alert(avg+" // "+avg2)
	window.opener.setSearchTeam(avg,avg2);
	self.close();
}


</script>
<script type="text/javascript">
function btndown(id,loc){
    var obj = document.getElementById(id);
    var orgSrc = obj.src;
    var newSrc = loc;
    
    obj.src = newSrc;
    
    obj.onmouseout = function(){
        obj.src = orgSrc;
    }
}
</script>
</head>

<body>

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="teamTypeYN" name="teamTypeYN" value="${teamTypeYN}" />
	<input type="hidden" id="clientID" name="clientID" value="${clientID}" /> 
	<input type="hidden" id="viewOption" name="viewOption" value="${viewOption}" /> 
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	
		<div class="child_search_head">
          <p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Search Team </p>
        </div>
      
         <div class="child_search_form"> 
    		<div class="child_search mgT5">
				<li>${menu.LN00104}</li>
				<li>
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:120px;ime-mode:active;"/>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="searchFrom()" value="Search">
				</li>
			</div>
			<div id="layout"></div>
		</div>
	</div>
	</form>
	
	<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	var grid = new dhx.Grid("", {
	    columns: [
	        { id: "ParentName", header: [{ text: "${menu.LN00162}" , align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 150, id: "TeamName", header: [{ text: "${menu.LN00104}" , align: "center" }, { content: "inputFilter" }], align: "left" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);	
	
	grid.events.on("cellClick", function (row,column,e) {
		setInfo(row.TeamID, row.ParentName + " - " + row.TeamName);
	});

	</script>
</body>
</html>