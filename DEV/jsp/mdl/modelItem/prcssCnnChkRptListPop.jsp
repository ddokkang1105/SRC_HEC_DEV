<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '${DefDimTypeID}', 'Select');
		
		if("${DefDimTypeID}" != null && "${DefDimTypeID}" != '') {
			fnGetDimValue("${DefDimTypeID}");
		}
		
	});	

	function gridOnRowSelect(id, ind){
		var ItemID = "";
		if(ind == 1 || ind == 2){
			ItemID = pp_grid1.cells(id, 7).getValue();
		}else if(ind == 3 || ind == 4){
			ItemID = pp_grid1.cells(id, 8).getValue();
		}else{
			return;
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
	function fnGetRadioValue() {
		var radioObj = document.all("rptType");
		
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
	}
	
	function fnGetDimValue(dimTypeID){
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
		fnSelect('dimValueID', data, 'getDimTypeValueId', '${DefDimValueID}', 'Select');
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body align="center" style="width:100%;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp; Consistency check of process connections</p>
	</div>
	 <div class="child_search" >
	   <li>
	   		 <input type="radio" name="rptType" value="1" checked >&nbsp;&nbsp;Outbound Check
	   		&nbsp;&nbsp;<input type="radio" name="rptType" value="2" >&nbsp;&nbsp;Inbound Check
	   		<c:if test="${classCode == 'CL01001' || classCode == 'CL01000'}">
	   		&nbsp;* Dimension&nbsp;
	   		<select id="dimTypeID" name="dimTypeID" style="width:120px;"  OnChange=fnGetDimValue(this.value);></select>
	   		<select id="dimValueID" name="dimValueID" style="width:120px;"><option value="">Select</option></select>	   		
	   		</c:if>&nbsp;&nbsp;&nbsp;&nbsp;
	   		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doPSearchList()" value=Search />
	   		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	   	</li>	
	</div>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
    </div>
	<div id="layout" class="mgB10 clear" style="width:100%;height:700px;"></div>
   <iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
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
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", rowspan: 2, align: "center" }], align: "center" },
		        { width: 100, id: "Identifier2", header: [{ text: "Process", colspan: 2, align: "center" }, { text: "ID", align: "center" }] },
		        { width: 250, id: "itemName", header: ["", { text: "Name", align: "center" }] },
		        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00178} Process", colspan: 2, align: "center" }, { text: "ID", align: "center" }] },
		        { width: 250, id: "prePstItemName", header: ["", { text: "Name", align: "center" }] },
		        { width: 65, id: "KBN", header: [{ text: "${menu.LN00178}", rowspan: 2, align: "center" }], align: "center" },
		        { width: 60, id: "VrfctnLink", header: [{ text: "Result", rowspan: 2, align: "center" }], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false
		});
		
		layout.getCell("a").attach(grid);
		
		function doPSearchList(){
			var dimValueID = $("#dimValueID").val();
			var rptType = fnGetRadioValue();
			var sqlID = "model_SQL.selectPrcssCnnChkList";
			if(rptType==1){
				sqlID = "model_SQL.selectPrcssCnnChkList";
			}else{
				sqlID = "model_SQL.selectPrcssCnnChkInBndList";
			}
			var param ="ItemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mdlCategory=${mdlCategory}"
				+ "&sqlID="+sqlID;

			if("${DefDimValueID}" != "" && dimValueID == "") {
				param += "&dimValueID=${DefDimValueID}";
			}
			else if(dimValueID != ""){
				param += "&dimValueID="+dimValueID;
			}
			
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
		
		grid.events.on("cellClick", function(row,column,e){
			var ItemID = "";
			if(column.id == "Identifier2" || column.id == "itemName"){
				ItemID = row.ItemID;
			}else if(column.id == "Identifier" || column.id == "prePstItemName"){
				ItemID = row.ObjectID;
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