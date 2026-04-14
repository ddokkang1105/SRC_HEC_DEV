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

<script>
	var tc_gridArea;
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	$(document).ready(function(){
		
		var bottomHeight = 180 ;
		if("${ownerType}" == "team"){
			bottomHeight = 330;
		}
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
		};
		
		$("#excel").click(function(){tc_gridArea.toExcel("${root}excelGenerate");});
	
	 	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
		fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');		
		fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
		fnSelect('status', data+"&category=ITMSTS", 'getDictionary', '', 'Select');	
		fnSelect('teamRoleType', data+"&category=TEAMROLETP", 'getDictionary', '', 'Select');	
		
		gridTcInit();		
		doTcSearchList();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function urlReload() {
		gridTcInit();		
		doTcSearchList();
	}

	//===============================================================================
	// BEGIN ::: GRID
	function doTcSearchList(){
		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
	}

	function gridTcInit(){	
		var tcd = setTcGridData();
		tc_gridArea = fnNewInitGrid("grdGridArea", tcd);
		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(tc_gridArea, 2, "img");
		fnSetColType(tc_gridArea, 1, "ch");
		
		tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		tc_gridArea.enablePaging(true,40,10,"pagingArea",true,"recInfoArea");
		
		tc_gridArea.setPagingSkin("bricks");
		tc_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setTcGridData(){
		var tcResult = new Object();
		tcResult.title = "${title}";
		tcResult.key = "role_SQL.getTeamRoleItemList";
		tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00043},${menu.LN00131},${menu.LN00070},${menu.LN00027},${menu.LN00119},${menu.LN00004},SCOUNT,ClassCode,Status,ItemID,AuthorID,Blocked,TeamRoleID";
		tcResult.cols = "CHK|ItemTypeImg|Identifier|ItemNM|ClassName|Path|PjtName|LastUpdated|StatusNM|TeamRoleNM|RoleManagerNM|SCOUNT|ClassCode|Status|ItemID|RoleManagerID|Blocked|TeamRoleID";
		tcResult.widths = "30,30,30,90,220,100,*,90,90,80,70,70,0,0,0,0,0,0,0";
		tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str";
		tcResult.aligns = "center,center,left,left,left,center,left,center,center,center,center,center,center,center, center,center,center";
		tcResult.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&teamID=${teamID}"  
					+ "&pageNum=" + $("#currPage").val()
			        + "&searchKey=" + $("#searchKey").val()
			        + "&searchValue=" + $("#searchValue").val();
		
									
					if($("#itemTypeCode").val() != null && $("#itemTypeCode").val() != ""){
				  		tcResult.data = tcResult.data + "&itemTypeCode=" + $("#itemTypeCode").val();
				  	}
					if($("#classCode").val() != null && $("#classCode").val() != ""){
				  		tcResult.data = tcResult.data + "&classCode=" + $("#classCode").val();
				  	}
					if($("#status").val() != null && $("#status").val() != ""){
				  		tcResult.data = tcResult.data + "&status=" + $("#status").val();
				  	}
					if($("#teamRoleType").val() != null && $("#teamRoleType").val() != ""){
				  		tcResult.data = tcResult.data + "&teamRoleType=" + $("#teamRoleType").val();
				  	}
		return tcResult;
	}
	function gridOnRowSelect(id, ind){if(ind != 1){doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());}else{tranSearchCheck = false;}}
	function doDetail(avg1, avg2){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}

	function fnTeamRoleCallBack(){ urlReload(); }
	
	function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){/*alert(s_itemID+":::"+tc_gridArea.cells(id, 14).getValue()+"::::"+id);*/if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}

	function changeRoleManager(){			
		if(tc_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}
		var rowNum = tc_gridArea.getRowsNum();;		
		var teamRoleIDs =  new Array;	
		var chkVal;
		
		var j = 0;		
		for ( var i = 0; i < rowNum; i++) { 
			chkVal = tc_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				teamRoleIDs[j] = tc_gridArea.cells2(i, 18).getValue();
				j++;
			}
		}
		if (teamRoleIDs.length > 0) {
			$("#teamRoleIDs").val(teamRoleIDs);
		    var url = "searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL"
		    			+ "&teamID=${teamID}";
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
		<div class="child_search" style="border:none;">		
			<li>${menu.LN00119}&nbsp;<select id="teamRoleType" name="teamRoleType" style="width:120px;" ></select></li>
			<li>${menu.LN00021}&nbsp;<select id="itemTypeCode" name="itemTypeCode" OnChange="fnGetClassCode(this.value)" style="width:120px;" ></select></li>
			<li>${menu.LN00016}&nbsp;<select id="classCode" name="classCode" style="width:120px;" ></select></li>
			<li>${menu.LN00027}&nbsp;<select id="status" name="status" style="width:120px;" ></select></li>
			<li class="pdL5">
				<select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID" 
						<c:if test="${!empty searchID}">selected="selected"
						</c:if>	
					>ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doTcSearchList()" value="Search" style="cursor:pointer;">
			</li>
			<li class="floatR pdR20">
				<c:if test="${loginInfo.sessionMlvl eq 'SYS' || loginInfo.sessionUserId eq teamManagerID }" ><span class="btn_pack nobg"><a class="gov" onclick="changeRoleManager();" title="Gov"></a></span></c:if>
        		<span class="btn_pack nobg"><a class="xls" id="excel" title="Down"></a></span>
			</li>			
		</div>
		  
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
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