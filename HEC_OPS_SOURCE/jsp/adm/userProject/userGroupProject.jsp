<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(window).load(function(){
		//$("#searchValue").focus();		
	});
	
	$(document).ready(function() {	

		$('.layout').click(function(){
			var changeLayout = $(this).attr('alt');
			setLayout(changeLayout);
		});

		//Grid 초기화
		gridInit();
		doSearchList();
		//doDetail('');
		//화면
		setLayout("2E");
		
	});	
	
	function setLayout(type){
		if( schCntnLayout != null){
			schCntnLayout.unload();
		}
		schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
		schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
		schCntnLayout.items[0].setHeight(350);
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
//		p_gridArea.setColumnHidden(0, true);
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.userGroupProject";
		result.header = "${menu.LN00024},#master_checkbox,ParentProject,Type,${menu.LN00028},${menu.LN00018},${menu.LN00013},${menu.LN00027},,";
		result.cols = "CHK|ParentName|TypeName|ProjectName|TeamName|CreationTime|StatusName|ProjectID|ChildCount";
		result.widths = "50,50,200,200,300,100,100,50,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,left,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(p_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	}
	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
</script>
<link rel="stylesheet" type="text/css" href="${root}${HTML_CSS_DIR}/style.css"/>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->