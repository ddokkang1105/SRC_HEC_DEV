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
    	fnActivitySttByPrcoChartFrame();
		fnClickedTab(1);
        setProcessFrame();
        setProcessTeamChartFrame(); 
        setProcChangeSttatByLvl();
        setDivSize();
        window.onresize = function() {
        	setDivSize();
        };
        
        $(".myItemCon>.myItemConSpan>img").each(function(i, item){
            var src = $(item).attr("src");	// src 경로 구하기
            src.substr(src.length-4,4); // .png 잘라내기
            src.substr(0,src.length-4); // .png 전까지 잘라내기
            $(item).attr("src",src.substr(0,src.length-4)+"_main"+src.substr(src.length-4,4)); // 중간에 _main 붙여서 새로운 
        });
	});
    
    function setDivSize(){
        $("#chartRightTopDiv > div:nth-child(2)").innerHeight($("#chartRightTopDiv").height()-$("#chartRightTopDiv > div:nth-child(1)").height());
        $("#chartDiv > div:nth-child(2)").innerHeight($("#chartDiv").height()-$("#chartDiv > div:nth-child(1)").height());
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
	    var url = "zHarimMainSttProcessByL1Chart.do";   
	    var target = "MegaProcessFrame";
	    var data = "";
	    ajaxPage(url, data, target);  
    }
    
    function setProcessTeamGridFrame(){ 
	    var url = "mainSttProcessByTeamList.do";   
	    var target = "MegaProcessFrame";
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
        var url = "mainSttProcessBarChart.do";   
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
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }

    function goArcMenu(avg,avg2,avg3,avg4) {
    	if(avg != "")
    		parent.clickMainMenu(avg,'',avg2, '',avg3,avg3,avg4);
    }
    
    function fnItemInfo(avg1){
    	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
    	var w = 1200;
    	var h = 900;
    	itmInfoPopup(url,w,h,avg1);
	}
   
    // Mega Process 별 activity 현황
    function fnActivitySttByPrcoChartFrame(){
    	var url = "zHarimMainActivitySttProcChart.do";   
	    var target = "activitySttByProcFrame";
	    var data = "";
	    ajaxPage(url, data, target);  
    }
    
    function setProcChangeSttatByLvl(){
    	var url = "procChangeSttatByLvl.do";   
	    var target = "procChangeSttatByLvlFrame";
	    var data = "";
	    ajaxPage(url, data, target);  
    }
    
    function fnGoTreeItem(itemID, refresh){    	
    	parent.clickMainMenu("PAL0101",'','', '','','','itemMgt.do?tLink=Y&nodeID='+itemID,'','','','','','','','','Y');
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

/* common */
.charTit li.charTit2 {
	color: #3F3C3C;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0px 20px;
    font-size: max(0.8vw,12px);
    font-weight:700;
}
#mainImageFrame {
	background: url(/cmm/common/images/img_olmMainHome.png) 0 0/100% 100%;
}
#popupDiv {
	width:1000px;
}

/* top section */
#chartAndMyItem, #chartRightTopDiv{
	width:100%;
	height:50%;
	margin-bottom:8%;
}

/* [Rule-Set/내부 통제] */
#myItemCntFrame {
	float: left;
   	margin: 0;
}
#viewItemTypeListPage1 {
	height: 89%;
}
.myItemList {
	width:100%;
	height: 46.5%;
}
#myItemTitle {
	color: #3F3C3C;
    display: flex;
    align-items: center;
    font-size: max(0.8vw,12px);
    font-weight:700;
    height: 16%;
    max-height: 43px;
    min-height:35px;
    width: 99%;
    padding-right: 1%;
}
.myItemList:first-child{
	margin-bottom: 10%;
}
.myItemList .myItemCon {
	padding: 0px;
	margin: 0px;
	width: 45%;
	height:100%;
	cursor:pointer;
}
.myItemList .myItemCon:first-child {
	margin-right:10%;
}
.myItemList .myItemCon span.myItemConSpan {
 box-sizing: border-box;
 color:#fff; 
 text-align:center;
 font-weight: 600; 
 font-size:13px;
 width:100%;
 height:60%; 
}
.myItemList .myItemCon span:last-child {
	text-align:center;
	background: #fff;
	width:100%;
	font-size:20px;
}

/*Mega 프로세스별 Sub 프로세스(L4) 현황*/
#chartDiv {
	float: right;
	background-color:transparent;
	color:#3F3C3C;
}
#chartArea2 {
	width: 100%!important;
	height: auto!important;
}
.tabs ul:first-child, .secTit ul:first-child, .charTit ul:first-child {
	width: 80%;
}
.morebtn {
	width: 11%!important;
}

/* Sub 프로세스(L4) 설계작업 현황 */
#chartRightBottomDiv {
	height:32%;
}
/* boardDiv */
#LeftBottomDiv { 
	height: 32%;
 }
#boardDiv { 
	height: 83%;
	margin-bottom:0;
 }

/* grid */
#gridArea {
	box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px
}

.dhx_grid-content {
	border: 0px!important;
	background: none!important;
}
.dhx_layout, .dhx_layout-cell, .dhx_grid{
	background: none!important;
}
.dhx_data-wrap {
	background: #ffffff;
}

.dhx_grid-row .dhx_grid-cell:last-child {
	border-right: 0px!important;
}
.dhx_grid-header-cell:last-child {
	border-right: 0px!important;
}
/* .dhx_grid-row:last-child {
	border-bottom: 0px!important;
} */

@media all and (max-width:1536px){
	/* 위 아래 간격 조정 */
	#mainWrapper {
		top: 3%;
	}
	#chartAndMyItem, #chartRightTopDiv {
		margin-bottom:4%;
	}
	
	/* 폰트 조절 */
	tspan{
		font-size:9px!important;
	}
	
	/* Rule-Set / 내부통제 */
	.myItemList .myItemCon span.myItemConSpan {
		font-size: 11px;
	}
	.myItemList {
		height: 45%;
	}
	.myItemList:first-child{
		margin-bottom:6%;
	}
	
	/* Mega 프로세스별 Sub 프로세스(L4)현황 라벨 우치 조절 */
	#chartArea2 .legend-item:first-child {
		transform: translate(-40px, 0px);
	}
	#chartArea2 .legend-item:nth-child(2) {
		transform: translate(30px, 0px);
	}
	#chartArea2 .legend-item:nth-child(3) {
		transform: translate(130px, 0px);
	}
	#chartArea2 .legend-item:nth-child(4) {
		transform: translate(230px, 0px);
	}
	#chartArea2 .legend-item:last-child {
		transform: translate(300px, 0px);
	}
	
	/* board / Sub 프로세스(L4) 설계작업 현황 height 조정 */
	#chartRightBottomDiv { 
		height: 41.5%;
	}
	/* boardDiv */
	#LeftBottomDiv { 
		height: 41.5%;
	 }
	
	/* grid 조절 */
	.dhx_grid-header-cell-text_content {
		font-size: 9px!important;
	}
	.dhx_grid-cell {
		padding: 0 4px!important;
		font-size: 9px!important;
		height:40.7px!important;
	}
	.dhx_grid-row {
		height:40.7px!important;
	}
	
	.dhx_data-wrap {
		height: auto!important;
	}
	
	.chart2_table colgroup col:first-child {
		width: 45%!important;
	}
	.chart2_table colgroup col:last-child {
		width: 55%!important;
	}
}

@media all and (max-width:1280px){
	
	.dhx_grid-cell {
		height:30px!important;
	}
	.dhx_grid-row {
		height:30.5px!important;
	}
	.dhx_layout-cell {
		width: 101.6%;
	}
}


</style>
</head>

<body id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
	<input id="boardMgtID" type="hidden" value="" >
	<div id="mainWrapper">
		<div id="leftDiv">		
			<div id="chartAndMyItem" >
				<!-- Mega 프로세스별 Sub 프로세스(L4) 현황 start -->
				<div id="chartDiv">
					<div class="charTit">
						<ul>
							<li class="charTit2">Mega 프로세스별 Sub 프로세스(L4) 현황</li>
						</ul>
						<ul class="morebtn" style="color:#3F3C3C" onClick="fnGoMore('','Proc')">
							Detail >
						</ul>
					</div>
					<div id="MegaProcessFrame"  class="postInfo" style=" height:330px; background-color:#fff ; box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;"></div>	
				</div>
				<!-- Mega 프로세스별 Sub 프로세스(L4) 현황 end -->
				
				<!-- Rule-Set/내부 통제 start -->
				<div id="myItemCntFrame">
					<ul style="height:100%; position:relative;">
						<li id="myItemTitle">Rule-Set/내부 통제</li>		
						<div id="viewItemTypeListPage1">
							<ul class="myItemList">
								<li class="myItemCon" onClick="goArcMenu('PAL07','ar_map.png','csh_process','itemMgt.do?&amp;&tLink=Y&nodeID=7')">
									<span class="myItemConSpan" style="background-color:#4265ee;">Rule-Set</span>
									<span>${ruleSetActivityCount}</span>
								</li>
								<li class="myItemCon"  onClick="goArcMenu('PAL07','ar_map.png','csh_process','itemMgt.do?&amp;&tLink=Y&nodeID=7')">
									<span class="myItemConSpan" style="background-color:#4265ee;" >Rule-Set <br />매핑 Activity</span>
									<span>${ruleSetCXNActivityCount}</span>								
								</li>
							</ul>	
							
							<ul class="myItemList">
								<li class="myItemCon"  onClick ="goArcMenu('PAL09','icon_board.png','csh_yellowbooks','itemFolderMgt.do?&amp;&nodeID=9')">
								<span class="myItemConSpan" style="background-color:#27bac1;">내부통제</span>
								<span>${iamActivityCount}</span>
																
								</li>
								
								<li class="myItemCon"  onClick ="goArcMenu('PAL09','icon_board.png','csh_yellowbooks','itemFolderMgt.do?&amp;&nodeID=9')">
									<span class="myItemConSpan" style="background-color:#27bac1;">내부통제<br />매핑 Activity</span>
									<span>${iamCXNActivityCount}</span>						
								</li>
							</ul>	
						</div>			
					</ul>
				</div>
				<!-- Rule-Set/내부 통제 end -->
			</div>

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
					<div id="tabFrame1" class="tabFrame" style="height:calc(105% - 40px); box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;" ></div>	
				</div>
			</div>
			<!-- 게시판 end -->
		</div>    
		
		<div id="rightDiv">
			<!-- Mega 프로세스별 Activity(L5) 현황 start -->
			<div id="chartRightTopDiv">
				<div class="charTit">
					<ul>
						<li class="charTit2" style="padding: 0px 20px;" >Mega 프로세스별 Activity(L5) 현황</li>
					</ul>
					<ul class="morebtn" style="color:#3F3C3C" onClick="fnGoMore('','Proc')">
					</ul>
				</div>
				<div id="activitySttByProcFrame" class="postInfo" style=" height:100%; background-color:#fff ; box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;"></div>	
			</div>
			<!-- Mega 프로세스별 Activity(L5) 현황 end -->
			
			<!-- Sub 프로세스(L4) 설계작업 현황 start -->
			<div id="chartRightBottomDiv">
				<div class="charTit">
					<ul>
						<li class="charTit2" style="padding: 0px 20px;">Sub 프로세스(L4) 설계작업 현황</li>
					</ul>
				</div>
				<div id="procChangeSttatByLvlFrame" style="height:86%; background-color:#fff ; box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;"></div>	
			</div>
			<!-- Sub 프로세스(L4) 설계작업 현황 end -->
		</div>
		
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>
<style>
.pdL10 {
    padding-left: 0 !important;
}

.pdR10 {
    padding-right: 0 !important;
}
</style>