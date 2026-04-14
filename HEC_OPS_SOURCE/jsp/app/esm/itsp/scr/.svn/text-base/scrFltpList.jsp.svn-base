<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		};
		gridInit();
		doSearchList();
	});	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function gridInit(){		
		var d = setOTGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch")
		
		dp = new dataProcessor("updateSCRFileType.do?scrId=${scrId}"); // lock feed url
		dp.enableDebug(true);
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		dp.init(p_gridArea); // link dataprocessor to the grid  
	}

	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";	
		result.key = "scr_SQL.getSCRfileType";
		result.header = "${menu.LN00024},#master_checkbox,FltpCode,${menu.LN00101},FilePath,LinkType,Mandatory,비고";	
		result.cols = "CHK|FltpCode|Name|FilePath|LinkType|MandatoryYN|Remark"; 
		result.widths = "50,50,0,250,0,0,100,450"; 
		result.sorting = "int,int,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,left";	
		result.types = "ro,ro,ro,ro,ro,ro,coro,ed";
		//set values for select box in MandatoryYN column
		var mdSelect = p_gridArea.getCombo(6);
		mdSelect.put("Y","Y");
		mdSelect.put("N","N");

		result.data = "&scrId=${scrId}&languageID=${languageID}";
		return result;
	}
	
	//조회
	function doSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function AddFileType(){	
		var url = "addSCRFileAllocPop.do?scrId=${scrId}";
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function fnSaveGridData(){
		dp.sendData(); 
	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		gridInit();
		doSearchList();
	}

	function DelFileType(){		
		if (p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");	
		} else {
			if (confirm("${CM00004}")) {
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var fltpCodes = "";
				
				for ( var i = 0; i < checkedRows.length; i++) {
					if(fltpCodes == ""){
						fltpCodes = p_gridArea.cells(checkedRows[i], 2).getValue();
					} else {
						fltpCodes = fltpCodes + "," + p_gridArea.cells(checkedRows[i], 2).getValue();
					}
				}
				if(fltpCodes != ""){
					var url = "delSCRFileType.do";
					var data = "scrId=${scrId}&fltpCodes="+fltpCodes;
					var target = "ArcFrame";
					ajaxPage(url, data, target);
				}
			}
		}
	}
	
</script>
</head>
<form name="FileTypeList" id="FileTypeList" action="*" method="post" onsubmit="return false;">
	<div style="overflow:auto;overflow-x:hidden;">
		<div class="countList">
	      	<li class="count">Total  <span id="TOT_CNT"></span></li>
	      	<li class="floatR mgR10">
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddFileType()"></span>&nbsp;
				<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveGridData()"></span>&nbsp;
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DelFileType()"></span>
			</li>
		</div>	
		<div id="gridDiv" class="mgB10 clear" align="center">
			<div id="grdGridArea" style="width:100%;"></div>
		</div>
	</div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
</html>