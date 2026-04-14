<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script type="text/javascript">
	var changeMenu = "";
	
	jQuery(document).ready(function() {	
		$('.shortIcon').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if ($(this).attr('alt') != changeMenu) {
				$(this).removeClass('on');
			}
		}).click(function(){
			changeMenu = $(this).attr('alt');
			var title = $(this).attr('title');
			if( changeMenu!="") {
				clickMenu(changeMenu, title);
				changeShortIconStyle();
			}
		});
	});
	
	function changeShortIconStyle(menuNm) {
		if(typeof(menuNm) == "undefined"){
		// shortIcon 클릭시 아이콘 배경색 변경처리
		$('.shortIcon').each(function(){
			if($(this).attr('alt') == changeMenu) {
				$(this).addClass('on');
			} else {
				$(this).removeClass('on');
			}
		});}
		else{
			$('.shortIcon').each(function(){				
				if($(this).attr('alt') == menuNm) {
					$(this).addClass('on');
				} else {
					$(this).removeClass('on');
				}
			});}
	}
	
</script>

<div id="shortmenu" class="shortmenu">
	<li class="home shortIcon" alt="HOME" title="Corporate"><img src="${root}${HTML_IMG_DIR}/short_company.png"/><br />Corporate</li>
	<li class="shortIcon" alt="TEAM" title="Team"><img src="${root}${HTML_IMG_DIR}/short_myteam.png"/><br />Team</li>
	<li class="shortIcon" alt="SEARCH" title="Search"><img src="${root}${HTML_IMG_DIR}/short_search.png"/><br />Search</li>
	<li class="shortIcon" alt="AR03000" title="Diagram"><img src="${root}${HTML_IMG_DIR}/short_modeling02.png"/><br />Diagram</li>
	<li class="shortIcon" alt="FORUM" title="Community of Practice"><img src="${root}${HTML_IMG_DIR}/short_communication.png"/><br />CoP</li>
	<li class="shortIcon" alt="ChangeManagement" title="Change Management"><img src="${root}${HTML_IMG_DIR}/short_management.png"/><br />Change<br />Management</li>
	<li class="shortIcon" alt="ANALYSIS" title="Analysis"><img src="${root}${HTML_IMG_DIR}/short_analysis.png"/><br />Analysis</li>
	<!--<li class="shortIcon" alt="AR01700" title="Improvement"><img src="${root}${HTML_IMG_DIR}/short_improve.png"><br />Improvement</li>-->
<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
	<li class="admin shortIcon" alt="ADMIN" title="Admin"><img src="${root}${HTML_IMG_DIR}/short_admin.png"/><br />Admin</li>
</c:if>
	<!-- <li class="shortIcon" alt="popMaster"><img src="${root}${HTML_IMG_DIR}/short_modeling02.png"><br />Modeling</li> -->
</div>
