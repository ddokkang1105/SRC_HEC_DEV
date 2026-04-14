<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>
<style>
    .row-css {
        background: #eef1f7 !important;
    }
</style>
<script type="text/javascript">
    var modelID = "${ModelID}";
    var gridChk = "${gridChk}";
    var grid, layout; 

    $(document).ready(function() {
        $("#layout").attr("style","height:"+(setWindowHeight() - 180)+"px;");
        window.onresize = function() { $("#layout").attr("style","height:"+(setWindowHeight() - 180)+"px;"); };

        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&modelID=${ModelID}&classCode="+"${groupClassCode}";
        fnSelect('classCode', data, 'getElementClassCode', '${classCode}', 'Select');
        fnSelect('groupClassCode', data, 'getGroupElementClassCode', '${groupClassCode}', 'Select');
        fnSelect('groupElementCode', data, 'getGroupElementCode', '${groupElementCode}', 'Select');

        //탭 전환 시 모든 입력 필드 강제 초기화
        $(":input:radio[name=gridChk]").on("change", function(){
            $("#searchValue").val(""); 
            $("#searchKey").val("Name"); 
            $("#classCode").val(""); 
            $("#groupClassCode").val(""); 
            $("#groupElementCode").val("");
            $("#showChild").prop("checked", false);
            view($(this).val());
        });

        $("#elementSearchPanel .image").click(function() { view('element'); });
        $("#groupSearchPanel .image").click(function() { view('group'); });
        $("#searchValue").keypress(function(e) { if (e.which == 13) { view('element'); } });
        $(".excel").click(function(){ fnGridExcelDownLoad(grid); });

        if(gridChk == "group") $("#group").prop('checked', true);
        else if(gridChk == "connection") $("#connection").prop('checked', true);
        else { gridChk = "element"; $("#element").prop('checked', true); }

        $("#searchKey").val("${searchKey}").attr("selected","selected");
        if("${showChild}" == "true") {$("#showChild").prop("checked",true);}

        view(gridChk);
    });

    function setWindowHeight(){var size = window.innerHeight; return (size == null || size == undefined) ? document.body.clientHeight : size; }

    function fnGetGroupElementList(classCode){
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}&classCode="+classCode;
        fnSelect('groupElementCode', data, 'getGroupElementCode', '', 'Select');
    }

    function modelPopDetail(mdlID){
        var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&modelID="+mdlID+"&scrnType=view&selectedTreeID=${s_itemID}";
        window.open(url, "", "width=1200, height=900, top=100,left=100,toolbar=no,status=no,resizable=yes");
    }

    function itemPopDetail(itmID){
        var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itmID+"&scrnType=pop";
        itmInfoPopup(url,1200,900,itmID);
    }

    function view(e){
        gridChk = e;
        $("#elementSearchPanel, #groupSearchPanel").hide();
        if(gridChk === "element") $("#elementSearchPanel").show();
        else if (gridChk === "group") $("#groupSearchPanel").show();

        if (grid) grid.destructor();
        if (layout) layout.destructor();

        layout = new dhx.Layout("layout", { rows: [{ id: "a" }] });

        var columns;
        if(gridChk === "element") {
            columns = [
		    	{ width: 350, id: "ItemName", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable : true,
		            template: (v, row) => {
		            	if(row.id == "1") return "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png'>"+row.ItemName+"</span>";
		            	if(row.ICON) return "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ICON+"'>"+row.ItemName+"</span>";
		            	return row.ItemName;
		            }
		        },
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }, { text: "" }], align: "center", type: "boolean", editable: true, sortable: false},
		    	{ id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
		    	{ width: 90, id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "AuthorName", type: "string", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 90, id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "StatusName", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "inputFilter" }], align: "center",	htmlEnable : true,
		    		template: (v, row) => {
		            	if(row.Status == "NEW1") return "<span style='color:blue;font-weight:bold'>"+v+"</span>";
		            	if(row.Status == "MOD1") return "<span style='color:orange;font-weight:bold'>"+v+"</span>";
		            	return v;
	            	}
		    	},
		    	{ hidden: true, id: "ItemID", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "ClassCode", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "AuthorID", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "Blocked", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "ElementID", header: [{ text: "" }, { text: "" }]}
		    ];
        } else if(gridChk === "group") {
            columns = [
		    	{ width: 350, id: "ItemName", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable : true,
		            template: (v, row) => {
		            	if(row.id == "1") return "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png'>"+row.ItemName+"</span>";
		            	if(row.ICON) return "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ICON+"'>"+row.ItemName;
		            	if(row.ItemTypeImg) return "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ItemTypeImg+"'> "+row.ItemName;
		            	return row.ItemName;
		            }
		        },
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }, { text: "" }], align: "center", type: "boolean", editable: true, sortable: false},
		    	{ width: 90, id: "ChildClassName", type: "string", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
		    	{ id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
		    	{ width: 90, id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "AuthorName", type: "string", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 90, id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "StatusName", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "inputFilter" }], align: "center",	htmlEnable : true,
		    		template: (v, row) => {
		            	if(row.Status == "NEW1") return "<span style='color:blue;font-weight:bold'>"+v+"</span>";
		            	if(row.Status == "MOD1") return "<span style='color:orange;font-weight:bold'>"+v+"</span>";
		            	return v;
	            	}
		    	},
		    	{ hidden: true, id: "ItemID", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "ClassCode", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "AuthorID", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "Blocked", header: [{ text: "" }, { text: "" }]},
		    	{ hidden: true, id: "ElementID", header: [{ text: "" }, { text: "" }]}
		    ];
        } else { // connection
            columns = [
					{ width: 50, id: "RNUM", header: [{ text: "No", align:"center" }, { text: "" }], align: "center"},
			    	{ width: 50, id: "FromItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }, { text: "" }], align: "center", htmlEnable : true,
			            template: (v, row) => "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.FromItemTypeImg+"'>"
			        },
			    	{ width: 100, id: "SourceClassName", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
			    	{ width: 70, id: "SourceID", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ id: "SourceName", header: [{ text: "Source Name", align:"center" }, { content: "inputFilter" }]},
			    	{ width: 50, id: "ToItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }, { text: "" }], align: "center", htmlEnable : true,
			            template: (v, row) => "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ToItemTypeImg+"'>"
			        },
			    	{ width: 100, id: "TargetClassName", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
			    	{ width: 70, id: "TargetID", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ id: "TargetName", header: [{ text: "Target Name", align:"center" }, { content: "inputFilter" }]},
			    	{ width: 130, id: "ConnectionName", header: [{ text: "Connection Name", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ hidden: true, id: "ObjectID", header: [{ text: "" }, { text: "" }]},
			    	{ hidden: true, id: "SourceItemID", header: [{ text: "" }, { text: "" }]},
			    	{ hidden: true, id: "TargetItemID", header: [{ text: "" }, { text: "" }]}
			    ];
        }

        grid = new dhx.Grid(null,  {
            columns: columns,
            group: { order: "ItemName", panel: false },
            groupable: true, autoWidth: true, resizable: true, selection: "row", tooltip: false, height: "100%",
        });
        layout.getCell("a").attach(grid);

        grid.events.on("afterEditEnd", (v, row, col) => { if (col.type === "boolean") checkChildren(row.id, v); });
        grid.events.on("cellClick", (row, col) => {
            if(col.type === "boolean") return;
            if (gridChk === "connection") {
                if(["FromItemTypeImg", "SourceClassName", "SourceID", "SourceName"].includes(col.id)) itemPopDetail(row.SourceItemID);
                if(["ToItemTypeImg", "TargetClassName", "TargetID", "TargetName"].includes(col.id)) itemPopDetail(row.TargetItemID);
                if(col.id == "ConnectionName") itemPopDetail(row.ObjectID);
            } else {
                if(row.id == "1") modelPopDetail(row.ModelID);
                else if(row.parent !== "1") {
                    if(row.ItemID) itemPopDetail(row.ItemID);
                    if(row.ChildItemID) itemPopDetail(row.ChildItemID);
                }
            }
        });
        fnReload();
    }

	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var s_itemID = "${s_itemID}";
	var MTCategory = "${MTCategory}";
	
	async function fnReload() {
		const requestData = {
		    s_itemID: s_itemID,
		    modelID: modelID,
		    gridChk: gridChk,
		    languageID: languageID,
		    MTCategory: MTCategory,
		    classCode: (gridChk === "element" ? $("#classCode").val() : undefined),
		    searchKey: $("#searchKey").val(),
		    searchValue: $("#searchValue").val(),
		    showChild: (gridChk === "element" ? $("#showChild").is(":checked") : undefined),
		    groupClassCode: (gridChk === "group" ? $("#groupClassCode").val() : undefined),
		    groupElementCode: (gridChk === "group" ? $("#groupElementCode").val() : undefined)
		};
		
		Object.keys(requestData).forEach(function(key) {
			if (requestData[key] === undefined || requestData[key] === null || requestData[key] === "") {
				delete requestData[key];
			}
		});
		
	    const params = $.param(requestData);
	    const url = "getModelElmList.do?" + params;
	
	    try {
	        const response = await fetch(url, { method: 'GET' });
	
	        if (!response.ok) {
	            throw new Error("Server response error");
	        }
	        const result = await response.json();
	        
/*	        if (!result.success) {
	            throw new Error(result.message);
	        }*/
	        if (result) {
	            fnReloadGrid(grid, result);
	        } else {
	            fnReloadGrid(grid, []);
	        }
	    } catch (error) {
	        handleAjaxError(error, "LN0014");
	    }
	}
	
	function handleAjaxError(err, errDicTypeCode) {
		console.error(err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
		.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
	
 	function fnReloadGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
		targetGrid.data.forEach(function(item) { if (item.parent === "1") targetGrid.addRowCss(item.id, "row-css"); });
 	}

    function fnEditAttr(){
        var checkedRows = grid.data.getInitialData().filter(e => e.checkbox);
        if(checkedRows.length == 0){ alert("${WM00023}"); return; }
        var itemIDs = []; var classCodes = [];
        var sID = "${sessionScope.loginInfo.sessionUserId}"; var sLev = "${sessionScope.loginInfo.sessionAuthLev}";
        for(var i = 0 ; i < checkedRows.length; i++ ){
            if(checkedRows[i].parent == "1" || checkedRows[i].id == "1") continue;
            if(checkedRows[i].Blocked != "0"){ alert("${WM00124}"); return; }
            if(sLev != "1" && sID != checkedRows[i].AuthorID){ alert("${WM00040}"); return; }
            if(checkedRows[i].ItemID) itemIDs.push(checkedRows[i].ItemID);
            if(checkedRows[i].ChildItemID) itemIDs.push(checkedRows[i].ChildItemID);
            classCodes.push(checkedRows[i].ClassCode);
        }
        itmInfoPopup("selectAttributePop.do?classCodes="+classCodes+"&items="+itemIDs+"&gridChk="+gridChk, 600, 600);
        $("#items").val(itemIDs);
    }

    function fnEditSortNum(){
        var ids = grid.data.getInitialData().filter(e => e.checkbox).map(e => e.ItemID).filter(e => e).join(",");
        if(!ids){ alert("${WM00020}"); return; }
        itmInfoPopup("openEditModelSortNum.do?modelID="+modelID+"&itemIDs="+ids, 600, 600);
    }

    function fnShowChild(){ view("element"); }

    function checkChildren(parentId, value) {
        grid.data.getInitialData().forEach(item => {
            if (item.parent === parentId) {
                grid.data.update(item.id, { checkbox: value });
                if (item.id) checkChildren(item.id, value);
            }
        });
    }
</script>
<body>
<div id="processDIV">
    <input type="hidden" id="items" name="items" >
    <div class="child_search01">
        <li class="floatL pdL20">
            <input type="radio" name="gridChk" value="element" id="element"/><label for="element">&nbsp;Object</label>
            <input type="radio" name="gridChk" value="group" id="group" class="mgL10"/><label for="group">&nbsp;Group</label>
            <input type="radio" name="gridChk" value="connection" id="connection" class="mgL10"/><label for="connection">&nbsp;Connection</label>
        </li>
    </div>
    <div id="elementSearchPanel" class="child_search01 mgB5" style="display:none;">
        <li class="floatL pdL20">
            ${menu.LN00016}&nbsp;<select id="classCode" name="classCode" class="sel" style="width:130px;"></select>&nbsp;&nbsp;&nbsp;
            <select id="searchKey" name="searchKey" style="width:80px;"><option value="Name">Name</option><option value="ID" >ID</option></select>
            <input type="text" class="text" id="searchValue" name="searchValue" value="${searchValue}" style="width:250px;">
            <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search">
            <input type="checkbox" id="showChild" name="showChild" OnClick="fnShowChild();" class="mgL20">&nbsp;<label for="showChild">Show Child</label>
        </li>
        <li class="floatR pdR20">
            <c:if test="${sessionScope.loginInfo.sessionAuthLev < 4}">
            <span class="btn_pack medium icon"><span class="edit"></span><input value="Attribute" onclick="fnEditAttr()" type="submit"></span>
            <span class="btn_pack medium icon"><span class="edit"></span><input value="Sequence" onclick="fnEditSortNum()" type="submit"></span>
            </c:if>
            <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" class="excel"></span>
        </li>
    </div>
    <div id="groupSearchPanel" class="child_search01 mgB5" style="display:none;">
        <li class="floatL pdL20">
            Element Group Class
            <select id="groupClassCode" name="groupClassCode" class="sel" OnChange="fnGetGroupElementList(this.value);" style="width:150px; margin:0 5px;"></select>
            &nbsp;Element Group
            <select id="groupElementCode" name="groupElementCode" class="sel" style="width:150px; margin:0 5px;"></select>
            <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search">
        </li>
        <li class="floatR pdR20">
            <c:if test="${sessionScope.loginInfo.sessionAuthLev < 4}">
            <span class="btn_pack medium icon"><span class="edit"></span><input value="Attribute" onclick="fnEditAttr()" type="submit"></span>
            </c:if>
            <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" class="excel"></span>
        </li>
    </div>
    <div id="gridPtgDiv" class="mgB10 mgT10"><div id="grdPtgArea" style="width:100%;"></div></div>
    <div style="width: 100%;" id="layout"></div>
</div>
</body></html>