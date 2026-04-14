<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
    var csType="1";
    var itemTypeCode = "";
    var templCode = "${templCode}";
	var defDimTypeID = "115053";
	var defDimValueID = "${defDimValueID}";
	
	// 법인별 board setting
	var noticeID = 1;
	var boardIDs = [
		{"id" : 3 , "label" : "${menu.LN00029}"},
		{"id" : 4 , "label" : "${menu.LN00215}"},
		{"id" : 2 , "label" : "${menu.LN01014}"},
		{"id" : 'BRD3006' , "label" : "${menu.ZLN0008}"}
	];
	if(defDimTypeID != null && defDimTypeID != "" && defDimValueID != null && defDimValueID != ""){
		if(defDimValueID == "VN") {
			noticeID = 11;
			boardIDs = [
				{"id" : 13 , "label" : "${menu.LN00029}"},
				{"id" : 14 , "label" : "${menu.LN00215}"},
				{"id" : 12 , "label" : "${menu.LN01014}"}];
		}
		// if(defDimValueID == "CN") 등 다른 법인 추가예정
	}
    
    $(document).ready(function(){
        window.addEventListener("resize", setDivSize);
        
     	// board 명 setting
    	var html = "";
    	for ( var i = 0; i < boardIDs.length; i++) {
    		setBoardList((i+1),boardIDs[i].id);
    		$("#boardTitle" + (i+1)).text(boardIDs[i].label);
    		html = '<ul class="morebtn" onClick="javascript:fnClickMoreBoard(' + boardIDs[i].id + ');"><li>more</li></ul>';
    		$("#brdTit" + (i+1)).append(html);
    	}
   	
		fnClickedTask(1); // task setting
        setNoticeList(noticeID); // notice setting
		
		// size 조절
		setDivSize();
		
		// 나의 업무 count setting 
		$("#task1 > span").text("${wfCurAprvCnt}");
		$("#task2 > span").text("${fn:length(myRewBrdList)}");
		$("#task3 > span").text("${fn:length(myQABrdList)}");
		
		// search
		$('#ItemTypeCode').change(function(){
			changeItemTypeCode($(this).val()); // 계층 option 셋팅
		});
		
		$("#ItemTypeCode").SumoSelect({parentWidth: 33.9});
		$("#classCode").SumoSelect({parentWidth: 33.9});
	});
    
    function setDivSize(){
    	// board1 와 Task(나의업무) 높이 맞추기
    	$("#taskDiv > div:nth-child(2)").innerHeight($("#taskDiv").height()-$("#taskDiv > div:nth-child(1)").height());
    	$("#boardDiv1").innerHeight($("#taskDiv").height());
    	$("#boardDiv1 > div:nth-child(2)").innerHeight($("#taskDiv > div:nth-child(2)").height());
        // board2 와 board3 높이 맞추기
    	$("#boardDiv2 > div:nth-child(2)").innerHeight($("#boardDiv2").height()-$("#boardDiv2 > div:nth-child(1)").height());
    	$("#boardDiv3").innerHeight($("#boardDiv2").height());
    	$("#boardDiv3 > div:nth-child(2)").innerHeight($("#boardDiv2 > div:nth-child(2)").height());
    }
    
	function ajaxPageBlankStyle(url, data, target) {
		$.ajax({
			url: url,
			type: 'post',
			data: data,
			async: true,
			error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },
			beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}},
			success: function(data){
				$('#loading').fadeOut(10);
				$("#" + target).hide();
				if (data.includes("There is no item to be listed.")) {
					$("#" + target).html("");
				} else {
					$("#" + target).html(data);
				}
				$("#" + target).fadeIn(10);
			}
		});
	} 
    
    // search
    function fnSearch(){
    	var searchValue = $("#searchValue").val();
    	var url = "searchList.do";
    	var target = "mainLayerFrm";
    	var selectItemTypecode = $("#ItemTypeCode").val();
    	var selectClassCode = $("#classCode").val();
    	
    	var data = "itemTypeCode="+selectItemTypecode+"&classCode="+selectClassCode+"&screenType=main&searchKey=AT00001&searchValue="+searchValue;
    	// 법인 조건 추가
    	if(defDimTypeID != null && defDimTypeID != "" && defDimValueID != null && defDimValueID != ""){
    		data += "&defDimTypeID=" + defDimTypeID + "&templCode=" + templCode;
    	}
    		
    	ajaxPage(url, data, target);
    }
    
 	// [계층 option] 설정
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "classCode";             // selectBox id
		var defaultValue = "${classCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendClassOption,1000);
	}
    
    function appendClassOption(){
		$("#classCode")[0].sumo.reload();
	}

    // notice
    function setNoticeList () {
    	var target = "tabFrame0";
		var url = "mainBoardList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=3&BoardMgtID=" + noticeID;
		ajaxPageBlankStyle(url, data, target);
    }
    
     // board1
    function setBoardList (id, mgtID) {
    	var target = "tabFrame" + id;
		var url = "mainBoardList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=3&BoardMgtID=" + mgtID;
		ajaxPageBlankStyle(url, data, target);
    }
     
    function fnClickMoreBoard(id){
    	var boardMgtID = id;
    	if(boardMgtID ==""){boardMgtID="1";}
    	if(id == "notice"){boardMgtID=noticeID;}
    	
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    function fnDetail(mgtID, ID){
		var url="boardDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardID="+ID+"&BoardMgtID="+mgtID;
		
		var windowWidth = $( window ).width();
		var popupWidth = (windowWidth*70)/100;
		
		//KPAL 운영 소스의 mainBoardList.jsp 에도 해당방식으로 사이즈 조절 (소스 전체 업그레이드 시 주의) 
		fnOpenLayerPopup(url,data,"",popupWidth,700);
	}
    
    // task
    var taskID = "1";
    function fnClickedTask(avg) {
		var target = "taskFrame";
		taskID = avg;
		
		if(avg == 1){ // 결재할문서
			var url = "mainWorkflowList.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode=CurAprv&screenType=MyPg";
			ajaxPage(url, data, target);
		}else if(avg == 2){ // 검토 my스케줄
			var result = '<div class="postInfo">';			
			<c:forEach items="${myRewBrdList}" var="list" varStatus="status">
			result += '<ul onclick="fnDetail(\'BRD0001\',\'${list.BoardID}\')">';
			result += '<li style=\"width:10%;\"class=\"alignL\">${list.ItemTypeNM}</li>';
			result += "<li style=\"width:28%;\">${list.Identifier}&nbsp;&nbsp;${fn:escapeXml(list.itemName)}</li>";
			result += '<li style=\"width:40%;max-width:595px;\">${list.Subject}</li>';
			result += '<li style="width:10%;"class="alignC">${list.WriteUserNM}</li>';
			result += '<li style="width:12%;"class="alignC">${list.EndDT}</li>';
			result += '</ul>';
			</c:forEach>
			result += '</div>';
			document.getElementById(target).innerHTML = result;
		}else if(avg == 3){ // my Q&A
			var result = '<div class="postInfo">';			
			<c:forEach items="${myQABrdList}" var="list" varStatus="status">
			result += '<ul onclick="fnDetail(\'BRD0001\',\'${list.BoardID}\')">';
			result += '<li style=\"width:10%;\"class=\"alignL\">${list.ItemTypeNM}</li>';
			result += "<li style=\"width:28%;\">${list.Identifier}&nbsp;&nbsp;${fn:escapeXml(list.itemName)}</li>";
			result += '<li style=\"width:40%;max-width:595px;\">${list.Subject}</li>';
			result += '<li style="width:10%;"class="alignC">${list.WriteUserNM}</li>';
			result += '<li style="width:12%;"class="alignC">${list.EndDT}</li>';
			result += '</ul>';
			</c:forEach>
			result += '</div>';
			document.getElementById(target).innerHTML = result;
		}
		
		var realMenuIndex = "1 2 3".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#task" + realMenuIndex[i]).addClass("on");
			} else {
				$("#task" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
    
    function fnClickMoreTask(){
    	if(taskID == "1") {
    		parent.clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "myWF");
    	}
    	if(taskID == "2") {
    		var url =  "boardForumList.do"; // beforeEndDT 없이 전체출력
			var data = "&BoardMgtID=BRD0001&myBoard=Y";
			var target = "layerBody";
    		ajaxPage(url, data, target);
    	}
    	if(taskID == "3") {
    		var url =  "boardForumList.do";
			var data = "&BoardMgtID=4&myBoard=Y";
			var target = "layerBody";
    		ajaxPage(url, data, target);
    	}
    }
    
    function fnGoWFDetail(projectID,wfID,stepInstID,actorID,stepSeq,wfInstanceID,lastSeq,documentID,docCategory){
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
					+"&wfMode=CurAprv";
				
		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
	}
    
    function fnItemInfo(avg1){
    	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
    	var w = 1200;
    	var h = 900;
    	itmInfoPopup(url,w,h,avg1);
	}
    
</script>

<style>
#mainWrapper {
	top:2%;
	width: 95%;
}

#leftDiv , #rightDiv {
	width: 48.5%;
}

#searchDiv {
	width: 100%;
    height: calc(22% - 43px);
    margin-bottom:2%;
    border: 1px solid #e6e6e6;
}

#searchDiv ul{
	padding: 29px 20px;
}

#searchDiv > ul > li > label {
	font-size:12px;
	width:8%;
	display:inline-block;
}

#noticeDiv {
	width: 100%;
    height: calc(22% - 43px);
    margin-bottom:2%;
    box-shadow:rgba(0,0,0,0.1) 1px 1px 5px 0px;
    background: #fff;
}

#tabFrame0 {
	height:100%;
}

#taskDiv {
	width: 100%;
    background: #fff;
    margin-bottom:2%;
    box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;
}

#taskDiv span {
	color: #fff;
	margin-left: 10px;
	padding: 1px 7px 3px 7px;
	font-weight: normal;
	background: #0F80E2;
	border-radius: 10px;
}

#boardDiv1,#boardDiv2,#boardDiv3 {
	background: #fff;
	box-shadow: rgb(0 0 0 / 10%) 1px 1px 5px 0px;
}

#boardDiv1{
	margin-bottom:2%;
}

#boardDiv2{
	height: calc(32% - 43px);
}

#myItemCntFrame {
	float: right;
   	margin: 0;
}

#mainImageFrame {
	background: url(/cmm/common/images//kfcMainHome.png) 0 0/100% 100%;
}

#popupDiv {
	width:1000px;
}

</style>
</head>

<body id="layerBody" name="layerBody" >
<div class="noform" id="mainLayer">
<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
	<input id="boardMgtID" type="hidden" value=""  />
	<input id="attrIndex"  type="hidden" value="0" />
	<div id="mainWrapper">
		<div id="leftDiv">
			
			<!-- 문서 검색 -->
			<div class="secTit">
				<ul>
					<li class="titNM">${menu.LN00134} ${menu.LN00047}</li>
				</ul>
			</div>
			<div id="searchDiv">
				<ul>
					<li>
						<label for="ItemTypeCode">${menu.LN00021 }</label>
						<select name="ItemTypeCode" id="ItemTypeCode">
							<option value="">Select</option>
							<c:forEach var="i" items="${itemTypeList}">
								<option value="${i.CODE}">${i.NAME}</option>						
							</c:forEach>
						</select>
						<label for="classCode" style="margin-left: 4%;">${menu.LN00016 }</label>
						<select name="classCode" id="classCode">
							<option value="">Select</option>
						</select>
					</li>
					<li style="padding: 20px 0 0 0;" >
						<label for="searchValue">${menu.LN00028}</label>
						<input type="text" id="searchValue" name="searchValue" class="text" style="width:81%" />
						<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="display:inline-block; float:right;" Onclick="fnSearch();" />
					</li>
				</ul>
			</div>
			
			<!-- 나의 업무 -->
			<div class="secTit">
				<ul>
					<li class="titNM">${menu.LN01022}</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreTask();">
					<li>more</li>
				</ul>
			</div>
			<div id="taskDiv">
	 			<div class="tabs">
					<ul>
						<li id="task1" class="on titNM" onclick="javascript:fnClickedTask('1');">${menu.LN01016 }<span></span></li>
						<li id="task2" class="titNM" onclick="javascript:fnClickedTask('2');">${menu.LN00323 }<span></span></li>
						<li id="task3" class="titNM" onclick="javascript:fnClickedTask('3');">${menu.LN00215 }<span></span></li>
					</ul>
				</div>
				<div id="taskFrame" class="tabFrame postInfo"></div>	
			</div>
			
			<!-- Q&A -->
			<div class="secTit" id="brdTit2">
				<ul>
					<li id="boardTitle2" class="titNM"></li>
				</ul>
			</div>
			<div id="boardDiv2" class="brdArea">
				<div id="tabFrame2" class="tabFrame"></div>	
			</div>
			
		</div>
		
		<div id="rightDiv">
			<!-- 공지사항  -->
			<div class="secTit">
				<ul>
					<li class="titNM">${menu.LN00001}</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreBoard('notice');">
					<li>more</li>
				</ul>
			</div>
			<div id="noticeDiv">
				<div id="tabFrame0" class="tabFrame"></div>
			</div>
			
			<!-- 자료실 -->
			<div class="secTit" id="brdTit1">
				<ul>
					<li id="boardTitle1" class="titNM"></li>
				</ul>
			</div>
			<div id="boardDiv1" class="brdArea">
				<div id="tabFrame1" class="tabFrame"></div>	
			</div>
			
			<!-- FAQ -->
			<div class="secTit" id="brdTit3">
				<ul>
					<li id="boardTitle3" class="titNM"></li>
				</ul>
			</div>
			<div id="boardDiv3" class="brdArea">
				<div id="tabFrame3" class="tabFrame"></div>	
			</div>
			
		</div>

	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>