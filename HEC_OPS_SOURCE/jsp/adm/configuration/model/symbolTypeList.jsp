<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<!-- 2. Script -->
<script type="text/javascript">
	$(function(){
		gridOTInit();
		doOTSearchList();
	});

	//===============================================================================
	//BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();	
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		OT_gridArea.setIconPath("${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/");
		fnSetColType(OT_gridArea, 1, "ch");
		fnSetColType(OT_gridArea, 3, "img");
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		OT_gridArea.enablePaging(true,10,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}  
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getSymbolList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00169},${menu.LN00176},${menu.LN00028},${menu.LN00033},${menu.LN00021},ClassCode,ImagePath,ArisTypeNum,Deactivated";	
		result.cols = "CHK|SymTypeCode|SymbolIcon|SymbolName|SymCategory|ItemTypeName|ClassName|ImagePath|ArisTypeNum|Deactivated";
		result.widths = "50,50,80,80,100,80,120,90,370,80,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,left,center,center";
		result.data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&SymTypeCode="
						+ "&pageNum=" + $("#currPage").val();
		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind) {
		var url = "symbolTypeDetail.do";
		var data = "&SymTypeCode="+ OT_gridArea.cells(id,2).getValue() + 
				   "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"+
				   "&pageNum=" + $("#currPage").val()+
				   "&viewType=E";
		var target = "SymbolTypeList";
		ajaxPage(url,data,target);
	}
	
	// END ::: GRID	
	//===============================================================================
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
	function addModelTypePop() {
		var url = "symbolTypeDetail.do";
		var data = "&pageNum=" + $("#currPage").val()+
				   "&viewType=N";
		var target = "SymbolTypeList";
		ajaxPage(url,data,target);
	}
	
	function delModelFLow() {
	
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		} else {
			//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
			if (confirm("${CM00004}")) {
				var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
				for ( var i = 0; i < checkedRows.length; i++) {
					var url = "DeleteSymbolType.do";
	
					var data = "&SymTypeCode=" + OT_gridArea.cells(checkedRows[i], 2).getValue()
							+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+ "&gubun=1";
					
					if (i + 1 == checkedRows.length) {
						data = data + "&FinalData=Final";
					}
					var target = "ModelFrame";
					ajaxPage(url, data, target);
					OT_gridArea.deleteRow(checkedRows[i]);
				}
			}
		}
	}
	
	function urlReload() {
		var url = "modelType.do";
		var target = "ModelFrame";
		var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" +
						"&pageNum=" + $("#currPage").val(); 
	 	ajaxPage(url,data,target);
	}

</script>
</head>
<body>
<div id="symbolTypeDiv">
<form name="SymbolTypeList" id="SymbolTypeList" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
<div class="cfgtitle" >					
	<ul>
		<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Symbol Type</li>
	</ul>
</div>
<div class="child_search01 mgB5 mgL10 mgR10">
	<ul>
		<li class="floatR pdR10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="addModelTypePop()" ></span>
		&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delModelFLow()" ></span>
		</c:if>	
		</li>
	</ul>
</div>
    <div class="countList pdL10">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
       	<li class="floatR">&nbsp;</li>
    </div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height: 360px; width: 100%"></div>
	</div>
<div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
</form>
</div>
<div class="schContainer" id="schContainer">
	<iframe name="cFrame" id="cFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
</body>
</html>