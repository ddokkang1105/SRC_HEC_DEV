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
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_skins.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var dp;
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
		
		$("#new").click(function(){
			fnCreateProcInstPop();
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
		gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.setColumnHidden(8, true);
		gridArea.setColumnHidden(9, true);
		
		var combobox = gridArea.getCombo(5);
		<c:forEach var="list" items="${instanceStatusList}" varStatus="status">
			combobox.put("${list.CODE}","${list.NAME}");
		</c:forEach>
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		dp = new dataProcessor("saveGridData.do"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.init(gridArea); // link dataprocessor to the grid  
		dp.attachEvent("onAfterUpdate", function(){});
	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		gridInit(); doSearchList();
	}
		
	function setGridData(){
		var result 	= new Object();
		result.title = "${title}";
		result.key= "instance_SQL.getProcInstList"; 
		result.header = "No,ProcInstNo,ProcInstanceName,StartDate,EndDate,상태,Owner,Chk,OwnerID,OwnerTeamIDP,ProcessID,";
		result.cols = "ProcInstNo|ProcInstanceName|StartDate|EndDate|Status|OwnerName|CHK|OwnerID|OwnerTeamID|ProcessID|NULL";
		result.widths = "40,150,220,100,80,80,80,40,80,80,80,*";
		result.types = "ro,ro,ed,ed,ed,coro,ro,ch,ro,ro,ro,ro";
		result.sorting = "int,str,str,date,date,str,str,str,str,str,str,str";		
		result.aligns = "center,center,left,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
    	return result;
	} 
	var clickedId;
	function gridOnRowSelect(id, ind){
		clickedId = id;
		if(ind == "6"){
			searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL');
		}
	}	
	
	function searchPopupWf(avg){
		var url = avg + "&searchValue=" 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4){
		gridArea.cells(clickedId,6).setValue(avg2);
		gridArea.cells(clickedId,8).setValue(avg1);
		gridArea.cells(clickedId,9).setValue(avg4);
		dp.setUpdated(clickedId,true,"updated");
	}
	
	function doExcel() {
		gridArea.toExcel("${root}excelGenerate");
	}
	function fnSaveGridData(){
		dp.sendData(); 
	}
	
	function fnSearchPopupWf(){
		searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL');
	}
	
</script>
</head>
<body>
<div id="instanceListDiv" class="pdR10 pdL10">
<form name="plmFrm" id="plmFrm" action="" method="post" onsubmit="return false">
	<div class="child_search mgT15" >
		<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/bullet_blue.png"></img>&nbsp;&nbsp;<b>Save Grid Data </b>
	   </li>
	  <%--  <li style="padding-left:100px !important;">
	   		<b>${menu.LN01003}</b>&nbsp;&nbsp;
	   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search"  style="cursor:pointer;" />
		  </li> --%>
	   <li class="floatR pdR20">	   		
	        <span class="btn_pack small icon"><span class="edit"></span><input value="Save" type="submit" id="edit" onClick="fnSaveGridData()" style="cursor:hand;"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>	
	</div>
	<div class="countList mgT10">
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