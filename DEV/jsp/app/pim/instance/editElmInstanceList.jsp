<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00119}"/>
<!-- 2. Script -->
<script type="text/javascript">
	var gridArea;				
	var skin = "dhx_skyblue";
	var objIds = new Array;
	var elmInstNos = new Array;
	var elmItemIDs = new Array;
	var procInstNos= new Array;
	var roleIDs= new Array;
	var index;
	
	$(document).on('propertychange change paste', '.elmInstRole, .schStartTime, .status', function(){
		if (objIds.indexOf(gridArea.getSelectedRowId()) == -1){ // 중복체크
			objIds.push(gridArea.getSelectedRowId());
			elmInstNos.push(gridArea.cells(gridArea.getSelectedRowId(), 5).getValue());
			elmItemIDs.push(gridArea.cells(gridArea.getSelectedRowId(), 3).getValue());
			procInstNos.push(gridArea.cells(gridArea.getSelectedRowId(), 2).getValue());
		}
	});
	
	$(document).on('change', '.status', function(){
		var rowId = gridArea.getSelectedRowId();
		if($("#status_"+rowId).val() == "" &&  $("#curStatus_"+rowId).val() == "CLS"){
			$("#schStartTimetxt_"+rowId).css("display","block");
			$("#schStartTimeDiv_"+rowId).css("display","none");
			$("#schStartTime_"+rowId).val($("#schStartTimetxt_"+rowId).text());
			
			$("#roletxt_"+rowId).css("display","block");
			$("#roleDiv_"+rowId).css("display","none");
			
			$("#actortxt_"+rowId).css("display","block");
			$("#actorDiv_"+rowId).css("display","none");
			
		}else{
			$("#schStartTimetxt_"+rowId).css("display","none");
			$("#schStartTimeDiv_"+rowId).css("display","block");

			$("#roletxt_"+rowId).css("display","none");
			$("#roleDiv_"+rowId).css("display","block");

			$("#actortxt_"+rowId).css("display","none");
			$("#actorDiv_"+rowId).css("display","block");
		}
	});
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 463)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 463)+"px;");
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
		*/
		fnSetColType(gridArea, 1, "ch");
		gridArea.setColumnHidden(10, true);
		gridArea.setColumnHidden(13, true);
		gridArea.setColumnHidden(14, true);
		gridArea.setColumnHidden(15, true);
		gridArea.setColumnHidden(17, true);
		gridArea.enablePaging(true,10,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind); 
		$("input.datePicker").nextAll().remove();
			$("input.datePicker").each(generateDatePicker);
});
	}
	
	function setGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00024},#master_checkbox,ProcInstNo,ElmItemID,projectCode,elmInstNo,Code,${menu.LN00028},${menu.LN00119},${menu.LN00004},${menu.LN00104},${menu.LN00027},${menu.LN00061},${menu.LN00062},${menu.LN00013},${menu.LN00070},,Status";
		result.widths = "30,30,0,0,0,0,120,250,200,*,0,140,150,0,0,0,100,0";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";		
		result.aligns =  "center,center,center,center,left,center,center,left,left,left,center,center,center,center,center,center,center,center,center";
		result.data = "";			
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
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
	
	function fnSaveAll(){
		if(objIds.length > 0){
			for(var i=0; i<objIds.length; i++){
				if(!fnCheckValidation(objIds[i])){return;}
			}
			var url = "saveAllElmInst.do?objIds="+objIds+"&procInstNos=${instanceNo}&elmInstNos="+elmInstNos+"&elmItemIDs="+elmItemIDs;
			if(confirm("${CM00001}")){
				ajaxSubmit(document.pimElementFrm, url,"saveDFrame");
			}
		}else{
			alert("${CM00066}");
		}
	}
	
	function fnelmInstaceSave(procInstNo, elmInstNo, elmItemID,idx){
		if(confirm("${CM00001}")){
			if(!fnCheckValidation(idx)){return;}
			var actorID = $("#actorID_"+idx).val();
			var schStartTime = $("#schStartTime_"+idx).val();
			var roleID = $("#roleID_"+idx).val();
			var status = $("#status_"+idx).val();
			var url = "saveElmInst.do";		
			var parameter = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&elmItemID="+elmItemID+"&roleID="+roleID
								+"&actorID="+actorID+"&schStartDate="+schStartTime+"&status="+status;
			var target = "subFrame";
			ajaxPage(url, parameter, target);	
		}
	}
	
	function fnPimElementInfo(procInstNo,elmInstNo){
		var url = "elmInstDetail.do?";
		var data = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&instanceClass=ELM&masterItemID=${nodeID}"; 
	    var w = "1000";
		var h = "650";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	

	}
	function fnCheckValidation(idx){
// 		var actorID = $("#actorID_"+idx).val();
// 		var actorName = $("#actorName_"+idx).val();
		var schStartTime = $("#schStartTime"+idx).val();
// 		var endTime = $("#endTime_"+idx).val();
// 		var roleID = $("#roleID_"+idx).val();

// 		if(roleID == ""){
// 			alert("${WM00025_2}"); return false;
// 		}
// 		if(actorName == "" || actorID == ""){
// 			alert("${WM00025_1}"); return false;
// 		}
// 		if(parseInt(schStartTime) > parseInt(endTime)) 	alert("${WM00132}"); return false;
		
		return true;
	}
	
	function goBack() {
		var url = "viewElmInstList.do";
		var target = "cfgFrame";
		var parameter = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&procModelID=${procModelID}"
			+ "&instanceNo=${instanceNo}"
			+ "&processID=${nodeID}";
		ajaxPage(url, parameter, target);
	}
	
	function fnAssignRole(ind){
		if (objIds.indexOf(ind) == -1){ // 중복체크
			objIds.push(ind);
			elmInstNos.push(gridArea.cells(ind, 5).getValue());
			elmItemIDs.push(gridArea.cells(ind, 3).getValue());
			procInstNos.push(gridArea.cells(ind, 2).getValue());
		}
		index = gridArea.cells(ind, 0).getValue();
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode=OJ00002&openMode=assignWText&s_itemID=${nodeID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){}
	
	function setCheckedItems(roleID, Name){
		Name = Name.split(" ");
		$("#roleID_"+index).val(roleID);
		$("#roleName_"+index).val(Name[Name.length-1]);
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	function fnAssignActor(ind){
		if (objIds.indexOf(ind) == -1){ // 중복체크
			objIds.push(ind);
			elmInstNos.push(gridArea.cells(ind, 5).getValue());
			elmItemIDs.push(gridArea.cells(ind, 3).getValue());
			procInstNos.push(gridArea.cells(ind, 2).getValue());
		}
		index = gridArea.cells(ind, 0).getValue();
		var sharers = $("#actorID_"+ind).val();
		var url = "selectMemberPop.do?mbrRoleType=ACTOR&&s_memberIDs="+sharers;
		window.open(url,"schedlFrm","width=900 height=700 resizable=yes");
	}
	
	function setCheckedActors(ids,Names,teamids){
		$("#actorID_"+index).val(ids);
		$("#actorName_"+index).val(Names);
		$("#actorTeamID_"+index).val(teamids);
	}
		
	function fnDelete(){
		var elmInstNo = "";
		var status = "";
		var checkedRows = gridArea.getCheckedRows(1).split(",");
		for(var i = 0 ; i < checkedRows.length; i++ ){
			status = gridArea.cells(checkedRows[i], 17).getValue();
			if(status != "CLS"){
				if (elmInstNo == "") {
					elmInstNo = gridArea.cells(checkedRows[i], 5).getValue();
				} else {
					elmInstNo = elmInstNo + "," + gridArea.cells(checkedRows[i], 5).getValue();
				}
			} else {
				gridArea.cells(checkedRows[i], 1).setValue(0);
			}
		}
		if (confirm("${CM00042}")) {
			var url  = "deleteElmInst.do";
			var data = "&procInstNo=${instanceNo}&elmInstNo="+elmInstNo;
			var target = "saveDFrame";
			ajaxPage(url,data,target);
		}
	}
	
	function fnReload(){
		var url = "editElmInstanceList.do";
		var target = "cfgFrame";
		var parameter = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&procModelID=${procModelID}"
			+ "&instanceNo=${instanceNo}"
			+ "&processID=${nodeID}";
		ajaxPage(url, parameter, target);
	}
</script>
<div style="width:100%;height:100%;">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" value="OJ00002"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Activity List</li>
		</ul>
	</div>
    <div class="countList">
		<ul>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
		    <li class="floatR mgR20">
		    	&nbsp;<span class="btn_pack medium icon"><span class="del"></span><input value="Delete" type="submit" onclick="fnDelete()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="save"></span><input value="Save All" type="submit" onclick="fnSaveAll()"></span>
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	 </li>
		</ul>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>