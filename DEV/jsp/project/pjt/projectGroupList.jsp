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
<!-- grid version 7.1.8  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script type="text/javascript">
//var p_gridArea;		
var screenType = "${screenType}"; //그리드 전역변수

	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};
	//	gridClassInit();
	//	doSearchClassList(); 

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

	function gridOnClassRowSelect(row, col){
		if(col.id == 'ProjectCode'){/*alert(ind+"번째 셀 클릭");*/
		}else if(col.id == 'CreatorName'){/*alert(ind+"번째 셀 클릭");*/
		}else{
			goInfoView("N", row.ProjectID);
		}
	}
	

	function goInfoView(avg1, avg2){

		var url = "projectGroupInfoview.do";
		var data = "isNew="+avg1+"&s_itemID="+avg2+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=${category}";
		var target = "projectDiv";
		ajaxPage(url, data, target);	
		
	}
	
	function addPrj(){
	
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
		<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
		<input type="hidden" id="saveType" name="saveType" value="New">		
		<input type="hidden" id="AuthorID" name="AuthorID">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode">
		<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${menu.LN00277}</div>		
		<div class="alignBTN pdB10">
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}">
				<span id="addIcon" class="btn_pack small icon"><span class="add"></span><input value="Create Work Space" type="submit" onclick="addPrj()"></span>
			</c:if>
		</div>		
	</form>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>	
	</div>
	<!-- START :: PAGING -->
		<div id="pagination"></div>
	<!-- END :: PAGING -->
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer" >
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
	<!-- END :: FRAME -->	
</div>

<script type="text/javascript">
var layout = new dhx.Layout("grdGridArea", {
	rows : [ {
		id : "a",
	}, ]
});	
var gridData = ${gridData}; 

var grid = new dhx.Grid("grdGridArea", {

    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 100, id: "ProjectCode", header: [{ text: "Code" , align: "center" },{content:"selectFilter"}], align: "center" },
        { width: 200, id: "ProjectName", header: [{ text: "${menu.LN00028}" , align: "center" },{content:"inputFilter"}], align: "left" },
        { width: 350, id: "Description", header: [{ text: "${menu.LN00003}" , align: "center" },{content:"inputFilter"}],align: "left" },
        { width: 150, id: "CreatorName", header: [{ text: "${menu.LN00004}" , align: "center" },{content:"inputFilter"}],align: "center" },
        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00013}" , align: "center" },{content:"selectFilter"}],align: "center"},
        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" },{content:"selectFilter"}],align: "center" },
        { hidden:true, width: 0, id: "ProjectID", header: [{ text: "" , align: "center" }, { content: "" }]}, 
        { hidden:true,width: 0, id: "ChildCount", header: [{ text: "" , align: "center" }, { content: "" }], align: "" },
        
        
        
       
    ],
    eventHandlers: {
        onclick: {
           /*   "Action": function (e, data) {
            	fnEditTmp(data.row);
            } 
             */
        }
    },
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});



layout.getCell("a").attach(grid);




var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 40,
 
});	

pagination.setPage(document.getElementById('currPage').value);

//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		
	
		gridOnClassRowSelect(row,column);
		
	}); 


</script>
</body>
</html>