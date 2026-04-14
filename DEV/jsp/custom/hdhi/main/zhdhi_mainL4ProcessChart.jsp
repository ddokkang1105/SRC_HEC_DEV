<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
    var p_chart;
    var l4ProcessData = ${l4ProcessData};
    var max = ${l4_max};
    var businessType;

    function findValueByName(data, name) {
        // 주어진 배열을 순회하면서 "name"이 주어진 name과 일치하는 객체를 찾습니다.
        for (var i = 0; i < data.length; i++) {
            if (data[i].name === name) {
                // 객체를 찾으면 해당 객체의 "value" 값을 반환합니다.
                return data[i].value;
            }
        }
        return undefined;
    }

    $(document).ready(function() {
        fnBarChartLoad();

        // 화면 resize 시 차트 재 생성
        window.addEventListener('resize', function() {
            chart1.destructor();
            fnBarChartLoad();
        });
        //alert(${businessType});

    });
    var totalValue = 0;
    
	function tooltipTemplate(p) {
		var total = (findValueByName(l4ProcessData,p[1])); 
	    return p[0];
	}    
    
    var chart1;
    function fnBarChartLoad() {
        if (!document.getElementById('l4ProcessChartArea1')) {
            console.error('l4ProcessChartArea1 div를 찾을 수 없습니다.');
            return;
        }
        
        config = {
            type: "bar",
            css: "dhx_widget",
            scales: {
                "bottom": {
                    text: "label"
                },
                "left": {
                    maxTicks: 10,
                    max: max * 1.1,
                    min: 0
                }
            },
            series: [
                {
                    id: "프로세스",
                    value: "프로세스",
                    color: "#4472C4",
                    fill: "#4472C4",
                    barWidth: 20,
                    tooltipTemplate: tooltipTemplate
                },
                {
                    id: "전체 ACT",
                    value: "전체 ACT",
                    color: "#ED7D31",
                    fill: "#ED7D31",
                    barWidth: 20,
                    tooltipTemplate: tooltipTemplate
                },
                {
                    id: "시스템 ACT",
                    value: "시스템 ACT",
                    color: "#A5A5A5",
                    fill: "#A5A5A5",
                    barWidth: 20,
                    tooltipTemplate: tooltipTemplate
                },
                {
                    id: "시스템",
                    value: "시스템",
                    color: "#FFC000",
                    fill: "#FFC000",
                    barWidth: 20,
                    tooltipTemplate: tooltipTemplate
                }
            ],
            legend: {
                series: ["프로세스", "전체 ACT", "시스템 ACT", "시스템"],
                halign: "right",
                valign: "top"
            }
        }
        
/*         if (businessType == null) {
        	businessType = 'C';
		} else {
        	businessType = "${businessType}";
		}
		
        if (businessType == 'C') {
	        config = {
	            type: "bar",
	            css: "dhx_widget",
	            scales: {
	                "bottom": {
	                    text: "label"
	                },
	                "left": {
	                    maxTicks: 10,
	                    max: max * 1.1,
	                    min: 0
	                }
	            },
	            series: [
	                {
	                    id: "조선",
	                    value: "조선",
	                    color: "#FF6F61",
	                    fill: "#FF6F61",
	                    stacked: true,
	                    itemID: "itemIdList",
	                    tooltipTemplate: tooltipTemplate
	                }
	            ],
	            legend: {
	                series: ["조선"],
	                halign: "right",
	                valign: "top"
	            }
	        };
	    } else if (businessType == 'E') {
	        config = {
		            type: "bar",
		            css: "dhx_widget",
		            scales: {
		                "bottom": {
		                    text: "label"
		                },
		                "left": {
		                    maxTicks: 10,
		                    max: max * 1.1,
		                    min: 0
		                }
		            },
		            series: [
		                {
		                    id: "특수선",
		                    value: "특수선",
		                    color: "#6B5B95",
		                    fill: "#6B5B95",
		                    stacked: true,
		                    itemID: "itemIdList",
		                    tooltipTemplate: tooltipTemplate
		                }
		            ],
		            legend: {
		                series: ["특수선"],
		                halign: "right",
		                valign: "top"
		            }
		        };				    	
	    } else if (businessType == 'Q') {
	        config = {
		            type: "bar",
		            css: "dhx_widget",
		            scales: {
		                "bottom": {
		                    text: "label"
		                },
		                "left": {
		                    maxTicks: 10,
		                    max: max * 1.1,
		                    min: 0
		                }
		            },
		            series: [
		                {
		                    id: "해양",
		                    value: "해양",
		                    color: "#88B04B",
		                    fill: "#88B04B",
		                    stacked: true,
		                    itemID: "itemIdList",
		                    tooltipTemplate: tooltipTemplate
		                }
		            ],
		            legend: {
		                series: ["해양"],
		                halign: "right",
		                valign: "top"
		            }
		        };				    	
	    } else if (businessType == 'X') {
	        config = {
		            type: "bar",
		            css: "dhx_widget",
		            scales: {
		                "bottom": {
		                    text: "label"
		                },
		                "left": {
		                    maxTicks: 10,
		                    max: max * 1.1,
		                    min: 0
		                }
		            },
		            series: [
		                {
		                    id: "공통",
		                    value: "공통",
		                    color: "#F7CAC9",
		                    fill: "#F7CAC9",
		                    stacked: true,
		                    itemID: "itemIdList",
		                    tooltipTemplate: tooltipTemplate
		                }
		            ],
		            legend: {
		                series: ["공통"],
		                halign: "right",
		                valign: "top"
		            }
		        };				    	
	    }  */     

        chart1 = new dhx.Chart("l4ProcessChartArea1", config);
        chart1.data.parse(l4ProcessData);

/*         chart1.events.on("serieClick", function (id, label, value) {
            var item = chart1.data.getItem(id);
            var itemIdList = item.itemIdList;
			
            // itemIdList 로 각 label 별로 itemID 추출
            var splitItemID = itemIdList.split(',');
            var nodeItemID;

            // label에 따라 nodeItemID를 결정
            switch (label) {
                case "조선":
                    nodeItemID = splitItemID[0];
                    break;
                case "특수선":
                    nodeItemID = splitItemID[1];
                    break;
                case "해양":
                    nodeItemID = splitItemID[2];
                    break;
                case "공통":
                    nodeItemID = splitItemID[3];
                    break;
                default:
                    console.error('알 수 없는 label: ' + label);
                    return;
            }
            fnGoTreeItem(nodeItemID, true);
        }); */
    }
</script>

<style>
.tbl_process {
    width: 94%;
    height: 100%;
    margin: 0 auto;
}

#chartArea2 {
    width: 98%;
    height: 100%;
    margin: 0 auto;
}

.process-class .dhx_chart-graph_area {
    stroke: #c8d4e4;
    stroke-width: 1px;
}

.process-class .grid-line {
    stroke: #fff;
    stroke-width: 0px;
}

.process-class .main-scale {
    stroke: #c8d4e4;
    stroke-width: 1px;
}


</style>

<table cellpadding="0" cellspacing="0" class="tbl_process chart2_table">
	<tr style="width:100%;">
		<td><div id="l4ProcessChartArea1" style="width:100%;height:100%;"></div></td>
	</tr>
</table>
