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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00004}"/>
<!-- 2. Script -->
<script type="text/javascript">

	var gridArea;				
	var skin = "dhx_skyblue";
	var objIds = new Array;
	var elmInstNos = new Array;
	var elmItemIDs = new Array;
	var procInstNos= new Array;
	
	$(document).on('propertychange change paste', '.startTime, .endTime, .actor .elmItemName', function(){
		if (objIds.indexOf(gridArea.getSelectedRowId()) == -1){ // 중복체크
			objIds.push(gridArea.getSelectedRowId());
			elmInstNos.push(gridArea.cells(gridArea.getSelectedRowId(), 2).getValue());
			elmItemIDs.push(gridArea.cells(gridArea.getSelectedRowId(), 1).getValue());
			procInstNos.push(gridArea.cells(gridArea.getSelectedRowId(), 0).getValue());
		}
	});
	$(document).on('keydown', '.actor', function(key){
		if (key.keyCode == 13) {
            return false;
        }
	});
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};
		
		
		var timer = setTimeout(function() {
			$("input.datePicker").each(generateDatePicker);
		}, 250); //1000 = 1초
		
		
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
		gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = "ProcInstNo,ElmItemID,ElmInstNo,${menu.LN00028},${menu.LN00119},${menu.LN00004},${menu.LN00104},${menu.LN00061},${menu.LN00062},${menu.LN00013},${menu.LN00070},";
		result.widths = "0,0,100,150,100,110,100,180,180,130,130,130";
		result.types = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";		
		result.aligns = "center,left,center,center,center,center,center,center,center,center,center,center";
		result.data = "";			
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	function fnGetEmailForm(id){
		var emailCode = gridArea.cells(id,2).getValue();
		var url = "editEmailFormPop.do?emailCode="+emailCode;
		window.open(url,'','width=1100, height=590, left=300, top=200,scrollbar=yes,resizble=0');
	}
	/*	
	function fnSaveGridData(id){
		var emailCode = gridArea.cells(id,2).getValue();
		var name = $("input[name='name_"+id+"']").val();
		var description = $("input[name='description_"+id+"']").val();
		
		var url = "saveEmailForm.do";
		var data = "emailCode=" + emailCode+"&name="+name+"&description="+description+"&viewType=E";
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}
	*/
	
	//조회
	function doSearchList(){
		gridArea.loadXML("${root}" + "${xmlFilName}");
	}

	function fnCallBack(){
		objIds = new Array;
		elmInstNos = new Array;
		elmItemIDs = new Array;
		procInstNos = new Array;
		doSearchList();
	}
	
	function searchPopupWf(idx){
		var url = "searchPluralNamePop.do?&UserLevel=ALL&searchValue="+ $("#actorName_"+idx).val()
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&objId="+idx;
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5){
		$("#actorName_"+avg5).val(avg2);
		$("#actorID_"+avg5).val(avg1);
		$("#actorTeamName_"+avg5).text(avg3);
		$("#actorTeamID_"+avg5).val(avg4);
	}
	
	function fnSaveAll(){

		for(var i=0; i<objIds.length; i++){
			if(!fnCheckValidation(objIds[i])){return;}
		}
		var url = "elmInstaceAllSave.do?objIds="+objIds+"&procInstNos="+procInstNos+"&elmInstNos="+elmInstNos+"&elmItemIDs="+elmItemIDs;
		if(confirm("${CM00001}")){
			ajaxSubmit(document.pimElementFrm, url,"saveDFrame");
		}
	}
	
	function fnelmInstaceSave(procInstNo, elmInstNo, elmItemID,idx){
		if(confirm("${CM00001}")){
			if(!fnCheckValidation(idx)){return;}
			var actorID = $("#actorID_"+idx).val();
			var actorTeamID = $("#actorTeamID_"+idx).val();
			var startTime = $("#startTime_"+idx).val();
			var endTime = $("#endTime_"+idx).val();
			var elmItemName = $("#elmItemName_"+idx).val();
			var url = "elmInstaceSave.do";		
			var parameter = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&elmItemID="+elmItemID;
			parameter +="&actorID="+actorID+"&actorTeamID="+actorTeamID;
			parameter +="&startTime="+startTime+"&endTime="+endTime;
			parameter +="&elmItemName="+elmItemName;
			var target = "subFrame";
			ajaxPage(url, parameter, target);	
		}
	}
	
	function fnPimElementInfo(instanceNo){
		var url = "plm_ViewProjectTask.do?";
		var data = "instanceNo="+instanceNo+"&instanceClass='STEP'&masterItemID=${nodeID}"; 
	    var w = "1000";
		var h = "650";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	

	}
	function fnCheckValidation(idx){
		var actorID = $("#actorID_"+idx).val();
		var actorName = $("#actorName_"+idx).val();
		var startTime = $("#startTime_"+idx).val();
		var endTime = $("#endTime_"+idx).val();
		
		if(actorName == "" || actorID == ""){					
			alert("${WM00034}"); return false;
		}	
		if(parseInt(startTime) > parseInt(endTime)){					
			alert("${WM00132}"); return false;
		}
		return true;
	}
</script>
<body>
<div id="">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Element List</li>
		</ul>
	</div>
    <div class="countList">
		<ul>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
		    <li class="floatR mgR20">
				<span class="btn_pack small icon"><span class="save"></span><input value="Save All" type="submit" onclick="fnSaveAll();"></span>
			</li>
		</ul>
    </div>
	<div id="gridDiv" class="mgB10 clear mgL10 mgR10">
		<div id="gridArea" style="width:100%"></div>
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