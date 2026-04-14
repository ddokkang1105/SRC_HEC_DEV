<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};		
		gridInit();		
		doSearchList();
		$("#excel").click(function(){
			doExcel();
		});
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		gridArea = fnNewInitGrid("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setColumnHidden(9, true);
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});						
		gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		result.title = "${title}";
		result.key= "instance_SQL.getProcInstList";
		result.header = "No,${menu.LN00015},${menu.LN00028},${menu.LN01006},${menu.LN01008} ,${menu.LN00027},${menu.LN00063},${menu.LN00064},${menu.LN01005},instanceClass";
		result.cols = "ProcInstNo|ProcInstanceName|OwnerName|OwnerTeamName|StatusNM|StartDate|EndDate|DueDate|instanceClass";
		result.widths = "30,120,*,100,150,100,90,90,90,40";
		result.sorting = "int,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					 + "&instanceName="+$("#searchValue").val()
					 + "&processID=${masterItemID}";
    	return result;
	}
	
	function gridOnRowSelect(id, ind){
		var instanceNo = gridArea.cells(id,1).getValue();
		var instanceClass = gridArea.cells(id, 9).getValue();
	
// 		var url = "plm_ViewProjectCharter.do?instanceNo="+instanceNo+"&instanceClass="+instanceClass;
// 		var w = 1200;
// 		var h = 600;
	
// 		itmInfoPopup(url,w,h);
		var url = "pimElementList.do";
		var data = "&instanceNo="+instanceNo;
		var target = "instanceListDiv";		
		ajaxPage(url, data, target);
	}	
	
	function doExcel() {
		gridArea.toExcel("${root}excelGenerate");
	}
	
	function fnCreateProcInstPop(){	
		var url = "plm_createProjectCharter.do?masterItemID=${masterItemID}";
		var w = 1200;
		var h = 600;
	
		itmInfoPopup(url,w,h);
	}	
	
	function fnSelectModelPop(){
		var url = "plm_createProcInstPop.do?masterItemID=${masterItemID}";
		var w = 550;
		var h = 230;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	
</script>
</head>
<body>
<div id="instanceListDiv">
<form name="plmFrm" id="plmFrm" action="" method="post" onsubmit="return false">
	<div class="child_search mgT15" >
		<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/bullet_blue.png"></img>&nbsp;&nbsp;<b>${menu.LN01002}</b>
	   </li>
	   <li style="padding-left:100px !important;">
	   		<b>${menu.LN01003}</b>&nbsp;&nbsp;
	   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search"  style="cursor:pointer;" />
		  </li>
	   <li class="floatR pdR20">	   		
	    	<span class="btn_pack small icon"><span class="add"></span><input value="Create Process" type="submit" onclick="fnSelectModelPop()" style="cursor:hand;"></span>&nbsp;
	        <span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" onclick="fnCreateProcInstPop()" style="cursor:hand;"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>	
	</div>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width: 98%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
</div>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>