<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<head>
<style>
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
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
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
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
	
	function goBatchAttrPop() {
		var itemID = "${itemID}";
 		var w = "500";
		var h = "220";
		var url = "zhdhi_batchAttrPop.do?itemID="+itemID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");		
	}
	
/* 	function goBatchReport() {
	    var url = "custom/zhdhi_batchReportRdy.do";
		var target = "actFrame";
		var data = "itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&url=custom/hdhi/report/batchReport&classCode=CL04005";
	 	ajaxPage(url, data, target);
		
	} */
	
	function urlReload() {
		var url = "custom/zhdhi_processItemInfo.do";
		var target = "actFrame";
		var data = "s_itemID=${itemID}&url=custom/hdhi/item/zhdhi_viewSysInfo"; 
	 	ajaxPage(url, data, target);
	}
	
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;">
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">				
		<c:if test="${systemtype eq 'BATCH' && sessionScope.loginInfo.sessionLogintype == 'editor' && myItem == 'Y'}">
		<%-- <c:if test="${itemBlocked eq '0' && sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}"> --%>
			<span class="btn_pack nobg white" sytle="width:100%;"><a onclick="goBatchAttrPop();"class="edit mgT2 " title="Attributes"></a></span>		   		
			<!-- <span class="btn_pack nobg white"><a onclick="goBatchReport();"class="copy" title="정의서"></a></span> -->		   		
		</c:if> 
		<div id="itemDiv" class="pdT10">
			<!-- BIGIN :: 기본정보 -->
			<div class="flex align-center justify-between pdB10">
				<p></p>
				<img src="${root}cmm/common/images/btn_arrow_up.png" onclick="fnContentToggle()" name="process" class="btn_arrow"/>
			</div>
			<div id="process">
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<c:choose>
							<c:when test="${systemtype eq 'SAP'}">
								<th>백그라운드작업이름</th>
							</c:when>
							<c:when test="${systemtype eq 'NF'}">
								<th>프로그램ID</th>
							</c:when>
							<c:when test="${systemtype eq 'BATCH'}">
								<th>백그라운드작업이름</th>
							</c:when>
							<c:when test="${systemtype eq 'NCO'}">
								<th>Func/Module명</th>
							</c:when>
							<c:when test="${systemtype eq 'EAI'}">
								<th>I/F ID</th>
							</c:when>
							<c:otherwise>
								<th>Program No.</th>
							</c:otherwise>
						</c:choose>
						
						<c:choose>
							<c:when test="${systemtype eq 'NF'}">
								<td class="alignL pdL10">${attrMap.AT00000}</td>
							</c:when>
							<c:otherwise>
								<td class="alignL pdL10">${prcList.Identifier}</td>
							</c:otherwise>
						</c:choose>
						<th>${menu.LN00004}</th>
						<td class="alignL pdL10" style="cursor:pointer;color: #0054FF;text-decoration: underline;" >
							<span onclick="fnGetAuthorInfo(${prcList.AuthorID})">${prcList.AuthorName}</span>
							<span onclick="fnOpenTeamInfoMain(
								<c:if test="${accMode eq 'OPS' || accMode eq '' }">${prcList.AuthorTeamID}</c:if>
								<c:if test="${accMode eq 'DEV'}">${prcList.OwnerTeamID}</c:if>
								)" >(${prcList.OwnerTeamName})</span>
						</td>
						<th>${menu.LN00027}</th>
						<td class="alignL pdL10">${prcList.StatusName}</td>
						<th>${menu.LN00070 }</th>
						<td class="alignL pdL10">${prcList.LastUpdated}</td>
					</tr>
					<c:choose>
						<c:when test="${systemtype eq 'NCO'}">
							<th>${attrNameMap.ATNCO93 }</th>
							<td class="alignL pdL10" colspan="7">
								<div style="width:100%;height:200px;">
									<textarea class="tinymceText" id="AT00003" name="AT00003" readonly="readonly">${attrMap.ATNCO93}</textarea>
								</div>
							</td>
						</c:when>
						<c:when test="${systemtype eq 'SAP'}">
							<th>${attrNameMap.ATSAP93 }</th>
							<td class="alignL pdL10" colspan="7">
								<div style="width:100%;height:200px;">
									<textarea class="tinymceText" id="AT00003" name="AT00003" readonly="readonly">${attrMap.ATSAP93}</textarea>
								</div>
							</td>
						</c:when>
						<c:when test="${systemtype eq 'BATCH'}">
							<th>${attrNameMap.ATPRD93 }</th>
							<td class="alignL pdL10" colspan="7">
								<div style="width:100%;height:200px;">
									<textarea class="tinymceText" id="AT00003" name="AT00003" readonly="readonly">${attrMap.ATPRD93}</textarea>
								</div>
							</td>
						</c:when>
						<c:otherwise>
							<th>${attrNameMap.AT00003 }</th>
							<td class="alignL pdL10" colspan="7">
								<div style="width:100%;height:200px;">
									<textarea class="tinymceText" id="AT00003" name="AT00003" readonly="readonly">${attrMap.AT00003}</textarea>
								</div>
							</td>
						</c:otherwise>
					</c:choose>
					
<%-- 					<tr>
						<th>${attrNameMap.AT00003 }</th>
						<td class="alignL pdL10" colspan="7">
							<textarea class="tinymceText" id="AT00003" name="AT00003" style="width:100%;height:200px;"><div class="mceNonEditable">${attrMap.AT00003}</div></textarea>
						</td>
					</tr>
 --%>					<c:choose>
						<c:when test="${systemtype eq 'SAP'}">
							<tr>
								<th>${attrNameMap.AT00037 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.AT00037}</td>
								<th>${attrNameMap.AT00014 }</th>
								<td class="alignL pdL10" colspan="3">
									<a onClick="fnRunLink('${attrLinkMap.AT00014}','', 'AT00014');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">${attrMap.AT00014}</a>
								</td>
							<tr>
						</c:when>
						<c:when test="${systemtype eq 'NF'}">
							<tr>
								<th>${attrNameMap.AT00037 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.AT00037}</td>
								<th>${attrNameMap.AT00039 }</th>
								<td class="alignL pdL10" colspan="3">
									<a onClick="fnRunLink('${attrLinkMap.AT00039}','', 'AT00039');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">${attrMap.AT00039}</a>
								</td>
							<tr>
						</c:when>
					</c:choose>	
					<c:choose>
						<c:when test="${systemtype eq 'BATCH'}">
							<tr>
								<th>${attrNameMap.ATPRD09 }</th>
								<td class="alignL pdL10">${attrMap.ATPRD09}</td>
								<th>${attrNameMap.ATPRD10 }</th>
								<td class="alignL pdL10">${attrMap.ATPRD10}</td>
								<th>${attrNameMap.ATPRD11 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATPRD11}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD01 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD01}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD97 }</th>
								<td class="alignL pdL10" colspan="7">
									<textarea style="width:100%;height:50px;" readonly="readonly">${attrMap.ATPRD97}</textarea>
								</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD98 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD98}</td>
							</tr>							
							<tr>
								<th>${attrNameMap.ATPRD12 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD12}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD13 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD13}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD02 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD02}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD03 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD03}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD04 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD04}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD05 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD05}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD06 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD06}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD07 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD07}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD08 }</th>
								<td class="alignL pdL10" colspan="8">${attrMap.ATPRD08}</td>
							</tr>
							<tr>
								<th>${attrNameMap.ATPRD99 }</th>
								<td class="alignL pdL10" colspan="7">
									<textarea style="width:100%;height:50px;" readonly="readonly">${attrMap.ATPRD99}</textarea>
								</td>
							</tr>							
						</c:when>
						<c:when test="${systemtype eq 'NCO'}">
							<tr>
								<th>${attrNameMap.ATNCO01 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO01}</td>
								<th>${attrNameMap.ATNCO06 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO06}</td>
								<th>${attrNameMap.ATNCO07 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATNCO07}</td>
							<tr>
							<tr>
								<th>${attrNameMap.ATNCO02 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO02}</td>
								<th>${attrNameMap.ATNCO03 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO03}</td>
								<th>${attrNameMap.ATNCO04 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO04}</td>
								<th>${attrNameMap.ATNCO05 }</th>
								<td class="alignL pdL10">${attrMap.ATNCO05}</td>
							<tr>
						</c:when>
						<c:when test="${systemtype eq 'SAP'}">
							<tr>
								<th>${attrNameMap.ATSAP01 }</th>
								<td class="alignL pdL10">${attrMap.ATSAP01}</td>
								<th>${attrNameMap.ATSAP02 }</th>
								<td class="alignL pdL10">${attrMap.ATSAP02}</td>
								<th>${attrNameMap.ATSAP03 }</th>
								<td class="alignL pdL10">${attrMap.ATSAP03}</td>
								<th>${attrNameMap.ATSAP90 }</th>
								<td class="alignL pdL10">${attrMap.ATSAP90}</td>
							<tr>
							<tr>
								<th>${attrNameMap.ATSAP04 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATSAP04}</td>
								<th>${attrNameMap.ATSAP05 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATSAP05}</td>
							<tr>
						</c:when>
						<c:when test="${systemtype eq 'NF'}">
							<tr>
								<th>${attrNameMap.ATNF001 }</th>
								<td class="alignL pdL10">${attrMap.ATNF001}</td>
								<th>${attrNameMap.ATNF002 }</th>
								<td class="alignL pdL10">${attrMap.ATNF002}</td>
								<th>${attrNameMap.ATNF003 }</th>
								<td class="alignL pdL10">${attrMap.ATNF003}</td>
								<th>${attrNameMap.ATNF092 }</th>
								<td class="alignL pdL10">${attrMap.ATNF092}</td>
							<tr>
						</c:when>												
						<c:when test="${systemtype eq 'EAI'}">
							<tr>
								<th>${attrNameMap.ATEAI04 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATEAI04}</td>
								<th>${attrNameMap.ATEAI05 }</th>
								<td class="alignL pdL10" colspan="3">${attrMap.ATEAI05}</td>
							<tr>
							<tr>
								<th>${attrNameMap.ATEAI01 }</th>
								<td class="alignL pdL10">${attrMap.ATEAI01}</td>
								<th>${attrNameMap.ATEAI02 }</th>
								<td class="alignL pdL10">${attrMap.ATEAI02}</td>
								<th>${attrNameMap.ATEAI03 }</th>
								<td class="alignL pdL10">${attrMap.ATEAI03}</td>
								<th>${attrNameMap.ATEAI92 }</th>
								<td class="alignL pdL10">${attrMap.ATEAI92}</td>
							<tr>
						</c:when>												
					</c:choose>				
				</table>
			</div>
			
<%-- 			<!-- 첨부 및 관련 문서 --> 
			<div class="flex align-center justify-between">
				<p class="cont_title">${menu.LN00111}</p>
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
								<span style="cursor:pointer;" class="mgL10" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption }','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
								(<span id="fileSize">${fileList.FileSize}</span>)
								<c:if test="${fileList.fileOption eq 'VIEWER'}">
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
 --%>			
			<!-- BIGIN :: 관련 VELL -->
			<div class="flex align-center justify-between">
				<p class="cont_title">관련 Process</p>
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
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00001' }">
					<tr>
						<td>${no }</td>
						<td class="alignL pdL10">
							<span style="cursor:pointer; border-bottom: 1px solid;" onclick="clickItemEvent(${relItemList.ParentID})">${relItemList.path}</span>&nbsp;&gt;&nbsp;
							<font style="color: blue; cursor:pointer; border-bottom: 1px solid;" onclick="clickItemEvent(${relItemList.s_itemID})">${relItemList.Identifier}&nbsp;${relItemList.ItemName}</font>
						</td>
						<td>${relItemList.Name}(${relItemList.AuthorTeamName })</td>
						<td>${relItemList.StatusName}</td>
						<td>${relItemList.LastUpdated}</td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
						<td class="tdhidden">${relItemList.ParentID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>
		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
