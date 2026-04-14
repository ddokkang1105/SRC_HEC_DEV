<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 관리자 : 변경 관리 단위 목록 -->
<!-- 
	* @RequestMapping(value="/projectGroupList.do")
	* project_SQL.xml - getSetProjectList_gridList
	* Action
	 - Create :: projectItemCreate.do
	 - View   :: projectGroupInfoview.do
 -->
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
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnClassRowSelect(id,ind);});
		p_gridArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridClassData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getSetProjectList";
		result.header = "${menu.LN00024},Project Code,${menu.LN00028},${menu.LN00003},${menu.LN00004},${menu.LN00013},${menu.LN00027},,";
		result.cols = "ProjectCode|ProjectName|Description|CreatorName|CreationTime|StatusName|ProjectID|ChildCount";
		result.widths = "50,100,170,*,100,100,70,0,0";
		result.sorting = "int,int,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,center,center,center,center,center";
		result.data = "filter=PG"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=${screenType}&refID=${refID}";
		return result;
	}
	function gridOnClassRowSelect(id, ind){
		if(ind == '1'){/*alert(ind+"번째 셀 클릭");*/
		}else if(ind == '4'){/*alert(ind+"번째 셀 클릭");*/
		}else{
			goInfoView("N", p_gridArea.cells(id,7).getValue());
		}
	}
	
	
	
	function doSearchClassList(){		
		var d = setGridClassData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false);
		this.setPagingHTML($("#totalPage").val(), $("#page").val());
	}
	
	function goInfoView(avg1, avg2){
		var url = "projectGroupInfoview.do";
		var data = "isNew="+avg1+"&s_itemID="+avg2+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=${category}";
		var target = "projectDiv";
		ajaxPage(url, data, target);	
	}
	
	function addPrj(){
		/*
		$("#groupInfoDiv").removeAttr('style', 'display: none');
		$("#addIcon").attr('style', 'display: none');
		$("#StartDate").append(generateDatePicker);
		$("#DueDate").append(generateDatePicker);
		*/
		//$("#CreationDate").append(generateDatePicker);
		goInfoView("Y", "");
	}
	
	function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
	function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
	
	// [Del]
	function delPjtInfo() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("삭제할 항목을 한개 이상 선택하여 주십시요.");
			alert("${WM00023}");
		}else{
			//if(confirm("선택된 항목를 삭제하시겠습니까?")){
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
				var items = "";
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					// 삭제 할 (ProjectID)의 문자열을 셋팅
					if (items == "") {
						items = p_gridArea.cells(checkedRows[i], 7).getValue();
					} else {
						items = items + "," + p_gridArea.cells(checkedRows[i], 7).getValue();
					}
				}
				var url = "DelProjectInfo.do";
				var data = "items=" + items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
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
		<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${menu.LN00277}</div>		
		<div class="alignBTN pdB10">
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}">
				<span id="addIcon" class="btn_pack small icon"><span class="add"></span><input value="Create Portfolio" type="submit" onclick="addPrj()"></span>
			</c:if>
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
	<div class="schContainer" id="schContainer" >
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
	<!-- END :: FRAME -->	
</div>
</body>
</html>