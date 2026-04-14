<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<!-- 1. Include JSP -->
<c:if test="${isPop == 'Y' }">
	<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
	<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
</c:if>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script type="text/javascript">
	var p_gridArea; //그리드 전역변수(ChangeSet)
	
	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar
		fnSelect('ChangeType', '&Category=CNGT1', 'dictionyCode', 'Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$('#Project').change(function(){
			changeCsrList($(this).val()); // 변경오더 option 셋팅
		});
		
		changeCsrList('${myPjtId}'); // 변경오더 option 셋팅
		
		gridCngtInit();
		doSearchList();
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* ChangeSet List */
	function gridCngtInit(){
		var d = setGridCngtData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 2, "img");
		
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(19, true);
		p_gridArea.setColumnHidden(20, true);
		p_gridArea.setColumnHidden(21, true);
		p_gridArea.setColumnHidden(22, true);
		p_gridArea.setColumnHidden(23, true);
		p_gridArea.setColumnHidden(24, true);
		p_gridArea.setColumnHidden(25, true);
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		p_gridArea.enablePaging(true,100,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){
			$("#currPageA").val(ind);
		});
	}
	
	function setGridCngtData(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "cs_SQL.getChangeSetList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},Version,${menu.LN00004},${menu.LN00131},${menu.LN00191},${menu.LN00022},${menu.LN00027},${menu.LN00063},${menu.LN00064},${menu.LN00296},ChangeSetID,,,,,,,,,,";
		result.cols = "CHK|ItemTypeImg|ClassCode|Identifier|ItemName|Version|AuthorName|parentPjtName|csrName|ChangeType|StatusName|CreationTime|CompletionDT|ValidFrom|ChangeSetID|ItemID|StatusCode|AuthorID|ExtFunc|CurTask|ProjectID|CreationTime2|LastUpdated|ChangeTypeCode|CheckInOption";
		result.widths = "30,30,50,90,90,*,80,90,100,100,100,80,80,80,80,80,0,0,0,0,0,0,0,0,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&AuthorID=${sessionScope.loginInfo.sessionUserId}"
					+ "&pageNum=" + $("#currPageA").val();
		
		// 프로젝트
		if($("#Project").val() != '' & $("#Project").val() != null){
			result.data = result.data +"&parentPjtID="+ $("#Project").val();
		}
		
		// 변경오더
		if($("#csrList").val() != '' & $("#csrList").val() != null){
			result.data = result.data +"&csrID="+ $("#csrList").val();
		}
		
		// 계층
		if($("#classCode").val() != '' & $("#classCode").val() != null){
			result.data = result.data +"&classCode="+ $("#classCode").val();
		}
		
		// 변경구분
		if($("#ChangeType").val() != '' & $("#ChangeType").val() != null){
			result.data = result.data +"&changeClassList="+ $("#ChangeType").val();
		}
		
		// 등록일
		if($("#REQ_STR_DT").val() != '' & $("#REQ_STR_DT").val() != null){
			result.data = result.data + "&reqStartDt=" + $("#REQ_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&reqEndDt=" + $("#REQ_END_DT").val().replace(/-/g, "");
		}
		// 완료일
		if($("#CLS_STR_DT").val() != '' & $("#CLS_STR_DT").val() != null){
			result.data = result.data + "&clsStartDt=" + $("#CLS_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&clsEndDt=" + $("#CLS_END_DT").val().replace(/-/g, "");
		}
		
		// 시행일
		if($("#VF_STR_DT").val() != '' & $("#VF_STR_DT").val() != null){
			result.data = result.data + "&vfStartDt=" + $("#VF_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&vfEndDt=" + $("#VF_END_DT").val().replace(/-/g, "");
		}
		
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			result.data = result.data +"&Status=" + $("#Status").val();
		}
		
		return result;
	}
	
	function doSearchList(){
		var d = setGridCngtData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	// 그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var isAuthorUser = "N";
		/* 변경항목 상세 화면으로 이동 */
		if (ind == 2) {
			// 구분 칼럼 Click : Item popup 표시
			var changeType = p_gridArea.cells(id, 24).getValue();
			var itemId = p_gridArea.cells(id, 16).getValue();
			var changeSetID = p_gridArea.cells(id, 15).getValue();
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		} else {
			if (ind != 1) {
				goInfoView(p_gridArea.cells(id, 15).getValue(), p_gridArea.cells(id, 17).getValue(), p_gridArea.cells(id, 16).getValue());
			}
		}
	}
	
	// [Row Click] 이벤트
	function goInfoView(avg1, avg2, avg3){
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2
		+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=${mainMenu}&seletedTreeId="+avg3
		+ "&screenMode=edit&isMyTask=Y&currPageA=" + $("#currPageA").val();
		var w = 1200;
		var h = 600; 
		itmInfoPopup(url,w,h);
	}
	
	// [변경오더 option] 설정
	function changeCsrList(avg){
		var url    = "getCsrListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=myPage&projectID="+avg ; //파라미터들
		var target = "csrList";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
	
	// After [Check in]
	function thisReload(){
		// reload
		var url = "myChangeSet.do";
		var data = "";
		var target = "help_content";
		ajaxPage(url, data, target);
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	// [Check in] Click
	function goCSCheckIN() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
			var items = "";
			var cngts = "";
			var pjtIds = "";
			var msg = "";
		
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				var extFunc = p_gridArea.cells(checkedRows[i], 17).getValue();
				var curTask = p_gridArea.cells(checkedRows[i], 18).getValue();
				var cngtName = p_gridArea.cells(checkedRows[i], 4).getValue() + " " + p_gridArea.cells(checkedRows[i], 5).getValue();
				var status = p_gridArea.cells(checkedRows[i], 15).getValue();
				
				if (status == "MOD" && (extFunc == "0" || (extFunc == "1" && curTask == "CLS"))) {
					// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
					if (items == "") {
						items = p_gridArea.cells(checkedRows[i], 14).getValue();
						cngts = p_gridArea.cells(checkedRows[i], 13).getValue();
						pjtIds = p_gridArea.cells(checkedRows[i], 19).getValue();
					} else {
						items = items + "," + p_gridArea.cells(checkedRows[i], 14).getValue();
						cngts = cngts + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
						pjtIds = pjtIds + "," + p_gridArea.cells(checkedRows[i], 19).getValue();
					}
				} else {
					if (status != "MOD") {
						msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00143' var='WM00143' arguments='"+ cngtName +"'/>";
						alert("${WM00143}");
						p_gridArea.cells(checkedRows[i], 1).setValue(0); 
					}else if (curTask != "CLS") {
							msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00142' var='WM00142' arguments='"+ cngtName +"'/>";
							alert("${WM00142}");
							p_gridArea.cells(checkedRows[i], 1).setValue(0); 
					}
				}
			}
			
			if (items != "") {
				var url = "checkInCommentPop.do?";
				var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
			    fnOpenLayerPopup(url,data,doCallBack,617,436);
			}
		}
	}
		
	
	function doCallBack(){alert("tesT");}
	function doCallBackMove(){}
	function fnCallBack(){
		doSearchList();
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	function fnCallBack(avg){
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var isMultiCnt = 0;
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			var status = p_gridArea.cells(checkedRows[i], 15).getValue();
			var checkInOption = p_gridArea.cells(checkedRows[i], 23).getValue();
			var itemName = p_gridArea.cells(checkedRows[i], 5).getValue();
			
			if ((status == "CMP" || status == "MOD") && checkInOption == "03") {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 13).getValue();
					projectID = p_gridArea.cells(checkedRows[i], 19).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
				}
				isMultiCnt++;
				
			}
		}
		
		if (items != "") {
	
			var url = "${wfURL}.do?";
			var data = "isNew=Y&wfDocType=CS&isMulti=Y&actionType=create&isPop=N&wfDocumentIDs="+items+"&ProjectID="+projectID+"&isMultiCnt="+isMultiCnt;
					
			var w = 1200;
			var h = 550; 

			window.open(url+data,'window','width=1200, height=730, left=200, top=50,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
		}
		
		doSearchList();
		
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goApprRequest() {
		
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var isMultiCnt = 0;
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			var status = p_gridArea.cells(checkedRows[i], 15).getValue();
			var checkInOption = p_gridArea.cells(checkedRows[i], 23).getValue();
			var itemName = p_gridArea.cells(checkedRows[i], 5).getValue();
			
			if (status == "CMP" && checkInOption == "03") {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 13).getValue();
					projectID = p_gridArea.cells(checkedRows[i], 19).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
				}
				isMultiCnt++;
				
			} else if(checkInOption == "03"){
				var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
				alert("${WM00129}");
				p_gridArea.cells(checkedRows[i], 1).setValue(0); 
			}
		}
		
		if (items != "") {
	
			var url = "${wfURL}.do?";
			var data = "isNew=Y&wfDocType=CS&isMulti=Y&actionType=create&isPop=N&wfDocumentIDs="+items+"&ProjectID="+projectID+"&isMultiCnt="+isMultiCnt;
					
			var w = 1200;
			var h = 550; 

			window.open(url+data,'window','width=1200, height=730, left=200, top=50,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
		}
		
	}
	
	function goAllApprRequest() {
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var items = "";
		var cngts = "";
		var pjtIds = "";
		var status = "";
		for(var i = 0 ; i < checkedRows.length; i++ ){
			
			status = p_gridArea.cells(checkedRows[i], 15).getValue();

			if(status == "MOD") {
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 14).getValue();
					cngts = p_gridArea.cells(checkedRows[i], 13).getValue();
					pjtIds = p_gridArea.cells(checkedRows[i], 19).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 14).getValue();
					cngts = cngts + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
					pjtIds = pjtIds + "," + p_gridArea.cells(checkedRows[i], 19).getValue();
				}
			}
		}
		if (items != "") {
			var url = "checkInItem.do";
			var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	
</script>

<form name="changeInfoLstTskFrm" id="changeInfoLstTskFrm" method="post" action="#" onsubmit="return false;">
<div>	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00205}</h3>		
	</div>
	<div style="height:10px"></div>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01" id="search">
		<colgroup>
		    <col width="8%">
			<col width="18%">
			<col width="8%">
			<col width="18%">
			<col width="8%">
			<col width="18%">
			<col width="8%">
			<col width="15%">
		
	
	    </colgroup>
	    <tr>
	    	<!-- 프로젝트 -->
	       	<th class="alignL viewtop pdL10">${menu.LN00131}</th>
	        <td class="alignL viewtop pdL10"> 
	        	<select id="Project" Name="Project" style="width:80%">
		           	<option value=''>Select</option>
		           	<c:forEach var="i" items="${parentPjtList}">
		               	<option value="${i.CODE}">${i.NAME}</option>
		           	</c:forEach>
		       	</select>
	       	</td>
	       	
	       	<!-- 변경오더 -->
	       	<th class="alignL viewtop pdL10">${menu.LN00191}</th>
	        <td class="alignL viewtop pdL10">    
		       	<select id="csrList" Name="csrList" style="width:80%">
		           	<option value="">Select</option>
		       	</select>
	       	</td>
	       	
	   		<!-- 계층 -->
	       	<th class="alignL viewtop pdL10">${menu.LN00016}</th>
	       	<td class="alignL viewtop pdL10">  
	       		<select id="classCode" Name="classCode" style="width:80%">
	       			<option value=''>Select</option>
		        	<c:forEach var="i" items="${classCodeList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
	       		</select>
	       	</td>
	       	
	       	<!-- 변경구분 -->
	       	<th class="alignL viewtop pdL10">${menu.LN00022}</th>
			<td class="viewtop alignL pdL10 last">	
				<select id="ChangeType" Name="ChangeType" style="width:80%">
				</select>
			</td>
				      
	      </tr>
	      <tr> 
	      	<!-- 등록일 -->
	        <th class="alignL pdL10">${menu.LN00063}</th>
	        <td class="alignL pdL10">     
	            <font><input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="REQ_END_DT" name="REQ_END_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	         </td>
	         
	        <!-- 완료일 -->
	        <th class="alignL pdL10">${menu.LN00064}</th>
	        <td class="alignL pdL10">     
	            <font><input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="CLS_END_DT" name="CLS_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	         </td>	
	         
	          <!-- 시행일 -->
	        <th class="alignL pdL10">${menu.LN00296}</th>
	        <td class="alignL pdL10" >     
		        <font><input type="text" id="VF_STR_DT" name="VF_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	        </td>
	         
	         <!-- 상태 -->
	        <th class="alignL pdL10">${menu.LN00027}</th>
	        <td class="alignL pdL10 last">     
		        <select id="Status" Name="Status" style="width:80%">
		        	<c:forEach var="i" items="${statusList}">
		            	<option value="${i.TypeCode}" <c:if test="${isPop == 'Y' and i.TypeCode == 'CMP' }"> selected</c:if> >${i.Name}</option>
		            </c:forEach>
		        </select>
	        </td>
	         
	      </tr>
	       	
    </table>
    
    <div class="countList pdT10">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">
	      &nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()"/>	
	  	  <c:if test="${GlobalVal.APPORVAL_MULTI == '1' }">
	    	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Check in" onclick="goCSCheckIN()" type="submit"></span>
	    	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goApprRequest();"></span>
		  </c:if>
	  	  <c:if test="${GlobalVal.APPORVAL_MULTI == '2' }">
	        &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goAllApprRequest();"></span>
	      </c:if>
		 	&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
 	</div>
	
	<!-- GRID -->	
	<div id="gridCngtDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>
	</div>
	
	<!-- END :: LIST_GRID -->
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>