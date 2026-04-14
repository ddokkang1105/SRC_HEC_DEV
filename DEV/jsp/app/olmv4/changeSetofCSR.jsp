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

<!-- icons -->
<link rel="stylesheet" href="//cdn.materialdesignicons.com/5.4.55/css/materialdesignicons.min.css" />
<script type="text/javascript">
	var gridData = ${gridData};
	var statusCSS;
	
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center", editable: false },
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" }], htmlEnable: true, align:"center",editable: false , template: function (text, row, col) {
                return "<img src=${root}${HTML_IMG_DIR_ITEM}"+text+">";
            } },
	        { width: 150, id: "ClassCode", header: [{ text: "${menu.LN00016}" }, { content: "selectFilter" }] },
	        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}" }, { content: "inputFilter" }] },
	        { id: "ItemName", header: [{ text: "${menu.LN00028}" }, { content: "inputFilter" }], gravity:1 },
	        { width: 100, id: "ChangeType", header: [{ text: "${menu.LN00022}" }, { content: "selectFilter" }] },
	        { width: 100, id: "AuthorName", header: [{ text: "${menu.LN00004}" }, { content: "selectFilter" }] },
	        { width: 100, id: "TeamName", header: [{ text: "${menu.LN00153}" }, { content: "selectFilter" }] },
	        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" }, { content: "selectFilter" }] , htmlEnable: true, align:"center", template: function (text, row, col) {
	        		switch (row.StatusCode) {
	        			case "MOD" : statusCSS = "mod"; break;
	        			case "CLS" : statusCSS = "cls"; break;
	        		}
                	return '<div class="grid__cell_status-item '+statusCSS+'">'+text+'</div>';
            	}
	        },
	        { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00078}" }], type: "date", dateFormat: "%Y-%m-%d"},
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return "<span class='action-buttons'><a class='edit-button'><i class='mdi mdi-pencil dhx_demo-exam-grid__controls__icon'></i></a><a class='remove-button'><i class='mdi mdi-delete dhx_demo-exam-grid__controls__icon'></i></a></span>"
	            }
	        }
	    ],
	    eventHandlers: {
	        onclick: {
	            "remove-button": function (e, data) {
	                grid.data.remove(data.row.id);
	            },
	            "edit-button": function (e, data) {
	                openEditor(data.row.id);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    editable: true,
	    data: gridData
	});
	
	var rowId1 = grid.data.getId(1);

	grid.addRowCss(rowId1, "my_сustom_сlass");
	
	function openEditor(id) {
	    editWindow.show();
	    const item = grid.data.getItem(id);
	    if (item) {
	        editForm.setValue(item);
	    }
	}
	
	// initializing Widnow for the editing form
	var editWindow = new dhx.Window({
		title: "Edit",
	    width: 440,
	    height: 450,
	    modal: true
	});
	
	// datapicker dhtmlxJsInc.jsp line9,11 주석처리해야 사용가능
	var editFormConfig = {
	        padding: 0,
	        rows: [
	            {
	                id: "id",
	                type: "input",
	                name: "id",
	                hidden: true
	            },
	            {
	                type: "input",
	                name: "Identifier",
	                label: "${menu.LN00015}"
	            },
	            {
	                type: "input",
	                name: "ItemName",
	                label: "${menu.LN00028}"
	            },
	            {
	                type: "datepicker",
	                name: "CreationTime",
	                label: "date",
	                dateFormat: "%Y-%m-%d"
	            },
	            {
	                align: "end",
	                cols: [
	                    {
	                        id: "apply-button",
	                        type: "button",
	                        text: "Apply",              
	                        icon: "mdi mdi-check",
	                        circle: true,
	                    }
	                ]
	            }
	            
	        ]
	    }
	
	// initializing Form for the editing form
	var editForm = new dhx.Form(null, editFormConfig);
	// assign a handler to the Click event of the button with the id="apply-button"
	// pressing the Apply button will get all data of the form, update data of the edited item, and close the editing form
	editForm.getItem("apply-button").events.on("click", function () {
	    var newData = editForm.getValue();
	    if (newData.id) {
	        grid.data.update(newData.id, { ...newData })
	        grid.scrollTo(newData.id, "title");
	    }
	    closeEditor();
	});
	
	function closeEditor() {
	    editForm.clear();
	    editWindow.hide();
	}
	
	editWindow.attach(editForm);
	
// 	grid.events.on("cellClick", function () {
//         var loginUser = "${sessionScope.loginInfo.sessionUserId}";
// 		var authorId = arguments[0].AuthorID;
// 		var itemId = arguments[0].ItemID;
// 		var changeType = arguments[0].ChangeTypeCode;
// 		var changeSetID = arguments[0].ChangeSetID;
// 		var statusCode = arguments[0].StatusCode;
// 		var header = arguments[1].id;
		
// 		/* 변경항목 수정 화면으로 이동 */
// 		// 파라메터 :ChangeSetID, StatusCode, 담당자 여부
// 		if(header != "action"){
// 			if (header == "ItemTypeImg") {
// 				// 구분 칼럼 Click : Item popup 표시
// 				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;

// 				var w = 1200;
// 				var h = 900;
// 				itmInfoPopup(url,w,h,itemId);
// 			} else {
// 				goInfoView(changeSetID, statusCode,itemId);
// 			}
// 		}
// 	});
	
	// [Row Click] 이벤트
	function goInfoView(avg1, avg2, avg3){	
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2+"&itemID="+avg3
				+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&mainMenu=${mainMenu}"
				+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}";
		var w = 1200;
		var h = 500; 
		itmInfoPopup(url,w,h);
	}
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grid").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};

	// 첫 로드 페이지에서 filtering 되도록 하는 부분
	var changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);

    var headerFilter = grid.getHeaderFilter("ClassCode");
    var element;
    element = headerFilter.querySelector("select");
    element.value = "지침서";
    element.dispatchEvent(changeEvent);
</script>
<style>
	.edit {
		background: #4CAF50;
		color: #FFF
	}
	.my_сustom_сlass {
		background: greenyellow;
	}
	.grid__cell_status-item {
	    background: rgba(0,0,0,.05);
	    color: #8792a7;
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
    }
    .mod {
    	color: #0ab169;
    }
    .cls {
    	color:#ff5252;
    }
    .dhx_demo-exam-grid__controls__icon {
	    color: #fff;
	    width: 16px;
	    height: 16px;
	    font-size: 16px;
	    line-height: 16px;
	}
</style>
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	<div class="title-section">
		${menu.LN00082}
		<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" onClick="exportXlsx()"></span>
	</div>
	
	<div style="width: 100%" id="grid"></div>
	<div id="pagination"></div>
	
	<div id="gridCngtDiv" >	
	   	<input type="hidden" id="item" name="item" value=""></input>
		<input type="hidden" id="cngt" name="cngt" value=""></input> 
		<input type="hidden" id="pjtId" name="pjtId" value=""></input>
		<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>	
	</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

