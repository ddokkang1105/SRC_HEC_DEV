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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="2 Models"/>

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		doPSearchList();
	});	

	function doGetCompareModelList(){	
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(selectedCell.length != 2){
			alert("${WM00025}");
			return false;
		} else {
			var url = "compareModel.do?s_itemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&modelID1="+selectedCell[1].ModelID+"&modelID2="+selectedCell[0].ModelID;
			var w = 1000;
			var h = 680;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			self.close();
		}
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID">
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
	<input type="hidden" name="ModelTypeCode" id="ModelTypeCode" >
	<div class="child_search_head">
	<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doGetCompareModelList()" ></span>
		</div>
		<div class="countList">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<div id="grdPAArea" style="width:100%;height:250px; overflow: hidden;"></div>
		<div class="mgT10 mgB10" style="background: #f2f2f2; border: 1px solid #ccc; padding: 7px 0;">
			<b style="margin: 0px 20px 0 10px;">Inbound check Option</b>
			<c:forEach var="i" items="${inboundChks}" varStatus="status">
				<c:choose>
					<c:when test="${i.MTCategory == 'BAS'}">
						<input type="checkbox" name="inboundChk" value="${i.MTCategory}" checked>&nbsp;${i.Name}&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						<input type="checkbox" name="inboundChk" value="${i.MTCategory}">&nbsp;${i.Name}&nbsp;&nbsp;
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>

<!-- dhtmlx9 ver upgrade -->

<script type="text/javascript">
 var layout = new dhx.Layout("grdPAArea", {
    rows: [
        {
            id: "a",
        },
    ]
}); 
	//result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00033},${menu.LN00032},${menu.LN00032}";
	//result.cols = "ModelID|Name|MTCategory|ModelTypeName|ModelTypeCode";
	//result.widths = "30,80,*,80,120,80";
	
var gridData = ${gridData};
 var grid = new dhx.Grid(null, {
    columns: [
        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
        { width: 80,id: "ModelID",  header: [{ text: "${menu.LN00106}", align: "center" }], align: "center" },
        { gravity:1,id: "Name",         header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
        { width: 100,id:"MTCategory",      header: [{ text: "${menu.LN00033}", align: "center" }], align: "left" },
        { width: 80,id: "ModelTypeName",          header: [{ text: "${menu.LN00032}", align: "center" }], align: "left" },
        { hidden:true,width: 70,id: "ModelTypeCode",         header: [{ text: "${menu.LN00032}", align: "center" }], align: "center" }
       
    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    multiselection: true,
    data: gridData
});
$("#TOT_CNT").html(grid.data.getLength());
layout.getCell("a").attach(grid);

/* var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});
  */


grid.events.on("cellClick", function(row, column, e) {
    var projectId  = row.ProjectID;

   gridOnRowSelect(row, column);
    
});
  
	function gridOnRowSelect(row, col){
		var ModelID = row.ModelID;
		var ModelTypeCode = row.ModelTypeCode
		$("#ModelID").val(ModelID);	
		$("#ModelTypeCode").val(ModelTypeCode);
	} 
	
	function doPSearchList(){
		let	sqlID = "model_SQL.selectCompareModelList";
		let param ="&ItemID=${ItemID}"
					+"&category=MC"	
					+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID="+sqlID;	
		


			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
			
					fnReload(result);
				
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
	}	
	
	function fnMasterChk(checked) {
	    grid.data.forEach(function(item) {
	        grid.data.update(item.id, { checkbox: checked });
	    });
	}

 	function fnReload(newGridData){
 	 	
 	    grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	} 
</script>
</body>
</html>
