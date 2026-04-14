<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>
   
<style>
    .fontStyleB15{
		font-size:15px;
		font-weight:Bold;  
		color:#3f3c3c;
	}
	.fontStyleB12{
		font-size:13px;
		color:#4265ee;
	}
	.fontStyleN12{
		font-size:12px;
		color:#4265ee;
		cursor: pointer;
	}
	.scroll-wrapper {
		width:100%;
		height:100%;
		overflow-y:auto;
	}
	#searchResultFrm:before {
		content: "";
	    position: absolute;
	    width: calc(100% - 9px);
	    height: 1px;
	    background: #ddd;
	} 
</style>

<script type="text/javascript">
	$(document).ready(function() {	
		fnResult('${searchList.size()}');
	
		var scrollH = $(".scroll-wrapper").height();
		var searchResultFrmH = $("#searchResultFrm").height();
		if(scrollH < searchResultFrmH) $(".scroll-wrapper").css("box-shadow","0px -1px 0 0 #ddd inset");
	});
	
	function fnClickItemType(itemTypeCode,e){		
		if($("#itemTypeTitleHidden_"+itemTypeCode).val() == "N"){			
			$("#itemTypeTitle_"+itemTypeCode).css("display", "block");
			$("#itemTypeTitleHidden_"+itemTypeCode).val("Y");
			$(e).attr("src","${root}cmm/common/images/fold.png");
		} else {			
			$("#itemTypeTitle_"+itemTypeCode).css("display", "none");
			$("#itemTypeTitleHidden_"+itemTypeCode).val("N");
			$(e).attr("src","${root}cmm/common/images/unfold.png");
		}
		
		var scrollH = $(".scroll-wrapper").height();
		var searchResultFrmH = $("#searchResultFrm").height();
		if(scrollH < searchResultFrmH) $(".scroll-wrapper").css("box-shadow","0px -1px 0 0 #ddd inset");
		else $(".scroll-wrapper").css("box-shadow","none");
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
		}
		else {

			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.searchResultFrm, url,"blankFrame");
		}
		
	}
	
	function fnGoDefArcPage(arcCode,menuStyle,url,varFilter){
		parent.fnDefArcPage(arcCode,menuStyle,url,varFilter);
	}
	
	function fnItemDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function fnResult(count){
		var searchValue = parent.$("#searchValue2").val();	
		if(searchValue == ""){
			searchValue = parent.$("#AT00001Value").val();
		}
		if(count < 1 || count == "") {
			alert("${WM00018}");
			count = "0";
		}
		
		var resultHtml ="<span class=resultCount>";
		resultHtml += '<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00068" arguments="<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\"'+ searchValue+'\"</span>,<span style=\"color:#4265ee;font-size:15px;font-weight:700\">'+count+'</span>" />';
		resultHtml +="</span>";
	
		$('#resultCount').html(resultHtml);
	
	}
	
</script>

</head>

<body>
<div id="resultCount" class="resultCount mgB10"></div>	
<div class="scroll-wrapper" style="height: calc(100% - 31px);">
	<c:if test="${fn:length(itemTypeList) > 0 }">
	<form name="searchResultFrm" id="searchResultFrm" action="#" method="post" onsubmit="return false;">
	<c:forEach var="itemTypeList" items="${itemTypeList}" varStatus="i">
		<div style="border-left: 1px solid #ddd; border-right: 1px solid #ddd;">
			<div style="width:100%;height:36px;background: #f2f2f2;padding-top:13px;border-top: 1px solid #ddd;border-bottom: 1px solid #ddd;" >
				<ul>
					<li class="floatL flex">								
					<span class="flex align-center fontStyleB15 mgR5"><img src="${root}cmm/common/images/fold.png" class="pdL10 pdR10 mgL5 mgR5" style="cursor:pointer;" onClick="fnClickItemType('${itemTypeList.ItemTypeCode}',this);" >
					<img src="${root}${HTML_IMG_DIR_ITEM}/${itemTypeList.Icon}" class="mgR5">
					${itemTypeList.ItemTypeName}</span><span class="fontStyleB12">(${itemTypeList.ItemCount}건)</span>
					</li>
					<li class="floatR pdR20">
						<span class="fontStyleN12" OnClick="fnGoDefArcPage('${itemTypeList.DefArc}','${itemTypeList.MenuStyle}','${itemTypeList.URL}','${itemTypeList.VarFilter}');">바로가기&nbsp;> </span>
					</li>
				</ul>
			</div>
			<div id="itemTypeTitle_${itemTypeList.ItemTypeCode}" name="itemTypeTitle_${itemTypeList.ItemTypeName}" >
				<input type="hidden" id="itemTypeTitleHidden_${itemTypeList.ItemTypeCode}" name="itemTypeTitleHidden_${itemTypeList.ItemTypeCode}" >
			<c:forEach var="sList" items="${searchList}" varStatus="i">
				<c:if test="${itemTypeList.ItemTypeCode eq sList.ItemTypeCode}">
				<div style="padding: 20px 20px 20px 50px;border-bottom:1px solid #ddd;" >
					<ul class="flex justify-between">
						<li class="pdL20">
							<span class="fontStyleB15" OnClick="fnItemDetail('${sList.ItemID}');" style="cursor: pointer">${sList.Identifier}&nbsp;${sList.ItemName}</span><br>
							${sList.Path}
						</li>
						<li class="pdR20" style="flex-basis: 200px;">
							${sList.LastUpdated}<br>
							${sList.Name}(${sList.TeamName})<br>
							${sList.StatusName}
						</li>
					</ul>
					<div class="pdL20 mgT10">
						<c:forEach var="attrList" items="${attrCodeList}" varStatus="i">
							<c:set var="attrCode" value="${attrList.AttrTypeCode}" />							
							${sList[attrCode]}
						</c:forEach>
					</div>
					<c:if test="${!empty sList.documentList}">
						<div class="pdL15 mgT20  align-center">
							<input type="text" value="Attachment" style="height:24px;width:90px;color:#0f80e2;background-color:#e3f0fe;border:0px;border-radius:20px;text-align:center;margin-right: 10px" readOnly >
							<br/>
							<c:forEach var="fileList" items="${sList.documentList}" varStatus="idx"> 								
								<c:if test="${!idx.first}"><br/></c:if><span style="cursor:pointer;color: #808080;" onclick="fileNameClick('${fileList.Seq}','${fileList.Seq}','','${fileList.Seq}','${fileList.Seq}');">
								${fileList.FileRealName}	
								</span>
							</c:forEach>
						</div>
					</c:if>
				</div>
				</c:if>
			</c:forEach>
			</div>
		</div>
	</c:forEach>
	</form>
	</c:if>
</div>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>	
</body>
</html>