<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>

<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() - 290)+"px;");
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
		
		//gridInit();		
		var isSearch = "${isSearch}";
		//if(isSearch=="Y"){
			//doSearchList();			
		//}
		
		fnInitGridConfig();
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
	// DHTMLX V7.1.8 START
	
	var grid = ""; var pagination = "";
	var gridConfig;
	
	function fnInitGridConfig(){		
		gridConfig = {
				columns: [
			    	{ width: 50, id: "RNUM", align:"center" ,header: [{ text: "Master Data", colspan: 16, align:"center"}
			    						  ,{ text: "Item" ,colspan: 7, align:"center"}
			    						  ,{ text: "No", align:"center"}	    										
			    						  ]},
			    											
					{ width: 90, id: "Identifier",      header: ["","", { text: "ID", align:"center"} ], align:"center"},
					{ width: 160, id: "ItemName",       header: ["","", { text: "${menu.LN00028}", align:"center"} ], align:"center"},
					{ width: 80, id: "ItemClassName",   header: ["","", { text: "${menu.LN00016}", align:"center"}], align:"center"},
					{ width: 180, id: "Path",           header: ["","", { text: "${menu.LN00043}", align:"center"}]},
					{ width: 140, id: "TCode",          header: ["","", { text: "ProgramID", align:"center"}], align:"center"},
					{ width: 120, id: "CBOType",        header: ["","", { text: "CBO Type", align:"center"}], align:"center"},
			    											
			    	{ width: 150, id: "ProjectName", header: ["",{ text: "ChangeOrder", colspan: 9, align:"center"}
			    										, { text: "Project", align:"center"}]},
			    										
			    										{ width: 120, id: "Csr",            header: ["","", { text: "${menu.LN00191}", align:"center"}] , align:"center"},
			    										{ width: 120, id: "AuthorTeamName", header: ["","", { text: "${menu.LN00153}", align:"center"}], align:"center"},
			    										{ width: 120, id: "AuthorName",     header: ["","", { text: "${menu.LN00004}", align:"center"}], align:"center"},
			    										{ width: 80, id: "ChangeSetID",     header: ["","", { text: "Revision", align:"center"}], align:"center"},	    										
			    										{ width: 80, id: "ChangeType",      header: ["","", { text: "${menu.LN00022}", align:"center"}], align:"center"},
			    										{ width: 80, id: "CurrTaskName",    header: ["","", { text: "${menu.LN00069}", align:"center"} ], align:"center"},
			    										{ width: 80, id: "PriorityName",    header: ["","", { text: "${menu.LN00067}", align:"center"}], align:"center"},
			    										{ width: 80, id: "DifficultyName",  header: ["","", { text: "${menu.LN00232}", align:"center"}], align:"center"} 
			    										
			    										<c:if test="${taskNameList.size()> 0 }">
			    											${taskNameHeader}
			    							    		</c:if>
			    	
			    							    		/* <c:if test="${taskNameList.size()> 0 }">
			    							    		
			    							    		
							,{ width: 120, id: 'P_TS001_LoginID', header: [{ text: 'Plan', align:'center' ,colspan: 16 }
																			,{ text: '기능설계(TS001)',  align:'center', colspan:4}
																			,{ text: '담당자 ID', align:'center'}]}

			    										,{ width: 120, id: 'P_TS001_ActorName', header: ['','', { text: '담당자', align:'center'}]}
			    										,{ width: 120, id: 'P_TS001_StartDate', header: ['','', { text: '시행일', align:'center'}]}
			    										,{ width: 120, id: 'P_TS001_EndDate',   header: ['','', { text: '완료일', align:'center'}]}
			    										
			    										,{ width: 120, id: 'P_TS002_LoginID', header: ['', { text: "기술설계(TS002)", align:"center", colspan: 4}
			    										,{  text: '담당자 ID', align:'center'}]}
														,{ width: 120, id: 'P_TS002_ActorName', header: ['','', { text: '담당자', align:'center'}]}
														,{ width: 120, id: 'P_TS002_StartDate', header: ['','', { text: '시행일', align:'center'}]}
														,{ width: 120, id: 'P_TS002_EndDate',   header: ['','', { text: '완료일', align:'center'}]}
														
														,{ width: 120, id: 'P_TS003_LoginID', header: ['', { text: "코딩(TS003)", align:"center", colspan: 4}
			    										,{  text: '담당자 ID', align:'center'}]}
														,{ width: 120, id: 'P_TS003_ActorName', header: ['','', { text: '담당자', align:'center'}], align:'center'}
														,{ width: 120, id: 'P_TS003_StartDate', header: ['','', { text: '시행일', align:'center'}], align:'center'}
														,{ width: 120, id: 'P_TS003_EndDate',   header: ['','', { text: '완료일', align:'center'}], align:'center'}
														
														,{ width: 120, id: 'P_TS004_LoginID', header: ['', { text: "테스트(TS004)", align:"center", colspan: 4}
			    										,{  text: '담당자 ID', align:'center'}]}
														,{ width: 120, id: 'P_TS004_ActorName', header: ['','', { text: '담당자', align:'center'}]}
														,{ width: 120, id: 'P_TS004_StartDate', header: ['','', { text: '시행일', align:'center'}]}
														,{ width: 120, id: 'P_TS004_EndDate',   header: ['','', { text: '완료일', align:'center'}]}
 							
			    										
			    										</c:if> 
 */
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false
		}
		
		doSearchList();	 
	}

	function doSearchList(){		
		var totalCnt = ${totalCnt};
		var target = "grid_container";
		
		if (grid) { grid.destructor();}
		grid = new dhx.Grid(target, gridConfig);
		$('#TOT_CNT').html(totalCnt);
				
		if(totalCnt > 0){	 
    		grid.data.parse(${csrTaskList});	        
		}
			  
		if(pagination){pagination.destructor();}
		pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	}
	
	// DHTMLX V7.1.8 END
	//===============================================================================
	
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
		var data = "project="+project
					+"&itemClass="+itemClass
					+"&csrList="+csrList
					+"&csrTeam="+csrTeam
					+"&curTask="+curTask
					+"&isSearch="+isSearch
					+"&screenMode=${screenMode}"
					+"&isMainMenu=${isMainMenu}"; 
		var target = "searchTaskDiv";
		ajaxPage(url, data, target);
	}
	
	function doExcel() {		
		//p_gridArea.toExcel("${root}excelGenerate");
		grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
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
<div class="cop_hdtitle mgB10" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 6px 0 6px 0">
		<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${menu.LN00239}
	</h3>
</div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="10%">
		<col width="20%">
		<col width="10%">
		<col width="20%">
		<col width="10%">
		<col width="20%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 -->
       	<th class="alignL">${menu.LN00131}</th>
        <td class="alignL"> 
	       	<select id="project" Name="project" onChange="fnGetCsrCombo(this.value)" class="sel" style="width:180px;">
	       		<c:if test="${isMainMenu =='mainV3'}"><!-- mainHomeLayerV3 -->
	       			<option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option>
	       		</c:if>
	       	</select>
       	</td>
       	<!-- 계층 -->
       	<th class="alignL">${menu.LN00016}</th>
        <td class="alignL"> <select id="itemClass" Name="itemClass" class="sel" style="width:180px;"></select></td>
       	<!-- 변경오더 -->
       	<th class="alignL">${menu.LN00191}</th>
        <td class="alignL"><select id="csrList" Name="csrList" class="sel" style="width:180px;"></select></td>
	</tr>
    <tr>
    	<!-- 담당조직 -->
        <th class="alignL">${menu.LN00153}</th>
        <td class="alignL"><select id="csrTeam" Name="csrTeam" class="sel" style="width:180px;"></select></td>
    	<!-- 진행상태 -->
        <th class="alignL">${menu.LN00069}</th>
        <td class="alignL"><select id="curTask" name="curTask" class="sel" style="width:180px;"></select></td>
        <th class="alignL" colspan=2>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onclick="fnSearchTaskList()" style="cursor:pointer;"/>
		</th>
      </tr>
  </table>
 <div class="countList">
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
<div id="gridDiv" style="width:100%;" class="clear" >
	<div id="grid_container" style="height: 400px; width: 100%"></div>
	<div id="pagination" style="padding: 0 10px;"  ></div>
</div>
</form>
</div>
