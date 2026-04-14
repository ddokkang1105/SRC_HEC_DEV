<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<script type="text/javascript">
	var menuIndex = "1";

	$(document).ready(function() {	
	
	});	
	
	$(function() {
		setpmFrame('SubListOfValue', '', '1');
	});

	function setpmFrame(avg, oj, avg2) {
		var url = avg + ".do";
		var data = "s_itemID=${itemID}" 
				+ "&languageID=${languageID}"
				+ "&DataType=${AttrLoveDataType}"
				+ "&pageNum=${pageNum}";
		var target = "arcFrame";
		
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

</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="AttributeTypeList" id="AttributeTypeList"
		action="admin/updateAttribute.do" method="post" onsubmit="return false;">

		<div class="SubinfoTabs">
			<ul>

				<li id="pliug1" class="on"><a href="javascript:setpmFrame('SubListOfValue','','1');"><span>List Of Value</span></a></li>
				<!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
								
			</ul>
		</div>
	</form>
</div>
<div id="arcFrame"></div>
