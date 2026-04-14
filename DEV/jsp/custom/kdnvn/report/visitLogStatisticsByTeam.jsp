<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">

<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getKDNVNCompanyList','${companyID}','Select',"custom_SQL","");
		
		if("${companyID}" != '' & "${companyID}" != null){
			fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID=${companyID}','getKDNVNTeamList','${teamID}','Select',"custom_SQL","");
		}
		gridInit();	
		doSearchList();
		
	});
	
	function fnGetTeam(companyID){
		fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID='+companyID,'getKDNVNTeamList','${companyID}','Select',"custom_SQL","");
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		
		p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
	}
	
	function setGridData(){
		
		var result = new Object();
		var widths = "";
		var sorting = "";
		var aligns = "";
		var processCspan = "";
		var companyStandardCspan = "";
		
		var processCnt = "${processCnt}";
		var companyStandardCnt = "${companyStandardCnt}";
		
		for (var i = 0; i < processCnt; i++) {
			widths = widths + ",80";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != processCnt - 1) {
				processCspan = processCspan + ",#cspan";
			}
		}
		
		for (var i = 0; i < companyStandardCnt; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != companyStandardCnt - 1) {
				companyStandardCspan = companyStandardCspan + ",#cspan";
			}
		}
				
		result.title = "";
		result.key = "";
		
		result.header = "${menu.LN00104},${menu.LN00011}" + processCspan +",${menu.LN00331}" + companyStandardCspan;
		result.attachHeader1 = "#rspan" + "${processRows}"+ "${companyStandardRows}";
		result.cols = "Date|" + "${processCols}" + "${companyStandardCols}";
		result.widths = "180" + widths;
		result.sorting = "str" + sorting;
		result.aligns = "left" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/visitLogStatisticsByTeamKDNVNGrid.xml");
		
	}
	
	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL && PDF
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	function doPdf() {		
		p_gridArea.toPDF("${root}pdfGenerate");
	}	
	// END ::: EXCEL && PDF
	//===============================================================================
	function fnSearchProchSum(){
		var url = "visitLogStatisticsByTeamKDNVN.do";
		var target = "grdGridArea";		
		var data = "year="+$("#year").val()+"&month="+$("#month").val()+"&date="+$("#year").val()+$("#month").val() + "&companyID="+$("#company").val()+"&teamID="+$("#team").val();
		ajaxPage(url, data, target);
	}	
</script>
<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
</div>
	
<div class="child_search">
	<ol>
		<li>&nbsp;&nbsp;Year
			<select id="year" name="year" style="width:80px;">
				<c:forEach var="i" begin="2016" end="${lastYear}">
					<option <c:if test="${ i eq year }"> selected="selected" </c:if> value="${i}">${i}</option>
				</c:forEach>
			</select>
			
		</li>
	   <li>&nbsp;&nbsp;Month
			<select id="month" name="month" style="width:50px;">
			<c:forEach var="i" begin="1" end="12">
				<c:choose>
					<c:when test="${i<10}">
						<option <c:if test="${ '0'+i eq month }"> selected="selected" </c:if> value="0${i}">0${i}</option>
					</c:when>
	       				<c:otherwise>
	       					<option <c:if test="${ i eq month }"> selected="selected" </c:if> value="${i}">${i}</option>
	       				</c:otherwise>
	       			</c:choose>
			</c:forEach>
			</select>
		</li>
		<li class="pdL10">
			Company &nbsp;
			<select id="company" Name="companyID" OnChange="fnGetTeam(this.value);" style="width:150px;"></select>
			&nbsp; ${menu.LN00104} &nbsp;
			<select id="team" Name="teamID" style="width:170px;"><option value="">Select</option></select>
			&nbsp;&nbsp;
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()" />
		</li>
		<li class="floatR pdR20">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</ol>
</div>
<form name="rptForm" id="rptForm" action="" method="post" >	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->			
</form>