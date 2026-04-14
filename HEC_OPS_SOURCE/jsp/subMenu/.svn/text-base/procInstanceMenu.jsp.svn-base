<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<script type="text/javascript">
	var height = 0;
	$(document).ready(function(){
		var topHeight = 33+$(".SubinfoTabs").height();
		height = document.body.clientHeight - topHeight;
		
		window.onresize = function() {
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
		}
	});
	
	function getHeigth(){
		var topHeight = 33+$(".SubinfoTabs").height();
		var height = document.body.clientHeight - topHeight;
		return height;
	}
	//ajax에서 페이지에 넘길 변수값들 지정
	function getData(avg, avg1, avg2){
		var Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&variantID=${id}"
				+"&s_itemID=${id}"
				//+"&modelID=${id}"
				+"&pop=${pop}"
				+"&width="+$("#actFrame").width()
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&userID=${sessionScope.loginInfo.sessionUserId}"
				+"&option=${option}"
				+"&MenuID="+avg2
				+ avg
				+"&objectType=${objectType}";
		
		// 테이불 TB_MENU_ALLOC 컬럼 Varfilter 내용 추가	
		if(avg1 != ''){
			Data = Data + "&varFilter=" + avg1;		
		}
		
		/* 하위 항목 이나 검색 화면에서 본 화면을 popup으로 표시 했을때 버튼 제어를 위해 screenMode 파라메터를 넘겨줌 */
		var screenMode = "${screenMode}";
		if (screenMode == 'pop') {
			Data = Data + "&screenMode=${screenMode}";		
		}
		return Data;
	}
	
	function setActFrame(avg, avg2, avg3, avg4,avg5){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = avg+".do";

		var data = getData(avg3, avg4,avg5);
		var target = "actFrame";
		var src = url +"?" + data+"&browserType="+browserType+"&focusedItemID=${focusedItemID}";
		var idx = (window.location.href).lastIndexOf('/');
		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
		$("#actFrame").empty();
		if( avg == "newDiagramEditor" || avg == "newDiagramViewer" || avg == "modelView_H"){
			//$("#digramFrame").attr("src", src);
			digramFrame.location.href  = src;
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
			$("#actFrame").attr("style", "display:none;");
		} else if( avg == "variantProjectInfoview" || avg == "variantProjectList"){
			data = data + "&masterProjectID=${masterProjectID}&variantClass=${variantClass}&masterItemID=${masterItemID}&refPGID=${refPGID}&myProject=${myProject}";
			$("#digramFrame").attr("style", "display:none;");
			$("#actFrame").attr("style", "display:block;height:"+height+"px;");
			$("#actFrame").attr("style", "height:"+height+"px;");
			ajaxTabPage(url, data, target);
		}else {
			$("#digramFrame").attr("style", "display:none;");
			$("#actFrame").attr("style", "display:block;height:"+height+"px;");
			$("#actFrame").attr("style", "height:"+height+"px;");
			ajaxTabPage(url, data, target);
		}
	}
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#pli"+SubinfoTabsNum).addClass('on');
		
		$('.SubinfoTabs ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('pli', '') != SubinfoTabsNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
		}).click(function(){
			$(".SubinfoTabs ul li").removeClass("on"); //Remove any "active" class
			$(this).addClass('on');
			SubinfoTabsNum = $(this).attr('id').replace('pli', '');
		});
	});
	
	// 담당자 정보 표시
	function fnGetAuthorInfo(memberID){
		var url = "authorInfoPop.do?memberID="+memberID;		
		window.open(url,'window','width=302, height=235, left=800, top=300,scrollbar=yes,resizble=0');
		
	}
	
	function fnGetProjectItemID() {
		var p_itemID =  "${id}";
		
		return p_itemID;
	}
	
	
</script>
<input type="hidden" id="clickedURL" style="width:800px"></input>
<div class="SubinfoTabs">
	<ul>
		<c:if test="${menuText == 'Project' }" >
			<li id="pli1" onclick="setActFrame('variantProjectInfoview', 1 , '', '', '') "><a><span>프로젝트 개요 ${BASE_ATCH_URL }</span></a></li>
			<li id="pli2" onclick="setActFrame('variantProjectList', 2 , '', '', '') "><a><span>Project List ${BASE_ATCH_URL }</span></a></li>
		</c:if>
		<c:if test="${menuText != 'Project' }" >
		<c:set value="1" var="tabNum" />
		<c:forEach var="i" items="${getList}" varStatus="status" >
			<li id="pli${tabNum}" onclick="setActFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
			<c:set var="tabNum" value="${tabNum+1}"/>
		</c:forEach>
		</c:if>
	</ul>
	<c:if test="${baseAtchUrl == 'mando' && roleAssignMemberList.size() > 0 }" >
	<ul class="floatR pdR10 mgB5" id="memberPhotoArea" style="font-family:arial;cursor:pointer;"> 1:1 Contact&nbsp;
		<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
		 <span id="authorInfo${status.index}" name="authorInfo${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetAuthorInfo('${author.MemberID}');"></span>
		</c:forEach>
	</ul>
	</c:if>
</div>

<div class="pdL10 pdR10">
<div id="actFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;" >
</div>
<iframe width="100%" frameborder="0" scrolling="no" style="display:none;border: 0;overflow:auto; padding:0 0 17px 0;" name="digramFrame" id="digramFrame"></iframe>
<form style="border: 0" name="subFrame" id="subFrame"></form>

<c:if test="${menuText == 'Project' }" >
	<li id="pli1" onclick="setActFrame('variantProjectInfoview', 1 , '', '', '') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
	<li id="pli2" onclick="setActFrame('variantProjectList', 2 , '', '', '') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
	<script>
		setActFrame('variantProjectInfoview', 1 , '', '', '');
	</script>	
</c:if>
<c:if test="${menuText != 'Project' }" >
<c:forEach var="i" items="${getList}" varStatus="status" >
	<c:if test="${status.count == '1' }" >
		<script>
		setActFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '<c:out value="${i.VarFilter}" />', '<c:out value="${i.MenuID}" />');
		</script>	
	</c:if>
</c:forEach>
</c:if>
</div>
