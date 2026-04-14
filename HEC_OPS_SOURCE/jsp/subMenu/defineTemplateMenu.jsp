<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<script type="text/javascript">
var menuIndex = "1 2 3";
	
	$(function(){
		setpmFrame('subArchitectureMenu','','1');
	});

	function setpmFrame(avg, oj, avg2) {

		var url = avg + ".do";
		var data = "languageID=${languageID}"
						+"&s_itemID=${filter}"
						+"&userType=1"
						+"&width="+arcFrame.offsetWidth
						+"&option=${option}"
						+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
						+"&pageNum=${pageNum}"
						+"&templCode=${templCode}"
						+"&projectID=${projectID}"
						+"&viewType=${viewType}"; 
		var target="arcFrame";
		
		ajaxPage(url, data, target);
	
		var realMenuIndex = menuIndex.split(' ');

		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg2) {
				$("#pliug" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliug" + realMenuIndex[i]).removeClass("on");
			}
		}

	}
	
	var SubinfoTabsNum = 1;  /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$('.SubinfoTabs ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('pliug', '') != SubinfoTabsNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
		}).click(function(){
			SubinfoTabsNum = $(this).attr('id').replace('pliug', '');
		});
	});

</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="AttributeTypeList" id="AttributeTypeList" action="updateAttribute.do" method="post" onsubmit="return false;">
		<div class="SubinfoTabs">
			<ul>
				<li id="pliug1"><a href="javascript:setpmFrame('subArchitectureMenu','','1');"><span>Architecture</span></a></li> <!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
				<li id="pliug2"><a href="javascript:setpmFrame('subBoardMgtAlloc','','2');"><span>Board</span></a></li>
				<li id="pliug3"><a href="javascript:setpmFrame('reportAlloc','','3');"><span>Report</span></a></li>				
			</ul>
		</div>
	</form>
</div>
<div id="arcFrame"></div>
