<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00262}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>
<style>
    .dhx_chart{font-size: 11px;font-family:'Malgun Gothic' !important;padding:0;border:0px;}
    .dhx_chart canvas{ left:0px;;}
</style>
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var p_subGridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	var isMainMenu = "${isMainMenu}";
	
	//window.onload=setInit;
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			if(fnValidationSearch()){doSearchList();$("#subGridDiv").attr("style","display:none;");}
		});
	    $("#excel").click(function(){
	    	doExcel();
	    	return false;
	    });
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:250px;");
		
      	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
      	fnSelect('srArea1', data, 'getSrArea1', '${srArea1}', 'Select');
      	fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
     	if('${srArea1}' !='' ) fnGetSRArea2('${srArea1}');
 		fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select','esm_SQL');	
 		fnSelect('crReceiptTeam', data, 'getCRReceiptTeamID', '${crReceiptTeam}', 'Select');	
 		
		if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함
			gridInit();
			doSearchList();			
			doCallChart();
		}
	});
	function setInit(){
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);
		}else{window.addEventListener("resize",resizeLayout, false);}
		var t;
		function resizeLayout(){			
			window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
		
	}
	function setScreenResize(){//document.getElementById("container").style.height = (clientHeight - (81)) + "px";if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);} baseLayout.setSizes();}
		var setWidth = setWindowWidth();
		$("#chartArea").css("width",setWidth+"px");	
		p_chart.refresh();	
	}

	//===============================================================================
	// BEGIN ::: CHART
	function setChartData(){
		var result = new Object();
		result.key = "analysis_SQL.getBISRCntList";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&srArea1="+$("#srArea1").val() + "&srArea2="+$("#srArea2").val()+"&itemType="+$("#itemType").val()
				+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
				+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
				+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
				+"&category="+$("#category").val()+"&subCategory="+$("#subCategory").val()				
				+"&srReceiptTeam="+ $("#srReceiptTeam").val()+"&crReceiptTeam="+ $("#crReceiptTeam").val()+"&srType=${srType}";
		result.cols = "label|value|PscRat";		
		return result;
	}
	function setChartConfig(){
		var result = new Object();
		result.view = "BAR";
		result.value = "#value#";
		result.label = "#label#";	
		result.color = "#color#";		
		return result;		
	}
	function doCallChart(){	
		var d = setChartData();
		var config = setChartConfig();
		if(p_chart!=undefined){
			p_chart.destructor();
			//p_chart.clearAll();
		}
		p_chart = fnNewInitChart(config, "chartArea");		
		p_chart.attachEvent("onItemClick", function(id, event){
			var target = event.target||event.srcElement;
		});
		fnLoadDhtmlxChartJson(p_chart, "chartArea", d.key, d.cols, d.data, false,"Y");

		//꺽은선 그래프 추가
		p_chart.addSeries({
		     view: "line",
		     item:{radius:0},
		     line:{color:"#36abee"},
		     value:"#PscRat#",
		     label:"#PscRat#"
		     //label:("#PscRat#").toFixed(2)
		     //label:function(obj){var psc = "#PscRat#"; alert(obj.PscRat); return psc.toFixed(2);}
		});
	}	
	// END ::: CHART
	//===============================================================================
		
	//===============================================================================
	// BEGIN ::: MAIN GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setNumberFormat("0,000.00",6,".",",");
		p_gridArea.setNumberFormat("0,000.00",10,".",",");
		p_gridArea.setColumnHidden(11, true);				
		p_gridArea.setColumnHidden(12, true);				
		//p_gridArea.attachFooter("Total,#cspan,#cspan,<div id='sr_rc'>0</div>,<div id='sr_cc'>0</div>,<div id='sr_ph'>0</div>,-,<div id='cr_rc'>0</div>,<div id='cr_cc'>0</div>,<div id='cr_ph'>0</div>,-,-,-",["text-align:right;"]);
		p_gridArea.attachFooter("Total,#cspan,#cspan,{#stat_total},{#stat_total},{#stat_total},,{#stat_total},{#stat_total},{#stat_total},,,"
				,['font-weight: bold',,
				  ,'text-align:right;font-weight:bold','text-align:right;font-weight:bold','text-align:right;font-weight:bold',
				  ,'text-align:right;font-weight:bold','text-align:right;font-weight:bold','text-align:right;font-weight:bold',,,]);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});	
		//p_gridArea.setOnLoadingEnd(calculateFooterValues);
		//p_gridArea.load("../common/grid_numbers.xml",calculateFooterValues);
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "analysis_SQL.getBISRCntList";
		result.header = "${menu.LN00024},${menu.LN00274},${menu.LN00185},SR요청건,SR완료건,SR처리시간(H),SR적기납기율(%),CR접수건,CR완료건,CR처리시간(H),CR적기납기율(%),SRArea1,SRArea2";
		result.cols = "SRArea1Name|SRArea2Name|SRReqCnt|SRCmpCnt|SRPscHour|SROtdRat|CRRcvCnt|CRCmpCnt|CRPscHour|CROtdRat|SRArea1|SRArea2";
		result.widths = "50,150,200,100,100,100,100,100,100,100,100,0,0";
		result.sorting = "str,str,str,str,str,str,int,str,str,str,int,str,str";
		result.aligns = "center,center,left,right,right,right,right,right,right,right,right,center,center";
		result.types = "ron,ron,ron,ron,ron,ron,edn,ron,ron,ron,edn,ron,ron";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&srArea1="+$("#srArea1").val() + "&srArea2="+$("#srArea2").val()+"&itemType="+$("#itemType").val()
				+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
				+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
				+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
				+"&category="+$("#category").val()+"&subCategory="+$("#subCategory").val()
				+"&srReceiptTeam="+ $("#srReceiptTeam").val()+"&crReceiptTeam="+ $("#crReceiptTeam").val()+"&srType=${srType}";
		return result;
	}
	function calculateFooterValues(stage){
		alert(stage);
		if(stage && stage!=6)
			return true;
		var srRC = document.getElementById("sr_rc");
			srRC.innerHTML = sumColumn(3);
		var srCC = document.getElementById("sr_cc");
			srCC.innerHTML = sumColumn(4);
		var srPH = document.getElementById("sr_ph");
			srPH.innerHTML = sumColumn(5);
		var crRC = document.getElementById("cr_rc");
			crRC.innerHTML = sumColumn(7);
		var crCC = document.getElementById("cr_cc");
			crCC.innerHTML = sumColumn(8);
		var crPH = document.getElementById("cr_ph");
			crPH.innerHTML = sumColumn(9);
		return true;
	}
	function sumColumn(ind){
		var out = 0;
		for(var i=0;i<p_gridArea.getRowsNum();i++){
			out+= parseFloat(p_gridArea.cells2(i,ind).getValue())
		}
		return out;
	}	
	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,"","","","",calculateFooterValues);
		
		doCallChart();
	}
	
	function gridOnRowSelect(id, ind){
		$("#subGridDiv").attr("style","display:block;");
		var SRArea1 = p_gridArea.cells(id, 11).getValue();
		var SRArea2 = p_gridArea.cells(id, 12).getValue();
		
		var url = "srDashboardList.do";
		var target = "subGrdGridArea";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srArea1="+SRArea1+"&srArea2="+SRArea2
				+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
				+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
				+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
				+"&category="+$("#category").val()+"&subCategory="+$("#subCategory").val()
				+"&srReceiptTeam="+ $("#srReceiptTeam").val()+"&crReceiptTeam="+ $("#crReceiptTeam").val();
		ajaxPage(url, data, target);
	}
	// END ::: MAIN GRID	
	//===============================================================================
	function fnGetSRArea1(receiptTeam){
	    var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&receiptTeam="+receiptTeam;
      	fnSelect('srArea1', data, 'getESMSRArea1', '${srArea1}', 'Select','esm_SQL');
	}
    function fnGetSRArea2(SRArea1ID){
	    var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
	    fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
	}	
	function fnGetSubCategory(parentID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
		 fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select','esm_SQL');
	}
	
	// 검색조건확인
	function fnValidationSearch(){
		if(($("#regStartDate").val() == "" && $("#regEndDate").val() != "")||($("#regStartDate").val() != "" && $("#regEndDate").val() == "")){
			alert("${menu.LN00093}을 입력해주십시오."); return false;
		}
		if(($("#srDueStartDate").val() == "" && $("#srDueEndDate").val() != "")||($("#srDueStartDate").val() != "" && $("#srDueEndDate").val() == "")){
			alert("SR${menu.LN00221}을 입력해주십시오."); return false;
		}
		if(($("#crDueStartDate").val() == "" && $("#crDueEndDate").val() != "")||($("#crDueStartDate").val() != "" && $("#crDueEndDate").val() == "")){
			alert("CR${menu.LN00221}을 입력해주십시오."); return false;
		}
		/*
		if(($("#regStartDate").val() == "" && $("#regEndDate").val() == "")&&
				($("#srDueStartDate").val() == "" && $("#srDueEndDate").val() == "")&&
				($("#crDueStartDate").val() == "" && $("#crDueEndDate").val() == "")){
			alert("${menu.LN00093}, SR${menu.LN00221}, CR${menu.LN00221} 중 하나는 입력해주십시오."); return false;
		}
		*/
		
		
		return true;
	}
	// 검색 조건 초기화 
	function fnClearSearch(){;
		$("#srArea1").val("");
		$("#srArea2").val("");
		
		$("#category").val("");
		$("#subCategory").val("");
		
		$("#regStartDate").val("");
		$("#regEndDate").val("");
		$("#srDueStartDate").val("");
		$("#srDueEndDate").val("");
		$("#crDueStartDate").val("");
		$("#crDueEndDate").val("");
	
		$("#srReceiptTeam").val("");
		$("#crReceiptTeam").val("");
		return;
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
		
</script>


<div class="floatL mgT10 mgB12" style="width:100%;">
	<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;SR Dashboard</h3>
</div>
<!-- BEGIN :: SEARCH -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="8%">
	    <col width="23%">
	    <col width="9%">
	    <col width="23%">
	    <col width="9%">
	    <col width="23%">
   </colgroup>
    <tr>
      	<!-- 요청일 -->
		<th class="viewtop alignL pdL10">${menu.LN00093}</th>
		<td class="viewtop alignL">
				<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
				<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-1 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
				<font><input type="text" id="regStartDate" name="regStartDate" value="${beforeYmd}"   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				</font>
			   ~
			   <font><input type="text" id="regEndDate" name="regEndDate" value="${thisYmd}"   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   </font>
		</td>    
      	<!-- SR완료예정일 -->
		<th class="viewtop alignL pdL10">SR${menu.LN00221}</th>
		<td class="viewtop alignL">
				<font><input type="text" id="srDueStartDate" name="srDueStartDate" value=""   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				</font>
			   ~
			   <font><input type="text" id="srDueEndDate" name="srDueEndDate" value=""   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   </font>
		</td> 
      	<!-- CR완료예정일 -->
		<th class="viewtop alignL pdL10">CR${menu.LN00221}</th>
		<td class="viewtop alignL">
				<font><input type="text" id="crDueStartDate" name="crDueStartDate" value=""   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				</font>
			   ~
			   <font><input type="text" id="crDueEndDate" name="crDueEndDate" value=""   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   </font>
		</td> 
	</tr>
	<tr>	
		<!-- SR접수팀 -->
		<th class="alignL pdL10">SR${menu.LN00227}</th>
		<td class="alignL">
			<select id="srReceiptTeam" Name="srReceiptTeam" onchange="fnGetSRArea1(this.value);" style="width:90%;">
				<option value=''>Select</option>
			</select>
		</td>
		<!-- 접수팀 -->
		<th class="alignL pdL10">CR${menu.LN00227}</th>
		<td class="alignL">
			<select id="crReceiptTeam" Name="crReceiptTeam" onchange="fnGetSRArea1(this.value);" style="width:90%;">
				<option value=''>Select</option>
			</select>
		</td>
		<!-- 카테고리 -->
       	<th class="alignL pdL10">${menu.LN00033}</th>
        <td>     
	       	<select id="category" Name="category" onchange="fnGetSubCategory(this.value);" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>       	
	</tr>	
    <tr>
		<!-- 업무영역 -->
		<th class="alignL pdL10">${menu.LN00274}</th>
		<td class="alignL">
		   <select id="srArea1" Name="srArea1" onchange="fnGetSRArea2(this.value);" style="width:90%;">
		      <option value=''>Select</option>
		   </select>
		</td>      	
		<!-- 시스템 -->
		<th class="alignL pdL10">${menu.LN00185}</th>
		<td class="alignL">
		 <select id="srArea2" Name="srArea2" style="width:90%">
		    <option value=''>Select</option>
		</select>
		</td>		
       	<!-- 서브 카테고리 -->
        <th class="alignL pdL10">${menu.LN00273}</th>
        <td class="alignL" colspan="2">     
	        <select id="subCategory" Name="subCategory" style="width:90%;">
	            <option value=''>Select</option>
	        </select>
        </td>		
	</tr>
</table>
<li class="mgT5 alignR">
	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
    <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
</li>
<form name="rptForm" id="rptForm" action="" method="post" >
	<div id="chart" class="mgT10">
		<div id="chartArea" align="center" style="width:100%;display:block;height:170px;"></div>		
	</div>
	<!-- END :: CHART_GRID -->
 	<div id="gridDiv" class="mgT10">
		<div class="mgB10 alignR" style="width:100%;"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></div>
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->				
	<div id="subGridDiv" class="mgT10">
		<div id="subGrdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: DATA LIST_GRID -->		
</form>