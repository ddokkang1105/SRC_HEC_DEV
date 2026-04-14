<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>

<script type="text/javascript">
	$(document).ready(function(){
	});
	
	function wordReportOut(){
		var paperSize = fnGetRadioValue("avg1");
		var outputType = $("select[name=avg2]").val();
		var delItemsYN = "";
		var checkObj = document.all("avg3");
		if (checkObj.checked) {delItemsYN = "Y"; } else { delItemsYN = "N"; }
		
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		timer = setTimeout(function() {checkDocDownCom();}, 1000);
		
		$('#paperSize').val(paperSize);
		$('#outputType').val(outputType);
		$('#delItemsYN').val(delItemsYN);
		
		var url = "subItemInfoReportEXE.do";
		ajaxSubmit(document.reportFrm, url, "saveFrame");
	}

	function fnGetRadioValue(radioName) {
		var radioObj = document.all(radioName);
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
	}
</script>

<!-- BIGIN :: ATTR LIST_GRID -->
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>
<form name="reportFrm" id="reportFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${arcCode}"/>
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="url" name="url" value="${url}" />
	<input type="hidden" id="objType" name="objType" value="${objType}" />
	<input type="hidden" id="reportCode" name="reportCode" value="" />
	<input type="hidden" id="delItemsYN" name="delItemsYN" value="" />
	<input type="hidden" id="docDownFlg" name="docDownFlg" value="N" />
	<input type="hidden" id="outputType" name="outputType" value="" />
	
	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<tr>
				<!-- Download Option -->
				<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;Select report Option</th>
			</tr>
		</table>
	</div>
	
	 <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tbl_blue01 alignL mgB10" >
		 <colgroup>
			<col width="30%">
			<col>
		</colgroup>
		<tr>
			<!-- 용지 크기 -->
			<th class=" pdL10">${menu.LN00158}</th>
			<td class="last pdL10">
				<input type="radio" name="avg1" value=1 checked="checked">&nbsp;A4 ( 21.0 cm / 29.7 cm ) &nbsp;&nbsp;
				<input type="radio" name="avg1" value=2>&nbsp;A3 ( 42.0 cm / 29.7 cm )
			</td>
		</tr>
		<tr>
			<th class="pdL10">Output Type</th>
			<td class="last pdL10" style="padding-bottom:3px;">
				<select id="avg2" name="avg2" class="sel" style="width:50%;">
					<option value="doc">doc</option>
					<option value="pdf">pdf</option>
				</select>
			</td>
		</tr>
		<tr>
			<!-- 삭제된 아이템 포함여부 -->
			<th class="pdL10">Include deleted items</th>
			<td class="last pdL10">
				<input type="checkbox" id="avg3" name="avg3" > 
			</td>
		</tr>
	</table>
	
	<div class="alignBTN mgB5">
		<span class="btn_pack medium icon"><span class="Save"></span><input value="Generate" onclick="wordReportOut()" type="submit"></span>
	</div>
	<!-- END :: LIST_GRID -->

	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>	
</form>
