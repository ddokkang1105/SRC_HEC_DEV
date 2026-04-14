<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- 담당 Item 목록  :: 현재 사용 안함(?)-->
<!-- 
	@RequestMapping(value="/dimensionList.do")
	* dim_SQL.xml - selectDim_gridList
-->
<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(window).load(function(){
		$("#searchValue").focus();		
	});

	$(document).ready(function() {	

		//ComboBox 초기화 
		//fnSelect('ItemTypeCode', '', 'itemTypeCode', '', '전체');
		
		//Grid 초기화
		gridInit();
		doSearchList();
		//doDetail('');
		//화면
		//setLayout("2E");
		
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
		//p_gridArea.setColumnHidden(0, true);				//RNUM
		//p_gridArea.setColumnHidden(9, true);				//ItemID
	
		/*
		p_gridArea.attachEvent("onRowSelect", function(id,ind){
						gridOnRowSelect(id,ind);
		});
		*/
	}
	
	function setGridData(){
		
		var result = new Object();
		result.title = "${title}";
		result.key = "dim_SQL.selectDim";
		result.header = "No,Dimension,Code,Value,ParentID";	//5
		result.cols = "DimensionID|Code|Dimension|ParentID";
		result.widths = "50,100,*,200,120";
		result.sorting = "str,str,str,str,str";
		result.aligns = "center,center,center,center,center";
		result.data = //"ItemTypeCode="		+ $('#ItemTypeCode').val()
		            //+ "&ClassCode="     	+ $("#newClassCode").val()
			        //+ "&searchKey="     	+ $("#searchKey").val()
			        //+ "&searchValue="     	+ $("#searchValue").val()
		 			"s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){

		//doDetail(p_gridArea.cells(id, 9).getValue());
	}
	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	/*
	function doDetail(avg){
		//document.getElementById("objInfo").src= "ObjectInfoChild.do?s_itemID="+avg+"&getAuth="+$("#Auth").val()+"&option="+$("#option").val();
		//setSubFrame('OrganizationInfo','addNewItem');
		
		var url = "ObjectInfoChild.do";
		var target = "objInfo";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg+"&getAuth="+$("#Auth").val()+"&option="+$("#option").val();
		ajaxPage(url, data, target);

	}

	
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "newClassCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	*/

</script>

</head>

<body>

	<form name="dimList" id="dimList" action="#" method="post" onsubmit="return false;">
	<!-- BEGIN :: SEARCH -->
	</form>		
	<!-- END :: SEARCH -->
	<!-- BIGIN :: LIST_GRID -->
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->

	<div id="objInfo" style="height:300px; width:100%"></div>

	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
	<!-- END :: FRAME -->
		

</body>
</html>