<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
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
		setFrame(3);
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

	function setFrame(avg){
		var url = "";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&elmItemID=${elmItemID}"
			+ "&fromModelYN=${fromModelYN}"
			+ "&instanceNo=${procInstanceInfo.ProcInstNo}"
			+ "&instanceClass=${instanceClass}"
			+ "&processID=${procInstanceInfo.ProcessID}";
		var target = "cfgFrame";
		if(avg == 1){
			url = "elmInstFileList.do";
		} else if (avg == 2){
			url = "forumMgt.do";
			data += "&s_itemID=${elmItemID}&projectID=${procInstanceInfo.ProjectID}&elmInstNo=${elmInstNo}";
			
		} else if (avg == 3){
			url = "elmInstAttr.do";
			data += "&elmInstNo=${elmInstNo}&scrnMode=V&testCase=Y";
		}else if(avg == 4){
			url = "InstanceFileList.do";
			data += "&elmInstNo=${elmInstNo}";
		}
		ajaxTabPage(url, data, target);
	}


	var SubTabNum = 3; /* 처음 선택된 tab메뉴 ID값*/
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
	
	function fnHideTable() {
		var tempSrc = $("#fitWindow").attr("src");
		if($("#fitWindow").hasClass("frame_show")) {
			//$("#wrapView").hide();
			var height = $("#wrapView").height();
			$("#wrapView").attr("style","display:none");
			$("#bottomView").attr("style","position:relative;");
			$("#PlmViewPjtDIV").scrollTop(0);
			$("#fitWindow").attr("class","frame_hide");
			$("#fitWindow").attr("alt","${WM00159}");
		}
		else {
			$("#wrapView").attr("style","display:block");
			$("#bottomView").attr("style","position:relative;");
			$("#fitWindow").attr("class","frame_show");
			$("#fitWindow").attr("alt","${WM00158}");
		}
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
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.PLMFrm, url,"saveFrame");
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
		
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.PLMFrm, url,"saveFrame");
		
	}
		
	function fnItemLinkLayer(itemID, layerID, classCode){ 
		var layerWindow = $('.connection_layer');
		var pos = $('#'+layerID).offset(); 
		linkLayerPopupView(layerID, 'connectionPopup', pos);
		
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("wrapView").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
		fnSetLinkList(itemID, classCode);
	}
	
	function fnSetLinkList(itemID, classCode){
		var data="itemID="+itemID+"&itemClassCode="+classCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var returnData;
		var layerOpen = "Y";
		$.ajax({   
			url : "getAttrLinkList.do",     
			type: "POST",     
			data : data,
			//dataType :  'json',
			//contentType: "application/x-www-form-urlencoded; charset=utf-8",
			beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
			success: function(returnData){
				var arrReturnData = returnData.split("/");
				var link = arrReturnData[0].split(",");
				var url = arrReturnData[1].split(",");				
				var lovCode = arrReturnData[2].split(",");
				var attrTypeCode = arrReturnData[3].split(",");
				var cnt = arrReturnData[4].split(",");
				var linkLayer ="";
				linkLayer += "<tr>";
				linkLayer += "<td style='cursor:hand;height:20px;' onClick='fnOpenItemPop("+itemID+");' class='alignL last'>${menu.LN00138}</td>";
				linkLayer += "</tr>"; 
				
				if(cnt > 0){					
					for(var i=0; i<link.length; i++){ 
						$("#url").val(url[i]);
						$("#lovCode").val(lovCode[i]);
						linkLayer += "<tr>";
						linkLayer += "<td height='20px' style='cursor:hand;' onClick='fnGoLink("+itemID+",\""+attrTypeCode[i]+"\");' class='alignL last'> "+link[i]+"</td>";
						linkLayer += "</tr>";
					}
					$('.connection_layer').addClass('open');
					$('#link').html(linkLayer);
				}else{
					fnOpenItemPop(itemID);					
				} 				
			},     
			error: function (jqXHR, textStatus, errorThrown)     {       }
			});
	}
	
	function fnGoLink(itemID, attrTypeCode){ 
		var lovCode = $("#lovCode").val();
		var url = $("#url").val();
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}else{		
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;	
		}
		window.open(url,'_newtab');
	}
	
	/* 관련항목 메뉴 popup창에 표시 : 상세항목정보, link 메뉴 */
	function linkLayerPopupView(sLinkName, sDivName, pos)  { 
		var nTop = pos.top;
		var nLeft = pos.left;
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("wrapView").scrollTop;
		oPopup.style.top = (oLink.offsetTop + nTop - 130) + "px";
		oPopup.style.left = nLeft +"px";
	} 
	
	function fnCloseLayer(){
		var layerWindow = $('.connection_layer');
		layerWindow.removeClass('open');
	}
</script>
<div id="PlmViewPjtDIV" style="width:100%; float:left; overflow-y:auto">
<form name="PLMFrm" id="PLMFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="lovCode" name="lovCode"  value="" />
	<input type="hidden" id="url" name="url" >
<div class="pdL10 pdR10 wrapView pdB10" id="wrapView" style="float:left;" >
	<div class="child_search01 pdT6 pdB5">
		<ul>
			<li class="floatL"><h3 class="floatL"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Test Case Information</h3></li>
<!-- 			<li class="floatR"> -->
<%-- 			&nbsp;<span class="btn_pack small icon"><span class="process"></span><input value="Activity" type="submit" onclick="fnOpenItemPop(${ElmInstInfo.ElmItemID});"></span> --%>
			<!-- span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goProcInstanceInfoEdit();"></span-->
<!-- 			</li> -->
	    </ul>
	</div>
	
	<table style="table-layout: fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
		<colgroup>
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
		</colgroup>
		<tr>	
			<th>${menu.LN00268}</th>
			<td>
				<span style="width: calc(100% - 53px); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: inline-block;">${ElmInstInfo.ProgramIdentifier} ${ElmInstInfo.ProgramName}</span>
				<span style="width: 50px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: inline-block; text-align: left;">(${AT00037})</span>
			</td>
			<th>명칭</th>
			<td onclick="fnOpenItemPop(${ElmInstInfo.ElmItemID});" style="text-decoration: underline;cursor: pointer;">${ElmInstInfo.Identifier} ${ElmInstInfo.elmItemName}</td>
			<th>${menu.LN00369}</th>
			<td>${procInstanceInfo.ProcInstanceNM}</td>
			<th>Role</th>
			<td class="last">${ElmInstInfo.roleName}</td>
		</tr>
		<tr>	
			<th>${menu.LN00004}</th>
			<td>${ElmInstInfo.actorName}</td>
			<th>테스트일</th>
			<td>${ElmInstInfo.endTime}</td>
			<th>테스트 결과</th>
			<td>${AT00402 }</td>
			<th>상태</th>
			<td class="last">${ElmInstInfo.StatusNM}</td>
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
					<input type="checkbox" name="checkedFile" value="${fileList.Seq}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
				</c:forEach>
				<c:forEach var="relatedfileList" items="${pertinentFileList}" varStatus="status">
					<input type="checkbox" name="checkedFile" value="${relatedfileList.Seq}" class="mgL2 mgR2">
					<span style="cursor:pointer;" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');">${relatedfileList.FileRealName}</span><br>
				</c:forEach>
				</div>
			</td> 
		</tr>
		<tr>
			<td colspan="8" class="hr1">&nbsp;</td>
		</tr>		
	</table>
</div>

<div id="bottomView" class="pdL10 pdR10">
	<div class="SubTab" style="margin-top:10px;">
		<ul>
<!-- 			<li id="cli1" onclick="setFrame(1)" class="on"><a><span>사내표준</span></a></li> -->
			<li id="cli3" onclick="setFrame(3)" class="on"><a><span>Attribute</span></a></li>
			<li id="cli4" onclick="setFrame(4)"><a><span>${menu.LN00199}</span></a></li>
			<li id="cli2" onclick="setFrame(2)"><a><span>Feedback</span></a></li>
		</ul>
		<div class="instance_top_btn mgR10" ><a id="fitWindow" class="frame_show" onclick="fnHideTable()"></a></div>
	</div>
	<div id="cfgFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;" ></div>
</div>
</form>
</div>	
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

