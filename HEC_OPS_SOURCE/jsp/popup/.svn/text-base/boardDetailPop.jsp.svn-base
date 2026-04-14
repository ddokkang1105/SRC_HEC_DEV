<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var chkReadOnly = true;
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
	
});
function clickSetCookie(){if(document.getElementById("IS_CHECK").checked){var cookieId="sfolmLdNtc_"+"${resultMap.BoardID}";setCookie(cookieId, "LD", 1);} else {setCookie(cookieId, "", -1);}}
function clickClosePop(){self.close();}
function fileNameClick(avg1, avg2){
	var seq = new Array();
	seq[0] = avg1;
	var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
	ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
}	


function fnOpenItemPop(itemID){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,itemID);
}
</script>
<style>
	strong,em{font-size:inherit;}
</style>
<div class="popup01" style="font-size:12px !important;">
<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10">${boardMgtNM}</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone" >
  		<div class="con01">
  			<table class="tbl_brd" style="table-layout:fixed;width:668px;" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col>
					<col width="15%">
					<col>
				</colgroup>		
				<tr>
					<th>${menu.LN00002}</th>
					<td class="sline tit last" colspan="3">${resultMap.Subject} 
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
				<table  width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="4" style="height:240px;" class="tit last">
						<div style="width:645px;height:223px;overflow:auto;padding:10px;box-sizing: content-box;">
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