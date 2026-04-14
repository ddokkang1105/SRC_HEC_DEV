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
#mainLayer, #mainLayerFrm {width:100%; height:100%;}
.row {position: relative; width:84%; height:98%; margin:0px auto; background:#fff;}
.col1 {float:left; width:100%; height:50%; margin:2% auto 40px;}
.col2 {float:right; width:100%; height:39%; margin:0 auto;}
.colbottom{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;}
.coltop01 {border-top:1px solid #d7d7d7;border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;background:#fff;;height:34px;line-height:34px;vertical-align:middle;}
.colbottom01{border-left:1px solid #d7d7d7;border-right:1px solid #d7d7d7;border-bottom:1px solid #d7d7d7;background:#fff;height:75%;}
.tbl_nstyle, .tbl_nstyle th, .tbl_nstyle td{border:0px solid #000;margin:0 auto;}
.tbl_nstyle{width:100%;font-family:'Malgun Gothic' !important;font-size:12px;text-align:center}
.tbl_nstyle td{padding:5px;;text-align:left;vertical-align:middle;}
.tbl_nstyle td.hr1 {border-top:#ddd dotted 1px;border-left:#FFFFFF solid 0px;border-right:#FFFFFF solid 0px;font-size:1;line-height:0;height:1px;  padding-top:0px;}

.nstylewrap{float: left;width: 96%; height:92%; margin:1% 2%;}
.nstyleL{float: left; width:15%; max-width: 115px; margin:10px 30px;}
.noform{border:1px solid #d7d7d7;background:#ffff;}
.mainimg {margin: 0 auto;}
</style>
<script type="text/javascript">
    var noticType;var menuIndex = "1 3 4"; 
    var cs_gridArea;var menuIndex2 = "CurAprv ToDoAprv RefMgt3 MyWIP";
	var skin = "dhx_skyblue";
    
    $(document).ready(function(){
    	var screenType = parent.$("#screenType").val();
    	if(screenType == "srRqst"){ // 외부에서 SR등록 호출시 실행 
    		parent.$("#screenType").val("");
    		fnGetSRCreate();
    	}
        setNoticFrame("1");   

        gridCSInit();
        doCSSearchList();
      
	setTimeout(function() {setWorkflowFrame('CurAprv','');}, 1500);
		 
       
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
    	$("#boardMgtID").val(avg);
        var url = "mainBoardList.do";   
        var target = "subBrdFrame";var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+avg;ajaxPage(url, data, target);
        setSubTab(menuIndex, avg, "pli");
    }
    function setProjectFrame(avg){
        var url = "mainProjectGroupList.do";   
        var target = "subPrjFrame";var data = "";ajaxPage(url, data, target);
    }
    function setProcessFrame(avg){
        var url = "mainSttProcess.do";   
        var target = "subPrcFrame";var data = "";ajaxPage(url, data, target);
    }
    function setWorkflowFrame(avg,avg2){
        //var url = "mainSttProgram.do";  
        $("#wfType").val(avg2);
        var url = "mainWorkflowList.do";
        var target = "subWFFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode="+avg+"&screenType=MyPg";
       
        ajaxPage(url, data, target);
        setSubTab(menuIndex2, avg, "pli");
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
		
		fnSearchProcess(searchMode); // Process
		
    }
    
    function fnSearchProcess(avg){
    	var searchValue = $("#searchValue").val();
    	var url = "searchList.do";
    	var target = "mainLayerFrm";
    	var classCode = "CL01005";
    	
    	if(avg != "OJ00001")
    		classCode = "";
    	
    	var data = "itemTypeCode="+avg+"&classCode="+classCode+"&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
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
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    // SR 등록 페이지 바로 가기 
    function fnGetSRCreate(){
    	$('#layerBody').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
    	var url = "srMgt.do";
    	var target = "mainLayerFrm";
    	var data = "screenType=srRqst&srType=ITSP&srMode=REG";
    	ajaxPage(url, data, target);
    }
    
    function gridCSInit() {
		var d = setCSGridData();
		cs_gridArea = fnNewInitGrid("grdCSGridArea", d);
		cs_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid

		//fnSetColType(CS_gridArea, 1, "ch");
		
		cs_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowCSSelect(id, ind);
		});
		cs_gridArea.setColumnHidden(4,true);
	}

	function setCSGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "cs_SQL.getChangeSetList";
		result.header = "No,ID,Name,${menu.LN00296},ItemID";
		result.cols = "Identifier|ItemName|ValidFrom|ItemID";
		result.widths = "50,100,*,120,10";
		result.sorting = "str,str,str,str,str";
		result.aligns = "center,left,left,center,center";
		result.data = "&languageID=${languageID}&ItemTypeCode=OJ00007&csStatus=CLS&maxCSYN=Y&Status=CLS"
			        	+"&pageNo=1&LIST_PAGE_SCALE=15&orderOption=CompletionDT DESC&nChangeType=DEL";
		
		var Now = new Date(); 
		
		var toDate = Now.getFullYear() + ("0" + (Now.getMonth() +1)).slice(-2)
		+ ("0" +  Now.getDate()).slice(-2);

		var Old = new Date(Now.getFullYear(),Now.getMonth() - 3,Now.getDate())
		var fromDate = Old.getFullYear() + ("0" + (Old.getMonth()+1)).slice(-2)
		+ ("0" +  Old.getDate()).slice(-2);
		
		result.data += "&apStartDt=" + fromDate + "&apEndDt=" + toDate;

		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowCSSelect(id, ind) {
		
		var itemID = cs_gridArea.cells(id, 4).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);	
			
	}
	
	function doCSSearchList(){
		var d = setCSGridData();
		fnLoadDhtmlxGridJson(cs_gridArea, d.key, d.cols, d.data,"","","","","");
	}

    function fnClickMoreWF(){
    	var type = "myWF" + $("#wfType").val();
    	parent.clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", type); 
    }

    function fnClickMoreChangeSet(){
    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','','','','CL07002A,CL07004A', '','');
    }
</script>
</head>

<BODY id="layerBody" name="layerBody" >
<div id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
<input id="chkSearch" type="hidden" value="false"></input>
<input id="boardMgtID" type="hidden" value="" >
<input id="wfType" type="hidden" value=""/>
<div class="row">
	<div class="col1">
		<div align="center" style="width:45%; height:100%; margin-left:3.3%; float:left; display:flex;">
			<img id="mainimg" src="${root}${HTML_IMG_DIR}/img_kdnMain.png" style="width:auto; height:100%; margin:0 auto; max-height:380px;">		
		</div>
		<!-- 검색 -->
		<ul style="text-align:left; width:45%; margin-right:3.3%; float:right;">
			<li>
				<input type="radio" name="searchMode" value="OJ00001" checked="checked">&nbsp;&nbsp;					
				<span style="vertical-align:middle;padding-right:9px;"><b>${menu.LN00011}</b></span>
				<input type="radio" name="searchMode" value="OJ00007">&nbsp;&nbsp;
				<span style="vertical-align:middle;padding-right:9px;"><b>${menu.LN00331}</b></span>
				<input type="radio" name="searchMode" value="OJ00005">&nbsp;&nbsp;
				<span style="vertical-align:middle;padding-right:22px;"><b>${menu.LN00330}</b></span>
			</li>
			<li style="padding: 20px 0 0 0;" >
				<input type="text" id="searchValue" name="searchValue" class="text" style="width:80%">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="display:inline-block;"" Onclick="fnSearch();">
			</li>
		</ul>
		<!--  Business Process -->
		<div style="width:45%; height:58%; margin-right:3.3%; float:right;">
			<div class="coltop01" style="margin-top: 6%;">
				<span><span class="pdL20"><b>${menu.ZLN0001}</b></span></span>
				<span class="floatR mgR10 mgT10"onClick="fnClickMoreChangeSet();"><img src="${root}${HTML_IMG_DIR}/more.png"></span>
			</div>
			<div class="colbottom" style="height:100%; display:flex;">
			    <div id="grdCSGridArea" name="grdCSGridArea" style="width:100%;height:100%"></div>
			</div>
		</div>
	</div>	
	<div class="col2">
		<!--  공지사항/자료실 -->
		<div style="width:45%; height:100%; margin-left:3.3%; float:left;">
			<div class="coltop01 SubinfoTabs" style="margin:0;">
				<ul>
					<li id="pli1" class="on" onclick="setNoticFrame('1');"><a><span>${menu.LN00001}</span></a></li>
					<li id="pli3" onclick="setNoticFrame('3');"><a><span>${menu.LN00029}</span></a></li>
					<li id="pli4" onclick="setNoticFrame('4');"><a><span>${menu.LN00215}</span></a></li>
				</ul>
				   <span class="floatR pdR20 pdT10" onClick="javascript:fnClickMoreBoard();"><img src="${root}${HTML_IMG_DIR}/more.png"></span>
			</div>
			<div class="colbottom01">
				<div class="nstylewrap">
					<div class="nstyleR">
						<div id="subBrdFrame"  style="height:100%;overflow-y:auto;"></div>
					</div>
				</div>
				<%-- <div class="nstyleL"><img src="${root}${HTML_IMG_DIR}/img_nstyle01.png"  OnClick="fnGetSRCreate();" style="width:100%;"></div> --%>
			</div>
		</div>
		<!-- 결재 -->
		<div style="width:45%; height:100%; margin-right:3.3%;  float:right;">
			<div class="coltop01 SubinfoTabs" style="margin:0;">
				<ul>
					<li id="pliCurAprv" class="on" onclick="setWorkflowFrame('CurAprv','');"><a><span>${menu.LN00243}</span></a></li>
					<li id="pliToDoAprv" onclick="setWorkflowFrame('ToDoAprv','15');"><a><span>${menu.LN00244}</span></a></li>
					<li id="pliRefMgt3" onclick="setWorkflowFrame('RefMgt3','16');"><a><span>${menu.LN00245}</span></a></li>
					<li id="pliMyWIP" onclick="setWorkflowFrame('MyWIP','');"><a><span>${menu.LN00121}</span></a></li>
				</ul>
				 <span class="floatR pdR20 pdT10" onClick="javascript:fnClickMoreWF();"><img src="${root}${HTML_IMG_DIR}/more.png"></span>
			</div>
			<div class="colbottom01">
				<div id="subWFFrame" style="height:100%;"></div>
			</div>
    	</div>
	</div>
</div>

</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>