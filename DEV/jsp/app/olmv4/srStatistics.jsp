<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript">
var dataset = ${result}
var spanData = ${spanData}
console.log(spanData)

var columns = [
    { id: "srCatLv1_NM", header: [{ text: "Category/Sub Category", colspan:2 }], gravity:1, mark: function() {return "fcfcfc" } },
    { id: "srCatLv2_NM", header: [{ text: "Sub Category" }], gravity:1, mark: function() {return "fcfcfc" }},
]

fnMakeColumns(${statusList})
function fnMakeColumns(list){	
// 	var options 	= new Array();
// 	var footerContent = new Object();
// 	footerContent.content = "sum";
// 	footerContent  = JSON.stringify(footerContent);
// 	options.push(JSON.parse(footerContent));
	for(idx in list){
		var json = new Object();
		json.width = 100;
	    json.id = list[idx].CODE;
		json.header = list[idx].NAME;
// 		json.footer = options;
// 		if(list[idx].CODE == "srCatLv1_NM" || list[idx].CODE == "srCatLv2_NM") json.mark = function() {return "fcfcfc" };
		json = JSON.stringify(json);
		columns.push(JSON.parse(json));
	};

	var json = new Object();
	json.width = 120;
    json.id = "statusCnt";
	json.header = "Total"
	json.mark = function() {return "fcfcfc" };
	
	json = JSON.stringify(json);
	columns.push(JSON.parse(json));
	
	return columns;
}

var srStatistics = new dhx.Grid("srStatistics", {
    columns: columns,
    data: dataset,
    margin : "0 10px",
    tooltip : false,
    leftSplit: 2,
    autoWidth: true,
    spans: spanData,
    resizable : true,
    rowCss: function (row) { return row.custom ? "fcfcfc" : "" },
});


// grid.paint();
</script>
<style>
	.fcfcfc {
	    background: #fcfcfc;
	    
	}
</style>
<div class="title-section">SR 처리현황 통계</div>
<div style="height: calc(100% - 58px); width: 100%" id="srStatistics"></div>
