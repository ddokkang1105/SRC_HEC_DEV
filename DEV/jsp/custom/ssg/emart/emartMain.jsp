<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style>
#statCountDiv {
    width: 100%;
    height: 48%;
    margin-bottom: 2%;
}

#statCountDiv .postInfo {
	overflow-y: auto;
    background: #fff;
    box-shadow: rgb(0 0 0 / 10%) 1px 1px 5px 0px;
}

#boardDiv, #csListDiv, #esrListDiv {
	height: 48%;
}
</style>
<script type="text/javascript">
    $(document).ready(function(){
		fnClickedTab(1);
        fnBoardQnA();
		
        setDivSize();
        window.onresize = function() {
        	setDivSize();
        };
	});
    
    function setDivSize(){
    	$("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#esrListDiv > div:nth-child(2)").innerHeight($("#esrListDiv").height()-$("#esrListDiv > div:nth-child(1)").height());
        $("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
        $("#statCountDiv > div:nth-child(2)").innerHeight($("#statCountDiv").height()-$("#statCountDiv > div:nth-child(1)").height());
    }
    
    function fnClickedTab(avg) {
		var target = "tabFrame1";
		
		if(avg == 1){ // 공지사항
			$("#boardMgtID").val(1);
			 var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=1&listSize=10";
			ajaxPage(url, data, target);
		}else if(avg == 2){ // 자료실
			$("#boardMgtID").val(3);
			var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=3&listSize=10";
			ajaxPage(url, data, target);
		}
		
		var realMenuIndex = "1 2".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
    
    function fnBoardQnA() {
		var target = "boardQnAFrame";
		var url = "mainBoardQnAList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=4&listSize=5&searchType=001";
		ajaxPage(url, data, target);
	}
    
    function fnClickMoreBoard(id){
    	var boardMgtID = $("#boardMgtID").val();
    	if(boardMgtID ==""){boardMgtID="1";}
    	if(id){boardMgtID=id;}
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    function fnGoMore(){
    	var url = "zSSG_LastUpdatedWithin6Months.do";
		var data = "";
        var target = "layerBody";
        	       
        ajaxPage(url, data, target);
    }
    
    function goArcMenu(gubun,itemID) {
   		parent.clickMainMenu('PAL0101','','','','csh_process','csh_process','itemMgt.do?nodeID='+itemID);
    }
    
    function fnItemInfo(avg1){
    	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
    	var w = 1200;
    	var h = 900;
    	itmInfoPopup(url,w,h,avg1);
	}
</script>
</head>

<body id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
	<input id="boardMgtID" type="hidden" value="" >
	<div id="mainWrapper">
		<div id="leftDiv">
			<div id="statCountDiv">
	 			<div class="secTit">
					<ul>
						<li class="titNM">이마트 전사 프로세스</li>
					</ul>
				</div>
				<div class="postInfo">
					<table class="tbl_blue" style="width:100%; height:100%;">
						<colgroup>
							<col width="13%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="7%">
						</colgroup>
						<tr style="background: #fdd768;">
							<td>구분</td>
							<td><p>기준정보</p><p style="font-size:10px;">(Master Data)</p></td>
							<td><p>MD</p><p style="font-size:10px;">(Merchandising)</p></td>
							<td><p>발주</p><p style="font-size:10px;">(Buying)</p></td>
							<td><p>판매&</p><p>점포운영</p></td>
							<td><p>물류</p><p>관리</p></td>
							<td><p>제조</p><p>관리</p></td>
							<td><p>품질</p><p>관리</p></td>
							<td><p>재무</p><p>회계</p></td>
							<td><p>관리</p><p>회계</p></td>
							<td class="last">합계</td>
						</tr>
						<c:forEach var="i" items="${procStatCount}" varStatus="status">
							<tr <c:if test="${i.GUBUN eq 'ALL'}">style="background: #fff0cc;font-weight: 500;"</c:if>>
								<td class="alignL pdL10">
									<c:choose>
										<c:when test="${i.GUBUN eq 'EM' }">이마트</c:when>
										<c:when test="${i.GUBUN eq 'TR' }">트레이더스</c:when>
										<c:when test="${i.GUBUN eq 'NB' }">노브랜드</c:when>
										<c:when test="${i.GUBUN eq 'SG' }">SSG푸드마켓</c:when>
										<c:when test="${i.GUBUN eq 'ED' }">에브리데이</c:when>
										<c:when test="${i.GUBUN eq 'CM' }">공통</c:when>
										<c:otherwise>전체 프로세스(L4)</c:otherwise>
									</c:choose>
								</td>
 								<c:set value="${i['01']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID01 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID01 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if>
								<c:set value="${i['02']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID02 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID02 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['03']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID03 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID03 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['06']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID06 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID06 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['04']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID04 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID04 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['05']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID05 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID05 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['09']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID09 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID09 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['07']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID07 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID07 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<c:set value="${i['08']}" var="val" /><td <c:if test="${val ne 0 and val ne null and i.ItemID08 ne null}">onclick="goArcMenu('${i.GUBUN}',${i.ItemID08 })" style="cursor:pointer"</c:if>><c:if test="${val eq 0 }">-</c:if><c:if test="${val ne 0 }">${val }</c:if></td>
								<td class="last" style="font-weight: 500">${i.Total }</td>
							</tr>
						</c:forEach>
					</table>
				</div>	
			</div>	
			
			<div id="csListDiv">
				<div class="secTit">
					<ul>
						<li class="titNM">Last updated within 6 months</li>
					</ul>
					<ul class="morebtn" onClick="fnGoMore()">
						<li>more</li>
					</ul>
				</div>
				<div id="csFrame" class="postInfo">
					<ul>
						<li style="width:10%;max-width:85px;font-weight: 600;" class="alignC">${menu.LN00042}</li>
						<li style="width:50%;font-weight: 600;" class="alignC">${menu.LN00028}</li>
						<li style="width:13%;font-weight: 600;" class="alignC">${menu.LN00004}</li>
						<li style="width:12%;font-weight: 600;" class="alignC">${menu.LN00027}</li>
						<li style="width:15%;font-weight: 600;" class="alignC">${menu.LN00070}</li>
					</ul>
					<c:forEach items="${csList}" var="list" varStatus="status">
						<ul onClick="fnItemInfo('${list.ItemID}')">
							<li style="width:10%;max-width:85px;">${list.TypeCode}</li>
							<li style="width:50%;">${list.Identifier}&nbsp;&nbsp;${list.ItemName}</li>
							<li style="width:13%;" class="alignC">${list.AuthorName}</li>
							<li style="width:12%;" class="alignC">${list.StatusName }</li>
							<li style="width:15%;" class="alignC">${list.LastUpdated}</li>
						</ul>
					</c:forEach>
				</div>	
			</div>
		</div>
		
		<div id="rightDiv">
			<div id="boardDiv">
	 			<div class="tabs">
					<ul>
						<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00001}</li>
						<li id="pliugt2" class="titNM" onclick="javascript:fnClickedTab('2');">${menu.LN00029}</li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
						<li>more</li>
					</ul>
				</div>
				<div id="tabFrame1" class="tabFrame"></div>	
			</div>
			
     		<div id="esrListDiv">
	 			<div class="secTit">
					<ul>
						<li class="titNM">${menu.LN00215}</li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreBoard(4);">
						<li>more</li>
					</ul>
				</div>
				<div id="boardQnAFrame" class="postInfo"></div>	
			</div>			
		</div>

	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>