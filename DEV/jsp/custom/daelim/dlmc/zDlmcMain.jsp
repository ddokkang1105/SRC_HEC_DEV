<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/" var="root"/>
<!DOCTYPE html">
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
.myItemList .myItemCon span{
 box-sizing: border-box;
 color:#fff; 
 align:center;
  font-weight: 600; 
 font-size:10px;
  width:38px; 
  height:30px; 
}


</style>

<script type="text/javascript">
    var noticType;var menuIndex = "4 1 3";  
    var itemTypeCode = "";
    var templCode = "${templCode}";
    var csType="1";
    
    $(document).ready(function(){
// 		setSchdlFrame();
		fnClickedTab(1);
		setCSFrame(1);
        setProcessFrame();
        setProcessTeamChartFrame(); 
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
		document.getElementById("task3").children[0].innerHTML = "${fn:length(myBrdList)}";
	});
    
    function setDivSize(){
    	$("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#teamProcessChartDiv > div:nth-child(2)").innerHeight($("#teamProcessChartDiv").height()-$("#teamProcessChartDiv > div:nth-child(1)").height());
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

    // last updated 10 items
    function setCSFrame(avg){
    	var realMenuIndex = "1 2 3".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#cs" + realMenuIndex[i]).addClass("on");
			} else {
				$("#cs" + realMenuIndex[i]).removeClass("on");
			}
		}
    	
		var classCode = "";
		
    	if(avg == "1") {
    		csType = "1";
    		itemTypeCode = "OJ00001"; // process
    		classCode = "CL01005";
    	}
    	if(avg == "2") {
    		csType = "5";
    		itemTypeCode = "OJ00005";
    		classCode = "CL05004";
    	}
    	if(avg == "3") {
    		csType = "17";
    		itemTypeCode = "OJ00017"; // risk
    		classCode = "CL17002";
    	}
    	
    	
        var url = "mainChangeSetList.do";   
		var target = "csFrame";
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode="+itemTypeCode+"&qryOption=01&classCode="+classCode;
		
    	/* if(defDimTypeID != null && defDimTypeID != "" && defDimValueID != null && defDimValueID != ""){
    		data += "&dimTypeID=" + defDimTypeID + "&dimValueID=" + defDimValueID;
    	}
    	 */
        ajaxPage(url, data, target);
    }
    
    function fnGoTreeItem(itemID, refresh){    	
    	parent.clickMainMenu("PAL0101",'','', '','','','itemMgt.do?tLink=Y&nodeID='+itemID,'','','','','','','','','Y');
    }
    
    function fnGoDimTree(defDimValueID, refresh){    
    	parent.clickMainMenu("PAL01TM",'','', defDimValueID,'','','itemMgt.do?nodeID=1','','','','','','','','','Y');
    }
    
    var teamProcessFlag = "1";
    function fnGoTeamProcess(){
    	if(teamProcessFlag == "1"){
    		teamProcessFlag = "2";
    		setProcessTeamGridFrame();
    	}else{
    		teamProcessFlag = "1";
    		setProcessTeamChartFrame();
    	}
    }
    
    function setProcessTeamChartFrame(){ 
	    var url = "mainSttProcessByTeamBarChart.do";   
	    var target = "processTeamFrame";
	    var data = "";
	    ajaxPage(url, data, target);  
    }
    
    function setProcessTeamGridFrame(){ 
	    var url = "mainSttProcessByTeamList.do";   
	    var target = "processTeamFrame";
	    var data = "";
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
        var url = "zdlmcMainSttProcessBarChart.do";   
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
    
    function settypeCodeListPageing(avg) {  }
    
    function fnClickMoreBoard(id){
    	var boardMgtID = $("#boardMgtID").val();
    	if(boardMgtID ==""){boardMgtID="1";}
    	if(id){boardMgtID=id;}
    	console.log(id);
    	console.log(boardMgtID);
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
			<c:forEach items="${myBrdList}" var="list" varStatus="status">
				result += '<ul onclick="fnDetail(\'BRD0002\',\'${list.BoardID}\')">';
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
		
		var realMenuIndex = "1 2 3".split(' ');
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
			var data = "&BoardMgtID=BRD0002&myBoard=Y";
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
    
    function fnClickMoreChangeSet(){
		if(csType == "1") {
    		classCode = "CL01005";
    	}
    	if(csType == "5") {
    		classCode = "CL05004";
    	}
    	if(csType == "17") {
    		classCode = "CL17002";
    	}
    	

    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '','',classCode,'','');
    }
    
</script>
<style>
#mainWrapper {
	top:2%;
	width: 95%;
}

#leftDiv , #rightDiv {
	width: 48.5%;
}

#searchDiv {
	width: 100%;
    height: calc(22% - 43px);
    margin-bottom:2%;
    border: 1px solid #e6e6e6;
}

#searchDiv ul{
	padding: 29px 20px;
}

#searchDiv > ul > li > label {
	font-size:12px;
	width:8%;
	display:inline-block;
}

#noticeDiv {
	width: 100%;
    height: calc(22% - 43px);
    margin-bottom:2%;
    box-shadow:rgba(0,0,0,0.1) 1px 1px 5px 0px;
    background: #fff;
}

#tabFrame0 {
	height:100%;
}

#taskDiv {
	width: 100%;
    background: #fff;
    margin-bottom:2%;
    box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;
}

#taskDiv span {
	color: #fff;
	margin-left: 10px;
	padding: 1px 7px 3px 7px;
	font-weight: normal;
	background: #0F80E2;
	border-radius: 10px;
}

#docDiv {
	width: 100%;
    background: #fff;
    margin-bottom:2%;
    box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;
}

#myItemCntFrame {
	float: right;
   	margin: 0;
}

#mainImageFrame {
	background: url(/cmm/common/images/img_olmMainHome.png) 0 0/100% 100%;
}

#csListDiv{
	height: calc(32% - 8px);
	box-shadow: rgb(0 0 0 / 10%) 1px 1px 5px 0px;
}

#csListDiv .postInfo {
	box-shadow: none;
}

#popupDiv {
	width:1000px;
}

#charTit2 {
	color: #3F3C3C;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0px 20px;
    font-size: max(0.8vw,12px);
    font-weight:700;
}


</style>
</head>

<body id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
	<input id="boardMgtID" type="hidden" value="" >
	<div id="mainWrapper">
		<div id="leftDiv">		
			<div id="mainImageFrame"></div>
			<div id="chartProcessDiv" >
				<div id="chartDiv" style="float: left; background-color:transparent;color:#3F3C3C;">
					<div class="charTit">
						<ul>
							<li id="charTit2" style="padding: 0px 20px;" >Value Chain별 Process 현황</li>
						</ul>
						<ul class="morebtn" style="color:#3F3C3C" onClick="fnGoMore('','Proc')">
							Detail >
						</ul>
					</div>
					<div id="subPrcFrame"   style=" height:300px; background-color:#fff ; box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;"></div>	
				</div>
				<div id="myItemCntFrame">
					<ul style="height:100%; position:relative;">
						<li id="myItemTitle">Contents</li>		
							<div id="viewItemTypeListPage1" style='height:88%;'>
								<ul class="myItemList"  >
									<li class="myItemCon" style="cursor:pointer;padding:3% 7% 3%;"onClick="goArcMenu('PAL0101','ar_map.png','csh_process','itemMgt.do?&amp;&tLink=Y&nodeID=1')">
										<span style="background-color:#4265ee;  ">프로<br>세스</span>
										<pre style="text-overflow: unset;">L4-Process</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black;">(${L4ProcessCount}개)</pre>
									
									</li>
									<li class="myItemCon" style="cursor:pointer;padding:3% 7% 3%;" onClick="goArcMenu('PAL0101','ar_map.png','csh_process','itemMgt.do?&amp;&tLink=Y&nodeID=1')">
										<span style="background-color:#4265ee;" >프로<br>세스</span>
										<%-- <span style="background-color:#4265ee;"><img src="${root}${HTML_IMG_DIR_ITEM}/img_process.png"/></span> --%>
										<pre style="text-overflow: unset;">L5-Activity</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black;">(${L5ActivityCount}개)</pre>									
									</li>
								</ul>	
								
								<ul class="myItemList" >
									<li class="myItemCon"  style="cursor:pointer;padding:3% 7% 3%;" onClick="goArcMenu('PAL05A','arc5.png','csh_document','itemFolderMgt.do?&amp;&objClassList=CL05004&nodeID=124063')">
										<span style="background-color:#14baed;">품질<br>경영</span> 
										<%-- <span style="background-color:#14baed;"><img src="${root}${HTML_IMG_DIR_ITEM}/img_manual.png"/></span> --%>
										<pre style="text-overflow: unset;">IATF-Manual</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black; ">(82개)</pre>									
									</li>
									<li class="myItemCon" style="cursor:pointer;padding:3% 7% 3%;" onClick ="goArcMenu('PAL05B','arc5.png','csh_document','itemFolderMgt.do?&amp;&objClassList=CL05003')">
										<span style="background-color:#14baed;">품질<br>경영</span> 
										<pre style="text-overflow: unset;">ISO-Manual</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black;">(61개)</pre>									
									</li>
								</ul>	
								
								<ul class="myItemList" >
									<li class="myItemCon" style="cursor:pointer;padding:3% 7% 3%;" onClick ="goArcMenu('PAL17','icon_board.png','csh_yellowbooks','itemFolderMgt.do?&amp;&nodeID=17')">
									<span style="background-color:#c1272d;">내부<br>통제 </span>
									<%-- 	<span style="background-color:#c1272d;"><img src="${root}${HTML_IMG_DIR_ITEM}/img_risk.png"/></span> --%>
										<pre style="text-overflow: unset;">Risk</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black;">(242개)</pre>									
									</li>
									
									<li class="myItemCon" style="cursor:pointer;padding:3% 7% 3%;" onClick ="goArcMenu('PAL17','icon_board.png','csh_yellowbooks','itemFolderMgt.do?&amp;&nodeID=17')">
										<span style="background-color:#c1272d;">내부<br>통제 </span>
										<%-- span style="background-color:#c1272d;"><img src="${root}${HTML_IMG_DIR_ITEM}/img_control.png"/></span> --%>
										<pre style="text-overflow: unset;">Control</pre>
										<pre style="text-overflow: unset; font-weight :900;color :black;">(292개)</pre>								
									</li>
								</ul>	
							</div>			
						<%-- 	
							<div id="pgCheckBoxDiv">
								<c:forEach items="${viewItemTypeList}" var="list" varStatus="status" step="6">
									<input type="radio" id="${status.count}" name="pgCheckBox" value="${status.count}" <c:if test="${status.count eq 1 }"> checked="checked"</c:if>/><label for="${status.count}"></label> 
								</c:forEach>
							</div> --%>
					</ul>
				</div>
			</div>

			
			<div id="teamProcessChartDiv">
				<div class="secTit">
					<ul>
						<li class="titNM">부서별 Process 현황</li>
					</ul>
					<ul class="morebtn" style="color:#3F3C3C" onClick="fnGoTeamProcess()()">
						Detail >
					</ul>
				</div>
				<div id="processTeamFrame"  class="postInfo" style="height:300px;"></div>
			</div>       
				
		</div>
		
		<div id="rightDiv">
			<div id="boardDiv" style="height:27%;">
	 			<div class="tabs">
					<ul>
						<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00001}</li>
						<li id="pliugt3" class="titNM" onclick="javascript:fnClickedTab('3');">${menu.LN00029}</li>
						<li id="pliugt4" class="titNM" onclick="javascript:fnClickedTab('4');">${menu.LN00215}</li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
						<li>more</li>
					</ul>
				</div>
				<div id="tabFrame1" class="tabFrame"></div>	
			</div>
			

			<div class="secTit">
				<ul>
					<li class="titNM">나의 업무</li>
				</ul>
			</div>
			<div id="taskDiv">
	 			<div class="tabs">
					<ul>
						<li id="task1" class="on titNM" onclick="javascript:fnClickedTask('1');">진행 중<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task2" class="titNM" onclick="javascript:fnClickedTask('2');">${menu.LN00242}<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task3" class="titNM" onclick="javascript:fnClickedTask('3');">${menu.LN00376}<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
					</ul>
					<ul class="morebtn" onClick="javascript:fnClickMoreTask();">
						<li>more</li>
					</ul>
				</div>
				<div id="taskFrame" class="tabFrame postInfo"></div>	
			</div>
			
			<div class="secTit csArea">
				<ul>
					<li class="titNM">최근 변경된 List</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreChangeSet();">
					<li>more</li>
				</ul>
			</div>
				
			<div id="csListDiv" class="csArea">
				<div class="tabs">
					<ul>
						<li id="cs1" class="titNM" onclick="javascript:setCSFrame(1);">${menu.LN00011}</li>
						<li id="cs2" class="titNM" onclick="javascript:setCSFrame(2);">품질경영</li>
						<li id="cs3" class="titNM" onclick="javascript:setCSFrame(3);">내부통제</li>
					</ul>
				</div>
				<div id="csFrame" class="postInfo" style="overflow-x:hidden;"></div>	
			</div>
		</div>

	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>