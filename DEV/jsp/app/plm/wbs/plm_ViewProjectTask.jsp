<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<script type="text/javascript">
	
	$(document).ready(function(){
		var height = setWindowHeight();
		if(document.getElementById('PlmViewPjtDIV')!=null&&document.getElementById('PlmViewPjtDIV')!=undefined){
			document.getElementById('PlmViewPjtDIV').style.height = (height)+"px";
		};
		
		window.onresize = function(){
			height = setWindowHeight();
			document.getElementById('PlmViewPjtDIV').style.height = (height)+"px";
		};
		var subTabMenuSize = parseInt("${subTabMenuListSize}");
		if(subTabMenuSize > 0) setFrame("${firstSubTabMenu.URL}","${firstSubTabMenu.Sort}","${firstSubTabMenu.MenuFilter}","${firstSubTabMenu.VarFilter}","${firstSubTabMenu.MenuID}");
		
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//ajax에서 페이지에 넘길 변수값들 지정
	function getData(avg, avg1, avg2){
		var Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID=${s_itemID}"
				+"&MenuID="+avg2
				+ avg + "&fromModelYN=${fromModelYN}"
				+ "&instanceNo=${ElmInstInfo.ElmInstNo}"
				+ "&instanceClass=${instanceClass}"
				+ "&elmItemID=${ElmInstInfo.ElmItemID}";
		
		// 테이불 TB_MENU_ALLOC 컬럼 Varfilter 내용 추가
		if(avg1 != '' || avg1 != null){
			Data = Data + "&varFilter=" + avg1;
		}
		
		/* 하위 항목 이나 검색 화면에서 본 화면을 popup으로 표시 했을때 버튼 제어를 위해 screenMode 파라메터를 넘겨줌 */
		var screenMode = "${screenMode}";
		if (screenMode == 'pop') {
			Data = Data + "&screenMode=${screenMode}";		
		}
		return Data;
	}

	function setFrame(avg, avg2, avg3, avg4,avg5){
		var browserType="";
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = avg+".do";
		var data = getData(avg3,avg4,avg5);
		var target = "cfgFrame";
		var src = url +"?" + data+"&browserType="+browserType;
		var idx = (window.location.href).lastIndexOf('/');
		var height = (setWindowHeight() - $(".wrapView").height())-110;
		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
		$("#cfgFrame").empty();
		$("#cfgFrame").attr("style", "display:block;height:"+ height +"px;");
		ajaxTabPage(url, data, target);
	}


	var SubTabNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#cli"+SubTabNum).addClass('on');
		
		$('.SubTab ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('cli', '') != SubTabNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubTabNum : ' + SubTabNum);
		}).click(function(){
			$(".SubTab ul li").removeClass("on"); //Remove any "active" class
			$(this).addClass('on');
			SubTabNum = $(this).attr('id').replace('cli', '');
		});
	});

	function LayerPopupView(sLinkName, sDivName)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("cfgFrame").scrollTop;
		var nTop = 140;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft + 10) + "px";
	}
	
	function showFitWindow(){
		$(".wrapView").hide();
		$("#fitWindow").attr('onClick','hideFitWindow()');
	}
	
	function hideFitWindow(){
		$(".wrapView").show();
		$("#fitWindow").attr('onClick','showFitWindow()');
	}
	
	/* 의견공유, 변경이력, 관련문서, Dimension 등의 화면으로 이동 */
	function goMenu(avg){
		var url = "";
		var target = "PlmViewPjtDIV";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}"
					+ "&instanceNo=${procInstanceInfo.ProcInstNo}"
					+ "&objectType=${procInstanceInfo.ObjectType}"
					+ "&processID=${procInstanceInfo.ProcessID}"; 
		
		if (avg == "fileMgt") {
			url = "pim_instanceFileList.do?&fileOption=${menuDisplayMap.FileOption}";
		} else if (avg == "changeMgt") {
			url = "itemHistory.do"; // 변경이력
			data = data + "&myItem=${myItem}&itemStatus=${itemStatus}";
		} else if (avg == "forum") {
			url = "forumMgt.do"; // 의견공유
		} else if (avg == "dim") {
			url = "dimListForItemInfo.do"; // Dimension
		} else if (avg == "model") {
			url = "getModelListGrid.do"; // Model
			data = data + "&filter=subElement&isFromMain=Y";
		} else if (avg == "rev") {
			url = "revisionList.do?docCategory=ITM"; // Revision
		} 
		
		ajaxPage(url, data, target);
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

		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";
		ajaxSubmitNoAdd(document.PLMFrm, url,"blankFrame");
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
	
	/* edit */
	function goProcInstanceInfoEdit() {	
	    var url = "editElmInstInfo.do";
		var target = "PlmViewPjtDIV";
		var data = "s_itemID=${masterItemID}"
					+ "&ProcInstNo=${procInstanceInfo.ProcInstNo}"
					+ "&ElmInstNo=${ElmInstInfo.ElmInstNo}"
					+ "&elmItemID=${ElmInstInfo.ElmItemID}"
					+ "&instanceClass=ELM";
	 	ajaxPage(url, data, target);
		
	}
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnOpenWBSPop(){		
		var url = "pim_ViewProjectWBS.do";		
		window.open(url,'','width=1200, height=600, left=200, top=100,scrollbar=yes,resizable=yes');
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
		
		var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";
		ajaxSubmitNoAdd(document.PLMFrm, url,"blankFrame");
		
	}
	
</script>
<div id="PlmViewPjtDIV" style="width:100%; float:left; overflow-y:auto">
<form name="PLMFrm" id="PLMFrm" action="" method="post" onsubmit="return false;">
<div class="pdL10 pdR10 wrapView" style="float:left;" >
	<div class="instance_title">
		<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img><p><b>${ElmInstInfo.ElmInstName}</b></p>
		<ul>
			<li class="floatR">
				&nbsp;<span class="btn_pack small icon"><span class="wbs"></span><input value="WBS" type="submit" onclick="fnOpenWBSPop();"></span>
				&nbsp;<span class="btn_pack small icon"><span class="process"></span><input value="Process" type="submit" onclick="fnOpenItemPop(${ElmInstInfo.ElmItemID});"></span>
				&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goProcInstanceInfoEdit();"></span>
				<!-- &nbsp;<span class="btn_pack small icon"><span class="report"></span><input value="Documents" type="submit" onclick="goMenu('fileMgt');"></span> -->
			</li>
	    </ul>
	</div>
	
	<table style="table-layout: fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="instance_table">
		<colgroup>
			<col width="11%">
			<col width="22%">
			<col width="11%">
			<col width="22%">
			<col width="11%">
			<col width="22%">
		</colgroup>
		<tr>
			<th class="viewtop">제품군</th>
			<td class="viewtop" colspan="5">${dimPath}</td> <!-- P1110  청정원/장류/고추장   -->
		</tr>
		<tr>	
			<th>과제코드</th>
			<td>${procInstanceInfo.Identifier}</td>
			<th>과제명</th>
			<td>${procInstanceInfo.ItemName}</td>
			<th>과제책임자</th>
			<td>${procInstanceInfo.OwnerName}</td>
		</tr>
		<tr>	
			<th>작성자</th>
			<td>${ElmInstInfo.ActorName}</td>
			<th>작성부서</th>
			<td>${ElmInstInfo.ActorTeamName}</td>
			<th>작성일</th>
			<td>${ElmInstInfo.LastUpdated}</td>
		</tr>
		<tr>
			<!-- 첨부 및 관련 문서 --> 
			<th style="height:53px;">${menu.LN00019}</th>
			<td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div class="floatR pdR20">
				<c:if test="${attachFileList.size() > 0 || pertinentFileList.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
					<input type="checkbox" name="checkedFile" value="${fileList.FileID}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.FileID}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
				</c:forEach>
				<c:forEach var="relatedfileList" items="${pertinentFileList}" varStatus="status">
					<input type="checkbox" name="checkedFile" value="${relatedfileList.Seq}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');">${relatedfileList.FileRealName}</span><br>
				</c:forEach>
				</div>
			</td> 
		</tr>
	</table>

	<!-- BIGIN :: 속성 -->
	<c:if test="${attributesList.size() > 0}">
	<div id="attrList">
		<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
			<c:forEach var="attrList" items="${attributesList}" varStatus="status">
				<c:choose>
		   		<c:when test="${columnNum2YN eq 'N' }" >
		   			<colgroup>	
						<col width="11%">
						<col width="89%">
					</colgroup>
		   		</c:when>
		   		<c:otherwise>
		   			<colgroup>	
						<col width="11%">
						<col width="39%">
						<col width="11%">
						<col width="39%">
					</colgroup>
		   		</c:otherwise>
	   		</c:choose>				
			<tr>
				<th>
					<c:if test="${attrList.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name}
				</th>
				<td class="tdLast alignL pdL5"
				<c:if test="${attrList.DataType eq 'Text'}">style="height:${attrList.RowHeight}px;" </c:if>
				<c:if test="${attrList.ColumnNum2 ne '2' }"> colspan="3" </c:if>
				>
					<c:if test="${attrList.HTML eq '1'}">
						<div style="width:100%;height:${attrList.RowHeight}px;">
							<textarea class="tinymceText" readonly="readonly">
							 	${attrList.PlainText}
							</textarea>
						</div>
					</c:if>
					<c:if test="${attrList.HTML ne '1'}">	
						<c:if test="${attrList.Link == null}">
						<textarea style="width:100%;height:${attrList.RowHeight}px;" readonly="readonly">${attrList.PlainText}</textarea></c:if>
						<c:if test="${attrList.Link != null || attrUrl != null}" >
							<a onClick="fnRunLink('${attrList.URL}','${attrUrl}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
							${attrList.PlainText}
							</a>
						</c:if>
					</c:if>
				</td>
				<!-- 두번째 컬럼   -->
				<c:if test="${attrList.ColumnNum2 eq '2' }">
				<th>
					<c:if test="${attrList.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name2}
				</th>
				<td class="tdLast alignL pdL5"
				<c:if test="${attrList.DataType2 eq 'Text'}">style="height:${attrList.RowHeight2}px;" </c:if>
				>
					<c:if test="${attrList.HTML2 eq '1'}">
						<div style="width:100%;height:${attrList.RowHeight2}px;">
							<textarea class="tinymceText" readonly="readonly">${attrList.PlainText2}</textarea>
						</div>
					</c:if>
					<c:if test="${attrList.HTML ne '1'}">	
						<c:if test="${attrList.Link2 == null}">
						<textarea style="width:100%;height:${attrList.RowHeight2}px;" readonly="readonly">${attrList.PlainText2}</textarea></c:if>
						<c:if test="${attrList.Link2 != null || attrUrl != null}" >
							<a onClick="fnRunLink('${attrList.URL2}','${attrUrl}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
							${attrList.PlainText2}
							</a>
						</c:if>
					</c:if>
				</td>
				</c:if>
			</tr>													
		</c:forEach>
		<c:if test="${relItemRowList.size() > 0}">
		<tr>
			<td colspan="4" class="hr1">&nbsp;</td>
		</tr>
		</c:if>
	</table>				
	</div>
	</c:if>
</div>
	
<div class="pdL10 pdR10">
	<div class="SubTab" style="margin-top:20px;">
		<ul>
			<c:set value="1" var="tabNum" />
			<c:forEach var="i" items="${subTabMenuList}" varStatus="status">
				<li id="cli${tabNum}" onclick="setFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
			<c:set var="tabNum" value="${tabNum+1}"/>
			</c:forEach>
		</ul>
		<div class="instance_top_btn"><a id="fitWindow" onclick="showFitWindow()"><img src="${root}${HTML_IMG_DIR}/icon_fitwindow.png" /></a></div>
	</div>
</div>

<div id="cfgFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;" ></div>
<form style="border: 0" name="subFrame" id="subFrame"></form>
	
<c:forEach var="i" items="${getList}" varStatus="status" >
	<c:if test="${status.count == '1' }" >
		<script>
		setFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '<c:out value="${i.VarFilter}" />', '<c:out value="${i.MenuID}" />');
		</script>	
	</c:if>
</c:forEach>
</form>
</div>	

