<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<script>
	var p_gridArea; //그리드 전역변수
	var grid_skin = "dhx_brd";
	var l1Color = ["#bf4266","#ec6b81","#f4a8bb","#f7d5e2","#616160","#9a9a9a","#c7c7c7","#a0caeb","#5990cb","#095bad","#394e79","#1c3058","#5f131c"];
	var l4Color = ["#fbbc12","#51b781","#2298cd","#c7c7c7","#616160","#e14747"];
	var l5Color = ["#00576f","#007f9f","#74d2f7","#c7e9fa","#57d1e5","#abe2ef","#59a7c9","#8dd1f7" ];
	
	var l6Color =  ["#bf4266","#ec6b81","#f4a8bb","#f7d5e2","#616160","#9a9a9a","#c7c7c7","#a0caeb","#a0caeb","#095bad","#394e79","#1c3058","#5f131c","#5990cb"];
	
	var pieData_CL01005 = [${PieDataSet_CL01005}];
	var pieData_CL01006 = [${PieDataSet_CL01006}];
	var stackedBarData_CL01005 = [${barStackedDataSet_CL01005}];
	var stackedBarData_CL01006 = [${barStackedDataSet_CL01006}];
	
	var configChart = {
		type: "pie",
		css: "dhx_widget--bg_white dhx_widget--bordered",
		series: [
			{
		    	value: "value",
		        color: "color",
		        text: "month",
		        stroke: "#FFFFFF",
	            showText: true,
		        strokeWidth: 2
			}
		],
		legend: {
			values: {
		    	text: "id",
		        color: "color"
			},
		    halign: "right",
		    valign: "middle"
		}
	};
	
	var configStackedBar_CL01005 = {
		type: "bar",
        css: "dhx_widget--bg_white dhx_widget--bordered",
        scales: {
            "bottom": {
                text: "month"
            },
            "left": {}
        },
        series: [
        	<c:forEach var="LovCodeData" items="${activityLovCodeList_CL01005}" varStatus="status">
        	{ id: "A${status.index}", value: "${LovCodeData.Value}", fill: l4Color[${status.index}], stacked: true, color: "none", barWidth: 30, showText: true,},
        	<c:if test="${status.last}">
        	{ id: "A${status.index+1}", value: "N/A", fill: l4Color[${status.index+1}], stacked: true, color: "none", barWidth: 30, showText: true,},
        	</c:if>
			</c:forEach>
        ],
        legend: {
            series: [
            	<c:forEach var="LovCodeData" items="${activityLovCodeList_CL01005}" varStatus="status">
            	"A${status.index}",
            	<c:if test="${status.last}">
            	"A${status.index+1}",
            	</c:if>
				</c:forEach>
            	],
            form: "rect",
            valign: "top",
            halign: "right",
        }
    };
	
	var configStackedBar_CL01006 = {
		type: "bar",
        css: "dhx_widget--bg_white dhx_widget--bordered",
        scales: {
            "bottom": {
                text: "month"
            },
            "left": {}
        },
        series: [
        	<c:forEach var="LovCodeData" items="${activityLovCodeList_CL01006}" varStatus="status">
        	{ id: "B${status.index}", value: "${LovCodeData.Value}", fill: l5Color[${status.index}], stacked: true, color: "none", barWidth: 30, showText: true,},
        	<c:if test="${status.last}">
        	{ id: "B${status.index+1}", value: "N/A", fill: l5Color[${status.index+1}], stacked: true, color: "none", barWidth: 30, showText: true,},
        	</c:if>
			</c:forEach>
        ],
        legend: {
            series: [
            	<c:forEach var="LovCodeData" items="${activityLovCodeList_CL01006}" varStatus="status">
            	"B${status.index}",
            	<c:if test="${status.last}">
            	"B${status.index+1}",
            	</c:if>
				</c:forEach>
            	],
            form: "rect",
            valign: "top",
            halign: "right",
            
        }
    };
	
	$(document).ready(function(){

		$('.searchList').click(function(){
			var url = "newItemStatisticsChart.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			
			/* [Dimension] 조건 선택값 */
			if ($("#dimTypeId").val() != "") {
				data = data + "&DimTypeID=" + $("#dimTypeId").val();
				if ($("#dimValueId").val() != "") {
					data = data + "&DimValueID=" + $("#dimValueId").val();
				}
			}
			
			var target = "help_content";
			ajaxPage(url, data, target);
		});
		
		// DimensionTypeList change event
		$('#dimTypeId').change(function(){changeDimValue($(this).val());});
		if ("${DimTypeID}" != "") { changeDimValue("${DimTypeID}"); }
		
		<c:forEach var="itemData" items="${itemClassCodeList}" varStatus="status">
			<c:if test="${itemData.ItemClassCode eq 'CL01005' or itemData.ItemClassCode eq 'CL01006'}">
				var pie_${itemData.ItemClassCode} = new dhx.Chart("chart_${itemData.ItemClassCode}", configChart);
				pie_${itemData.ItemClassCode}.data.parse(pieData_${itemData.ItemClassCode});
				var barStacked_${itemData.ItemClassCode} = new dhx.Chart("barStacked_${itemData.ItemClassCode}", configStackedBar_${itemData.ItemClassCode});
				barStacked_${itemData.ItemClassCode}.data.parse(stackedBarData_${itemData.ItemClassCode});
			</c:if>
		</c:forEach>

		// 초기 표시 화면 크기 조정 
		$("#chartArea").attr("style","height:"+(setWindowHeight() * 0.8)+"px; overflow:scroll;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#chartArea").attr("style","height:"+(setWindowHeight() * 0.8)+"px; overflow:scroll;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}	

	// [Process Update] Click
	function processUpdate() {
		var url = "newItemStatisticsChart.do";
		var data = "eventMode=prcUpdate&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = "${DimValueID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption, 1000);
	}
	
	function appendOption(){
		$("#dimValueId").val("${DimValueID}").attr("selected", "selected");
	}
	
	function getRandomColor() {
		var letters = '0123456789ABCDEF';
		var color = '#';
		for (var i = 0; i < 6; i++) {
	    	color += letters[Math.floor(Math.random() * 16)];
		}
		return color;
	}
	
	function changeStatics(){
		var url = "admin/newItemStatistics.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		/* [Dimension] 조건 선택값 */
		if ($("#dimTypeId").val() != "") {
			data = data + "&DimTypeID=" + $("#dimTypeId").val();
			if ($("#dimValueId").val() != "") {
				data = data + "&DimValueID=" + $("#dimValueId").val();
			}
		}
		
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
</script>

<div class="pdL10 pdR10">
	<div class="cop_hdtitle" style="width:100%;">
	<li class="floatR pdR15">
		<div class="icon_color_btn2" onclick="changeStatics()" style="cursor:pointer; display:inline-block;" >
		<i class="mdi mdi-table" style="color:#494848;"></i>
		 </div>
		<div class="icon_color_btn searchList"  style="cursor:pointer; display:inline-block; background-color:#E3F0FE;">
	 	 	<i class="mdi mdi-chart-pie" style="color: #0f80e2;"></i>
		 </div>
	</li>
	
	<h3 style="padding: 6px 0;     border-bottom: 1px solid #ccc;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Process Statistics</h3>
	</div>
	<div class="child_search01">
		<ul>
			<li class="pdL20">
				<select id="dimTypeId" style="width:120px">
		    		<option value=''>Select</option>
		         	   		<c:forEach var="i" items="${dimTypeList}">
		                 		<option value="${i.DimTypeID}" <c:if test="${DimTypeID == i.DimTypeID}">selected="selected"</c:if>>${i.DimTypeName}</option>
		         	    	</c:forEach>
				</select>
				<select id="dimValueId" <c:if test="${isMainMenu eq 'Y' }"> style="width:120px;" </c:if> >
					<option value="">Select</option>
				</select>	
			</li>
			<li>
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
			</li>
			<li class="floatR ">
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="processUpdate();">
				<span class="mdi mdi-pencil mgR5 mgL_5" style="color:#494848;"></span>Update
			    </button>
			</li>
		</ul>
	</div>
	<form name="itemStatisticsForm" id="itemStatisticsForm" action="" method="post" >	
		<div id="chartArea" style="" class="pdL20">
		<c:forEach var="itemData" items="${itemClassCodeList}" varStatus="status">
			<c:if test="${itemData.ItemClassCode eq 'CL01005' or itemData.ItemClassCode eq 'CL01006'}">
				<h1>${itemData.className}</h1>
				<div id="chart_${itemData.ItemClassCode}" style="padding: 5px;width: 47%;height: 370px;display:inline-block;"></div>
				<div id="barStacked_${itemData.ItemClassCode}" style="padding: 5px;width: 50%;height: 370px;display:inline-block;"></div>	
			</c:if>			
		</c:forEach>
				
		</div>
	</form>
	
</div>