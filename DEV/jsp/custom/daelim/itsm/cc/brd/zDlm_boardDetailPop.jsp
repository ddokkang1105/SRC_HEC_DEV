<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var chkReadOnly = true;
	var goDetailOpt = "Y";
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script>	

jQuery(document).ready(function() {	
	$('#popup_close_btn').click(function(){clickClosePop();});
	var noticType = "${noticType}";
	
	if(noticType == "4") {
		$("#Content").css("height","200px");
		$("#Content_ifr").css("height","200px");
	}
	
	if(goDetailOpt == "Y") {
		$(".goDetailBtn").show();
	}
	
});
function clickSetCookie(){if(document.getElementById("IS_CHECK").checked){var cookieId="sfolmLdNtc_"+"${resultMap.BoardID}";setCookie(cookieId, "LD", 1);} else {setCookie(cookieId, "", -1);}}
function clickClosePop(){self.close();}
function fileNameClick(avg1, avg2){
	var seq = new Array();
	seq[0] = avg1;
	var url  = "zDlm_fileDownload.do?seq="+seq+"&scrnType=BRD";
	ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
}	

function fnOpenItemPop(itemID,changeSetID){
	if(itemID != "" && itemID != null && itemID != 0) {
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		
		if(changeSetID != "" && changeSetID != null && changeSetID != 0){
			url += "&changeSetID=" + changeSetID + "&option=CNGREW";
		}
		
		itmInfoPopup(url,w,h,itemID);
	}
}

// [제목 클릭 시 상세화면으로 이동 ::: goDetailOpt=Y ]
function goDetail(){
	var itemID = "${resultMap.ORGNZT_ID}";
	var changeSetID = "${resultMap.ChangeSetID}";
	var boardMgtID = "${boardMgtID}";
	var faqID = "${resultMap.FAQ_ID}";
	if(goDetailOpt == "Y"){
		// 제/개정 검토의견 게시판 일 경우 itemPop창
			var data = "?goDetailOpt=" + goDetailOpt
			 + "&boardMgtID=" + boardMgtID
			 + "&faqID=" + faqID
			 + "&s_itemID=" + itemID;
			var url = "zDlm_boardMgt.do";
			location.href = url + data;
	}
}
</script>
<style>
	strong,em{font-size:inherit;}
	.goDetailBtn {
		cursor:pointer;
		font-weight:bold;
		color:#3a4d98;
		float:right;
		margin-right:10px;
	}
	
	table {float: left;}
	
.popup04 {
  position: fixed;  /* 화면의 보이는 영역을 기준으로 고정 */
  top: 50%;  /* 화면 상단에서 50% 위치 */
  left: 50%; /* 화면 왼쪽에서 50% 위치 */
  transform: translate(-50%, -50%); /* 중앙 정렬 */
  width: 30vw;  /* 너비를 화면 크기에 비례하여 설정 */
  height: 65vh; /* 높이를 화면 크기에 비례하여 설정 */
  max-width: 1200px; /* 최대 너비 설정 */
  max-height: 800px; /* 최대 높이 설정 */
  margin: auto;
  z-index: 9999;  /* 팝업이 다른 콘텐츠 위에 표시되도록 z-index 설정 */
}


}

.szone {
  max-height: 100%;
  overflow: auto;
}

.tbl_brd {
  width: 100%;
  table-layout: fixed;
}

@media screen and (max-width: 1200px) {
  .popup04 {
    width: 90vw;
    height: 70vh;
  }
}

@media screen and (max-width: 768px) {
  .popup04 {
    width: 95vw;
    height: 60vh;
  }
}

@media screen and (max-width: 480px) {
  .popup04 {
    width: 100vw;
    height: 50vh;
  }
}
}
</style>
<div class="popup04" style="font-size:12px !important;">
<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
<input type="hidden" id="faqID" name="faqID" value="${resultMap.FAQ_ID}">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10">${boardMgtNM}</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone" >
  		<div>
  			<table class="tbl_brd" style="table-layout:fixed;" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col>
					<col width="15%">
					<col>
				</colgroup>		
				<tr>
					<th>${menu.LN00002}</th>
					<td class="sline tit last" colspan="3">
						${resultMap.QESTN_SJ}
						<a onclick="javascript:goDetail();" class="goDetailBtn" >Full screen</a>
					</td>
				</tr>
				<tr>
					<th class="sline">${menu.LN00004}</th>
					<td id="TD_WRITE_USER_NM">
						${resultMap.NAME}
					</td>
					<th class="sline">${menu.LN00013}</th>
					<td class="tdend last" style="width:35%;" id="TD_REG_DT">
						${resultMap.FRST_REGIST_PNTTM}
					</td>
				</tr>
				<tr>
					<th class="sline">
						${menu.LN00019}
					</th>
					<td colspan="3" class="tit last" style="position:relative;">
					<!-- 하단 div 높이값으로 간격 수정 -->
							<div class="pdT5"></div>
					<!-- 파일 다운로드 -->
							<div id='down_file_items'  style="overflow:scroll;overflow-x:hidden;height:50px;">
							<c:if test="${itemFiles.size() > 0}">
								<c:forEach var="result" items="${itemFiles}" varStatus="status" >
										<div id="divDownFile${result.fileSn}"  class="mm" name="divDownFile${result.fileSn}">
											<img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" style="width:13;height:13;padding-right:5px;" alt="파일다운로드" align="absmiddle">
											<span style="cursor:pointer;" onclick="fileNameClick('${result.fileSn}','BRD');">${result.orignlFileNm}</span>
											<br>
										</div>
								</c:forEach>
							</c:if>										
							<div id='display_items'></div>
							<input type="hidden" id="items" name="items"/>		
	
					</td>			
				</tr>
				<c:if test="${noticType == '4' }">
				<tr>
					<th  class="sline">
						${menu.LN00043}
					</th>
					<td colspan="3" class="tit last" style="position:relative">
						<c:if test="${!empty resultMap.ItemID && resultMap.ItemID ne '0'}">
				  			<span style="cursor:pointer;" Onclick="fnOpenItemPop(${resultMap.ItemID})"> Path :	${resultMap.Path}</span>	
						</c:if>
					</td>			
				</tr>
				</c:if>
				</table>
				<table class="mgT10" width="100%" style="height:calc(100% - 150px);" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="4" style="height:100%;" class="tit last">
						<div style="height:100%;overflow:auto;padding:10px;box-sizing: content-box;">
							${resultMap.QESTN_CN}
						</div>
					</td>
				</tr>
				</table>
  		</div>
	</div>
	</li>	
	</ul>
	</form>
</div>