<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<script type="text/javascript">
	var menuIndex = "1 2 3";

	$(function(){
		setpmFrame('SubAttributeTypeAllocation','','1');
	});
	
	function setpmFrame(avg, oj, avg2) {
		var url = avg+".do";
		var data = "s_itemID=${filter}"
				+"&ItemTypeCode=${ItemTypeCode}"
				+"&CategoryCode=${CategoryCode}"
				+"&ClassName=${ClassName}"
				+"&languageID=${languageID}"
				+"&pageNum=${pageNum}"
				+"&classCode=${filter}";

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
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
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
	<form name="ClassTypeList" id="ClassTypeList" action="#" method="post" onsubmit="return false;">

		<div class="SubinfoTabs">
			<ul>
				<li id="pliug1" class="on"><a href="javascript:setpmFrame('SubAttributeTypeAllocation','','1');"><span>AttributeType</span></a></li> <!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
				<li id="pliug2"><a href="javascript:setpmFrame('SubReportAllocation','','2');"><span>ReportType</span></a></li>
				<li id="pliug3"><a href="javascript:setpmFrame('SubFile','','3');"><span>File</span></a></li>
				<!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
								
			</ul>
		</div>
	</form>
</div>
<div id="arcFrame"></div>
