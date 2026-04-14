<meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script type="text/javascript">
$(document).ready(function(){
	var height = setWindowHeight();
	if(document.getElementById('actFrame')!=null&&document.getElementById('actFrame')!=undefined){
		document.getElementById('actFrame').style.height = (height - 60)+"px";
	};
	
	window.onresize = function(){
		height = setWindowHeight();
		document.getElementById('actFrame').style.height = (height - 60)+"px";
	};
	
	<c:forEach var="i" items="${getList}" varStatus="status" >
	<c:if test="${status.count == '1' }" >
		setCfgFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '<c:out value="${i.VarFilter}" />', '<c:out value="${i.MenuID}" />');
	</c:if>
	</c:forEach>
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// TODO : 담당자 정보 표시
	var layerWindow = $('.item_layer_photo');
	$('#authorInfo').click(function(){
		$("#layerPopup2").removeClass("open");
		var pos = $('#authorInfo').position();  
		LayerPopupView('authorInfo', 'layerPopup', pos.top);
		$("#layerPopup").addClass('open');
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("cfgFrame").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
	});
	
	// TODO : Configurator 정보 표시
	$('#actorInfo').click(function(){
		if($('#actorInfo').text() == ''){return false;}
		$("#layerPopup").removeClass("open");
		var pos = $('#actorInfo').position();  
		LayerPopupView('actorInfo', 'layerPopup2', pos.top);
		$("#layerPopup2").addClass('open');
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("cfgFrame").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
	});
	
	// 레이어 팝업 닫기
	$('.closeBtn').click(function(){
		layerWindow.removeClass('open');
	});
	
	// 레이어 팝업 닫기
	$('.popup_closeBtn').click(function(){
		layerWindow.removeClass('open');
	});
	
});

//ajax에서 페이지에 넘길 변수값들 지정
function getData(avg, avg1, avg2){
	var Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID=${s_itemID}"
			+"&MenuID="+avg2
			+"&fromModelYN=${fromModelYN}"
			+"&configSTS=${configSTS}"
			+ avg;
	
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

function setCfgFrame(avg, avg2, avg3, avg4,avg5){
	var browserType="";
	var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
	if(IS_IE11){browserType="IE11";}
	var url = avg+".do";
	var data = getData(avg3,avg4,avg5);
	var target = "cfgFrame";
	var src = url +"?" + data+"&browserType="+browserType;
	var idx = (window.location.href).lastIndexOf('/');
	
	$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
	$("#cfgFrame").empty();
	$("#cfgFrame").attr("style", "display:block;height:"+ height/3 +"px;");
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

//Edit
function goItemConfigEdit() {	
    var url = "pim_EditItemConfigInfo.do";
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}";
 	ajaxPage(url, data, target);
}

//Setup
function goItemConfigCreate(){
	if(confirm("${CM00001}")){
		var url = "pim_AddItemConfig.do";
		var data = "s_itemID=${s_itemID}";
		var target = "actFrame";
		ajaxPage(url, data, target);	
	}
}

//Release
function goItemConfigRelease(){
	if(confirm("${CM00001}")){
		var url = "pim_ReleaseItemConfig.do";
		var data = "s_itemID=${s_itemID}&itemConfigID=${itemConfigMap.ItemConfigID}";
		var target = "actFrame";
		ajaxPage(url, data, target);
	}
}

function goItemConfigCopy(){
	var url = "pim_ItemConfigCopyListPop.do";
	var data = "&s_itemID=${s_itemID}&languageID=${languageID}" 
	url += "?" + data;
	var option = "width=820,height=300,left=300,top=100,toolbar=no,status=no,resizable=yes";
    //window.open(url, self, option);
}

function LayerPopupView(sLinkName, sDivName)  { 
	$(".item_layer_photo").attr("style","width:240px;");
	var oPopup = document.getElementById(sDivName);
	var oLink = document.getElementById(sLinkName);
	var scrollTop = document.getElementById("cfgFrame").scrollTop;
	var nTop = 120;
	oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
	oPopup.style.left = (oLink.offsetLeft + 10) + "px";
} 

function fnHideTable() {
	var tempSrc = $("#fitWindow").attr("src");
	if($("#fitWindow").hasClass("frame_show")) {
		var height = $("#processDIV").height();
		$("#processDIV").attr("style","visibility:hidden");
		$("#bottomView").attr("style","position:relative;top:-" + height + "px;");
		$("#actFrame").scrollTop(0);
		$("#fitWindow").attr("class","frame_hide");
		$("#fitWindow").attr("alt","${WM00159}");
	}
	else {
		$("#processDIV").attr("style","visibility:visible");
		$("#bottomView").attr("style","position:relative;top:" + height + "px;");
		$("#fitWindow").attr("class","frame_show");
		$("#fitWindow").attr("alt","${WM00158}");
	}
}

function fnCallback(){
	var url = "pim_ItemConfigMgt.do";
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
	ajaxPage(url, data, target);
}

</script>

<body>
<div id="processDIV">
	<div class="title">
		<img src="cmm/base/images//sc_file.png" />
		<p><b>Item Configuration</b></p>
		<ul>
			<li class="floatR">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
					<c:choose>
						<c:when test="${configSTS == 'MOD'}">
							&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goItemConfigEdit()"></span>
							&nbsp;<span class="btn_pack medium icon"><span style="margin-top:0px;" class="confirm"></span><input value="Release" type="submit" onclick="goItemConfigRelease()"></span>
						</c:when>
						<c:when test="${configSTS == '' or configSTS eq null}">
							&nbsp;<span class="btn_pack small icon"><span class="setup"></span><input value="Setup" type="submit" onclick="goItemConfigCreate()"></span>
							&nbsp;<span class="btn_pack small icon"><span class="copy"></span><input value="Copy" type="submit" onclick="goItemConfigCopy()"></span>
						</c:when>
					</c:choose>
				</c:if>
				&nbsp;<span class="btn_pack small icon"><span class="log"></span><input value="Log" type="submit" onclick=""></span>
			</li>
        </ul>
	</div>
	
	<c:choose>
	<c:when test="${configSTS != null && configSTS != ''}">	
	<div class="table">
		<table width="100%" cellpadding="0" cellspacing="0">
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
			
			<c:forEach var="prcList" items="${prcList}" varStatus="status">
			<tr>
				<th>${menu.LN00015}</th>
				<td>${prcList.Identifier}</td>
				<th>${menu.LN00028}</th>
				<td>${prcList.ItemName}</td>
				<th>${menu.LN00016}</th>
				<td>${prcList.ClassName}</td>
				<th>항목 담당자</th>
				<td id="authorInfo" style="cursor:pointer;_cursor:hand">${prcList.Name}</td>
			</tr>
			<tr>
				<th>Configuration No.</th>
				<td>${itemConfigMap.ItemConfigID}</td>
				<th>Status</th>
				<td>${itemConfigMap.Status}</td>
				<th>Configurator</th>
				<td id="actorInfo" style="cursor:pointer;_cursor:hand">${itemConfigMap.Configurator}</td>
				<th>${menu.LN00070}</th>
				<td>${itemConfigMap.LastUpdated}</td>
			</tr>
			<tr>
				<th>${menu.LN00035}</th>
				<td class="pdL5 pdR5" colspan="7">
					<div style="width:100%;height:160px;">
						<textarea class="tinymceText" readonly="readonly">${itemConfigMap.Description}</textarea>	
					</div>
				</td>
			</tr>
			</c:forEach>
		</table>
	</div>
	</c:when>
	<c:otherwise>
		<div class="no_item">
			<p>${message.MSG0001}</p>
		</div>
	</c:otherwise>
	</c:choose>
</div>

<c:if test="${configSTS != null && configSTS != ''}">	
<input type="hidden" id="clickedURL" style="width:800px" />
	<div id="bottomView">
		<div class="SubTab">
			<ul>
				<c:set value="1" var="tabNum" />
				<c:forEach var="i" items="${getList}" varStatus="status">
						<li id="cli${tabNum}" onclick="setCfgFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
				<c:set var="tabNum" value="${tabNum+1}"/>
				</c:forEach>
			</ul>
			<div class="instance_top_btn"><a id="fitWindow" class="frame_show" onclick="fnHideTable()"><img src="${root}${HTML_IMG_DIR}/icon_fitwindow.png" /></a></div>
		</div>
		
		<div id="cfgFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;" >
		</div>
		<form style="border:0;" name="subFrame" id="subFrame"></form>
	</div>
</c:if>


<!-- 담당자 레이어 팝업 -->
	<div class="item_layer_photo" id="layerPopup">
		<div>
			<div class="child_search_head_blue" style="border: 0px;">
				<li class="floatL"><p>Employee information</p></li>
				<li class="floatR mgT10 mgR10"><img class="popup_closeBtn"
					id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png'
					title="close"></li>
			</div>
			<table class="tbl_blue01 mgT5"
				style="width: 100%; height: 99%; table-layout: fixed; border: 0px;">
				<colgroup>
					<col width="30%">
					<col width="70%">
				<tr>
					<td style="border: 0px;"><c:if
							test="${authorInfoMap.Photo == 'blank_photo.png' }">
							<img src='<%=GlobalVal.HTML_IMG_DIR%>${authorInfoMap.Photo}'>
						</c:if> <c:if test="${authorInfoMap.Photo != 'blank_photo.png' }">
							<img src='<%=GlobalVal.EMP_PHOTO_URL%>${authorInfoMap.Photo}'>
						</c:if></td>
					<td class="alignL last pdl10" style="border: 0px;"><span
						style="font-weight: bold; font-size: 12px;">${authorInfoMap.MemberName}</span>
						&nbsp;(${authorInfoMap.EmployeeNum})<br>${authorInfoMap.UserNameEN}<br>${authorInfoMap.OwnerTeamName}
						<c:if test="${authorInfoMap.City != '' }">
								(${authorInfoMap.City})
							</c:if></td>
				</tr>
				<tr>
					<td colspan="2"
						style="border-bottom: 2px solid #ddd; border-top: 0px;"></td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">${menu.LN00104}</div>
						<div class="floatR" " style="width: 70%">${authorInfoMap.TeamName}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">E-mail</div>
						<div class="floatR" style="width: 70%;">${authorInfoMap.Email}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">Tel</div>
						<div class="floatR" style="width: 70%">${authorInfoMap.TelNum}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">Mobile</div>
						<div class="floatR" style="width: 70%">${authorInfoMap.MTelNum}</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

<!-- 담당자 레이어 팝업 -->
	<div class="item_layer_photo" id="layerPopup2">
		<div>
			<div class="child_search_head_blue" style="border: 0px;">
				<li class="floatL"><p>Employee information</p></li>
				<li class="floatR mgT10 mgR10"><img class="popup_closeBtn"
					id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png'
					title="close"></li>
			</div>
			<table class="tbl_blue01 mgT5"
				style="width: 100%; height: 99%; table-layout: fixed; border: 0px;">
				<colgroup>
					<col width="30%">
					<col width="70%">
				<tr>
					<td style="border: 0px;"><c:if
							test="${actorInfoMap.Photo == 'blank_photo.png' }">
							<img src='<%=GlobalVal.HTML_IMG_DIR%>${actorInfoMap.Photo}'>
						</c:if> <c:if test="${actorInfoMap.Photo != 'blank_photo.png' }">
							<img src='<%=GlobalVal.EMP_PHOTO_URL%>${actorInfoMap.Photo}'>
						</c:if></td>
					<td class="alignL last pdl10" style="border: 0px;"><span
						style="font-weight: bold; font-size: 12px;">${actorInfoMap.MemberName}</span>
						&nbsp;(${actorInfoMap.EmployeeNum})<br>${actorInfoMap.UserNameEN}<br>${actorInfoMap.OwnerTeamName}
						<c:if test="${actorInfoMap.City != '' }">
								(${actorInfoMap.City})
							</c:if></td>
				</tr>
				<tr>
					<td colspan="2"
						style="border-bottom: 2px solid #ddd; border-top: 0px;"></td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">${menu.LN00104}</div>
						<div class="floatR" " style="width: 70%">${actorInfoMap.TeamName}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">E-mail</div>
						<div class="floatR" style="width: 70%;">${actorInfoMap.Email}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">Tel</div>
						<div class="floatR" style="width: 70%">${actorInfoMap.TelNum}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignL pdl10" style="border: 0px;">
						<div class="floatL" style="width: 30%; font-weight: bold;">Mobile</div>
						<div class="floatR" style="width: 70%">${actorInfoMap.MTelNum}</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

</body>
