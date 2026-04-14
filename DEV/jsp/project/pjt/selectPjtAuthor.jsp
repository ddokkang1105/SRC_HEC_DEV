<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<!-- dhtmlx 7버전 업그레이드   -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var memberIds;
	var projectID ="${projectID}";
	$(document).ready(function() {	
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		
		console.log(${gridData});
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	// function PgridInit(){		
	// 	var d = setPGridData();
	// 	pp_grid = fnNewInitGrid("grdPAArea", d);
	// 	pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
	// 	pp_grid.setColumnHidden(2, true);
	// 	pp_grid.setColumnHidden(6, true);
	// 	fnSetColType(pp_grid, 1, "ch");
	// }
	
	// function setPGridData(){
	// 	var result = new Object();
	// 	result.title = "${title}";
	// 	result.key = "project_SQL.getPjtWorkerList";
	// 	result.header = "${menu.LN00024},#master_checkbox,Login ID,Name,${menu.LN00202},E-Mail,MemberID";
	// 	result.cols = "CHK|LoginID|UserName|TeamPath|Email|MemberID";
	// 	result.widths = "30,30,75,80,*,150,0";
	// 	result.sorting = "int,int,str,str,str,str,str";
	// 	result.aligns = "center,center,center,center,left,left,left";
	// 	result.data = "csrId=${csrId}&projectID=${projectID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
	// 	// Name 입력 겸색 조건
	// 	if($("#searchValue").val() != ''){
	// 		result.data = result.data +"&Name="+ $("#searchValue").val();
	// 	}	
	// 	return result;
	// }
	// END ::: GRID	
	//===============================================================================
		
	//조회
	// function doPSearchList(){
	// 	var d = setPGridData();
	// 	fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	// }	
	


	
	// [Add] 버튼 Click
	function addPjtMember(url){
	 console.log("add접속");
		var checkedRow = grid.data.findAll(function (data){
			return data.checkbox
		});
		if(!checkedRow.length){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00012}")){
				//var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				 memberIds =""; 
				
				for(var i = 0 ; i < checkedRow.length; i++ ){
					if (memberIds == "") {
						//memberIds = pp_grid.cells(checkedRows[i], 6).getValue();
						memberIds = checkedRow[i].MemberID;
					} else {
						memberIds = memberIds + "," +checkedRow[i].MemberID;
					}
				}
				console.log(memberIds);
				//console.log(${screenType});
				if("${screenType}" == "csrDtl"){
					var url = "admin/insertPjtMembers.do"; 
					var data = "memberIds=" + memberIds+"&projectID=${csrId}&screenType=${screenType}";
					var target = "saveFrame";
					
					ajaxPage(url, data, target);
				}else{
					var url = "addPjtMembers.do"; 
					var data = "memberIds=" + memberIds;
					var target = "saveFrame";

					ajaxPage(url, data, target);
				}
			}
		}
		
	}
 
	
	// [Add] Click 이벤트 후 처리
	function setInfo(avg1,avg2){
		window.opener.setMembers(avg1,avg2);
		self.close();
	}
	
	function fnCallBack(){
		parent.opener.fnSearchMember();
		self.close();
		
	}

	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<div id = "selectPjtAuthor">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="memberIds" name="memberIds" value="" />
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<tr>
               		<td class="pdL20">Name</td>
					<td class="alignL">
						<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색">&nbsp;	
					</td>
					<td class="alignR pdR20">
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addPjtMember()" ></span>
					</td>
               	</tr>
      		</table>
       	</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="mgL10 mgR10">
  			<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT"></span></p>
			</div>
		    <div id="grdPAArea" style="width:100%;"></div>
  		</div>
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->
</body>

<script type="text/javascript">
var layout = new dhx.Layout("grdPAArea", {
	rows : [ {
		id : "a",
	}, ]
});	
var gridData = ${gridData}; 
//	result.header = "${menu.LN00024},#master_checkbox,Login ID,Name,${menu.LN00202},E-Mail,MemberID";
	// 	result.cols = "CHK|LoginID|UserName|TeamPath|Email|MemberID";
	// 	result.widths = "30,30,75,80,*,150,0";
var grid = new dhx.Grid("grdPAArea", {
	  columns: [
	        { width: 60, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan: 2 }], align: "center" },
	        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center",rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
	        { hidden:true,width: 200, id: "LoginID", header: [{ text: "LoginID" }]},
	        { width: 180, id: "UserName", header: [{ text: "Name" , align: "center" }, { content: "inputFilter" }],align: "center" },
	        { width: 280, id: "TeamPath", header: [{ text: "${menu.LN00202}" , align: "center" }]},
	        { width: 180, id: "Email", header: [{ text: "E-Mail" , align: "center" }], align: "" },
	        { hidden:true, width: 0, id: "MemberID", header: [{ text: "MemberID" , align: "center" }]},  
	        
	    ],
    eventHandlers: {
        onclick: {
      
        }
    },
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});

layout.getCell("a").attach(grid);
// screenType == csrDtl member insert 후 처리 
$("#TOT_CNT").html(grid.data.getLength());

</script>
</html>