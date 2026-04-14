<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00168" var="WM00168" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00168" var="WM00168" arguments="${menu.LN00148}"/>
<!-- 2. Script -->
<script type="text/javascript">

	var gridArea;				
	var skin = "dhx_skyblue";
	var objIds = new Array;
	var elmInstNos = new Array;
	var elmItemIDs = new Array;
	var procInstNos= new Array;
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
// 		$("#gridArea").attr("style","height:calc(100% - 182px)");
// 		// 화면 크기 조정
// 		window.onresize = function() {
// 			$("#gridArea").attr("style","height:calc(100% - 182px)");
// 		};
		
		gridInit();
		doSearchList();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		gridArea = fnNewInitGridMultirowHeader("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		/*
		gridArea.setColumnHidden(4, true);
		fnSetColType(gridArea, 1, "ch");
		*/
		gridArea.setColumnHidden(8, true);
		gridArea.setColumnHidden(11, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
		gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "instance_SQL.getElmInstList";
		result.header = "${menu.LN00024},ProcInstNo,ElmItemID,projectCode,Code,${menu.LN00028},${menu.LN00119},${menu.LN00004},${menu.LN00104},${menu.LN00027},${menu.LN00061},${menu.LN00062},${menu.LN00064},${menu.LN00070},Mailing Date,";
		result.cols = "ProcInstNo|ElmItemID|projectCode|Identifier|elmItemName|roleName|actorName|actorTeamName|StatusNM|SchStartDate|DueDate|endTime|LastUpdated|AlarmDate|infoBtn";
		result.widths = "30,0,0,0,120,250,160,*,0,140,150,0,0,0,150,130";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";		
		result.aligns = "center,left,left,left,center,left,left,left,center,center,center,center,center,center,center,center";
		result.data = "instanceNo=${instanceNo}"
            + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	//조회
	function doSearchList(){
		//gridArea.loadXML("${root}" + "${xmlFilName}");
		var d = setGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	
	}
	
	function fnElmInstanceEditList(){
		var url = "editElmInstanceList.do";
		var target = "cfgFrame";
		var parameter = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&instanceNo=${instanceNo}"
			+ "&processID=${nodeID}";
		ajaxPage(url, parameter, target);
	}
	
	function fnEnsembleUserList(){
		var url = "/daelim/plant/getEnsembleUserList.do";
		var target = "saveDFrame";
		var parameter = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&procInstNo=${instanceNo}";
		ajaxPage(url, parameter, target);
	}
	
	function fnPimElementInfo(procInstNo,elmInstNo){
		var url = "elmInstDetail.do?";
		var data = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&instanceClass=ELM"; 
	    var w = "1000";
		var h = "800";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	

	}
	
	function fnCopyElm(){
		var url = "selectElmInstTree.do?modelID=${procModelID}&instanceNo=${instanceNo}&processID=${nodeID}";
		var w = 800;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnCallBackSubmit() {
		doSearchList();
	}
	function fnCallBackEnsembleUserList(errorMessage, errortype) {
		if(errortype == 0){
			alert(errorMessage + "${WM00114}");	
		}else if(errortype == 1){
			alert(errorMessage + "${WM00168}");	
		}
	}
	
	function fnDeleteAll(){
		if (confirm("${CM00042}")) {
			var url  = "deleteElmInst.do";
			var data = "&procInstNo=${instanceNo}";
			var target = "saveDFrame";
			ajaxPage(url,data,target);
		}
	}
	
	function fnReload() {
		goProcInstanceInfoEdit("V");
	}
</script>
<body>
<div style="width:100%;height:100%;">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Activity List</li>
		</ul>
	</div>
    <div class="countList">
		<ul>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
			<c:if test="${sessionScope.loginInfo.sessionUserId eq procInstanceInfo.OwnerID || sessionScope.loginInfo.sessionUserId eq prcMap.AuthorID}">
		    <li class="floatR mgR20">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Copy Activity" type="submit" onclick="fnCopyElm()"></span>
				&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="Update All Workers" type="submit" onclick="fnEnsembleUserList()"></span>
				&nbsp;<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnElmInstanceEditList()"></span>
				&nbsp;<span class="btn_pack medium icon"><span class="del"></span><input value="Delete All" type="submit" onclick="fnDeleteAll()"></span>
			</li>
			</c:if>
		</ul>
    </div>
	<div id="gridDiv" class="mgB10 clear mgL10 mgR10">
		<div id="gridArea" style="width:100%;height:calc(100% - 150px);"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>