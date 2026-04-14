<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>

<script type="text/javascript">
	var menuIndex = "${menuIndex}";	
	
	$(document).ready(function(){
		clickOpenClose('${grpOpenClose}');
		
		// popup에서 바로  상세화면으로 이동
		var goDetailOpt = "${goDetailOpt}";
		if (goDetailOpt == "Y") {
			var boardID = "${BoardID}";
			var s_itemID = "${s_itemID}";
			if(boardID != '' && boardID != null) {
				clickSubMenu('${loadingBoard}');
				fnInitValues(); 
				var url = '${Url}';
				$("#currUrl").val(url);
				// 포럼 체크
				if(url == "forumMgt"){
					var data = "boardMgtID=${BoardMgtID}&BoardMgtID='${BoardMgtID}'&boardID="+boardID+"&s_itemID="+s_itemID+"&goDetailOpt="+goDetailOpt;
					var target = "help_content";
					url = "forumMgt.do";
					ajaxPage(url, data, target);
				}else {
					goDetail('N','${BoardMgtID}', boardID);
				}
			} 
		}		
		else {
			setSubFrame('${BoardMgtID}','${loadingBoard}','${Url}', '${BoardTypeCD}'); 
		}
	});
	
	// [Menu] Click
	function setSubFrame(BoardMgtID, avg, url, boardTypeCD) {
		clickSubMenu(avg); // 클릭한 변경
		fnInitValues(); 
		$("#currUrl").val(url);
		if("${boardLstCnt}"!="0"){
			$('#BoardMgtID').val(BoardMgtID); 
			var target = "help_content";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=Admin&BoardMgtID="+BoardMgtID+"&url="+url+"&boardTypeCD="+boardTypeCD;
			var url = "boardList.do";
			ajaxPage(url, data, target);
		}
	}
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuCng";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	function fnInitValues(){
		$('#BoardMgtID').val("");
		$('#BoardID').val("");
	}
	function goList(isConfirm, screenType, projectID, category, categoryIndex, categoryCnt, back){
		if(isConfirm){if(confirm("${CM00003}")) fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back);} else{fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back);}
	}	
	function fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back){
		removeSubFrame();
		var url = "boardList.do";
		var data = "BoardMgtID="+$('#BoardMgtID').val()+"&pageNum="+$("#currPage").val()
					+"&url="+$("#currUrl").val()+"&screenType="+screenType
					+"&s_itemID="+projectID+"&category="+category
					+back
					+"&categoryIndex="+categoryIndex
					+"&categoryCnt="+categoryCnt;
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	function goDetail(isNew,boardMgtID, boardID, boardUrl, currPage, screenType, projectID, category, categoryIndex, categoryCnt,back){ 
		removeSubFrame();
		var url = "boardDetail.do";
		var data = "NEW="+ encodeURIComponent(isNew)
				+"&BoardID="+ encodeURIComponent(boardID)
				+"&BoardMgtID="+ encodeURIComponent(boardMgtID)			
				+"&url="+ encodeURIComponent(boardUrl)
				+"&currPage="+currPage
				+"&screenType="+ encodeURIComponent(screenType)
				+"&projectID="+ encodeURIComponent(projectID)
				+"&category="+ encodeURIComponent(category)
				+"&categoryIndex="+ encodeURIComponent(categoryIndex)
				+back
				+"&categoryCnt="+ categoryCnt;
		var target = "help_content";
		ajaxPage(url, data, target);		
	}
	function removeSubFrame(){
		//$("#help_content").empty();
		//$("#help_content").remove();
	}
	
	// [+][-] button event
	function clickOpenClose(avg) { 
		if (  $(".plus"+ avg).css("display") != "none" || $(".smenu" + avg).css("display") == "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); // 그외 내용을 닫아줌
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
	}
	
	function setOtherArea(avg) {
		var indexArray = menuIndex.split(' ');
		for(var i = 0 ; i < indexArray.length; i++){
			var index = i + 1;
			if(index != avg){
				$(".smenu" + index).css("display", "none");
				$(".plus" + index).css("display", "block");
				$(".minus" + index).css("display", "none");
			}
		}
	}

</script>
</head>
<style type="text/css">
* html body { /*IE6 hack*/
	padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}

* html #carcontent { /*IE6 hack*/
	width: 100%;
}
a{
	cursor:pointer;
}
</style>

<body id="mainMenu">
	<form name="boardMainFrm" id="boardMainFrm"></form>
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${BoardMgtID}"></input>
		<input type="hidden" id="BoardID" name="BoardID" value=""/>
		<input type="hidden" id="currUrl" name="currUrl" value=""></input>			
		<div id="carframe">
			<div>
				<ul class="help_menu">
					 <li class="helptitle2" style="border-bottom:0;">&nbsp;${templName}</li>
						<!-- 1.Board -->
	                 	<c:forEach var="grpList" items="${boardGrpList}" varStatus="grpStatus">
		                 <li class="helpstitle line plus${grpStatus.count}"> 	                 
		                 <a onclick="clickOpenClose(${grpStatus.count});"><img class="mgR5" src="${root}cmm/common/images/menu//sidebar_tap_close.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName}</span></a>
		                 </li>
		                 <li style="display:none;" class="helpstitle line minus${grpStatus.count}">	                 
		                 <a class="on" onclick="clickOpenClose(${grpStatus.count});"><img class="mgR5" src="${root}cmm/common/images/menu//sidebar_tap_open.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName }</span></a>
		                 </li>
		                 <c:if test="${boardLstCnt != 0 }" >
	                 	 <c:forEach var="list" items="${boardMgtList}" varStatus="status">
	                 		<c:if test= "${grpList.BoardGrpID == list.ParentID}" >
								<li style="display:none;"								
								<c:choose>
								<c:when test="${list.ParentIDCnt == status.count && boardGrpCnt > 1}"> class="hlepsub smenu${grpStatus.count}"  </c:when>
								<c:otherwise> class="hlepsub line smenu${grpStatus.count}"  </c:otherwise>
								</c:choose>							
								><a id="menuCng${startBoardIndex + status.count}" onclick="setSubFrame('${list.BoardMgtID}','${startBoardIndex + status.count}','${list.URL}','${list.BoardTypeCD}');">&nbsp;${list.BoardMgtName}</a>
								</li>
							</c:if>
						 </c:forEach>
						 </c:if>
	                 </c:forEach>
				</ul>
			</div>
		</div>
		<div id="carcontent">
			<div id="help_content" class="pdL10 pdR10"></div>
		</div>
</body>
</html>


