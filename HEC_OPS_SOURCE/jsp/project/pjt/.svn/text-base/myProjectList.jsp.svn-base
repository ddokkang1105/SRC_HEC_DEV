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
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};
		gridClassInit();
		doSearchClassList();
	});
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function gridClassInit(){
		var d = setGridClassData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
	//	fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnClassRowSelect(id,ind);});
		p_gridArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridClassData(){
		var result = new Object();
		var loginUserId = "${sessionScope.loginInfo.sessionUserId}";
		var loginUserAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var mainVersion = "${mainVersion}";
		
		result.title = "${title}";
		result.key = "project_SQL.getSetProjectList";
		result.header = "${menu.LN00024},Project Code,${menu.LN00028},${menu.LN00035},${menu.LN00277},${menu.LN00014},${menu.LN00004},${menu.LN00063},${menu.LN00062},${menu.LN00027},,";
		result.cols = "ProjectCode|ProjectName|Description|ProjectGRName|CompanyName|CreatorName|StartDate|DueDate|StatusName|ProjectID|ChildCount";
		result.widths = "30,100,170,*,160,100,80,80,80,50,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,center,center,center,center,center,center,center,center";
		result.data = "filter=${filter}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=${screenType}&refID=${refID}";
					+ "&pageNum=" + $("#currPage").val();
					
					

		var mbrType = $(":input:radio[name=mbrTypeList]:checked").val();

		if(mbrType != '' && mbrType != null && mbrType == "all") {
			result.data = result.data + "&memberId=" + loginUserId;
		}
		else if(mbrType != '' && mbrType != null && mbrType == "manager") {
			result.data = result.data + "&authorID=" + loginUserId;
		}
		else if(mbrType != '' && mbrType != null && mbrType == "worker") {
			result.data = result.data  + "&loginUserId=" + loginUserId;
		}
		
		if($("#Status").val() != '' & $("#Status").val() != null){
			result.data = result.data +"&Status="+ $("#Status").val();
		}		
		
		// 프로젝트 그룹
		if($("#ProjectGroup").val() != '' & $("#ProjectGroup").val() != null){
			result.data = result.data +"&ProjectGroup=" + $("#ProjectGroup").val();
		}		
		
		return result;
	}
	function gridOnClassRowSelect(id, ind){
		if(ind != '1'){
			//goInfoView(p_gridArea.cells(id,9).getValue(), p_gridArea.cells(id,2).getValue());
			goInfoView(p_gridArea.cells(id,10).getValue());
		}
	}
	function doSearchClassList(){		
		var d = setGridClassData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false);
	}
	
	function goInfoView(avg1){
		var target = "projectDiv";
		var url = "";
		url = "viewProjectInfo.do";
		data = "isNew=N&s_itemID=" +avg1+ "&pjtMode=R&refID=${refID}&screenType=${screenType}";
		ajaxPage(url, data, target);
	}
		
	function addPjt(){
		var url = "registerProject.do"; // 프로젝트 생성
		var target = "projectDiv";
		var data = "pjtMode=N&s_itemID=${refID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=${screenType}&refID=${refID}&isNew=Y";
		
		ajaxPage(url, data, target);
	}
	
	function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
	function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
	
	function fnGoRefresh() {
		var target = "projectDiv";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=0&mainVersion=mainV5";
		var url = "myProjectList.do";
		
		ajaxPage(url, data, target);
	}
	
</script>
</head>

<body>
<div id="projectDiv">
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="saveType" name="saveType" value="New">		
		<input type="hidden" id="AuthorID" name="AuthorID">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
		<input type="hidden" id="userList" name="userList" value="" />
				
	<h3 class="floatL mgB10 mgT12" style="width:100%">
	<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00052}
	</h3>		
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="8%">
	    <col width="17%">
	 	<col width="8%">
	    <col width="17%">
	 	<col width="8%">
	    <col width="17%">
	    <col width="8%">
	    <col width="17%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 그룹 -->
       	<th class="alignL pdL10">${menu.LN00277}</th>       	
       	 <td class="alignL pdL10"> 
        		<select id="ProjectGroup" Name="ProjectGroup" style="width:60%">
        			<c:if test="${refPGID eq ''}">
		            <option value=''>Select</option>
		            </c:if>
        	    	<c:forEach var="i" items="${pgList}">
		            	<option value="${i.CODE}" <c:if test="${i.CODE eq refPGID}">Selected="Selected"</c:if> >${i.NAME}</option>
		            </c:forEach>
		       	</select> 
	       	</td>
		     <!-- 상태 -->
		      <th class="alignL pdL10">${menu.LN00027}</th>
		     <td class="alignL pdL10">    
		        <select id="Status" Name="Status" style="width:40%">
		            <option value=''>Select</option>
		        	<c:forEach var="i" items="${statusList}">
		            	<option value="${i.CODE}" <c:if test="${status eq i.CODE }"> selected="selected"</c:if>>${i.NAME}</option>
		            </c:forEach>
		        </select>
		      </td>
		     <th class="alignL"> <c:if test="${screenType eq 'MYSPACE' }">${menu.LN00149}</c:if></th>
			<td class="alignL pdL10">    
		       <c:if test="${screenType eq 'MYSPACE' }">
	     		<input type="radio" id="mbrTypeList" name="mbrTypeList" value="manager" <c:if test="${mbrType eq 'manager' }"> checked="checked" </c:if>> Manager			
				<input type="radio" id="mbrTypeList" name="mbrTypeList" value="worker"  <c:if test="${mbrType eq 'worker' }"> checked="checked" </c:if>> Worker			
				<input type="radio" id="mbrTypeList" name="mbrTypeList" value="all" > All
				</c:if>
			</td>
			<td class="alignR" colspan=2>
		    	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchClassList()"/>
	       </td>
	</tr>
	
  </table>
  
	<div class="countList pdT10" style="width:100%;">
	     <li class="count">Total <span id="TOT_CNT"></span></li>
	     <li class="floatR">
	         <c:if test="${createPG eq 'Y'}">
	  			<span id="addIcon" class="btn_pack small icon"><span class="add"></span><input value="Create Project" type="submit" onclick="addPjt()"></span>
			</c:if>
	     </li>
	</div>		
	</form>
	
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>	
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular">
			<div id="pagingArea" style="display:inline-block;"></div>
			<div id="recinfoArea" class="floatL pdL10"></div>
		</div>
	</div>
	<!-- END :: PAGING -->
		
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer" ><iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe></div>	
	<!-- END :: FRAME -->	
	</div>
</body>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</html>