<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<!-- 출력용 Item 정보화면 -->
<!-- 
	@RequestMapping(value="/NewItemInfoMain.do")
	* 기본정보      :: report_SQL.getItemInfo
	     속성            :: report_SQL.itemAttributesInfo
-->
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script type="text/javascript">
	
	$(document).ready(function(){	
		
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		if (strClassName != "") {
			var classNameArray = strClassName.split(",");
			for (var i = 1; i < classNameArray.length + 1; i++) {
				var subTitleId = "subTitle" + i;
				document.getElementById(subTitleId).innerHTML = classNameArray[i-1];
			}
		}
		
		printDivAfter();
		
	});
		
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function printDivAfter() {
		$('#htmlReport').attr('style', 'overflow-y:hidden');
		window.onbeforeprint = beforePrint;
		window.onafterprint = afterPrint;
		window.print();
		window.close();
	}
	
	function beforePrint() {
		boxes = document.body.innerHTML;
		document.body.innerHTML = htmlReport.innerHTML;
	}
	
	function afterPrint() { 
		document.body.innerHTML = boxes;
	}
	
</script>

<!-- BIGIN :: --> 
<div id="htmltop">
</div>

<div class="clear"></div>
<div id="htmlReport">

	<!-- BIGIN :: 기본정보 -->
	<div id="processList">
			<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview mgT10">
				<c:forEach var="prcList" items="${prcList}" varStatus="status">
						<colgroup>
							<col width="11%">
							<col width="14%">
							<col width="11%">
							<col width="14%">
							<col width="11%">
							<col width="14%">
							<col width="11%">
							<col width="14%">
						</colgroup>
						<tr>
							<!-- 코드 -->
							<th class="viewtop">${menu.LN00106}</th>
							<td class="viewtop">${prcList.Identifier}</td>
							<!-- 명칭 -->
							<th class="viewtop">${menu.LN00028}</th>
							<td class="viewtop">${prcList.ItemName}</td>
							<!-- 항목계층 -->
							<th class="viewtop">${menu.LN00016}</th>
							<td class="viewtop">${prcList.ClassName}</td>
							<!-- 등록일 -->
							<th class="viewtop" >${menu.LN00013}</th>
							<td class="tdLast viewtop">${prcList.CreateDT}</td>
						</tr>
						<tr>
							<!-- 관리조직 -->
							<th>${menu.LN00018}</th>
							<td>${prcList.OwnerTeamName}</td>
							<!-- 작성자 -->	
							<th>${menu.LN00004}</th>
							<td>${prcList.Name}</td>
							<!-- 상태 -->	
							<th>${menu.LN00027}</th>
							<td>${prcList.StatusName}</td>
							<th>${menu.LN00070}</th>
							<td class="tdLast">${prcList.LastUpdated}</td>
						</tr>
						<tr>
							<!-- 경로 -->
							<th>${menu.LN00043}</th>
							<td colspan="7" class="tdLast alignL pdL5">${prcList.Path}</td>
						</tr>
						<tr>
						  <td colspan="8" class="hr1">&nbsp;</td>
						 </tr>
					</c:forEach>
				</table>
				<!-- 
		
			</div>
			<!--  //end 기본정보 -->
		
		<!-- BIGIN :: 속성 -->
		<c:if test="${attributesList.size() > 0}">
		<div id="attrList">

			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
				<c:forEach var="attrList" items="${attributesList}" varStatus="status">
						<colgroup>
							<col width="11%">
							<col width="89%">
						</colgroup>
						<tr>
							<th>${attrList.Name}</th>
							<td class="tdLast alignL pdL5">${attrList.PlainText}</td>
						</tr>
					</c:forEach>
				</table>
				
			</div>
		</c:if>
			<!--  //end 속성 -->
			
			
			<!-- 관련항목  -->
			<c:if test="${relItemRowList.size() > 0}">
			<c:set value="1" var="List_size" />
			<c:forEach var="allList" items="${relItemRowList}" varStatus="status">
				<div class="pdL20">
				<table width="98%" border="0" cellpadding="0" cellspacing="0" class="tbl_blue mgT5">
					<colgroup>
						<col width="12%">
						<col width="20%">
						<col>
						<col width="10%">
					</colgroup>
					<tr>
                		<td class="noline" colspan="4">-&nbsp;<span id="subTitle${List_size}"></span></td>
                	</tr>
					<tr>
						<th>${menu.LN00015}</th>
						<th>${menu.LN00016}</th>
						<th>${menu.LN00028}</th>
						<th class="last">${menu.LN00013}</th>
					</tr>
					<c:forEach var="result" items="${allList}" varStatus="status">
						<tr>
							<td>${result.Identifier}</td>
							<td>${result.ClassName}</td>
							<td class="alignL pdL5">${result.ItemName}</td>
							<td class="tdLast">${result.LastUpdated}</td>
						</tr>
					</c:forEach>	
				</table>
				</div>
				<c:set var="List_size" value="${List_size+1}"/>	
			</c:forEach>
			</c:if>
			<!-- // end 관련항목 -->
			
</div>