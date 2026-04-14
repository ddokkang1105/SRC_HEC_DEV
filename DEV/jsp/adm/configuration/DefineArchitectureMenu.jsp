<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript">
	
var menuIndex = "1 2 3 4 5 6";
	
	$(function(){
		setpmFrame('architectureView','','5');
	});
	
	function setpmFrame(avg,oj, avg2){
		var url = avg+".do";
		var data = "languageID=${languageID}"
				+"&s_itemID=${filter}"
				+"&userType=1"
				+"&option=${option}"
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&pageNum=${pageNum}"
				+"&ArcCode=${ArcCode}&cfgCode=${cfgCode}&viewType=E"; 
		var target="arcFrame";
		
		ajaxPage(url,data,target);
		var realMenuIndex = menuIndex.split(' ');
		
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if(realMenuIndex[i] == avg2){
				$("#pliug"+realMenuIndex[i]).addClass("on");
			}else{
				$("#pliug"+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	var SubinfoTabsNum = 5; /* 처음 선택된 tab메뉴 ID값*/
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
		var url = "DefineArchitecture.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cfgCode=${cfgCode}";
		
		var target = "processListDiv";
		
		ajaxPage(url, data, target);
	}
	
	
	function fnOpenTree(cfgCode){// ParentItem Popup
		parent.olm.menuTree.selectItem(cfgCode,false,false);
		parent.olm.getMenuUrl(cfgCode);
	}
</script>

<div class="title-section flex align-center justify-between">
	<span class="flex align-center" id="cfgPath">
		<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
		<c:forEach var="path" items="${path}" varStatus="status">
			<span>${path.cfgName}&nbsp;>&nbsp;</span><!-- onclick="fnOpenTree('${path.cfgCode}');"  -->
		</c:forEach>
		<span style="font-weight: bold;">${arcName}</span>
	</span>
</div>
<div class="SubinfoTabs">
	<ul>
		<c:choose>
			<c:when test="${type eq 'G' }">
				<li id="pliug5"><a href="javascript:setpmFrame('architectureView','','5');"><span>Basis</span></a></li>
				<li id="pliug6"><a href="javascript:setpmFrame('allocateArchitecture','','6');"><span>Architecture Allocation</span></a></li>
			</c:when>
			<c:otherwise>
				<li id="pliug5"><a href="javascript:setpmFrame('architectureView','','5');"><span>Basis</span></a></li>
				<li id="pliug4"><a href="javascript:setpmFrame('arcMenu','','4');"><span>Menu</span></a></li>
				<li id="pliug1"  class="on"><a href="javascript:setpmFrame('arcFilter','','1');"><span>Filter</span></a></li> <!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
				<li id="pliug2"><a href="javascript:setpmFrame('arcClass','','2');"><span>Class</span></a></li>
				<li id="pliug3"><a href="javascript:setpmFrame('arcDimension','','3');"><span>Dimension</span></a></li>
			</c:otherwise>
		</c:choose>
	</ul>
</div>
<div id="arcFrame"></div>
