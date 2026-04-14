<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<c:if test="${defBoardMgtID != ''}">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
</c:if>

<script>
	// var p_gridArea;	
	var screenType = "${screenType}";
	var baseURL = "${baseUrl}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var projectID = "${projectID}";

		if(templProjectID != undefined && templProjectID != '') {
			data = data + "&templProjectID="+templProjectID+"&projectType="+projectType;
		}
		
		fnSelect('project', data, 'getProject', templProjectID, 'Select');
		
		$("input.datePicker").each(generateDatePicker);
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
		var category = "${category}";
		if(category != "" ){
			setTimeout(function() {fnSearchCat("${categoryIndex}","${categoryCnt}","${category}");}, 100);		
		}else{ setTimeout(function() {doSearchList(); }, 100);}
		
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
	
	
	function doSearchList(byBtn){
		var category = $("#categoryCode").val(); if(category=='undefined' || category==null){category = "";}
		var projectID = $("#project").val(); 
		if($("#project").val() != "" && $("#project").val() != null && $("#project").val() != undefined){projectType = "PJT";}else{projectType = "PG";}
		if(projectID==null){ projectID="";}
		if(projectID == "" && templProjectID != "" && templProjectID != "0") {
			projectID = templProjectID;
		}
		if(byBtn == "Y"){projectType = "PJT";}
	
		if(projectType != undefined && projectType != '') {
			"&projectType="+projectType;
		}
		if("${srID}" == null || "${srID}" == ''){
        	"&scStartDt="     + $("#SC_STR_DT").val()  + "&scEndDt="+ $("#SC_END_DT").val();
        }

		var sqlID = "board_SQL.boardList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" 
					+ "&BoardMgtID=${BoardMgtID}"		
			        + "&scStartDt="     + $("#SC_STR_DT").val()
			        + "&searchKey="    	+ $("#searchKey").val()
			        + "&searchValue="  	+ $("#searchValue").val()			        
			        + "&scEndDt="     	+ $("#SC_END_DT").val()
					+ "&projectType="     + projectType
        			+ "&projectID="     + projectID
					+ "&category="     + category
					+ "&pageNum="     	+ $("#currPage").val()	
					+ "&baseURL="		+ baseURL
					+ "&replyLev=0"
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
	
	
	function doClickNew(){
		var projectID = $("#project").val();
		if(projectID==undefined){projectID="${projectID}";}
		var category = $("#categoryCode").val();if(category=='undefined' || category==null){ category=""; }
		var categoryIndex = $("#categoryIndex").val();if(categoryIndex=='undefined' || categoryIndex==null){ categoryIndex=""; }
		var categoryCnt = $("#categoryCnt").val();if(categoryCnt=='undefined' || categoryCnt==null){ categoryCnt=""; }
		var url = "mboardEdit.do";
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
		
		doSearchList();
	}
	
	function fnGetAll(cnt){ // 카테고리 ALL
		var menuName = "bcList";
		$("#categoryCode").val("");
		$("#categoryIndex").val("");
		
		doSearchList();
	}
	
</script>
<%-- <c:if test="${defBoardMgtID != '' }" > --%>
<div id="help_content" class="mgL10 mgR10">
<%-- </c:if> --%>
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="categoryCode" name="categoryCode" value="${category}">
	<input type="hidden" id="categoryIndex" name="categoryIndex" value="">
	<input type="hidden" id="categoryCnt" name="categoryCnt" value="">
	<div class="cop_hdtitle">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/${icon}">&nbsp;&nbsp;${boardMgtName}</h3>
	</div>
	
	<!-- BEGIN :: SEARCH -->
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
	    </colgroup>
	    <tr>
	    	<th class="alignL" <c:if test="${projectType ne 'PG' && screenType ne 'Admin'}" >style="display:none;"</c:if>>${menu.LN00131}</th>
	    	<td class="alignL" <c:if test="${projectType ne 'PG' && screenType ne 'Admin'}" >style="display:none;"</c:if>><select id="project" name="project" class="sel"></select></td>
	    	<th class="alignL">${menu.LN00070}</th>
	    	<td class="alignL">
				<c:if test="${scStartDt != '' and scEndDt != ''}">
					<fmt:parseDate value="${scStartDt}" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<fmt:parseDate value="${scEndDt}" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="${beforeYmd}" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<fmt:formatDate value="${thisYmd}" pattern="yyyy-MM-dd" var="thisYmd"/>
				</c:if>
				<c:if test="${scStartDt == '' or scEndDt == ''}">
					<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
				</c:if>
				 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				~
				 <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	    	</td>
	    	<th class="alignL">
	    		<select id="searchKey" name="searchKey" class="sel">
					<option value="Name">${menu.LN00002}</option>
					<option value="Info" 
						<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
						${menu.LN00003}
					</option>					
				</select>
	    	</th>
	    	<td class="alignL"><input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}"></td>
	    	<td colspan=<c:choose><c:when test="${projectType == 'PG' or screenType == 'Admin'}" >2</c:when><c:otherwise>4</c:otherwise></c:choose> class="alignR">
	    	<button class="cmm-btn2 searchList" style="height: 30px;" value="Search">Search</button>
	    	</td>
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
	<div class="countList">
       <li  class="count">Total  <span id="TOT_CNT"></span></li>
       <li class="floatR">
	       	<c:if test="${(mgtInfoMap.MgtOnlyYN eq 'Y' and mgtInfoMap.MgtUserID eq sessionScope.loginInfo.sessionUserId) or
			              (mgtInfoMap.MgtOnlyYN ne 'Y' and mgtInfoMap.MgtGRID eq mgtInfoMap.MgtGRID2) or
			              (mgtInfoMap.MgtOnlyYN ne 'Y' and mgtInfoMap.MgtGRID < 1 and sessionScope.loginInfo.sessionAuthLev <= 2) }">
			<li class="floatR pdR20">
				<button class="cmm-btn floatR " style="height: 30px;" id="new" value="Write">Write</button>
			</li>
			</c:if>
       </li>
    </div>
	<!-- BIGIN :: LIST_GRID -->
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdOTGridArea02" style="height:300px; width:100%">
			<div style="width: 100%;" id="layout"></div> <!--layout 추가한 부분-->
			<div id="pagination"></div>
		</div>
	</div>
	<!-- END :: LIST_GRID -->
</form>
<%-- <c:if test="${defBoardMgtID != '' }" > --%>
</div>
<%-- </c:if> --%>


<script type="text/javascript">// BEGIN ::: GRID

	var layout = new dhx.Layout("layout", { 
				rows: [
					{
						id: "a",
					},
				]
			});
		
		var gridData = ${gridData};
		var grid = new dhx.Grid("layout", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ fillspace: true, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
				{ width: 150, id: "ProjectName", header: [{ text: "${menu.LN00131}", align: "center" }], align: "center" },
				{ width: 150, id: "WriteUserNM", header: [{ text: "${menu.LN00212}", align: "center" }], align: "center" },
				{ width: 140, id: "ModDT2", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
				{ width: 40, id: "ReadCNT", header: [{ text: "${menu.LN00030}", align: "center" }], align: "center" },
				{ hidden: true, width: 0, id: "BoardMgtID", header: [{ text: "BoardMgtID", align: "center" }], align: "center" },
				{ hidden: true, width: 0, id: "BoardID", header: [{ text: "BoardID", align: "center" }], align: "center" },
				{ width: 50, id: "IsNew", header: [{ text: "${menu.LN00068}" , align: "center"}],htmlEnable:true, align: "center",
					template:function (text,row,col){
						return  '<img src="${root}${HTML_IMG_DIR}/'+row.IsNew+'" width="13" height="13">';
					}	
				},
				{ hidden: true, width: 50, id: "ActiveNotice", header: [{ text: "ActiveNotice" }], align: "center" }			
				],
				autoWidth: true,
				resizable: true,
				selection: "row",
				tooltip: false,
				data: gridData
			});

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

			function gridOnRowSelect(row){
				var boardMgtID = row.BoardMgtID;
				var boardID = row.BoardID;
				var currPage = $("#currPage").val();
				var projectID = $("#project").val();
				var category = $("#categoryCode").val();if(category=='undefined' || category==null){ category=""; }
				var categoryIndex = $("#categoryIndex").val();if(categoryIndex=='undefined' || categoryIndex==null){ categoryIndex=""; }
				var categoryCnt = $("#categoryCnt").val();if(categoryCnt=='undefined' || categoryCnt==null){ categoryCnt=""; }
				if(projectID == null || projectID == undefined){projectID="";}
				var back = "&scStartDt="     + $("#SC_STR_DT").val()
							+ "&searchKey="    	+ $("#searchKey").val()
							+ "&searchValue="  	+ $("#searchValue").val()			        
							+ "&scEndDt="     	+ $("#SC_END_DT").val();
				
				if(screenType != "Admin"){
					var url = "mboardDetail.do"; 
					var data = "NEW=N&BoardID="+boardID+"&BoardMgtID="+boardMgtID
								+"&BoardMgtID=${BoardMgtID}&url=${boardUrl}"
								+"&screenType=${screenType}&pageNum="+$("#currPage").val()
								+"&projectID=${projectID}&category="+category
								+"&categoryIndex="+categoryIndex
								+back
								+"&categoryCnt="+categoryCnt;
								
					var target = "help_content";
					ajaxPage(url, data, target);
				}else{
					$("#BoardMgtID").val(boardMgtID);
					$("#BoardID").val(boardID);
					var url = "mboardDetail.do"; 
					var data = "NEW=N&BoardID="+boardID+"&BoardMgtID="+boardMgtID
								+"&BoardMgtID=${BoardMgtID}"
								+"&screenType=${screenType}&pageNum="+$("#currPage").val()
								+"&projectID=${projectID}&category="+category
								+"&categoryIndex="+categoryIndex
								+back
								+"&categoryCnt="+categoryCnt;
					var target = "help_content";
					ajaxPage(url, data, target);
				}	
	}

</script>