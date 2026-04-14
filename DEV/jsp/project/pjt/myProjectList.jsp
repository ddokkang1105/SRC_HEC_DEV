<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<!-- 2. Script  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var p_gridArea;		
	var screenType = "${screenType}"; //그리드 전역변수
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 191)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 191)+"px;");
		};
		
		
		
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
	

	function goInfoView(avg1){
		var target = "projectDiv";
		var url = "";
		url = "viewProjectInfo.do";
		data = "isNew=N&s_itemID=" +avg1+ "&pjtMode=R&refID=${refID}&screenType=${screenType}";
		ajaxPage(url, data, target);
	}
		
	function addPjt(){
		var url = "registerProject.do"; // 프로젝트 생성
		var target = "projectDiv";
		var data = "pjtMode=N&s_itemID=${refID}&screenType=${screenType}&refID=${refID}&isNew=Y";
		
		ajaxPage(url, data, target);
	}
	
	function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
	function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
	
	function fnGoRefresh() {
		var target = "projectDiv";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=0&mainVersion=mainV5";
		var url = "myProjectList.do";
		
		ajaxPage(url, data, target);
	}
	
</script>
</head>

<body>
<div id="projectDiv">
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="saveType" name="saveType" value="New">		
		<input type="hidden" id="AuthorID" name="AuthorID">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
		<input type="hidden" id="userList" name="userList" value="" />
				
	<h3 class="floatL mgB10 mgT12" style="width:100%">
	<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00052}
	</h3>		

  
	<div class="countList pdT10" style="width:100%;">
	     <li class="count">Total <span id="TOT_CNT"></span></li>
	     <li class="floatR">
	         <c:if test="${createPG eq 'Y'}">
	  			<span id="addIcon" class="btn_pack small icon"><span class="add"></span><input value="Create Project" type="submit" onclick="addPjt()"></span>
			</c:if>
	     </li>
	</div>		
	</form>
	
	<div id="gridDiv" style="width:100%;" class="clear mgB10">
		<div id="grdGridArea"></div>	
	</div>
	<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular">
			<div id="pagingArea" style="display:inline-block;"></div>
		<!-- 	<div id="recinfoArea" class="floatL pdL10"></div> -->
		</div> 
	<!-- END :: PAGING -->
		
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer" ><iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe></div>	
	<!-- END :: FRAME -->	
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
	
	<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
<script type="text/javascript">
		var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 
	
		var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		    	{ fillspace : true,width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { fillspace : true,width: 100, id: "ProjectCode", header: [{ text: "Project Code", align: "center" },{ content: "selectFilter" }], align: "left"},
		        { fillspace : true, id: "ProjectName", header: [{ text: "${menu.LN00028}", align: "center"},{content: "inputFilter"}],align: "left"},
		        { fillspace : true, id: "Description", header: [{ text: "${menu.LN00035}" , align: "center" }, {content: "inputFilter"}],align: "left"},
		        { fillspace : true,width: 250, id: "ProjectGRName", header: [{ text: "${menu.LN00277}" , align: "center" }, { content: "selectFilter" }],align: "center"},
		        { fillspace : true,width: 150, id: "PJTCatName", header: [{ text: "프로젝트 카테고리" , align: "center" }, {content: "inputFilter"}], align: "center" },
		        { fillspace : true,width: 100, id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }, { content: "selectFilter" }],align: "center"},
		        { fillspace : true,width: 150, id: "CreatorName", header: [{ text: "${menu.LN00004}" , align: "center" }, {content: "inputFilter"}], align: "center" },
		        { fillspace : true,width: 100, id: "StartDate", header: [{ text: "${menu.LN00063}" , align: "center" }, {content: "selectFilter"}],align: "center" },
		        { fillspace : true,width: 100, id: "DueDate", header: [{ text: "${menu.LN00062}" , align: "center" },{content: "selectFilter"}],align: "center" },
		        { fillspace : true,width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }],align: "center"},
		        { hidden:true,width: 0, id: "ProjectID", header: [{ text: "" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { hidden:true,width: 0, id: "ChildCount", header: [{ text: "" , align: "center" }, { content: "" }],align: "center" }
		        
		    ],
		    eventHandlers: {
		        onclick: {
		           /*   "Action": function (e, data) {
		            	fnEditTmp(data.row);
		            } 
		             */
		        }
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
	
		
		layout.getCell("a").attach(grid);
		
		var pagination = new dhx.Pagination("pagingArea", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(document.getElementById('currPage').value);
	 	
		$("#TOT_CNT").html(grid.data.getLength());
		grid.events.on("cellClick", function(row, column, e) {
		    var projectId  = row.ProjectID;
		    goInfoView(projectId);
		});
</script>
	
</body>
</html>