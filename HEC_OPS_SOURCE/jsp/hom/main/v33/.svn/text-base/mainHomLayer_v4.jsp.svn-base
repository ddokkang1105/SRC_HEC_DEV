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
body {background:url("${root}${HTML_IMG_DIR}/bg_mainhomelayer.png")}
.row {padding:10px;border:0px solid #000}
.col1 {float: left;width: 46%; margin: 5px;clear: both;margin:0 7px;}
.col1top {border:1px solid #d7d7d7;!important;background:url("${root}${HTML_IMG_DIR}/bg_mainhom_gray.png");vertical-align:middle;text-align:center}
.coltop {border:1px solid #d7d7d7;background:url("${root}${HTML_IMG_DIR}/bg_mainhome_title.png");height:34px;line-height:34px;vertical-align:middle;}
.colbottom{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;}
.coltop01 {border-top:1px solid #d7d7d7;border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;background:#fff;;height:34px;line-height:34px;vertical-align:middle;}
.colbottom01{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;height:250px;}
.tbl_nstyle, .tbl_nstyle th, .tbl_nstyle td{border:0px solid #000;margin:0 auto;}
.tbl_nstyle{width:100%;font-family:'Malgun Gothic' !important;font-size:12px;text-align:center}
.tbl_nstyle td{padding:5px;;text-align:left;vertical-align:middle;}
.tbl_nstyle td.hr1 {border-top:#ddd dotted 1px;border-left:#FFFFFF solid 0px;border-right:#FFFFFF solid 0px;font-size:1;line-height:0;height:1px;  padding-top:0px;}

.nstylewrap{float: left;width: 100%;margin:0 auto;}
.nstyleR{margin:0;padding:0 10px;}
/*.nstyleL{float: left;width: 135px; margin-left: -98%;padding:10px}*/
.col2 {width: 49%;margin-left:50%; padding: 0; }
.noform{border:1px solid #d7d7d7;background:#ffff;}
</style>
<script type="text/javascript">
    var noticType;var menuIndex = "1 2 3";    
    $(document).ready(function(){
    	var screenType = parent.$("#screenType").val();
    	if(screenType == "srRqst"){ // 외부에서 SR등록 호출시 실행 
    		parent.$("#screenType").val("");
    		fnGetSRCreate();
    	}
    	//setNoticFrame(1,1); 
        var srMode = "mySR"; 
        setSRFrame(srMode,1);
        setProcessFrame();  
        setSRStatic();
      	$("#onTab").val("SR");
    });
    function setNoticFrame(avg1, avg2){
        var url = "mainBoardList.do";   
        var target = "subSRFrame";
        var data = "mainVersion=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=5&BoardMgtID="+avg2;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg1, "sli");
        $("#onTab").val("BOARD");
    }
    
    function setSRFrame(srMode,avg){
        var url = "mainSRList.do";
        var target = "subSRFrame";
        var data = "listSize=5&srType=ITSP&srMode="+srMode;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "sli");
        $("#onTab").val("BOARD");
    }
    
    function setProcessFrame(avg){
        var url = "mainSttProcess.do";   
        var target = "subPrcFrame";var data = "";ajaxPage(url, data, target);
    }
    
    function setSRStatic(){
        var url = "mainSRStatistics.do";
        var target = "subSRStaticFrame";
        var data = "srType=ITSP";
        ajaxPage(url, data, target);        
    }
      
    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
    	var url = ""; 
    	var mainType = "SRDtl";
    	var screenType = "srRqst";
    		//alert(status);
    	if(sessionUserID == receiptUserID && status != 'CLS' && status != 'CMP' ){
    		url = "myPage.do"; //MyPage / 서비스요청  
    		screenType = "srRcv" ;
    		mainType ="mySRDtl" ;
    	}else{
    		url = "srMgt.do"; // 1.서비스요청/나의 서비스 요청/ 2.Service Desk
    	}
    	
    	if(sessionUserID == requestUserID){
    	  mainType ="mySRDtl" ;
    	}
    	
        var data = "screenType=" + screenType + "&srID="+SRID+"&srType=ITSP&mainType="+mainType;
        var target = "mainLayerV4Frm";   
        
       // alert(url+data);
        $('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
       
        ajaxPage(url, data, target);
    }
    
    // SR 등록 페이지 바로 가기 
    function fnGetSRCreate(){
    	$('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
    	var url = "srMgt.do";
    	var target = "mainLayerV4Frm";
    	var data = "screenType=srRqst&srType=ITSP&srMode=REG&mainType=REG";
    	ajaxPage(url, data, target);
    }
    
 	// SR Service Desk 바로가기 
    function fnGetSRServiceDesk(){
    	$('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
    	var url = "srMgt.do";
    	var target = "mainLayerV4Frm";
    	var data = "screenType=srRqst&mainType=srDsk&srType=ITSP";
    	ajaxPage(url, data, target);
    }
 
 	// SR FAQ 바로 가기 
    function fnGetSRFAQ(){
    	$('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
    	var url = "srMgt.do";
    	var target = "mainLayerV4Frm";
    	var data = "screenType=srRqst&mainType=srFAQ&srType=ITSP";
    	ajaxPage(url, data, target);
    }
 	
    function fnSearchProcess(avg){
    	var searchKey = $("#searchKeyPrc").val();
    	var searchValue = $("#searchValuePrc").val();
    	var url = "searchList.do";
    	var target = "mainLayerV4Frm";
    	var data = "itemTypeCode=OJ00001&classCode=CL01005&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
    	ajaxPage(url, data, target);
    }
    
    function fnSearchFile(avg){
    	var searchKey = $("#searchKeyFile").val();
    	var searchValue = $("#searchValueFile").val();
    	var url = "goDocumentList.do";
    	var target = "mainLayerV4Frm";
    	var data = "screenType=main&searchKey=Name&searchValue="+searchValue;
    	// LF Use ** var data = "screenType=main&fltpCode=FLTP012&searchKey=Name&searchValue="+searchValue;
    	ajaxPage(url, data, target);
    }
    
    function fnGoMore(){
    	var onTab = $("#onTab").val();
       	if(onTab == "SR"){
    		parent.goMenu('srMgt.do?screenType=srRqst&srType=ITSP', '', true, layout_2E);
    	}else{
    		parent.clickMainMenu('BOARD', 'BOARD');
    	}
    }
    
</script>
</head>

<BODY id="layerBody" name="layerBody" >
<form name="mainLayerV4Frm" id="mainLayerV4Frm" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input type="hidden" id="onTab" name="onTab" value=""></input>
<div class="row">
	<div class="col1"  >
			<div class="col1top mgT8 mgB6">
			<img src="${root}${HTML_IMG_DIR}/img_mainHome3.png" style="height:266px;max-width:100%;"> 
			</div>
			<!-- SR -->
			<div class="coltop01 mgT15">
				<div class="SubinfoTabs">
					<ul>
						<li id="sli1" class="on" onclick="setSRFrame('mySR',1);"><a><span>My SR</span></a></li>
						<li id="sli2" onclick="setNoticFrame(2,1);"><a><span>${menu.LN00001}</span></a></li>
						<li id="sli3" onclick="setNoticFrame(3,3);"><a><span>${menu.LN00029}</span></a></li>
					</ul>
				     <span class="floatR pdR20" onClick="javascript:fnGoMore();">
				    	<img src="${root}${HTML_IMG_DIR}/more.png">
				    </span>
				</div>
			</div>
			<div class="colbottom01">
				<div class="nstylewrap">
					<div class="nstyleR"><div id="subSRFrame"  name="subSRFrame" width="100%" height="100%"></div></div>
				</div>			
			</div>		
	</div>
	<div class="col2">
		<!--  Business Process -->
		<div class="coltop mgT5"><span><img src="${root}${HTML_IMG_DIR}/icon_mainhome01.png"></span><span class="pdL20"><b>Business Process</b></span><span class="floatR pdR10"></span></div>
		<div class="colbottom">
		    <div id="subPrcFrame"  name="subPrcFrame" width="98%" height="100%"></div>
		</div>
		<div class="coltop mgT16"><span><img src="${root}${HTML_IMG_DIR}/icon_mainhome01.png"></span><span class="pdL20"><b>SR 처리 현황</b></span><span class="floatR pdR10"></span></div>
		<div style="margin:0 auto;"> 	
			 <div id="subSRStaticFrame"  name="subSRStaticFrame" width="98%" height="100%"></div>
		</div>
	</div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>