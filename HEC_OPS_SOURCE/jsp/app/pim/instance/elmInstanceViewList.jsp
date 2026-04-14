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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00004}"/>
<!-- 2. Script -->
<script type="text/javascript">

	var gridArea;				
	var skin = "dhx_skyblue";
	var objIds = new Array;
	var elmInstNos = new Array;
	var elmItemIDs = new Array;
	var procInstNos= new Array;
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};
		
		
		var timer = setTimeout(function() {
			$("input.datePicker").each(generateDatePicker);
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
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		/*
		gridArea.setColumnHidden(4, true);
		fnSetColType(gridArea, 1, "ch");
		*/
		gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "instance_SQL.getElmInstList";
		result.header = "${menu.LN00024},ProcInstNo,ElmItemID,projectCode,ElmInstNo,${menu.LN00028},${menu.LN00119},${menu.LN00004},${menu.LN00104},${menu.LN00061},${menu.LN00062},${menu.LN00064},${menu.LN00070},";
		result.cols = "ProcInstNo|ElmItemID|projectCode|ElmInstNo|elmItemName|roleName|actorName|actorTeamName|startTime|DueDate|endTime|LastUpdated|infoBtn";
		result.widths = "30,0,0,0,0,150,100,110,100,180,180,130,130,130,130";
		result.types = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str";		
		result.aligns = "center,center,left,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "instanceNo=${instanceNo}"
            + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	//조회
	function doSearchList(){
		//gridArea.loadXML("${root}" + "${xmlFilName}");
		var d = setGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	
	}
	
	function fnElmInstanceEidtList(procInstNo, elmInstNo, elmItemID,idx){
		var url = "editElmInstanceList.do";
		var target = "cfgFrame";
		var parameter = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&instanceNo=${instanceNo}"
			+ "&processID=${nodeID}";
		ajaxPage(url, parameter, target);
	}
	
	function fnPimElementInfo(procInstNo,elmInstNo){
		var url = "elmInstDetail.do?";
		var data = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&instanceClass=STEP&masterItemID=${nodeID}"; 
	    var w = "1000";
		var h = "650";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	

	}
	
</script>
<body>
<div id="">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Activity List</li>
		</ul>
	</div>
    <div class="countList">
		<ul>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
		    <li class="floatR mgR20">
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnElmInstanceEidtList();"></span>
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