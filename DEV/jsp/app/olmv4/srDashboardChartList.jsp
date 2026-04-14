<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00262}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>

<script type="text/javascript">
	var chartData = ${chartData};
	var gridData = ${gridData};
	var subGridData = ${subGridData};
	var subGrid;
	
	var chartConfig = {
	    type: "bar",
	    css: "dhx_widget--bg_white",
	    scales: {
	        "bottom": {
	            text: "label"
	        },
	        "left": {
	        }
	    },
	    series: [
	        {
	            id: "A",
	            value: "value",
	            fill: "#81C4E8",
	        }
	    ]
	};
	
	var chart = new dhx.Chart("chart", chartConfig);
	chart.data.parse(chartData);
	
	var grid = new dhx.Grid("grid", {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center", editable: false, footer: [{ text: "Total", colspan:3 }] },
	        { width: 150, id: "SRArea1Name", header: [{ text: "${menu.LN00274}" }] },
	        { width: 150, id: "SRArea2Name", header: [{ text: "${menu.LN00185}" }] },
	        { width: 150, id: "SRReqCnt", header: [{ text: "SR요청건" }], footer: [{ content: "sum" }]},
	        { width: 100, id: "SRCmpCnt", header: [{ text: "SR완료건" }], footer: [{ content: "sum" }] },
	        { width: 100, id: "SRPscHour", header: [{ text: "SR처리시간(H)" }], footer: [{ content: "sum" }] },
	        { width: 120, id: "SROtdRat", header: [{ text: "SR적기납기율(%)" }], type: "number", format: "#.00"},
	        { width: 100, id: "CRRcvCnt", header: [{ text: "CR접수건" }], footer: [{ content: "sum" }]},
	        { width: 100, id: "CRCmpCnt", header: [{ text: "CR완료건" }], footer: [{ content: "sum" }]},
	        { width: 100, id: "CRPscHour", header: [{ text: "CR처리시간(H)" }], footer: [{ content: "sum" }]},
	        { width: 120, id: "CROtdRat", header: [{ text: "CR적기납기율(%)" }], type: "number", format: "#.00"},

	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
    grid.events.on("cellClick", function(row,column,e) {
        subGridLoad(row)
    });
	
	function subGridLoad(rowData) {
		document.getElementsByClassName("subGridExcel")[0].style.display = "block";
		if (subGrid) {
			subGrid.destructor();
	    }
		subGrid = new dhx.Grid("subGrid", {
			columns: [
		        { width: 150, id: "SRCode", header: [{ text: "SR No." }] },
		        { id: "Subject", header: [{ text: "${menu.LN00002}" }], gravity:1 },
		        { width: 150, id: "StatusName", header: [{ text: "${menu.LN00027}" }] },
		        { width: 100, id: "SRArea1Name", header: [{ text: "${menu.LN00026}" }] },
		        { width: 100, id: "SRArea2Name", header: [{ text: "${menu.LN00274}" }] },
		        { width: 120, id: "ReqTeamNM", header: [{ text: "${menu.LN00185}" }]},
		        { width: 100, id: "SRDueDate", header: [{ text: "SR${menu.LN00221}" }]},
		        { width: 100, id: "CRDueDate", header: [{ text: "CR${menu.LN00221}" }]},
		        { width: 100, id: "SRCompletionDT", header: [{ text: "SR${menu.LN00064}" }]},
		        { width: 120, id: "CRCompletionDT", header: [{ text: "CR${menu.LN00064}" }]},
		        { width: 120, id: "ReceiptName", header: [{ text: "${menu.LN00004}" }]},
		    ],
		    rowCss: function (row) { 
		    	var customCss;
		        row.ReceiptDelay == "Y" ? customCss = "receiptDelay" : "";
		        row.CompletionDelay == "Y" ? customCss = "completionDelay" : "";
		        return customCss; 
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: subGridData
		});
		
		subGrid.data.filter(function (item) {
		    return item.SRArea1 == rowData.SRArea1 && item.SRArea2 == rowData.SRArea2;
	    });	
		
		subGrid.events.on("cellClick", function(row,column,e) {
			var screenType = "${screenType}";
			var srCode = arguments[0].SRCode;
			var srID = arguments[0].SRID;
			var receiptUserID = arguments[0].ReceiptUserID;
			var status = arguments[0].Status;
			var srType = arguments[0].SRType;
			   
			if(srType == "ITSP"){
				url = "processItsp.do?";
			} else if(srType == "ISP"){
				url = "processIsp.do?";
			}
			   
			var data = "srCode="+srCode
				+"&srMode=srRqst&srType=${srType}&screenType=${screenType}&srID="+srID
				+"&receiptUserID="+receiptUserID+"&status="+status+"&projectID=${projectID}"
				+"&isPopup=Y";
			 var w = 1280;
			 var h = 710;
			 var spec = "width="+w+", height="+h+",top=100,left=100,toolbar=no,location=no,status=yes,resizable=yes,scrollbars=yes";
			 var popup = window.open(url+data, '_blank', spec);
	    });
	}
	
	function gridExportXlsx(){
		grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	}
	
	function subGridExportXlsx(){
		subGrid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	}
</script>
<style>
	.receiptDelay{
		background-color:#FCDCDC;
	}
	.receiptDelay > div {
		font-weight: bold;
	}
	.completionDelay {
		background-color:#CFE4FC;
	}
	.completionDelay > div {
		font-weight: bold;
	}
	.subGridExcel {
		display:none;
	}
</style>

<div id="chart" style="height:200px;"></div>
<div class="mgB10 alignR pdR10" style="width:100%;"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" onClick="gridExportXlsx()"></span></div>
<div id="grid" style="height:250px;"></div>
<div class="mgB10 alignR pdR10 subGridExcel" style="width:100%;"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" onClick="subGridExportXlsx()"></span></div>
<div id="subGrid" style="height:250px;"></div>