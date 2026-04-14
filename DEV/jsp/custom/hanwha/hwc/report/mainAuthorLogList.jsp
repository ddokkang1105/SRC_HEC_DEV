<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	
	var AL_gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
		
		$("#excel").click(function(){AL_gridArea.toExcel("${root}excelGenerate");});
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		
		$("#statusCode").val("${StatusCode}");
		$("#changeTypeCode").val("${ChangetypeCode}");
		$("#actionTypeCode").val("${ActionTypeCode}");
		
		gridOTInit();
		doSearchList();
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		AL_gridArea = fnNewInitGrid("grdGridArea", d);
		AL_gridArea.setImagePath("${root}${HTML_IMG_0DIR}/");//path to images required by grid
		//fnSetColType(AL_gridArea, 1, "ch");
		
		AL_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});
		
		AL_gridArea.setColumnHidden(6,true);
		//START - PAGING
		/*AL_gridArea.enablePaging(true,20,20,"pagingArea",true,"recInfoArea");
		AL_gridArea.setPagingSkin("bricks");
		AL_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});*/
		//END - PAGING
	}

	function setOTGridData() {
	 	var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.itemAuthorLogList";
		result.header = "No,담당자,사규/프로세스명,Current 조직,Prev 조직,상태,";
		result.cols = "Name|ItemName|CurTeamName|PrevTeamName|Status|ItemID";
		//result.widths = "50,50,120,120,100,100,100,100,130,130,100,100,100,0,0";
		result.widths = "30,70,250,150,150,70,0";
		result.sorting = "str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "&languageID=${languageID}"
			        	+"&changeType=02&status=01" 
						+"&isMain=Y" ;
		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind) {
		
		var itemID = AL_gridArea.cells(id, 6).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);	
			
	}
	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(AL_gridArea, d.key, d.cols, d.data);
	}


</script>

</head>
<body>
<div id="itemAuthorList">     
	<div id="gridOTDiv" class="mgB10 clear">
		<!-- <span style="float:right" onClick="javascript:fnClickMoreAuthorLogList();"><img src="${root}${HTML_IMG_DIR}/more.png"></span>  -->
		<div id="grdGridArea" style="width: 100%"></div>
	</div>	
</div>	
</body>
</html>
