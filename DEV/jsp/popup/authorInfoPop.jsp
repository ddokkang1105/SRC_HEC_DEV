<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<!-- 2. Script -->
<script type="text/javascript">

	

</script>	
	
<div style="width:300px;height:235px;overflow-x:hidden;overflow-y:hidden;position:absolute;margin:0 auto;border:1px gray solid;background-color:white;">
	<div>
		<div class="child_search_head_blue" style="border:0px;">
			<li class="floatL"><p>Employee information</p></li>
		</div>	 
		<table class="tbl_blue01 mgT5" style="width:100%;height:99%;table-layout:fixed;border:0px;cellpadding:0px;cellspacing:0px;">
			<colgroup>
				<col width="30%">
				<col width="70%">	
			</colgroup>		
			<tr>
				<td style="border:0px;" >
					<c:if test="${authorInfoMap.Photo == 'blank_photo.png' }" >
						<img src='<%=GlobalVal.HTML_IMG_DIR%>${authorInfoMap.Photo}' style="width:80px;height:100px;">
					</c:if>
					<c:if test="${authorInfoMap.Photo != 'blank_photo.png' }" >
						<img src='<%=GlobalVal.EMP_PHOTO_URL%>${authorInfoMap.Photo}' style="width:80px;height:100px;">
					</c:if>
				</td>
				<td class="alignL last pdl10" style="border:0px;"><span style="font-weight:bold;font-size:12px;">${authorInfoMap.MemberName}</span>
				  &nbsp;(${authorInfoMap.EmployeeNum})<br>${authorInfoMap.UserNameEN}<br>${authorInfoMap.OwnerTeamName}  
				   <c:if test="${authorInfoMap.City != '' }" >
							(${authorInfoMap.City})
					</c:if></td>
			</tr>				
	    	<tr>
	 		   	<td colspan="2"  style="border-bottom:2px solid #ddd;border-top:0px;"></td>
	    	</tr>
	    
			<tr>
				<td class="alignL pdl10" style="border:0px;font-weight:bold;">${menu.LN00104}</td>
				<td class="alignL pdl10" style="border:0px;">${authorInfoMap.TeamName}</td>
			</tr>
			<tr>
				<td class="alignL pdl10" style="border:0px;font-weight:bold;">E-mail</td>
				<td class="alignL pdl10" style="border:0px;">${authorInfoMap.Email}</td>
			</tr>
			<tr>
				<td class="alignL pdl10" style="border:0px;font-weight:bold;">Tel</td>
				<td class="alignL pdl10" style="border:0px;">${authorInfoMap.TelNum}</td>
			</tr>
			<tr>
				<td class="alignL pdl10" style="border:0px;font-weight:bold;">Mobile</td>
				<td class="alignL pdl10" style="border:0px;">${authorInfoMap.MTelNum}</td>
			</tr>
		</table> 
	</div>
</div>
