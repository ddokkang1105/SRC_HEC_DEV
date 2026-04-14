<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<c:if test="${defBoardMgtID != ''}">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
</c:if>
<script>
	var p_gridArea;	
	var screenType = "${screenType}";
	var baseURL = "${baseUrl}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea02").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea02").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var projectID = "${projectID}";

		if(templProjectID != undefined && templProjectID != '') {
			data = data + "&templProjectID="+templProjectID+"&projectType="+projectType;
		}
		
		fnSelect('project', data, 'getProject', templProjectID, 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList("Y");
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
			setTimeout(function() {gridInit();fnSearchCat("${categoryIndex}","${categoryCnt}","${category}");}, 100);		
		}else{ setTimeout(function() {gridInit();doSearchList(); }, 100);}
		
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
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea02", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		//p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(6, true);				
		p_gridArea.setColumnHidden(7, true);	
		p_gridArea.setColumnHidden(9, true);	
		fnSetColType(p_gridArea, 8, "img");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridData(byBtn) {
		var projectID = $("#project").val(); 
		if(projectID==null){ projectID="";}
		var category = $("#categoryCode").val(); if(category=='undefined' || category==null){category = "";}
		var result = new Object();
		result.title = "${title}";
		result.key = "board_SQL.boardList";
		result.header = "${menu.LN00024},${menu.LN00002},${menu.LN00131},${menu.LN00212},${menu.LN00070},${menu.LN00030},BoardMgtID,BoardID,${menu.LN00068},ActiveNotice";
		result.cols = "Subject|ProjectName|WriteUserNM|ModDT2|ReadCNT|BoardMgtID|BoardID|IsNew|ActiveNotice";
		result.widths = "50,*,150,150,140,40,0,0,50,50";
		result.sorting = "str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,center,center,center,center,center,center,center,center";
		if(projectID == "" && templProjectID != "" && templProjectID != "0") {
			projectID = templProjectID;
		}
		if(byBtn == "Y"){projectType = "PJT";}
		result.data = "BoardMgtID=${BoardMgtID}"		
			        + "&scStartDt="     + $("#SC_STR_DT").val()
			        + "&searchKey="    	+ $("#searchKey").val()
			        + "&searchValue="  	+ $("#searchValue").val()			        
			        + "&scEndDt="     	+ $("#SC_END_DT").val()
        			+ "&projectID="     + projectID
					+ "&pageNum="     	+ $("#currPage").val()	
					+ "&baseURL="		+ baseURL
					+ "&replyLev=0";
		
		
		if(category != ''){
			result.data = result.data +"&category="+category;
		}
		if(projectType != undefined && projectType != '') {
			result.data = result.data + "&projectType="+projectType;
		}

		return result;
	}

	function gridOnRowSelect(id, ind){
		var boardMgtID = p_gridArea.cells(id, 6).getValue();
		var boardID = p_gridArea.cells(id, 7).getValue();
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
	
	function doSearchList(byBtn){
		var d = setGridData(byBtn);		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,"","","","","fnSetRow(10000)");
	}
	// cnt fmf grid list total count로 수정 필요
  function fnSetRow(cnt){
		var rowId = 1; 
		var activeNotice = 1 ;
		for(var i=0; i<cnt; i++){			
			activeNotice = p_gridArea.cells(rowId, 9).getValue();
			if(activeNotice == 1){
				p_gridArea.setRowColor(rowId,"#f0f3f6");		
		    } else if(activeNotice == null){return;}
			rowId++;		
		}
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
	
	function fnGetAll(cnt){ // 카테고리 ALL
		var menuName = "bcList";
		$("#categoryCode").val("");
		$("#categoryIndex").val("");
		for(var i=0; i<=cnt; i++){
			if(i==0){
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
				<font> <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
				~
				<font> <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
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
	    	<td colspan=<c:choose><c:when test="${projectType == 'PG' or screenType == 'Admin'}" >2</c:when><c:otherwise>4</c:otherwise></c:choose> class="alignR"><input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" /></td>
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
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Write" type="submit" id="new"></span>&nbsp;&nbsp;
			</li>
			</c:if>
       </li>
    </div>
	<!-- BIGIN :: LIST_GRID -->
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea02" style="height:300px; width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</form>
<%-- <c:if test="${defBoardMgtID != '' }" > --%>
</div>
<%-- </c:if> --%>
