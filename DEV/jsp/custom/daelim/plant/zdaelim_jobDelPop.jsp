<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<script type="text/javascript">
	var baseLayout;var cntnLayout;var menuTreeLayout;
	var treeImgPath="${menuStyle}";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;
	var p_gridArea;
	
	jQuery(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 70)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 70)+"px;");
		};
		
		gridInit();
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

	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setColumnHidden(4, true);				
		p_gridArea.setColumnHidden(5, true);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onCheck", function(rId,cInd,state){pGridOnCheck(rId,cInd,state);});
		p_gridArea.checkAll(false);
		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,"", "", "", "", "", "${WM00119}", 1000);
		
	}
	function setGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "custom_SQL.zdaelim_del";
		result.header = "No,#master_checkbox,경로,세부직무,ItemID,CNItemID";
		result.cols = "CHK|Path|Name|itemID|CNItemID";
		result.widths = "30,30,300,*,10,10";
		result.sorting = "int,int,str,str,int,int";
		result.aligns = "center,center,left,left,center,center";
		
		result.data = "itemID=${itemID}"		
			        + "&memberID=${sessionScope.loginInfo.sessionUserId}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sessionAuthLev=${sessionScope.loginInfo.sessionAuthLev}"
					+ "&pageNum="     	+ $("#currPage").val();
		
		
		return result;
	}

	function pGridOnCheck(rId,cInd,state){
		if( state ){
			p_gridArea.cells(rId,1).setValue(1);
			
		}else{
			p_gridArea.cells(rId,1).setValue(0);
			
		}
 
	}
	function fnDeleteJopCnx(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var items = "";
				
				for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
					var itemID=p_gridArea.cells(checkedRows[i], 5).getValue();
					if(itemID==""||itemID==undefined){}
					else{
						// 삭제 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = itemID;
						} else {
							items = items + "," + itemID;
						}
					}
				}

				if (items != "") {
					opener.fnGoConnectionDelete(items);
				}
				self.close();
			}
		}	
	}
	
	
</script>
<input type="hidden" id="tmpSelID" name="tmpSelID" value="" />
<input type="hidden" id="tmpSelSHR" name="tmpSelSHR" value="" />
<form name="cfgFrm" id="cfgFrm" action="#" method="post" onsubmit="return false;">
<div id="contentwrapper" style="position:absolute;margin:5px;">	
	<div class="child_search_head_blue" style="border:0px;">
			<li class="floatL"><p>* Select items</p></li>
		</div>	 	
	<div id="contentcolumn" >		
		<div style="width:100%;height:300px;" class="grdGridArea" id="grdGridArea">
		 </div>	
	</div>
	<div style="padding-top:5px;padding-right:10px;">
	<span class="btn_pack small icon floatR"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteJopCnx();"></span>
	</div>
</div>	
</form>
