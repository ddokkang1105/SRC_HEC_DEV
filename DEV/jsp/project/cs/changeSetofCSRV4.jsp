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
<style>

	.grid__cell_status-item {
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
	    background: rgba(0, 0, 0, 0.05);
	    font-size: 14px;
	}
	
	.grid__cell_status-item.new{
		background: rgba(2, 136, 209, 0.1);
	   	color: #0288D1;
	}
	
	.grid__cell_status-item.mod{
		background: rgba(10, 177, 105, 0.1);
	   	color: #0ab169;
	}
</style>
<script type="text/javascript">
//전역변수 
	var csrID = "${csrID}" ;
	var csrStatus = "${csrStatus}" ;
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var viewType
	
	$(document).ready(function() {
		fnSelect('Status','&category=CNGSTS','getDictionaryOrdStnm','', 'Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdCngtGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdCngtGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		reloadItemChangeSet();
		//memberList
		getMemberList();
		//classCodeList
		getClassCodeList();
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
		searchCSList();
	
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
	
	// changeSetRequest > 변경 항목 데이터 API호출
	async function reloadItemChangeSet(){
		
		$('#loading').fadeIn(150);
		var sqlID = "cs_SQL.getChangeSetList";
	    const requestData = { sqlID,csrID,languageID };

        for (const [key, value] of Object.entries(requestData)) {
        	 if (value === undefined || value === null || value === "") {
        		  console.error(key+" 가 필요합니다.");
        	 }
        }

	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    try {
	        const response = await fetch(url, {
	            method: 'GET',
	        });     
	        if (!response.ok) {
	        	// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(response.statusText, response.status);
	        }       
	        const result = await response.json();     
	        if (!result.success) {
				throw throwServerError(result.message, result.status);
			}   
	        if(result.data){
	        
	            fnReloadGrid(result.data);
	            return true;
	        } else {
	        	throw new Error(`Problem with data occured: ${data}`)
	        }     
	    } catch (error) {
	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.    	
	    } finally {
	    	$('#loading').fadeOut(150);
	    }
	}
	
	function handleAjaxError(err, errDicTypeCode) {
		console.error(err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
	

// getMemberListAPI 

    async function getMemberList(){
       
   
        $('#loading').fadeIn(150);
        const sqlID = "project_SQL.getProjectMemberList";
        const Creator = "${Creator}";
        const projectID = "${myPjtId}";
        const sqlGridList = "N";
   
        const requestData = {sqlID,Creator,s_itemID:projectID,sqlGridList};
        //param 필수체크 
        for (const [key, value] of Object.entries(requestData)) {
          	 if (value === undefined || value === null || value === "") {
          		  console.error(key+" 가 필요합니다.");
          	 }
          }
        const params = new URLSearchParams(requestData).toString();
        const url = "getData.do?" + params;
  
        try {
            const response = await fetch(url, { method: 'GET' });
            if (!response.ok) throw throwServerError(response.statusText, response.status);
            const result = await response.json();
   
            if(result.data){
                // 1. 기존 옵션 초기화 (첫 번째 'Select' 옵션은 남겨둠)
            	   const $select = $('#members');
            	   $select.empty().append('<option value="">Select</option>');
            	 
            	    // 2. 응답받은 데이터를 순회하며 옵션 추가
            	  result.data.forEach(item => {
            	   const option = $('<option>').val(item.MemberID).text(item.Name);
            	   $select.append(option);
            	 });

            }
        } catch (error) {
            handleAjaxError(error, "LN0014");
        } finally {
            $('#loading').fadeOut(150);
        }
    }
    
    //getClassCodeList 
    async function getClassCodeList(){
        
    	   
        $('#loading').fadeIn(150);
        const sqlID = "item_SQL.getClassCodeOption";
        const sqlGridList = "N";
   
        const requestData = {sqlID,languageID,ChangeMgt:"1",sqlGridList};
        //param 필수체크 
        for (const [key, value] of Object.entries(requestData)) {
       	 if (value === undefined || value === null || value === "") {
       		  console.error(key+" 가 필요합니다.");
       	 }
       }
        const params = new URLSearchParams(requestData).toString();
        const url = "getData.do?" + params;
  
        try {
            const response = await fetch(url, { method: 'GET' });
            if (!response.ok) throw throwServerError(response.statusText, response.status);
            const result = await response.json();
   
            if(result.data){
                // 1. 기존 옵션 초기화 (첫 번째 'Select' 옵션은 남겨둠)
            	   const $select = $('#classCode');//ID가 classCode인 <select> 요소를 찾아 $select 변수에 할당
            	   $select.empty().append('<option value="">Select</option>');
            	 
            	    // 2. 응답받은 데이터를 순회하며 옵션 추가
            	  result.data.forEach(item => {
            	   const option = $('<option>').val(item.CODE).text(item.NAME);
            	   $select.append(option);
            	 });

            }
        } catch (error) {
            handleAjaxError(error, "LN0014");
        } finally {
            $('#loading').fadeOut(150);
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
	       		</select>
	       	</td>
	       	<!-- 담당자 -->
	       	<th class="viewtop">${menu.LN00004}</th>
	       	<td class="viewtop alignL">
	       		<select id="members" Name="members" style="width:90%">
	       		</select>
	       	</td>
	       	<!-- 상태 -->
	        <th class="viewtop">${menu.LN00027}</th>
	        <td class="viewtop alignL">     
		        <select id="Status" Name="Status" style="width:90%"></select>
	        </td>	        
	        <td class="viewtop last alignR">
				<li class="floatC" style="display:inline">
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="searchCSList()"/>
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


	var layout = new dhx.Layout("grdCngtGridArea", {
		rows : [ {
			id : "a",
		}, ]
	});	


	var grid = new dhx.Grid("grdCngtGridArea", {
		  columns: [
				{ hidden:true,width: 120, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center"},
				{ hidden:true,minWidth: 180, gravity: 1, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" }], align: "left" },
				
				{  width: 50,id: "checkbox",
					  header: [{
					    htmlEnable: true,
					    text: "<input type='checkbox' onclick='fnMasterChk(this.checked)'>",
					    align: "center"
					  }],
					  align: "center",
					  type: "boolean",
					  editable: true,
					  sortable: false,
					  template: function(val, row){
						    if (row && row.$group) return "";   // 그룹행에는 체크박스 안 그림
						    return val;                         // 일반행은 기본 boolean 렌더링
						  }
					},
				{ width: 80, id: "ChangeType", header: [{ text: "${menu.LN00022}" , align: "center" }] , align: "center"},
				{ width: 80,id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center"},{ content: "selectFilter" }], htmlEnable: true, align: "center",
    	        	template: function (text, row, col) {
    	        		var result = "";
    	        		if (!text) return result;
						var code = row.StatusCode;
    	                switch (code) {
    	        			case "MOD" : result = '<span class="grid__cell_status-item new">'+row.StatusName; break;
    	        			default : result = '<span class="grid__cell_status-item">'+row.StatusName; break;
    	    			}
    	                result += '</span>'
    	        		return result ; 
    	         }}, 
    			{ width:130,id: "ClassCode", header: [{ text: "${menu.LN00016}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ minWidth: 150, id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" },{ content: "selectFilter" }] , align: "center"},
				{ width: 130, id: "TeamName", header: [{ text: "${menu.LN00153}" , align: "center" }], align: "center"},
				{ width: 100, id: "CreationTime", header: [{ text: "${menu.LN00078}" , align: "center" }], align: "center"},
	
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
	   group: {
				  order: function (r) {
				    return r.ClassCode 
				  },
				  panel: false,
				  header: function (key, rows) {
				    return rows.ClassCode;
				  }
				},	
		groupable: true,
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false
	});

	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());
	
	var pagination = new dhx.Pagination("pagination", {
		data: grid.data,
		pageSize: 40,
	});		


	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		// 1. 그룹 행 클릭 방지
		if (row.$group || row.isGroup || e?.target?.closest(".dhx_grid-group-row")) {
	        return false;
	    }
		 if (e?.target?.closest(".dhx_grid-expand-cell-icon")||column.id==="group") {
			    return false;
			  }
		 
		  if (column.id === "checkbox") {
			    return false;
			  }

			  if(column.id != "ItemTypeImg"){
			    goInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
			  } else {
			    gridOnRowSelect(row);
			  }
	}); 
	
	function fnReloadGrid(newGridData){
		// 1. 기존 그룹 해제 (깨짐 방지)
	    grid.data.ungroup(); 
	    
	    // 2. 데이터 가공
	    const modifiedData = newGridData.map(item => {
	        if (item.ItemTypeImg) {
	            const currentClassCode = item.ClassCode || "";
	            return { 
	                ...item, 
	               
	               
	          	    __groupKey: '<img src="${root}${HTML_IMG_DIR}/item/'+item.ItemTypeImg+'" width="18" height="18">&nbsp;'+item.Identifier +" "+ item.ItemName
	            };
	        }
	        return item; 
	    });
	    
	    // 3. 데이터 파싱
	    grid.data.parse(modifiedData);
	   // grid.data.group([{ by: "__groupKey" }]);

	    // 4. 그룹핑 설정 수정 
	    if (grid.data.getLength() > 0) {
	        grid.data.group([ 
	            { 
	                by: "__groupKey", 
	                header: function (key) { return key; } 
	            }
	        ]); 
	    }
	    
		  if (grid.config && grid.config.group) {
			  grid.config.group.column = grid.config.group.column || {};
			  grid.config.group.column.width = 300;
			  grid.config.group.column.minWidth = 300;
			  grid.config.group.column.maxWidth = 300;
			  }

	    // 5. 카운트 및 체크박스 초기화
	    $("#TOT_CNT").html(grid.data.getLength());
	    grid.data.forEach(function(item){
	        if (!item.$group) {
	            grid.data.update(item.id, { checkbox: false });
	        }
	    });
	}
 	
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
		var url = "viewItemCSInfo.do?changeSetID="+avg1+"&StatusCode="+avg2+"&itemID="+avg3
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
		searchCSList();
	
		$(".popup_div").hide();
		$("#mask").hide();	
	}

	async function searchCSList(){
		const sqlID = "cs_SQL.getChangeSetList";
		const requestData = new URLSearchParams({
			csrID,
			languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			sqlID
	
	    });

		let params = new URLSearchParams(requestData).toString();	
		// 계층
		if($("#classCode").val() != '' & $("#classCode").val() != null){
			params = params +"&classCode="+ $("#classCode").val();
		}
		// 담당자
		if($("#members").val() != '' & $("#members").val() != null){
			params = params +"&AuthorID="+ $("#members").val();
		}
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			params = params +"&Status=" + $("#Status").val();
		}
	 
		 const url = "getData.do?" + params;	
		  try {
		    	const response = await fetch(url, { method: 'GET' });
		        
		        if (!response.ok) {
		            throw new Error(`HTTP error! status: ${response.status}`);
		        }	        
		        const result = await response.json();  	
		        fnReloadGrid(result.data);	    
		    } catch (error) {
		    	showDhxAlert("ERR: " + error.message);
		    } finally {
		    	$('#loading').fadeOut(150);
		    }
	}
	


</script>