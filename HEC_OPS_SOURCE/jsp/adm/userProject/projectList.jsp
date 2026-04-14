<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 관리자 : 사용자/그릅 변경항목 단위 관리  -->
<!-- 
	@RequestMapping(value="/projectList.do")
	* project_SQL.xml - getSetProjectList_gridList
	* Action
	  - Save(Add) :: projectItemCreate.do
	  - View      :: projectInfoview.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>

<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(document).ready(function(){
		
		fnSelect('projectStatus','&Category=sts','dictionyCode','All');
		gridClassInit();
		doSearchClassList(false);		
		//fnSelect('ParentID',data,'projectParentID','All');		
	});
	
	function gridClassInit(){
		var d = setGridClassData('');
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnClassRowSelect(id,ind);});
	}	
	function setGridClassData(avg){
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getSetProjectList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00069},${menu.LN00035},${menu.LN00043},${menu.LN00004},${menu.LN00013},${menu.LN00027},,";
		result.cols = "CHK|ProjectName|Description|Name|CreatorName|CreationTime|StatusName|ProjectID|ChildCount";
//		result.header = "${menu.LN00024},#master_checkbox,Project,${menu.LN00028},Description,${menu.LN00004},${menu.LN00013},${menu.LN00027},,";
//		result.cols = "CHK|Name|ProjectName|Description|CreatorName|CreationTime|StatusName|ProjectID|ChildCount";
		result.widths = "50,50,200,200,300,100,100,50,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,left,center,center,center,center,center";
		result.data = "&filter=${filter}"
					+ "&Category=${Category}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	function gridOnClassRowSelect(id, ind){
		//$("#projNew").removeAttr('style', 'display: none');
		/*
		$("#ProjectID").val(p_gridArea.cells(id, 1).getValue());
		$("#ProjectName").val(p_gridArea.cells(id, 2).getValue());
		$("#teamName").val(p_gridArea.cells(id, 3).getValue());
		$("#AuthorName").val(p_gridArea.cells(id, 4).getValue());
		$("#ownerTeamCode").val(p_gridArea.cells(id, 5).getValue());
		
		$("#CompanyID").val(p_gridArea.cells(id, 6).getValue());
		$("#ownerTeamCode").val(p_gridArea.cells(id, 7).getValue());
		$("#AuthorID").val(p_gridArea.cells(id, 8).getValue());
		$("#ProjectInfo").val(p_gridArea.cells(id, 9).getValue());
		*/
		//$("#newButton").removeAttr('style', 'display: none');

		if(ind == '1'){/*alert(ind+"번째 셀 클릭");*/
		}else if(ind == '4'){/*alert(ind+"번째 셀 클릭");*/
		}else{
			goInfoView(p_gridArea.cells(id,8).getValue());
		}
	}		
	function doSearchClassList(avg){
		var parentID = '';
		if(avg){
			//alert("저장되었습니다.");
			alert("${WM00067}");
			parent.top.fnSearchTreeId('${s_itemID}');
			parentID = $("#parentID").val();
		}
		var d = setGridClassData(parentID);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false);
		this.setPagingHTML($("#totalPage").val(), $("#page").val());
	}
	function goInfoView(avg){
		var url = "projectInfoview.do";
		//var url = "processNewList.do";
		var data = "s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=${category}";
		var target = "projectListFrm";
		ajaxPage(url, data, target);	
	}
	function setSubFrame(avg){
		if(avg == 1){
			/*
			if('${projectType}'==3){
				$("#pagingDiv").attr('style', 'display: none');
				$("#cancleButton").removeAttr('style', 'display: none');
			}else{
			}
			*/
				$("#groupInfoDiv").removeAttr('style', 'display: none');
				$("#ProjectID").val('');
				$("#ProjectName").val('');
				$("#teamName").val('');
				$("#AuthorName").val('');
				$("#ownerTeamCode").val('');
				
				$("#CompanyID").val('');
				$("#ownerTeamCode").val('');
				$("#AuthorID").val('');
				$("#ProjectInfo").val('');
			$("#child_search").attr('style', 'display: none');
			$("#newButton").attr('style', 'display: none');			
//			$("#saveOrg").removeAttr('style', 'display: none');
			$("#projNew").removeAttr('style', 'display: none');			
		}else{
			$("#child_search").removeAttr('style', 'display: none');
			$("#gridDiv").removeAttr('style', 'display: none');
			$("#pagingDiv").removeAttr('style', 'display: none');
			$("#newButton").removeAttr('style', 'display: none');			
			//$("#alignBTN").attr('style', 'display: none');
			$("#cancleButton").attr('style', 'display: none');
			$("#saveOrg").attr('style', 'display: none');
			$("#projNew").attr('style', 'display: none');
		}
	}
	function saveProject() {
		//$("#projectListFrm").attr("action","projectItemCreate.do").submit();
		if($("#ProjectName").val() == ''){
			//alert("명칭을 입력하세요.");
			alert("${WM00034}");
			$("#ProjectName").focus();			
			return;
		}else{
//			alert($("#ProjectType").val());
			var url = "projectItemCreate.do";			
			var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=${category}"
//			            + "&ProjectID="     	+ $("#ProjectID").val()
				        + "&ProjectName="     + $("#ProjectName").val()
//				        + "&TeamID="     	+ $("#ownerTeamCode").val()
//				        + "&CompanyID="     	+ $("#CompanyID").val()
				        + "&AuthorID="     	+ $("#AuthorID").val()
//				        + "&AuthorName="     	+ $("#AuthorName").val()
						+ "&ProjectStatus="     	+ $("#ProjectStatus").val()
				        + "&UserID="     	+ $("#UserID").val()
				        + "&ProjectInfo="     	+ $("#description").val()
				        + "&ProjectType="     	+ $("#ProjectType").val();
			var target = "blankFrame";
			
			ajaxPage(url, data, target);
			$("#groupInfoDiv").attr('style', 'display: none');
			//setTimeout(doSearchClassList(true),2000); 
		}
	}	
/*
 * 
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	function setSearchName(memberID,memberName){
		$('#AuthorID').val(memberID);
		$('#AuthorName').val(memberName);
	}
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}
 */	
</script>
</head>

<body>
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />
		<input type="hidden" id="ProjectID" name="ProjectID" />
		<input type="hidden" id="ProjectType" name="ProjectType" value="${filter}">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
		<input type="hidden" id="category" name="category" value="${category}">
		<input type="hidden" id="page" name="page" value="${page}">		
		<!-- BEGIN :: SEARCH -->
		<div class="alignBTN pdB10">
<!-- 
			<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="setSubFrame(1)"></span>
 -->		
			<span class="btn_pack medium icon"><span class="delete"></span><input value="Del" type="submit" onclick="setSubFrame(2)" ></span>
		</div>		

		<div id="gridDiv" >
			<div id="grdGridArea" style="height:300px; width:100%"></div>
		</div>
			<div id="groupInfoDiv" class="hidden" style="width:100%;height:400px;display: none;">
		<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col width="21%">
				<col width="12%">
				<col>
			</colgroup>
			<tr>
				<th  class="viewtop">프로젝트 코드</th>
				<td  class="viewtop">
					<input type="text" class="text" id="ProjectCode" name="ProjectCode" />
				</td>				
				<th  class="viewtop">프로젝트 명</th>
				<td  class="viewtop">
					<input type="text" class="text" id="ProjectName" name="ProjectName" />
				</td>
				<th  class="viewtop">${menu.LN00027}</th>
				<td  class="viewtop">
					<select id="ProjectStatus" name="ProjectStatus"></select>
				</td>
			</tr>
			<tr>
				<th >Description</th>
				<td colspan="5">
					<input type="text" class="text" id="description" name="description"  />
				</td>				
			</tr>
			<tr>
				<td colspan="6">
					<div class="alignBTN pdB10">
						<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="saveProject()" ></span>
					</div>		
				</td>
			</tr>
		</table>
	</div>
<!-- 
		<table id="projNew" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;" >
			<tr>
				<td>
					<iframe src="subMain.do?url=middleMenu/subChangeManagement&languageID=${sessionScope.loginInfo.sessionCurrLangType}" id="iFr" name="iFr" frameborder="0" scrolling="no" width="100%" height="500px"></iframe>
				</td>
		</table>	
 -->		
	</form>
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
	<!-- END :: FRAME -->	
</body>
</html>