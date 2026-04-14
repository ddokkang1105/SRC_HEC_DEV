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
<script type="text/javascript">
    var noticType;var menuIndex = "1 3";  
    
    $(document).ready(function(){
// 		setSchdlFrame();
		fnClickedTab(1);
		setCSFrame();
        setESRFrame();
        setProcessFrame();
        fnBoardQnA();
		fnClickedTask(1);
        
        $('input:radio[name=pgCheckBox]').change(function() {
			setListPage($(this).val());
		});
		
        setDivSize();
        window.onresize = function() {
        	setDivSize();
        };
        
        $(".myItemCon>span>img").each(function(i, item){
            var src = $(item).attr("src");	// src 경로 구하기
            src.substr(src.length-4,4); // .png 잘라내기
            src.substr(0,src.length-4); // .png 전까지 잘라내기
            $(item).attr("src",src.substr(0,src.length-4)+"_main"+src.substr(src.length-4,4)); // 중간에 _main 붙여서 새로운 
        });
        
        document.getElementById("task1").children[0].innerHTML = "${fn:length(myItemList)}";
		document.getElementById("task2").children[0].innerHTML = "${wfCurAprvCnt}";
		document.getElementById("task3").children[0].innerHTML = "${fn:length(myRewBrdList)}";
	});
    
    function setDivSize(){
    	$("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#esrListDiv > div:nth-child(2)").innerHeight($("#esrListDiv").height()-$("#esrListDiv > div:nth-child(1)").height());
        $("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
        $("#schdlDiv > div:nth-child(2)").innerHeight($("#schdlDiv").height()-$("#schdlDiv > div:nth-child(1)").height());
        $("#chartDiv > div:nth-child(2)").innerHeight($("#chartDiv").height()-$("#chartDiv > div:nth-child(1)").height());
        $("#taskDiv > div:nth-child(2)").innerHeight($("#taskDiv").height()-$("#taskDiv > div:nth-child(1)").height());
    }
    
    function setListPage(avg) {
    	var radios = $("input:radio[name=pgCheckBox]");
    	
    	for(var i = 0; i < radios.length; i++) {
	    	var $this = $(radios[i]);
	    	if($this.val() != avg) { 
	        	$("#viewItemTypeListPage"+$this.val()).attr("style","display:none");
	    	} else {
	        	$("#viewItemTypeListPage"+avg).attr("style"," height:83%;");
	    	}
    	}
    }

    function setCSFrame(){ 
        var url = "olmMainChangeSetList.do";
        var target = "csFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }
    
    function setSchdlFrame(){
        var url = "olmMainSchdlList.do";   
        var target = "schdlFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=10";
        ajaxPage(url, data, target);
    }
    
    function setESRFrame(){ 
        var url = "olmMainEsrList.do";
        var target = "esrFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&chkNew=5&scrnType=main"; // chkNew.def = 7
        ajaxPage(url, data, target);
    } 
    
    function fnSearchProcess(avg){
    	var searchValue = $("#searchValue").val();
    	var url = "searchList.do";
    	var target = "mainLayerFrm";
    	var data = "itemTypeCode=OJ00001&classCode=CL01005&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
    	ajaxPage(url, data, target);
    }
    
    function fnSearchFile(avg){
    	var searchValue = $("#searchValue").val();
    	var url = "goDocumentList.do";
    	var target = "mainLayerFrm";
    	var data = "screenType=main&searchKey=Name&searchValue="+searchValue;
    	ajaxPage(url, data, target);
    }
    

    function setProcessFrame(){
        var url = "mainSttProcessChart.do";   
        var target = "subPrcFrame";
        var data = "";
        ajaxPage(url, data, target);
    }
    
    function fnClickedTab(avg) {
		var target = "tabFrame1";
		
		if(avg == 1){ // 공지사항
			$("#boardMgtID").val(1);
			 var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=1&listSize=5";
			ajaxPage(url, data, target);
		}else if(avg == 2){ // 자료실
			$("#boardMgtID").val(3);
			var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=3&listSize=5";
			ajaxPage(url, data, target);
		}else if(avg == 3){ // FAQ
			$("#boardMgtID").val(2);
			var url = "mainBoardList.do";
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID=2&listSize=5";
			ajaxPage(url, data, target);
		}
		
		var realMenuIndex = "1 2 3".split(' ');
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
    
    function settypeCodeListPageing(avg) {  }
    
    function fnClickMoreBoard(id){
    	var boardMgtID = $("#boardMgtID").val();
    	if(boardMgtID ==""){boardMgtID="1";}
    	if(id){boardMgtID=id;}
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    function fnGoMore(id, onTab){
    	var focusMenu ="";

       	if(onTab == "SCHDL"){
       		parent.goMenu('goSchdlListMgt.do?refPGID='+id, '', true, layout_2E);
       	} else if(onTab == "ESR"){
       		parent.goMenu('esmMgt.do?srType=${srType}&focusMenu=2', '', true, layout_2E);
       	} else if(onTab == "Proc") {
			var url = "admin/newItemStatistics.do";
			var data = "isMainMenu=Y";
	        
	        var target = "layerBody";
	        	       
	        ajaxPage(url, data, target);
       	}else if(onTab == "CngSet") {

    		var Now = new Date(); 
    		
    		var toDate = Now.getFullYear() + "-" + ("0" + (Now.getMonth() +1)).slice(-2) + "-"
    		+ ("0" +  Now.getDate()).slice(-2);

    		var Old = new Date(Now.getFullYear(),Now.getMonth(),Now.getDate() - 7)
    		var fromDate = Old.getFullYear() + "-" + ("0" + (Old.getMonth()+1)).slice(-2) + "-"
    		+ ("0" +  Old.getDate()).slice(-2);
    		
            var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modStartDT="+fromDate+"&modEndDT="+toDate;
            
	    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '','',data,'','');
       	}
    }
    
    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status,srType){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
      	var url = ""; 
    	var mainType = "SRDtl";
    	var url = "";
    	var scrnType = "";
    	var data = "";
		if(sessionUserID == requestUserID ){		// 요청자
			parent.goMenu("mySpaceV34.do?srID="+SRID+"&scrnType=srReq&srType="+srType+"&mainType="+mainType, '', true, layout_2E);
		} else if (sessionUserID == receiptUserID){	// 담당자일 경우
			parent.goMenu("mySpaceV34.do?srID="+SRID+"&scrnType=srIng&srType="+srType+"&mainType="+mainType, '', true, layout_2E);
		} else {
			url = "esmMgt.do";
			scrnType = "srRqst" ;
		
    	var data = "&srID="+SRID+"&srType="+srType+"&mainType="+mainType+"&scrnType="+scrnType;
        var target = "layerBody";       
        ajaxPage(url, data, target);
		}  	
    }
    
    function goMyPage(avg) {
    	var url = "mySpace.do";
    	var data = "mainType="+avg;
    	var target = "layerBody";
    	
    	ajaxPage(url, data, target);
    }

    function goArcMenu(avg,avg2,avg3,avg4) {
    	if(avg != "")
    		parent.clickMainMenu(avg,'',avg2, '',avg3,avg3,avg4);
    }
    
    var taskID = "1";
    function fnClickedTask(avg) {
		var target = "taskFrame";
		taskID = avg;
		
		if(avg == 1){ // myitem
			var result = '<div class="postInfo">';
			<c:forEach items="${myItemList}" var="list" varStatus="status">
				result += '<ul onclick="fnItemInfo(${list.ItemID})">';
				result += '<li style="width:10%;"class="alignL">${list.ItemTypeName}</li>';
				result += '<li style="width:63%;">${list.Identifier}&nbsp;&nbsp;${list.ItemNM}</li>';			
				result += '<li style="width:12%;"class="alignC">${list.ChangeTypeNM}</li>';
				result += '<li style="width:15%;"class="alignC">${list.LastUpdated}</li>';
				result += '</ul>';
			</c:forEach>
			result += '</div>';
			document.getElementById("taskFrame").innerHTML = result;
		}else if(avg == 2){ // 결재할문서
			var url = "mainWorkflowList.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode=CurAprv&screenType=MyPg";
			ajaxPage(url, data, target);
		}else if(avg == 3){ // 검토 my스케줄
			var result = '<div class="postInfo">';			
			<c:forEach items="${myRewBrdList}" var="list" varStatus="status">
				result += '<ul onclick="fnDetail(\'BRD0001\',\'${list.BoardID}\')">';
				result += '<li style="width:10%;"class="alignL">${list.ItemTypeNM}</li>';
				result += '<li style="width:28%;">${list.Identifier}&nbsp;&nbsp;${list.itemName}</li>';	
				result += '<li style="width:40%;max-width:595px;">${list.Subject}</li>';
				result += '<li style="width:10%;"class="alignC">${list.WriteUserNM}</li>';
				result += '<li style="width:12%;"class="alignC">${list.EndDT}</li>';
				result += '</ul>';
			</c:forEach>
			result += '</div>';
			document.getElementById("taskFrame").innerHTML = result;
		}
		
		var realMenuIndex = "1 2 3 4".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#task" + realMenuIndex[i]).addClass("on");
			} else {
				$("#task" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
    
    function fnClickMoreTask(){
    	if(taskID == "1") {
    		parent.clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "myCSItem");
    	}
    	if(taskID == "2") {
    		parent.clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "myWF");
    	}
    	if(taskID == "3") {
    		var 	url =  "boardForumList.do";
			var data = "&BoardMgtID=BRD0001&myBoard=Y";
			var target = "layerBody";
    		ajaxPage(url, data, target);
    	}
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
			<div id="boardDiv">
	 			<div class="tabs">
					<ul>
						<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00001}</li>
						<li id="pliugt2" class="titNM" onclick="javascript:fnClickedTab('2');">${menu.LN00029}</li>
						<li id="pliugt3" class="titNM" onclick="javascript:fnClickedTab('3');">FAQ</li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
						<li>more</li>
					</ul>
				</div>
				<div id="tabFrame1" class="tabFrame"></div>	
			</div>
			
<!-- 			<div id="schdlDiv"> -->
<!-- 				<div class="secTit"> -->
<!-- 					<ul> -->
<%-- 						<li class="titNM">${menu.LN00110}</li> --%>
<!-- 					</ul> -->
<!-- 					<ul class="morebtn" onClick="javascript:fnGoMore('','SCHDL')"> -->
<!-- 						<li>more</li> -->
<!-- 					</ul> -->
<!-- 				</div> -->
<!-- 				<div id="schdlFrame"></div>	 -->
<!-- 			</div> -->

			<div class="secTit">
				<ul>
					<li class="titNM">To do List</li>
				</ul>
			</div>
			<div id="taskDiv">
	 			<div class="tabs">
					<ul>
						<li id="task1" class="on titNM" onclick="javascript:fnClickedTask('1');">${menu.LN00194}<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task2" class="titNM" onclick="javascript:fnClickedTask('2');">${menu.LN00242}<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task3" class="titNM" onclick="javascript:fnClickedTask('3');">${menu.LN00323 }<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreTask();">
						<li>more</li>
					</ul>
				</div>
				<div id="taskFrame" class="tabFrame postInfo"></div>	
			</div>
			
			<div id="csListDiv">
				<div class="secTit">
					<ul>
						<li class="titNM">Last updated within 7 days</li>
					</ul>
					<ul class="morebtn" onClick="fnGoMore('','CngSet')">
						<li>more</li>
					</ul>
				</div>
				<div id="csFrame" class="postInfo">	</div>	
			</div>
		</div>
		<div id="rightDiv">
			<div id="chartAndMyItem">
				<div id="chartDiv">
					<div class="charTit">
						<ul>
							<li class="titNM">Business Process Statistics</li>
						</ul>
						<ul class="morebtn" onClick="fnGoMore('','Proc')">
							<li>Detail ></li>
						</ul>
					</div>
					<div id="subPrcFrame"></div>	
				</div>
				<div id="myItemCntFrame">
					<ul style="height:100%; position:relative;">
						<li id="myItemTitle">Process Contents</li>		
							<c:set var="size" value="${fn:length(viewItemTypeList)}" />					
							<c:forEach items="${viewItemTypeList}" var="list" varStatus="status" step="6">
							<div id="viewItemTypeListPage${status.count}"
							<c:choose><c:when test="${status.count ne 1 }"> style='display:none;'</c:when><c:otherwise>style='height:83%;'</c:otherwise></c:choose> >
								<ul class="myItemList">
									<li class="myItemCon"onclick="goArcMenu('${viewItemTypeList[status.index].itemArcCode}','${viewItemTypeList[status.index].itemArcIcon}','${viewItemTypeList[status.index].itemArcStyle}','${viewItemTypeList[status.index].itemURL}.do?${viewItemTypeList[status.index].itemMenuVar}${viewItemTypeList[status.index].itemArcVar}')">
										<span  style="background-color:${viewItemTypeList[status.index].itemDefColor};"><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index].itemName}</pre><p>${viewItemTypeList[status.index].itemCnt}</p>
									</li>
									<c:if test="${status.index+1 < size}">
									<li class="myItemCon" onclick="goArcMenu('${viewItemTypeList[status.index+1].itemArcCode}','${viewItemTypeList[status.index+1].itemArcIcon}','${viewItemTypeList[status.index+1].itemArcStyle}','${viewItemTypeList[status.index+1].itemURL}.do?${viewItemTypeList[status.index+1].itemMenuVar}${viewItemTypeList[status.index+1].itemArcVar}')">
										<span  style="background-color:${viewItemTypeList[status.index+1].itemDefColor};" ><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index+1].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index+1].itemName}</pre><p>${viewItemTypeList[status.index+1].itemCnt}</p>
									</li>
									</c:if>
								</ul>						
								<c:if test="${status.index+2 < size || status.index+3 < size}">		
								<ul class="myItemList">
									<c:if test="${status.index+2 < size}">
									<li class="myItemCon" onclick="goArcMenu('${viewItemTypeList[status.index+2].itemArcCode}','${viewItemTypeList[status.index+2].itemArcIcon}','${viewItemTypeList[status.index+2].itemArcStyle}','${viewItemTypeList[status.index+2].itemURL}.do?${viewItemTypeList[status.index+2].itemMenuVar}${viewItemTypeList[status.index+2].itemArcVar}')">
										<span  style="background-color:${viewItemTypeList[status.index+2].itemDefColor};" ><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index+2].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index+2].itemName}</pre><p>${viewItemTypeList[status.index+2].itemCnt}</p>
									</li>
									</c:if>
									<c:if test="${status.index+3 < size}">
									<li class="myItemCon" onclick="goArcMenu('${viewItemTypeList[status.index+3].itemArcCode}','${viewItemTypeList[status.index+3].itemArcIcon}','${viewItemTypeList[status.index+3].itemArcStyle}','${viewItemTypeList[status.index+3].itemURL}.do?${viewItemTypeList[status.index+3].itemMenuVar}${viewItemTypeList[status.index+3].itemArcVar}')">
										<span style="background-color:${viewItemTypeList[status.index+3].itemDefColor};" ><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index+3].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index+3].itemName}</pre><p>${viewItemTypeList[status.index+3].itemCnt}</p>
									</li>
									</c:if>
								</ul>
								</c:if>
								<c:if test="${status.index+4 < size || status.index+5 < size}">
								<ul class="myItemList">
									<c:if test="${status.index+4 < size}">
									<li class="myItemCon" onclick="goArcMenu('${viewItemTypeList[status.index+4].itemArcCode}','${viewItemTypeList[status.index+4].itemArcIcon}','${viewItemTypeList[status.index+4].itemArcStyle}','${viewItemTypeList[status.index+4].itemURL}.do?${viewItemTypeList[status.index+4].itemMenuVar}${viewItemTypeList[status.index+4].itemArcVar}')">
										<span style="background-color:${viewItemTypeList[status.index+4].itemDefColor};"><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index+4].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index+4].itemName}</pre><p>${viewItemTypeList[status.index+4].itemCnt}</p>
									</li>	
									</c:if>							
									
									<c:if test="${status.index+5 < size}">
									<li class="myItemCon" onclick="goArcMenu('${viewItemTypeList[status.index+5].itemArcCode}','${viewItemTypeList[status.index+5].itemArcIcon}','${viewItemTypeList[status.index+5].itemArcStyle}','${viewItemTypeList[status.index+5].itemURL}.do?${viewItemTypeList[status.index+5].itemMenuVar}${viewItemTypeList[status.index+5].itemArcVar}')">
										<span style="background-color:${viewItemTypeList[status.index+5].itemDefColor};" ><img src="${root}${HTML_IMG_DIR_ITEM}/${viewItemTypeList[status.index+5].itemIcon}"/></span>
										<pre>${viewItemTypeList[status.index+5].itemName}</pre><p>${viewItemTypeList[status.index+5].itemCnt}</p>
									</li>
									</c:if>
								</ul>	
								</c:if>
								</div>
							</c:forEach>
							<div id="pgCheckBoxDiv">
								<c:forEach items="${viewItemTypeList}" var="list" varStatus="status" step="6">
									<input type="radio" id="${status.count}" name="pgCheckBox" value="${status.count}" <c:if test="${status.count eq 1 }"> checked="checked"</c:if>/><label for="${status.count}"></label> 
								</c:forEach>
							</div>
					</ul>
				</div>
			</div>

			<c:choose>
		       <c:when test="${empty(srType)}">
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
		    	</c:when>
		    	<c:otherwise>
					<div id="esrListDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">${menu.LN00333}</li>
							</ul>
							<ul class="morebtn" onClick="javascript:fnGoMore('','ESR');">
								<li>more</li>
							</ul>
						</div>
						<div id="esrFrame" class="postInfo"></div>	
					</div>       
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>