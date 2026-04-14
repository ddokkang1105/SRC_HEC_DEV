<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

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


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

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

  /* (선택) 그룹 라벨 말줄임 */
  .dhx_grid-group__cell,
  .dhx_grid-group__content,
  .dhx_grid-group__title{
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .empty-placeholder {
	font-style: italic; color: #9ca3af;
}
  
/* subrow 추가/수정 */
.subrow-changeset-container { border: 1px solid #d1d5db; background-color: #fff; }
.changeset-description-textarea {
    width: 100%; height: 80px; resize: none; border: none;
    overflow-y: auto; padding: 10px; font-size: small;
}
.changeset-description-textarea.empty-placeholder { font-style: italic; color: #9ca3af; }
.changeset-files-outer-container { height: 130px; overflow-y: auto; padding: 10px; border-top: 1px solid #e5e7eb; }
.changeset-files-inner-container {
    width:100%; display:flex; justify-content: space-between; height: 100%;
    padding: 4px 10px; border: 1px solid #d1d5db; border-radius: 4px; background-color: #f9fafb;
}
.changeset-individual-file { padding: 5px 0; display: flex; align-items: center; border-bottom: 1px solid #e5e7eb; cursor: pointer; }
.changeset-buttons-container {
    width: 100%; padding: 5px 10px; border: 1px solid #d1d5db; border-top: none;
    display: flex; justify-content: end; background-color: #f3f3f3; gap: 8px;
}

/* 데이터 없음 화면 정렬 및 스타일 보정 */
.empty-wrapper {
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: center !important;
    width: 100% !important;
    height: 100% !important;
    min-height: 200px; /* 최소 높이 확보 */
    text-align: center;
}

.empty-wrapper > * {
    font-size: 15px !important; /* 텍스트 크기 강제 고정 */
    color: #666 !important;
    margin-top: 10px;
}
</style>

<script type="text/javascript">
  // ===================== 전역변수 =====================
  var screenType     = "${screenType}";
  var sessionState   = "${sessionScope.loginInfo.sessionState}";
  var myTeam         = "${myTeam}";
  var languageID     = "${sessionScope.loginInfo.sessionCurrLangType}";
  var isNotIn        = "";
  var DimTypeID      = "";
  var modStartDT     = "${modStartDT}";
  var modEndDT       = "${modEndDT}";
  var dhxModal = null;

  var layout = null;
  var changSetGrid = null;
  
  /* [주석처리] 페이징 관련 전역 변수
  var totalCount=0;
  var pagerData=null;
  */
  var PAGE_SIZE = 40; // 클라이언트 페이징용 사이즈 유지
  var pagination = null;
  
  function setWindowHeight(){
    var size = window.innerHeight;
    var height = 0;
    if (size == null || size == undefined) height = document.body.clientHeight;
    else height = window.innerHeight;
    return height;
  }

  function handleAjaxError(err, errDicTypeCode) {
    console.error(err);
    Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
      .then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
  }

  // [dimValue option] 설정
  function changeDimValue(avg){
    var url    = "getDimValueSelectOption.do";
    var data   = "dimTypeId="+avg+"&searchYN=Y";
    var target = "dimValueId";
    var defaultValue = "";
    var isAll  = "no";
    ajaxMultiSelect(url, data, target, defaultValue, isAll);
    setTimeout(function(){ $("#dimValueId")[0].sumo.reload(); }, 500);
  }

  function fnResetSelectBox(objName,defaultValue){
    $("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove();
  }

  function fnClearFilter(columnID) {
    if(!changSetGrid) return;
    var headerFilter = changSetGrid.getHeaderFilter(columnID);
    if(headerFilter){
      changSetGrid.getHeaderFilter(columnID).clear();
    }
  }

  function fnClearSearch(){
    $("#Company").val("");
    $("#REQ_STR_DT").val("");
    $("#REQ_END_DT").val("");
    $("#MOD_STR_DT").val("${modStartDT}");
    $("#MOD_END_DT").val("${modEndDT}");
    $("#VF_STR_DT").val("");
    $("#VF_END_DT").val("");

    $("#CLS_STR_DT").val("${clsStartDt}");
    $("#CLS_END_DT").val("${clsEndDt}");

    $("#authorTeamName").val("");

    if($("#dimTypeId")[0] && $("#dimTypeId")[0].sumo) $("#dimTypeId")[0].sumo.selectItem(0);
    fnResetSelectBox("dimValueId","");
    if($("#dimValueId")[0] && $("#dimValueId")[0].sumo) $('#dimValueId')[0].sumo.reload();

    fnClearFilter("ClassCode");
    fnClearFilter("Identifier");
    fnClearFilter("AuthorName");
    fnClearFilter("PjtName");
    fnClearFilter("csrName");
    fnClearFilter("ChangeType");
    fnClearFilter("StatusName");
    return;
  }

  // ======================== changeSetList API 호출 ======================== //
  /* [주석처리] reloadTotalChangeSet 전체 건수 가져오기
  async function reloadTotalChangeSet(){
    $('#loading').fadeIn(150);
    var sqlID = "cs_SQL.getChangeSetMultiListCount";
    var dvArray = [];
    var isNotYN = "N";

    if ($("#dimTypeId").val() != "") {
      $("#dimValueId :selected").each(function(i, el){
        var dvTemp = $(el).val();
        if (dvTemp != "" && "nothing" != dvTemp) {
          dvArray.push(dvTemp);
        } else {
          isNotYN = "Y";
          dvArray.push(dvTemp);
        }
      });
    }

    const requestData = {      
    		sqlID,
            languageID: languageID,
            screenType: screenType,
            pageNo: 1,
            pageRow: 1, // 최소로 호출
            
            DimValueID: $("#dimValueId").val(),
            DimTypeID: $("#dimTypeId").val(),
            isNotIn: isNotYN,
            DimValueIDOLM_ARRAY_VALUE: dvArray.join(","),

            authorTeamName: $("#authorTeamName").val(),
            reqStartDt: $("#REQ_STR_DT").val(),
            reqEndDt: $("#REQ_END_DT").val(),
            modStartDt: $("#MOD_STR_DT").val() || modStartDT,
            modEndDt: $("#MOD_END_DT").val() || modEndDT ,
            clsStartDt: $("#CLS_STR_DT").val(),
            clsEndDt: $("#CLS_END_DT").val(),
            vfStartDt: $("#VF_STR_DT").val(),
            vfEndDt: $("#VF_END_DT").val()};
            
    var CompanyID = $("#Company").val();
    if (CompanyID && CompanyID.trim() !== "") {
        requestData.Company = CompanyID;
    }

    const params = new URLSearchParams(requestData).toString();
    const url = "getData.do?" + params;

    try {
      const response = await fetch(url, { method: 'GET' });
      if (!response.ok) throw throwServerError(response.statusText, response.status);
      const result = await response.json();
      if (!result.success) throw throwServerError(result.message, result.status);
      var total2 = Number(result.data[0].CNT);
      return total2;
    } catch (error) {
      handleAjaxError(error, "LN0014");
      return [];
    } finally {
      $('#loading').fadeOut(150);
    }
  }
  */


  function fnReloadGrid(targetGrid, newGridData) {
	    if (!targetGrid) return;

	    /* [주석처리] Pagination (상태 초기화)
	    if (pagination) pagination.destructor();
	    */
	    if (pagination) pagination.destructor();
	    const safeData = Array.isArray(newGridData) ? newGridData : [];


	    if (safeData.length === 0) {
	        showEmptyDataPage("#gridCngtDiv"); 
	        targetGrid.data.parse([]);
	        $("#TOT_CNT").html("0");
	    } else {
	        deleteEmptyDataPageAndPrepareLayout();
		
	        const modifiedData = safeData.map(item => {
	            const identifierRaw = item.Identifier || "";
	            const itemNameRaw = item.ItemName || "";
	            return {
	                ...item,
	                id: item.ChangeSetID,
	                IdentifierRaw: identifierRaw,
	                ItemNameRaw: itemNameRaw,
	                __groupKey: '<img src="' + "${root}${HTML_IMG_DIR}" + '/item/' + item.ItemTypeImg + '" width="18" height="18">&nbsp;' + identifierRaw + " " + itemNameRaw
	            };
	        });

	        // 4. 데이터 그룹화 
	        targetGrid.data.removeAll();
	        targetGrid.data.parse(modifiedData);
	        targetGrid.data.group([{ by: "__groupKey" }]);

	        // 카운트 표시 (받아온 데이터의 길이로 전체 건수 표시)
	        $("#TOT_CNT").html(safeData.length);
	     //  하단에 페이지 번호가 나오게 설정 (Client-side Paging)
	        pagination = new dhx.Pagination("pagination", {
	            data: targetGrid.data, // 그리드 데이터를 직접 연결
	            pageSize: PAGE_SIZE
	        });
	     
	        /* [주석처리] Pagination 재생성 및 설정
	        pagination = new dhx.Pagination("pagination", {
	            data: pagerData,
	            pageSize: PAGE_SIZE
	        });

	        pagination.events.on("change", function(page) {
	            $("#currPageA").val(Number(page) + 1);
	            searchChangeSetGrid();
	        });

	        var pageNo = Number($("#currPageA").val() || 1);
	        pagination.setPage(pageNo - 1);
	        */
	    }

	    targetGrid.paint();
	}


  /* [주석처리] loadAllChangeSetData
  async function loadAllChangeSetData() {
    $('#loading').fadeIn(150);
    try {
      totalCount = await reloadTotalChangeSet();
      pagination.paint();
      $("#TOT_CNT").html(totalCount);
      
      var pageNo = Number(document.getElementById('currPageA').value || 1); // 1-based
      pagination.setPage(pageNo - 1); 


 	 await searchChangeSetGrid();

      return true;
    } catch (error) {
      handleAjaxError(error, "LN0014");
      return false;
    } finally {
      $('#loading').fadeOut(150);
    }
  }
  */

  // ======================== GRID 생성 ======================== //
  var allSubRowFiles = [];
  function initGrid(){

    const columns = [
		{
			  width: 100,
			  id: "Version",
			  header: [
			    { text: "Version", align: "center" },
			    { content: "selectFilter" }
			  ],
			  align: "center",
			  htmlEnable: true,
			  template: function (text, row) {
			    if (row.$group) return "";
			
			    var isExpanded = !!row.$expanded;

			    var icon = isExpanded
			      ? '<span style="display:inline-flex; align-items:center; margin-right:4px;">'
			        + '<svg width="14" height="14" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">'
			        + '<polyline points="5,7 10,12 15,7" fill="none" stroke="#3f4d67" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
			        + '</svg>'
			        + '</span>'
			      : '<span style="display:inline-flex; align-items:center; margin-right:4px;">'
			        + '<svg width="14" height="14" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">'
			        + '<polyline points="7,5 12,10 7,15" fill="none" stroke="#3f4d67" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
			        + '</svg>'
			        + '</span>';

			    return '<div style="display:flex; align-items:center; justify-content:center; cursor:pointer;">'
			      + icon
			      + '<span>' + text + '</span>'
			      + '</div>';
			  }
			},
         { width: 80, id: "ChangeType", header: [{ text: "${menu.LN00022}", align:"center" },{ content: "selectFilter" }], align:"center", htmlEnable: true,
             template: function (text, row, col) {
               var result = "";
               if (!text) return result;
               var code = row.ChangeTypeCode;
               switch (code) {
                 case "DEL" : result = '<span class="grid__cell_status-item">'+row.ChangeType; break;
                 case "MOD" : result = '<span class="grid__cell_status-item mod">'+row.ChangeType; break;
                 case "NEW" : result = '<span class="grid__cell_status-item new">'+row.ChangeType; break;
                 default : result = "";
               }
               result += '</span>';
               return result;
             }
           },
           { width: 80,id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center"},{ content: "selectFilter" }], htmlEnable: true, align: "center",
             template: function (text, row, col) {
               var result = "";
               if (!text) return result;
               var code = row.StatusCode;
               switch (code) {
                 case "MOD" : result = '<span class="grid__cell_status-item new">'+row.StatusName; break;
                 default : result = '<span class="grid__cell_status-item">'+row.StatusName; break;
               }
               result += '</span>';
               return result;
             }
           },
         { width: 100, id: "CreationTime", header: [{ text: "${menu.LN00063}" , align: "center" }, { content: "" }], align: "center" },
         { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" }, { content: "" }], align: "center" },
         { width: 100, id: "ApproveDate", header: [{ text: "${menu.LN00095}" , align: "center" }, { content: "" }], align: "center" },
         { width: 100, id: "ValidFrom", header: [{ text: "${menu.LN00296}" , align: "center" }, { content: "" }], align: "center" },
         {
           width: 130,
           id: "ClassCodeName",
           header: [{ text: "${menu.LN00016} ", align: "center" }, { content: "selectFilter" }],
           align: "center",
         },
         {  id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }], align: "center"},
         {  id: "AuthorTeamName", header: [{ text: "${menu.LN00153}" , align: "center" }, { content: "inputFilter" }], align: "center"},
         { id: "PjtName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }], align: "center" },
         { id: "csrName", header: [{ text: "${menu.LN00191}" , align: "center" }, { content: "selectFilter" }], align: "center" },
         { width:80,id: "WF",  header: [{ text: "${menu.ZLN0017}", align: "center" }], htmlEnable: true, align: "center",
        	  template: function (text, row, col) {
        		    let txt = `-`;
                   if(row?.WFInstanceID) txt = `<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" class="cur-po"
                     onclick="openAprvDetailPopup( '\${row.WFInstanceID}', '\${row.ChangeSetID}', '\${row.ProjectID}', '\${row.ItemClassCode}')"><path d="m692-156 130-135-35-33-96.29 99L652-264l-34 34 74 74ZM288-576h384v-72H288v72ZM719.77-48Q640-48 584-104.23q-56-56.22-56-136Q528-320 584.23-376q56.22-56 136-56Q800-432 856-375.77q56 56.22 56 136Q912-160 855.77-104q-56.22 56-136 56ZM144-96v-648q0-29.7 21.15-50.85Q186.3-816 216-816h528q29.7 0 50.85 21.15Q816-773.7 816-744v259q-17-7-35.03-11-18.04-4-36.97-6v-242H216v528h240q3 30 12.12 58T492-105l-12 9-56-45-56 45-56-45-56 45-56-45-56 45-56-45-56 45Zm144-216h177q5-20 13.5-37.5T498-384H288v72Zm0-132h264q26-21 56-35t64-20v-17H288v72Zm-72 228v-528 528Z"/></svg>`;
                   return txt;
                 }
         },
         { hidden:true,width: 0, id: "ChangeSetID", header: [{ text: "ChangeSetID" , align: "center" }, { content: "" }], align: "center" },
         { hidden:true,width: 0, id: "ItemID", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
         { hidden:true,width: 0, id: "StatusCode", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
         { hidden:true,width: 0, id: "AuthorID", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
         { hidden:true,width: 0, id: "CreationTime2", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
         { hidden:true,width: 0, id: "ChangeTypeCode", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" }
    ];

    layout = new dhx.Layout("grdGridArea", { rows : [{ id : "a" }] });

    changSetGrid = new dhx.Grid(null, {
      columns: columns,
      group: {
        order: function (r) { return r.__groupKey; },  
        panel: false,
        header: function (key, rows) {
        	  var id = (rows[0].IdentifierRaw || "").trim();
        	  var nm = (rows[0].ItemNameRaw || "").trim();
        	  return id + " " + nm; 
        	},
        column: { width: 250, minWidth: 200, maxWidth: 250 } 
      },
       subRowConfig: { height: 300, padding: 15, toggleIcon: false },
       subRow: function(row) {
           if(!row || row.$group) return "";
           var csID = row.ChangeSetID;
           var desc = row.Description || '작성된 내역이 없습니다.';
           var descClass = row.Description ? "" : "empty-placeholder";
           var itemName = row.ItemName;
           var itemID = row.ItemID;
           const versionText = row.Version;
           const changeType = row.ChangeType; 
           const changeStatus = row.StatusName;
      
           return `
               <div class="subrow-changeset-container">
                   <textarea id="desc-\${csID}" class="changeset-description-textarea \${descClass}" readOnly>\${desc}</textarea>
                   <div id="files-\${csID}" class="changeset-files-outer-container">Loading...</div>
               </div>
               <div class="changeset-buttons-container">
                   <span class="btn_pack medium icon">
                   <span class="confirm"></span>
                     <input
               				value="View Changelog"
               				onclick="openChangelogModal('\${itemID}',\${csID}, '\${itemName}', '\${versionText}', '\${changeType}', '\${changeStatus}' )"
               				type="submit" >
                   </span>
                   <span id="versionBtn-${csID}" class="btn_pack medium icon"></span> 
           
               </div>`;
       },
      groupable: true,
      autoWidth: true, 
      resizable: true,
      selection: "row",
      tooltip: false,
      height: "100%",
    });

    changSetGrid.events.on("afterExpand", function(rowId) {
        const rowData = changSetGrid.data.getItem(rowId);
        if (rowData && !rowData.$group) {
        	getLastChangeSet(rowData);
            expandSubrowCallback(rowData);
        }
    });
 
	 changSetGrid.events.on("cellClick", function (row, col, e) {
	  if (col.id !== "Version" || row.$group) return;
	
	  var item = changSetGrid.data.getItem(row.id);
	
	  if (item.$expanded) {
	    changSetGrid.collapse(row.id);
	    item.$expanded = false;
	  } else {
	    changSetGrid.expand(row.id);
	    item.$expanded = true;
	  }
	
	  changSetGrid.paint();
	});
 
    layout.getCell("a").attach(changSetGrid);

    /* [주석처리] Pagination 생성 (dhtmlx9)
    pagerData = new dhx.DataCollection();
    pagerData.getLength = function () {
      return Number(totalCount) || 0;
    };
    pagination = new dhx.Pagination("pagination", {
      data: pagerData,   
      pageSize: PAGE_SIZE
    });
    pagination.events.on("change", function(page){
    	  $("#currPageA").val(Number(page)+1);
    	  searchChangeSetGrid();
    });
    if (document.getElementById('currPageA')) {
    	  var pageNo = Number(document.getElementById('currPageA').value || 1); // 1-based
    	  pagination.setPage(pageNo - 1);  
    }
    */

    function resizeGridArea() {
      if(!layout) return;
      layout.config.height = setWindowHeight() - 340;
      layout.paint();
      if(changSetGrid) changSetGrid.paint();
    }
    resizeGridArea();
    window.onresize = resizeGridArea;
  }

  function openAprvDetailPopup( WFInstanceID, ChangeSetID, ProjectID, ItemClassCode) {
  	var url =  "${wfURL}.do";
  	var data = "wfInstanceID=" + WFInstanceID + "&actionType=view&changeSetID=" + ChangeSetID + "&isMulti=N&wfDocType=CS&projectID=" + ProjectID + "&docSubClass=" + ItemClassCode;
    var w = Math.min(window.innerWidth - 60, 1400);
    var h = Math.min(window.innerHeight - 120, 950);
  	openUrlWithDhxModal(url, data, title="", w, h)
  }

  const waitForElementRender = (selector) => {
      return new Promise((resolve) => {
          const el = document.getElementById(selector);
          if (el) return resolve(el);
          const observer = new MutationObserver(() => {
              const el = document.getElementById(selector);
              if (el) { observer.disconnect(); resolve(el); }
          });
          observer.observe(document.body, { childList: true, subtree: true });
      });
  };

  async function expandSubrowCallback(rowData) {
      const csID = rowData.ChangeSetID;
      const itemID = rowData.ItemID;
      let fetchedFiles = [];

      if (rowData.attachFilesLoaded) {
          const existing = allSubRowFiles.find(item => item.changeSetID === csID);
          fetchedFiles = existing ? existing.files : [];
      } else {
          fetchedFiles = await getChangesetFileInfo(itemID, languageID, csID);
          rowData.attachFilesLoaded = true;
          allSubRowFiles.push({ changeSetID: csID, files: fetchedFiles });
      }

      const filesDiv = await waitForElementRender(`files-\${csID}`);
      let filesHTML = `<div class="changeset-files-inner-container">`;
      
      if (fetchedFiles.length > 0) {
          filesHTML += `<div style="width:70%; max-height: 120px; overflow-y: auto;">`;
          fetchedFiles.forEach(file => {
              filesHTML += `
                  <div class="changeset-individual-file" onclick="toggleIndividualFileCHK('\${csID}', '\${file.Seq}')">
                      <input type="checkbox" name="chk_\${csID}_\${file.Seq}" style="margin-right:8px;" \${file.CHK==1 ? 'checked' : ''}>
                      <span style="color: #2563eb;">\${file.FileRealName}</span>
                  </div>`;
          });
          filesHTML += `</div>`;
      } else {
          filesHTML += `<div class="empty-placeholder">첨부된 파일이 없습니다.</div>`;
      }

      filesHTML += `
          <div style="min-width:180px; display:flex; align-items:flex-end; gap:5px;">
              <span class="btn_pack medium icon"><span class="download"></span><input value="Download All" type="button" onclick="downloadFiles('\${csID}', true)"></span>
              <span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="downloadFiles('\${csID}', false)"></span>
          </div></div>`;
      
      filesDiv.innerHTML = filesHTML;
  }

  async function getChangesetFileInfo(itemID, langID, csID) {
      const url = "getItemFileListInfo.do?s_itemID=" + itemID + "&languageID=" + langID + "&changeSetID=" + csID + "&isPublic=N&DocCategory=CS";
      try {
          const response = await fetch(url);
          const result = await response.json();
          return result.success ? result.data : [];
      } catch (e) { return []; }
  }

  function toggleIndividualFileCHK(csID, seq) {
      const target = allSubRowFiles.find(i => i.changeSetID == csID);
      if (target) {
          const file = target.files.find(f => f.Seq == seq);
          if (file) {
              file.CHK = file.CHK == 1 ? 0 : 1;
              const cb = document.querySelector(`input[name="chk_\${csID}_\${seq}"]`);
              if (cb) cb.checked = file.CHK == 1;
          }
      }
  }

  function downloadFiles(csID, isAll) {
      const target = allSubRowFiles.find(i => i.changeSetID == csID);
      if (!target || target.files.length === 0) return;
      const seqs = isAll ? target.files.map(f => f.Seq) : target.files.filter(f => f.CHK == 1).map(f => f.Seq);
      if (seqs.length > 0) {
          location.href = "fileDownload.do?seq=" + seqs.join(",");
      }
  }

  async function getLastChangeSet(rowData){
      $('#loading').fadeIn(150);
      const sqlID = "cs_SQL.getNextPreChangeSetID";
      const rNum = "1";
      const sqlGridList = "N";
      const csID = rowData.ChangeSetID;
      const itemID = rowData.ItemID;
      const requestData = { sqlID, itemID, changeSetID: csID, rNum, sqlGridList };
      const params = new URLSearchParams(requestData).toString();
      const url = "getData.do?" + params;

      try {
          const response = await fetch(url, { method: 'GET' });
          if (!response.ok) throw throwServerError(response.statusText, response.status);
          const result = await response.json();
          if(result.data){
              const lastChangeSetID = result.data;
              const isLast = (lastChangeSetID == csID);
              const btnDiv = await waitForElementRender(`versionBtn-${csID}`);
              let btnHtml = '<span class="confirm"></span>';
              if(isLast) {
                  btnHtml += `<input value="View Current Item" onclick="openItemPopup('\${itemID}','\${csID}')" type="button">`;
              } else {
                  btnHtml += `<input value="View Version Item" onclick="openVersionItemModal('\${itemID}', '\${csID}','\${rowData.ProjectID}', '\${rowData.AuthorID}', '\${rowData.StatusCode}', '\${rowData.Version}')" type="button">`;
              }
              btnDiv.innerHTML = btnHtml;
          }
      } catch (error) {
          handleAjaxError(error, "LN0014");
      } finally {
          $('#loading').fadeOut(150);
      }
  }

  function openItemPopup(itemID,ChangeSetID) {
      var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+itemID+
                "&scrnType=pop&screenMode=pop&option=CNGREW&changeSetID="+ChangeSetID+"&itemMainPage=/itm/itemInfo/itemMainMgt";
      itmInfoPopup(url,1200,800,itemID);
  }

  function openVersionItemModal(itemID, changeSetID, projectID, authorID, status, version) {
     var url ="viewVersionItemInfo.do?s_itemID="+itemID+"&changeSetID="+changeSetID+"&projectID="+projectID+"&authorID="
          +authorID+"&status="+status+"&version="+version;
     openUrlWithDhxModal(url,"","",1200,700);
  }

  function openChangelogModal (itemID,changeSetID, itemName, versionText, changeType, changeStatus) {
    const htmlString = `<div style="width:100%; height: 100%; overflow-y: auto;" id="changeLogModal"><div id="\${changeSetID}-layout"></div></div>`;	
    const title= "" + itemName + " " + "[" +versionText + "] " + " - " + changeType + " / " + changeStatus + "";
    async function openModalCallback (itemID, languageID, changeSetID) {
      const res = await getRevisionListData(itemID, languageID, changeSetID);
      const finalData = Array.isArray(res) && res.length > 0 ? res : [];
      const getElementTargetId = changeSetID + "-layout";
      const layoutDiv = document.getElementById(getElementTargetId);
      if (!layoutDiv) return;
      layoutDiv.innerHTML = "";
      if (layoutDiv) {
        const layout = new dhx.Layout(getElementTargetId, { cols: [{ id: "a" }] }); 
        if (finalData.length === 0) {
          layoutDiv.innerHTML = ""; 
          showEmptyDataPage("#changeLogModal");
          return;
        }
        const modalGrid =  new dhx.Grid("modalGrid", {
          columns: [
            { width: 80, id: "ItemID", header: [{ text: "ID", align:"center" }], align:"center" },
            { width: 160, id: "ItemName", header: [{ text: "명칭", align:"center" }], align:"center" },
            { width: 120, id: "ClassName", header: [{ text: "클래스", align:"center" }], align:"center" },
            { id: "Description", header: [{ text: "변경개요", align:"center" }], align:"center" },
          ],
          autoWidth: true, resizable: true, selection: "row", tooltip: false, height: "auto", data: finalData
        })
        layout.getCell("a").attach(modalGrid);
      }	
    }
    openHtmlWithDhxModal(htmlString, title, 900, 480, () => openModalCallback(itemID, languageID, changeSetID));
  }

  async function getRevisionListData(s_itemID, languageID, changeSetID) {
    $('#loading').fadeIn(150);
    const params = new URLSearchParams({ s_itemID, languageID, changeSetID }).toString();
    const url = "getRevisionCSInfoView.do?" + params;
    try {
        const response = await fetch(url, { method: 'GET' });
        if (!response.ok) throw throwServerError(response.statusText, response.status);
        const result = await response.json();
        if (!result.success) throw throwServerError(result.message, result.status);
        return (result.data && Array.isArray(result.data)) ? result.data : [];
    } catch (error) {
        handleAjaxError(error, "LN0014"); 
        return [];
    } finally {
        $('#loading').fadeOut(150);
    }
  }

  var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CCCCCC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 6H11"/><path d="M21 12H11"/><path d="M21 18H11"/><path d="M3 6h2"/><path d="M3 12h2"/><path d="M3 18h2"/><path d="M5 6v12"/></svg>';
  function showEmptyDataPage(targetSelector = "#gridCngtDiv") {
      const parent = document.querySelector(targetSelector);
      if (!parent) return;
      $(".empty-wrapper").remove();
      if (targetSelector === "#gridCngtDiv") {
          $("#grdGridArea").hide();
          $("#pagination").hide();
          parent.style.display = "flex";
          parent.style.flexDirection = "column";
          parent.style.alignItems = "center";
          parent.style.justifyContent = "center";
          parent.style.minHeight = "300px";
      } else {
          parent.style.display = "flex";
          parent.style.flexDirection = "column";
          parent.style.alignItems = "center";
          parent.style.justifyContent = "center";
          parent.style.width = "100%";
          parent.style.height = "100%";
      }
      getDicData("ERRTP", "LN0042").then((errtp042) => {
          parent.insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, "", "", "", ""));
      });
  }

  function deleteEmptyDataPageAndPrepareLayout(){
      $(".empty-wrapper").remove();
      const parent = document.querySelector("#gridCngtDiv");
      if (parent) parent.style.display = "block";
      $("#grdGridArea").show();
      $("#pagination").show();
      if(typeof resizeGridArea === "function") resizeGridArea();
  }

  // ======================== 검색 ======================== //
  async function doSearch(){
    /* [주석처리]
    $("#currPageA").val(1);
    totalCount = await reloadTotalChangeSet();
    if (pagination) {
      pagination.paint();
      pagination.setPage(0);
    }
    $("#TOT_CNT").html(Number(totalCount) || 0);
    */
    await searchChangeSetGrid();
  }
      
  async function searchChangeSetGrid(){
    $('#loading').fadeIn(150);
    const sqlID = "cs_SQL.getChangeSetMultiList";
    var dvArray = [];
    var isNotYN = "N";

    if ($("#dimTypeId").val() != "") {
      $("#dimValueId :selected").each(function(i, el){
        var dvTemp = $(el).val();
        if (dvTemp != "" && "nothing" != dvTemp) dvArray.push(dvTemp);
        else { isNotYN = "Y"; dvArray.push(dvTemp); }
      });
    }
    
    // [수정] 전체 조회를 위해 pageRow를 크게 설정
    const requestData = new URLSearchParams({
      sqlID,
      languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
      screenType: screenType,
      //pageNo: 1, 
     // pageRow: 99999,
      DimValueID: $("#dimValueId").val(),
      DimTypeID: $("#dimTypeId").val(),
      isNotIn: isNotYN,
      DimValueIDOLM_ARRAY_VALUE: dvArray.join(","), 
      authorTeamName: $("#authorTeamName").val(),
      reqStartDt: $("#REQ_STR_DT").val(),
      reqEndDt: $("#REQ_END_DT").val(),
      modStartDt: $("#MOD_STR_DT").val(),
      modEndDt: $("#MOD_END_DT").val(),
      clsStartDt: $("#CLS_STR_DT").val(),
      clsEndDt: $("#CLS_END_DT").val(),
      vfStartDt: $("#VF_STR_DT").val(),
      vfEndDt: $("#VF_END_DT").val()
    });

    var CompanyID = $("#Company").val();
    if (CompanyID && CompanyID.trim() !== "" && CompanyID !== "null") {
      requestData.set("Company", CompanyID);
    }

    const url = "getData.do?" + requestData.toString();
    try {
      const response = await fetch(url, { method: 'GET' });
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
      const result = await response.json();
      fnReloadGrid(changSetGrid, result.data);
    } catch (error) {
      showDhxAlert("ERR: " + error.message);
    } finally {
      $('#loading').fadeOut(150);
    }
  }

  // ======================== ready ======================== //
  $(document).ready(function() {
    $("input.datePicker").each(generateDatePicker);
    $("#Project").SumoSelect({parentWidth: 98});
    $("#Status").SumoSelect({parentWidth: 98, defaultValues: "${status}"});
    $("#ChangeType").SumoSelect({defaultValues: "${changeType}", parentWidth: 98});
    $("#classCode").SumoSelect({defaultValues: "${classCodes}", parentWidth: 98});
    $("#dimTypeId").SumoSelect({parentWidth: 40});
    $('#dimValueId').SumoSelect({parentWidth: 50});

    var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
    fnSelect('Company',data+'&teamType=2','getTeam','','Select');

    $("#excel").click(function (){ fnGridExcelDownLoad(); });

    $('#dimTypeId').change(function(){ changeDimValue($(this).val()); });

    initGrid();
    
    // [수정] 초기 로딩 시 doSearch 직접 호출 (페이징 주석 처리 대응)
    doSearch();
  });
</script>

<form name="changeInfoLstAdmFrm" id="changeInfoLstAdmFrm" method="post" action="#" onsubmit="return false;">
<div class="pdL10 pdR10 pdT10">
  <input type="hidden" id="item" name="item" value=""></input>
  <input type="hidden" id="cngt" name="cngt" value=""></input>
  <input type="hidden" id="pjtId" name="pjtId" value=""></input>
  <input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
  <input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>

  <div class="floatL msg" style="width:100%">
    <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00205}
  </div>
  <div style="height:10px"></div>

  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
    <colgroup>
      <col width="5%">
      <col width="15%">
    </colgroup>
    <tr>
      <th class="alignL">${menu.LN00014}</th>
      <td class="alignL last">
        <select id="Company" name="Company" class="sel"></select>
      </td>

      <th class="alignL">${menu.LN00088}</th>
      <td class="alignL">
        <select id="dimTypeId" name="dimTypeId" class="sel" style="float:left;">
          <option value=''>Select</option>
          <c:forEach var="i" items="${dimTypeList}">
            <option value="${i.DimTypeID}">${i.DimTypeName}</option>
          </c:forEach>
        </select>
        <select id="dimValueId" name="dimValueId" multiple="multiple" class="sel" style="float:left; margin-left: 5%;min-height:15px;">
          <option value="">Select</option>
        </select>
      </td>

      <th class="alignL">${menu.LN00018}</th>
      <td class="alignL last">
        <input type="text" class="stext" id="authorTeamName" name="authorTeamName" value="" style="width:92.8%;ime-mode:active;" />
      </td>
    </tr>

    <tr>
      <th class="alignL">${menu.LN00063}</th>
      <td class="alignL">
        <input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value="" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
        ~
        <input type="text" id="REQ_END_DT" name="REQ_END_DT" value="" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
      </td>

      <th class="alignL">${menu.LN00070}</th>
      <td class="alignL">
        <input type="text" id="MOD_STR_DT" name="MOD_STR_DT" value="${modStartDT}" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
        ~
        <input type="text" id="MOD_END_DT" name="MOD_END_DT" value="${modEndDT}" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
      </td>

      <th class="alignL">${menu.LN00095}</th>
      <td class="alignL">
        <input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value="${clsStartDt}" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
        ~
        <input type="text" id="CLS_END_DT" name="CLS_END_DT" value="${clsEndDt}" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
      </td>

      <th class="alignL">${menu.LN00296}</th>
      <td class="alignL">
        <input type="text" id="VF_STR_DT" name="VF_STR_DT" value="" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
        ~
        <input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="input_off datePicker text" size="8"
          style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
      </td>
    </tr>
  </table>

  <div class="mgT5" align="center">
    &nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search"
      onclick="doSearch(); return false;" style="cursor:pointer;"/>
    <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear"
      style="display:inline-block;" onclick="fnClearSearch(); return false;" >
  </div>

  <div class="countList pdT10">
    <li class="count">Total  <span id="TOT_CNT"></span></li>
    <li class="floatR">
      <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
    </li>
  </div>

  <div id="gridCngtDiv" style="width:100%;" class="clear">
    <div id="grdGridArea"></div>
    <div id="pagination"></div>
  </div>
</div>
</form>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>