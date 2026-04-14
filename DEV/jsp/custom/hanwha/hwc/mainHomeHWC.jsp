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
<link rel="stylesheet" type="text/css" href="${root}cmm/hanwha/css/process_styles.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />

<script type="text/javascript">
    var noticType;var menuIndex = "1 3 4";
    var ruleType;var ruleIndex = "5 6 7";
    var i_gridArea;
    
    $(document).ready(function(){
        setNoticFrame("3");
        //setRuleFrame("6");
        setDivSize();
        window.onresize = function() {
        	setDivSize();
        };
    });
    
    function setDivSize(){
    	$("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
    }
    
    function setNoticFrame(avg){
    	$("#boardMgtID").val(avg);
        var url = "mainBoardList.do";   
        var target = "subBrdFrame";var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+avg;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "pli");
    }
    
    function setRuleFrame(avg){
    	var url = "";
    	var data = "";
    	if(avg == '7') {
            url = "mainChangeSetList.do";   
            data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&memberState=${sessionScope.loginInfo.sessionState}";
    	}
    	else if(avg == '5'){
            url = "mainAuthorLogList.do";   
            data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isMain=Y";      
    	}
    	
    	if(avg == '6'){
    		$("#subRuleFrame").hide();
    		$("#subRuleFrame2").show();
    		gridItemSearchInit();
    	}
    	else {
    		$("#subRuleFrame").show();
    		$("#subRuleFrame2").hide();
	        var target = "subRuleFrame";
	        ajaxPage(url, data, target);
    	}
    	setSubTab(ruleIndex, avg, "pli");
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
    	var url  = "fileDownload.do?sysFileName="+sysFileName+"&originalFileName="+encodeURIComponent(originalFileName)+"&filePath="+filePath+"&seq="+seq+"&scrnType="+avg5;
    	ajaxSubmitNoAdd(document.mainLayerFrm, url,"saveFrame");
    }
    
    function fnClickMoreBoard(){
    	var boardMgtID = $("#boardMgtID").val();
    	if(boardMgtID ==""){boardMgtID="1";}
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    function fnSearch(){
    	var radioObj = document.all("searchMode");
		var searchMode = "";
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				searchMode = radioObj[i].value;
				break;
			}
		}
		if(searchMode == "1"){
			fnSearchProcess("FLTP009","OJ00007","CL07002",""); 
		}else if(searchMode == "2"){ 
			fnSearchProcess("FLTP000","OJ00001","CL01005",""); 
		}else if(searchMode == "3"){
			fnSearchProcess("","OJ00007","CL07002","Name");
		}
    }
    
    function fnSearchProcess(fltpCode,tCode,cCode,Name){
    	var searchValue = $("#searchValue").val();
    	
    	if(Name == "Name") {
    		Name = searchValue;
    		searchValue = "";
    	}
    	
    	var url = "goDocumentList.do";
    	var target = "mainLayerFrm";
    	var data = "itemTypeCode="+tCode+"&classCode="+cCode+"&screenType=main&idExist=Y&searchKey=Name&searchValue="+searchValue+"&fltpCode="+fltpCode+"&regMemberName="+Name; 
    	ajaxPage(url, data, target);
    }
    
    
    function setProcessL1(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
    }

    function fnClickMoreChangeSet(){
    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '');
    }
    
    function fnClickMoreAuthorLogList(){
    	parent.clickMainMenu('AUTHORLOG', 'AUTHORLOG','','','','','.do?', '');
    }

    function gridItemSearchInit(){		
		var d = setGridItemSearchData();		
		i_gridArea = fnNewInitGrid("subRuleFrame2", d);
		
		i_gridArea.setImagePath("/cmm/hanwha/images///");
		i_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	
		//i_gridArea.setColumnHidden(6, true);
		
		i_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	
		fnLoadDhtmlxGridJson(i_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}	
    
    function gridOnRowSelect(id, ind) {    	

		var itemID = i_gridArea.cells(id, 6).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);	
		
    }
	function setGridItemSearchData(){
		var result = new Object();
		result.title = "${title}"; 
		result.key = "search_SQL.getSearchMultiList";
		result.header = "${menu.LN00024},담당자,ID,사규/프로세스명,최종수정일,";
		result.cols = "Name|Identifier|ItemName|LastUpdated|ItemID";
		result.widths = "30,50,200,300,150,0"; // base 검색
		result.sorting = "int,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&isLastSearch=Y&idExist=Y"
		 			+ "&pageNo=1&LIST_PAGE_SCALE=20&ItemTypeCodes='OJ00001','OJ00007'&ClassCodes='CL01004','CL07002'";
		 

		return result;
	}
	

    function setReport() {
    	var url = "zhwc_ProcessItemStatistics.do";
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isMainMenu=Y";
    	var target = "mainLayerFrm";
    	
    	ajaxPage(url, data, target);
    }
	
</script>

<style>
.tabs {width:100%;}
.titNM {font-size:14px;}
#boardDiv{height:233px; border:1px solid #c8c8c8;float: left;    box-shadow: none;}
.postInfo ul{box-sizing: content-box;}
</style>
</head>

<BODY>

<div class="noform" id="mainLayer" style="height:100%;background:#fff;">
<form name="mainLayerFrm" id="mainLayerFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input id="boardMgtID" type="hidden" value="" >

<div class="row">
	<div class="col1">		
		<!-- 메인 이미지 -->
		<div class="main_img"><img src="/cmm/hanwha/images//main_img_04.png" alt="H-PIP"/></div>
	</div>
	
	<div class="col2">
		
		<!-- Search &  Process statistics -->
		 <div class="col2_04">
		 	<h3 style="width:100%;margin-top:0px;">검색 및 통계 <span>| SEARCH AND STATISTICS</span></h3>
			 <div class="searchBox">
				<li>
					<input type="text" id="searchValue" name="searchValue" class="text" value="">
					<input id="btnSearch" type="image" class="image" src="/cmm/hanwha/images//btn_icon_search.gif" value="Search" style="display:inline-block;" Onclick="fnSearch();">
			 	</li>
			 	<li>
			 		<input type="radio" id="mode01" name="searchMode" value=1 checked="checked">					
					<span style="vertical-align:middle;"><label for="mode01"><b>규정</b></label></span>
					<input type="radio" id="mode03" name="searchMode" value=2>
					<span style="vertical-align:middle;"><label for="mode03"><b>Process 부속서</b></label></span>
					<input type="radio" id="mode04" name="searchMode" value=3>
					<span style="vertical-align:middle;"><label for="mode04"><b>${menu.LN00004}</b></label></span>
			 	</li>
			 </div>
			 
			 <div class="statics"> 
			 	<a href="javascript:setReport();">
			 		<img src="/cmm/hanwha/images///main_statics_img.png" />
			 		<span>바로가기 ></span>
			 	</a>
			 </div>
		 </div>
				
		<!-- 규정 -->
		<div class="col2_01">
			<h3>규정 <span>| RULE</span></h3>
			<ul>
				<li onclick="setProcessL1('AR010710','135984');"><p><img style="width:13px;" src="/cmm/hanwha/images///hwc_rule_icon01.png" alt="일반규정" /> 규정/지침/세칙</p></li>
				<li onclick="setProcessL1('AR010730','15');"><p><img style="width:16px;"  src="/cmm/hanwha/images///hwc_rule_icon02.png" alt="위임전결규정" /> 위임전결 규정</p></li>
				<li onclick="setProcessL1('AR010712','136383');"><p><img style="width:16px;"  src="/cmm/hanwha/images///hwc_rule_icon03.png" alt="안전환경보건 업무절차" /> 안전환경보건 업무절차</p></li>
				<li onclick="setProcessL1('AR010713','136385');"><p><img style="width:13px;"  src="/cmm/hanwha/images///hwc_rule_icon04.png" alt="품질전사규정" /> 품질전사 규정</p></li>
			</ul>
			
		</div>
		<!-- 공통 프로세스 -->
		<div class="col2_02">
			<h3>공통 프로세스 <span>| COMMON PROCESS</span></h3>
			<ul class="mgB15 col2_02_top">
				<li onclick="setProcessL1('AR010101','102585');"><p><img src="/cmm/hanwha/images///hwc_common_icon01.png" alt="전략" /> 전략</p></li>
				<li onclick="setProcessL1('AR010102','102695');"><p><img src="/cmm/hanwha/images///hwc_common_icon02.png" alt="고객/시장" /> 고객/시장</p></li>
				<li onclick="setProcessL1('AR010103','102845');"><p><img src="/cmm/hanwha/images///hwc_common_icon03.png" alt="사업관리" /> 사업관리</p></li>
				<li onclick="setProcessL1('AR010104','102969');"><p><img src="/cmm/hanwha/images///hwc_common_icon04.png" alt="기술" /> 기술</p></li>
				<li onclick="setProcessL1('AR010105','103151');"><p><img src="/cmm/hanwha/images///hwc_common_icon05.png" alt="구매" /> 구매</p></li>
				<li onclick="setProcessL1('AR010106','103233');"><p><img src="/cmm/hanwha/images///hwc_common_icon06.png" alt="제조" /> 제조</p></li>
			</ul>
			<ul class="mgB15 col2_02_mid">
				<li onclick="setProcessL1('AR010107','131755');"><p><img src="/cmm/hanwha/images///hwc_common_icon07.png" alt="안전환경보건" /> 안전환경보건 </p></li>
				<li onclick="setProcessL1('AR010108','131578');"><p><img src="/cmm/hanwha/images///hwc_common_icon08.png" alt="품질" /> 품질</p></li>
			</ul>
			<ul class="mgB10 col2_02_bottom">
				<li onclick="setProcessL1('AR010109','103623');"><p><img src="/cmm/hanwha/images///hwc_common_icon09.png" alt="경영관리" /> 경영관리</p></li>
				<li onclick="setProcessL1('AR010110','103861');"><p><img src="/cmm/hanwha/images///hwc_common_icon10.png" alt="인력관리" /> 인력관리</p></li>
				<li onclick="setProcessL1('AR010111','104045');"><p><img src="/cmm/hanwha/images///hwc_common_icon11.png" alt="재무관리" /> 재무관리</p></li>
			</ul>
		</div>
		<!-- 사업장 프로세스 -->
		<div class="col2_03">
			<h3>사업장 프로세스 <span>| PLACE OF BUSINESS PROCESS</span></h3>
			<ul class="mgB30">
				<li onclick="setProcessL1('AR010724','143709');"><p>여수</p></li><span></span>
				<!-- <li onclick="setProcessL1('AR010721','180893');"><p>보은1</p></li><span></span> -->
				<li onclick="setProcessL1('AR010726','142505');"><p>보은</p></li><span></span>
				<li onclick="setProcessL1('AR010725','145103');"><p>대전</p></li><span></span>
				<!-- <li onclick="setProcessL1('AR010722','142801');"><p>구미</p></li><span></span> -->
				<li onclick="setProcessL1('AR010723','143979');"><p>연구소</p></li>
			</ul>
		</div>
		
		<!-- 담당자변경 필요사규 / 개정검토 필요사규 / 재/개정 현황
		<div>
			<ul class="tab">
		       <li id="pli5" class="on" onclick="setRuleFrame('5')"><a>담당자변경</a></li>
		        <li id="pli6" onclick="setRuleFrame('6')" style="width:50%"><a>개정검토필요</a></li>
		        <li id="pli7" onclick="setRuleFrame('7')" style="width:50%" class="end"><a>재/개정 현황</a></li>
	     	 </ul>
		      <div class="notice_area">
		      	<div id="subRuleFrame" name="subRuleFrame" width="98%" height="100%">
		      	</div>
		      	<div id="subRuleFrame2" name="subRuleFrame2" width="98%" height="100%" class="mgT10"></div>
		      </div>
		</div>-->
		<!--  공지사항/자료실 -->
		<div id="boardDiv">
			<div class="tabs">
				<ul>
					<li id="pli3" class="on titNM" onclick="setNoticFrame('3');">${menu.LN00029}</li>
					<li id="pli1" class="titNM" onclick="setNoticFrame('1');">${menu.LN00001}</li>
					<li id="pli4" class="titNM" onclick="setNoticFrame('4');">신문고</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
					<li>more</li>
				</ul>
			</div>	
			<div id="subBrdFrame" name="subBrdFrame" class="tabFrame"></div>
<!-- 			<span class="floatR pdR20" style="cursor:pointer;" onClick="javascript:fnClickMoreBoard();"><img src="/cmm/hanwha/images///more.png"></span> -->
			
		</div>
	</div>	
	
</div>
</form>
</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>