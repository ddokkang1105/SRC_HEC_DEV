<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00026" var="WM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00115" var="WM00115" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00025" var="CM00025" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_1" arguments="${menu.LN00181}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_2" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00050" var="CM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var csrID = "${csrID}" ;
	var csrStatus = "${csrStatus}" ;
	
	$(document).ready(function() {
		fnSelect('Status','&category=CNGSTS','getDictionaryOrdStnm','', 'Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdCngtGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdCngtGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// [Del] Click
	function delChangeSet() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ 
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		} else {	
			if(confirm("${CM00004}")){
				var loginUser = "${sessionScope.loginInfo.sessionUserId}";
				var items = "";
				var ids = "";
				var msg = "";
				
				for(idx in selectedCell){
					var creationTime = selectedCell[idx].CreationTime2;
					var lastUpdated = selectedCell[idx].LastUpdated;
					var authorId = selectedCell[idx].AuthorID;
					var cngtName = selectedCell[idx].Identifier + " " + selectedCell[idx].ItemName;
					
					if (loginUser == authorId) {
						if (creationTime == lastUpdated || creationTime > lastUpdated) {
							// 삭제 할 (ChangeSetID, ItemID)의 문자열을 셋팅
							if (items == "") {
								items = selectedCell[idx].ChangeSetID;
								ids = selectedCell[idx].ItemID;
							} else {
								items = items + "," + selectedCell[idx].ChangeSetID;
								ids = ids + "," + selectedCell[idx].ItemID;
							}
						} else {
							msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00130' var='WM00130' arguments='"+ cngtName +"'/>";
							alert("${WM00130}");
							selectedCell[idx].checkbox = 0;
						}
					} else {
						msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ cngtName +"'/>";
						alert("${WM00112}");
						selectedCell[idx].checkbox = 0;
					}
				}
				if (items != "") {
					var url = "deleteChangeSet.do";
					var data = "items=" + items + "&ids=" + ids;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
	}
	
	function doCallBack(){}
	function fnCallBack(){
		thisReload();
	}
	function doCallBackMove(){}
	
	//After [Add]
	function thisReload(){
		// 변경항목 목록으로 reload
		fnSearch();
	
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	
	
	//Item Tree Popup Open
	function openItemTreePop(){
		var url = "myItemTreeDiagramList.do?screenType=${screenType}&Status=REL&csrID=${csrID}";
		var w = 1200;
		var h = 800;
		
		itmInfoPopup(url,w,h);
	}

	// [Approve] Click
	function goCSApproval() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ 
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		} else {
			var items = "";
			var cngts = "";
			var pjtIds = "";
			var msg = "";
			
			for(idx in selectedCell){
				var cngtName = selectedCell[idx].Identifier+ " " + selectedCell[idx].ItemName;			
			    var status = selectedCell[idx].StatusCode;
			    var itemName = selectedCell[idx].ItemName;
			    var checkInOption = selectedCell[idx].CheckInOption;
	
			    if (status == "CMP" && checkInOption == "02") {    
					// Close 할 (ChangeSetID, ItemID)의 문자열을 셋팅
					if (items == "") {
						items = selectedCell[idx].ItemID;					
					} else {
						items = items + "," + selectedCell[idx].ItemID;			
					}
				 } else {
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
					alert("${WM00129}");
					selectedCell[idx].checkbox = 0;
				}
			  }			
			
			if (items != "") {
				var url = "publishItem.do?";
				var data = "items=" + items ;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goApprRequest() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});

		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var isMultiCnt = 0;
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			var status = selectedCell[idx].StatusCode;
			var itemName = selectedCell[idx].ItemName;
			
			if (status == "CMP") {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = selectedCell[idx].ChangeSetID;
					projectID = selectedCell[idx].ProjectID;
				} else {
					items = items + "," + selectedCell[idx].ChangeSetID;
				}
				isMultiCnt++;
				
			} else {
				var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
				alert("${WM00129}");
				selectedCell[idx].checkbox = 0;
			}
		}
		
		if (items != "") {
	
			var url = "${wfURL}.do?";
			var data = "isNew=Y&wfDocType=CS&isMulti=Y&actionType=create&isPop=Y&wfDocumentIDs="+items+"&ProjectID="+projectID+"&isMultiCnt="+isMultiCnt;
					
			var w = 1200;
			var h = 550; 
			window.open(url+data,'window','width=1200, height=730, left=200, top=50,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
		}
		
	}
</script>

<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
<div id="gridCngtDiv" >	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="currPage" name="currPage" value="${currPageA}"></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="8%">
		    <col width="12%">
		    <col width="8%">
		    <col width="12%">
		    <col width="8%">
		    <col width="12%">
		    <col width="40%">
	    </colgroup>
	    <tr>
	   		<!-- 계층 -->
	       	<th class="viewtop">${menu.LN00016}</th>
	       	<td class="viewtop alignL">
	       		<select id="classCode" Name="classCode" style="width:90%">
	       			<option value=''>Select</option>
		        	<c:forEach var="i" items="${classCodeList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
	       		</select>
	       	</td>
	       	<!-- 담당자 -->
	       	<th class="viewtop">${menu.LN00004}</th>
	       	<td class="viewtop alignL">
	       		<select id="members" Name="members" style="width:90%">
	       			<option value=''>Select</option>
		        	<c:forEach var="i" items="${memberList}">
		            	<option value="${i.MemberID}">${i.Name}</option>
		            </c:forEach>
	       		</select>
	       	</td>
	       	<!-- 상태 -->
	        <th class="viewtop">${menu.LN00027}</th>
	        <td class="viewtop alignL">     
		        <select id="Status" Name="Status" style="width:90%"></select>
	        </td>	        
	        <td class="viewtop last alignR">
				<li class="floatC" style="display:inline">
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearch()"/>
					<c:if test="${(csrStatus == 'CSR' ||  csrStatus == 'CNG') && sessionScope.loginInfo.sessionMlvl == 'SYS'}">				
				    		&nbsp;<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="openCsrListPop()"></span>			   
				   	</c:if>
			
					<c:if test="${csrStatus == 'CNG' && authorID == sessionScope.loginInfo.sessionUserId }">		
						<c:if test="${closingOption == '02' }">				
				  	    	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Publish" onclick="goCSApproval()" type="submit"></span>		
				  	    </c:if>	
				  	    <c:if test="${closingOption == '03' }">			  		  	    
			    			&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goApprRequest();"></span>
			    		</c:if>
					</c:if>			
				</li>
			</td>
	    </tr>
    </table>
    
    <div class="countList pdT5">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>	    
 	</div>
	
	<!-- GRID -->	
	<div id="gridCngtDiv" style="width:100%;" class="clear" >
		<div id="grdCngtGridArea" ></div>
		<div id="pagination"></div>
	</div>
	<!-- END :: LIST_GRID -->
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
<script type="text/javascript">
	fnSearch();

	var layout = new dhx.Layout("grdCngtGridArea", {
		rows : [ {
			id : "a",
		}, ]
	});	
// 	var gridData = ${chgSetData}; 


	var grid = new dhx.Grid("grdCngtGridArea", {
		  columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align:"center",
					template:function(text,row,col){
						return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
					}	
				},
				{ width: 100, id: "ClassCode", header: [{ text: "${menu.LN00016}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ width: 180, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center"},
				{ width: 230, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" }], align: "left" },
				{ width: 80, id: "ChangeType", header: [{ text: "${menu.LN00022}" , align: "center" }] , align: "center"},
				{ width: 130, id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" },{ content: "selectFilter" }] , align: "center"},
				{ width: 130, id: "TeamName", header: [{ text: "${menu.LN00153}" , align: "center" }], align: "center"},
				{ width: 100, id: "CreationTime", header: [{ text: "${menu.LN00078}" , align: "center" }], align: "center"},
				{ width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ hidden:true, width: 0, id: "ChangeSetID", header: [{ text: "ChangeSetID" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "ItemID", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "StatusCode", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "AuthorID", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "CreationTime2", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "LastUpdated", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "ExtFunc", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "CurTask", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "ProjectID", header: [{ text: "" , align: "center" }], align: "center" },
				{ hidden:true, width: 0, id: "ChangeTypeCode", header: [{ text: "" , align: "center" }] , align: "center"},
				{ hidden:true, width: 0, id: "CheckInOption", header: [{ text: "" , align: "center" }] , align: "center"},
			],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
// 		data: gridData
	});

	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());
	
	var pagination = new dhx.Pagination("pagination", {
		data: grid.data,
		pageSize: 40,
	});		


	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" && column.id != "ItemTypeImg"){
			goInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
		}
		if(column.id == "ItemTypeImg"){
			gridOnRowSelect(row);
		}
	}); 

	// 그리드ROW선택시
	function gridOnRowSelect(row){
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var authorId = row.AuthorID;
		var itemId = row.ItemID;
		/* 변경항목 수정 화면으로 이동 */
		// 파라메터 :ChangeSetID, StatusCode, 담당자 여부
		
		// 구분 칼럼 Click : Item popup 표시
		var changeType = row.ChangeTypeCode;
		var changeSetID = row.ChangeSetID;
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;

		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	// [Row Click] 이벤트
	function goInfoView(avg1, avg2, avg3){	
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2+"&itemID="+avg3
				+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&mainMenu=${mainMenu}"
				+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}";
		var w = 1200;
		var h = 500; 
		itmInfoPopup(url,w,h);
	}

	
	// [Move] Click
	function openCsrListPop() {
		//CHEKC된 ROW 수 확인하기 
		var checkRows = grid.data.findAll(function(data){
				return data.checkbox;
		});
		if(checkRows.length === 0 ){
			alert("${WM00023}");
		}else{
			var cngts = new Array;

			for(idx in checkRows){
				 if (cngts == " "){
				 	cngts[idx] = checkRows[idx].ChangeSetID;
				}else{
				cngts[idx] =  checkRows[idx].ChangeSetID;
				}
			}
			
			 if(cngts != ""){
			 	var url ="selectCsrListPop.do?";
				var curPJTID = "${ProjectID}";
			 	var data =  "cngts=" + cngts + "&curPJTID=" + csrID  + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				fnOpenLayerPopup(url,data,doCallBack,500,400);
			 } 
		}
	}
	
	function fnCallBack(){
		thisReload();
	}

	//After [Add]
	function thisReload(){
		// 변경항목 목록으로 reload
		//doSearchCngtList();	
		fnSearch();
	
		$(".popup_div").hide();
		$("#mask").hide();	
	}

	function fnSearch(){
		var sqlID = "cs_SQL.getChangeSetList";
	 	var param = "&csrID="+csrID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&sqlID="+sqlID;
	 	
		// 계층
		if($("#classCode").val() != '' & $("#classCode").val() != null){
			param = param +"&classCode="+ $("#classCode").val();
		}
		// 담당자
		if($("#members").val() != '' & $("#members").val() != null){
			param = param +"&AuthorID="+ $("#members").val();
		}
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			param = param +"&Status=" + $("#Status").val();
		}
	 
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function fnReloadGrid(newGridData){
	    grid.data.parse(newGridData);
	    $("#TOT_CNT").html(grid.data.getLength());
		fnMasterChk('');
	}
 	

</script>