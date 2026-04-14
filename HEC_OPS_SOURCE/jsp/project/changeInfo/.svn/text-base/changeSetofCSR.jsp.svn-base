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

<script type="text/javascript">
	var p_gridArea_Cngt; //그리드 전역변수(ChangeSet)
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
		
		gridCngtInit();
		doSearchCngtList();
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* ChangeSet List */
	function gridCngtInit(){
		var d = setGridCngtData();
		p_gridArea_Cngt = fnNewInitGrid("grdCngtGridArea", d);
		p_gridArea_Cngt.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea_Cngt.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(p_gridArea_Cngt, 1, "ch");
		fnSetColType(p_gridArea_Cngt, 2, "img");	
		
		p_gridArea_Cngt.setColumnHidden(11, true);
		p_gridArea_Cngt.setColumnHidden(12, true);
		p_gridArea_Cngt.setColumnHidden(13, true);
		p_gridArea_Cngt.setColumnHidden(14, true);
		p_gridArea_Cngt.setColumnHidden(15, true);
		p_gridArea_Cngt.setColumnHidden(16, true);
		p_gridArea_Cngt.setColumnHidden(17, true);
		p_gridArea_Cngt.setColumnHidden(18, true);
		p_gridArea_Cngt.setColumnHidden(19, true);
		p_gridArea_Cngt.setColumnHidden(20, true);
		
		p_gridArea_Cngt.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		p_gridArea_Cngt.enablePaging(true,50,null,"pagingArea",true,"recInfoArea");
		p_gridArea_Cngt.setPagingSkin("bricks");
		p_gridArea_Cngt.attachEvent("onPageChanged", function(ind,fInd,lInd){
			$("#currPage2").val(ind);
		});
	}
	
	function setGridCngtData(){
		var result = new Object();
		
		var pjtId = "${ProjectID}";
		result.title = "${title}";
		result.key = "cs_SQL.getChangeSetList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00022},${menu.LN00004},${menu.LN00153},${menu.LN00078},${menu.LN00027},ChangeSetID,,,,,,,,,";
		result.cols = "CHK|ItemTypeImg|ClassCode|Identifier|ItemName|ChangeType|AuthorName|TeamName|CreationTime|StatusName|ChangeSetID|ItemID|StatusCode|AuthorID|CreationTime2|LastUpdated|ExtFunc|CurTask|ProjectID|ChangeTypeCode";
		result.widths = "50,50,50,100,100,*,100,100,100,80,80,0,0,0,0,0,0,0,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data =  "&csrID=" + csrID + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";

		// 계층
		if($("#classCode").val() != '' & $("#classCode").val() != null){
			result.data = result.data +"&classCode="+ $("#classCode").val();
		}
		// 담당자
		if($("#members").val() != '' & $("#members").val() != null){
			result.data = result.data +"&AuthorID="+ $("#members").val();
		}
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			result.data = result.data +"&Status=" + $("#Status").val();
		}
		
		return result;
	}
	
	function doSearchCngtList(){
		var d = setGridCngtData();
		fnLoadDhtmlxGridJson(p_gridArea_Cngt, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	// 그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var authorId = p_gridArea_Cngt.cells(id, 14).getValue();
		var itemId = p_gridArea_Cngt.cells(id, 12).getValue();
		/* 변경항목 수정 화면으로 이동 */
		// 파라메터 :ChangeSetID, StatusCode, 담당자 여부
		
		if (ind == 2) {
			// 구분 칼럼 Click : Item popup 표시
			var changeType = p_gridArea_Cngt.cells(id, 20).getValue();
			var changeSetID = p_gridArea_Cngt.cells(id, 11).getValue();
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;

			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		} else {
			if (ind != 1) {
				goInfoView(p_gridArea_Cngt.cells(id, 11).getValue(), p_gridArea_Cngt.cells(id, 13).getValue(),itemId);
			}
		}
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
	
	// [Del] Click
	function delChangeSet() {
		if(p_gridArea_Cngt.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea_Cngt.getCheckedRows(1).split(",");	
				var loginUser = "${sessionScope.loginInfo.sessionUserId}";
				var items = "";
				var ids = "";
				var msg = "";
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var creationTime = p_gridArea_Cngt.cells(checkedRows[i], 15).getValue();
					var lastUpdated = p_gridArea_Cngt.cells(checkedRows[i], 16).getValue();
					var authorId = p_gridArea_Cngt.cells(checkedRows[i], 14).getValue();
					var cngtName = p_gridArea_Cngt.cells(checkedRows[i], 4).getValue() + " " + p_gridArea_Cngt.cells(checkedRows[i], 5).getValue();
					
					if (loginUser == authorId) {
						if (creationTime == lastUpdated || creationTime > lastUpdated) {
							// 삭제 할 (ChangeSetID, ItemID)의 문자열을 셋팅
							if (items == "") {
								items = p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
								ids = p_gridArea_Cngt.cells(checkedRows[i], 12).getValue();
							} else {
								items = items + "," + p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
								ids = ids + "," + p_gridArea_Cngt.cells(checkedRows[i], 12).getValue();
							}
						} else {
							msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00130' var='WM00130' arguments='"+ cngtName +"'/>";
							alert("${WM00130}");
							p_gridArea_Cngt.cells(checkedRows[i], 1).setValue(0); 
						}
					} else {
						msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ cngtName +"'/>";
						alert("${WM00112}");
						p_gridArea_Cngt.cells(checkedRows[i], 1).setValue(0); 
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
		doSearchCngtList();		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	// [Move] Click
	function openCsrListPop() {
		
		if(p_gridArea_Cngt.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			var checkedRows = p_gridArea_Cngt.getCheckedRows(1).split(",");	
			var cngts = "";
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				if (cngts == "") {
					cngts = p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
				} else {
					cngts = cngts + "," + p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
				}
			}
			if (cngts != "") {
				var url = "selectCsrListPop.do?";
				var curPJTID = "${ProjectID}";
				var data = "cngts=" + cngts + "&curPJTID=" + csrID ;
			    fnOpenLayerPopup(url,data,doCallBack,900,900);
			}
		}
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
		if(p_gridArea_Cngt.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			var checkedRows = p_gridArea_Cngt.getCheckedRows(1).split(",");	
			var items = "";
			var cngts = "";
			var pjtIds = "";
			var msg = "";
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				
				var cngtName = p_gridArea_Cngt.cells(checkedRows[i], 4).getValue() + " " + p_gridArea_Cngt.cells(checkedRows[i], 5).getValue();			
			    var status = p_gridArea_Cngt.cells(checkedRows[i], 13).getValue();
			    var itemName = p_gridArea_Cngt.cells(checkedRows[i], 5).getValue();
	
			    if (status == "CMP") {    
					// Close 할 (ChangeSetID, ItemID)의 문자열을 셋팅
					if (items == "") {
						items = p_gridArea_Cngt.cells(checkedRows[i], 12).getValue();
						cngts = p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
						pjtIds = p_gridArea_Cngt.cells(checkedRows[i], 19).getValue();
					} else {
						items = items + "," + p_gridArea_Cngt.cells(checkedRows[i], 12).getValue();
						cngts = cngts + "," + p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
						pjtIds = pjtIds + "," + p_gridArea_Cngt.cells(checkedRows[i], 19).getValue();
					}
				 } else {
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
					alert("${WM00129}");
					p_gridArea_Cngt.cells(checkedRows[i], 1).setValue(0); 
				}
			  }			
			
			if (items != "") {
				var url = "closeChangeSet.do?";
				var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goApprRequest() {
		
		var checkedRows = p_gridArea_Cngt.getCheckedRows(1).split(",");	
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var isMultiCnt = 0;
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			var status = p_gridArea_Cngt.cells(checkedRows[i], 13).getValue();
			var itemName = p_gridArea_Cngt.cells(checkedRows[i], 5).getValue();
			
			if (status == "CMP") {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
					projectID = p_gridArea_Cngt.cells(checkedRows[i], 19).getValue();
				} else {
					items = items + "," + p_gridArea_Cngt.cells(checkedRows[i], 11).getValue();
				}
				isMultiCnt++;
				
			} else {
				var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
				alert("${WM00129}");
				p_gridArea_Cngt.cells(checkedRows[i], 1).setValue(0); 
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
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchCngtList()"/>
					<c:if test="${(csrStatus == 'CSR' ||  csrStatus == 'CNG') && sessionScope.loginInfo.sessionMlvl == 'SYS'}">				
				    		&nbsp;<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="openCsrListPop()"></span>			   
				   	</c:if>
					<c:if test="${csrStatus == 'CNG' && (GlobalVal.APPORVAL_MULTI == '1' || GlobalVal.APPORVAL_MULTI == '2') }">		
						<c:if test="${closingOption == '02' }">				
				  	    	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approve" onclick="goCSApproval()" type="submit"></span>		
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
	</div>
	
	<!-- END :: LIST_GRID -->
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>