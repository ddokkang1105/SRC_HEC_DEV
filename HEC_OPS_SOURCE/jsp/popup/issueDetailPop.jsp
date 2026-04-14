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
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10">${menu.LN00226}</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
  		<div class="con01 mgL10">
			<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col>
					<col width="15%">
					<col>
				</colgroup>		
				<tr>
					<th>${menu.LN00002}</th>
					<td class="sline tit last" colspan="3">
						${resultMap.Subject}
					</td>
				</tr>
				<tr>
					<th  class="sline">${menu.LN00004}</th>
					<td id="TD_WRITE_USER_NM">
						${resultMap.RequestorName}
					</td>
					<th  class="sline">${menu.LN00013}</th>
					<td class="tdend last" style="width:25%;" id="TD_REG_DT">
						${resultMap.CreationTime}
					</td>
				</tr>
				<tr>
					<th  class="sline">
						<div>
							${menu.LN00019}
						</div>
					</th>
					<td colspan="3" class="tit last" style="position:relative">
					<!-- 하단 div 높이값으로 간격 수정 -->
							<div class="pdT5"></div>
					<!-- 파일 다운로드 -->
							<div id='down_file_items'></div>
							<c:if test="${itemFiles.size() > 0}">
								<c:forEach var="result" items="${itemFiles}" varStatus="status" >
										<div id="divDownFile${result.Seq}"  class="mm" name="divDownFile${result.Seq}">
											<img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" style="width:13;height:13;padding-right:5px;" alt="파일다운로드" align="absmiddle">
											<span style="cursor:pointer;" onclick="fileNameClick('','','','${result.Seq}','ISSUE');">${result.FileRealName}</span>
											<br>
										</div>
								</c:forEach>
							</c:if>										
							<div id='display_items'></div>
							<input type="hidden" id="items" name="items"/>		
	
					</td>			
				</tr>
				</table>
				<table  width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="4" style="height:250px;" class="tit last">
							<textarea id="Content" name="Content" style="width:100%;height:250px">${resultMap.Content}</textarea>
						</td>
					</tr>
				</table>
  		</div>
	</div>
	</li>	
	</ul>
</div>