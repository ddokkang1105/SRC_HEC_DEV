

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
		
		/*
		$('#titleLink_baisic').click(function() {
			document.getElementById("htmlReport").scrollTop = 0;
		});

		$('#titleLink_file').click(function() {
			var moveHeight = document.getElementById("subTitle_file").offsetTop;
			document.getElementById("htmlReport").scrollTop = moveHeight - 90;
		});
		
		$('#titleLink_process').click(function() {
			var moveHeight = document.getElementById("subTitle_process").offsetTop;
			document.getElementById("htmlReport").scrollTop = moveHeight - 90;
		});
		
		$('#titleLink_activity').click(function() {
			var moveHeight = document.getElementById("subTitle_activity").offsetTop;
			document.getElementById("htmlReport").scrollTop = moveHeight - 120;
		});
		
		$('#titleLink_changeset').click(function() {
			var moveHeight = document.getElementById("subTitle_changeset").offsetTop;
			document.getElementById("htmlReport").scrollTop = moveHeight - 90;
		});
		
		$('.icon').click(function(){
			var	changeMenu = $(this).attr('alt');
			
			$('.icon').each(function(){
				if($(this).attr('alt') == changeMenu) {
					$(this).addClass('on');
				} else {
					$(this).removeClass('on');
				}
			});
		});
		
		
		*/
		
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		var classNameArray = strClassName.split(",");
		for (var i = 1; i < classNameArray.length + 1; i++) {
			var subTitleId = "subTitle" + i;
			document.getElementById(subTitleId).innerHTML = classNameArray[i-1];
		}
		
	});
	
	/*
	function setScrollHeight(cnt, linkId, subTitleId) {
		$('#' + linkId).click(function() {
			var moveHeight = document.getElementById(subTitleId).offsetTop;
			document.getElementById("htmlReport").scrollTop = moveHeight - (120 + (cnt * 40));
		});
	}
	*/
	
	function trDbClickEvent(itemId) {
		var url = "newSubMain.do?option=AR010101&languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId;
		var w = 1200;
		var h = 900;
		openPopup(url,w,h,itemId);
	}
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	/* 프린트 버튼 클릭 이벤트 */
	function printDiv() {
		var winTitle = "MPM(Master Process Manager) ::: 프로세스 개요  :::";
		var path = "${root}";
		fnPrintArea('htmlReport', winTitle, path);
	}
	
</script>

<!-- BIGIN :: --> 
<div id="htmltop">
<!-- TODO : 프로세스 개요 타이틀 comment out
	<div id="htmlnavcontainer">
		<ul id="htmlnavlist">
			<li class="on icon" alt="basic"><span id="titleLink_baisic">${menu.LN00005}</span></li>
			<li class="icon" alt="process"><span id="titleLink_process">프로세스 모델</span></li>
			<li class="icon" alt="activity"><span id="titleLink_activity">Activity List</span></li>
			
			<c:if test="${0 != itemFileList.size()}">
				<li class="icon" alt="file"><span id="titleLink_file">첨부파일</span></li>
			</c:if>
			
			<c:set value="1" var="link_size" />
			<c:forEach var="allList" items="${pertinentDetailListList}" varStatus="status">
				<li class="icon" alt="connect${link_size}"><span id="titleLink${link_size}"></span></li>
			<c:set var="link_size" value="${link_size+1}"/>	
			</c:forEach>
            
            <c:if test="${0 != changeSetInfoList.size()}">
            <li class="icon" alt="changeset"><span id="titleLink_changeset">변경이력</span></li>
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
							<col width="40%">
							
							<col width="10%">
							<col width="15%">
							<col width="10%">
							<col width="15%">
						</colgroup>
						<tr>
							<!-- 명칭 -->
							<th>${menu.LN00028}</th>
							<td>${prcList.ItemName}</td>
							<!-- 경로 -->
							<th>${menu.LN00043}</th>
							<td colspan="3" class="tdLast">${prcList.Path}</td>	
						</tr>
						<tr>
							<!-- 코드 -->
							<th>${menu.LN00015}</th>
							<td>${prcList.Identifier}</td>
							<!-- 등록일 -->
							<th>${menu.LN00013}</th>
							<td>${prcList.CreateDT}</td>
							<th>최종변경일</th>
							<td class="tdLast">${prcList.LastUpdated}</td>	
						</tr>
						
						<tr>
							<!-- 오너조직 -->
							<th>${attrNameMap.AT00033}</th>
							<td>${attrTextMap.AT00033}</td>
							<!-- 작성자 -->	
							<th>${attrNameMap.AT00024}</th>
							<td>${attrTextMap.AT00024}</td>
							<!-- 검토자 -->
							<th>${attrNameMap.AT00025}</th>
							<td  class="tdLast">${attrTextMap.AT00025}</td>	
						</tr>
						
						<tr>
							<!-- 개요 -->
							<th>${menu.LN00035}</th>
							<td colspan="5" class="tdLast alignL pdL5">${prcList.StringDescription}</td>
						</tr>
						
					</c:forEach>
						
						<!-- 기능정의내용 -->
						<c:if test="${null ne attrTextMap.AT00029}">
						<tr>
							<th>${attrNameMap.AT00029}</th>
							<td colspan="5" class="tdLast alignL pdL5">${attrTextMap.AT00029}</td>
						</tr>
						</c:if>
						
						<!-- 고려사항 -->
						<c:if test="${null ne attrTextMap.AT00027}">
						<tr>
							<th>${attrNameMap.AT00027}</th>
							<td colspan="5" class="tdLast alignL pdL5">${attrTextMap.AT00027}</td>
						</tr>
						</c:if>
						
						<c:if test="${null ne attrTextMap.AT00030 || null ne attrTextMap.AT00023}">
						<tr>
							<!-- 현황 및 문제점 -->
							<th>AS-IS<br>(${attrNameMap.AT00030})</th>
							<td class="alignL pdL5">${attrTextMap.AT00023}</td>
							<!-- 개선사항 -->
							<th>TO-BE<br>(${attrNameMap.AT00023})</th>
							<td colspan="3" class="tdLast alignL pdL5">${attrTextMap.AT00030}</td>	
						</tr>
						</c:if>
						
						
						
						
						
				</table>
			</div>
			<!--  //end 기본정보 -->
			
			<!-- 첨부파일 -->
			<!-- 
			<c:if test="${0 != itemFileList.size()}">
			<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_file">&nbsp;${menu.LN00019}</p>
				<table border="0" cellpadding="0" cellspacing="0" class="tbl_blue">
					<colgroup>
						<col width="10%">
						<col>
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>No</th>
						<th>파일명</th>
						<th>등록일</th>
						<th class="last">등록자</th>
					</tr>
					<c:forEach var="itemFileList" items="${itemFileList}" varStatus="status">
						<tr>
							<td>${itemFileList.RNUM}</td>
							<td>${itemFileList.FileRealName}</td>
							<td>${itemFileList.RegDate}</td>
							<td class="tdLast">${itemFileList.RegMemberName}</td>
						</tr>
					</c:forEach>
				</table>
			</c:if>
			 -->
			<!-- // end 첨부파일 -->
			
			<!-- 프로세스 모델 -->
			<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_process">&nbsp;프로세스 모델</p>
				<table border="0" cellpadding="0" cellspacing="0" class="tbl_blue">
					<colgroup>
						<col width="12%">
						<col width="20%">
						<col>
						<col width="10%">
					</colgroup>
					<tr>
						<th>${menu.LN00015}</th>
						<th>${menu.LN00028}</th>
						<th>${menu.LN00035}</th>
						<th class="last">최종변경일</th>
					</tr>
					<c:forEach var="result" items="${subModelList}" varStatus="status">
						<tr onclick="trDbClickEvent(${result.ItemID});">
							<td class="bar">${result.Identifier}</td>
							<td>${result.ItemName}</td>
							<td class="alignL pdL5">${result.ProcessInfo}</td>
							<td class="tdLast">${result.LastUpdated}</td>
						</tr>
					</c:forEach>
					<!--  
					<tr>
						<td class="hr1" height="1" colspan="4">&nbsp;</td>
					</tr>
					 -->
				</table>
			<!-- // end 서브 프로세스 -->
			
			
			<!--Activity List  -->
			<!-- 
			<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_activity">&nbsp;Activity List</p>
				<table border="0" cellpadding="0" cellspacing="0" class="tbl_blue">
					<colgroup>
						<col width="10%">
						<col width="20%">
						<col>
						<col width="10%">
					</colgroup>
					<tr>
						<th>${menu.LN00015}</th>
						<th>${menu.LN00028}</th>
						<th>${menu.LN00035}</th>
						<th class="last">트랜잭션</th>
					</tr>
					<c:forEach var="activityList" items="${activityList}" varStatus="status">
						<c:forEach var="result" items="${activityList}" varStatus="status">
							<tr  ondblclick="trDbClickEvent(${result.ItemID});" >
								<td class="bar">${result.ItemID}</td>
								<td>${result.ItemName}</td>
								<td class="alignL pdL5">${result.ProcessInfo}</td>
								<td class="tdLast">${result.PlainText}</td>
							</tr>
						</c:forEach>
					</c:forEach>
				</table>
				-->
			<!-- // end Activity List -->
			
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
			
			<!-- 변경이력 -->
			<!-- 
			<c:if test="${0 != changeSetInfoList.size()}">
			<p class="msg mgT10"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_changeset">&nbsp;변경이력</p>
				<table border="0" cellpadding="0" cellspacing="0" class="tbl_blue">
					<colgroup>
						<col width="10%">
						<col>
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>No</th>
						<th>변경내역</th>
						<th>변경일</th>
						<th class="last">변경자</th>
					</tr>
					<c:forEach var="changeSetInfoList" items="${changeSetInfoList}" varStatus="status">
						<tr>
							<td>${changeSetInfoList.RNUM}</td>
							<td>${changeSetInfoList.Description}</td>
							<td>${changeSetInfoList.RegDate}</td>
							<td class=tdLast>${changeSetInfoList.AuthorName}</td>
						</tr>
					</c:forEach>
				</table>
			</c:if>
			-->
			<!-- // end 변경이력 -->
</div>
