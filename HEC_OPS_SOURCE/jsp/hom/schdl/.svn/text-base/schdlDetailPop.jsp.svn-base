<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script>	
jQuery(document).ready(function() {	
	$('#popup_close_btn').click(function(){clickClosePop();});
});

function clickClosePop(){self.close();}


</script>
<div class="popup01">
	<ul>
<%-- 		<li class="top_zone popup_title"><img src="${root}${HTML_IMG_DIR}/popup_box2_.png" /></li> --%>
		<li class="con_zone">
			<div class="title popup_title"><span class="pdL10">${menu.LN00090}</span>
				<div class="floatR mgR10">
					<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
				</div>
			</div>
			<div class="szone">
  				<div class="con01">
					<table class="tbl_brd" style="table-layout:fixed;width:668px;" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="15%">
							<col width="35%">
							<col width="15%">
							<col width="35%">
						</colgroup>		
						<tr>
							<th>${menu.LN00002}</th>
							<td  class="tit last" colspan="3">
								${resultMap.Subject}
							</td>
						</tr>
						<tr>
							<th>${menu.LN00336}</th>
							<td  class="tit last" colspan="3">
								<div style="overflow-y:scroll; height:70px; width:100%">
								<%-- <c:out value="${resultMap.Content}" escapeXml="false" /> --%>
								<pre><c:out value="${resultMap.Content}"/></pre>
								</div>
							</td>
						</tr>
						<tr>
							<th>${menu.LN00237}</th>
							<td  class="tit last" colspan="3">
								${resultMap.Location}
							</td>
						</tr>
						<tr>
							<th>${menu.LN00324}</th>
							<td  class="tit">
								<font> 
									${resultMap.start_date}
								</font>
								${resultMap.startTime}
							</td>
							<th>${menu.LN00325}</th>
							<td class="tit last" align="left">
								<font> 
									${resultMap.end_date}
								</font>
								${resultMap.endTime}
							</td>
						</tr>
						<tr>
							<th>${menu.LN00337}</th>
							<td  class="tit">
								<c:choose>
									<c:when test="${resultMap.disclScope eq 'PUB'}">전체</c:when>
									<c:when test="${resultMap.disclScope eq 'SHR'}">공유자</c:when>
									<c:when test="${resultMap.disclScope eq 'PJT'}">프로젝트 / ${resultMap.ProjectName}</c:when>
								</c:choose>
							</td>
							<th>
								${menu.LN00334}
							</th>
							<td class="tit last" align="left" >
								<c:choose>
									<c:when test = "${resultMap.alarmOption == 30}">
										30 minutes
									</c:when>
									<c:when test = "${resultMap.alarmOption == 60}">
										1 hour
									</c:when>
									<c:otherwise>
										N/A
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr id="share">
							<th>
								<a onclick="addSharer();">${menu.LN00245}</a>
							</th>
							<td  class="tit">
								${resultMap.sharerNames}
							</td>
							<th>${menu.LN00091}</th>
							<td  class="tit last">		
								${resultMap.docCategoryName}
								<c:if test="${!empty(resultMap.docNO)}">
									 / 
									<c:choose>							 
										<c:when test="${resultMap.docCategory eq 'SR'}">
											<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnSRDetail();">
										</c:when>
										<c:when test="${resultMap.docCategory eq 'CSR'}">
											<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnOpenCsrDetail();">
										</c:when>
										<c:when test="${resultMap.docCategory eq 'PJT'}">
											<span style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;" onclick="fnPJTDetail();">
										</c:when>
									</c:choose>
									 ${resultMap.docNO}</span>
								</c:if>
							</td>
						</tr>
						<tr>
							<th  class="sline">${menu.LN00078} <c:if test="${!empty(resultMap.ModDT)}"> / ${menu.LN00070}</c:if></th>
							<td class="tit last" id="TD_REG_DT">
								${resultMap.RegDT} <c:if test="${!empty(resultMap.ModDT)}"> / ${resultMap.ModDT}</c:if> 
							</td>
							<th  class="sline">${menu.LN00212}</th>
							<td id="TD_WRITE_USER_NM" class="tit last">
								${resultMap.WriteUserNM}
							</td>
						</tr>
						<tr>
						<!-- 첨부문서 -->
							<th style="height:53px;">${menu.LN00111}</th>
							<td colspan="3" style="height:53px;" class="alignL pdL5 last">
								<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
								<div id="tmp_file_items" name="tmp_file_items"></div>
								<c:forEach var="fileList" items="${schdlFiles}" varStatus="status">
								<div id="divDownFile${fileList.Seq}"  class="mm"  name="divDownFile${fileList.Seq}">
									<span style="">${fileList.FileRealName}</span>				
								</div>
								</c:forEach>
								</div>
							</td>
						</tr>
					</table>
  				</div>
			</div>
		</li>	
		
	</ul>
</div>