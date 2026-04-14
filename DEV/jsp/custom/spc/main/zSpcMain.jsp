<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/" var="root"/>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
    
    $(document).ready(function(){
        window.onresize = function() {
        	setDivSize();
        };
	});
    
    function fnClickedTab(avg) {
		var target = "tabFrame1";
		
		if(avg == 1){ // 공지사항
			$("#boardMgtID").val(1);
			 var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=1&listSize=5";
			ajaxPage(url, data, target);
		}else if(avg == 3){ // 자료실
			$("#boardMgtID").val(3);
			var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=3&listSize=5";
			ajaxPage(url, data, target);
		}else if(avg == 4){ // Q&A
			$("#boardMgtID").val(4);
			var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=4&listSize=5";
			ajaxPage(url, data, target);
		}
		
		
		
		var realMenuIndex = "4 1 3".split(' ');
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
    
</script>
<style>

/* section  */
#mainWrapper {
	top:5%;
	width: 95%;
}
#leftDiv , #rightDiv {
	width: 48.5%;
}
</style>
</head>

<body id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
	<input id="boardMgtID" type="hidden" value="" >
	<div id="mainWrapper">
		
		<div id="leftDiv">		
			<!-- 게시판 start -->
			<div id="LeftBottomDiv">
				<div class="charTit">
					<ul>
						<li class="charTit2" style="padding: 0px 20px;">게시판</li>
					</ul>
				</div>
				<div id="boardDiv">
			 		<div class="tabs"  style="height:40px;">
						<ul>
							<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00001}</li>
							<li id="pliugt3" class="titNM" onclick="javascript:fnClickedTab('3');">${menu.LN00029}</li>
							<li id="pliugt4" class="titNM" onclick="javascript:fnClickedTab('4');">${menu.LN00215}</li>
						</ul>
						<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
							<li>more</li>
						</ul>
					</div>
					<div id="tabFrame1" class="tabFrame" style="height:calc(100% - 40px);" ></div>	
				</div>
			</div>
			<!-- 게시판 end -->
		</div>    
		
		<div id="rightDiv">
		</div>
		
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>

<script>
</script>