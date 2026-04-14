<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00072}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00148}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00018}"/>

<script>
var p_gridOUGArea;
$(document).ready(function(){
	gridOUGInit();		
	doSearchOUGList();
	
});
//===============================================================================
function doSearchOUGList(){
	var d = setGridOUGData();
	fnLoadDhtmlxGridJson(p_gridOUGArea, d.key, d.cols, d.data);
}
function gridOUGInit(){	
	var d = setGridOUGData();
	p_gridOUGArea = fnNewInitGrid("grdOUGGridArea", d);
	p_gridOUGArea.setImagePath("${root}${HTML_IMG_DIR}/");
	fnSetColType(p_gridOUGArea, 1, "ch");
	p_gridOUGArea.attachEvent("onRowSelect", function(id,ind){gridOUGOnRowSelect(id,ind);});
	
	p_gridOUGArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
	p_gridOUGArea.setPagingSkin("bricks");
	p_gridOUGArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
}
function setGridOUGData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "crm_SQL.custList";
	result.header = "${menu.LN00024},#master_checkbox,고객레벨,고객명,고객타입,사업분야,종목,수정일,등록자,customerNo,custGRNo,custLvl,TeamID";
	result.cols = "CHK|CustLvl|CustomerNM|CustType|BizType|BizItem|LastUpdated|RegUser|CustomerNo|CustGRNo|CustLvl|TeamID";
	result.widths = "50,50,100,140,100,100,200,140,100,0,0,0,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				
				/* 검색 조건 */
				if($("#searchValue").val() != '' & $("#searchValue").val() != null){
					result.data = result.data +"&searchValue="+$("#searchValue").val();
					result.data = result.data + "&pageNum=1";
				} else {
					result.data = result.data + "&pageNum=" + $("#currPage").val();
				}
				result.data = result.data + "&custLvl="+$("#custLvl").val();
				result.data = result.data + "&custType="+$("#custType").val();
	return result;
}

function gridOUGOnRowSelect(id, ind){	
	var customerNo = p_gridOUGArea.cells(id, 9).getValue();
	var custGRNo = p_gridOUGArea.cells(id, 10).getValue();
	var custLvl = p_gridOUGArea.cells(id, 11).getValue();
	var currPage = $("#currPage").val();
	var custLvl = $("#custLvl").val();
	var custType = $("#custType").val();
	parent.fnGoTreeMgt(customerNo,custGRNo,currPage,custLvl,custType);
}

//===============================================================================

function custDel(){
	if(p_gridOUGArea.getCheckedRows(1).length == 0){
		alert("${WM00023}");
	}else{
		if(confirm("${CM00004}")){
			var checkedRows = p_gridOUGArea.getCheckedRows(1).split(",");
			var items = "";
			for(var i = 0 ; i < checkedRows.length; i++ ){
				if (i == 0) {
					items = p_gridOUGArea.cells(checkedRows[i], 12).getValue();
				} else {
					items = items + "," + p_gridOUGArea.cells(checkedRows[i], 12).getValue();
				}
			}
			
			var url = "deleteCust.do";
			var data = "items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
			
		}
	}
}

function clickNewBtn(){
	var url    = "registerCust.do"; // 요청이 날라가는 주소
	var data = "viewType='N'"
	var target = "custList";
	ajaxPage(url,data,target);
}


</script>
</head>

<body>
<form name="custList" id="custList" action="#" method="post" onsubmit="return false;" class="pdT10 pdL10 pdR10">
	<div id="custListDiv" class="hidden" style="width:100%;height:100%;">
		<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionAuthId}">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
		
		<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;고객 관리 목록</div>
		<div>	  	
			<div class="child_search">
				<li class="pdL10">
					고객타입 &nbsp;
					<select id="custType" Name="custType" style="width:150px;">
						<option value="CS" <c:if test="${custType == 'CS'}">selected</c:if>>Customer</option>
						<option value="BP" <c:if test="${custType == 'BP'}">selected</c:if>>Partner</option>
					</select>
					&nbsp; 고객레벨 &nbsp;
					<select id="custLvl" Name="custLvl" style="width:150px;">
						<option value="G" <c:if test="${custLvl == 'G'}">selected</c:if>>Group</option>
						<option value="C" <c:if test="${custLvl == 'C'}">selected</c:if>>Company</option>
						<option value="D" <c:if test="${custLvl == 'D'}">selected</c:if>>Division</option>
					</select>
					&nbsp; 고객명 &nbsp;
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchOUGList()" value="검색">
				</li>
				<li class="floatR pdR20">
						<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
						<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="newButton"  onclick="clickNewBtn()"></span>&nbsp;
						&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" id="delButton"  onclick="custDel()"></span>&nbsp;
						</c:if>
				</li>
			</div>
			
			<div id="gridDiv" class="mgB10 mgT5">
				<div id="grdOUGGridArea" style="height:400px; width:100%"></div>
			</div>
			
			<!-- START :: PAGING -->
			<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
			<!-- END :: PAGING -->	
	    </div>
	</div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;border: 0;" ></iframe>
</body>
</html>