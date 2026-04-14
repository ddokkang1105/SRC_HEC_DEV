<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript">
	
var menuIndex = "1 2 3 4";
	
	$(function(){
		setpmFrame('arcFilter','','1');
	});
	
	function setpmFrame(avg,oj, avg2){
		var url = avg+".do";
		var data = "languageID=${languageID}"
				+"&s_itemID=${filter}"
				+"&userType=1"
				+"&option=${option}"
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&pageNum=${pageNum}"
				+"&ArcCode=${ArcCode}"; 
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
	
	function fnGoBack(){
		var url = "architectureView.do";
		var data = "&ArcCode=${ArcCode}"
				   +"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"  
				   +"&pageNum=${pageNum}"
				   +"&viewType=${viewType}";	
		var target = "processListDiv";
		ajaxPage(url,data,target);	
	}
	
</script>

<div class="SubinfoTabs">
	<ul>
		<li id="pliug1"  class="on"><a href="javascript:setpmFrame('arcFilter','','1');"><span>Filter</span></a></li> <!-- jsp명, 공백, 탭순서, 3개를 넘긴다. -->
		<li id="pliug2"><a href="javascript:setpmFrame('arcClass','','2');"><span>Class</span></a></li>
		<li id="pliug3"><a href="javascript:setpmFrame('arcDimension','','3');"><span>Dimension</span></a></li>
		<li id="pliug4"><a href="javascript:setpmFrame('arcMenu','','4');"><span>Menu</span></a></li>
	</ul>
</div>
<div id="arcFrame"></div>
