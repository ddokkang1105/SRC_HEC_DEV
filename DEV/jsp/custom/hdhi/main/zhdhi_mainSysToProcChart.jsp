<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
    var p_chart;
    var sysToProcData = ${sysToProcData};
    var max = ${sys_max};

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
            chart.destructor();
            fnBarChartLoad();
        });

    });
    var totalValue = 0;
    
	function tooltipTemplate(p) {
		var total = (findValueByName(sysToProcData,p[1])); 
	    return p[0];
	}    
    
    var chart2;
    function fnBarChartLoad() {
        if (!document.getElementById('activityChartArea2')) {
            console.error('activityChartArea2 div를 찾을 수 없습니다.');
            return;
        }
        

        var config = {
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
                    id: "맵 반영",
                    value: "맵 반영",
                    color: "#FFFF00",
                    fill: "#FFFF00",
                    barWidth: 150,
                    tooltipTemplate: tooltipTemplate
                },
                {
                    id: "맵 미반영",
                    value: "맵 미반영",
                    color: "#046B99",
                    fill: "#046B99",
                    barWidth: 150,
                    tooltipTemplate: tooltipTemplate
                }
            ],
            legend: {
                series: ["맵 반영", "맵 미반영"],
                halign: "right",
                valign: "top"
            }
        };

        chart2 = new dhx.Chart("activityChartArea2", config);
        chart2.data.parse(sysToProcData);         
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
		<td><div id="activityChartArea2" style="width:100%;height:100%;"></div></td>
	</tr>
</table>
