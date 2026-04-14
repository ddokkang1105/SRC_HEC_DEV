<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Search member</title>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
$(function(){
	$('.sem001').click(function(){
		$('.sem001').css('background-color', '#ffffff');
		$('.sem001').attr('alt', '');
		$(this).css('background-color', '#eafafc');
		$(this).attr('alt', '1');
	}).mouseover(function(){
		$(this).css('background-color', '#eafafc');
	}).mouseout(function(){
		if($(this).attr('alt') != 1) 
			$(this).css('background-color', '#ffffff');
	});;
});

$(window).load(function(){
	$("#searchValue").focus();
	
});

function searchFrom(){
	document.getElementById("processList").action = "searchNamePop.do";
	document.getElementById("processList").submit();
}


function setInfo(avg,avg2){
//	alert(avg+" // "+avg2)
	window.opener.setSearchName(avg,avg2);
	self.close();
}


</script>
<script type="text/javascript">
function btndown(id,loc){
    var obj = document.getElementById(id);
    var orgSrc = obj.src;
    var newSrc = loc;
    
    obj.src = newSrc;
    
    obj.onmouseout = function(){
        obj.src = orgSrc;
    }
}
</script>
</head>

<body>

    <!-- BEGIN :: BOARD_ADMIN_FORM -->
    <form name="processList" id="processList" action="" method="post" onsubmit="return false;">
    <input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
    <div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	        <div class="child_search_head">
	              <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;Search member</p>
	            </div>
            <div class="child_search_form">
		        <div class="child_search mgT5">
		               <li>
		               		<select id="searchKey" name="searchKey">
								<option value="Name">Name</option>
								<option value="ID" 
									<c:if test="${!empty searchID}">selected="selected"
									</c:if>	
								>ID</option>
							</select>
						</li>
		               <li>
		                <input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;"/>
		                <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="searchFrom()" value="검색">
		                </li>
		        </div>
		        <div style="height:240px;overflow:auto; overflow-x:hidden; padding:0;">
			    <ul>
			    	<c:forEach var="i" items="${getList}" varStatus="listStatus">
			    	<li class="mem_list">
					    <div class="box" onclick="setInfo('${i.MemberID}','${i.UserName}')">
						    <span class="thumb">
							    <c:if test="${i.Photo != 'blank_photo.png' }" >
									<img src='<%=GlobalVal.EMP_PHOTO_URL%>${i.Photo}' style="width:40px;height:40px;border-radius: 50px;">
								</c:if>
								<c:if test="${i.Photo == 'blank_photo.png' }" >
									<span lang="ko" class="initial_profile" style="background-color: rgb(134, 164, 212);">
								    	<em>${fn:substring(i.UserName,0,1)}</em>
								    </span>
								</c:if>
							    
						    </span>
						    <span class="address_item_info">
						    <span class="name_info">
							    <span class="name_txt">
							    	<span class="name">${i.UserName}</span><c:if test="${!empty i.NameEN}" >(${i.NameEN })</c:if>
							    </span>
						    </span>
						    <p class="company_info">
							    <span>
								    <strong>${i.Position }</strong>
								    <span>${i.TeamName }</span>
								    <span>${i.CompanyName }</span>
								    <span>${i.Email}</span>
							    </span>
						    </p>
						    </span>
					    </div>
			    	</li>
			    	</c:forEach>
			    </ul>
			   	</div>
        </div>
    </div>
    </form>
</body>
</html>