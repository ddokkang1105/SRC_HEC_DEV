<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />


<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		gridInit();
		doSearchList();
	});	

	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}

	//그리드 초기화
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");


		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(5, true);	

	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "cs_SQL.getItemChangeList";
		result.header = "${menu.LN00024},#master_checkbox,Version,${menu.LN00070},${menu.LN00027},ChangeSetID";
		result.cols = "CHK|Version|CompletionDate|ChangeSts|ChangeSetID";
		result.widths = "30,30,80,120,80,0";
		result.sorting = "str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	function doDiffCheck(){		
		
		var cnt  = p_gridArea.getRowsNum();
		var seq = "";
		var chkVal = "";

		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		
		for(var i=0; i<cnt; i++){
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){		
				if(seq == "")
					seq = "&changeSet=" + p_gridArea.cells2(i,5).getValue(); 
				else 
					seq = seq + "&preChangeSet=" + p_gridArea.cells2(i,5).getValue(); 
			}
		}		
		
		var url = "compareAttribute.do?s_itemID=${s_itemID}"+seq;

		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		self.close();
		
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="preChangeSet" id="preChangeSet" >
	<div class="child_search_head">
	<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Diff Check</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doDiffCheck()" ></span>
		</div>
		<div id="grdGridArea" style="width:100%;height:320px;"></div>	
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>