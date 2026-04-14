<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<script type="text/javascript">
	var p_gridArea;		
	var screenType = "${screenType}"; //그리드 전역변수
	
	$(document).ready(function(){
	});
	
	function fnGoRefresh() {		

		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		
		var target = "projectDiv";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=0&mainVersion=mainV5";
		var url = "myProjectList.do";
		
		ajaxPage(url, data, target);
	}
	
	function fnGetTemp() {
		
		var UserList = "${userList}";
		var projectList = new Array();
		
		var temp = UserList.split(",");
		var cnt = 0;

		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		
		var intervalID = setInterval(function(){
			
			if(cnt == temp.length) {
				clearInterval(intervalID);

				$('#fileDownLoading').removeClass('file_down_on');
				$('#fileDownLoading').addClass('file_down_off');

				alert("Project Member Update 완료");
			}
			else {
	       		var data = {
	                "p_projectType": 'Project',    // Project, Proposal
	                'p_userID': temp[cnt]     // UserNo
	            }
	       		
	            var sURL = "http://172.22.118.97/Webservice.asmx/ProjectList"; //운영 http://localhost:80/WebService.asmx/ProjectList
	            $.ajax({
	                url: sURL,
	                type: "POST",
	                contentType: "application/json; charset=utf-8",
	                dataType: "json",
	                data: JSON.stringify(data),
	                success: function (msg) {
	                	projectList[cnt] = temp[cnt] + "|" + msg.d;
						
						var url = "/daelim/plant/updateProjectMember.do";
						var data = "userList=" + projectList[cnt];
						var target = "blankFrame";
						ajaxPage(url, data, target);
	                }
	            });
	       		cnt++;
			}
       		
		},500);
		
	}
</script>
</head>

<body>


<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/dhxlayout_progress.gif.gif"/>
</div>
<div id="projectDiv">
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
	<input type="hidden" id="userList" name="userList" value="" />
				
	<div class="floatL msg" style="width:100%"></div>		
	<div class="countList pdT10" style="width:100%;">
	     <li class="floatR">
				<span id="addIcon" class="btn_pack small icon"><span class="add"></span><input value="Regist ECS Project Member" type="submit" onclick="fnGetTemp()"></span>
	     </li>
	</div>		
	</form>
	<!-- END :: PAGING -->
		
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer" ><iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe></div>	
	<!-- END :: FRAME -->	
</div>
</body>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</html>