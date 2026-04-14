<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script>
	var p_gridArea;	
	$(document).ready(function(){		
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
		gridInit();	
		doSearchList();
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(6, true);				
		p_gridArea.setColumnHidden(7, true);				
		fnSetColType(p_gridArea, 8, "img");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "board_SQL.boardList";
		result.header = "${menu.LN00024},선택,${menu.LN00002},${menu.LN00004},${menu.LN00030},${menu.LN00013},BoardMgtID,BoardID,${menu.LN00050}";
		result.cols = "CHK|Subject|WriteUserNM|ReadCNT|RegDT|BoardMgtID|BoardID|IsNew";
		result.widths = "50,0,*,150,100,125,0,0,50";
		result.sorting = "str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,right,center,center,center,center";
		result.data = "noticType="		+ $('#noticType').val()
			        + "&scStartDt="     + $("#SC_STR_DT").val()
			        + "&searchKey="    	+ $("#searchKey").val()
			        + "&searchValue="  	+ $("#searchValue").val()			        
			        + "&scEndDt="     	+ $("#SC_END_DT").val()
        			+ "&pageNum="     	+ $("#currPage").val();
		return result;
	}
	function gridOnRowSelect(id, ind){
		$("#BoardMgtID").val(p_gridArea.cells(id, 6).getValue());
		$("#BoardID").val(p_gridArea.cells(id, 7).getValue());
		goDetail("N",p_gridArea.cells(id, 6).getValue(), p_gridArea.cells(id, 7).getValue());
	}
	// END ::: GRID	
	//===============================================================================
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	function doClickNew(){
		goDetail("Y", "", "");	
	}
</script>
<form name="boardForm" id="boardForm" action="" method="post" >
		<!--lst_mgtId:<input type="text" id="BoardMgtID" name="BoardMgtID" value="">
		lst_id:<input type="text" id="BoardID" name="BoardID" value="">-->
		<!--<input type="text" id="noticType" name="noticType" value="${noticType}"> -->
		<input type="hidden" id="NEW" name="NEW" value="">
		<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
		<input type="hidden" id="page" name="page" value="${page}">

		<!-- BEGIN :: SEARCH -->
		<div class="child_search">
				<li class="pdL55">
					${menu.LN00013}
					<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<font> <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
					~
					<font> <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
				</li>
				<li>
					<select id="searchKey" name="searchKey" style="width:150px;">
						<option value="Name">${menu.LN00002}</option>
						<option value="Info" 
							<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
							${menu.LN00003}
						</option>					
					</select>
				</li>
				<li>
					<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;ime-mode:active;">
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
				</li>
				<c:if test="${sessionScope.loginInfo.sessionAuthLev < 3}">
				<li class="floatR pdR20">
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Write" type="submit" id="new"></span>&nbsp;&nbsp;
				</li>
				</c:if>
		</div>
		<!-- END :: SEARCH -->
		 <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
		<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="height:300px; width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->
		<!-- START :: PAGING -->
			<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
		<!-- END :: PAGING -->	
</form>