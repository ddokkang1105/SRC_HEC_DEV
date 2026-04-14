<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainbasic.css" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


 <style>
/*  	body {background:url("${root}${HTML_IMG_DIR}/bg_mainhomelayer.png")} */
	
</style> 
<script type="text/javascript">
    var noticType;var menuIndex = "1 2 3";    
    $(document).ready(function(){
    	setNoticFrame(1,'BRD001'); 
        setSRFrame('mySR',1);
        setCSRFrame('myCSR',1);  
        setScheduleFrame(1);  
       
      	$("#onTab").val("SR");
    });
    
    function setNoticFrame(avg1, avg2){
        var url = "mainBoardList.do";   
        var target = "boardFrame";
        var data = "mainVersion=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=5&BoardMgtID="+avg2;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg1, "sli","active");
        $("#onTab").val("BOARD");
        $("#boardMgtID").val(avg2);
    }
    
    function setSRFrame(srMode,avg){
        var url = "mainESRList.do";
        var target = "subSRFrame";
        var data = "listSize=5&srType=ITSP&srMode="+srMode+"&status=ING";
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "sr","active");
        
        if(srMode =="mySR"){
            $("#srOnTab").val("MyITS");
        }else{
        	$("#srOnTab").val("ITS");
        }
        $("#onTab").val("SR");
    }
    
    function setCSRFrame(csrMode, avg){
        var url = "mainCSRList.do";   
        var target = "csrFrame";
        var data = "listSize=4&csrMode="+csrMode+"&status=CNG";
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "csr","active");
        $("#onTab").val("CSR");
    }
    
    function setScheduleFrame(avg){
    	var url = "mainSchdlList.do";   
        var target = "scheduleFrame";
        var data = "listSize=5&endDTCheck=Y";
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "schl","active");
        $("#onTab").val("SCHDL");
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
    		url = "itspMgt.do"; // 1.서비스요청/나의 서비스 요청/ 2.Service Desk
    	}
    	
    	if(sessionUserID == requestUserID){
    	  mainType ="mySRDtl" ;
    	}
    	
        var data = "screenType=" + screenType + "&srID="+SRID+"&srType=ITSP&mainType="+mainType;
        var target = "mainLayerV4Frm";   
        
        $('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
       
        ajaxPage(url, data, target);
    }
       
    function fnGoMore(id, onTab){ 
    	var focusMenu ="";
       	if(onTab == "SR"){
       		if($("#srOnTab").val() == "MyITS"){
    			focusMenu = "1";
    		}else{
    			focusMenu = "3";
    		}
       		parent.goMenu('itspMgt.do?multiComp=Y&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
       	}else if(onTab == "CSR"){
       		parent.goMenu('csrList.do', '', true, layout_2E);
    	}else if(onTab == "SCHDL"){
       		parent.goMenu('goSchdlListMgt.do?refPGID='+id, '', true, layout_2E);
       	}else{
       		var boardMgtID = $("#boardMgtID").val();
    		parent.clickMainMenu('BOARD', '', '', '', '', '', '', boardMgtID);
    	}
    }
    
	function fnGoCSRDetail(projectID){		
		var screenMode = "V";
		var mainMenu = "${mainMenu}";
		var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
				
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnPgTemplate(){
		parent.$("#cmbTempl").val("${templateMap.TemplCode}");
		parent.changeTempl("${templateMap.TemplCode}","${templateMap.TemplText}","${templateMap.MainURL}","","","${templateMap.TmplFilter}");
	}
    
</script>
</head>

<BODY id="layerBody" name="layerBody" >
<form name="mainLayerV4Frm" id="mainLayerV4Frm" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input type="hidden" id="onTab" name="onTab" value=""></input>
<input type="hidden" id="boardMgtID" name="boardMgtID" value="BRD001">
<input type="hidden" id="srOnTab" name="srOnTab" value=""/>
<ul class="row">
	<li class="col-4">
		<!-- BOARD -->
		<h1>${menu.LN00123}</h1>
		 <div class="sec01">
		 	<a class="more" onClick="javascript:fnGoMore('', 'BOARD');">+ more</a>
			<ul class="boardtab">
				<li id="sli1" class="active" onclick="setNoticFrame(1,'BRD001');"><a><span>General</span></a></li>
				<li id="sli2" onclick="setNoticFrame(2,'BRD002');"><a><span>Material</span></a></li>
				<li id="sli3" onclick="setNoticFrame(3,'BRD003');"><a><span>Revision</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=boardFrame  name="boardFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
		
	<li class="col-4">
		<!-- Schedule -->
		<h1>Schedule</h1>
		 <div class="sec01">
		 	<a class="more" onClick="javascript:fnGoMore('','SCHDL');">+ more</a>
			<ul class="boardtab">
				<li id="sli1" class="active" onclick="setScheduleFrame(1);"><a><span>Schedule</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=scheduleFrame  name="scheduleFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
</ul>
	
<ul class="row">
	<li class="col-4">
		<!-- SR -->
		<h1>Service Request</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('mySR', 'SR');">+ more</a>
			<ul class="boardtab">
				<li id="sr1" class="active" onclick="setSRFrame('mySR',1);"><a><span>My SR</span></a></li>
				<li id="sr2" onclick="setSRFrame('',2);"><a><span>SR</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=subSRFrame  name="subSRFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
		
	<li class="col-4">
	<!-- CSR -->
		<h1>CSR</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('myCSR','CSR');">+ more</a>
			<ul class="boardtab">
				<li id="csr1" class="active" onclick="setCSRFrame('myCSR',1);"><a><span>My CSR</span></a></li>
					<li id="csr2" onclick="setCSRFrame('',2);"><a><span>CSR</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=csrFrame  name="csrFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
</ul>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>