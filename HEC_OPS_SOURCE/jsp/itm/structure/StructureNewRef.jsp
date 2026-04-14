<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 2. Script -->
<script type="text/javascript">
 	$(window).load(function(){$("#searchValue").focus();});
	$(document).ready(function() {
	});	
	//===============================================================================
	//조회
	function popupClose(){
		doPPSearchList();
	}
	
	function processNewRef(){
		
	}
</script>
	<form name="plgFrm" id="plgFrm" action="" method="post" onsubmit="return false;"></form>

<div class="popup01">
<ul>
  <li class="top_zone popup_title"><img src="${root}${HTML_IMG_DIR}/popup_box2.png" /></li>
  <li class="con_zone"><!-- 세로사이즈 바뀝니다 100,200,300,400 -->
	<div class="title mgT30 mgL45 popup_title"> 조회</div>
	<div class="szone">
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="con01 mgL35">
     		<div class="searchtable04">
       			<ul>
         		<li class="stop01"></li>
         		<li class="scenter01">
           			<table class="table05" cellpadding="0" cellspacing="0" border="0" width="100%">
		            	<colgroup>
		            		<col width="70">
		            		<col width="100">
		            		<col width="70">
		            		<col>
		            		<col width="100">
		            	</colgroup>
		            	<tr>
		               		<td>${menu.LN00021}</td>
		               		<td>${menu.LN00016}</td>
		               		<td></td>
		               		<td></td>
		               	</tr>
		               	<tr>
							<td>
								<input type="text" id="searchValue" name="searchValue" value="${searchValue}" style="width:300px">
							</td>
							<td>
								<input type="text" id="searchValue" name="searchValue" value="${searchValue}" style="width:300px">
							</td>
							<td>
								<input type="text" id="searchValue" name="searchValue" value="${searchValue}" style="width:300px">
							</td>											
							<td>
								<input type="text" id="searchValue" name="searchValue" value="${searchValue}" style="width:300px">
								<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="processNewRef()" ></span>
							</td>
		             	</tr>
           			</table>
           		</li>
         		<li class="sbottom01"></li>
       			</ul>
     		</div>
  		</div>
	</div>
	<!-- BEGIN::CONTENT_CONTAINER -->
	</li>
	<!-- END::CONTENT-->
	<li class="con_rizone"></li><!-- 세로사이트 바뀝니다 100,200,300,400 -->
	</ul>
</div>

<div class="bot_zone">
	<img src="${root}${HTML_IMG_DIR}/popup_box6.png">
</div>
<!-- END::POPUP BOX-->
<!--BEGIN::Close-->
<div class="close" onclick="popupClose();">
	<img class="popup_closeBtn" id="popup_close_btn" 
	src='${root}${HTML_IMG_DIR}/btn_close.png' title="close" onmouseover='this.src="${root}${HTML_IMG_DIR}/btn_closeo.png"' onmouseout='this.src="${root}${HTML_IMG_DIR}/btn_close.png"'>
</div>
<!--END::Close-->
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>