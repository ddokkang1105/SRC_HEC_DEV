<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<script type="text/javascript">
	var menuIndex = "1 2";

	//var url = avg + ".do";
	
	$(function() {
		setpmFrame('modelTypeTab', '', '1');
	});

	function setpmFrame(avg, oj, avg2) {		
		var url = avg + ".do";
		var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&Name=${Name}"
				+ "&s_itemID=${filter}" + "&userType=2" + "&width="
				+ arcFrame.offsetWidth + "&option=${option}"
				+ "&getAuth=${sessionScope.loginInfo.sessionLogintype}"
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
	<form name="WorkFlowList" id="WorkFlowList"
		action="updateAttribute.do" method="post" onsubmit="return false;">

		<div class="SubinfoTabs">
			<ul>
				<li id="pliug1" class="on"><a href="javascript:setpmFrame('modelTypeTab','','1');"><span>Symbol Type</span></a></li>
				<li id="pliug2"><a href="javascript:setpmFrame('modelDisplayTypeTab','','2');"><span>Model Display</span></a></li>
				<!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->								
			</ul>
		</div>
	</form>
</div>
<div id="arcFrame"></div>
