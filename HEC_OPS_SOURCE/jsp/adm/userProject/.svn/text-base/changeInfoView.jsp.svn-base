<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<!-- 현재 사용 안함 :: project/changeInfo.jsp 로 이전 -->

<script type="text/javascript">
	function goProcessList(){
		if(confirm("목록으로 이동하시겠습니까?")){
			var url = "projectInfoview.do";
			var data = "s_itemID=${s_itemID}&page=${page}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=${category}";
			var target = "boardFrm";			
			if('${filter}' == 'processNew'){
				url = "ProcessNew.do";
				data = "s_itemID=${s_itemID}&page=${page}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				target = "projectListFrm";
			}
			ajaxPage(url, data, target);			
		}
	}
</script>
<div>
	<form name="boardFrm" id="boardFrm" action="#" method="post" onsubmit="return false;" enctype="multipart/form-data" >
	<div id="boardDiv" class="hidden" style="width:100%;height:400px;">
		<table class="tbl_blue01 mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="9%">
				<col width="16%">
				<col width="9%">
				<col width="16%">
				<col width="9%">
				<col width="16%">
				<col width="9%">
				<col>
			</colgroup>
			<tr>
				<th  class="viewtop">${menu.LN00028}</th>
				<td  class="viewtop alignC">${resultMap.Name}</td>				
				<th  class="viewtop">${menu.LN00016}</th>
				<td  class="viewtop alignC">${resultMap.TypeName}</td>				
				<th  class="viewtop">${menu.LN00022}</th>
				<td class="viewtop alignC">${resultMap.ChgTypeName}</td>
				<th class="viewtop">${menu.LN00023}</th>
				<td class="viewtop alignC">${resultMap.ReasonName}</td>
			</tr>
			<tr>
				<th>${menu.LN00025}</th>
				<td class="alignC">${resultMap.AuthorName}</td>
				<th>${menu.LN00026}</th>
				<td class="alignC">${resultMap.TeamName}</td>
				<th >${menu.LN00027}</th>
				<td class="alignC">${resultMap.StatusName}</td>
				<th>${menu.LN00013}</th>
				<td class="alignC">${resultMap.CreationTime}</td>				
			</tr>
			<tr>
				<th>Path</th>
				<td colspan="3" class="alignL">${resultMap.Path}</td>
				<th >이관</th>
				<td class="alignC">${resultMap.ToOrgName}</td>
				<th>수관</th>
				<td class="alignC">${resultMap.FromOrgName}</td>				
			</tr>
			<tr>
				<th >${menu.LN00019}</th>
				<td colspan="7" class="tit">
			    	<div id='down_file_items'></div>
					<c:if test="${itemFiles.size() > 0}">
						<c:forEach var="result" items="${itemFiles}" varStatus="status" >
							<div id="divDownFile${result.Seq}" class="mm" name="divDownFile${result.Seq}">
								<a href="${root}fileDown.do?seq=${result.Seq}"><img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" style="cursor:pointer;width:13;height:13;padding-right:10px;" alt="파일다운로드" align="absmiddle">${result.FileRealName}</a>
								<br>
							</div>
						</c:forEach>
					</c:if>
					<c:if test="${itemFiles == null || itemFiles.size() == 0}">파일첨부없음</c:if>
				</td>
			</tr>
			<tr>
				<td colspan="8" style="height: 280px; " class="tit">
					<textarea id="Description" name="Description" style="width:98%;height:98%" >${resultMap.Description}</textarea>
				</td>
			</tr>
		</table>
		<div class="alignBTN">
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="goProcessList()"></span>
		</div>
	</div>
	</form>
</div>