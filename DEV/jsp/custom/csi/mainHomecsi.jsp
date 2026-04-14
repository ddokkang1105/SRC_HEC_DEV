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
.row {
    position: relative;
    width: 76%;
    height: 92%;
    top: 4%;
    margin: 0 auto;
}
.col1 {    float: left;
    width: 42%;
    height: 100%;
    margin: 0;
    clear: both;}

#mainImg {
    width: 100%;
    height:100%;
}    
#mainImg > img {
	width: 100%;
    height: 100%;
}
#boardDiv {border:1px solid #d7d7d7; width:100%;
	height:31.5%;
	box-sizing: border-box;
}

#boardDiv li, #boardDiv li span {
	font-size: 0.63vw;
}

.col2 {width: 54%;
    height: 100%;
    float: right;}
.noform{background:#ffff;width:100%;height:100%;}
#mainLayerFrm{width:100%;height:100%;}
.mainimg {margin: 0 auto;}
.SubinfoTabs{margin:0;}
.SubinfoTabs ul li a{
    width: 100px;
    text-align: center;
    background:#fff;
    border-top: 0;
}
.SubinfoTabs ul li.on a {
	padding-top:11px;
	border-top: 1px solid rgb(25, 53, 152);
}

#business > p, #operational > p {
font-size: 1vw;
    color: #000;
    font-weight: 500;
    display: flex;
    padding-bottom: 0.5vw;
    width:100%;
    max-height:24px;
}
#business {
      height: 35%;
}
#business > ul {
    width: 100%;
    height: calc(72%/3);
    display: flex;
    margin-bottom: 1.5%;
  }
  #business > ul:last-child{
  	margin:0;
  }
#business > ul > li { 
    border: 1px solid #d7d7d7;
    padding: 0 2%;
    width: 32.3333%;
    margin-right: 1.5%;
    box-sizing: border-box;
    font-size: 0.7vw;
    height: 100%;
    display: flex;
    align-items: center;
    color: #000;
    cursor:pointer;
    justify-content: flex-start;
}
#business > ul > li:last-child{
	margin-right:0;
}
#business > ul > li img {
	margin-right:10px;
	width:12%;
	max-width:22px;
}
#business > ul > li span {
	background: #13213c;
    color: #fff;
    border-radius: 10px;
    padding: 1px 5px;
    margin-left: auto;
    font-size: 0.6vw;
}
#business > ul > li:hover{
    background: rgba(65, 152, 247, 0.15);
    transition: background-color .2s ease-out;
}

#operational {
	    height: 18.5%;
}
#operational > ul {
    width: 100%;
    height: 60%;
    display: flex;
}
#operational > ul > li {
    border: 1px solid #cacaca;
    text-align: center;
    box-shadow: 0 2.5px 0px 0px #4871b2 inset ;
    width: 23.875%;
    margin-right: 1.5%;
    box-sizing: border-box;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
     color: #000;
    cursor:pointer;
}
#operational > ul > li:hover{
    background: rgba(65, 152, 247, 0.15);
    transition: background-color .2s ease-out;
}

#operational > ul > li:last-child{
	margin-right:0;
}
#operational > ul > li span:nth-child(1) {
	    width: 25%;
    text-align: right;
}
#operational > ul > li span:nth-child(1) img {
	width:80%;
}
#operational > ul > li span:nth-child(2) {
	width:58%;
    font-size: 0.7vw;
}

#report {
    height: 11%;
    width: 100%;
    background: antiquewhite;
    margin-bottom: 4%;
    display: table;
}
#report > div {
    font-size: 0.65vw;
    width: 100%;
    background: #4871b2;
    color: #fff;
    padding: 0 25px;
    box-sizing: border-box;
    height: 62%;
    display: table-cell;
    vertical-align: middle;
    margin-bottom:4%;
}
#report div > .floatL {
	    font-size: 0.7vw;
}
#report div > .floatL img {
	margin-right:15px;
}
#report div > .floatR {
    width: 100px;
    background: rgba(255,255,255,0.2);
    padding: 4px 10px;
    border-radius: 3px;
    cursor:pointer;
}
#report div > .floatR > span {
	font-size: 0.7vw;
}

.morebtn{
    float: right;
    height: 100%;
    width: 9% !important;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #808080;
    cursor: pointer;
    font-weight: 300;
}

.postInfo{
	height:100%;
   	overflow-y: auto;
   	background:#fff;
}
.postInfo ul{
    background: #fff;
    width: 96%;
    padding: 0 2%;
    display: table;
    table-layout:fixed;
}
.postInfo ul:hover{
	background:rgba(65, 152, 247, 0.15);
	cursor:pointer;
	box-shadow: 2px 0px 0px 0px #4265EE inset;
	transition: background-color .2s ease-out;
}
.postInfo li{
	display: table-cell;    
	padding: 1.44% 1.4%;
    border-bottom: 1px solid #e6e6e6;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.postInfo ul:last-child li{
	border:none;
}
</style>
<script type="text/javascript">
    var noticType;var menuIndex = "1 2 3 4";  
    
    $(document).ready(function(){
    	var screenType = parent.$("#screenType").val();
    	if(screenType == "srRqst"){ // 외부에서 SR등록 호출시 실행 
    		parent.$("#screenType").val("");
    		fnGetSRCreate();
    	}
        setNoticFrame("1"); 
//         setESRFrame("1","ITSP"); 

//        window.onresize = function() {
	    	var winWidth = setWindowWidth();
//	    	if(winWidth > 1400) {
 	    		$('#mainimg').css('width', '80%');
 	    		$('#mainimg').css('height', '80%');
// 		    } else {
//	    		$('#mainimg').css('width', '90%');
//	    		$('#mainimg').css('height', '90%');
//	    	}
//		}; 
       
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
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
    	$("#boardMgtID").val(avg);
    	if(avg == 4){
			url = "mainChangeSetList_v2.do";   
    	} else if (avg == 2){
    		url = "olmMainEsrList.do";   
    		data = data + "&chkNew=5&scrnType=main&srType=ITSP&srMode=mySR";
    	} else {
			url = "mainBoardList.do";
			data = data + "&BoardMgtID="+avg;
    	}
        
        var target = "subBrdFrame";
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "pli");
    }
    
    function fileNameClick(avg1, avg2, avg3, avg4, avg5){
    	var originalFileName = new Array();
    	var sysFileName = new Array();
    	var seq = new Array();
    	sysFileName[0] =  avg3 + avg1;
    	originalFileName[0] =  avg3;
    	seq[0] = avg4;
    	var url  = "fileDownload.do?seq="+seq+"&scrnType="+avg5;
    	ajaxSubmitNoAdd(document.mainLayerFrm, url,"saveFrame");
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
    	var data = "itemTypeCode=OJ00001&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
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
    	if(boardMgtID ==""){boardMgtID="1";}
    	if(boardMgtID == 4){
    		var Now = new Date(); 
    		
    		var toDate = Now.getFullYear() + "-" + ("0" + (Now.getMonth() +1)).slice(-2) + "-"
    		+ ("0" +  Now.getDate()).slice(-2);

    		var Old = new Date(Now.getFullYear(),Now.getMonth(),Now.getDate() - 7)
    		var fromDate = Old.getFullYear() + "-" + ("0" + (Old.getMonth()+1)).slice(-2) + "-"
    		+ ("0" +  Old.getDate()).slice(-2);
    		
            var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modStartDT="+fromDate+"&modEndDT="+toDate;
            
        	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '','',data,'','');
    	} else if (boardMgtID == 2){
    		parent.goMenu('esmMgt.do?&srType=ITSP&scrnType=srRqst&focusMenu=1', '', true, layout_2E);
    	}else {
        	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    	}
    }
    
    function setProcessL1(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
    }
    
    function setArc(arcCode) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?');
    }
    
    function setArc2(arcCode) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','multiItemTreeMgt.do?');
    }
    
    function fnClickStati(){
    	var url = "admin/newItemStatistics.do";
		var data = "isMainMenu=Y";
        var target = "layerBody";
        ajaxPage(url, data, target);
    }
    
    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status,srType){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
    	var authLev = "${sessionScope.loginInfo.sessionAuthLev}";
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
</script>
</head>

<BODY id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input id="boardMgtID" type="hidden" value="" >
<input id="srType" type="hidden" value="" >
<div class="row">
	<div class="col1">
		<div id="mainImg">
		<img src="${root}${HTML_IMG_DIR}/img_csi_main.png">
		</div>		
		
	</div>
	<div class="col2">
		<div id="business">
			<p>Business Process</p>
			<ul>
				<li onclick="setProcessL1('AR010110','100114')"><img src="${root}${HTML_IMG_DIR}/md.png">MD 기준정보<span>${CNTof100114 }</span></li>
				<li onclick="setProcessL1('AR010110','115875')"><img src="${root}${HTML_IMG_DIR}/pc.png">PC 제품개발<span>${CNTof115875 }</span></li>
				<li onclick="setProcessL1('AR010110','100118')"><img src="${root}${HTML_IMG_DIR}/sd.png">SD 영업물류<span>${CNTof100118 }</span></li>
			</ul>	
			<ul>
				<li onclick="setProcessL1('AR010110','107367')"><img src="${root}${HTML_IMG_DIR}/pp.png">PP 생산관리<span>${CNTof107367 }</span></li>
				<li onclick="setProcessL1('AR010110','100122')"><img src="${root}${HTML_IMG_DIR}/mm.png">MM 구매자재<span>${CNTof100122 }</span></li>
				<li onclick="setProcessL1('AR010110','100124')"><img src="${root}${HTML_IMG_DIR}/qm.png">QM 품질관리<span>${CNTof100124 }</span></li>
			</ul>	
			<ul>
				<li onclick="setProcessL1('AR010110','100126')"><img src="${root}${HTML_IMG_DIR}/fi.png">FI 재무회계<span>${CNTof100126 }</span></li>
				<li onclick="setProcessL1('AR010110','100128')"><img src="${root}${HTML_IMG_DIR}/co.png">CO 관리회계<span>${CNTof100128 }</span></li>
				<li onclick="setProcessL1('AR010110','100130')"><img src="${root}${HTML_IMG_DIR}/hr.png">HR/총무<span>${CNTof100130 }</span></li>
			</ul>
		</div>
		
		<div id="operational">
			<p>Operational Process</p>
			<ul>
				<li onclick="setArc('AR010500')"><span><img src="${root}${HTML_IMG_DIR}/sop.png"></span><span>SOP</span></li>
				<li onclick="setArc('AR010200')"><span><img src="${root}${HTML_IMG_DIR}/role.png"></span><span>Role</span></li>
				<li onclick="setArc('AR010400')"><span><img src="${root}${HTML_IMG_DIR}/ITsystem.png"></span><span>IT System</span></li>
				<li onclick="setArc2('MFG1000')"><span><img src="${root}${HTML_IMG_DIR}/mfg.png"></span><span>Mfg. Process</span></li>
			</ul>
		</div>
		
		<div id="report">
			<div>
				<p class="floatL"><img src="${root}${HTML_IMG_DIR}/process_knowledge.png">Process Knowledge Portal Statistics Report</p>
				<p class="floatR" onclick="fnClickStati()"><span class="floatL">GO</span><span class="floatR">&gt;</span></p>
			</div>
		</div>
		
		<!--  공지사항/자료실 -->
		<div id="boardDiv">
			<div class="SubinfoTabs">
				<ul>
					<li id="pli1" class="on" onclick="setNoticFrame('1');"><a><span>${menu.LN00001}</span></a></li>
					<li id="pli3" onclick="setNoticFrame('3');"><a><span>${menu.LN00029}</span></a></li>
					<li id="pli4" onclick="setNoticFrame('4');"><a><span>제/변경 리스트</span></a></li>
					<li id="pli2" onclick="setNoticFrame('2');"><a><span>ITS</span></a></li>
				</ul>
				    <span class="morebtn" onClick="javascript:fnClickMoreBoard();">more</span>
			</div>
			<div id="subBrdFrame"  name="subBrdFrame" style="height:calc(100% - 40px);overflow:hidden;" class="postInfo"></div>
		</div>
		
	</div>
</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>