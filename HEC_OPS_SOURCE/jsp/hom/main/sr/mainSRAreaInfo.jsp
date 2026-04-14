<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script>
	var p_gridArea;				//그리드 전역변수
	var grid_skin = "dhx_brd";
	$(document).ready(function(){
		var fullScreen = "${fullScreen}"; 
		var height = "${height}";
		console.log(height);
		if(fullScreen=='Y'){
			$("#grdSRGridArea01").attr("style","height:700px;");
		}
		if(height != null || height != ''){
			$("#grdSRGridArea01").attr("style","height:"+height+"px;");
		}
			
		gridInit();	
		doSearchList();
	});	

	function gridInit(){		
		var d = setGridData();				
		p_gridArea = fnNewInitGridMultirowHeader("grdSRGridArea01", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid

	}
	
	function setGridData(){
		var result = new Object();
		result.header = "파트,시스템,1차담당자,#cspan,#cspan,2차담당자,#cspan,#cspan";
		result.attachHeader1 = "#rspan,#rspan,소속,이름,내선번호,소속,이름,내선번호";
		result.widths = "80,*,120,80,80,120,80,80";
		result.sorting = "str,str,str,str,str,str,str,str";
		result.aligns = "center,left,left,left,left,left,left,left";
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan(true);
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	
</script>

<form name="srRptFrm" id="srRptFrm" action="" method="post" >
	<c:if test="${fullScreen=='Y'}" >
		<div style="padding:10px 30px 10px 30px;height:680px;overflow-x:hidden;overflow-y:auto;">
		<div class="cop_hdtitle" ><h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;IT Service Desk</h3></div>	
	</c:if>
	<div id="gridDiv" ><div id="grdSRGridArea01" style="width:100%;height:300px"></div></div>
	<c:if test="${fullScreen=='Y'}" ></div></c:if>
</form>