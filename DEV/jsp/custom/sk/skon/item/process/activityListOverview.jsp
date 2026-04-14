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
	$(document).ready(function(){
		
		$.ajax({
            url: "/zSKON_getProcessActivity.do",
            type: "GET",
            data: {
                itemID: ${s_itemID},
                languageID: ${sessionScope.loginInfo.sessionCurrLangType}
            },
            dataType: "json",
            success: function (response) {
                itemListData = response.list; 
                
                updateTable();
               
            }
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

//===============================================================================


	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);	
	}
	
	function updateTable() {
	    let tableContent = "";
	    itemListData.forEach((item) => {	    
	            tableContent = `
	            	<td class="alignC last">${"${r_text}"}</td>
	            	<td class="alignC last">${"${a_text}"}</td>
	            	<td class="alignC last">${"${s_text}"}</td>
	            	<td class="alignC last">${"${i_text}"}</td>
	            	<td class="alignC last">${"${c_text}"}</td>`; 
	    });
	    $("#itemTable").html(tableContent);
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
			
			<!-- Activity List --> 
			<div class="mgB30">
				<div class="flex justify-between align-center pdT10 pdB10">
					<div class="flex align-center">
						<!-- 기본정보 -->
						<p class="cont_title mgB1" style="width: 52px;">${menu.LN00005}</p>
					</div>	
				</div>
				<table id="itemTable" class="tbl_blue01 pdL10" style="width:100%;margin:5px;" >				
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col>
				</colgroup>
				<c:forEach var="activity" items="${activityListData}">
					<tr>
						<!-- Activity명 -->
						<th class="alignC last" style="background: #dbf7fa;">${menu.ZLN0109}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;" onclick="doDetail(${activity.ItemID})">${activity.Activity}</td>
					</tr>	
					<tr>			
						<td class="alignL last" colspan="4" >
						<textarea class="tinymceText" style="height:600px;" readonly="readonly">
						<div class="mceNonEditable">${activity.Outline}</div>		
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
					<tr>		
						<td class="alignC last link" id="activity-r-${activity.ItemID}"></td>
						<td class="alignC last link" id="activity-a-${activity.ItemID}"></td>
						<td class="alignC last link" id="activity-s-${activity.ItemID}"></td>
						<td class="alignC last link" id="activity-i-${activity.ItemID}"></td>

						<script>
						    function createLinks(containerId, text, itemID) {
						        let container = document.getElementById(containerId);
						        text = text.replace(/&amp;/g, "&");
						        let texts = text.split("$$ "); 
						        let itemIDs = itemID.split("$$ "); 

						        texts.forEach((text, i) => {
						            text = text.trim(); 
						            if (text && itemIDs[i] !== undefined) {
						                let link = document.createElement("a");
						                link.textContent = text;
						                link.style.display = "block";
						                link.onclick = function(event) {
						                    event.preventDefault();
						                    doDetail(itemIDs[i]);
						                };
						                container.appendChild(link);
						            }
						        });
						    }

						    createLinks("activity-r-${activity.ItemID}", "${activity.r_text}", "${activity.r_ItemID}");
						    createLinks("activity-a-${activity.ItemID}", "${activity.a_text}", "${activity.a_ItemID}");
						    createLinks("activity-s-${activity.ItemID}", "${activity.s_text}", "${activity.s_ItemID}");
						    createLinks("activity-i-${activity.ItemID}", "${activity.i_text}", "${activity.i_ItemID}");
						</script>
						
					</tr>
					<!-- 입력물 -->	
					<tr>
						<th class="alignC last">${menu.ZLN0110}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.Input}</td>
					</tr>
					<!-- 출력물 -->		
					<tr>
						<th class="alignC last">${menu.ZLN0111}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.Output}</td>
					</tr>	
					<!-- 수행 시스템 -->	
					<tr>
						<th class="alignC last">${menu.ZLN0112}</th>
						<td colspan="3" class="alignL last" style="padding:5px 0 5px 10px;">${activity.PerformanceSystem}</td>
					</tr>	
					<c:if test="${itemFileOption ne 'VIEWER' and itemFileOption ne 'PDFCNVT' }">
						<tr>
							<!-- 첨부문서 --> 
							<th style="height:53px;">${menu.LN00019}</th>
							<td style="height:53px;" class="alignL last" colspan="3">
								<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">					
									<c:forEach var="fileList" items="${attachFileActivityList}" varStatus="status">
										<c:if test="${fileList.DocumentID == activity.ItemID}">
										
										<div class="floatR pdR20">
											<c:if test="${fileList.size() > 0}">
												<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
												<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
											</c:if>
										</div>	
										<input type="checkbox" name="checkedFile" value="${fileList.FileName}/${fileList.FileRealName}//${fileList.Seq}" class="mgL2 mgR2">
										<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
										</c:if>
									</c:forEach>							
								</div>
							</td> 
						</tr>
					</c:if>	
					<c:if test="${itemFileOption eq 'VIEWER' || itemFileOption eq 'PDFCNVT' }">
					<tr>
						<!-- 첨부문서 --> 
						<th style="height:53px;">${menu.LN00019}</th>
						<td style="height:53px;" class="alignL last" colspan="3">
							<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
							<div class="floatR pdR20"></div>
							
							<c:forEach var="fileList" items="${attachFileActivityList}" varStatus="status">
								<c:if test="${fileList.DocumentID == activity.ItemID}">
									<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
									&nbsp;&nbsp;
									<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
									&nbsp;
									<%-- <c:if test="${myItem == 'Y'}"> --%>
									<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
									<%-- </c:if> --%>
									<br>
								</c:if>
							</c:forEach>
						</div>
						</td> 
					</tr>
					</c:if> 
					
					<tr>
						<td class="alignL last" colspan="4" style="height: 30px;" ></td>
					</tr>
			  </c:forEach>
			  					
			</table>	
			</div>
 		</div>
	</div>
</form>

</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
