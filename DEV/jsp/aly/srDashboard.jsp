<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00262}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	var isMainMenu = "${isMainMenu}";
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			if(fnValidationSearch()){doSearchList();$("#subGridDiv").attr("style","display:none;");}
		});
		
	    $("#excel").click(function(){ fnGridExcelDownLoad(p_gridArea); });
		
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
	
	function setScreenResize(){
		var setWidth = setWindowWidth();
		$("#chartArea").css("width",setWidth+"px");	
		p_chart.refresh();	
	}
	
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
	
	function doCallChart(){	
		var d = setChartData();
		if(p_chart!=undefined){
			p_chart.destructor();
		}
		
		const config = {
		    scales: {
		        "bottom": {
		            text: "label"
		        },
		        "left": {
		            min: 0,
		            maxTicks: 5
		        }
		    },
		    series: [
		        {
		            type: "bar",
		            value: "value",
		            showText: true,
		        },
		        {
		            type: "line",
		            value: "PscRat",
		            color: "#36abee",
		            showText: true,
		        }
		    ],
		};

		p_chart = new dhx.Chart("chartArea", config);

		fnLoadDhtmlxChartJson3(p_chart, "chartArea", d.key, d.cols, d.data, false,"Y");
	}
	
	function gridInit(){
		p_gridArea = new dhx.Grid("grdGridArea",  {
			columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], footer: [{ text: "Total" }], align:"center"},       
		        { width: 150, id: "SRArea1Name", header: [{text: "${menu.LN00274}", align:"center"}], align: "center"},
		        { width: 200, id: "SRArea2Name", header: [{ text: "${menu.LN00185}", align:"center" }], align:"left"},
		        { width: 100, id: "SRReqCnt", header: [{ text: "SR요청건", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "SRCmpCnt", header: [{ text: "SR완료건", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "SRPscHour", header: [{ text: "SR처리시간(H)", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "SROtdRat", header: [{ text: "SR적기납기율(%)", align:"center" }], align:"right" },
		        { width: 100, id: "CRRcvCnt", header: [{ text: "CR접수건", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "CRCmpCnt", header: [{ text: "CR완료건", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "CRPscHour", header: [{ text: "CR처리시간(H)", align:"center" }], summary: "sum", footer: [{ text: ({ sum }) => sum, align : "right" }], align:"right" },
		        { width: 100, id: "CROtdRat", header: [{ text: "CR적기납기율(%)", align:"center" }], align:"right" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,		    
		});
		
		p_gridArea.events.on("cellClick", function(row,column,e,item){
			$("#subGridDiv").attr("style","display:block;");
			var SRArea1 = row.SRArea1;
			var SRArea2 = row.SRArea2;
			
			var url = "srDashboardList.do";
			var target = "subGrdGridArea";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srArea1="+SRArea1+"&srArea2="+SRArea2+"&srType=${srType}"
					+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
					+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
					+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
					+"&category="+$("#category").val()+"&subCategory="+$("#subCategory").val()
					+"&srReceiptTeam="+ $("#srReceiptTeam").val()+"&crReceiptTeam="+ $("#crReceiptTeam").val();
			ajaxPage(url, data, target);
	 	});
	}
	
	function setGridData(){
		var sqlID = "analysis_SQL.getBISRCntList";
		var param =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&srArea1="+$("#srArea1").val() + "&srArea2="+$("#srArea2").val()+"&itemType="+$("#itemType").val()
				+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
				+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
				+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
				+"&category="+$("#category").val()+"&subCategory="+$("#subCategory").val()
				+"&srReceiptTeam="+ $("#srReceiptTeam").val()+"&crReceiptTeam="+ $("#crReceiptTeam").val()+"&srType=${srType}"
			+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				p_gridArea.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	//조회
	function doSearchList(){
		if($("#srDueStartDate").val() != "" && $("#srDueEndDate").val() == "")		$("#srDueEndDate").val(new Date().toISOString().substring(0,10));
		if($("#crDueStartDate").val() != "" && $("#crDueEndDate").val() == "")		$("#crDueEndDate").val(new Date().toISOString().substring(0,10));
		
		setGridData();
		doCallChart();
	}
	
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
				<input type="text" id="regStartDate" name="regStartDate" value="${beforeYmd}"   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				
			   ~
			   <input type="text" id="regEndDate" name="regEndDate" value="${thisYmd}"   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   
		</td>    
      	<!-- SR완료예정일 -->
		<th class="viewtop alignL pdL10">SR${menu.LN00221}</th>
		<td class="viewtop alignL">
				<input type="text" id="srDueStartDate" name="srDueStartDate" value=""   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				
			   ~
			   <input type="text" id="srDueEndDate" name="srDueEndDate" value=""   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   
		</td> 
      	<!-- CR완료예정일 -->
		<th class="viewtop alignL pdL10">CR${menu.LN00221}</th>
		<td class="viewtop alignL">
				<input type="text" id="crDueStartDate" name="crDueStartDate" value=""   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				
			   ~
			   <input type="text" id="crDueEndDate" name="crDueEndDate" value=""   class="input_off datePicker text" size="8"
			      style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   
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
		<div class="mgB10 alignR" style="width:100%;">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</div>
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->				
	<div id="subGridDiv" class="mgT10">
		<div id="subGrdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: DATA LIST_GRID -->		
</form>