<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/> --%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<head>
<style>
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 0 0 0 8px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	.btn_arrow {
		opacity:0.7;
	}
	.btn_arrow:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#itemNameAndPath, #functions{
		display:inline;
	}
	.tbl_preview td {
		height: 24px;
	}
</style>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		// 초기 표시 화면 크기 조정 
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1, avg2, avg3){
		
		if(avg2 == "VIEWER") {
			var url = "openViewerPop.do?seq="+avg1;
			var w = screen.width;
			var h = screen.height;
			
			if(avg3 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {	
			var url  = "fileDownload.do?seq="+avg4;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	function doDetail(avg1, avg2){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	// 관련항목 팝업
	function clickItemEvent(trObj) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+trObj
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnRunLink(url,attrUrl,attrTypeCode){
		var lovCode = "${lovCode}";		
		var itemID = "${itemID}";
		var fromItemID = "${fromItemID}";
		if(fromItemID != ""){
			itemID = fromItemID;
		}
		
		if(url == null || url == ""){
			url = attrUrl;		
		}
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}else{
			
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
		}		
		window.open(url,'_newtab');		
	}
	
	function fnContentToggle() {
		var node = event.target;
		var src = node.src;
		var name = node.name;
		var filename = (src.split("/")[src.split("/").length-1]).split(".")[0];
		
		if(filename == "btn_arrow_up") {
			node.setAttribute("src","${root}cmm/common/images/btn_arrow_down.png");
			$("#"+node.name).slideUp();
		} else {
			node.setAttribute("src","${root}cmm/common/images/btn_arrow_up.png");
			$("#"+node.name).slideDown();
		}
	}
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "openTeamInfo", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">				
		<div id="itemDiv" class="pdT10">			
			<!-- 첨부 및 관련 문서 --> 
			<div class="flex align-center justify-between pdR10 pdB5">
				<div>
					<span class="cont_title">${menu.LN00111}</span>
					<span class="mgL10" style="color:red">( * 사용자매뉴얼 용량이 큰 경우, 조회 시간이 오래 걸릴 수 있습니다. )</span>
				</div>
				<img src="${root}cmm/common/images/btn_arrow_up.png" onclick="fnContentToggle()" name="file" class="btn_arrow"/>
			</div>
			<div id="file">
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="5%">
						<col width="75%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>${menu.LN00101}</th>
					    <th>${menu.LN00060}</th>
						<th>${menu.LN00078}</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<tr>
							<td>${no }</td>
							<td class="align-center alignL flex pdL10">
								<span class="btn_pack small icon mgR20">
								<c:set var="FileFormat" value="${fileList.FileFormat}" />
									<span class="
											<c:choose>
												<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
												<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
												<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
												<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
												<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
												<c:otherwise>log</c:otherwise>
											</c:choose>
													"></span>
								</span>
								<span style="cursor:pointer;" class="mgL10" onclick="fileNameClick('${fileList.Seq}','${itemFileOption}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
								(<span id="fileSize">${fileList.FileSize}</span>)
								<c:if test="${itemFileOption eq 'VIEWER'}">
									<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" class="mgL10">
								</c:if>
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.LastUpdated}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
			
			<!-- BIGIN :: 관련 VELL -->
			<div class="flex align-center justify-between pdR10 pdB5">
				<p class="cont_title">관련 Activity List</p>
				<img src="${root}cmm/common/images/btn_arrow_up.png" onclick="fnContentToggle()" name="cxn" class="btn_arrow"/>
			</div>
			<div id="cxn">
				<table class="tbl_preview mgB10">
					<colgroup>
						<col width="5%">
						<col width="65%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="0%">
						<col width="0%">
					</colgroup>
					<tr>
						<th>No</th>
						<th>${menu.LN00043 }</th>
						<th>${menu.LN00004 }</th>
						<th>${menu.LN00027 }</th>
						<th>${menu.LN00070 }</th>
					</tr>
					<c:set value="1" var="no" />
					<c:set var="orderType" value="CM,EM,TR,NB,SS,all" />
					<c:forTokens items="${orderType}" delims="," var="type">
						<c:forEach var="relItemList" items="${attrMatchValueList}" varStatus="status">
							<c:if test="${(type eq fn:substring(relItemList.Identifier,0,2))}">
							<tr>
								<td>${no }</td>
								<td class="alignL pdL10">
									<span style="cursor:pointer; border-bottom: 1px solid;" onclick="clickItemEvent(${relItemList.PItemID})">${relItemList.Path}</span>&nbsp;&gt;&nbsp;
									<font style="color: blue; cursor:pointer; border-bottom: 1px solid;" onclick="clickItemEvent(${relItemList.ItemID})">${relItemList.Identifier}&nbsp;${relItemList.ItemName}</font>
								</td>
								<td>${relItemList.Name}(${relItemList.OwnerTeamName })</td>
								<td>${relItemList.StatusName}</td>
								<td>${relItemList.LastUpdated}</td>
								<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
								<td class="tdhidden">${relItemList.ParentID}</td>
							</tr>
							<c:set var="no" value="${no+1}"/>
							</c:if>
						</c:forEach>
					</c:forTokens>
				</table>	
			</div>
		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
