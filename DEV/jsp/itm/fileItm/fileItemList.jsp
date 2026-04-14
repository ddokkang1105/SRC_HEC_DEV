<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/search.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00059" var="WM00059"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00060" var="WM00060"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>

<style>
	.dhx_list-item {
		padding: 11px 15px;
	}
	
	.new {
		color: #4264ED;
		background: #E1F3FF;
		padding: 0 5px;
		line-height: 15px;
		display: inline-block;
		text-align: center;
		border-radius: 4px;
	}
	
	.mod {
		color: #0D914F;
		background: #EBFFEF;
		padding: 0 5px;
		line-height: 15px;
		display: inline-block;
		text-align: center;
		border-radius: 4px;
	}
	
	.del {
		color: #FC4C4C;
		background: #FEF3F1;
		padding: 0 5px;
		line-height: 15px;
		display: inline-block;
		text-align: center;
		border-radius: 4px;
	}
	
	#grid_area {
		width: 27%;
	}
	
	#tab_area {
		flex: 1 1 0;
	}
	
	#hr {
		width: 1px;
		border-left: 1px solid #ededed;
		padding-right: 5px;
		cursor: w-resize;
	}
	
	#hr::after {
		content: "";
		position: relative;
		z-index: 9999999;
		top: 50%;
		left: 3px;
		width: 25px;
		height: 25px;
		border-left: 1px solid #d2d2d2;
		display: block;
	}
	
	#fileItemDiv {
		border: 1px solid #e4e4e4;
	}
	
	.list_search {
		border-bottom: 1px solid #e4e4e4;
	}
	
	.fontStyleB12 {
		font-size: 13px;
		font-weight: Bold;
		color: #3f3c3c;
	}
	
	.divider {
		position: relative;
		top: 2px;
		display: inline-block;
		width: 1px;
		height: 13px;
		margin-left: 7px;
		margin-right: 3px;
		background: #ababab;
	}
</style>

<script>
	var gridArea;	
	var tranSearchCheck = false;
	var statusCSS;
	var list;
	var isEnable = false;
	
	$(document).ready(function(){
		var currIdx = "${currIdx}";
		if(currIdx == "" || currIdx == "undefined"){currIdx = "0";}
		
		if(getCookie('itemIDs')) {
			var itemIDs = getCookie('itemIDs').split(',');
			fnOpenItems(currIdx,itemIDs);
		}
		$("input.datePicker").each(generateDatePicker);
		
		fnLoadList(listData, ${totalCnt});
		
		document.getElementById("hr").onmousedown = on_mouse_down;
		document.onmouseup = on_mouse_up;
		document.onmousemove = on_mouse_move;
		
// 		autoComplete("searchValue2", "AT00001", "", "", "", 5, "top");
		fnSelect('status', '&category=ITMSTS', 'getDictionaryOrdStnm', '', 'Select');
	});
	
	function fnGoBackNextPage(pID,preNext,currIdx){
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId,preNext,currIdx);
		} 
	}
	
	function doTcSearchList(){ doSearchList(); }

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doSearchList(){		
		var param = "&itemID=${s_itemID}"
			 		+ "&option=" + $("#option").val()
		      		+ "&filterType=${filterType}"
				    + "&TreeDataFiltered=${TreeDataFiltered}"  
				    + "&defDimTypeID=${defDimTypeID}"
				    + "&defDimValueID=${defDimValueID}"      
				    + "&showTOJ=${showTOJ}"
				    + "&showElement=${showElement}";
		
		$.ajax({
			url:"getFileItemList.do",
			type:"POST",
			data:param,
			success: function(result){
				listData = eval(result);
				if(listData != ""){
					fnLoadList(listData, listData.length);
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function fnViewFileItem(itemID, classCode){				
		var url = "viewFileItem.do?s_itemID=${s_itemID}&classCode="+classCode+"&itemID="+itemID;
		
		var w = 1500;
		var h = 800;
		itmInfoPopup(url,w,h); 	
	}
	
	function fnClickedFileIcon(itemID, fileCheck, e){
		e.stopPropagation();
		if(fileCheck.indexOf("blank.gif") < 1) {
			if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckItemArrayAccRight(itemID); // 접근권한 체크후 DownLoad
			}else{
				var url = "selectFilePop.do";
				var data = "?s_itemID="+itemID; 
			   
			    var w = "650";
				var h = "350";
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
		}else{
			tranSearchCheck = false;
		}
	}
	
	function fnCheckItemArrayAccRight(seq, DocumentID, ind){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, ind);
			}
		});	
	}
	
	function fnCheckAccCtrlFileDownload(data, seq, DocumentID, ind){
		var dataArray = data.split(",");
		var accRight = dataArray[0];
		var fileName = dataArray[1];
		
		if(accRight == "Y"){
			if(ind==3){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
					ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");			
			}else{						
				var url  = "documentDetail.do?&seq="+seq
						+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 	
			}
		}else{			
			alert(fileName + "은 ${WM00033}"); return;
		}
	}
	
	function fnFileUpload(){
		
	    var fileCount = document.getElementById("files_upload").files.length;
	
	    var fileSize = new Array();
	    var fileName = new Array();
	
	 	for(var i=0; i<fileCount; i++){
	 		fileSize[i] = document.getElementById("files_upload").files[i].size;
	 		fileName[i] = document.getElementById("files_upload").files[i].name;
	 	}
		  
		var files =  $("#files-upload").val();
		var url  = "fileUpload.do?files="+files+"&fileSize="+fileSize+"&fileName="+fileName;
		ajaxSubmit(document.fileMgtFrm, url);
	}	
	
	function fnFileDownload(){
		var cnt  = gridArea.getRowsNum();
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		if (gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00049}");
			return;
		}
		
		for(var i=0; i<cnt; i++){
			chkVal = gridArea.cells2(i,1).getValue();
			if(chkVal == 1){				
				sysFileName[j] =  gridArea.cells2(i,14).getValue(); //sysfile
				originalFileName[j] =  gridArea.cells2(i,7).getValue(); // orignalfile
				filePath[j] = gridArea.cells2(i,16).getValue(); // 파일경로
				seq[j] = gridArea.cells2(i,13).getValue(); 
				j++;
			}
		}		
		
		$("#sysFileName").val("");
		$("#originalFileName").val("");
		$("#seq").val(seq);
		var url  = "fileDownload.do";
		ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");
	}	
	
	function fnRegisterFileItem(){
		var url = "registerItem.do?s_itemID=${s_itemID}&pop=pop";	
		window.open(url,'',"width=1600px, height=800px, left=200, top=100,scrollbar=yes,resizble=0");
	}
	
	function doCallBackMove(){}
	
	var itemIDs = "";
	function fnClickedMoveItem(){
		var itemID;
		var gubun;
		var itemName;
		
		var checkedCnt=0;
		<c:forEach var="list" items="${fileItemList}" varStatus="status">				
			try{
				var checkObj = document.all("chkItem_${list.ItemID}");
				if(checkObj != null){
					if (checkObj.checked) {
						checkedCnt = checkedCnt + 1;
					}
				}
			}catch(e){}
		</c:forEach>
		if(checkedCnt == 0){alert("${WM00023}");return;}
		
		<c:forEach var="list" items="${fileItemList}" varStatus="status">
			itemID = "${list.ItemID}";
			gubun = "${list.GUBUN}";
			itemName = "${list.ItemName}";
			try{
				var checkObj = document.all("chkItem_"+itemID);
				
				if(checkObj != null){
					if (checkObj.checked) {
						if(gubun == "O" || gubun == "o"){
							alert(itemName + "${WM00059}");
						}else{
						    if (itemIDs == "") {
						    	itemIDs = itemID;
							} else {
								itemIDs += ","+itemID;
							}
						}
					}
				}
			}catch(e){}
		</c:forEach>
		if (itemIDs != "") {
			var url = "acrCodeTreePop.do";
			var data = "items=" + itemIDs + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
			fnOpenLayerPopup(url,data,doCallBackMove,617,436);
		}
	}
	
	function fnMoveItems(avg, isCheck){
		if(isCheck == "false") {
			alert("${WM00060}");
			return;
		}
			
		if(itemIDs != ""){
			var url = "changeItemParent.do";
			var data = "s_itemID=${s_itemID}&items="+itemIDs+"&fromItemID="+avg;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
		itemIDs = "";
		$(".popup_div").hide();
		$("#mask").hide();
	}
		
	function fnEditCheckedAllItems(avg){			
		var itemStatus="";
		var blocked="";
		var itemName="";
		var classCodes="";
		var nowClassCode="";
		var items="";
		var checkedCnt=0;
		<c:forEach var="list" items="${fileItemList}" varStatus="status">	
			try{
				var checkObj = document.all("chkItem_${list.ItemID}");
				if(checkObj != null){
					if (checkObj.checked) {
						checkedCnt = checkedCnt + 1;
					}
				}
			}catch(e){}
		</c:forEach>
		if(checkedCnt == 0){alert("${WM00023}");return;}
		
		<c:forEach var="list" items="${fileItemList}" varStatus="status">	
		try{
			var checkObj = document.all("chkItem_${list.ItemID}");
			if(checkObj != null){
				if (checkObj.checked) {
					itemStatus = "${list.Status}";
					blocked = "${list.Blocked}";
					itemName = "${list.itemName}";	
				
					if (blocked != "0" && avg != "Owner") {
						if (itemStatus == "REL") {
							alert(itemName+"${WM00124}"); // [변경 요청 안된 상태]
						} else {
							alert(itemName+"${WM00123}"); // [승인요청중]
						}
						checkObj.checked = false;
					}else{
						// 이동 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = "${list.ItemID}";
							classCodes = "${list.ClassCode}";
							nowClassCode = "${list.ClassCode}";
						} else {
							items = items + ",${list.ItemID}";
							if (nowClassCode != "${list.ClassCode}") {
								classCodes = classCodes + ",${list.ClassCode}";
								nowClassCode = "${list.ClassCode}";
							}
						}
					}
				}
			}
		}catch(e){}
		</c:forEach>
		
		if (items != "") {
			$("#items").val(items);
			if (avg == "Attribute2") {
				var url = "selectAttributePop.do";
				var data = "items="+items+"&classCodes="+classCodes; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
				$("#classCodes").val(classCodes);
			    document.fileItemFrm.action=url;
			    document.fileItemFrm.target="selectAttribute2";
			    document.fileItemFrm.submit();
			    
			}
		
			//if (items != "") {
			else if (avg == "Attribute") {
					var url = "selectAttributePop.do";
					var data = "classCodes="+classCodes+"&items="+items; 
				    var option = "dialogWidth:400px; dialogHeight:250px;";			
				   
				    var w = "400";
					var h = "350";
					$("#classCodes").val(classCodes);
				    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
				    document.fileItemFrm.action=url;
				    document.fileItemFrm.target="selectAttribute";
				    document.fileItemFrm.submit();
				    
			} else  if (avg == "Owner") {				    
				    var url = "selectOwnerPop.do"; 
				    var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
				    window.open("", "SelectOwner", option);
				    document.fileItemFrm.action=url;
				    document.fileItemFrm.target="SelectOwner";
				    document.fileItemFrm.submit();
			} 
		 }
	}
		
	function urlReload() {
		doSearchList();
	}

	function fnDeleteItem(){
		var checkedCnt=0;
		<c:forEach var="list" items="${fileItemList}" varStatus="status">	
		try{
			var checkObj = document.all("chkItem_${list.ItemID}");
			if(checkObj != null){
				if (checkObj.checked) {
					checkedCnt = checkedCnt + 1;
				}
			}
		}catch(e){}
		</c:forEach>
		if(checkedCnt == 0){alert("${WM00023}");return;}
		
		if(confirm("${CM00004}")){
			var items = "";
			<c:forEach var="list" items="${fileItemList}" varStatus="status">		
			try{
				var checkObj = document.all("chkItem_${list.ItemID}");
				if(checkObj != null){
					if (checkObj.checked) {
						var itemStatus = "${list.Status}";
						var blocked = "${list.Blocked}";
						var changeMgt = "${list.ChangeMgt}";
						console.log("itemID  :${list.ItemID}");
						if (blocked != "0") {
							if (itemStatus == "REL") {
								alert("${list.ItemName} ${WM00121}");  // CSR 등록해
							} else {
								alert("${list.ItemName} ${WM00054}"); 
							}
							checkObj.checked = false;
						} else if (blocked == "0") {
							
							if("${list.GUBUN}" == "O"){						
								alert("${list.ItemName} - ${WM00052}"); // 모델에 사용중
								checkObj.checked = false;
							}else if(changeMgt == "1" && (itemStatus == "MOD1" || itemStatus == "DEL1")){						
								alert("${list.ItemName} ${WM00046}"); 
								checkObj.checked = false;
							}else {	
								if("${list.SCOUNT}" != 0){
									// 하위항목이 존재할 경우 삭제 불가
									alert("${list.ItemName} - ${WM00024}");
									checkObj.checked = false;
									
							   } else if (items == "") {
									items = "${list.ItemID}";
							   } else {
									items = items + ",${list.ItemID}";
							   }
						    }
						}
					}
				}
			}catch(e){}
		</c:forEach>

		if (items != "") {
			var url = "setItemStatusForDel.do";
			var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
		}
	  	
	 }
	
	function fnClickedReload() {
		var url = "fileItemList.do";
		var target = "fileItemFrm";
		var data = "itemID=${s_itemID}&arcCode=${arcCode}&accMode=${accMode}"
				+ "&showElement=${showElement}&strType=${strType}&scrnMode=${scrnMode}"
				+ "&showTOJ=${showTOJ}&showVAR=${showVAR}&ownerType=${ownerType}"
				+ "&itemClassMenuUrl=${itemClassMenuUrl}"
				+ "&currIdx=${currIdx}&showPreNextIcon=${showPreNextIcon}";
		ajaxPage(url, data, target);
	}
	
	function fnOpenTab(itemID, classCode, varFilter){
		var url = "viewItemInfoMgt.do";
		var target = "tab_detail_area";
		var data = "s_itemID="+itemID
				+ "&accMode=${accMode}"
				+ "&option=${arcCode}"
				+ "&level=${level}${varFilter}"
				+ "&openItemIDs=${openItemIDs}"
				+ "&showPreNextIcon=N"
				+ "&showTOJ=${showTOJ}"
				+ "&tLink=${tLink}"
				+ varFilter;
								
		ajaxPage(url, data, target);
	}
	
	function fnFileItemEditMulitiItemID(){
		var param = "s_itemID=${s_itemID}"
	 		+ "&option=" + $("#option").val()
      		+ "&filterType=${filterType}"
		    + "&TreeDataFiltered=${TreeDataFiltered}"  
		    + "&defDimTypeID=${defDimTypeID}"
		    + "&defDimValueID=${defDimValueID}"      
		    + "&showTOJ=${showTOJ}"
		    + "&showElement=${showElement}";
	
	    var url = "editItemIDNamePop.do"+ "?" +param	; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("", "SelectOwner", option);
	    document.fileItemFrm.action=url;
	    document.fileItemFrm.target="SelectOwner";
	    document.fileItemFrm.submit();
	}
	
	function fnFileItemReload(){		
		var url = "fileItemList.do";
		var target = "fileItemListDiv";
		var data = "itemID=${s_itemID}&srType=${srType}&showElement=${showElement}"
					+ "&accMode=${accMode}&currIdx=${currIdx}&showPreNextIcon=${showPreNextIcon}"
					+ "&tLink=${tLink}";	
					
		ajaxPage(url, data, target);
	}
	
	function fnClickChkAll(){
		<c:forEach var="list" items="${fileItemList}" varStatus="status">	
			try{
				var checkObj = document.all("chkItem_${list.ItemID}");
				if(checkObj != null){
					if(document.all("chkItem_all").checked){
						checkObj.checked = true;
					}else{
						checkObj.checked = false;
					}
				}
			}catch(e){}
		</c:forEach>
	}
	
	function fnTotalSearch(){ // 검색 돋보기 클릭시 	
		var searchValue = $("#searchValue2").val();
		if(searchValue != ""){			
			$("#AT00001Value").val(searchValue);
		} else {
			return;
		}
		searchValue = searchValue.replace(",","comma");
		var param ="&s_itemID=${s_itemID}&searchValueAT00001="+searchValue+"&childLevel=15&showID=${showID}&CategoryCode=OJ";
		$.ajax({
			url : "getFileItemList.do",
			type: 'get',
			data: param,
			error: function(xhr, status, error) { 
			},
			success: function(data){	
				var jsonObj = JSON.parse(data);
				fnLoadList(data, jsonObj.length);	
			}
		});	         
	}
	
	function fnDetailSearch(){ //상세검색 
		var searchValue = $("#AT00001Value").val().replace(",","comma");	
		var searchValueText = $("#searchValueText").val().replace(",","comma");
		var status = $("#status").val();
		var teamName = $("#teamName").val();
		var authorName = $("#authorName").val();
		var startDT = $("#startDT").val();
		var endDT = $("#endDT").val();
		
		var param ="&CategoryCode=OJ&s_itemID=${s_itemID}&searchValueAT00001="+searchValue+"&childLevel=15"
			+ "&searchValueText="+searchValueText+"&status="+status+"&teamName="+teamName
			+ "&authorName="+authorName+"&startDT="+startDT+"&endDT="+endDT;
		
		$.ajax({
			url : "getFileItemList.do",
			type: 'get',
			data: param,
			error: function(xhr, status, error) { 
			},
			success: function(data){	
				var jsonObj = JSON.parse(data);
				fnLoadList(data, jsonObj.length);	
			}
		});	         
	}
	
	function fnOpenFileItemPop(pID, e){
		e.stopPropagation();
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		
		var accMode = "${accMode}";
		if(accMode == ""){
			accMode = "OPS";
		}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+pID+"&scrnType=pop&screenMode=pop&accMode="+accMode;
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	function fnOpenParentItemPop(pID){
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId);
		} else {
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+pID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	}
	
	function clearSearchCon() {
		$("#AT00001Value").val("");
		$("#searchValueText").val("");
		$("#status").val("");
		$("#teamName").val("");
		$("#authorName").val("");
		$("#startDT").val("");
		$("#endDT").val("");
	}
	
</script>	
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>
<form name="fileItemFrm" id="fileItemFrm" method="post">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />	
	<input type="hidden" id="sysFileName" name="sysFileName">
	<input type="hidden" id="originalFileName" name="originalFileName">
	<input type="hidden" id="filePath" name="filePath" >
	<input type="hidden" id="seq" name="seq" >	
	<input type="hidden" id="filtered" value="Y"> 
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="currIdx" value="">
	<input type="hidden" id="openItemList" value="">	
	<input type="hidden" id="itemArrayList" name="itemArrayList">
   	<input type="hidden" id="fileArrayList" name="fileArrayList">
   	<input type="hidden" id="searchKey" name="searchKey" value="Name">
   	<input type="hidden" id="searchQuery" name="searchQuery">
   	<input type="hidden" id="itemIDs" name="itemIDs">
   	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode">
    </form>
	<div id="fileItemListDiv" style="height:100%;">
	<div id="titWrap" style="width:100%;line-height: 44px;border-bottom: 1px solid #cfe7ff;background: #f7f9fd;" class="align-center flex justify-between">
		<div class="pdL20">
			<c:choose>
		   		<c:when test="${itemInfo.CategoryCode eq 'MCN' || itemInfo.CategoryCode eq 'CN' || itemInfo.CategoryCode eq 'CN1' }" >
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" onclick="fnOpenFileItemPop('${itemInfo.CxnFromItemID}',event);" style="cursor:pointer;vertical-align: text-bottom !important;">&nbsp;${itemInfo.FromItemName}
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" onclick="fnOpenFileItemPop('${itemInfo.CxnToItemID}',event);" style="cursor:pointer;vertical-align: text-bottom !important;">&nbsp;${itemInfo.ToItemName}
				 <c:if test="${itemInfo.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${itemInfo.ItemName}</b></font> </c:if>
		   		</c:when>
		   		<c:otherwise>
					<c:forEach var="path" items="${itemPath}" varStatus="status">
							<span style="cursor:pointer;color:#698AA3;font-size:14px;" onclick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
							<span class="path_divider"></span>
					</c:forEach>
				  	<b style="font-size:14px;">${itemInfo.ItemName}</b>
		   		</c:otherwise>
		   	</c:choose>
	   </div>
		<div class="icon_color_inherit flex mgR10" style="color: #767676;">
			<i class="mdi mdi-restore h40-icon" onclick="fnFileItemReload()"></i>
			<i class="mdi mdi-dock-left h40-icon" id="listToggle"></i>
		</div>
	</div>
	
	<div id="fileItemHeaderDiv">		
		<div class="align-center flex justify-between pdL10 pdR10 mgT10">
			<div class="flex align-center">
				<div class="align-center flex mgL10 mgR10 mgT1">
					<input type='checkbox' id='chkItem_all"' class="mgL5 mgR6" name='chkItem_all' onclick="fnClickChkAll()" value='all'>
					<span id="TOTCNT"></span>
					<div class="box_col1 flex mgT1 search_box mgL20" style="height:32px;border:1px solid #dfdfdf;border-radius:3px;">
						<input type="text" id="searchValue2" name="searchValue2" class=" stext pdL10" style="background:none; font-size: 12px;width: 240px; border:none;">
						<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="Search" onclick="fnTotalSearch();" style="width: 21px;height: 23px;padding: 5px 8px;"></div>
					<div class="box_col1 flex mgT1 search_box" style="height:32px;">
						<button class="detail" id="btnDetail">${menu.LN00108}</button>
					</div>
				</div>
			   	<c:if  test="${pop != 'pop' }" >
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && myItem eq 'Y'}">			    		
						<button class="cmm-btn mgR5" onclick="fnRegisterFileItem()">Register Item</button>
						<button class="cmm-btn mgR5" onclick="fnFileItemEditMulitiItemID()">Edit ID/Name</button>
						<button class="cmm-btn mgR5" onclick="fnClickedMoveItem()">Move</button>
						<button class="cmm-btn mgR5" onclick="fnEditCheckedAllItems('Owner')">Gov</button>
		   				<c:if test="${blocked != 'Y'}">							
							<button class="cmm-btn btnred" onclick="fnDeleteItem()">Del</button>
						</c:if>
					</c:if>
				</c:if>
			</div>
		</div>
		<!-- 상세검색 -->		
		<div class="search_detail" id="search_detail" style="display:none;">
			<div class="box_col1 mgL20">
				<div class="title">${menu.LN00028}</div>
				<input type="text" id="AT00001Value" name="AT00001Value" class="stext">
			</div>
			<div class="box_col1 mgL20">
				<div class="title">${menu.LN00003}</div>
				<input type="text" id="searchValueText" name="searchValueText" class="stext">
			</div>
			<div class="box_col1 mgL20">
				<div class="title">${menu.LN00027}</div>
					<select id="status" name="status" class="sel"></select>
			</div>
			<span style="display: block; height: 10px;"></span>
			<div class="box_col1 mgL20">
				<div class="title">${menu.LN00018}</div>
				<input type="text" id="teamName" value="${teamName}" name="teamName" class="stext">
			</div>
			<div class="box_col1 mgL20">
				<div class="title">${menu.LN00004}</div>
				<input type="text" id="authorName" name="authorName" class="stext">
			</div>
			<div class="box_col2 mgL20">
				<div class="title">${menu.LN00070}</div>
				<input type="text" id="startDT" name="startDT" value=""	class="text datePicker mgR6" size="8" style="width: 117px" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				-
				<input type="text" id="endDT" name="endDT" value=""	class="text datePicker mgL6" size="8" style="width: 117px" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</div>
			<div style="display: inline-block;">
				<button onclick="fnDetailSearch()" class="submit_detail">Search</button>
				<button onclick="clearSearchCon()" class="submit_detail clearBtn">Clear</button>
			</div>
		</div>
	</div>
		
	<div class="flex mgL10 mgR10 mgT10" id="fileItemDiv" style="height: calc(100% - 116px);">
		<div id="grid_area">
			<div style="width: 100%;" id="layout"></div>
			<div style="width: 100%;height: calc(100% - 62px);" id="list"></div>
			<div id="pagination" style="padding: 0 20px;"></div>
		</div>
		<div class="block" id="hr"></div>	
		<div id="tab_area" class="block" <c:if test="${accMode ne 'DEV'}">style="overflow-y: auto;"</c:if>>	             
			<div style="width: 100%; box-sizing: border-box;" id="tab_detail_area"></div>	
		</div>
	</div>
	<div id="sch_content" style="height: calc(100% - 120px);display: block;width: 100%;padding: 0 10px;box-sizing:border-box;">		
        <iframe name="contentFrame" id="contentFrame" src="" style="width:100%;height:100%;" frameborder="0"></iframe> 	
    </div>
   </div>
<script>
	const btnDetail = document.querySelector("#btnDetail");
	const search_detail = document.querySelector("#search_detail");
	const detail_box = document.querySelector("#fileItemHeaderDiv");
	btnDetail.addEventListener("click", (event) => {
		if(event.pointerType !== "") {
			detail_box.className = detail_box.className.includes("show_detail") ? "" : "show_detail";
			if(search_detail.style.display == "none") {
				search_detail.style.display = "inline-block";
				document.querySelector("#sch_content").style.height = "calc(100% - 280px)";
				document.querySelector("#fileItemDiv").style.height = "calc(100% - 200px)";
			} else {
				search_detail.style.display = "none";
				document.querySelector("#sch_content").style.height = "calc(100% - 120px)";
				document.querySelector("#fileItemDiv").style.height = "calc(100% - 116px)";
			}
		}
	});
	
	const listToggle = document.querySelector("#listToggle");
	let clsName = document.querySelector("#listToggle").className;
	
	clsName = "mdi mdi-format-list-bulleted h40-icon";
	document.querySelector("#hr").className = "none";
	document.querySelector("#tab_area").className = "none";
	document.querySelector("#grid_area").style.width = "100%";
	document.querySelector("#listToggle").className = clsName;
	
	listToggle.addEventListener("click", (event) => {
		if(clsName.includes("mdi-dock-left")) {
			clsName = "mdi mdi-format-list-bulleted h40-icon";
			document.querySelector("#hr").className = "none";
			document.querySelector("#tab_area").className = "none";
			document.querySelector("#grid_area").style.width = "100%";
		} else {
			clsName = "mdi mdi-dock-left h40-icon";
			document.querySelector("#hr").className = "block";
			document.querySelector("#tab_area").className = "block";
			document.querySelector("#grid_area").style.width = "";
		}
		document.querySelector("#listToggle").className = clsName;
	});
	
	function on_mouse_down(e) {
		isEnable = true;
		return false;
	}
	
	function on_mouse_up(e) {
		isEnable = false;
		return false;
	}
	
	function on_mouse_move(e) {
		if (isEnable) {
			document.getElementById("grid_area").style.width = event.clientX - 15 + "px";
		}
	}
	
	//============================= dhtmlx 7.1 Start ==========================================================================================================
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var list;
	var listData = ${fileItemListData};
	var showID = "${showID}";
	var pagination;
	
	function template(item) {
		let statusClass = "";
		switch (item.Status) {
			case "NEW1" :
			case "NEW2" :
				statusClass = "new";
				break;
			case "DEL1" :
			case "DEL2" :
				statusClass = "del";
				break;
			case "MOD1" :
			case "MOD2" :
				statusClass = "mod";
				break;
			default : 
				statusClass = "";
				break;
		}
	    let template = "<div class='align-center flex justify-between'>"
	    	template += "	<div class='flex align-center' style='width: calc(100% - 75px);'>"
	    	
	         	template += "	<input type='checkbox' class='checkbox mgR15' id='chkItem_"+item.ItemID+"' name='chkItem_"+item.ItemID+"' value='"+item.ItemID+"'>";
	        
// 	        template += "		<div class='flex-column list_item mgR15'>";
	        //template += "			<img src='${root}${HTML_IMG_DIR_ITEM}/"+item.ItemClassImg+"' class='mgR15' >";
// 	        template += "			<img src='${root}${HTML_IMG_DIR_ITEM}/"+item.FileIcon+"' onclick=fnClickedFileIcon("+ item.ItemID + ",'"+item.FileIcon+"'); style='align-self: center' class='mgT10'>"
// 	        template += "			<span></span>";
// 	        template += "		</div>";
// 	        template += "		<div class='flex align-center'>";
	       	if(showID == "Y"){
	        	template += "			<span class='mgR10' style='text-overflow: ellipsis; overflow: hidden; white-space: nowrap;'>" + item.Identifier +"&nbsp;"+ item.ItemName +"</span>";
	        }else{
	       		template += "			<span class='mgR10' style='text-overflow: ellipsis; overflow: hidden; white-space: nowrap;'>" + item.ItemName +"</span>";
	        }
	        if(statusClass !== "") 
	        	template += "			<span class='mgR10 "+statusClass+"' style='white-space: nowrap;'>"+item.StatusName+ "</span>";
			if(!item.FileIcon.includes("blank"))
	        	template += "			<img src='${root}${HTML_IMG_DIR_ITEM}/"+item.FileIcon+"' onclick=fnClickedFileIcon("+ item.ItemID + ",'"+item.FileIcon+"',event); style='align-self: center' class='mgR10'>"
	        	template += "			<i class='mdi mdi-vector-arrange-above' onclick='fnOpenFileItemPop("+item.ItemID+",event)' style='color: #767676;cursor:pointer;'></i>";
// 	        template += "					<span>"+item.Name+"("+item.OwnerTeamName+")"+"</span><span class='divider'></span>";
// 			template += "		</div>";
	        template += "	</div>";
 	        template += "	<span>"+item.LastUpdated+"</span>";
	        template += "</div>";
	    return template;
	};
	
	function fnLoadList(resultdata, totalCnt){
	 	if (list) { list.destructor(); }
	 	if (pagination) { pagination.destructor(); }
		$("#TOTCNT").html("Total&nbsp;"+totalCnt);
		list = new dhx.List("list", {
		    template: template
		});
	
		list.data.parse(resultdata);
		
		list.events.on("click", function (id, e) {
			if(!e.target.className.includes("checkbox")) {
				
				clsName = "mdi mdi-dock-left h40-icon";
				document.querySelector("#hr").className = "block";
				document.querySelector("#tab_area").className = "block";
				document.querySelector("#grid_area").style.width = "";
				document.querySelector("#listToggle").className = clsName;
				
				const itemID = list.selection.getItem().ItemID;
				const classCode = list.selection.getItem().ClassCode;
				const ClassVarFilter = list.selection.getItem().ClassVarFilter;
				fnOpenTab(itemID,classCode,ClassVarFilter);
			}
		});
		
		document.querySelector("#searchValue2").addEventListener("keyup", function (event) {
	  	const key = event.target.value;
	  	if (key) {
	    	list.data.filter(function(item) {
	    		return item.ItemName.toLowerCase().includes(key.toLowerCase());
	    	});
	  	} else {
	    	list.data.filter();
	  	}
		});
		
		pagination = new dhx.Pagination("pagination", {
		    data: list.data,
		    pageSize: 40,
		});
		
	} 
	
	layout.getCell("a").attach(list);

//============================= dhtmlx 7.1 End ==========================================================================================================
</script>
	