<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />

<script>
var option = "${option}";
$(document).ready(function(){
	
	var bottomHeight = 180 ;
	if("${ownerType}" == "team" || "${ownerType}" == "user"){
		bottomHeight = 330;
	}
	
	// 초기 표시 화면 크기 조정 
	$("#layout").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });

 	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
	fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');	
	fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
	fnSelect('status', data+"&category=ITMSTS", 'getDictionaryOrdStnm', '${status}', 'Select');
	
	doTcSearchList();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {
	doTcSearchList();
}

function doDetail(avg1, avg2){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}

function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}

function fnGetClassCode(itemTypeCode){
	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+itemTypeCode;
	fnSelect('classCode', data, 'classCodeOption', '', 'Select');	
}

function doCallBack(){}

// 본 화면 Reload [Seach][After Check In]
function thisReload(){
	var url = "ownerItemList.do";
	var target = "help_content";
	var screenType = "${screenType}";
	if(screenType == "CSR"){
		target = "myItemDiv";
	}
	
	var data = "screenType="+screenType+"&csrID=${csrID}&ownerType=editor";
	if($("#Status").val() != '' & $("#Status").val() != null){
		data = data + "&Status="+ $("#Status").val();
	}
	if($("#ClassCode").val() != '' & $("#ClassCode").val() != null){
		data = data + "&ClassCode="+ $("#ClassCode").val();
	}
	
 	ajaxPage(url, data, target);
}

function urlReload() {
	thisReload();
}

function fnItemMenuReload(){
	opener.fnUpdateStatus("SPE015");
	self.close();
}
	
</script>	

<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	
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
	
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<div class="cop_hdtitle pdL10 pdB5 pdT5" style="border-bottom:1px solid #ccc">
			<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00347}${menu.LN00087}</h3>
		</div><div style="height:10px"></div>
		<div class="child_search" style="border:none;">	
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
		</div>
		  
        <div class="countList">
            <li class="count">Total  <span id="TOT_CNT"></span></li>
			<li class="floatR pdR20">	
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>	
       	</div>
		<div id="layout" style="width:100%"></div>
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	grid = new dhx.Grid("",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true, align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], align:"center", htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+text+'" width="18" height="18">';
	            }
	        },
	        { width: 90, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }]},
	        { width: 220, id: "ItemNM", header: [{ text: "${menu.LN00028}", align:"center" }]},
	        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" }], align:"center"},
	        { id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }]},
	        { width: 90, id: "PjtName", header: [{ text: "${menu.LN00131}", align:"center" }], align:"center"},
	        { width: 90, id: "AuthorName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 70, id: "StatusNM", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center"},
	        { width: 70, id: "ChangeMgtYN", header: [{ text: "${menu.LN00089}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	layout.getCell("a").attach(grid);
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id !== "checkbox") {
			doDetail(row.ItemID);
		}
	 });
	
	function doTcSearchList(){
		var sqlID = "item_SQL.getMyItemList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&statusList=${statusList}" 
			+ "&pageNum=" + $("#currPage").val()
	        + "&searchKey=" + $("#searchKey").val()
	        + "&searchValue=" + $("#searchValue").val()
			+ "&sqlID="+sqlID;
			
		if($("#itemTypeCode").val() != null && $("#itemTypeCode").val() != ""){
	  		param = param + "&itemTypeCode=" + $("#itemTypeCode").val();
	  	}
		if($("#classCode").val() != null && $("#classCode").val() != ""){
	  		param = param + "&classCode=" + $("#classCode").val();
	  	}
		
		if($("#status").val() != null && $("#status").val() != ""){
	  		param = param + "&status=" + $("#status").val();
	  	}				
		else if("${status}" != "" && ($("#status").val() == null || $("#status").val() == "")) {
			param = param + "&status=${status}";
		}
		
	  	param = param + "&changeMgtYN=${changeMgt}&assignmentType=${assignmentType}";
	  	
	  	if("${assignmentType}" != "SUBSCR") {
	  		param = param + "&roleType=R";
	  	}
	  	else {
	  		param = param + "&accessRight=R";
	  	}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
		 		$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>