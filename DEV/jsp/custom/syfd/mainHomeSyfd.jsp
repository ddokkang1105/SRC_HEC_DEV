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

<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/process_styles.css"/>
<script type="text/javascript">
    var noticType;
    var menuIndex = "1 4 5";  
	var list = new Array();
	var i = 0;
	
	// process L1 리스트
	<c:forEach items="${nameList}" var="item" varStatus="status"> 
	list[i] = {identifier: "${item.Identifier}" , name : "${item.PlainText}" , itemID : "${item.ItemID}"};
	i++;
	</c:forEach>
	
    $(document).ready(function(){
    	
    	// 사용유무 체크
    	var screenType = parent.$("#screenType").val();
    	if(screenType == "srRqst"){ // 외부에서 SR등록 호출시 실행 
    		parent.$("#screenType").val("");
    		fnGetSRCreate();
    	}
    	
    	// 게시판 셋팅
        setNoticFrame("1"); 
		
		//Operational Process text 셋팅
		list.forEach(function (item,key,mapObj) {
			$("#pl"+item.identifier).text(item.name);
			$("#pl"+item.identifier).attr('data-index-number',item.itemID);
		});
       
    });
    
    // 화면 사이즈 셋팅
    function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	}
    
    // 게시판 (TODO)
    function setNoticFrame(avg){
    	var url = "";
    	var data = "";
    	if(avg == '5') {
            url = "zmd_MainChangeSetList.do";   
            data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&memberState=${sessionScope.loginInfo.sessionState}";
    	}
    	else {
    		$("#boardMgtID").val(avg);
            url = "mainBoardList.do";   
            data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainVersion=5&BoardMgtID="+avg;            
    	}
        var target = "subBrdFrame";
        ajaxPage(url, data, target);
    	setSubTab(menuIndex, avg, "pli");
    }
    
    // 게시판 클릭
    function fnClickMoreBoard(){
    	var boardMgtID = $("#boardMgtID").val();
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    // 검색 - 사용유무 체크
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
			fnSearchProcess(); // Process
		}else{ // 2
			fnSearchFile(); // File
		}
    }
    
    // 프로세스 검색 -- 사용유무 체크
    function fnSearchProcess(){
    	var searchValue = $("#searchValue").val();
    	var url = "searchList.do";
    	var target = "mainLayerFrm";
    	var data = "itemTypeCode=OJ00001&classCode=CL01005&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
    	ajaxPage(url, data, target);
    }
    
    // 파일 검색 -- 사용유무 체크
    function fnSearchFile(avg){
    	var searchValue = $("#searchValue").val();
    	var url = "goDocumentList.do";
    	var target = "mainLayerFrm";
    	var data = "screenType=main&searchKey=Name&searchValue="+searchValue;
    	// LF Use ** var data = "screenType=main&fltpCode=FLTP012&searchKey=Name&searchValue="+searchValue;
    	ajaxPage(url, data, target);
    }
    
    // 사용유무 체크
    function fnClickMoreChangeSet(){
    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '');
    }
    
    // SR 등록 페이지 바로 가기 
    function fnGetSRCreate(){
    	$('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
    	var url = "srMgt.do";
    	var target = "mainLayerFrm";
    	var data = "screenType=srRqst&srType=ITSP&srMode=REG";
    	ajaxPage(url, data, target);
    }
    
    // 프로세스 셋팅
    function setProcessL1(id) {
    	var itemID = $("#pl" + id).attr('data-index-number');
    	var url = "itemMgt.do?&tLink=Y&nodeID=" + itemID;
    	goArcMenu('PAL0101','ar_map.png','csh_process',url)
    }
    
    // 리포트 셋팅
    function setReport() {
    	goArcMenu('ITS2000','','csh_process','esmMgt.do?&srType=ISP&scrnType=srRqst&defCategory=ISP100');
    }
    
    // process 클릭
    function goArcMenu(avg,avg2,avg3,avg4) {
    	if(avg != "")
    		parent.clickMainMenu(avg,'',avg2, '',avg3,avg3,avg4);
    }
    
    
</script>
</head>

    
<BODY id="layerBody" name="layerBody"  >


<div class="noform" id="mainLayer" style="overflow-y:auto;height:100%;">
<form name="mainLayerFrm" id="mainLayerFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input id="boardMgtID" type="hidden" value="" >
<input id="imgIndex" type="hidden" value="1">

<div id="contents_wrap"> 

	<!-- 메인 이미지 -->
	<div class="left_area">
		<img id="mainimg" src="${root}${HTML_IMG_DIR}/RSP_main_V1.0.jpg" />
	</div>
    
    <div class="right_area">
		
		<!-- Operational Process -->
		<p class="main_tit"><img src="${root}${HTML_IMG_DIR}/main_title_01.png" /></p>
		<div class="operation_area">
			<ul class="operation">					
				<li class="op01"><a href="javascript:setProcessL1('01');"><span id="pl01"></span></a></li> <!-- 국내영업 -->
				<li class="op02"><a href="javascript:setProcessL1('02');"><span id="pl02"></span></a></li> <!-- 해외영업 -->
				<li class="op03"><a href="javascript:setProcessL1('03');"><span id="pl03"></span></a></li> <!-- 생산  -->
				<li class="op04"><a href="javascript:setProcessL1('05');"><span id="pl05"></span></a></li> <!-- 물류 -->
				<li class="op05"><a href="javascript:setProcessL1('06');"><span id="pl06"></span></a></li> <!-- 마케팅 -->
				<li class="op06"><a href="javascript:setProcessL1('07');"><span id="pl07"></span></a></li> <!-- 연구개발 -->
			</ul>
		</div> 
		
		<!--  Support Process  -->
		<p class="main_tit"><img src="${root}${HTML_IMG_DIR}/main_title_02.png" /></p>
		<ul class="support">
	        <li><a href="javascript:setProcessL1('04');"><span id="pl04"></span></a></li> <!-- 구매 -->
	        <li><a href="javascript:setProcessL1('08');"><span id="pl08"></span></a></li> <!-- 재무회계 -->
	        <li class="end"><a href="javascript:setProcessL1('09');"><span id="pl09"></span></a></li> <!-- 자금 -->
	        <li><a href="javascript:setProcessL1('10');"><span id="pl10"></span></a></li> <!-- 전략기획 -->
	        <li><a href="javascript:setProcessL1('11');"><span id="pl11"></span></a></li> <!-- 사업관리 -->
	        <li class="end"><a href="javascript:setProcessL1('12');"><span id="pl12"></span></a></li> <!-- 경영관리 -->
	        <li><a href="javascript:setProcessL1('13');"><span id="pl13"></span></a></li> <!-- 인사 -->
	        <li><a href="javascript:setProcessL1('14');"><span id="pl14"></span></a></li> <!-- IT/PI -->
	        <li class="end"><a href="javascript:setProcessL1('15');"><span id="pl15"></span></a></li> <!-- 품질 -->
		</ul>
	    
	    <!-- Process Statistics -->  
		<div class="statics">
			<img src="${root}${HTML_IMG_DIR}/offer.png" style="width:50px; padding-left: 20px;"/>  
			<span id="statTxT" style="display:inline-block; width:auto; color:white; font-size:initial; padding:23px 20px 0px 30px;">Process Innovation Proposal Management</span> <a href="javascript:setReport();" class="btn_search" style="color:#fff;">GO</a> 
		</div>
	    
	    <!-- board -->  
		<ul class="tab">
			<li id="pli1" class="on" onclick="setNoticFrame('1');"><a href="#" >${menu.LN00001}</a></li>
			<li id="pli4" onclick="setNoticFrame('4');"><a href="#" >${menu.LN00215}</a></li>
			<li id="pli5" onclick="setNoticFrame('5');" class="end"><a href="#">${menu.LN00205}</a></li>
		</ul>
		<div class="notice_area">
			<div id="subBrdFrame"  name="subBrdFrame" width="98%" height="100%"></div>
		</div>
		
	</div>
</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>