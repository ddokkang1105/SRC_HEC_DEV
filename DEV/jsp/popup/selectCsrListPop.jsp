<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00053" var="CM00053"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="300"/>
<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
	});	
	
	// [Move] Click
	function changeCsrOrder(){
		//CHEKC된 ROW 
		var checkRows = grdPAArea.data.findAll(function(data){
				return data.checkbox;
		});
		
		if(checkRows.length === 0 ){
			alert("${WM00023}");
		}
		
		if(checkRows.length != 1){
			alert("${WM00042}");
		} else {
			if(confirm("${CM00053}")){
				var pjtId =""; 
				for(idx in checkRows){
					pjtId =checkRows[idx].ProjectID
				}
			
				var url = "changeCsrOrder.do";		
				var data = "cngts=${cngts}&pjtId="+pjtId;
				var target="blankFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	
</script>

<div class="popup01">
<ul>
	<li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR20">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">	
	
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
				<colgroup>
            		<col width="80">
            		<col width="20">
            		<col>
            	</colgroup>
            	<tr>
               		 <td>					
						<%-- <select id="searchKey" name="searchKey" class="sel" style="width:80px;">
							<option value="Name">Name</option>
							<option value="Code">ID</option> 				
						</select>
						<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="stext" style="width:130px;ime-mode:active;">
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search">
						 --%>
					</td> 
					<td class="alignR">
						<span class="btn_pack small icon mgR10"><span class="move"></span><input value="Move" type="submit" onclick="changeCsrOrder()"></span>
					</td>
					
					
               	</tr>
               	
      		</table>
       	</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="mgL10 mgR10">
  			<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
		    <div id="grdPAArea" style="height:300px;"></div>
  		</div>
	</div>
	
	</div>
	</li>
</ul>	
</div>	
<div class="bot_zone" style="margin-top:10px;" >
	<img src="${root}${HTML_IMG_DIR}/popup_box6_.png" style="margin-top:-8px;">
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
<script type="text/javascript">
	var layout = new dhx.Layout("grdPAArea", {
		rows : [ {
			id : "a",
		}, ]
	});	
	var gridData = ${gridData}; 

	var grdPAArea = new dhx.Grid("grdPAArea", {
		  columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 80, id: "ProjectCode", header: [{ text: "${menu.LN00015}" , align: "center"},{ content: "inputFilter" }], align: "center"},
				{ width: 120, id: "ProjectName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }], align: "left"},
				{ width: 100, id: "ParentName", header: [{ text: "${menu.LN00131}" , align: "center" },{ content: "inputFilter" }], align: "left"},
				{ width: 80, id: "AuthorTeamName", header: [{ text: "${menu.LN00266}" , align: "center" }], align: "center"},
				{ width: 80, id: "AuthorName", header: [{ text: "${menu.LN00153}" , align: "center" }] , align: "center"},
				{ width: 80, id: "DueDate", header: [{ text: "${menu.LN00078}" , align: "center" }], align: "center" },
				{ width: 80, id: "StatusName", header: [{ text: "${menu.LN00062}" , align: "center" }], align: "center"},
				{ width: 80, id: "PriorityName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center"},
				{ width: 80, id: "WFName", header: [{ text: "${menu.LN00067}" , align: "center" }], align: "center"},
				{ hidden:true, width: 0, id: "CurWFStepName", header: [{ text: "${menu.LN00042}" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "ProjectID", header: [{ text: "${menu.LN00132}" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "ProjectType", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "WFID", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "AuthorID", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "Creator", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "PjtMemberIDs", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "CNGT_CNT", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "Status", header: [{ text: "" , align: "center" }] , align: "center"}
			],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	});

	layout.getCell("a").attach(grdPAArea);
	
	$("#TOT_CNT").html(grdPAArea.data.getLength());

	</script>
