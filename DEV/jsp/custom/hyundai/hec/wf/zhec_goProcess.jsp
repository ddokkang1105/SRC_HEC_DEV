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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript">

function saveProcInfo(){	
	
	if(confirm("${CM00001}")){	
				
		var url = "zhec_saveProcWfInfo.do";	
		ajaxSubmitNoAdd(document.procInfoFrm, url);
	}
	
}

function fnCallBack() {
	
	var url = "zhec_WFDocMgt.do?";
	var data = "isPop=Y&changeSetID=${getPJTMap.ChangeSetID}&isMulti=N&wfInstanceID=&wfDocType=CS&ProjectID=${getPJTMap.ProjectID}&isView=N&isProc=N";
			
	var w = 1500;
	var h = 1050; 
	itmInfoPopup(url+data,w,h);
	
}
</script>
</head>
<body>
<form name="procInfoFrm" id="procInfoFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="s_itemID" name="s_itemID"  value="${getPJTMap.ItemID}" />

<div style="margin: 0px auto; padding: 0px; width: 100%; ">
<div style="padding:10px;">
<div style=" text-align: center; padding-top:5px;background-color: #DFE9F7;width: 150px;height: 30px;border-top-right-radius:25px;font-weight: 600;line-height:30px;">기본정보</div>
<div style="padding: 30px; border:2px solid #DFE9F7;">
<table style="width:100%; ;table-layout:fixed;border-collapse:collapse;font-size:12px;font-family:Malgun Gothic;line-height:15pt">
<tr>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
표준유형
</td>
<td rowspan="1" colspan="1" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" >
<c:if test="${getPJTMap.ItemClassCode == 'CL01005'}">
Process
</c:if> 	 
<c:if test="${getPJTMap.ItemClassCode == 'CL01006'}">
Activity
</c:if> 		
</td>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
분류체계
</td>
<td rowspan="1" colspan="1" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;">
${itemPathName}
</td>
</tr>
<tr>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
No.
</td>
<td rowspan="1" colspan="1" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" >
${getPJTMap.Identifier}
</td>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
표준 명
</td>
<td rowspan="1" colspan="1" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;" >
${getPJTMap.ItemName}
</td>
</tr>
<tr>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
주관조직
</td>
<td rowspan="1" colspan="1" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;">
${getPJTMap.TeamName}
</td>
</tr>
<tr>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
제/개정/폐기 사유
</td>
<td rowspan="1" colspan="3" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;">
<textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;"></textarea> 
</td>
</tr>
<tr>
<td rowspan="1" colspan="1" align="center" bgcolor="#f4f4f4" style="width:140px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;" scope="col">
주요 제/개정 사항
</td>
<td rowspan="1" colspan="3" align="left" style="border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;">
<textarea class="edit" id="Reason" name="Reason" style="width:100%;height:40px;"></textarea>
</td>
</tr>
</table>
</div>
</div>
</div>	

<div class="alignR">
	<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveProcInfo()" type="submit"></span>
</div>
</form>

<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>