<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<style type="text/css">
 a:link { color: blue; text-decoration: underline;}
 a:visited { color: #800080; text-decoration: underline;}
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<script type="text/javascript">

	jQuery(document).ready(function() {
		$("#viewPageBtn").attr("style:display","none");
	});
	
	function fnOpenParentItemPop(){// ParentItem Popup
		var itemId = "${parentItemID}";
		if(itemId=="" || itemId=="0"){return;}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${parentItemID}&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	function fnChangeMenu(menuID,menuName) { 

		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}else if(menuID == "file"){
			var url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}"; 
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);			
		}else if(menuID == "report"){
			var url = "objectReportList.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&backBtnYN=N"; 
		 	ajaxPage(url, data, target);			
		}else if(menuID == "relation"){
			var url = "cxnItemTreeMgt.do"; 
			var data = "s_itemID=${itemID}&backBtnYN=N&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			var target = "itemDescriptionDIV";
			ajaxPage(url, data, target);
		}else if(menuID == "changeSet"){
			var url = "itemHistory.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&backBtnYN=N&myItem=${myItem}&itemStatus=${itemStatus}";
		 	ajaxPage(url, data, target);
		}else if(menuID == "dimension"){
			var url = "dimListForItemInfo.do";
			var target = "itemDescriptionDIV";
			var data = "s_itemID=${itemID}&backBtnYN=N";
		 	ajaxPage(url, data, target);
		}	
		document.getElementById('viewPageBtn').style.display ="block";
		
	}
	
	function fnViewPage(){
		parent.fnSetItemClassMenu("${itemClassMenuUrl}","${itemID}")
	}
			
</script>
</head>

<body>
<div id="itemMenualDiv" class="pdT10 pdR10" style="position:relative; height:100%;top:-50px;">
<div style="height:100%;position:absolute;width:100%;overflow-y:auto;overflow-x:hidden;padding-top:50px;">
	<div class="mgB10 pdL10 mgR10">
	   <li class="floatL" style="font-size:14px;">
	  	 <img src="${root}${HTML_IMG_DIR_ITEM}/${processInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${processInfo.Path}/<span style="color:#3333FF;font-size:14px;font-weight:bold;">${processInfo.ItemName}</span> 
	   </li>
	   <li class="floatR pdR10">
		<ul id="nav4" >
			<li id="viewPageBtn" class="viewPageBtn" style="display:none;"><span style="font-size:14px;display:done;" OnClick="fnViewPage();"><img src="${root}${HTML_IMG_DIR}/ico_arrow_left.png">&nbsp;&nbsp;View Page</span></li>
			<li class="top">				
				<span id="cmbMenu" style="font-size:14px;"><img src="${root}${HTML_IMG_DIR}/icon_pjt_cfg.png">&nbsp;&nbsp;Menu</span>	
				<ul class="sub4" id="layerMenu">	
					<li onclick="fnChangeMenu('report','Report');"><a href="#" style="border-bottom:1px solid #c0c0c0;padding-bottom:3px;" alt="report" id="report" >Report</a></li>			
					<c:if test="${menuDisplayMap.FileOption ne  'N'}">
						<li onclick="fnChangeMenu('file','Attachments');"><a href="#" alt="file" id="file">Attachments<font color="#1141a1">(${menuDisplayMap.FILE_CNT})</font></a></li>	
					</c:if>
					<c:if test="${menuDisplayMap.HasDimension eq '1'}">
						<li onclick="fnChangeMenu('dimension','Dimension');"><a href="#" alt="dimension" id="dimension">Dimension<font color="#1141a1">(${menuDisplayMap.DIM_CNT})</font></a></li>
					</c:if>
					<li onclick="fnChangeMenu('relation','Relation');"><a style="border-bottom:1px solid #c0c0c0;padding-bottom:3px;" href="#" alt="relation" id="relation">Relationship</a></li>
					<c:if test="${menuDisplayMap.ChangeMgt eq '1'}">
						<li onclick="fnChangeMenu('changeSet','Change history');"><a href="#" alt="changeSet" id="changeSet">Change history<font color="#1141a1">(${menuDisplayMap.CNGT_CNT})</font></a></li>	
					</c:if>			
					<li onclick="fnChangeMenu('management','Management');"><a href="#" alt="management" id="management">Management</a></li>										
				</ul>				
			</li>						
		</ul>
	   </li>
	</div>	
	<div class="mgT30 mgL7" style="width:99%;border-top:1px solid #ddd;" >
	<div id="itemDescriptionDIV" name="itemDescriptionDIV" class="mgT5" style="width:100%;text-align:center;">
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<tr>	
				<td class="alignL pdL5 pdT10" valign="top" style="width:100%;height:100%;">
				${itemDescription}
				</td>			
			</tr>
		</table>
	</div>
	</div>
</div>
</div>
</body>
	
