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
    var noticType;var menuIndex = "1 2 4 5";  
	var list = new Array();
	var i = 0;
	var randomImg = Math.floor(Math.random() * 4 + 1 );
	
	<c:forEach items="${nameList}" var="item" varStatus="status"> 
	list[i] = "${item.Identifier}" + "/" + "${item.PlainText}";
	i++;
	</c:forEach>
	
    $(document).ready(function(){
    	var screenType = parent.$("#screenType").val();
    	if(screenType == "srRqst"){ // 외부에서 SR등록 호출시 실행 
    		parent.$("#screenType").val("");
    		fnGetSRCreate();
    	}
        setNoticFrame("1"); 

        window.onresize = function() {
	    	var winWidth = setWindowWidth();
	    	if(winWidth > 1400) {
	    		$('#mainimg').css('width', '80%');
	    		$('#mainimg').css('height', '80%');
		    } else {
	    		$('#mainimg').css('width', '90%');
	    		$('#mainimg').css('height', '90%');
	    	}
		}; 
		
		setInterval(function() {
			var idx = $("#imgIndex").val();
			
			if($("#mainimg").attr("src") != undefined) {
				if(idx == '4') {
					$("#mainimg").attr("src",$("#mainimg").attr("src").replace(idx+"","1"));
					$("#imgIndex").val("1");
				}
				else {
					$("#mainimg").attr("src",$("#mainimg").attr("src").replace(idx+"",(idx*1+1)+""));
					$("#imgIndex").val((idx*1+1)+"");
				}
			}
			
		},30000);
		$("#mainimg").attr("src","${root}${HTML_IMG_DIR}/rolling_img_0"+randomImg+".jpg");
		
		$("#imgIndex").val(randomImg);
		
		list.forEach(function (item,key,mapObj) {
			
			var obj = item.split("/");
			$("#pl"+obj[0]).text(obj[1]);
		});
       
    });
    
    function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	}
    
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
    
    function fnSearchProcess(){
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
    	// LF Use ** var data = "screenType=main&fltpCode=FLTP012&searchKey=Name&searchValue="+searchValue;
    	ajaxPage(url, data, target);
    }
    
    function fnClickMoreBoard(){
    	var boardMgtID = $("#boardMgtID").val();
    //	if(boardMgtID ==""){boardMgtID="1";}
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
   
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
    
    function setProcessL1(id) {
    	var url = "mdProcSummary.do";
    	var data = "L1ID="+id;
    	var target = "mainLayerFrm";
    	
    	ajaxPage(url, data, target);
    }
    
    function setReport() {
    	var url = "mdItemStatistics.do";
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isMainMenu=Y";
    	var target = "mainLayerFrm";
    	
    	ajaxPage(url, data, target);
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

	<div class="left_area"> <img id="mainimg" src="" /></div>
    <div class="right_area">
	      <p class="main_tit"><img src="${root}${HTML_IMG_DIR}/main_title_01.png" /></p>
	      <div class="operation_area">
	        <ul class="operation">					
		        <li class="op01"><a href="javascript:setProcessL1('02');"><span id="pl02"></span></a></li>
				<li class="op02"><a href="javascript:setProcessL1('03');"><span id="pl03"></span></a></li>
				<li class="op03"><a href="javascript:setProcessL1('04');"><span id="pl04"></span></a></li>
				<li class="op04"><a href="javascript:setProcessL1('05');"><span id="pl05"></span></a></li>
				<li class="op05"><a href="javascript:setProcessL1('06');"><span id="pl06"></span></a></li>
	        </ul>
	      </div> 
	      <p class="main_tit"><img src="${root}${HTML_IMG_DIR}/main_title_02.png" /></p>
	      <ul class="support" style="width:600px;">
	        <li><a href="javascript:setProcessL1('01');"><span id="pl01"></span></a></li>
	        <li><a href="javascript:setProcessL1('12');"><span id="pl12"></span></a></li>
	        <li class="end"><a href="javascript:setProcessL1('07');"><span id="pl07"></span></a></li>
	        <li><a href="javascript:setProcessL1('13');"><span id="pl13"></span></a></li>
	        <li><a href="javascript:setProcessL1('08');"><span id="pl08"></span></a></li>
	        <li class="end"><a href="javascript:setProcessL1('14');"><span id="pl14"></span></a></li>
	        <li><a href="javascript:setProcessL1('09');"><span id="pl09"></span></a></li>
	        <li><a href="javascript:setProcessL1('15');"><span id="pl15"></span></a></li>
	        <li class="end"><a href="javascript:setProcessL1('10');"><span id="pl10"></span></a></li>
	        <li><a href="javascript:setProcessL1('16');"><span id="pl16"></span></a></li>
	        <li><a href="javascript:setProcessL1('17');"><span id="pl17"></span></a></li>
	        <li class="end"><a href="javascript:setProcessL1('11');"><span id="pl11"></span></a></li>
	      </ul>
	    <div class="statics"> <img src="${root}${HTML_IMG_DIR}/main_statics_img.png" /> <a href="javascript:setReport();" class="btn_search" style="color:#fff;">GO</a> </div>
	      <ul class="tab">
	        <li id="pli1" class="on" onclick="setNoticFrame('1');"><a href="#" >${menu.LN00001}</a></li>
	        <li id="pli2" onclick="setNoticFrame('2');"><a href="#" >${menu.LN00250}</a></li>
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