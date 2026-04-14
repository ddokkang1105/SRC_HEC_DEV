<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />

<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>

	var languageID = `${languageID}`; // 언어코드
	
	// team option
	var teamID = `${teamID}`;
	
	// role option
	var roleManagerID = `${roleManagerID}`;
	var teamRoleType = `${teamRoleType}`;
	
	// item option
	var itemTypeCode = `${itemTypeCode}`;
	var classCode = `${classCode}`;
	var status = `${status}`;
	var s_itemID = `${s_itemID}`; // s_itemID
	
	// search option
	var searchKey = `${searchKey}`;
	var searchValue = `${searchValue}`;

	var tc_gridArea;
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	$(document).ready(function(){
		
		var bottomHeight = 180 ;
		if("${ownerType}" == "team"){
			bottomHeight = 435;
		}
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
		};
		
		$("#excel").click(function(){fnGridExcelDownLoad();});
	
	 	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
		fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');		
		fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
		fnSelect('status', data+"&category=ITMSTS", 'getDictionary', '', 'Select');	
		fnSelect('teamRoleType', data+"&category=TEAMROLETP", 'getDictionary', '', 'Select');	
		
		// grid load
		loadTeamRoleMgtList();
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function urlReload() {
		thisReload();
	}

	//===============================================================================
	
	// BEGIN ::: GRID
	function thisReload(){
		loadTeamRoleMgtList();
	}
	
	function gridOnRowSelect(row, col){
		if(col.id != "checkbox"){
			if(col.id  == "TeamRoleNM"){
				fnViewTeamRole(row.TeamRoleID);
			}else{
				doDetail(row.ItemID);
			}
		}else{tranSearchCheck = false;}
	}
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function fnViewTeamRole(teamRoleID){
		var w = "1000";
		var h = "400";
		var url = "teamRoleDetail.do?teamRoleID="+teamRoleID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

	function fnTeamRoleCallBack(){ urlReload(); }
	
	function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){/*alert(s_itemID+":::"+tc_gridArea.cells(id, 14).getValue()+"::::"+id);*/if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}

	function changeRoleManager(){
		// check된 row 
		var checkedRows = grid.data.findAll(function (data) {
	    	return data.checkbox; 
		});

		if(checkedRows.length == 0){
			alert("${WM00023}");
			return;
		}
		
		var teamRoleIDs =  new Array;	
		var chkVal;
		
		var j = 0;		
		for ( var i = 0; i < checkedRows.length; i++) { 
			chkVal = checkedRows[i].checkbox;
			if(chkVal == true){
				teamRoleIDs[i] = checkedRows[i].TeamRoleID;
				j++;
			}
		}
		
		if (teamRoleIDs.length > 0) {
			$("#teamRoleIDs").val(teamRoleIDs);
		    var url = "searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL"+ "&teamID=${teamID}";
			var w = "400";
			var h = "330";
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		 }
				
	  }

	function setSearchNameWf(memberID){
		if(!confirm("${CM00001}")){ return;}
		var teamRoleIDs = $("#teamRoleIDs").val();
		
		var url = "updateTeamRoleInfo.do";
		var target = "blankFrame";		
		var data = "teamRoleIDs="+teamRoleIDs+"&roleManagerID="+memberID;
		ajaxPage(url, data, target);
	}
	
	// [api]
	// teamRoleMgtList 가져와 grid에 주입시키는 함수
	async function loadTeamRoleMgtList(){
		
		$('#loading').fadeIn(150);
		
		// option
		var searchKeyElement = document.querySelector("#searchKey");
		var searchKey = searchKeyElement ? searchKeyElement.value : "";
		var searchValueElement = document.querySelector("#searchValue");
		var searchValue = searchValueElement ? searchValueElement.value : "";
		var pageNumElement = document.querySelector("#pageNum");
		var pageNum = pageNumElement ? pageNumElement.value : "";
		
		searchValue = encodeURIComponent(searchValue);
		
	    const requestData = { languageID, teamID, pageNum, searchKey, searchValue };
	    
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getTeamRoleMgtList.do?" + params;
	    
	    try {
	        const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}

			if (result && result.data && result.data.length > 0) {
				fnReloadGrid(result.data);
			} else {
				return [];
			}
	        
	    } catch (error) {
	    	
	    	handleAjaxError(error);
	    	
	    } finally {
	    	$('#loading').fadeOut(150);
	    }
	}
	 
	 /**
	  * @function handleAjaxError
	  * @description 데이터 로드 실패 시 에러 메시지 팝업 출력
	  * @param {Error} err - 발생한 에러 객체
	  */
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

</script>	
<form name="teamRoleMgtFrm" id="teamRoleMgtFrm" action="#" method="post" onsubmit="return false;">
	
	<input type="hidden" id="itemID" name="itemID">
	<input type="hidden" id="ItemID" name="ItemID">
	<input type="hidden" id="checkIdentifierID" name="checkIdentifierID">
	<input type="hidden" id="itemDelCheck" name="itemDelCheck" value="N">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="level" name="level" value="${request.level}">
	<input type="hidden" id="Auth" name="Auth" value="${sessionScope.loginInfo.sessionLogintype}">	
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}">	
	<input type="hidden" id="AuthorSID" name="AuthorSID" value="${sessionScope.loginInfo.sessionUserId}">	
	<input type="hidden" id="AuthorName" name="AuthorName" value="${sessionScope.loginInfo.sessionUserNm}">	
	<input type="hidden" id="fromItemID" name="fromItemID" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="ownerType" name="ownerType" value="${ownerType}" >
	<input type="hidden" id="teamRoleIDs" name="teamRoleIDs" >
	
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<c:if test="${ownerType eq 'editor' }" >
		<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
			<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00190}</h3>
		</div><div style="height:10px"></div>
		</c:if>
			  
        <div class="countList pdT5">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">
				<c:if test="${loginInfo.sessionMlvl eq 'SYS' || loginInfo.sessionUserId eq teamManagerID }" ><span class="btn_pack small icon"><span class="gov"></span><input value="Gov" type="submit"  onclick="changeRoleManager();" id="gov"></span></c:if>
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
<script type="text/javascript">

	// grid
	var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		
	var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		        {width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        {width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center"}]
		                , align: "center", type: "boolean", editable: true, sortable: false   },
		        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
		                  	template: function (text, row, col) {
		                  		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
		                      }
		                  },
		        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00106}" , align: "center" }, { content: "inputFilter" }]},
		        { width: 350, id: "ItemNM", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }]},
		        { width: 200, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" }, { content: "selectFilter" }],align:"center"},
		        { width: 200, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" }, { content: "inputFilter" }], align: "" },
		        { width: 180, id: "PjtName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }],align:"center" },
		        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" }]},
		        { width: 100, id: "StatusNM", header: [{ text: "${menu.LN00027}" , align: "center" },{ content: "selectFilter" }],align:"center"},
		        { width: 140, id: "TeamRoleNM", header: [{ text: "${menu.LN00119}" , align: "center" }, { content: "selectFilter" }],align:"center"},
		        { width: 150, id: "RoleManagerNM", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "selectFilter" }],align:"center" },
		        { hidden:true,width: 80, id: "SCOUNT", header: [{ text: "SCOUNT"}, { content: "" }], align: "" },
		        { hidden:true,width: 80, id: "ClassCode", header: [{ text: "ClassCode" , align: "center" }, { content: "" }], align: "" },
		        { hidden:true,width: 80, id: "Status", header: [{ text: "Status" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 80, id: "ItemID", header: [{ text: "ItemID" , align: "" }, { content: "" }], align: "" },
		        
		        { hidden:true,width: 80, id: "RoleManagerID", header: [{ text: "AuthorID" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 80, id: "Blocked", header: [{ text: "Blocked" , align: "" }, { content: "" }], align: "" },   
		        { hidden:true,width: 80, id: "TeamRoleID", header: [{ text: "TeamRoleID" , align: "" }, { content: "" }], align: "" },    
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
		layout.getCell("a").attach(grid);
	
		var pagination = new dhx.Pagination("pagingArea", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(document.getElementById('currPage').value);
		grid.events.on("cellClick", function(row, column, e) {
			gridOnRowSelect(row,column);
		});

</script>