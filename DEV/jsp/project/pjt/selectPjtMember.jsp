<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<!-- dhtmlx 7버전 업그레이드   -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listEditable = "${listEditable}";
	var isProject = "${isProject}";
	var screenType = "${screenType}";
	var parentID = "${parentID}";
	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		// 초기 표시 화면 크기 조정 
		$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		$("#excel").click(function(){pp_grid.toExcel("${root}excelGenerate");});

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	 

	
		// [Add] 버튼 Click
		function addPjtMember(url){
		 console.log("add접속");

		 console.log("parentID>>"+parentID);
		 console.log("projectId>>"+"${projectID}");
		 
			if("${screenType}"=="csrDtl"){			
				
				var url = "selectPjtAuthor.do?projectID=${parentID}&csrId=${projectID}&screenType=${screenType}";
				var w = 800;
				var h = 700;
				itmInfoPopup(url,w,h);
			}else{
				
			
				var cnt  = grid.data.getLength();
				
				var memArr = new Array;
				var data = grid.data.serialize();
				for ( var i = 0; i < cnt; i++) {
					
					memArr[i] = data[i].MemberID;
				}
				
				var url = "selectMemberPop.do?projectID=${projectID}&scrnType=PJT&s_memberIDs="+memArr;
				window.open(url,"","width=1000 height=650 resizable=yes");
			}
		}
	 
	// [Del] 버튼 Click
	function delPjtMember() {
	
	
		var checkedRow = grid.data.findAll(function (data){
			return data.checkbox
		});
		
		
		console.log("checkedRow>>"+checkedRow);
		
		if(!checkedRow.length){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00004}")){
				var memberIds ="";
				for(idx in checkedRow){
					var count = checkedRow[idx].CNT;
					
					if(count > 0){
						var id = "LoginID : " + checkedRow[idx].LoginID;
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00134' var='WM00134' arguments='"+ id +"'/>"
						alert("${WM00134}");
						checkedRow[idx].checkbox =0;
					}else {
						if (memberIds == "") {
							memberIds = checkedRow[idx].MemberID;
						} else {
							memberIds = memberIds + "," + checkedRow[idx].MemberID;
						}
					}
				  }
				if (memberIds != "") {
					var url = "admin/delPjtMembers.do";
					var data = "projectID=${projectID}&memberIds=" + memberIds;
					var target = "saveFrame";
					console.log("memberIds>>"+memberIds);
					
					ajaxPage(url, data, target);
				}
				}
			}
			
		}
		
	
	
	
	// [Select] 버튼 Click
	function selectNewMember() {
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				var memberIds =""; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (memberIds == "") {
						memberIds = pp_grid.cells(checkedRows[i], 10).getValue();
					} else {
						memberIds = memberIds + "," + pp_grid.cells(checkedRows[i], 10).getValue();
					}
				}
				
				var url = "admin/insertPjtMembers.do";
				var data = "projectID=${projectID}&memberIds=" + memberIds +"&screenType=${screenType}"; 
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	// [Del][Select] Click 이벤트 후 reload 처리
	function reloadMemberList(){
		var url = "selectPjtMember.do";
		var data = "projectID=${projectID}&listEditable=Y&isNew=${isNew}&isPjtMgt=${isPjtMgt}&screenType=${screenType}&parentID=${parentID}";
		var target = "help_content"; if("${screenType}" == "csrDtl"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [조직] text Click 이벤트
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#txtTeam').val(teamName);
	}
	
	// [Clear] click
	function clearSearchCon() {
		// User Type
		$("#userType").val("1").attr("selected", "selected");
		// 조직
		$("#selTeam").val("").attr("selected", "selected");
		$("#ownerTeamCode").val('');
		$("#txtTeam").val('');
		// 입력 검색조건
		$("#searchKey").val("Name").attr("selected", "selected");
		$("#searchValue").val('');
	}
	
	// [Back] click
	function goBack() {
		
		var data = "isNew=N&s_itemID=${projectID}&pjtMode=R&screenType=${screenType}&listEditable=${listEditable}&isPjtMgt=${isPjtMgt}";
		var target = "help_content";
		var isProject = "N";
		
		if ("N" == isProject) {
			url = "viewProjectInfo.do";		
			target = "viewProjectInfoDiv";
		}		
		if ("Y" == isProject) {
			url = "variantDetail.do";
			target = "userNameListFrm";
			data = "isNew=${isNew}&s_itemID=${s_itemID}&variantID=${variantID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&pjtMode=R&screenType=${screenType}";
		}
		
		ajaxPage(url, data, target);
	}
	
</script>
<div id="viewProjectInfoDiv">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
	<c:if test="${screenType != 'csrDtl'}">
		<div class="msg mgT5" style="width:100%;">
		      	   <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Worker management    
	    </div>
    </c:if>

	<div class="child_search">
		
		<li class="floatR pdR20">
			<c:if test="${listEditable == 'Y' && (sessionScope.loginInfo.sessionMlvl eq 'SYS' or authorID == sessionScope.loginInfo.sessionUserId)}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addPjtMember('selectPjtMember.do')" ></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delPjtMember()"></span>
			</c:if>	
			<c:if test="${empty loginInfo.sessionSecuLvl}">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</c:if>			
			<c:if test="${isPjtMgt != 'Y' && screenType != 'csrDtl'}">
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>						
		</li>
    </div>
  	
	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="left">
		<div id="grdPAArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular">
			<div id="pagingArea" style="display:inline-block;"></div>
		
	</div> 
	
</form>
</div>
<!-- =================================== BEGIN ::: GRID -->

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
<script type="text/javascript">
		var layout = new dhx.Layout("grdPAArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 
	
		var grid = new dhx.Grid("grdPAArea", {
			  columns: [
			        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" ,rowspan: 2}], align: "center" },
			        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center",rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
			        { hidden:true,width: 200, id: "LoginID", header: [{ text: "LoginID" , align: "center"}]},
			        { width: 180, id: "UserName", header: [{ text: "Name" , align: "center" }, { content: "inputFilter" }], align: "center" },
			        { width: 100, id: "Position", header: [{ text: "Position" , align: "center" }]},
			        { width: 280, id: "TeamPath", header: [{ text: "${menu.LN00202}" , align: "center" }, { content: "inputFilter" }]},
			        { width: 180, id: "Email", header: [{ text: "E-Mail" , align: "center" }, { content: "" }], align: "" },
			        { width: 95, id: "MTelNum", header: [{ text: "Mobile" , align: "center" }, { content: "" }] },
			        { width: 100, id: "RegDate", header: [{ text: "${menu.LN00013}" , align: "center" }] },
			        { width: 80, id: "MLVL", header: [{ text: "Type" , align: "center" }, { content: "selectFilter" }]},
			        { hidden:true, width: 0, id: "MemberID", header: [{ text: "MemberID" , align: "center" }, { content: "selectFilter" }]},
			        { hidden:true, width: 0, id: "Authority", header: [{ text: "Authority" , align: "center" }, { content: "selectFilter" }]},
			        { hidden:true, width: 0, id: "CNT", header: [{ text: "CNT" , align: "center" }, { content: "selectFilter" }] },
			 
			        
			    ],
		    eventHandlers: {
		        onclick: {
		        
		        }
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
	
		
		layout.getCell("a").attach(grid);
		
		var pagination = new dhx.Pagination("pagingArea", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(document.getElementById('currPage').value);
		$("#TOT_CNT").html(grid.data.getLength());
		
		

</script>
