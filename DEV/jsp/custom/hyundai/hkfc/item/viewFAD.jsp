<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<style>
	.scroll-area {
	    overflow: hidden auto;
	    background-attachment: local;
	}
	.contents-box-wrapper {
	    width: 1200px;
	    background: url(../cmm/common/images/line.png) 50%/52% no-repeat;
	    background-attachment: local;
	}
	.contents-box div {
	    width: 200px;
	    height: 150px;
	    margin: 30px 0;
        background: #fff;
	}
	.process-bar {
		margin: 20px 0;
	}
	.process-bar div{
		 height: 200px;
	}
	.contents-box h4 {
    	padding: 10px 20px;
    	padding-top: 0;
  	    border-radius: 3px 3px 0 0;
  	    font-size:13px;
	}
	.process-bar h4{ 
		padding-top: 10px;
		height: 20px;
		text-align: center;
	}
	.process-bar div:nth-child(4n+1) h4{
		color: #fff;
	    background: url(../cmm/common/images/process.png) 10px 50%, #055185;
	    background-repeat: no-repeat;
	    background-size: 22px;
	}
	.contents-box ul {
		overflow: auto;
	    height: calc(100% - 53px);
	    padding: 10px 20px;
	}
	.process-bar ul {
		height: calc(100% - 58px);
		padding: 6px 20px;
	}
	.alignR {
		border-right:3px solid;
	}
	.alignL {
		border-left:3px solid;
	}
	.alignR h4, .alignL h4{
		color:#055185;
	}
	.alignR h4 img, .alignL h4 img{
		width: 15px;
	    margin-right: 7px;
    }
    .tri {
	    content: "";
	    width: 0px;
	    height: 0px;
	    border-bottom: 15px solid #e6e6e6;
	    border-right: 10px solid transparent;
	    border-left: 10px solid transparent;
	    transform: rotate(90deg);
	    margin-left: 3px;
	}
	.contents-box li:hover:not(.not-hover li){
		text-decoration: underline;
	    cursor: pointer;
	    color: #0085BA;
	}
	.two-box {
		width: 93%;
		margin: 0 auto;
	}
	.two-box div{
		width:320px;
	}
</style>
<script>
	function fnItemPopUp(itemId){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
</script>
</head>
<div class="scroll-area">
	<div class="contents-box-wrapper">
		<!-- 상단 속성 -->
		<div class="flex justify-between contents-box two-box not-hover">
			<div class="alignR">
				<h4><img src="${root}cmm/common/images/operation.png">장비 또는 운영 정보</h4> <%-- ${attrNameMap.AT00015 } --%>
				<ul>
					<li>&middot; ${attrMap.AT00086}</li>
				</ul>
			</div>
			<div class="alignL">
				<h4><img src="${root}cmm/common/images/skill.png">교육 / 지식 / skills</h4>
				<ul>
					<li>&middot; ${attrMap.AT00082}</li>
				</ul>
			</div>
		</div>
		
		<!-- 중간 cxn, 선후행 -->
		<div class="flex justify-between contents-box align-center process-bar">
			<div class="alignL" style="border-radius: 5px;border: 2px solid #ccc;">
				<h4>선행 프로세스</h4>
				<ul>
				<c:forEach var="list" items="${elementList}" varStatus="status">
					<c:if test="${list.LinkType eq 'Pre' }">
					<li onClick="fnItemPopUp(${list.ItemID})">&middot; ${list.ItemName }</li>
					</c:if>
				</c:forEach>
				</ul>
			</div>
			<span class="tri"></span>
			<div class="alignL" style="border-radius: 5px;border: 2px solid #0085ba;">
				<h4 style="color:#0085ba;">입력정보</h4>
				<ul>
					<c:forEach var="list" items="${relItemList}" varStatus="status">
					<c:if test="${list.ItemTypeCode eq 'OJ00006' && list.CXNClassCode eq 'CNL0506' }">
					<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
					</c:if>
					</c:forEach>
				</ul>
			</div>
			<span class="tri"></span>
			<div>
				<ul class="flex align-center justify-center not-hover" style="height: 100%; padding: 0; background: url(../cmm/common/images/circle.png) no-repeat; background-size: 100%;">
					<li style="font-size: 15px;font-weight: 700;color:#0085BA;">${prcList.ItemName}</li>
				</ul>
			</div>
			<span class="tri"></span>
			<div class="alignL" style="border-radius: 5px;border: 2px solid #0085ba;">
				<h4 style="color:#0085ba;">출력정보</h4>
				<ul>
					<c:forEach var="list" items="${relItemList}" varStatus="status">
					<c:if test="${list.ItemTypeCode eq 'OJ00006' && list.CXNClassCode eq 'CNL0506A' }">
					<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
					</c:if>
					</c:forEach>
				</ul>
			</div>
			<span class="tri"></span>
			<div class="alignL" style="border-radius: 5px;border: 2px solid #ccc;">
				<h4>후행 프로세스</h4>
				<ul>
					<c:forEach var="list" items="${elementList}" varStatus="status">
					<c:if test="${list.LinkType eq 'Post' }">
					<li onClick="fnItemPopUp(${list.ItemID})">&middot; ${list.ItemName }</li>
					</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
		
		<!-- 하단 cxn -->
		<div class="flex justify-between contents-box two-box">
			<div class="alignR">
				<h4><img src="${root}cmm/common/images/way.png">지침 / 절차 / 방법</h4>
				<ul>
					<c:forEach var="list" items="${relItemList}" varStatus="status">
					<c:if test="${list.ItemTypeCode eq 'OJ00011'}">
					<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
					</c:if>
					</c:forEach>
				</ul>
			</div>
			<div class="alignL">
				<h4><img src="${root}cmm/common/images/chart.png">성과지표</h4>
				<ul>
					<c:forEach var="list" items="${relItemList}" varStatus="status">
					<c:if test="${list.ItemTypeCode eq 'OJ00008'}">
					<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
					</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
	</div>
</div>