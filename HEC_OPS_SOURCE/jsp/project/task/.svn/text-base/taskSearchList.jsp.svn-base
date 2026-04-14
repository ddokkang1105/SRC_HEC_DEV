<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>

<script type="text/javascript">
	var p_gridArea
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		var isMainMenu = "${isMainMenu}";
		if(isMainMenu == "mainV3"){
			$("#project").attr('disabled', 'disabled: disabled');
		}else{
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}','getPjtMbrRl','${parentID}','Select'); // getPjtParentIDCSR
		}
		
		fnSelect('itemClass','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getItemClassTaskTP','${itemClassCode}','Select');
		fnSelect('csrList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getCsrOrder','${projectID}','Select');
		fnSelect('curTask','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=TSKTP','getCurTask','${curTask}','Select');
		fnSelect('csrTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getCsrTeam','${csrTeam}','Select');
		
		gridInit();		
		var isSearch = "${isSearch}";
		if(isSearch=="Y"){
			doSearchList();			
		}
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
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setGridData(){ // chnageSetId 옆에 changeType 필드 추가 
		var result = new Object();
		var header = "Master Data,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan";
		var attachHeader1 = "Item,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,Change order,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan";
		var attachHeader2 = "No,Identifier,${menu.LN00028},${menu.LN00016},Path,ProgramID,${CBOType},${menu.LN00131},${menu.LN00191},${menu.LN00153},${menu.LN00004},Revision,${menu.LN00022},${menu.LN00069},${menu.LN00067},${menu.LN00232},itemID";
		var widths = "30,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,0";
		var sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		var aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		var taskNameHeader = "${taskNameHeader}";
		var taskNameCnt = "${taskNameCnt}";
		var taskNameArr = new Array();
		taskNameArr = taskNameHeader.split(",");
	
		for (var i = 0; i < Number(taskNameCnt); i++) { 
			if(i==0){
				header = header + ",Plan,#cspan,#cspan,#cspan";
			}else{
				header = header + ",#cspan,#cspan,#cspan,#cspan";
			}
			attachHeader1 = attachHeader1 + ","+taskNameArr[i]+",#cspan,#cspan,#cspan";
			attachHeader2 = attachHeader2+",${menu.LN00004} ID,${menu.LN00004},${menu.LN00063},${menu.LN00064}";
			
			widths = widths + ",80,80,80,80";
			sorting = sorting + ",str,str,str,str";
			aligns = aligns + ",center,center,center,center";
		} 
	
		for (var i = 0; i < Number(taskNameCnt); i++) {
			if(i==0){header = header + ",Actual,#cspan,#cspan,#cspan";
			}else{
				header = header + ",#cspan,#cspan,#cspan,#cspan";
			}
			attachHeader1 = attachHeader1 + ","+taskNameArr[i]+",#cspan,#cspan,#cspan";
			attachHeader2 = attachHeader2+",${menu.LN00004} ID,${menu.LN00004},${menu.LN00063},${menu.LN00064}";
			widths = widths + ",80,80,80,80";
			sorting = sorting + ",str,str,str,str";
			aligns = aligns + ",center,center,center,center";
		} 
	
		result.title = "";
		result.key = "";
		result.header = header;
		result.attachHeader1 = attachHeader1;
		result.attachHeader2 = attachHeader2;
		
		result.widths = widths;
		result.sorting = sorting;
		result.aligns = aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	
	function fnGetCsrCombo(parentID){
		fnSelect('itemClass','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getItemClassTaskTP','Select');
		fnSelect('csrList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','Select');
		fnSelect('csrTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrTeam','Select');
	}
	
	function fnSearchTaskList(){
		var project = $("#project").val();
		var itemClass = $("#itemClass").val();
		var csrList = $("#csrList").val();
		var csrTeam = $("#csrTeam").val();
		var curTask = $("#curTask").val();
		var isSearch = "Y";
		
		if(project == ""){
			alert("${WM00041_1}"); return;
		}else if(itemClass == ""){ alert("${WM00041_2}"); return;}
		
		var url = "getTaskSearchList.do";
		var data = "project="+project+"&itemClass="+itemClass+"&csrList="+csrList+"&csrTeam="+csrTeam+"&curTask="+curTask+"&isSearch="+isSearch+"&screenMode=${screenMode}";
		var target = "searchTaskDiv";
		ajaxPage(url, data, target);
	}
	
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	
	function fnGoTaskUpdate(){
		var url = "goTaskUpdate.do";
		var target = "taskSearchFrm";
		var data = "";
		ajaxPage(url, data, target);
	}
	
	function gridOnRowSelect(id, ind){
		var itemID = p_gridArea.cells(id, 16).getValue(); 
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);
	}
	
	
</script>
<div id="searchTaskDiv">
<form name="taskSearchFrm" id="taskSearchFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 6px 0 6px 0">
		<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${menu.LN00239}
	</h3>
</div><div style="height:10px"></div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="10%">
		<col width="19%">
		<col width="10%">
		<col width="19%">
		<col width="10%">
		<col width="19%">
		<col width="10%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 -->
       	<th class="viewtop">${menu.LN00131}</th>
        <td class="viewtop"> 
	       	<select id="project" Name="project" onChange="fnGetCsrCombo(this.value)" class="sel" style="width:100px;">
	       		<c:if test="${isMainMenu =='mainV3'}"><!-- mainHomeLayerV3 -->
	       			<option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option>
	       		</c:if>
	       	</select>
       	</td>
       	<!-- 계층 -->
       	<th class="viewtop">${menu.LN00016}</th>
        <td class="viewtop">  <select id="itemClass" Name="itemClass" class="sel" style="width:100px;"></select>
       	</td>
       	<!-- 변경오더 -->
       	<th class="viewtop">${menu.LN00191}</th>
        <td class="viewtop  last alignL"><select id="csrList" Name="csrList" class="sel" style="width:100px;"></select></td>
        <td class="viewtop last alignC" rowspan="2">
			<li class="floatC" style="display:inline">
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onclick="fnSearchTaskList()" style="cursor:pointer;"/>
			</li>
		</td>
	</tr>
    <tr>
    	<!-- 담당조직 -->
        <th>${menu.LN00153}</th>
        <td><select id="csrTeam" Name="csrTeam" class="sel" style="width:100px;"></select></td>
    	<!-- 진행상태 -->
        <th>${menu.LN00069}</th>
        <td class="last alignL" colspan="3"><select id="curTask" name="curTask" class="sel" style="width:100px;"></select></td>
      </tr>
  </table>
 <div class="countList pdT10">
    <li class="count">Total <span id="TOT_CNT">${totalCnt}</span></li>
 	<li class="floatR">
 		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>	
 		<c:if test="${sessionScope.loginInfo.sessionAuthLev <= 1 && isMainMenu ==''}">	
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Update" onclick="fnGoTaskUpdate()"  type="submit"></span>
		</c:if>
		<c:if test="${sessionScope.loginInfo.sessionMlvl == 'SYS' && isMainMenu =='Y'}">	
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Update" onclick="fnGoTaskUpdate()"  type="submit"></span>
		</c:if>
		<c:if test="${isMainMenu =='mainV3'}"><!-- mainHomeLayerV3 -->
			<c:if test="${sessionScope.loginInfo.sessionMlvl == 'SYS' || projectMap.ProjectAuthorID == sessionScope.loginInfo.sessionUserId}">	
				<span class="btn_pack medium icon"><span  class="save"></span><input value="Update" onclick="fnGoTaskUpdate()"  type="submit"></span>
			</c:if>
		</c:if>
	</li>
 </div>
<form name="rptForm" id="rptForm" action="" method="post" > 
<div id="gridIssueDiv" style="width:100%;" class="clear" >
	<div id="grdGridArea" ></div>
</div>
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<!-- END :: PAGING -->	
</form>
</div>
