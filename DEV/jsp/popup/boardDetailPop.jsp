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
	var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
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
	var itemID = "${resultMap.ItemID}";
	var changeSetID = "${resultMap.ChangeSetID}";
	var boardMgtID = "${resultMap.BoardMgtID}";
	var boardID = "${resultMap.BoardID}";
	
	if(goDetailOpt == "Y"){
		// 제/개정 검토의견 게시판 일 경우 itemPop창
		if (boardMgtID == "BRD0001") {
			fnOpenItemPop(itemID,changeSetID);
		} else {
			var data = "?goDetailOpt=" + goDetailOpt
			 + "&boardMgtID=" + boardMgtID
			 + "&BoardID=" + boardID
			 + "&s_itemID=" + itemID;
			var url = "boardMgt.do";
			location.href = url + data;
		}	
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
</style>
<div class="popup04" style="font-size:12px !important;">
<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
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
						${resultMap.Subject}
						<a onclick="javascript:goDetail();" class="goDetailBtn" >Full screen</a>
					</td>
				</tr>
				<tr>
					<th class="sline">${menu.LN00004}</th>
					<td id="TD_WRITE_USER_NM">
						${resultMap.WriteUserNM}
					</td>
					<th class="sline">${menu.LN00013}</th>
					<td class="tdend last" style="width:35%;" id="TD_REG_DT">
						${resultMap.RegDT}
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
										<div id="divDownFile${result.Seq}"  class="mm" name="divDownFile${result.Seq}">
											<img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" style="width:13;height:13;padding-right:5px;" alt="파일다운로드" align="absmiddle">
											<span style="cursor:pointer;" onclick="fileNameClick('${result.Seq}','BRD');">${result.FileRealName}</span>
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
				<table class="mgT10" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="4" style="height:100%;" class="tit last">
						<div style="height:100%;overflow:auto;padding:10px;box-sizing: content-box;">
							${resultMap.Content}
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