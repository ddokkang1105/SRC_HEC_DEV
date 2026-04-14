<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>


<!-- 2. Script -->
<script type="text/javascript">
	var scrnType = "${scrnType}";
	
	$(document).ready(function() {	
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<body style="width:100%;">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="memberIds" name="memberIds" value="" />
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Members</p>
	</div>
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<tr>
					<td class="alignR pdR20">
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addScrMember()" ></span>
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
		    <div id="layout" style="width:100%;"></div>
  		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->

</body>

<script type="text/javascript">
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});
var gridData = ${gridData};
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
        { width: 120, id: "LoginID", header: [{ text: "Login ID" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120, id: "UserName", header: [{ text: "Name" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { id: "TeamPath", header: [{ text: "${menu.LN00202}" , align: "center" }], align: "center" },
        { width: 200, id: "Email", header: [{ text: "E-Mail" , align: "center" }], align: "center" },
        { hidden: true, id: "MemberID", header: [{ text: "MemberID" , align: "center" }], align: "center" }
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

//filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

$("#TOT_CNT").html(grid.data.getLength());
	
// [Add] 버튼 Click
function addScrMember(){
	
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	
	if(selectedCell.length == 0){
		alert("${WM00023}");
	} else {
		if(confirm("${CM00012}")){
			var memberIds =""; 
			for(idx in selectedCell){
				if (memberIds == "") {
					memberIds = selectedCell[idx].MemberID;
				} else {
					memberIds = memberIds + "," + selectedCell[idx].MemberID;
				}
			}
			
			var url = "insertSCRMembers.do";
			var data = "memberIds=" + memberIds+"&scrId=${scrId}";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	} 
}

function reloadMemberList(){
	window.opener.doSearchList(scrnType);
	self.close();
}
	
</script>

</html>