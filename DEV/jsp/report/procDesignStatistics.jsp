<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->

<!-- 2. Script -->
<script type="text/javascript">
	var gridArea;				
	var skin = "dhx_skyblue";

	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 463)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 463)+"px;");
		};
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&classCode=${rootClassCode}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('rootItemID', data, 'getTreeRootItemList', '${rootItemID}', 'Select');
		
		var timer = setTimeout(function() {

		}, 250); //1000 = 1초
		
		gridInit();
		doSearchList();
		
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		gridArea = fnNewInitGridMultirowHeader("gridArea", d);
		
		/*
		gridArea.setColumnHidden(4, true);
		*/
		//fnSetColType(gridArea, 1, "ch");
		
		gridArea.enablePaging(true,10,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		/*
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind); 
		$("input.datePicker").nextAll().remove();
			$("input.datePicker").each(generateDatePicker);
		*/

	}
	
	function setGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00004},${subListOfValueNM}";
		result.widths = "100,${dWidth}";
		result.sorting = "int,${dSort}";		
		result.aligns =  "center,${dAlign}";
		result.data = "";			
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	//조회
	function doSearchList(){
		gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	
	function fnSearchProchSum(){
		var url = "procDesignStatistics.do";
		var target = "procDesignStatistics";		
		var data = "reportCode=${reportCode}&rootItemID="+$("#rootItemID").val()+"&rootClassCode=${rootClassCode}";
		ajaxPage(url, data, target);
	}
	
</script>
<body>
<div id="procDesignStatistics">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" value="OJ00002"></input> 
	<div class="cfgtitle" >				
		
	</div>
    <div class="countList">
		<ul>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
			<li>&nbsp;&nbsp;L1&nbsp;&nbsp;
				<select id="rootItemID" name="rootItemID" style="width:120px;"></select>
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()"/>
			</li>
			
		</ul>
    </div>
	<div id="gridDiv" class="mgB10 clear mgL10 mgR10">
		<div id="gridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>