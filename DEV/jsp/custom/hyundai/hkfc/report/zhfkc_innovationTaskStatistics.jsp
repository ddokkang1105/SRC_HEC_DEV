<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>
<c:set var="PT_OVER_BL" value="0"/>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>"> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var p_gridArea;   
	var myBarChart;   
	var myBarChartConfig;
	<c:forEach var="StatisticsList" items="${graphInnovationTaskStatisticsList}" varStatus="status">
		<c:if test="${StatisticsList.ProgressType eq 'PT_OVER'}">
			<c:set var="PT_OVER_BL" value="${StatisticsList.ZLV10111 + StatisticsList.ZLV10112 + StatisticsList.ZLV10113 + StatisticsList.ZLV10114}" />
		</c:if>
	</c:forEach>
	
	var salesData = [
		
		<c:if test="${graphInnovationTaskStatisticsList.size() == 0 }">
		{ 
			month: "적용일 미경과"
				, "BaseLineD" : 0
				, "경과": 0, "미경과": 0
				, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
				, "(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0  
		},
		{ 
			month: "적용일 경과"
				, "BaseLineD" : 0
				, "경과": 0, "미경과": 0
				, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
				,"(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
		},
		</c:if>
		
		<c:forEach var="StatisticsList" items="${graphInnovationTaskStatisticsList}" varStatus="status">
		
		<c:choose>
			
			<c:when test="${graphInnovationTaskStatisticsList.size() == 1 }">
				
				<c:choose>
					<c:when test="${StatisticsList.ProgressType eq 'PT_UNDER'}">
						{ 
							month: "적용일 미경과"
								, "BaseLineD" : ${PT_OVER_BL}
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
								, "(미경과)선적용": ${StatisticsList.ZLV10115}, "(미경과)양호": ${StatisticsList.ZLV10116}, "(미경과)이슈": ${StatisticsList.ZLV10117}, "(미경과)취소": ${StatisticsList.ZLV10118}  
						},{ 
							month: "적용일 경과"
								, "BaseLineD" : 0
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
								,"(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
						},	
					</c:when>
					<c:otherwise>
						{ 
							month: "적용일 미경과"
								, "BaseLineD" : 0
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
								, "(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0  
						},{ 
							month: "적용일 경과"
								, "BaseLineD" : 0
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": ${StatisticsList.ZLV10111}, "(경과)모니터링": ${StatisticsList.ZLV10112}, "(경과)지연": ${StatisticsList.ZLV10113}, "(경과)미적용취소": ${StatisticsList.ZLV10114}
								,"(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
						},
					</c:otherwise>
				</c:choose>
			
			
			</c:when>			
			<c:otherwise>
					
				<c:choose>
					<c:when test="${StatisticsList.ProgressType eq 'PT_UNDER'}">
						{ 
							month: "적용일 미경과"
								, "BaseLineD" : ${PT_OVER_BL}
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
								, "(미경과)선적용": ${StatisticsList.ZLV10115}, "(미경과)양호": ${StatisticsList.ZLV10116}, "(미경과)이슈": ${StatisticsList.ZLV10117}, "(미경과)취소": ${StatisticsList.ZLV10118}  
						},	
					</c:when>
					<c:otherwise>
						{ 
							month: "적용일 경과"
								, "BaseLineD" : 0
								, "경과": 0, "미경과": 0
								, "(경과)과제완료": ${StatisticsList.ZLV10111}, "(경과)모니터링": ${StatisticsList.ZLV10112}, "(경과)지연": ${StatisticsList.ZLV10113}, "(경과)미적용취소": ${StatisticsList.ZLV10114}
								,"(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
						},
					</c:otherwise>
				</c:choose>
			
			
			</c:otherwise>
		</c:choose>	
		
		
		
		
		
				
		</c:forEach>
		
		<c:if test="${graphInnovationTaskALLStatisticsList.size() == 0 }">
			{ 
				month: "전체"
					, "BaseLineD" : 0
					, "경과": 0, "미경과": 0
					, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
					, "(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
			}
		</c:if>
		<c:forEach var="ALLStatisticsList" items="${graphInnovationTaskALLStatisticsList}" varStatus="status">
		{ 
			month: "전체"
				, "BaseLineD" : 0
				, "경과": ${ALLStatisticsList.PT_OVER}, "미경과": ${ALLStatisticsList.PT_UNDER}
				, "(경과)과제완료": 0, "(경과)모니터링": 0, "(경과)지연": 0, "(경과)미적용취소": 0
				, "(미경과)선적용": 0, "(미경과)양호": 0, "(미경과)이슈": 0, "(미경과)취소": 0
		}
		<c:set var="ALLStatisticsCNT" value="${ALLStatisticsList.PT_OVER + ALLStatisticsList.PT_UNDER}" />
	</c:forEach>
    ];

	
   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() * 0.5)+"px;");
      
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() * 0.5)+"px;");
      };
      
     $("#excel").click(function(){
    	doExcel();
		return false;
	 });
      
     $("#Search").click(function(){
    	doSearchList();
		return false;
	 });

	setTimeout(function() { 
		gridInit(); 
		doSearchList();
		doOnLoadChart();
	},500 );
      
   });
   
   function doOnLoadChart() {
	   myBarChartConfig = {
			   type: "xbar",
		        css: "dhx_widget--bg_white dhx_widget--bordered",
		        scales: {
		            "bottom": {
		            	title: "",
		                min: 0,
		                //max : "${ALLStatisticsCNT}"
		            },
		            "left": {
		            	text: "month",
		            	size: 150
		            }
		        },
		        series: [
		        	{
		                id: "BaseLineD",
		                value: "BaseLineD",
		                fill: "none",
		                stacked: true,
		                color: "none",
		                barWidth: 30,
		                baseLine: ${PT_OVER_BL},
		            },
		            {
		                id: "OVER",
		                value: "경과",
		                fill: "#a8c7ff",
		                stacked: true,
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "UNDER",
		                value: "미경과",
		                fill: "#a3ebff",
		                stacked: true,
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10111",
		                value: "(경과)과제완료",
		                stacked: true,
		                fill: "#a8c7ff",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10112",
		                value: "(경과)모니터링",
		                stacked: true,
		                fill: "#ddfdae",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10113",
		                value: "(경과)지연",
		                stacked: true,
		                fill: "#ffaaa9",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10114",
		                value: "(경과)미적용취소",
		                stacked: true,
		                fill: "#ccb9e9",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            
		            {
		                id: "ZLV10115",
		                value: "(미경과)선적용",
		                stacked: true,
		                fill: "	#a3ebff",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10116",
		                value: "(미경과)양호",
		                stacked: true,
		                fill: "#ffc593",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10117",
		                value: "(미경과)이슈",
		                stacked: true,
		                fill: "#b5c2d8",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            },
		            {
		                id: "ZLV10118",
		                value: "(미경과)취소",
		                stacked: true,
		                fill: "#dbbaba",
		                color: "none",
		                showText: true,
		                barWidth: 30,
		            }
		        ],
		        legend: {
		            series: ["OVER","UNDER","ZLV10111","ZLV10112","ZLV10113","ZLV10114","ZLV10115","ZLV10116","ZLV10117","ZLV10118"],
		            halign: "right",
		            valign: "top"		        
		            }
		        
		        
			};
		var myBarChart = new dhx.Chart("chartDiv", myBarChartConfig);
		myBarChart.data.parse(salesData);
	}

   
   function setWindowHeight(){
      var size = window.innerHeight;
      var height = 0;
      if( size == null || size == undefined){
         height = document.body.clientHeight;
      }else{
         height=window.innerHeight;
      }return height;
   }
   
   //===============================================================================
   // BEGIN ::: GRID
   function gridInit(){      
      var d = setGridData();
      p_gridArea = fnNewInitGrid("grdGridArea", d);
      p_gridArea.setColumnHidden(0, true);
   }
   function setGridData(){

      var result = new Object();
      result.title = "${title}";
      result.key = "custom_SQL.zhkfc_getGridInnovationTaskStatistics";
      result.header = "${menu.LN00024},부문,(경과)과제완료,(경과)모니터링,(경과)지연,(경과)미적용취소,(미경과)선적용,(미경과)양호,(미경과)이슈,(미경과)취소,Total";
      result.cols = "P_Name|ZLV10111|ZLV10112|ZLV10113|ZLV10114|ZLV10115|ZLV10116|ZLV10117|ZLV10118|V_Total";
      result.widths = "0,200,110,110,110,110,110,110,110,110,110";
      result.sorting = "int,str,int,int,int,int,int,int,int,int,int";
      result.aligns = "center,center,center,center,center,center,center,center,center,center,center";
      result.data = "languageID=${languageID}&s_itemID=${s_itemID}";
      //result.data = "languageID=1042&s_itemID=161020";
      
               
      return result;
   }

   function doSearchList(){
	   	var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
   }
   
   var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			p_gridArea.toExcel("${root}excelGenerate");
		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		}
		
	}
	
   function goBack() {
		var url = "objectReportList.do";
		var data = "s_itemID=${s_itemID}"; 
		var target = "proDiv";
	 	ajaxPage(url, data, target);
	}
   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	
	<div class="msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp; Innovation Task Statistics </span>
	</div>	
	
	<div id="chartDiv" style="height:220px; border:1px solid #c0c0c0;margin:20px;"></div>
	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
         </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>