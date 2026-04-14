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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css"/>
</head>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
<div class="child_search_head">
<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
</div>
<div class="countList" style="padding:10px 0 0 0;">
    <li class="count">Total  <span id="TOT_CNT"></span></li>
    <li class="floatR">&nbsp;</li>
</div>
<div id="layout" style="width:100%;height:500px;"></div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<script>
	doPSearchList();

	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 230, id: "FromName", header: [{ text: "From", align:"center" }], align:"left"},
	        { width: 230, id: "ToName", header: [{text: "To", align:"center"}], align: "left"},
	        { width: 110, id: "FromIDEx", header: [{ text: "Check", align:"center", colspan: 2 }], align:"center"},
	        { width: 110, id: "ToIDEx", header: [{ text: "", align:"center" }], align:"center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    multiselection : true   
	});
	
	layout.getCell("a").attach(grid);
	
 	function doPSearchList(){
		var sqlID = "model_SQL.getValidateElementLst";
		var param =  "ModelID=${ModelID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
 	}
 	
	 grid.events.on("cellClick", function(row,column,e,item){
			var ItemID = "";
			if(column.id == "FromName"){
				ItemID = row.FromItemID;
			}else if(column.id == "ToName"){
				ItemID = row.ToItemID;
			}else{
				return;
			}
			
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,ItemID);
		 });
</script>
</body>
</html>