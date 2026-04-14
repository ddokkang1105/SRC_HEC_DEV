<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#itemNameAndPath, #functions{
		display:inline;
	}
	
	.link {
	color: #193598;
	text-decoration: underline;
	cursor:pointer;
	}

</style>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
let itemListData = [];
var r_text, a_text, s_text, i_text, c_text;

	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show(); 
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		$.ajax({
	        url: "/zSKON_cxnRnrList.do",
	        type: "GET",
	        data: {
	        	itemID: ${s_itemID},
	        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
	        },
	        dataType: "json",
	        success: function (response) {
	  			
	        	itemListData = response.list;
	        	r_text = response.r_text;
	        	a_text = response.a_text;
	        	s_text = response.s_text;
	        	i_text = response.i_text;
	        	c_text = response.c_text;
	        	
	        	updateTable();
	        },
	    });     
	});
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2]
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			 var viewerForm = document.viewerForm;
			 var url = "openViewerPop.do";
			 window.open("" ,"viewerForm", "width="+screen.width+", height="+screen.height); 
			 viewerForm.action =url;
			 viewerForm.method="post";
			 viewerForm.target="viewerForm";
			 viewerForm.seq.value = +seq[0];
// 			var url = "openViewerPop.do?seq="+seq[0];
// 			var w = screen.width;
// 			var h = screen.height;
			
			if(avg5 != "") { 
				viewerForm.isNew.value = "N";
// 				url = url + "&isNew=N";
			}
			else {
				viewerForm.isNew.value = "Y";
// 				url = url + "&isNew=Y";
			}
// 			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
// 			//window.open(url,1316,h); 
			
			 viewerForm.submit();
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	function updateTable() {
	    let tableContent = "";
	    itemListData.forEach((item) => {	    
            tableContent = `
            	<td class="alignC last">${"${r_text}"}</td>
            	<td class="alignC last">${"${a_text}"}</td>
            	<td class="alignC last">${"${s_text}"}</td>
            	<td class="alignC last">${"${i_text}"}</td>`; 
    });
	    $("#itemTable").html(tableContent);
	}
	    
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}
	}
	
	function doTcSearchList(){
		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
	}
	
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}
	
	
	function fnOnCheck(rowId,cellInd,state){
		if(state){
			tc_gridArea.setRowColor(rowId, "#f2f8ff");
		}else{
			tc_gridArea.setRowColor(rowId, "#ffffff");
		}
	}
	
	//edit버튼 클릭시
	function fnEditItemInfo() {
	 	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/process/editActivityInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode=${defSiteCode}"
		+"&wfOptopn=V"
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm"); 
	}
	
	//편집 저장후 콜백
	function fnCllbackEdit(itemID) {
		
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/process/editActivityInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}

//===============================================================================


	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenAuthorInfo(authorID) {
		var url = "viewMbrInfo.do?memberID="+authorID;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
</script>
<form name ="viewerForm" >
	<input type="hidden" id="seq" name="seq" value="">
	<input type="hidden" id="isNew" name="isNew" value="">
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">

			<!-- 기본정보 --> 
			<div class="mgB10">
				<div class="flex justify-between align-center pdT10 pdB10">
					<div class="flex align-center">
						<p class="cont_title mgB1" style="width:52px">${menu.LN00005}</p>
						<ul class="mgL20">
							<li class="flex">
								<input type="checkbox" class="mgR3 chkbox" name="subItem" id="subItem_chk" checked><label for="subItem_chk" class="mgR3">${menu.LN00005}</label>
						 		<input type="checkbox" class="mgR3 chkbox" name="subItemFile" id="subItemFile_chk" checked><label for="subItemFile_chk" class="mgR3"> ${menu.LN00019}</label>
							</li>
						</ul>
					</div>
					<c:if test="${screenMode ne 'pop' && accMode ne 'OPS' && (itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev eq '1')}" >
						<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status ne 'DEL1'}" >
							<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
						</c:if>
					</c:if>
				</div>
			<table id="subItem" class="tbl_blue01 pdL10" style="width:100%;margin:5px;" >				
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col>
				</colgroup>
				<!-- Activity명 -->
				<tr>
					<th class="alignC last">${menu.ZLN0109}</th>
					<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;" onclick="doDetail(${prcList.ItemID})">${prcList.ItemName}</td>
				</tr>	
				<tr>			
					<td class="alignC last" colspan="4" >
						<textarea class="tinymceText" style="height:600px;" readonly="readonly">
						<div class="mceNonEditable">${attrMap.AT00003}</div>		
						</textarea>
					</td>
				</tr>
				<!-- R / A / S / I -->			
				<tr>
					<th class="alignC last">${menu.ZLN0126}</th>
					<th class="alignC last">${menu.ZLN0127}</th>
					<th class="alignC last">${menu.ZLN0128}</th>
					<th class="alignC last">${menu.ZLN0129}</th>
				</tr>
				<tr id="itemTable">
				</tr>
				<!-- 입력물 -->	
				<tr>
					<th class="alignC last">${menu.ZLN0110}</th>
					<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${attrMap.AT00015}</td>
				</tr>	
				<!-- 출력물 -->
				<tr>
					<th class="alignC last">${menu.ZLN0111}</th>
					<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${attrMap.AT00016}</td>
				</tr>
				<!-- 수행 시스템 -->	
				<tr>
					<th class="alignC last">${menu.ZLN0112}</th>
					<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${attrMap.ZAT02015}</td>
				</tr>	
			</table>	
			</div>
			
			<!-- 첨부문서 --> 
			<div id="subItemFile" class="mgB30">
				<p class="cont_title">${menu.LN00019}</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<!-- No / 문서유형 / 문서명 / 작성자 / 등록일 -->
						<th>${menu.LN00024}</th>
						<th>${menu.LN00091}</th>
						<th>${menu.LN00101}</th>
						<th>${menu.LN00060}</th>
						<th>${menu.LN00078}</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<tr>
							<td>${no }</td>
							<td>${fileList.FltpName}</td>
							<td class="alignL pdL10 flex align-center">
									<span class="btn_pack small icon mgR20"  onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">
									<c:set var="FileFormat" value="${fileList.FileFormat}" />
										<span class="
												<c:choose>
													<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
													<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
													<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
													<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
													<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
													<c:otherwise>log</c:otherwise>
												</c:choose>
														"></span>
										</span>
										&nbsp;
										<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
							&nbsp;&nbsp;
							<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
							&nbsp;
							<%-- <c:if test="${myItem == 'Y'}"> --%>
							<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
							<%-- </c:if> --%>
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.CreationTime}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>  
 		</div>
	</div>
</form>

</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
