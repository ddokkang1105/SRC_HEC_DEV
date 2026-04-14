<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>

<script>

$(document).ready(function(){
	var height = setWindowHeight();
	$("#groupListDiv").height(height-30);
	if(document.getElementById('orgFrame')!=null&&document.getElementById('orgFrame')!=undefined){
		document.getElementById('orgFrame').style.height = (height - 260)+"px";
	};
	
	window.onresize = function(){
		height = setWindowHeight();
		$("#groupListDiv").height(height-30);
		document.getElementById('orgFrame').style.height = (height - 260)+"px";
	};
	
	if("${resultMap.CustLvl}" == "G"){
		setorgFrame('cspList','3');
		$(".cmm_subTab ul li").attr("style","margin-bottom:0px!important;");
	}else{
		setorgFrame('orgMemberMgt','1');
	}
	
	if("${resultMap.Active}" == "1") $("#active").attr("checked", true);
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


function setorgFrame(avg, avg2, avg3){ 
	var url = avg+".do";
	var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&customerNo=${resultMap.CustomerNo}"
			+"&companyID=${resultMap.CompanyID}"
			+"&screenType=cust&srType=CSP"
			+"&custGRPNo=${custGRNo}"
			+"&custLvl=${resultMap.CustLvl}"
			+"${srVarFilter}";
	if(avg2 == '5'){
		data = data +"&projectType=''&projectIDs=${projectIDs}&s_itemID=${itemID}&varFilter=BRD003";
	}
	if(avg2 == '1'){		
			data = data +"&custType=${resultMap.CustType}"
						+"&s_itemID=${resultMap.TeamID}";
	} 
	var target="orgFrame";
	ajaxPage(url,data,target);
	
	for(var i = 0 ; i < 9; i++){
		if(i == avg2){
			$("#pliOM"+i).addClass("on");
		}else{
			$("#pliOM"+i).removeClass("on");
		}
	}
}

//===============================================================================
// BEGIN ::: GRID
	
function clickEditBtn() {
	var url = "editCustDetail.do";
	var data = "customerNo=${resultMap.CustomerNo}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	var target = "groupListDiv";
	ajaxPage(url, data, target);
}

function goBack() {
	parent.fnGoList("${currPage}","${custLvl}","${custType}");
}


</script>

<style>
	body{position:relative;}
	#groupListDiv{width:100%;overflow-y:auto;overflow-x:hidden;position:relative;-ms-overflow-style:scrollbar;-webkit-box-sizing: border-box;
 			-moz-box-sizing: border-box; box-sizing: border-box; height:100%;}
	.groupListDiv .groupListDiv{padding:0!important;}
	.dhxcont_global_content_area{border-top:0px solid #fff;}
	.msg{margin-top:2px;margin-bottom:0px!important;}
	.alignBTN{padding-right:0px!important;padding-top:5px!important;}
</style>

</head>

<body>
	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="groupList" id="groupList" action="#" method="post" onsubmit="return false;">
		<div id="groupListDiv" class="hidden groupListDiv" style="padding:10px;">
			<input type="hidden" id="customerNo" name="customerNo" value="${resultMap.CustomerNo}" />
			<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.ZLN0200} ${menu.LN00108}</div>
			<div id="groupInfoDiv" class="hidden" style="width:100%;height:140px;">
				<div class="alignBTN" id="saveGrp">
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
					<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
					<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" onclick="clickEditBtn()"  type="submit"></span>
					</c:if>
				</div>
				<table class="tbl_blue01 mgT5" width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
						<col width="11%">
						<col width="14%">
					</colgroup>
					<tr>
						<th>${menu.ZLN0201}</th>
						<td>${resultMap.CustomerNM}</td>
						<th>${menu.ZLN0202}</th>
						<td>${resultMap.CustomerNo}</td>
						<th>고객${menu.LN00042}</th>
						<td>${resultMap.CustType}</td>
						<th>${menu.ZLN0204}</th>
						<td class="last">${resultMap.CustLvlNM}</td>
					</tr>
					<tr>
						<th>${menu.ZLN0205}</th>
						<td>${resultMap.BizNo}</td>
						<th>${menu.ZLN0206}</th>
						<td>${resultMap.CEOName}</td>
						<th>${menu.ZLN0207}</th>
						<td>${resultMap.BizType}</td>
						<th>${menu.ZLN0208}</th>
						<td class="last">${resultMap.BizItem}</td>
					</tr>
					<tr>
						<th>${menu.ZLN0209}</th>
						<td colspan="3">${resultMap.Address}</td>
						<th>${menu.LN00035 }</th>
						<td>${resultMap.CustomerDesc}</td>
						<th>Active</th>
						<td class="last"><input type="checkbox" id="active" name="active" disabled></td>
					</tr>
				</table>
			</div>	
	
			<div class="cmm_subTab mgB20">
				<ul>
					<c:if test="${resultMap.CustLvl == 'C' || resultMap.CustLvl == 'D'}">
						<li id="pliOM1"><a href="javascript:setorgFrame('orgMemberMgt','1');"><span>Contact</span></a></li>
						<!-- li id="pliOM2"><a href="javascript:setorgFrame('orgMemberMgt','2');"><span>Contract</span></a></li-->
					</c:if>
					<li id="pliOM3"><a href="javascript:setorgFrame('cspList','3');"><span>SR Management</span> </a></li>
					<c:if test="${resultMap.CustLvl == 'C'}">
						<li id="pliOM4"><a href="javascript:setorgFrame('csrList','4');"><span>CSR</span></a></li>	
						<!-- li id="pliOM5"><a href="javascript:setorgFrame('forumMgt','5');"><span>${menu.LN00012}</span> </a></li-->
						<!-- <li id="pliOM6"><a href="javascript:setorgFrame('teamRoleMgt','6');"><span>계약관리</span></a></li>	
						<li id="pliOM7"><a href="javascript:setorgFrame('childOrgMgt','7');"><span>Billing</span> </a></li> -->
						<li id="pliOM8"><a href="javascript:setorgFrame('custCategoryMgt','8');"><span>SR Category</span> </a></li>
					</c:if>
				
				</ul>
			</div>			
			<div id="orgFrame" style="display:none" frameborder="0" scrolling='no'></div>
			
			<div class="schContainer" id="schContainer">
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
			</div>
			
		</div>
	</form>			
</body>
</html>