<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />


<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		doSearchList();
	});	

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "cs_SQL.getItemChangeList";
		result.header = "${menu.LN00024},#master_checkbox,Version,${menu.LN00070},${menu.LN00027},ChangeSetID";
		result.cols = "CHK|Version|CompletionDate|ChangeSts|ChangeSetID";
		result.widths = "30,30,80,120,80,0";
		result.sorting = "str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	function doDiffCheck(){
		
		var checkedRows = grid.data.findAll(function (data){
			return data.checkbox
		});
		
		var seq = "";
		var chkVal = "";

		if (checkedRows.length == 0) {
			alert("${WM00023}");
			return;
		}
		
		for(var i=0; i<checkedRows.length; i++){
			if(seq == "")
				seq = "&changeSet=" + checkedRows[i].ChangeSetID; 
			else 
				seq = seq + "&preChangeSet=" + checkedRows[i].ChangeSetID; 
		}
		
		var url = "compareAttribute.do?s_itemID=${s_itemID}"+seq;

		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		self.close();
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="preChangeSet" id="preChangeSet" >
	<div class="child_search_head">
	<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Diff Check</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
			<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doDiffCheck()" ></span>
		</div>
		<div id="grdGridArea" class="mgL15 mgR15" style="height:320px;"></div>	
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>
<!-- CHK|Version|CompletionDate|ChangeSts|ChangeSetID -->
<script>


	function doSearchList(){
		$('#loading').fadeIn(150);
		
		var currentGridData = setGridData();
		var param = "";
		param += currentGridData.data + "&sqlID="+currentGridData.key
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
					fnReloadGrid(result);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		}
	}
	
	const gridData = setGridData();
	
// 	console.log(gridData);

	var grdGridArea = new dhx.Layout("grdGridArea", {
		rows: [ { id: "a" } ] });
	
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
	        { width: 40, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 80, id: "Version", header: [{ text: "${menu.LN00017}", align:"center" },], align: "center" },
	        { id: "CompletionDate", header: [{ text: "${menu.LN00070}", align:"center" }] },
	        { width: 120, id: "ChangeSetStatus", header: [{ text: "${menu.LN00027}", align:"center" }], align: "center" },
// 	        { width: 120, id: "ChangeSetID", header: [{ text: "${menu.LN00018}", align:"center" }], align: "center" },
	        ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
	grdGridArea.getCell("a").attach(grid);
</script>