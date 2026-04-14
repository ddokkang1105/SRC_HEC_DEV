<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">

<script>
	var p_gridArea;				//그리드 전역변수
	var grid_skin = "dhx_brd";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "zhmbs_proc_stat.do";
			var data = setData();
			/* [Dimension] 조건 선택값 */
			var target = "help_content";
			ajaxPage(url, data, target);
		});
		
		/* fnSelect('dimTypeId', '&languageID='+languageID, 'getDimTypeList', '${dimTypeID}', 'Select', 'dim_SQL'); */
		
		//GRID
		gridInit();	
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		
		//p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
	    p_gridArea.setPagingSkin("bricks");   
	      p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
	      p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");   
	}
	function setGridData(){
		var result = new Object();
		var widths = "";
		var sorting = "";
		var aligns = "";
		var dimCnt = "${dimCnt}";
		var dimValueNames = "${dimValueNames}";
		var dimvalues = "${dimvalues}";
		var colWidth = (document.body.clientWidth - 225 - 41) / dimCnt;

		for (var i = 0; i < dimCnt; i++) {
			widths = widths + "," + colWidth;
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title	= "";
		result.key		= "custom_SQL.getZhmbsProcSum";
		result.header	= "NO,L1Code,Level,ProcessID,ProcNM,L1Name,L2Name,L3Name,L4Name,Application,AppType,Tcode,DevID " + dimValueNames;
		result.cols    = "L1Code|Level|ProcessID|ProcNM|L1Name|L2Name|L3Name|L4Name|AT00013|AT00037|AT00014|AT00027 " + dimvalues;
		result.widths	= "0,50,50,120,125,100,120,120,120,120,120,120,120" + widths;
		result.sorting	= "str,str,str,str,str,str,str,str,str,str,str,str,str" + sorting;
		result.aligns	= "center,center,center,center,center,center,center,center,center,center,center,center,center" + aligns;
		result.data		= setData();
		return result;
	}
	
	//조회
	function doSearchList(){
		/*
		p_gridArea.enableRowspan(true);
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
		*/
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false,"N");	
	}
	
	function setData(){
		var data = "";
		data = "&languageID="+languageID+"&dimTypeID="+$('#dimTypeID').val()
		+ "&pageNum=" + $("#currPage").val();
		return data;
	}
	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}

	// END ::: EXCEL
	//===============================================================================
	
	// [Process Update] Click
	function processUpdate() {
		var url = "zhmbs_proc_stat.do";
		var data = "eventMode=prcUpdate"+setData();
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
</script>


<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Process Statistics</div>
	
<div class="child_search">
	<li class="pdL55">
		<select id="dimTypeID" style="width:120px">
    		<option value=''>Select</option>
         	   		<c:forEach var="i" items="${getDimTypeList}">
                 		<option value="${i.DimTypeID}" <c:if test="${dimTypeID == i.DimTypeID}">selected="selected"</c:if>>${i.DimTypeName}</option>
         	    	</c:forEach>
		</select>
	<!-- 	
		<select id="dimValueId">
			<option value="">Select</option>
		</select>
	 -->
	</li>
	<li>
		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
	</li>
	<li class="floatR pdR20">
	<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}">
		<span class="btn_pack small icon"><span class="edit"></span><input value="Process Update" type="submit" onclick="processUpdate();"></span>
	</c:if>
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</li>
</div>

<form name="itemStatisticsForm" id="itemStatisticsForm" action="" method="post" >
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</form>