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
<style>
 	.mod_col {
		color:blue;
		font-weight:bold
	}
	.remain_col{
	color:#000000;
	}
</style>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<!-- 2. Script  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var p_gridArea; //그리드 전역변수(ChangeSet)
	
	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar
		fnSelect('ChangeType', '&Category=CNGT1', 'getDicWord', 'Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){fnGridExcelDownLoad();})
		
		$('#Project').change(function(){
			changeCsrList($(this).val()); // 변경오더 option 셋팅
		});
		
		changeCsrList('${myPjtId}'); // 변경오더 option 셋팅
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


	
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
				var extFunc = selectedCell[idx].ExtFunc;
				var curTask = selectedCell[idx].CurTask;
				var cngtName = selectedCell[idx].Version + " " + selectedCell[idx].AuthorName;
				var status = selectedCell[idx].StatusCode;
				
				if (status == "MOD" && (extFunc == "0" || (extFunc == "1" && curTask == "CLS"))) {
					// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
					if (items == "") {
						items = selectedCell[idx].ItemID;
						cngts = selectedCell[idx].ChangeSetID;
						pjtIds = selectedCell[idx].ProjectID;
					} else {
						items = items + "," + selectedCell[idx].ItemID;
						cngts = cngts + "," + selectedCell[idx].ChangeSetID;
						pjtIds = pjtIds + "," + selectedCell[idx].ProjectID;
					}
				} else {
					if (status != "MOD") {
						msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00143' var='WM00143' arguments='"+ cngtName +"'/>";
						alert("${WM00143}");
						selectedCell[idx].checkbox = 0;
					}else if (curTask != "CLS") {
							msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00142' var='WM00142' arguments='"+ cngtName +"'/>";
							alert("${WM00142}");
							selectedCell[idx].checkbox = 0;
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
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});	
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		var isMultiCnt = 0;
		
		for(idx in selectedCell){
			var status = selectedCell[idx].StatusCode;
			var checkInOption = selectedCell[idx].CheckInOption;
			var itemName = selectedCell[idx].AuthorName;
			
			if ((status == "CMP" || status == "MOD") && (checkInOption == "03" || checkInOption == "03B")) {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = selectedCell[idx].ChangeSetID;
					projectID = selectedCell[idx].ProjectID;
				} else {
					items = items + "," + selectedCell[idx].ChangeSetID;
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
		
		//doSearchList();
		
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
		
		for(idx in selectedCell){
			var status = selectedCell[idx].StatusCode;
			var checkInOption = selectedCell[idx].CheckInOption;
			var itemName = selectedCell[idx].AuthorName;	
			
			if (status == "CMP" && ( checkInOption == "03" || checkInOption == "03B" )) {
				// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
				if (items == "") {
					items = selectedCell[idx].ChangeSetID;
					projectID = selectedCell[idx].ProjectID;
				} else {
					items = items + "," + selectedCell[idx].ChangeSetID;
				}
				isMultiCnt++;
				
			} else if(checkInOption == "03" || checkInOption == "03B"){
				var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00129' var='WM00129' arguments='"+ itemName +"'/>";
				alert("${WM00129}");
				selectedCell[idx].checkbox = 0;
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
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});	
		var items = "";
		var cngts = "";
		var pjtIds = "";
		var status = "";
		for(idx in selectedCell){
			status = selectedCell[idx].StatusCode;
			if(status == "MOD") {
				if (items == "") {
					items = selectedCell[idx].ItemID;
					cngts = selectedCell[idx].ChangeSetID;
					pjtIds = selectedCell[idx].ProjectID;
				} else {
					items = items + "," + selectedCell[idx].ItemID;
					cngts = cngts + "," + selectedCell[idx].ChangeSetID;
					pjtIds = pjtIds + "," + selectedCell[idx].ProjectID;
				}
			}
		}
		if (items != "") {
			var url = "checkInMgt.do";
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
	<c:if test="${hideTitle ne 'Y' }">
	<div class="cop_hdtitle">
		<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00205}</h3>		
	</div>
	</c:if>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01<c:if test="${hideTitle eq 'Y' }"> mgT20</c:if>" id="search">
		<colgroup>
		    <col width="8%">
			<col width="18%">
			<col width="8%">
			<col width="18%">
			<col width="8%">
			<col width="18%">

	    </colgroup>
	    <tr>
	    	<!-- 프로젝트 -->
	  
	       	
	       	<!-- 변경오더 -->
	     
	   		<!-- 계층 -->
	 
	       	
	       	<!-- 변경구분 -->
	
	      </tr>
	      <tr> 
	      	<!-- 등록일 -->
	        <th class="alignL pdL10">${menu.LN00063}</th>
	        <td class="alignL pdL10">     
	            <input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="REQ_END_DT" name="REQ_END_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	         </td>
	         
	        <!-- 완료일 -->
	        <th class="alignL pdL10">${menu.LN00064}</th>
	        <td class="alignL pdL10">     
	            <input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="CLS_END_DT" name="CLS_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	         </td>	
	         
	          <!-- 시행일 -->
	        <th class="alignL pdL10">${menu.LN00296}</th>
	        <td class="alignL pdL10" >     
		        <input type="text" id="VF_STR_DT" name="VF_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	        </td>
	         
	         <!-- 상태 -->

	         
	      </tr>
	       	
    </table>
    
    <div class="countList pdT10">
	    <li class="count">Total <span id="TOT_CNT"></span></li>
	    <li class="floatR">
	      &nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearch();"/>	
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
<!-- 	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div> -->
	<div id="pagination"></div>
	<!-- END :: PAGING -->	
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
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
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},			
		        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align: "center",
		        	template:function (text,row,col){
		        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
		        	}	
		        },
		        { width: 90, id: "ClassCode", header: [{ text: "${menu.LN00016}" , align: "center" }, { content: "selectFilter" }],align: "center"},
		        { width: 90, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "selectFilter" }],align: "center"},
		        { width: 230, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }], align: "left" },
		        { width: 60, id: "Version", header: [{ text: "Version" , align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 170, id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }] , align: "center"},
		        { width: 170, id: "parentPjtName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 130, id: "csrName", header: [{ text: "${menu.LN00191}" , align: "center" }, { content: "selectFilter" }], align: "center"},
		        { width: 80, id: "ChangeType", header: [{ text: "${menu.LN00022}" , align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 80, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], align: "center", htmlEnable: true, 
		        	 mark: function (cell, data) { 
		        		 if(cell==='편집 중'){return "mod_col";}
		        		 else return "remain_col";
		        		  }
		        },
		        { width: 80, id: "CreationTime", header: [{ text: "${menu.LN00063}" , align: "center" }, { content: "" }], align: "center" },
		        { width: 80, id: "CompletionDT", header: [{ text: "${menu.LN00064}" , align: "center" }, { content: "" }], align: "center" },
		        { width: 80, id: "ValidFrom", header: [{ text: "${menu.LN00296}" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "ChangeSetID", header: [{ text: "ChangeSetID" , align: "" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "ItemID", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "StatusCode", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "AuthorID", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "ExtFunc", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "CurTask", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "ProjectID", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "CreationTime2", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "LastUpdated", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "ChangeTypeCode", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,width: 0, id: "CheckInOption", header: [{ text: "" , align: "" }, { content: "" }], align: "" }
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 40,
		});	
	
		function fnSearch(){
			 sqlID = "cs_SQL.getChangeSetList";
		 	let param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		 	     	+"&myCS=Y"
		 	        +"&pageNum="+$("#currPageA").val()
					+"&reqStartDt="+$("#REQ_STR_DT").val()
					+"&reqEndDt="+$("#REQ_END_DT").val()
					+"&clsStartDt="+$("#CLS_STR_DT").val()
					+"&clsEndDt="+$("#CLS_END_DT").val()
					+"&vfStartDt="+$("#VF_STR_DT").val()
					+"&vfEndDt="+$("#VF_END_DT").val()
					+"&sqlID="+sqlID;	 		
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
	 	    fnClearFilter("parentPjtName");
	 	    fnClearFilter("csrName");
	 	    fnClearFilter("ChangeType");
	 	    fnClearFilter("StatusName");
	 		
	 	    grid.data.parse(newGridData);
	 	
	 		$("#TOT_CNT").html(grid.data.getLength());
	 		fnMasterChk('');
	 	}
		
	 	function fnClearFilter(columnID) {
	 	    var changeEvent = document.createEvent("HTMLEvents");
	 	    changeEvent.initEvent("change");
// 	 	    var selectFilter = grid.getHeaderFilter(columnID).querySelector('select');
// 	 	    selectFilter.value = " ";
// 	 	    selectFilter.dispatchEvent(changeEvent);
			grid.getHeaderFilter(columnID).clear();
	 	}
	 	
		grid.events.on("cellClick", function(row, column, e) {
		    if (column.id != "checkbox") {
		    	gridOnRowSelect(row);
		    }
		});
		
		//그리드 ROW 선택시 
	 	function gridOnRowSelect(row){
			var itemId = row.ItemID;
			var changeSetID = row.ChangeSetID;
			console.log(itemId+ " "+changeSetID);
			
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
		
</script>



