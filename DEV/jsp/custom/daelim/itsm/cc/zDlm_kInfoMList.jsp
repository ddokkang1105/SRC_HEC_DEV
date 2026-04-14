<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	var screenType = "${screenType}";
	var baseURL = "${baseUrl}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var projectCategory = "${projectCategory}";
	var projectID = "${projectID}";
	var projectIDs = "${projectIDs}";
	
	$(document).ready(function(){

		// 초기 표시 화면 크기 조정 
		if(screenType == 'cust' && projectIDs == ''){projectIDs = "0";}
		$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		// project select
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		if(templProjectID != undefined && templProjectID != '') {
			
			data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&myCSR=${myCSR}&notCompanyIDs=${notCompanyIDs}"+"&projectType="+projectType;
		}
		
		fnSelect('project', data, 'getESPCustomerList', projectID, 'Select', 'esm_SQL');
		
		// on Click
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				
				doSearchList();
				return false;
			}
		});	
		
		$('#new').click(function(){ 
			doClickNew();
			return false;
		});	
		
		setTimeout(function() {$('#searchValue').focus();}, 0);		
		setTimeout(function() {doSearchList(); }, 100);
		
	});

	//조회
	function doSearchList(){
		
		if(screenType != 'cust'){
			projectID = $("#project").val();
			if(projectID==null){ projectID="";}
		}
		var category = $("#categoryCode").val(); 
			if(category=='undefined' || category==null){category = "";}
			if(screenType != 'cust'){
			if(projectID == "" && templProjectID != "" && templProjectID != "0") {
				projectID = templProjectID;
			}
		}
			
		if($("#project").val() != "" && $("#project").val() != null && $("#project").val() != undefined){projectType = "PJT";}else{projectType = "PG";}
		
		var sqlID = "zDLM_KINFOM.boardList";
		
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" 
			+ "&userID=${sessionScope.loginInfo.sessionLoginId}"
			+ "&BoardMgtID=${BoardMgtID}"
			+ "&searchKey="    	+ $("#searchKey").val()
			+ "&searchValue="  	+ $("#searchValue").val()
			+ "&projectType="    + projectType
			+ "&projectID="     + projectID
			+ "&category="		+ category
			+ "&baseURL="		+ baseURL
			+ "&replyLev=0"
			+ "&screenType="	+ screenType
			+ "&sqlID="+sqlID; 
		
		$.ajax({
			
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
			fnReloadGrid(result);
			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
		function fnReloadGrid(newGridData){
			grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
			fnMasterChk('');
		}
	
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function listToArray(fullString, separator) {var fullArray = [];if (fullString !== undefined) {if (fullString.indexOf(separator) == -1) {fullArray.push(fullString);} else {fullArray = fullString.split(separator);}}return fullArray;}
	
	function doClickNew(){
		var projectID = $("#project").val();
		if(projectID==undefined){projectID="${projectID}";}
		var category = $("#categoryCode").val();if(category=='undefined' || category==null){ category=""; }
		var categoryIndex = $("#categoryIndex").val();if(categoryIndex=='undefined' || categoryIndex==null){ categoryIndex=""; }
		var categoryCnt = $("#categoryCnt").val();if(categoryCnt=='undefined' || categoryCnt==null){ categoryCnt=""; }
		var url = "zDlm_kInfoMEdit.do";
		var data = "NEW=Y&BoardMgtID=${BoardMgtID}&projectType=${projectType}&url=${boardUrl}&screenType=${screenType}&pageNum="+$("#currPage").val()
					+"&projectID="+templProjectID+"&screenType=${screenType}"
					+"&defBoardMgtID=${defBoardMgtID}&category="+category
					+"&categoryIndex="+categoryIndex
					+"&templProjectID="+templProjectID
					+"&categoryCnt="+categoryCnt;
		var target = "help_content";
		ajaxPage(url, data, target);		
	}
	
	function fnSearchCat(statusCount,cnt,categoryCode){
		var menuName = "bcList";
		$("#categoryCode").val(categoryCode);
		$("#categoryIndex").val(statusCount);
		$("#categoryCnt").val(cnt);
		for(var i=0; i<=cnt; i++){
			if(statusCount==i){
				$("#"+menuName+i).css('color','#0000FF');
				$("#"+menuName+i).css('font-weight','bold');				
			}else{
				$("#"+menuName+i).css('color','#000000');
				$("#"+menuName+i).css('font-weight','');
			}
		}
		doSearchList();
	}
	
	
</script>
<div id="help_content" class="mgL10 mgR10">
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="categoryCode" name="categoryCode" value="${category}">
	<input type="hidden" id="categoryIndex" name="categoryIndex" value="">
	<input type="hidden" id="categoryCnt" name="categoryCnt" value="">
	
	<c:if test="${screenType != 'cust'}">
		<div class="cop_hdtitle">
			<h3 style="padding: 6px 0;"><img src="${root}${HTML_IMG_DIR}/${icon}">&nbsp;지식정보관리</h3>
		</div>
	</c:if>
	
	<!-- BEGIN :: SEARCH -->
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		
	    <tr>
	    	<th class="alignR" >${menu.ZLN0018}</th>
	    	<td class="alignR" ><select id="project" name="project" class="sel"></select></td>
	    	
	    	<th class="alignR">
	    		<select id="searchKey" name="searchKey" class="sel">
					<option value="KnoName">${menu.ZLN0023}</option>
					<option value="UserNm" 
						<c:if test="${searchKey == 'UserNm'}"> selected="selected"</c:if>>
						${menu.LN00212}
					</option>					
				</select>
	    	</th>
	    	
	    	<td class="alignR">
	    		<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}">
	    	</td>
	    	
	    	<td colspan=<c:choose><c:when test="${projectType == 'PG' or screenType == 'Admin'}" >2</c:when><c:otherwise>4</c:otherwise></c:choose> class="alignR">
	    	
	    	<button class="cmm-btn2 searchList" style="height: 30px;" value="Search">Search</button>
	    	
	    </tr>
	</table>
	
	<c:if test="${CategoryYN == 'Y' && brdCatListCnt != '0'}">
		<div class="child_search" style="border-top:0px;">
			<li style="font-weight:bold;">${menu.LN00033}</li>	
			<li>													
			<a href="#" id="bcList0" OnClick="fnSearchCat('0','${brdCatListCnt}','')" class="mgR5">ALL</a>&nbsp;|&nbsp;
			<c:forEach var="bcList" items="${brdCatList}" varStatus="status">				
				<a href="#" id="bcList${status.count}" onclick="fnSearchCat('${status.count}','${brdCatListCnt}','${bcList.CODE}');" class="mgR5">
				${bcList.NAME} 				
				</a><c:if test="${!status.last}" >&nbsp;|&nbsp;</c:if>
			</c:forEach>
			</li>
		</div>
	</c:if>
	<!-- END :: SEARCH -->
	
	<div class="countList pdT10">
       <li  class="count">Total  <span id="TOT_CNT"></span></li>
	       <li class="floatR pdR10">  		     
					<!-- <li class="floatR pdR10"> -->
						<button class="cmm-btn floatR " style="height: 30px;" id="new"  value="Write">Write</button>
			</li>
				
       </li>
    </div>
	<!-- BEGIN :: LIST_GRID -->
	<div id="gridDiv" class="mgB10 clear" style="width:100%;">
		<div id="grdOTGridArea02" style="height:300px; width:100%">
			<div style="width: 100%;" id="layout"></div> <!-- layout 추가한 부분 -->
			<div id="pagination"></div>
		</div>
	</div>
	<!-- END :: LIST_GRID -->
</form>
</div>

<script type="text/javascript">// BEGIN ::: GRID

	var layout = new dhx.Layout("layout", { 
				rows: [
					{
						id: "a",
					},
				]
			});
		
			var gridData = ${gridData};
			var grid = new dhx.Grid("grdOTGridArea02", {
				columns: [
					{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
					{ hidden: true, width: 50, id: "knoId", header: [{ text: "knoId", align: "center" }], align: "center" },
					{ width: 100, id: "orgnztNm", header: [{ text: "${menu.ZLN0018}" , align: "center"}], align: "center"},
					{ fillspace: true, id: "knoNm", header: [{ text: "지식명" , align: "center" }],htmlEnable:true, align: "left" },
					{ width: 100, id: "userNm", header: [{ text: "${menu.LN00212}" , align: "center"}], align: "center"},
					{ width: 100, id: "frstRegistPnttm", header: [{ text: "${menu.LN00078}" , align: "center"}], align: "center"}						
				],
				autoWidth: true,
				resizable: true,
				selection: "row",
				tooltip: false,
				data: gridData
			});
			
			var total = grid.data.getLength();
			layout.getCell("a").attach(grid);
			$("#TOT_CNT").html(grid.data.getLength());

			var pagination = new dhx.Pagination("pagination", {
				data: grid.data,
				pageSize: 20,
			});	

			//그리드ROW선택시
			grid.events.on("cellClick", function(row,column,e){
				if(column.id != "checkbox"){
					gridOnRowSelect(row);
				}
			}); 

			function gridOnRowSelect(row){		//그리드ROW선택시
				
				var knoId = row.knoId
				var boardMgtID = row.BoardMgtID;
				var boardID = row.BoardID;
				var currPage = $("#currPage").val();
				var projectID = $("#project").val();
				var category = $("#categoryCode").val();if(category=='undefined' || category==null){ category=""; }
				var categoryIndex = $("#categoryIndex").val();if(categoryIndex=='undefined' || categoryIndex==null){ categoryIndex=""; }
				var categoryCnt = $("#categoryCnt").val();if(categoryCnt=='undefined' || categoryCnt==null){ categoryCnt=""; }
				var projectCategory = $("#project").val();
				if(projectID == null || projectID == undefined){projectID="";} 
				
 				var back = "&scStartDt="     + $("#SC_STR_DT").val()
							+ "&searchKey="    	+ $("#searchKey").val()
							+ "&searchValue="  	+ $("#searchValue").val()			        
							+ "&scEndDt="     	+ $("#SC_END_DT").val()
							+ "&projectCategory=" + projectCategory
 							+ "&searchOrg=" + projectID;
							
			
				var url = "/zDlm_kInfoMDetail.do"; 
				var data = "NEW=N&BoardID="+encodeURIComponent(boardID)+"&BoardMgtID="+encodeURIComponent(boardMgtID)
							+"&url="+encodeURIComponent("${boardUrl}")
							+"&screenType="+encodeURIComponent("${screenType}")
							+"&projectID="+encodeURIComponent("${projectID}")
							+"&category="+encodeURIComponent(category)
							+"&categoryIndex="+encodeURIComponent(categoryIndex)
							+back
							+"&categoryCnt="+categoryCnt
							+"&projectIDs="+encodeURIComponent(projectIDs)
							+"&knoId="+knoId;
				
					
				var target = "help_content";
				ajaxPage(url, data, target);
				
			} 
			

</script>
