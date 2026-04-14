<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %><c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<c:url value="/" var="root"/>

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>

<script type="text/javascript">
$(document).ready(function(){		
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&editable=1&category=MC";
	fnSelect('MTCategory', data, 'getDictionary', 'BAS');
});

function fnReport(){	
	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	timer = setTimeout(function() {checkDocDownCom();}, 4000);
	
	var url = "subItemInfoReportEXE.do";
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
</script>
<form name="reportFrm" id="reportFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="URL" name="URL" value="${url}"/>
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="classCodeList" name="classCodeList" value="${classCodeList}"/>
	<input type="hidden" id="accMode" name="accMode" value="${accMode}"/>
	
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
			<th class="pdL10">Output Type</th>
			<td class="last pdL10" style="padding-bottom:3px;">
				<select id="outputType" name="outputType" class="sel" style="width:50%;">
					<option value="doc" <c:if test="${outputType eq 'doc' }"> selected </c:if> >doc</option>
					<option value="pdf" <c:if test="${outputType eq 'pdf' }"> selected </c:if> >pdf</option>
				</select>
			</td>
		</tr>
	</table>
	
	<div class="alignBTN mgB5">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Generate" onclick="fnReport()" type="submit"></span>
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</form>

</body></html>