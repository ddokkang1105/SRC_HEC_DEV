<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(document).ready(function(){
		
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchClassList();
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchClassList();
				return false;
			}
		});		
		
		gridClassInit();
		doSearchClassList(false);
	});
	function gridClassInit(){
		var d = setGridClassData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		//p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnClassRowSelect(id,ind);});
	}
	function setGridClassData(){ 
		var result = new Object();
		result.title = "${title}";
		result.key = "boardProject_SQL.getBoardProjectList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00028},${menu.LN00003},${menu.LN00004},${menu.LN00013},${menu.LN00027},,";
		result.cols = "CHK|ProjectName|Description|CreatorName|CreationTime|StatusName|ProjectID|ChildCount";
		result.widths = "30,50,100,*,70,70,50,0,0";
		result.sorting = "int,int,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,center,center,center,center,center";
		result.data = "filter=${filter}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&scStartDt="     + $("#SC_STR_DT").val()
				    + "&searchKey="    	+ $("#searchKey").val()
				    + "&searchValue="  	+ $("#searchValue").val()			        
				    + "&scEndDt="     	+ $("#SC_END_DT").val();
		return result;
	}
	function gridOnClassRowSelect(id, ind){
		if(ind == '1'){/*alert(ind+"번째 셀 클릭");*/
//		}else if(ind == '4'){/*alert(ind+"번째 셀 클릭");*/
		}else{
			goInfoView(p_gridArea.cells(id,7).getValue());
		}
	}
	function doSearchClassList(avg){
		var d = setGridClassData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false);
		this.setPagingHTML($("#totalPage").val(), $("#page").val());
	}

</script>
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="saveType" name="saveType" value="New">		
		<input type="hidden" id="AuthorID" name="AuthorID">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode">
		
		<!-- BEGIN :: SEARCH -->
		<div class="child_search">
			<ul>
				<li>
					<font color="#fe7f14"></font>&nbsp;${menu.LN00013}
						<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
						<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
					 
						<input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					~
					 
						<input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
				<select id="searchKey" name="searchKey" style="width:150px;">
					<option value="Name">${menu.LN00028}</option>
					<option value="Info" 
						<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
						${menu.LN00003}
					</option>					
				</select>
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="검색" />
				</li>
			</ul>
		</div>
		<!-- END :: SEARCH -->
		<div id="gridDiv" >
			<div id="grdGridArea" style="height:200px; width:100%"></div>
		</div>
	</form>	
