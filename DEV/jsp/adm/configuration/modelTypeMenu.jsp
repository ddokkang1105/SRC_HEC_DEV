<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true" />

<script type="text/javascript">
	var menuIndex = "1 2 3";

	//var url = avg + ".do";
	
	$(function() {
		setpmFrame('modelTypeView', '', '1');
	});

	function setpmFrame(avg, oj, avg2) {		
		var url = avg + ".do";
		var data = "&ModelTypeCode=${filter}"
				+"&ItemTypeCode=${ItemTypeCode}"
				+ "&Name=${Name}"
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
				+ "&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+ "&DataType=${AttrLoveDataType}"
				+"&cfgCode=${cfgCode}"
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
	
	

	function goBack() {
		var url = "modelType.do";
		var data = "&pageNum=" + $("#currPage").val();
		var target = "modelTypeDiv";
		ajaxPage(url, data, target);
	}
</script>


 <input type="hidden" id="cfgCode" name="cfgCode" value="${cfgCode}">
 <input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
 <div class="title-section flex align-center justify-between">
	<span class="flex align-center" id="cfgPath">
		<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
		<c:forEach var="path" items="${path}" varStatus="status">
			<span>${path.cfgName}&nbsp;>&nbsp;</span><!-- onclick="fnOpenTree('${path.cfgCode}');"  -->
		</c:forEach>
		<span style="font-weight: bold;">${filter}</span>
	</span>
</div>
<div class="SubinfoTabs">
	<ul>
		<li id="pliug1" class="on"><a href="javascript:setpmFrame('modelTypeView','','1');"><span>Basis</span></a></li>
		<li id="pliug2"><a href="javascript:setpmFrame('modelTypeTab','','2');"><span>Symbol Type</span></a></li> <!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
		<li id="pliug3"><a href="javascript:setpmFrame('modelDisplayTypeTab','','3');"><span>Model Display</span></a></li>
	
		<!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
	</ul>
</div>
<div id="arcFrame" style="width:100%;height:100%;"></div>
