<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -My Dimension 관리 -->
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
 
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">			//그리드 전역변수
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('assignmentType', '&actorType=USER&languageID='+languageID, 'getAssignment', "", 'Select');
	$(document).ready(function() {
		if("${scrnType}" == "mySpace"){
			$("#grdGridArea").innerHeight(document.body.clientHeight - 120);
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 120);
			};
		} else {
			$("#grdGridArea").innerHeight(document.body.clientHeight - 340);
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 340);
			};
		}
		
		$("#assigned").change(function(){
	        var chk = $(this).is(":checked");
	        if(chk){ $(this).prop('checked', true); 
	        }else{  $(this).prop('checked', false); }
	        
	        doSearchList();
	    });
	});	

	var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 160, id: "AssignmentTypeName", header: [{ text: "Role Category", align: "center" },{ content: "selectFilter" } ], align: "center" },
	        { width: 110, id: "RoleTypeTxt", header: [{ text: "Role", align: "center" } ], align: "center" },
		    { width: 130, id: "AccessRightName", header: [{ text: "${menu.LN00149}", align: "center" } ], align: "center" },
	        { width: 100, id: "className", header: [{ text: "${menu.LN00016}", align: "center" } ], align: "center" },
	        { id: "itemPath", header: [{ text: "${menu.LN00087}", align: "center" } ], align: "left" },
	        { width: 130, id: "AssignedDate", header: [{ text: "${menu.LN00078}", align: "center" } ], align: "center" },
	        { width: 80, id: "OrderNum", header: [{ text: "Order", align: "center" } ], align: "center" },
	        { width: 80, id: "Assignment", header: [{ text: "Active", align: "center" } ], align: "center" },
	        { hidden : true, width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" } ], align: "left" },

	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});

	layout.getCell("a").attach(grid);
	
	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 	}

	function doSearchList(){
		var sqlID = "role_SQL.getMyAssignedRoleList";

		var param =  "memberId=${memberID}"				
	        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
	        + "&assignmentType="     + $("#assignmentType").val()
	        + "&sqlID="+sqlID;   
		if($("#assigned").is(":checked") == true){
			param += "&assigned=1";
		}
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		doDetail(row.ItemID);
	}); 
	
	function doDetail(itemId){
		if(itemId=="" || itemId=="0"){return;}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 850;
		itmInfoPopup(url,w,h,itemId);
	}
	
	function doCallBack(){}
	
	
</script>
<c:if test="${scrnType eq 'mySpace' }">
	<h3 class="pdT10 pdB10" style="border-bottom:1px solid #ccc;  "><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic" />&nbsp;${menu.LN00119}</h3>
</c:if>
<div class="child_search01 pdT10 pdB10">
	<ul>
		<li class="mgL10" style="font-weight:bold;">Role Category</li>
		<li class="mgL10">
		      <select id="assignmentType" Name="assignmentType"></select> 
		  	  <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
		</li>
		<li class="mgL10 floatR">
			<input type="checkbox" id="assigned" name="assigned" checked >&nbsp;Active
		</li>
	</ul>
</div>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv">
	<div id="grdGridArea" style="width:100%;"></div>
</div>
<!-- END :: LIST_GRID -->

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->