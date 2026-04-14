<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<script type="text/javascript">
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var p_gridArea;
	
	jQuery(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 20)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 20)+"px;");
		};
		
		gridInit();
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

	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");			
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,"", "", "", "", "", "${WM00119}", 1000);
		
	}
	function setGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "custom_SQL.zdaelim_Category";
		result.header = "No,Category Name,Category Code";
		result.cols = "CategoryNM|CategoryCD";
		result.widths = "30,400,100";
		result.sorting = "int,str,str";
		result.aligns = "left,left,center";
		
		result.data = "itemID=${itemID}"		
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		
		return result;
	}

	function gridOnRowSelect(id, ind){
		var cnItemID = "${cnItemID}";
		var categoryCode = p_gridArea.cells(id, 2).getValue();
		opener.fnUpdateCategorys(cnItemID,categoryCode);
		self.Close();
	}
	
	
</script>
<input type="hidden" id="tmpSelID" name="tmpSelID" value="" />
<input type="hidden" id="tmpSelSHR" name="tmpSelSHR" value="" />
<form name="cfgFrm" id="cfgFrm" action="#" method="post" onsubmit="return false;">
<div id="contentwrapper" style="position:absolute;margin:5px;">	
	<div class="child_search_head_blue" style="border:0px;">
			<li class="floatL"><p>* Select Category</p></li>
		</div>	 	
	<div id="contentcolumn" >		
		<div style="width:100%;height:300px;" class="grdGridArea" id="grdGridArea">
		 </div>	
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
</div>	
</form>
