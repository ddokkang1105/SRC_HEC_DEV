

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript">
	
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#actFrame").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#actFrame").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		};
		
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		var classNameArray = strClassName.split(",");
		for (var i = 1; i < classNameArray.length + 1; i++) {
			var subTitleId = "subTitle" + i;
			document.getElementById(subTitleId).innerHTML = classNameArray[i-1];
		}
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function trDbClickEvent(itemId) {
		var url = "newSubMain.do?option=AR010101&languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId;
		var w = 1200;
		var h = 900;
		openPopup(url,w,h,itemId);
	}
	
	/* 프린트 버튼 클릭 이벤트 */
	function printDiv() {
		var winTitle = "MPM(Master Process Manager) ::: 프로그램 개요  :::";
		var path = "${root}";
		fnPrintArea('htmlReport', winTitle, path);
	}
	
	
</script>

<!-- BIGIN :: --> 
<div id="htmltop">
	<!-- 
	<div id="htmlnavcontainer">
		<ul id="htmlnavlist">
			<li class="on icon" alt="basic"><span id="titleLink_baisic">${menu.LN00005}</span></li>
			
            <c:if test="${0 != changeSetInfoList.size()}">
            <li class="icon" alt="changeset"><span id="titleLink_changeset">변경이력 / 프로그램 진척</span></li>
            </c:if>
            
            <li class="floatR pdR20" style="border-right: 0px solid #666;">
        		<input type="image" id="print" src="${root}modeling/img/print.png" value="print" onclick="printDiv()"/>
    		</li>
    		
         </ul>
	</div>
	 -->
</div>

<div class="clear"></div>
<div id="htmlReport">

	<!-- BIGIN :: 기본정보 -->
	<div id="processList">
		<p><input type="image" id="print" src="${root}modeling/img/print.png" value="print" onclick="printDiv()" class="floatR" /></p>
		<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${menu.LN00005}</p>
		<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_blue">
			<c:forEach var="prcList" items="${prcList}" varStatus="status">
				<colgroup>
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
				</colgroup>
				<tr>
					<!-- 명칭 -->
					<th>${menu.LN00028}</th>
					<td colspan="3">${prcList.ItemName}</td>
					<!-- 경로 -->
					<th>${menu.LN00043}</th>
					<td colspan="3" class="tdLast">${prcList.Path}</td>	
				</tr>
				<tr>
					<!-- 코드 -->
					<th>${menu.LN00015}</th>
					<td>${prcList.Identifier}</td>
					<!-- Program ID -->
					<th>${attrNameMap.AT00039}</th>
					<td>${attrTextMap.AT00039}</td>
					<!-- 등록일 -->
					<th>${menu.LN00013}</th>
					<td>${prcList.CreateDT}</td>
					<th>최종변경일</th>
					<td class="tdLast">${prcList.LastUpdated}</td>	
				</tr>
				
				<tr>
					<!-- TODO : 법인 -->
					<th>${menu.LN00014}</th>
					<td>${prcList.TeamName}</td>
					<!-- 관리조직 -->
					<th>${menu.LN00018}</th>
					<td>${prcList.OwnerTeamName}</td>
					<!-- TODO : 작성자 -->	
					<th>${menu.LN00004}</th>
					<td>${prcList.Name}</td>
					<!-- 버전 -->	
					<th>${menu.LN00017}</th>
					<td class="tdLast">${prcList.Version}</td>	
				</tr> 
				  
				<tr>
					<!-- 개요 -->
					<th>${menu.LN00035}</th>
					<td colspan="7" class="alignL tdLast pdL5">${prcList.StringDescription}</td>
				</tr>
				
			</c:forEach>
				
			<tr>
				<!-- Process ID -->
				<th>${attrNameMap.AT00061}</th>
				<td colspan="3">${attrTextMap.AT00061}</td>
				<!-- Process 명 -->
				<th>${attrNameMap.AT00062}</th>
				<td colspan="3" class="tdLast">${attrTextMap.AT00062}</td>
			</tr>
			
			<c:if test="${classCode eq 'CL04005'}">
				<tr>
					<!-- CBO Type -->
					<th>${attrNameMap.AT00063}</th>
					<td>${attrTextMap.AT00063}</td>
					<!-- 개발유형 -->	
					<th>${attrNameMap.AT00064}</th>
					<td>${attrTextMap.AT00064}</td>
					<!-- 개발대상SAP -->
					<th>${attrNameMap.AT00065}</th>
					<td>${attrTextMap.AT00065}</td>	
					<!-- 사용기간 -->
					<th>${attrNameMap.AT00066}</th>
					<td class="tdLast">${attrTextMap.AT00066}</td>
				</tr>
				
				<tr>
					<!-- 난이도 -->	
					<th>${attrNameMap.AT00067}</th>
					<td>${attrTextMap.AT00067}</td>
					<!-- 중요도 -->
					<th>${attrNameMap.AT00068}</th>
					<td>${attrTextMap.AT00068}</td>	
					<!-- 우선순위 -->
					<th>${attrNameMap.AT00069}</th>
					<td>${attrTextMap.AT00069}</td>
					<!-- 개발공수 -->	
					<th>${attrNameMap.AT00070}</th>
					<td class="tdLast">${attrTextMap.AT00070}</td>
				</tr>
				
				<tr>
					<!-- T-Code -->
					<th>${attrNameMap.AT00038}</th>
					<td>${attrTextMap.AT00038}</td>
					<!-- 관련 시스템 -->
					<th>${attrNameMap.AT00071}</th>
					<td colspan="2">${attrTextMap.AT00071}</td>
					<!-- 연관 모듈 -->	
					<th>${attrNameMap.AT00072}</th>
					<td colspan="2" class="tdLast">${attrTextMap.AT00072}</td>
				</tr>
			</c:if>
			
			<c:if test="${classCode eq 'CL04006'}">
				<tr>
					<!-- 그룹명 -->
					<th>${attrNameMap.AT00076}</th>
					<td>${attrTextMap.AT00076}</td>
					<!-- 관리주체 -->	
					<th>${attrNameMap.AT00077}</th>
					<td>${attrTextMap.AT00077}</td>
					<!-- 단위시스템 -->
					<th>${attrNameMap.AT00078}</th>
					<td>${attrTextMap.AT00078}</td>	
					<!-- 서브시스템 -->
					<th>${attrNameMap.AT00079}</th>
					<td class="tdLast">${attrTextMap.AT00079}</td>
				</tr>
				
				<tr>
					<!-- CBO ID -->	
					<th>${attrNameMap.AT00080}</th>
					<td>${attrTextMap.AT00080}</td>
					<!-- Variant -->
					<th>${attrNameMap.AT00081}</th>
					<td>${attrTextMap.AT00081}</td>	
					<!-- Gap ID -->
					<th>${attrNameMap.AT00082}</th>
					<td>${attrTextMap.AT00082}</td>
					<!-- In/Out -->	
					<th>${attrNameMap.AT00083}</th>
					<td class="tdLast">${attrTextMap.AT00083}</td>
				</tr>
				
				<tr>
					<!-- OnLine or Batch -->	
					<th>${attrNameMap.AT00084}</th>
					<td>${attrTextMap.AT00084}</td>
					<!-- I/F 주기 -->
					<th>${attrNameMap.AT00085}</th>
					<td>${attrTextMap.AT00085}</td>	
					<!-- ERP -->
					<th>${attrNameMap.AT00086}</th>
					<td>${attrTextMap.AT00086}</td>
					<!-- RFC Destination -->	
					<th>${attrNameMap.AT00087}</th>
					<td class="tdLast">${attrTextMap.AT00087}</td>
				</tr>
				
				<tr>
					<!-- Legacy -->	
					<th>${attrNameMap.AT00088}</th>
					<td>${attrTextMap.AT00088}</td>
					<!-- ERP TYPE -->
					<th>${attrNameMap.AT00089}</th>
					<td>${attrTextMap.AT00089}</td>	
					<!-- M/W Type -->
					<th>${attrNameMap.AT00090}</th>
					<td>${attrTextMap.AT00090}</td>
					<!-- Legacy Type -->	
					<th>${attrNameMap.AT00091}</th>
					<td class="tdLast">${attrTextMap.AT00091}</td>
				</tr>
				
				<tr>
					<!-- ERP담당 -->	
					<th>${attrNameMap.AT00092}</th>
					<td>${attrTextMap.AT00092}</td>
					<!-- M/W담당 -->
					<th>${attrNameMap.AT00093}</th>
					<td>${attrTextMap.AT00093}</td>	
					<!-- Legacy 담당 -->
					<th>${attrNameMap.AT00094}</th>
					<td>${attrTextMap.AT00094}</td>
					<!-- ERP Status -->	
					<th>${attrNameMap.AT00095}</th>
					<td class="tdLast">${attrTextMap.AT00095}</td>
				</tr>
				
				<tr>
					<!-- M/W Status -->	
					<th>${attrNameMap.AT00096}</th>
					<td>${attrTextMap.AT00096}</td>
					<!-- Legacy Status -->
					<th>${attrNameMap.AT00097}</th>
					<td>${attrTextMap.AT00097}</td>	
					<!-- Total Status -->
					<th>${attrNameMap.AT00098}</th>
					<td>${attrTextMap.AT00098}</td>
					<!-- M/W -->
					<th>${attrNameMap.AT00101}</th>
					<td class="tdLast">${attrTextMap.AT00101}</td>
				</tr>
				
				<tr>
					<!-- 통합테스트 시기 -->	
					<th>${attrNameMap.AT00099}</th>
					<td colspan="3">${attrTextMap.AT00099}</td>
					<!-- 고려사항 및 이슈 -->
					<th>${attrNameMap.AT00100}</th>
					<td colspan="3" class="tdLast">${attrTextMap.AT00100}</td>
				</tr>
				
			</c:if>
					
					
		</table>
	</div>
	<!--  //end 기본정보 -->
	
	<!-- 관련항목  -->
	<c:set value="1" var="List_size" />
			<c:forEach var="allList" items="${pertinentDetailListList}" varStatus="status">
				<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;<span id="subTitle${List_size}"></span></p>
				<table border="0" cellpadding="0" cellspacing="0" class="tbl_blue">
					<colgroup>
						<col width="12%">
						<col width="20%">
						<col>
						<col width="10%">
					</colgroup>
					<tr>
						<th>${menu.LN00015}</th>
						<th>${menu.LN00016}</th>
						<th>${menu.LN00028}</th>
						<th class="last">${menu.LN00013}</th>
					</tr>
					<c:forEach var="result" items="${allList}" varStatus="status">
						<tr onclick="trDbClickEvent(${result.s_itemID});">
							<td class="bar">${result.Identifier}</td>
							<td>${result.ClassName}</td>
							<td class="alignL pdL5">${result.ItemName}</td>
							<td class="tdLast">${result.LastUpdated}</td>
						</tr>
					</c:forEach>	
				</table>
				<c:set var="List_size" value="${List_size+1}"/>	
			</c:forEach>
			<!-- // end 관련항목 -->
	
	
		
	<!--  //end 변경이력 -->		
			
			
			
			
</div>
