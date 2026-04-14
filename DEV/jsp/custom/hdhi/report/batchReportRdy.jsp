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
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&editable=1&category=MC";
		fnSelect('avg5', data, 'getDictionary', 'BAS');
		
		$("#tabMenu").css("display", "none");
	});
	
	function wordReportOut(){
		if($("#modelExist").val() != 0){
			var onlyMap = "";
			if ($("input:checkbox[id='avg4']").is(":checked") == true) {onlyMap = "Y";} else {onlyMap = "N";}
			var MTCategory = $("#avg5").val();
			var element = "";
			if ($("input:checkbox[id='avg6']").is(":checked") == true) {element = "Y";} else {element = "N";}
			
			$('#onlyMap').val(onlyMap);
			$('#MTCategory').val(MTCategory);
			$('#element').val(element);
		}
		
		var paperSize = fnGetRadioValue("avg1");
		var outputType = $("select[name=avg2]").val();
		var delItemsYN = "";
		var checkObj = document.all("avg3");
		if (checkObj.checked) {delItemsYN = "Y"; } else { delItemsYN = "N"; }
		
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		timer = setTimeout(function() {checkDocDownCom();}, 4000);
		
				
		$('#paperSize').val(paperSize);
		$('#outputType').val(outputType);
		$('#delItemsYN').val(delItemsYN);
		
		var url = "custom/zhdhi_itemDocReport.do";
		ajaxSubmitNoAdd(document.reportFrm, url, "saveFrame");
	}

	function fnGetRadioValue(radioName) {
		var radioObj = document.all(radioName);
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
	}
	
	function checkOnlyMap(){
		var checkboxes = document.querySelectorAll('.contentsOption input[type=checkbox]');
		if($('input:checkbox[id="avg4"]').is(":checked") == true){
	    	$("#avg3").attr("disabled",true);
	    	$("#avg6").attr("disabled",true);
	    	for(var checkbox of checkboxes) {
				checkbox.disabled = true;
			}
	    	
	    } else {
    		$("#avg3").attr("disabled",false);
    		$("#avg6").attr("disabled",false);
    		for(var checkbox of checkboxes) {
    			checkbox.disabled = false;
			}
	    }
	}
	
	function checkAll() {
		var isChecked = all.checked;
		var checkboxes = document.querySelectorAll('.contentsOption input[type=checkbox]');
		
		if(isChecked == true){
			for(var checkbox of checkboxes) {
				checkbox.checked = true;
			}
		} else {
			for(var checkbox of checkboxes) {
				checkbox.checked = false;
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
	<input type="hidden" id="onlyMap" name="onlyMap"  value="N" />
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="exportUrl" name="exportUrl" value="${url}" />
	<input type="hidden" id="objType" name="objType" value="${objType}" />
	<input type="hidden" id="reportCode" name="reportCode" value="" />
	<input type="hidden" id="delItemsYN" name="delItemsYN" value="" />
	<input type="hidden" id="MTCategory" name="MTCategory" value="" />
	<input type="hidden" id="docDownFlg" name="docDownFlg" value="N" />
	<input type="hidden" id="outputType" name="outputType" value="" />
	<input type="hidden" id="element" name="element" value="" />
	<input type="hidden" id="modelExist" name="modelExist" value="${modelExist }" />
	<input type="hidden" id="classCode" name="classCode" value="${classCode }" />
	<input type="hidden" id="rnrOption" name="rnrOption" value="${rnrOption }" />
	<input type="hidden" id="elmClassList" name="elmClassList" value="${elmClassList }" />
	<input type="hidden" id="accMode" name="accMode" value="${accMode}" />
	<input type="hidden" id="activityMode" name="activityMode" value="${activityMode}" />
	
	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<tr>
				<!-- Download Option -->
				<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;Select BatchJob Report Option</th>
			</tr>
		</table>
	</div>
	
	 <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tbl_blue01 alignL mgB10" >
		 <colgroup>
			<col width="30%">
			<col>
		</colgroup>
		
		<c:if test="${modelExist != 0}">
		<tr hidden="true">
			<!-- 출력 범위 -->
			<th class="pdL10">${menu.LN00157}</th>
			<!-- 프로세스 모델 맵만 -->
			<td class="last  pdL10">
				<input type="checkbox" id="avg4" onclick="checkOnlyMap()" class="mgR5"><label for="avg4" class="mgR15">${menu.LN00156}</label>
			</td>
		</tr>
		</c:if>
		
		<tr hidden="true">
			<!-- 삭제된 아이템 포함여부 -->
			<th class="pdL10">Contents Option</th>
			<td class="last pdL10 contentsOption">
				<input type="checkbox" id="all" name="all" class="mgR5" onclick="checkAll()"><label for="all" class="mgR15">All</label>
				<input type="checkbox" id="subItemYN" name="subItemYN" class="mgR5"><label for="subItemYN" class="mgR15">${menu.LN00006 }</label>
				<input type="checkbox" id="occYN" name="occYN" class="mgR5"><label for="occYN" class="mgR15">${menu.LN00178 } ${menu.LN00011 }</label>
				<input type="checkbox" id="cxnYN" name="cxnYN" class="mgR5"><label for="cxnYN" class="mgR15">${menu.LN00008 }</label>
				<input type="checkbox" id="fileYN" name="fileYN" class="mgR5"><label for="fileYN" class="mgR15">${menu.LN00019 }</label>
				<input type="checkbox" id="teamYN" name="teamYN" class="mgR5"><label for="teamYN" class="mgR15">${menu.LN00036 }</label>
				<input type="checkbox" id="rnrYN" name="rnrYN" class="mgR5"><label for="rnrYN" class="mgR15">${menu.LN00163 }</label>
				<input type="checkbox" id="csYN" name="csYN" class="mgR5"><label for="csYN" class="mgR15">${menu.LN00012 }</label>
			</td>
		</tr>
		
		<c:if test="${modelExist != 0}">
		<tr hidden="true">
			<th class="pdL10">Model Category</th>
			<td class="last pdL10">
				<select id="avg5" name="avg5" class="sel" style="width:50%;"></select>
			</td>
		</tr>
		</c:if>
		
		<tr hidden="true">
			<!-- 삭제된 아이템 포함여부 -->
			<th class="pdL10">Include deleted items</th>
			<td class="last pdL10">
				<input type="checkbox" id="avg3" name="avg3" > 
			</td>
		</tr>
		
		<c:if test="${modelExist != 0}">
		<tr hidden="true">
			<!-- 액티비티 리스트에 모델 엘리먼트 포함여부 -->
			<th class="pdL10">Include element</th>
			<td class="last pdL10">
				<input type="checkbox" id="avg6" name="avg6" > 
			</td>
		</tr>
		</c:if>
		
	</table>
	
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
	</table>
	
	
	
	<div class="alignBTN mgB5">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Generate" onclick="wordReportOut()" type="submit"></span>
	</div>
	<!-- END :: LIST_GRID -->

	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>	
</form>