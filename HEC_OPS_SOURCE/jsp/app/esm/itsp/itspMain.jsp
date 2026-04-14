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
.row{width:75%;}
.col-4 {width:50%;}
</style> 
<script type="text/javascript">
    var menuIndex = "1 2 3";
    var menuIndex2 = "CurAprv ToDoAprv RefMgt MyWIP";
  	var curWFMode = "CurAprv";
    $(document).ready(function(){
    	//setNoticFrame(1,'BRD001'); 
        setSRFrame('mySR',1);
        setSCRFrame('Y',1);
        setctrFrame('Y',1);
        setWorkflowFrame('CurAprv','');
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
       // var data = "listSize=5&srType=ITSP&srMode="+srMode;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "sr","active");
        
        if(srMode =="mySR"){
            $("#srOnTab").val("MyITS");
        }else{
        	$("#srOnTab").val("ITS");
        }
        $("#onTab").val("SR");
    }
    
    function setSCRFrame(mySCR, avg){
        var url = "scrMainList.do";   
        var target = "scrFrame";
        var data = "listSize=4&scrMode=&mySCR="+mySCR;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "scr","active");
        
        if(mySCR =="Y"){
            $("#scrOnTab").val("MySCR");
        }else{
        	$("#scrOnTab").val("SCR");
        }
        $("#onTab").val("SCR");
    }
    
    function setctrFrame(myCTR,avg){
        var url = "mainCTRList.do";   
        var target = "ctrFrame";
        var data = "listSize=4&myCTR="+myCTR;
        if(myCTR == "Y"){
        	data += "&ctrMode=ING";
        }

        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "ctr","active");
        if(myCTR =="Y"){
            $("#ctsOnTab").val("MyCTS");
        }else{
        	$("#ctsOnTab").val("CTS");
        }
        $("#onTab").val("CTS");
    }

    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
    	var url = "itspMgt.do"; 
    	var mainType = "SRDtl";
    	var screenType = "";    	
    	
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
    		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);    	
       	}else if(onTab == "SCR"){
       		if($("#scrOnTab").val() == "MySCR"){
    			focusMenu = "4";
    		}else{
    			focusMenu = "6";
    		}
       		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
    	}else if(onTab == "CTS"){
    		if($("#ctsOnTab").val() == "MyCTS"){
    			focusMenu = "7";
    		}else{
    			focusMenu = "9";
    		}
       		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
       	}if(onTab == "WF"){
       		if($("#wfOnTab").val() == "CurAprv"){
    			focusMenu = "10";
    		}else if($("#wfOnTab").val() == "ToDoAprv"){
    			focusMenu = "12";
    		}else if($("#wfOnTab").val() == "RefMgt"){
    			focusMenu = "14";
    		}else if($("#wfOnTab").val() == "MyWIP"){
    			focusMenu = "11";
    		}
        	var type = "myWF" + $("#wfType").val();
       		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
       	}else{
       		var boardMgtID = $("#boardMgtID").val();
    		parent.clickMainMenu('BOARD', '', '', '', '', '', '', boardMgtID);
    	}
    }
    
	function fnSCRDetail(scrID, srID){				
		var screenMode = "V";
		var url = "viewScrDetail.do";		
		var data = "srID="+srID+"&scrID="+scrID+"&screenMode="+screenMode; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnGoctrDetail(ctrID){		
		var screenMode = "V";
		var mainMenu = "${mainMenu}";
		var url = "ctrDetail.do?ctrID="+ctrID+ "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
				
		var w = 850;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnPgTemplate(){
		parent.$("#cmbTempl").val("${templateMap.TemplCode}");
		parent.changeTempl("${templateMap.TemplCode}","${templateMap.TemplText}","${templateMap.MainURL}","","","${templateMap.TmplFilter}");
	}
	
    function setWorkflowFrame(wfMode,avg){
    	curWFMode = wfMode;
        $("#wfType").val(avg);
        var url = "mainWFInstList.do";
        var target = "subWFFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode="+wfMode+"&screenType=MyPg&listSize=5";
       
        ajaxPage(url, data, target);
        setSubTab(menuIndex2, wfMode, "pli","active");
        $("#wfOnTab").val(wfMode);
        $("#onTab").val("WF");
    }
    function fnGoWFDetail(projectID,wfID,stepInstID,actorID,stepSeq,wfInstanceID,lastSeq,documentID,docCategory){		
		//var screenMode = "V";
		var mainMenu = "${mainMenu}";
		var url = "wfDocMgt.do?";
		var data = "projectID="+projectID+"&pageNum=1&isPop=Y&isMulti=N&actionType=view"
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&srID="+documentID
					+"&lastSeq="+lastSeq
					+"&docCategory="+docCategory
					+"&wfMode="+curWFMode;
				
		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
	}
    
</script>
</head>

<BODY id="layerBody" name="layerBody" >
<form name="mainLayerV4Frm" id="mainLayerV4Frm" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input type="hidden" id="onTab" name="onTab" value=""></input>
<input type="hidden" id="ctsOnTab" name="ctsOnTab" value=""/>
<input type="hidden" id="srOnTab" name="srOnTab" value=""/>
<input type="hidden" id="scrOnTab" name="scrOnTab" value=""/>
<input type="hidden" id="wfOnTab" name="wfOnTab" value=""/>
<input type="hidden" id="boardMgtID" name="boardMgtID" value="BRD001">
<input id="wfType" type="hidden" value=""/>
<ul class="row">
	<li class="col-4">		
		<!-- SR -->
		<h1>IT Service Request</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('mySR', 'SR');">+ more</a>
			<ul class="boardtab">
				<li id="sr1" class="active" onclick="setSRFrame('mySR',1);"><a><span>My ITS</span></a></li>
				<li id="sr2" onclick="setSRFrame('',2);"><a><span>ITS List</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=subSRFrame  name="subSRFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
	<li class="col-4">		
		<h1>Approval Box</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('', 'WF');">+ more</a>
			<ul class="boardtab">
				<li id="pliCurAprv" class="active" onclick="setWorkflowFrame('CurAprv','');"><a><span>${menu.LN00243}</span></a></li>
				<li id="pliToDoAprv" onclick="setWorkflowFrame('ToDoAprv','');"><a><span>${menu.LN00244}</span></a></li>
				<li id="pliRefMgt" onclick="setWorkflowFrame('RefMgt','');"><a><span>${menu.LN00245}</span></a></li>
				<li id="pliMyWIP" onclick="setWorkflowFrame('MyWIP','');"><a><span>${menu.LN00121}</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=subWFFrame  name="subWFFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
</ul>
	
<ul class="row">
	<li class="col-4">
		<h1>System Change Request</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('ING','SCR');">+ more</a>
			<ul class="boardtab">
				<li id="scr1" class="active" onclick="setSCRFrame('Y',1);"><a><span>My SCR</span></a></li>
				<li id="scr2" onclick="setSCRFrame('',2);"><a><span>SCR List</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=scrFrame  name="scrFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
		
	<li class="col-4">
	<!-- CTS -->
		<h1>Change & Transfort System</h1>
		<div class="sec01">
			<a class="more" onClick="javascript:fnGoMore('ING','CTS');">+ more</a>
			<ul class="boardtab">
				<li id="ctr1" class="active" onclick="setctrFrame('Y',1);"><a><span>My CTS</span></a></li>
					<li id="ctr2" onclick="setctrFrame('',2);"><a><span>CTS List</span></a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content"><div id=ctrFrame  name="ctrFrame" width="100%" height="100%"></div></div>
			</div>
		</div>
	</li>
</ul>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>