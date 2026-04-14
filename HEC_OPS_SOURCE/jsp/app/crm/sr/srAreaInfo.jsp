<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script>
	var p_gridArea;	
	var screenType = "${screenType}";
	var srMode = "${srMode}";
	var srType = "${srType}";

	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		gridInit();	
		doSearchList();
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}

	
	function gridInit(){		
		var d = setGridData();
		p_gridArea =  fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
	//	p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
	//	p_gridArea.enablePaging(true,20,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridData(){
		var result = new Object();		
		result.header = "${menu.LN00024},${menu.LN00274},${menu.LN00004},${menu.LN00185},${menu.LN00004},ITO${menu.LN00004}";
		result.widths = "30,150,200,*,250,250";
		result.sorting = "int,str,str,str,str,str";
		result.aligns = "center,left,left,left,left,left,left";
		result.data = "";
					
		return result;
	}
	
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
	
</script>

<div id="srAreaInfoListDiv">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Service desk</span>
	</div>
	<li class="mgT5 mgB5 alignR"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
</div>