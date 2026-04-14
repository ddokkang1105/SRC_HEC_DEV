<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
 <!DOCTYPE html>
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<script type="text/javascript">
	var chkReadOnly = false;
	var isWf = "";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var s_itemID = "${s_itemID}";
	var scrnMode = "${scrnMode}";
	var sessionUserId = "${sessionScope.loginInfo.sessionUserId}";
	var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
</script>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<style>

	.noticeTab02{margin-top:-15px;}
	.noticeTab02 > input{display:none;}
	.noticeTab02 > label{display:inline-block;margin:0 0 -1px; padding:15px 0; font-weight:700;text-align:center;color:#999999;width:62px;}
	.noticeTab02 > section {display: none;padding: 20px 0 0;}
	.noticeTab02 > input:checked+label{color:#333333;border-bottom:3px solid #008bd5;}
	#itemDiv > div {
		padding : 0 10px;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
	border: 1px solid #ccc;
	width:100%;
	}
	#maintext th{
	    text-align: left;
    padding: 10px;
        color: #000;
    font-weight: bold;
	}
	#maintext td{
	 width: 97%;
    border: 1px solid #ccc;
    display: block;
    padding-top: 10px;
    padding-left: 10px;
    margin: 0px auto 15px;
    overflow-x: auto;
    line-height: 18px;
	}
	#maintext  textarea {
	width: 100%;
	resize:none;
	}
</style>
<script type="text/javascript">

	$(document).ready(function(){				
		
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});

		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});

	});


	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function saveObjInfoMain(){	
		
		if(confirm("${CM00001}")){	
			
			if (!setAllCondition()) {
		        return; 
		    }
			
			$('#loading').fadeIn(150);
			var url = "zhec_saveItemInfoAPI.do";	
			var frm = document.getElementById('editSOPFrm');
			ajaxSubmitNoAdd(frm, url);
			
		}
	}
	
	var itemTypeCodeTreePop;
	function fnOpenItemTree(){
		var itemTypeCode = $("#itemTypeCode").val();
		var url = "itemTypeCodeTreePopV4.do";
		var data = "ItemTypeCode="+itemTypeCode+"&openMode=assignParentItem&s_itemID=${itemID}&option=AR010100&hiddenClassList='CL05003','CL16004'";

// 		fnOpenLayerPopup(url,data,doCallBackItem,617,436);
		itemTypeCodeTreePop = openUrlWithDhxModal(url, data, "Search" , 617, 436)
	}
	
	function doCallBackItem() {
		
	}
	
	function doCallBackTeam(orgID,orgNames) {
		$("#orgIDs").val(orgID);
		$("#orgNames").val(orgNames);
		
	}
	
	function setParentItem(pID,avg){
		$("#parentID").val(pID);
		$("#parentPath").val(avg);
// 		$(".popup01").hide();
// 		$("#mask").hide();
// 		$("#popupDiv").hide();

		itemTypeCodeTreePop.hide();
	}

	function searchOrgPopUp(){
		
		var url = "orgUserTreePop.do";
		var data = "s_itemID=${s_itemID}&openMode=assignOwnerTeam&btnName=Assign&btnStyle=assign";
		fnOpenLayerPopup(url,data,doCallBackTeam,617,436);
		
	}
	function fnRefreshTree(itemId,isReload){ 

	}
	function fnCreateRefreshTree(itemId,isReload){ 
		fnRefreshPage("${option}",itemId);
	}

	
	function fnGetItemClassMenuURL(itemID){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID;
		ajaxPage(url, data, target);
	}
	
	function fnSetItemClassMenu(menuURL, itemID){
		var temp = itemID.split("&");
		
		var url = menuURL+".do";
		var data = "&itemID="+s_itemID+"&itemClassMenuUrl="+menuURL+"&scrnMode=E";
		
		for(var i=0; i<temp.length; i++) {
			var temp2 = temp[i].split("=");

			if(temp2.length > 1 && scrnMode == "E" && temp2[0] != "itemViewPage") {                            
				data += "&" + temp2[0] + "=" + temp2[1];
			}
			else if(temp2.length > 1 && scrnMode != "E" && temp2[0] != "itemEditPage") {
				data += "&" + temp2[0] + "=" + temp2[1];
			}
		}
		
		var target = "myItemList";
		ajaxPage(url, data, target);
	}

	
	function fnRefreshPage(option, itemID,scrnMode){
		parent.fnRefreshPageCall(option, itemID,scrnMode);
	}
	
	var orgTeamTreePop;
	function fnGoOrgTreePop(){
		var url = "orgTreePop.do";
		var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}&option=NoP";
// 		fnOpenLayerPopup(url,data,doCallBack,617,436);
		orgTeamTreePop = openUrlWithDhxModal(url, data, "Search Organization" , 617, 436)
	}
	
	function fnTeamRoleCallBack(){
	}
	
	function doCallBack(){}
	
	function fnSaveTeamRole(teamIDs,teamNames){
		$("#orgNames").val(teamNames);
		$("#orgTeamIDs").val(teamIDs);
		
		orgTeamTreePop.hide();
	}
	
	
	function selfClose(){
		goBack();
	}
	

	function setAllCondition() {
		
		/*
		if("${sessionScope.loginInfo.sessionAuthLev}" == "1") {
			return true;
		}
		*/
		
		const validationRules = [
	        { id: "#parentID",    message: "분류체계를 선택하여 주십시오." },
	        { id: "#AT00001",     message: "표준명을 입력하여 주십시오." },
	        { id: "#Description", message: "제/개정/폐기 사유를 입력하여 주십시오." },
	        { id: "#Reason",      message: "주요 개정 사항을 입력하여 주십시오." },
	        { id: "#orgNames",    message: "유관조직을 선택하여 주십시오." }
	    ];

	    for (const rule of validationRules) {
	        const $el = $(rule.id);
	        if ($.trim($el.val()) === "") {
	            alert(rule.message);
	            $el.focus();
	            return false;
	        }
	    }
		
		return true;
	}
	
</script>
</head>
<!-- BIGIN :: -->
<body>
<form name="editSOPFrm" id="editSOPFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
<div id="processItemInfo">
<input type="hidden" id="s_itemID" name="s_itemID"  value="${itemID}" />
<input type="hidden" id="option" name="option"  value="${option}" />		
<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
<input type="hidden" id="AuthorID" name="AuthorID" value="" />
<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />			
<input type="hidden" id="sub" name="sub" value="${sub}" />
<input type="hidden" id="function" name="function" value="saveObjInfoMain">
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
<input type="hidden" id="projectId" name="projectId" value="" />
<input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
<input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" />

	<div id="htmlReport" style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
				
		<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>
				
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB10">
				<div class="pdL10 pdT15 pdB5" style="width:98%;">
				<p class="cont_title">${menu.LN00321} ${menu.ZLN016}</p>
				</div>
				<table class="tbl_preview mgB10">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>${menu.LN00021}</th>
						<td class="alignL pdL10">
						<select id="itemTypeCode" name="itemTypeCode" class="sel">
						<option value="OJ00005">SOP</option>
						<option value="OJ00016">STP</option>
						</select>
						
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10">
						<input type="text" id="parentPath" name="parentPath" value="" class="text" onClick="fnOpenItemTree()">
						<input type="hidden" id="parentID" name="parentID" />
						</td>
					</tr>
					<tr>
						<th>${menu.ZLN018}</th>
						<td class="alignL pdL10">
						<input type="text" id="AT00001" name="AT00001" value="" class="text" maxLength="100">
						</td>
						<th>${menu.ZLN021}</th>
						<td class="alignL pdL10">
						<input type="text" id="orgNames" name="orgNames" value="" class="text" onClick="fnGoOrgTreePop()">
						</td>
					</tr>
					<tr>
						<th>${menu.LN00359}</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;"></textarea> 
						</td>						
					</tr>
					<tr>
						<th>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="10">						
						<textarea class="edit" id="Reason" name="Reason" style="width:100%;height:40px;"></textarea>
						</td>						
					</tr>
				</table>
			</div>
			
			<div class="alignR">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
			</div>
			
			
		</div>
	</div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>