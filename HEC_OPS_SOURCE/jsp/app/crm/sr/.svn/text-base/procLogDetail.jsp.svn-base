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
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script type="text/javascript">	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		jQuery("#comment").focus();
	});
	

	
</script>
</head>

<body>
<div style="padding: 0 6px 6px 6px; height:400px; overflow:scroll;overflow-y;overflow-x:hidden;">
<form name="srFrm" id="srFrm" action="" method="post" onsubmit="return false;">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png"></img>&nbsp;${procLogInfo.ActivityName}</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
			<col>
		</colgroup>		
		<tr>
			<!-- 담당자 -->
			<th class="alignL pdL10"> ${menu.LN00004}</th>
			<td class="sline tit last" >${srInfoMap.ReceiptName}</td>
			<!-- 생성일 -->
			 <th class="alignL pdL10"> ${menu.LN00013}</th>
			<td class="sline tit last">${srInfoMap.RegDate}</td>
		</tr>
		<tr>
			<th class="alignL pdL10">Comment</th>
			<td class="sline tit pdR10 last" colspan="3" style="height:120px;">${procLogInfo.Comment}	
			</td>
		</tr>
	</table>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
