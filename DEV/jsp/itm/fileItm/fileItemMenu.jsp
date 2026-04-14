<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<c:if test="${screenType ne 'model'}"><%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%></c:if>

<script type="text/javascript">
	var s_itemID = '${s_itemID}';
	var menuIndex = "1 2";
	$(document).ready(function(){
		fnViewFileItem();
		$("#plisOM1").click(function() {fnViewFileItem();});
		$("#plisOM2").click(function() {fnFileList();});
	});
	function fnViewFileItem(){ 	
		var url = "viewFileItem.do";
		var data = "s_itemID=${s_itemID}&classCode=${classCode}&itemID=${itemID}"; 
		var target="occDiv";
		var src = url+"?"+data;
		$.ajax({
			url: url,type: 'post',data: data,async: false,error: function(xhr, status, error) {alert(status+"||"+error); }
			,success: function(data){$("#" + target).hide();$("#" + target).html(data);$("#" + target).fadeIn(10);}
		});		
		
		//tab Change
		setSubTab(menuIndex, 1, "plisOM", "selected");
	}
	function setSubTab(menuIdx, avg, tabNm, classNm){var realMenuIndex = menuIdx.split(' '); if(tabNm == null || tabNm == "undefined"){tabNm = "pli";}if(classNm == null || classNm == "undefined"){classNm = "on";}for(var i = 0 ; i < realMenuIndex.length; i++){if(realMenuIndex[i] == avg){$('#'+tabNm+realMenuIndex[i]).addClass(classNm);}else{$('#'+tabNm+realMenuIndex[i]).removeClass(classNm);}}}

	function reload(){
		fnViewFileItem();
	}
	
	function fnFileList() {
		var url = "fileItemHistory.do"; // 관련문서
		var target = "actFrame";
		var data = "s_itemID=${itemID}&itemBlocked=${itemBlocked}&fileOption=${menuDisplayMap.FileOption}";
		
		var target="occDiv";
		var src = url+"?"+data;
		$.ajax({
			url: url,type: 'post',data: data,async: false,error: function(xhr, status, error) {alert(status+"||"+error); }
			,success: function(data){$("#" + target).hide();$("#" + target).html(data);$("#" + target).fadeIn(10);}
		});		
		
		//tab Change
		setSubTab(menuIndex, 2, "plisOM", "selected");
	}
	
</script>
<div class="ddoverlap" style="line-height:1.3em;">
	<ul>
		<li id="plisOM1" class="selected"><a><span>${menu.LN00035}</span> </a></li>
		<li id="plisOM2" ><a><span>History</span></a></li>	
	</ul>
</div>	
<div id="occDiv" name="occDiv" style="width:100%;hegiht:100%;overflow:hidden;line-height:1.3em;font-weight:normal;"></div>
 
