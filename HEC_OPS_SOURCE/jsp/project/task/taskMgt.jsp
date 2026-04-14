<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>

<script type="text/javascript">
    var menuIndex = "1 2";
	$(document).ready(function(){	
		$("input.datePicker").each(generateDatePicker); // calendar
		fnClickedTab('taskPlan','','1');
		
		fnSelect('priority', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=PRT', 'getDictionaryOrdStnm', '${csrInfo.Priority}', 'Select');
		fnSelect('difficulty', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=DFCT', 'getDictionaryOrdStnm', '${csrInfo.Difficulty}', 'Select');
	});
		
	function fnClickedTab(avg, oj, avg2) {		
		var itemID = "${itemID}";
		var changeSetID = "${csrInfo.ChangeSetID}";
		var projectID = "${csrInfo.ProjectID}";
		var csrAuthorID = "${csrInfo.AuthorID}";
		var curTask = "${csrInfo.CurTask}";
		var csrStatus = "${csrInfo.CsrStatus}";
		var parentID = "${csrInfo.ParentID}";
	
		var url = avg + ".do";
		var data = "itemID="+itemID+"&changeSetID="+changeSetID+"&projectID="+projectID+"&csrAuthorID="+csrAuthorID+"&curTask="+curTask+"&csrStatus="+csrStatus+"&parentID="+parentID;
		var target="arcFrame";
		
		ajaxPage(url, data, target);
	
		var realMenuIndex = menuIndex.split(' ');

		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg2) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}

	}
		
	var subtabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$('.subtabs ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('pliugt', '') != subtabsNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('subtabsNum : ' + subtabsNum);
		}).click(function(){
			subtabsNum = $(this).attr('id').replace('pliugt', '');
		});
	});
	
	function fnClickedEdit(){
		$("#readMode").attr('style', 'display: none');
		$("#editMode").attr('style', 'display: block');
		$("#priority").attr("disabled",false);
		$("#difficulty").attr('disabled', false);
		$("#description").attr('disabled', false);
	}
	
	function fnCsrEdit(){
		var changeSetID = "${csrInfo.ChangeSetID}";
		var projectID = "${csrInfo.ProjectID}";
		var itemID = "${itemID}";		
		var priority = $("#priority").val();
		var difficulty = $("#difficulty").val();
		var description = $("#description").val();
		
		var url = "editCsrInfo.do";
		var data = "&changeSetID="+changeSetID+"&itemID="+itemID+"&priority="+priority+"&difficulty="+difficulty+"&description="+description;
		var target = "blankFrame";	
		ajaxPage(url,data,target);
	}
	
	function fnCallBack(){		
		var url = "taskMgt.do";
		var data = "&itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&isFromMain=${isFromMain}"; 
		var target="taskFrm";		
		ajaxPage(url, data, target);
	}
	
	/* 의견공유, 변경이력, 관련문서, Dimension 등의 화면으로 이동 */
	function goMenu(avg) {
		var target = "actFrame";
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&isFromTask=Y"; 
		var url = "itemHistory.do"; // 변경이력
		ajaxPage(url, data, target);
	}
	
</script>
</head>
<body>
<form name="taskFrm" id="taskFrm" action="#" method="post" onsubmit="return false;"> 
	<c:if test="${csrInfo != null }">
		<table style="table-layout:fixed;" width="98%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
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
				<th class="viewtop">${menu.LN00106}</th>
				<td class="viewtop">${csrInfo.Identifier}</td>
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop">${csrInfo.ItemName}</td>
				<th class="viewtop">${menu.LN00200}</th>
				<td class="viewtop">${csrInfo.AuthorName}</td>
				<th class="viewtop">${menu.LN00013}</th>
				<td class="tdLast viewtop">${csrInfo.CreateDT}</td>
			</tr>
			<tr>
				<th>${menu.LN00131}</th>
				<td>${csrInfo.ProjectName}</td>
				<th>${menu.LN00069}</th>
				<td>${csrInfo.CurTaskName}</td>	
				<th>${menu.LN00067}</th>
				<td>
					<select id="priority" name="priority" class="sel" style="margin-left=5px;" disabled=true></select>
				</td>
				<th>난이도</th>
				<td class="tdLast"><select id="difficulty" name="difficulty" class="sel" style="margin-left=5px;" disabled=true></select></td>
			</tr>	
		</table>
		
	    <div class="floatR mgT10">
			<ul>
				<li class="floatR pdR20" id="readMode" name="readMode">
		  			<c:if test="${csrInfo.AuthorID == sessionScope.loginInfo.sessionUserId && csrInfo.CsrStatus != 'CLS'}">
		       		<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnClickedEdit()"></span>
		       	    </c:if> 
			   	</li>
				<li class="floatR pdR20" id="editMode" name="editMode" style="display:none">
		       		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCsrEdit()" type="submit"></span>
			   		<c:if test="${isFromMain != 'Y' }">
			   		<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="fnCallBack()" type="submit"></span>
			   		</c:if>
			   	</li>
			</ul>
		</div> <c:if test="${isFromMain != 'Y' }"><div style="height:10px"></div>  </c:if>
		<div class="subtabs">
			<ul>
				<li id="pliugt1"  class="on"><a href="javascript:fnClickedTab('taskPlan','','1');"><span>${menu.LN00238}</span></a></li> 
				<li id="pliugt2"><a href="javascript:fnClickedTab('taskDeliverables','','2');"><span>${menu.LN00199}</span></a></li>
			</ul>
		</div>	
		<div id="arcFrame"></div>
	</c:if>
	<c:if test="${csrInfo == null }">
		<div>${WM00120}</div>
	</c:if>	
</form>
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>	
<!-- END :: FRAME -->
</body></html>
