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
.col1 {float: left;width: 49%; margin: 0;clear: both;margin:0 5px;}
.coltop {border:1px solid #d7d7d7;background:url("${root}${HTML_IMG_DIR}/bg_mainhome_title.png");height:34px;line-height:34px;vertical-align:middle;}
.colbottom{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;}
.coltop01 {border-top:1px solid #d7d7d7;border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;background:#fff;;height:34px;line-height:34px;vertical-align:middle;}
.colbottom01{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;height:200px;}
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
    var noticType;var menuIndex = "1 2";    
    $(document).ready(function(){
        setNoticFrame(1,4); 
        setIssueFrame();
        setProcessFrame();        
        setSchdlFrame();        
    });
    function setNoticFrame(avg1, avg2){
        var url = "mainBoardList.do";   
        var target = "subBrdFrame";
        var data = "mainVersion=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=5&noticType="+avg2;
        ajaxPage(url, data, target);
        setSubTab(menuIndex, avg1, "pli");
    }
    function setIssueFrame(){
        var url = "mainIssueList.do";
        var target = "subIsFrame";
        var data = "listSize=5";
        ajaxPage(url, data, target);
    }
    function setProcessFrame(avg){
        var url = "mainSttProcess.do";   
        var target = "subPrcFrame";var data = "";ajaxPage(url, data, target);
    }
    function setSchdlFrame(avg){    
     	var url = "mainSchdlList.do";
        var target = "subSchFrame";
        var data = "listSize=5&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    } 
    
    function fileNameClick(avg1, avg2, avg3, avg4, avg5){
    	var originalFileName = new Array();
    	var sysFileName = new Array();
    	var seq = new Array();
    	sysFileName[0] =  avg3 + avg1;
    	originalFileName[0] =  avg3;
    	seq[0] = avg4;
    	var url  = "fileDownload.do?seq="+seq+"&scrnType="+avg5;
    	ajaxSubmitNoAdd(document.mainLayerV2Frm, url,"saveFrame");
    }
</script>
</head>

<BODY>
<form name="mainLayerV2Frm" id="mainLayerV2Frm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<div class="row">
	<div class="col1">
		<!--  공지사항/자료실 -->
		<div class="coltop01 pdT10 mgT10">
			<div class="nSubinfoTabs">
				<ul>
					<li id="pli1" class="on" onclick="setNoticFrame(1,4);"><a><span>${menu.LN00045}</span></a></li>
					<li id="pli2" onclick="setNoticFrame(2,3);"><a><span>${menu.LN00029}</span></a></li>
				</ul>
				    <span class="floatR pdR20" onClick="javascript:parent.clickMainMenu('BOARD', 'BOARD');"><img src="${root}${HTML_IMG_DIR}/more.png"></span>
			</div>
		</div>
		<div class="colbottom01">
			<div class="nstylewrap">
				<div class="nstyleR"><div id="subBrdFrame"  name="subBrdFrame" width="98%" height="100%"></div></div>
			</div>
			
		</div>
		
		<!-- ISSUE -->
		<div class="coltop01 pdT10 mgT10">
			<div class="nSubinfoTabs">
				<ul>
					<li id="pli1" class="on" onclick="setIssueFrame();"><a><span>Issue</span></a></li>
				</ul>
				    <span class="floatR pdR20" onClick="javascript:parent.goMenu('mainIssueSearchMgt.do', '', true, layout_2E);">
				    	<img src="${root}${HTML_IMG_DIR}/more.png">
				    </span>
			</div>
		</div>
		<div class="colbottom01">
			<div class="nstylewrap">
				<div class="nstyleR"><div id="subIsFrame"  name="subIsFrame" width="98%" height="100%"></div></div>
			</div>
			
		</div>
		
	</div>
	<div class="col2">
		<!--  Business Process -->
		<div class="coltop mgT10"><span><img src="${root}${HTML_IMG_DIR}/icon_mainhome01.png"></span><span class="pdL20"><b>Business Process</b></span><span class="floatR pdR10"></span></div>
		<div class="colbottom">
		    <div id="subPrcFrame"  name="subPrcFrame" width="98%" height="100%"></div>
		</div>
		
		<!-- Schedule -->
		<div class="coltop01 pdT10 mgT10">
			<div class="nSubinfoTabs">
				<ul>
					<li id="pli1" class="on" onclick="setSchdlFrame();"><a><span>Schedule</span></a></li>
				</ul>
				    <span class="floatR pdR20" onClick="javascript:parent.goMenu('goSchdlListMgt.do', '', true, layout_2E);"><img src="${root}${HTML_IMG_DIR}/more.png"></span>
			</div>
		</div>
		<div class="colbottom01">
			<div class="nstylewrap">
				<div class="nstyleR"><div id="subSchFrame"  name="subSchFrame" width="98%" height="100%"></div></div>
			</div>
		</div>
	</div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>
</BODY>