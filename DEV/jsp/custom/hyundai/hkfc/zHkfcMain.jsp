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
		{"id" : 'BRD3006' , "label" : "${menu.ZLN0008}"},
		{"id" : 2 , "label" : "${menu.LN01014}"},
		{"id" : 4 , "label" : "${menu.LN00215}"},
		{"id" : 3 , "label" : "${menu.LN00029}"}
	];
    
    $(document).ready(function(){
        window.addEventListener("resize", setDivSize);
        
     	// board 명 setting
    	var html = "";
    	for ( var i = 0; i < boardIDs.length; i++) {
    		html += "<li id='pliugt" + i + "' class='titNM";
    		if(i == 0) html += " on";
    		html += "' onclick='javascript:fnClickedTab(" + i + ",\"" + boardIDs[i].id + "\");'>" + boardIDs[i].label + "</li>";
    	}
    	$("#boardUl").append(html);
    	
		fnClickedTask(1); // task setting
		fnClickedDoc(1); // my document list setting
        setNoticeList(noticeID); // notice setting
		fnClickedTab(0,boardIDs[0].id); // board setting
		setTimeout(() => {
			setCSFrame(1); // last updated 10 items setting
		}, 500);
	
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
    	// board 와 Task(나의업무) 높이 맞추기
    	$("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
    	$("#taskDiv").innerHeight($("#boardDiv").height());
    	$("#taskDiv > div:nth-child(2)").innerHeight($("#boardDiv > div:nth-child(2)").height());
        // Last Updated 10 Items 와 My Document list 높이 맞추기
    	$("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
    	$("#docDiv").innerHeight($("#csListDiv").height());
    	$("#docDiv > div:nth-child(2)").innerHeight($("#csListDiv > div:nth-child(2)").height());
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

    // last updated 10 items
    function setCSFrame(avg){
    	var realMenuIndex = "1 2 3 4".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#cs" + realMenuIndex[i]).addClass("on");
			} else {
				$("#cs" + realMenuIndex[i]).removeClass("on");
			}
		}
    	
		var classCode = "";
		
    	if(avg == "1") {
			csType = "1";
    		itemTypeCode = "OJ00001"; // process
    		classCode = "CL01005";
    	}
    	if(avg == "2") {
			csType = "5";
    		itemTypeCode = "OJ00005"; // qms
    	}
    	if(avg == "3") {
			csType = "7";
    		itemTypeCode = "OJ00007"; // rule
    	}
    	if(avg == "4") {
			csType = "16";
    		itemTypeCode = "OJ00001"; // e2e
    		classCode = "CL01008";
    	}
    	
        var url = "mainChangeSetList_v2.do";   
		var target = "csFrame";
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode="+itemTypeCode+"&qryOption=01&classCode="+classCode;
		
    	if(defDimTypeID != null && defDimTypeID != "" && defDimValueID != null && defDimValueID != ""){
    		data += "&dimTypeID=" + defDimTypeID + "&dimValueID=" + defDimValueID;
    	}
    	
        ajaxPage(url, data, target);
    }
    
    function fnClickMoreChangeSet(){
		if(csType == "1") {
    		classCode = "CL01005";
    	}
    	if(csType == "5") {
    		classCode = "CL05003";
    	}
    	if(csType == "7") {
    		classCode = "CL07003";
    	}
    	if(csType == "16") {
    		classCode = "CL01008";
    	}

    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '','',classCode,'','');
    }
    
    // notice
    function setNoticeList () {
    	var target = "tabFrame0";
		var url = "mainBoardList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=3&BoardMgtID=" + noticeID;
		ajaxPageBlankStyle(url, data, target);
    }
    
    // board
    function fnClickedTab(avg,id) {
		var target = "tabFrame1";
		var url = "mainBoardList.do";
		
		$("#boardMgtID").val(id);
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=5&BoardMgtID=" + id;
		ajaxPageBlankStyle(url, data, target);
		
		$("#boardUl > li").removeClass("on");
		$("#pliugt" + avg).addClass("on");
	}
    
    function fnClickMoreBoard(id){
    	var boardMgtID = $("#boardMgtID").val();
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
			result += "<li style=\"width:40%;max-width:595px;\">${fn:escapeXml(list.Subject)}</li>";
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
			result += "<li style=\"width:40%;max-width:595px;\">${fn:escapeXml(list.Subject)}</li>";
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
    
    // my document list
    var docID = "1";
    function fnClickedDoc(avg) {
		var target = "docFrame";
		docID = avg;
		
		if(avg == 1){ // 관리항목
			var url = "zhkfcOwnerItemList.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode=CurAprv&screenType=MyPg";
			ajaxPageBlankStyle(url, data, target);
		}else if(avg == 2){ // bookmark list
			var url = "olmMainbookMarkList.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			ajaxPageBlankStyle(url, data, target);
		}
		
		var realMenuIndex = "1 2".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#doc" + realMenuIndex[i]).addClass("on");
			} else {
				$("#doc" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
    
    function fnClickMoreDoc(){
    	if(docID == "1") {
    		parent.clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "myItem");
    	}
    	else if(docID == "2") {
    		parent.clickMainMenu('PAL0002','Bookmark','','','csh_document','','itemFolderMgt.do?&objClassList=CL01005,CL01006,CL05004,CL07001A,CL07001B','','','','','','','','','Y');
    	}
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

/* #taskDiv span {
	color: #fff;
	margin-left: 10px;
	padding: 1px 7px 3px 7px;
	font-weight: normal;
	background: #0F80E2;
	border-radius: 10px;
} */

#docDiv {
	width: 100%;
    background: #fff;
    margin-bottom:2%;
    box-shadow: rgba(0,0,0,0.1) 1px 1px 5px 0px;
}

#myItemCntFrame {
	float: right;
   	margin: 0;
}

#mainImageFrame {
	background: url(/cmm/common/images//kfcMainHome.png) 0 0/100% 100%;
}

#csListDiv{
	height: calc(32% - 43px);
	box-shadow: rgb(0 0 0 / 10%) 1px 1px 5px 0px;
}

#csListDiv .postInfo {
	box-shadow: none;
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
						<li id="task1" class="on titNM" onclick="javascript:fnClickedTask('1');">${menu.LN01016 }<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task2" class="titNM" onclick="javascript:fnClickedTask('2');">${menu.LN00323 }<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
						<li id="task3" class="titNM" onclick="javascript:fnClickedTask('3');">${menu.LN00215 }<span style="color: #fff; padding-right: 6px; padding-left: 6px; font-weight: normal; background-color: #62b3ed; border-radius: 18px; margin-top: 2px;margin-left: 8px; padding-bottom: 1px;"></span></li>
					</ul>
				</div>
				<div id="taskFrame" class="tabFrame postInfo"></div>	
			</div>
			
			
			<!-- My Document list -->
			<div class="secTit docArea">
				<ul>
					<li class="titNM">My Document list</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreDoc();">
					<li>more</li>
				</ul>
			</div>
			<div id="docDiv" class="docArea">
				<div class="tabs">
					<ul>
						<li id="doc1" class="on titNM" onclick="javascript:fnClickedDoc('1');">${menu.LN00190}</li>
						<li id="doc2" class="titNM" onclick="javascript:fnClickedDoc('2');">Bookmark</li>
					</ul>
				</div>
				<div id="docFrame" class="tabFrame"></div>	
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
			
			<!-- 게시판 -->
			<div class="secTit brdArea">
				<ul>
					<li class="titNM">${menu.LN00123}</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreBoard();">
					<li>more</li>
				</ul>
			</div>
			<div id="boardDiv" class="brdArea">
	 			<div class="tabs">
					<ul id="boardUl">
					</ul>
				</div>
				<div id="tabFrame1" class="tabFrame"></div>	
			</div>
			
			<!-- Last Updated 10 Items -->
			<div class="secTit csArea">
				<ul>
					<li class="titNM">Last Updated 10 Items</li>
				</ul>
				<ul class="morebtn" onClick="javascript:fnClickMoreChangeSet();">
					<li>more</li>
				</ul>
			</div>
			<div id="csListDiv" class="csArea">
				<div class="tabs">
					<ul>
						<li id="cs1" class="titNM" onclick="javascript:setCSFrame(1);">${menu.LN00011}</li>
						<li id="cs2" class="titNM" onclick="javascript:setCSFrame(2);">${menu.LN00050 }</li>
						<li id="cs3" class="titNM" onclick="javascript:setCSFrame(3);">${menu.LN00322 }</li>
						<li id="cs4" class="titNM" onclick="javascript:setCSFrame(4);">E2E</li>
					</ul>
				</div>
				<div id="csFrame" class="postInfo">	</div>	
			</div>
		</div>

	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>