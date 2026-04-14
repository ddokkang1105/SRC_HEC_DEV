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
</style>
<script type="text/javascript">
	$(document).ready(function(){		
		$('.chkbox').click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$('input:checkbox:not(:checked)').each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		var height = setWindowHeight();
		document.getElementById("htmlReport").style.height = (height - 55)+"px";
		modelView();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function modelView(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = "newDiagramViewer.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${itemID}"
					+"&width="+$("#model2").width()
					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&varFilter=${revViewOption}";
		var src = url +"?" + data+"&browserType="+browserType;
 		document.getElementById('model2').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
		$("#model2").attr("style", "display:block;height:600px;border: 0;");
	}
	
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
				filePath[0] = checkObjVal[2];
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
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "Mnado", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	// Model 팝업
	function clickModelEvent(trObj) {
		var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID=${itemID}"
				+"&modelID="+$(trObj).find("#ModelID").text()
				+"&scrnType=view"
 				+"&MTCategory="+$(trObj).find("#MTCategory").text()
				+"&modelName="+encodeURIComponent($(trObj).find("#ModelName").text())
			    +"&modelTypeName="+encodeURIComponent($(trObj).find("#modelTypeName").text())
				+"&menuUrl="+$(trObj).find("#ModelURL").text()
				+"&changeSetID="+$(trObj).find("#ModelCSID").text()
				+"&selectedTreeID=${itemID}";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 관련항목 팝업
	function clickItemEvent(trObj) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+$(trObj).find("#ItemID").text()
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 변경이력 팝업
	function clickChangeHistoryEvent(trObj) {
		var url = "viewItemChangeInfo.do?"
				+"changeSetID="+$(trObj).find("#ChangeSetID").text()
 				+"&StatusCode="+$(trObj).find("#ChangeStsCode").text()
				+"&ProjectID"+$(trObj).find("#ChangeStsCode").text()
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&isItemInfo=Y&seletedTreeId=${itemID}&isStsCell=Y";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
	function fnChangeMenu(menuID,menuName) {
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		$("#viewPageBtn").css('display','block');
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}else if(menuID == "file"){
			var url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}"; 
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);
		}else if(menuID == "report"){
			var url = "objectReportList.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);
		}else if(menuID == "changeSet"){
			var url = "itemHistory.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N&myItem=${myItem}&itemStatus=${itemStatus}";
		 	ajaxPage(url, data, target);
		}else if(menuID == "dimension"){
			var url = "dimListForItemInfo.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&backBtnYN=N";
		 	ajaxPage(url, data, target);
		}
	}
	
	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
	}
	
	function reload(){
		var titleViewOption= "${titleViewOption}";
		var mdlOption= "${revViewOption}";
		if(itemPropURL != "" || itemPropURL != null){
			var itemPropURL = "${url}";
			var avg4 = itemPropURL+","+titleViewOption;
			if(mdlOption != null && mdlOption != ""){
				avg4 += ","+mdlOption;
			}
			setActFrame("viewItemProperty", '', '', avg4,'');
		} else {
			var itemPropURL = "${itemPropURL}";
			parent.fnSetItemClassMenu("viewItemProperty", "${itemID}", "&mdlOption="+mdlOption+"&itemPropURL="+itemPropURL+"&scrnType=clsMain");
		}
	}
</script>

</head>
<body>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div style="height: 20px;padding: 12px 0;">
			<li class="shortcut">
			${prcList.Path}/<font color="#3333FF"><b>&nbsp;${prcList.Identifier}&nbsp;${prcList.ItemName}</b></font>	
			</li>
			<li class="floatR pdR10">
			<c:if test="${titleViewOption ne 'N'}">
			<ul id="nav4" >
				<li id="viewPageBtn" class="viewPageBtn" style="display:none;"><span OnClick="fnViewPage();"><img src="${root}${HTML_IMG_DIR}/ico_arrow_left.png">&nbsp;&nbsp;View Page</span></li>
				<li class="top">				
					<span id="cmbMenu" style="font-size:13px;"><img src="${root}${HTML_IMG_DIR}/icon_pjt_cfg.png">&nbsp;&nbsp;Menu</span>	
					<ul class="sub4" id="layerMenu">	
						<li onclick="fnChangeMenu('report','Report');"><a href="#" alt="report" id="report" >Report</a></li>			
						<c:if test="${menuDisplayMap.FileOption ne  'N'}">
							<li onclick="fnChangeMenu('file','Attachments');"><a href="#" alt="file" id="file">Attachments<font color="#1141a1">(${menuDisplayMap.FILE_CNT})</font></a></li>	
						</c:if>
						<c:if test="${menuDisplayMap.HasDimension eq '1'}">
							<li onclick="fnChangeMenu('dimension','Dimension');"><a href="#" alt="dimension" id="dimension">Dimension<font color="#1141a1">(${menuDisplayMap.DIM_CNT})</font></a></li>
						</c:if>
						<c:if test="${menuDisplayMap.ChangeMgt eq '1'}">
							<li onclick="fnChangeMenu('changeSet','Change history');"><a href="#" alt="changeSet" id="changeSet">Change history<font color="#1141a1">(${menuDisplayMap.CNGT_CNT})</font></a></li>	
						</c:if>			
						<li onclick="fnChangeMenu('management','Management');"><a href="#" alt="management" id="management">Management</a></li>										
					</ul>				
				</li>						
			</ul>
			</c:if>
			</li>
		</div>
		
		<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>
				
		<div id="itemDiv">
			<div style="height: 22px; padding: 10px 0; width: 100%;">
				<ul>
					<li class="floatL pdL10">
						<img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ItemTypeImg}">
						&nbsp;<b>${prcList.ItemName}&nbsp;</b>
						<img src="${root}${HTML_IMG_DIR_ITEM}/img_refresh_02.png" style="width:15px;" id="refresh" onclick="reload()">
					</li>
					<li class="floatR pdR10">
						<input type="checkbox" class="mgR5 chkbox" name="process" checked>ITEM 정보&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="model" checked>모델&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="occurrence">선/후행 Process&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="subItem">액티비티&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="ruleSet">Rule Set&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="kpi">KPI&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="csr">변경이력&nbsp;
					</li>
				</ul>
			</div>	
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">ITEM 정보</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="10%">
						<col width="40%">
						<col width="10%">
						<col width="40%">
					</colgroup>
					<tr>
						<th>${attrNameMap.AT00003}</th>
						<td class="alignL pdL10" colspan="3">${attrMap.AT00003}</td>
					</tr>
					<tr>
						<th>${menu.LN00016}</th>
						<td class="alignL pdL10" colspan="3">${prcList.ClassName}</td>
					</tr>
					<tr>
						<th>${menu.LN00004}</th>
						<td class="alignL pdL10">${prcList.Name}</td>
						<th>${menu.LN00070}</th>
						<td class="alignL pdL10">${prcList.LastUpdated}</td>
					</tr>
					<!-- dimension -->
					<c:forEach var="dimList" items="${dimResultList}" varStatus="status">
					 <tr>
						 <th>${dimList.dimTypeName}</th>
						 <td class="alignL pdL10" colspan="3">${dimList.dimValueNames }</td>
					 </tr>
					 </c:forEach>
					<!-- 첨부 및 관련 문서 --> 
					<tr>
						<th>첨부문서</th>
						<td class="alignL pdL10" colspan="3">
							<div class="floatR pdR20">
							<c:if test="${attachFileList.size() > 0 || pertinentFileList.size() > 0}">
								<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
								<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
							</c:if>
							</div>
							<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
								<input type="checkbox" name="checkedFile" value="${fileList.FileName},${fileList.FileRealName},,${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
							</c:forEach>
							<c:forEach var="relatedfileList" items="${pertinentFileList}" varStatus="status">
								<input type="checkbox" name="checkedFile" value="${relatedfileList.FileName},${relatedfileList.FileRealName},,${relatedfileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');">${relatedfileList.FileRealName}</span><br>
							</c:forEach>
						</td> 
					</tr>
					<c:if test="${showVersion eq '1' && changeMgt eq '1'}">
						<tr>
							<th>${menu.LN00017}</th>
							<td class="alignL pdL10">
								${maxVersion}
							</td> 
							<th>${menu.LN00296}</th>
							<td class="alignL pdL10">
								${maxValidFrom}
							</td> 
						</tr>
					</c:if>
				</table>
			</div>
			
			<!-- BIGIN :: 모델리스트 -->
			<div id="model" class="mgB30">
				<p class="cont_title">모델</p>
	<!-- 			<table class="tbl_preview"> -->
	<%-- 				<colgroup> --%>
	<%-- 					<col width="5%"> --%>
	<%-- 					<col width="25%"> --%>
	<%-- 					<col width="20%"> --%>
	<%-- 					<col width="15%"> --%>
	<%-- 					<col width="10%"> --%>
	<%-- 					<col width="10%"> --%>
	<%-- 					<col width="15%"> --%>
	<%-- 				</colgroup> --%>
	<!-- 				<tbody> -->
	<!-- 					<tr> -->
	<!-- 						<th>No</th> -->
	<!-- 						<th>명칭</th> -->
	<!-- 						<th>모델 유형</th> -->
	<!-- 						<th>카테고리</th> -->
	<!-- 						<th>상태</th> -->
	<!-- 						<th>작성자</th> -->
	<!-- 						<th>수정일</th> -->
	<!-- 					</tr> -->
	<%-- 					<c:set value="1" var="no" /> --%>
	<%-- 					<c:forEach var="modelList" items="${modelList}" varStatus="status"> --%>
	<!-- 						<tr onclick="clickModelEvent(this)"> -->
	<%-- 							<td>${no}</td> --%>
	<%-- 							<td id="ModelName">${modelList.Name}</td> --%>
	<%-- 							<td id="ModelTypeName">${modelList.ModelTypeName}</td> --%>
	<%-- 							<td id="MTCategory">${modelList.MTCName}</td> --%>
	<%-- 							<td>${modelList.StatusName}</td> --%>
	<%-- 							<td>${modelList.UserName}</td> --%>
	<%-- 							<td>${modelList.LastUpdated}</td> --%>
	<%-- 							<td class="tdhidden" id="ModelID">${modelList.ModelID}</td> --%>
	<%-- 							<td class="tdhidden" id="ModelURL">${modelList.URL}</td> --%>
	<%-- 							<td class="tdhidden" id="ModelCSID">${modelList.ChangeSetID}</td> --%>
	<!-- 						</tr> -->
	<%-- 					<c:set var="no" value="${no+1}"/> --%>
	<%-- 					</c:forEach> --%>
	<!-- 				</tbody> -->
	<!-- 			</table> -->
				<iframe width="100%" frameborder="0" scrolling="no" style="border: 0;overflow:auto; padding:0 0 17px 0;" id="model2" class="mgB30" ></iframe>
			</div>
			
			<!-- BIGIN :: 선/후행 Process -->
			<div id="occurrence" class="mgB30">
				<p class="cont_title">선/후행 Process</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="8%">
						<col width="10%">
						<col width="25%">
						<col width="52%">
					</colgroup>
					<tbody>
						<tr>
							<th>No</th>
							<th>구분</th>
							<th>ID</th>
							<th>명칭</th>
							<th>개요</th>
						</tr>
						<c:set value="1" var="no" />
						<c:forEach var="elementList" items="${elementList}" varStatus="status">
							<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
								<td>${no}</td>
								<td>${elementList.KBN}</td>
								<td>${elementList.ID}</td>
								<td class="alignL pdL10">${elementList.Name}</td>
								<td class="alignL pdL10">${elementList.Description}</td>
								<td class="tdhidden" id="ItemID">${elementList.itemID}</td>
							</tr>
						<c:set var="no" value="${no+1}"/>
						</c:forEach>
					</tbody>
				</table>
			</div>
					
			<!-- BIGIN :: 액티비티 -->
			<div id="subItem" class="mgB30">
				<p class="cont_title">액티비티</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="55%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>ID</th>
						<th>명칭</th>
						<th>개요</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="activityList" items="${activityList}" varStatus="status">
					<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
						<td>${no }</td>
						<td>${activityList.Identifier}</td>
						<td class="alignL pdL10">${activityList.ItemName}</td>
						<td class="alignL pdL10">${activityList.AT00003}</td>
						<td class="tdhidden" id="ItemID">${activityList.ItemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
			
			<!-- BIGIN :: Rule set -->
			<div id="ruleSet" class="mgB30">
				<p class="cont_title">Rule set</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="55%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>ID</th>
						<th>명칭</th>
						<th>개요</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00007' }">
					<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
						<td>${no }</td>
						<td>${relItemList.Identifier}</td>
						<td class="alignL pdL10">${relItemList.ItemName}</td>
						<td class="alignL pdL10">${relItemList.ProcessInfo}</td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>
			
			<!-- BIGIN :: KPI -->
			<div id="kpi" class="mgB30">
				<p class="cont_title">KPI</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="55%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>ID</th>
						<th>명칭</th>
						<th>개요</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00008' }">
					<tr onclick="clickItemEvent(this)" style="cursor: pointer;">
						<td>${no }</td>
						<td>${relItemList.Identifier}</td>
						<td class="alignL pdL10">${relItemList.ItemName}</td>
						<td class="alignL pdL10">${relItemList.ProcessInfo}</td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>
			
			<!-- BIGIN :: 변경이력 -->
			<div id="csr" class="mgB30">
				<p class="cont_title">변경이력</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="13%">
						<col width="12%">
						<col width="10%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>Version</th>
						<th>변경구분</th>
						<th>담당자</th>
						<th>시작일</th>
						<th>수정일</th>
						<th>승인일</th>
						<th>상태</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="historyList" items="${historyList}" varStatus="status">
					<tr onclick="clickChangeHistoryEvent(this)">
						<td>${no }</td>
						<td>${historyList.Version}</td>
						<td>${historyList.ChangeType}</td>
						<td>${historyList.RequestUserName}</td>
						<td>${historyList.RequestDate}</td>
						<td>${historyList.CompletionDate}</td>
						<td>${historyList.ApproveDate}</td>
						<td>${historyList.ChangeSts}</td>
						<td class="tdhidden" id="ChangeSetID">${historyList.ChangeSetID}</td>
						<td class="tdhidden" id="ChangeStsCode">${historyList.ChangeStsCode}</td>
						<td class="tdhidden" id="ProjectID">${historyList.ProjectID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
</form>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
