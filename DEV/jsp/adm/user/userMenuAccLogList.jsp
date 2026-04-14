<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

<script type="text/javascript">
	var gridData = ${UserMenuAccLogListData};
	
	gridData = gridData.map(item => ({
	    ...item,
	   /*  MemberName: item.MemberName && item.MemberName.length > 4
		        ? item.MemberName[0] + item.MemberName[1] + "*".repeat(item.MemberName.length - 4) + item.MemberName[item.MemberName.length - 2] + item.MemberName[item.MemberName.length - 1]
		        : item.MemberName && item.MemberName.length > 2
		            ? item.MemberName[0] + "*".repeat(item.MemberName.length - 2) + item.MemberName[item.MemberName.length - 1]
		            : item.MemberName, */
		            
	        /* LoginID: item.LoginID && item.LoginID.length > 4
	        ? item.LoginID[0] + item.LoginID[1] + "*".repeat(item.LoginID.length - 4) + item.LoginID[item.LoginID.length - 2] + item.LoginID[item.LoginID.length - 1]
	        : item.LoginID && item.LoginID.length > 2
	            ? item.LoginID[0] + "*".repeat(item.LoginID.length - 2) + item.LoginID[item.LoginID.length - 1]
	            : item.LoginID  */
	            
	            MemberName: item.MemberName && item.MemberName.length === 2
	            ? item.MemberName[0] + "*" + item.MemberName[1]
	            : item.MemberName && item.MemberName.length > 2
	                ? item.MemberName[0] + "*".repeat(item.MemberName.length - 2) + item.MemberName[item.MemberName.length - 1]
	                : item.MemberName,
	            
		            LoginID: item.LoginID && item.LoginID.length > 3
		            ? item.LoginID.slice(0, -3) + "***"
		            : item.LoginID && item.LoginID.length > 1
		                ? item.LoginID[0] + "*".repeat(item.LoginID.length - 1)
		                : item.LoginID
		                
	}));	

	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() * 0.8 )+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		};

		fnGridList(gridData);
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSearchList(){
		var url = "userMenuAccLogList.do";
		var data="reportCode=${reportCode}&languageID=${languageID}&title=${title}&startDate="+$("#startDate").val()+"&endDate="+$("#endDate").val();
		var target = "changeInfoLstFrm";
		 
		ajaxPage(url, data, target);
	}
	
	function changeChart(){
		var url = "userMenuAccLogListStatistics.do";
		var data = "reportCode=${reportCode}&languageID=${languageID}&title=${title}";
		var target = "help_content";
		
		ajaxPage(url, data, target);
	}
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	function fnGridList(resultdata){		
		grid = new dhx.Grid("grid", {
			
			columns: [
				/* 메뉴 ID, 메뉴명, 로그인 ID, 성명, 부서 명, 접속 시간 */
				{ width: 120, id: "ActionType", header: [{ text: "메뉴 유형", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 120, id: "MenuID", header: [{ text: "메뉴 ID", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 200, id: "MenuIDName", header: [{ text: "메뉴명", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 120, id: "LoginID", header: [{ text: "로그인 ID", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 150, id: "MemberName", header: [{ text: "성명", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 200, id: "TeamName", header: [{ text: "부서 명", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				{ width: 200, id: "Date", header: [{ text: "접속 시간", align: "center" }, { content: "selectFilter", align: "center" }], align: "center" },
				],  
			
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(grid.data.getLength());
		});	

		
		/*  // MemberName 클릭 시 MemberID 불러서 사용자 정보 팝업 띄우기
		grid.events.on("cellClick", function(row, column, e) {
		    if (column.id === "MemberName") {  
		    	var memberID = row.MemberID;
		        var popupUrl = "viewMbrInfo.do?memberID=" + encodeURIComponent(memberID);  
			    window.open(popupUrl, "viewMbrInfo", 'width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');  
		    }
		}); 

		// TeamName 열 클릭 시 TeamID를 불러서 사용자 정보 팝업 띄우기
	    grid.events.on("cellClick", function(row, column, e) {
	    	 if (column.id === "TeamName") {  
	    	        var teamId = row.TeamID;  
	    	        var popupUrl = "orgMainInfo.do?id=" + encodeURIComponent(teamId);  
	    	        window.open(popupUrl, "teamInfoPopup", 'width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');  
	    	    }
	    });  */

		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 50,
		});
		
		layout.getCell("a").attach(grid);
	} 
	
	function exportXlsx() {
		fnGridExcelDownLoad();
	};
</script>

<body>
<div class="pdL10 pdR10">
	<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
		  <div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
			  	<li class="floatR pdR15">
					<div class="icon_color_btn2 searchList" onclick="changeChart()" style="cursor:pointer; display:inline-block;;" >
						<i class="mdi mdi-table" style="color:#494848;"></i>
					</div>
				</li>
			<h3 style="padding: 6px 0; border-bottom: 1px solid #ccc;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
		  </div>
		  <div class="countList">
		    	<li class="count">Total  <span id="TOT_CNT"></span></li>
		       <li class="pdL55 floatL">
		       		
						<input type="text" id="startDate" name="startDate" value="${startDate}" class="text datePicker" size="10" 
							style="width: 90px; min-width: 85px; text-aligh: left; padding-left: 5px;" onchange="this.value = makeDateType(this.value);"
							maxlength="10" autocomplete="off">  
					
					~
					
						<input type="text" id="endDate" name="endDate" value="${endDate}" class="text datePicker" size="10" 
							style="width: 90px; min-width: 85px; text-aligh: left; padding-left: 5px;" onchange="this.value = makeDateType(this.value);"
							maxlength="10" autocomplete="off">  
					
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearchList()" value="Search" style="cursor:pointer;">
				</li>
			<li class="floatR pdR10">	
				<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" onClick="exportXlsx()"></span>
			</li>	
		   </div>
		   
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
		
	</form>
</div>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>