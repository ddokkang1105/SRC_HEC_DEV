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

<script type="text/javascript">

	var screenType = "${screenType}";
	var sessionState = "${sessionScope.loginInfo.sessionState}";
	var myTeam = "${myTeam}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";

	// [서버 페이징 변수 주석 처리]
	// var PAGE_SIZE = 40;
	// var totalCount = 0;
	// var pagerData = null;
	var pagination = null; // 클라이언트 페이징용 객체

	$(document).ready(  function() {
		$("input.datePicker").each(generateDatePicker); 

		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
	    getClassCodeList();
	    getChangeTypeList();
	    
		setTimeout(function() { 
			// [서버 페이징 초기화 주석 처리]
			// initPagination(); 
			doSearch(); 
		}, 1000 ); 
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* [서버 페이징 카운트 조회 로직 주석 처리]
	async function reloadTotalChangeSet() {
		$('#loading').fadeIn(150);
		const sqlID = "cs_SQL.getChangeSetMultiListCount";
		const requestData = { ... };
		...
	}
	*/

	async function doSearch() {
		// [서버 페이징 관련 처리 주석 처리]
		// $("#currPageA").val(1);
		// totalCount = await reloadTotalChangeSet();
		// if (pagination) { pagination.paint(); pagination.setPage(0); }
		// $("#TOT_CNT").html(totalCount);
		
		await searchChangeSetGrid();
	}

	/* [서버 페이징 전용 Pagination 설정 주석 처리]
	function initPagination() {
		if (pagination) pagination.destructor();
		pagerData = new dhx.DataCollection();
		pagerData.getLength = function () { return Number(totalCount) || 0; };
		pagination = new dhx.Pagination("pagination", { data: pagerData, pageSize: PAGE_SIZE });
		pagination.events.on("change", function(page){ ... });
	}
	*/
	
	async function getClassCodeList() {
	    $('#loading').fadeIn(150);
	    const sqlID = "item_SQL.getClassCodeOption";
	    const languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	    const sqlGridList = "N";
	    const params = new URLSearchParams({ sqlID, languageID, ChangeMgt:"1",sqlGridList}).toString();
	    const url = "getData.do?" + params;

	    try {
	        const response = await fetch(url);
	        const result = await response.json();
	        if (result.data) {
	            const $select = $('#classCode');
	            $select.empty().append('<option value="">Select</option>');
	            result.data.forEach(item => {
	                $select.append($('<option>').val(item.CODE).text(item.NAME));
	            });
	            if ($select[0].sumo) $select[0].sumo.unload();
	            $select.SumoSelect({ defaultValues: "${classCodes}", parentWidth: 98 }); 
	        }
	    } catch (error) {
	        handleAjaxError(error, "LN0014");
	    } finally {
	        $('#loading').fadeOut(150);
	    }
    }
    
    async function getChangeTypeList() {
	    $('#loading').fadeIn(150);
	    const sqlID = "common_SQL.getDicWord_commonSelect";
	    const sessionCurrLangType = "${sessionScope.loginInfo.sessionCurrLangType}";
	    const sqlGridList = "N";
	    const params = new URLSearchParams({ sqlID, sessionCurrLangType, Category:"CNGT1",sqlGridList}).toString();
	    const url = "getData.do?" + params;

	    try {
	        const response = await fetch(url);
	        const result = await response.json();
	        if (result.data) {
	            const $select = $('#ChangeType');
	            $select.empty().append('<option value="">Select</option>');
	            result.data.forEach(item => {
	                $select.append($('<option>').val(item.CODE).text(item.NAME));
	            });
	            if ($select[0].sumo) $select[0].sumo.unload();
	            $select.SumoSelect({ defaultValues: "${ChangeType}", parentWidth: 98 });
	        }
	    } catch (error) {
	        handleAjaxError(error, "LN0014");
	    } finally {
	        $('#loading').fadeOut(150);
	    }
    }
    
    function handleAjaxError(err, errDicTypeCode) {
		console.error(err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

	function goInfoView(avg1, avg2, avg3){
			
	var url = "viewItemCSInfo.do";
	var data = "changeSetID="+avg1+"&StatusCode="+avg2
	+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&s_itemID=${s_itemID}"
	+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&currPageA=1"
	+ "&myPjtId=${myPjtId}&itemID="+avg3;
			
		var w = 1200;
		var h = 500; 
	  openUrlWithDhxModal(url, data, title="", w, h)
		//itmInfoPopup(url,w,h);
	}
	
	function fnClearSearch(){
		$("#ChangeType")[0].sumo.selectItem(0);
		$("#MOD_STR_DT").val("${modStartDT}");
		$("#MOD_END_DT").val("${modEndDT}");
		$("#VF_STR_DT").val("");
		$("#VF_END_DT").val("");
		$("#version").val("");
		$("#searchValue").val("");
		$("#authorName").val("");
		$("#authorTeamName").val("");
		$("#relatedTeamName").val("");
		$("#identifier").val("");
		return;
	}

	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}
</script>

<form name="changeInfoLstAdmFrm" id="changeInfoLstAdmFrm" method="post" action="#" onsubmit="return false;">
<div class="pdL10 pdR10 pdT10">	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="1"></input>
	
	<div><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;사내표준(전체)
	</div><div style="height:10px"></div>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">	
			<col width="5%">
			<col width="15%">
	    </colgroup>
	    <tr>
	       	<th class="alignL">표준유형</th>
	       	<td class="alignL">
	       		<select id="classCode" Name="classCode" multiple="multiple" class="sel" style="width:92.8%;ime-mode:active;">
	       		</select>
	       	</td>
	       	<th class="alignL">표준번호</th>
			<td class="alignL last" >  
				<input type="text" class="stext" id="identifier" name="identifier" value="" style="width:92.8%;ime-mode:active;"/>   
			</td>
	       	<th class="alignL">표준명</th>
	       	<td class="alignL">
	       		<input type="text" class="stext" id="searchValue" name="searchValue" value="" style="width:92.8%;ime-mode:active;"/>   
	       	</td>
	       	<th class="alignL">개정번호</th>
	       	<td class="alignL">
	       		<input type="text" class="stext" id="version" name="version" value="" style="width:92.8%;ime-mode:active;"/>   
	       	</td>
	        <th class="alignL">표준 ${menu.LN00004}</th>
	        <td class="alignL">
	        	<input type="text" class="stext" id="authorName" name="authorName" value="" style="width:92.8%;ime-mode:active;" />   
	        </td>	
	      </tr>
	      <tr> 
	       	<th class="alignL">주관조직</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="authorTeamName" name="authorTeamName" value="" style="width:92.8%;ime-mode:active;" />   
	       	</td>
	        <th class="alignL">${menu.ZLN021}</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="relatedTeamName" name="relatedTeamName" value="" style="width:92.8%;ime-mode:active;" />   
	       	</td> 	       	
	        <th class="alignL">${menu.LN00022}</th>
	        <td class="alignL">  
				<select id="ChangeType" Name="ChangeType" class="sel" style="width:92.8%;ime-mode:active;">
				</select>
			</td> 
	        <th class="alignL">${menu.LN00070}</th>
	        <td class="alignL">
	            <input type="text" id="MOD_STR_DT" name="MOD_STR_DT" value="${modStartDT}" class="input_off datePicker stext" size="8"
					style="width: 95px; min-width: 90px;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
				~
				<input type="text" id="MOD_END_DT" name="MOD_END_DT" value="${modEndDT}" class="input_off datePicker stext" size="8"
					style="width: 95px; min-width: 90px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
	        </td>		       	
	        <th class="alignL">최신 개정일</th>
	        <td class="alignL">
	        	<input type="text" id="VF_STR_DT" name="VF_STR_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 95px; min-width: 90px;" onchange="this.value = makeDateType(this.value);" maxlength="10" >
				~
				<input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width: 95px; min-width: 90px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
	        </td>
	      </tr>
    </table>
    
	<div class="mgT5" align="center">
		&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearch()" style="cursor:pointer;"/>
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
	</div>
	
    <div class="countList pdT10">
    <ul>
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
		</ul>
 	</div>
	
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</div>
</form>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

<script>
		document.querySelector("#layout").style.height = setWindowHeight() - 340+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 340+"px"
		};
	
		const layout = new dhx.Layout("layout", {
			    rows: [ { id: "a" } ]
			});
		
		let gridConfig = [
		        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
		        { width: 130, id: "ClassCodeName", 	header: [{ text: "표준유형" , align: "center" }], align: "center" },  
		        { width: 150, id: "Identifier", 	header: [{ text: "표준번호" , align: "center" }], align: "center" },  
		        { width: 500, id: "ItemName",   	header: [{ text: "${menu.ZLN018}" , align: "center" }], align: "left" },  
		        { width: 70, id: "Version",    	header: [{ text: "${menu.LN00356}" , align: "center" }], align: "center" },  
		        { id: "AuthorName", 	header: [{ text: "표준 ${menu.LN00004}" , align: "center" }], align: "center" },  
		        { id: "AuthorTeamName", 	header: [{ text: "${menu.ZLN019}" , align: "center" }], align: "center" },  
		        { width: 300,id: "RelatedTeamNameList", 	header: [{ text: "${menu.ZLN021}" , align: "center" }], align: "center" },  
		        { id: "StatusName", 	header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" }, 
		        { id: "LastUpdated", 	header: [{ text: "수정일" ,      align: "center" }], align: "center" },  
		        { id: "ValidFrom", 		header: [{ text: "최신 개정일" , align: "center" }], align: "center" },  
		        { width: 130, id: "PjtName",    	header: [{ text: "${menu.LN00131}" , align: "center" }], align: "center" ,hidden: true },  
		        { width: 130, id: "csrName",    	header: [{ text: "${menu.LN00191}" , align: "center" }], align: "center" ,hidden: true },  
		        { width: 130, id: "ChangeType", 	header: [{ text: "${menu.LN00022}" , align: "center" }], align: "center" },  
		        { width: 130, id: "ChangeSetID", 	header: [{ text: "ChangeSetID" ,      align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "ItemID", 		header: [{ text: "ItemID" ,           align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "StatusCode", 	header: [{ text: "StatusCode" ,      align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "AuthorID", 		header: [{ text: "AuthorID" ,         align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "CreationTime2", 	header: [{ text: "CreationTime2" ,   align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "LastUpdated_Hide", 	header: [{ text: "LastUpdated" ,      align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "ChangeTypeCode", header: [{ text: "ChangeTypeCode" ,  align: "center" }], align: "center", hidden: true },  
	        ];
	
		const grid = new dhx.Grid("", {
		    columns: gridConfig,
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
	
		layout.getCell("a").attach(grid);
		
		async function searchChangeSetGrid() {
		    $('#loading').fadeIn(150);

		    const sqlID = "cs_SQL.getChangeSetMultiList";
		    const requestData = new URLSearchParams({
		        sqlID: sqlID,
		        languageID: languageID,
		        screenType: screenType,
		        // [서버 페이징 파라미터 주석 처리]
		        // pageNo: 1,
		       // pageRow: 1000, // 최대 1000건을 한 번에 가져오도록 설정
		        searchValue: $("#searchValue").val() || "",
		        authorName: $("#authorName").val() || "",
		        RelatedTeam:"Y"
		    });

		    if (screenType === "PG" || screenType === "PJT") { requestData.set("refID", "${refID}"); }
		    if ($("#identifier").val()) requestData.set("identifier", $("#identifier").val());
		    if ($("#authorTeamName").val()) requestData.set("authorTeamName", $("#authorTeamName").val());
		    if ($("#relatedTeamName").val()) requestData.set("relatedTeamName", $("#relatedTeamName").val());
		    if (typeof myTeam !== "undefined" && myTeam !== "") requestData.set("myTeam", "Y");

	
			let ccArray = $("#classCode").val() || [];
			if (ccArray.length > 0) {
			    requestData.set("classCodeList", ccArray.join(",")); 
			}

		    if ($("#ChangeType").val()) requestData.set("changeType", $("#ChangeType").val());
		    if ($("#version").val()) requestData.set("version", $("#version").val());

		    const dateFields = [
		        { start: "#VF_STR_DT",  end: "#VF_END_DT",  prefix: "vf" },
		        { start: "#MOD_STR_DT", end: "#MOD_END_DT", prefix: "mod" }
		    ];

		    dateFields.forEach(field => {
		        let startVal = $(field.start).val();
		        let endVal = $(field.end).val();
		        if (startVal) {
		            requestData.set(field.prefix + "StartDt", startVal.replace(/-/g, ""));
		            requestData.set(field.prefix + "EndDt", endVal.replace(/-/g, ""));
		        }
		    });

		    const url = "getData.do?" + requestData.toString();

		    try {
		        const response = await fetch(url, { method: 'GET' });
				const result = await response.json();
		        
		        if (result && result.data) {
		            grid.data.removeAll();
		            grid.data.parse(result.data);
                    
                    $("#TOT_CNT").html(result.data.length);

                    // [클라이언트 페이징 적용]
                    if (pagination) pagination.destructor();
                    
                    pagination = new dhx.Pagination("pagination", {
                        data: grid.data,
                        pageSize: 40
                    });

		        } else {
		            grid.data.removeAll();
                    $("#TOT_CNT").html(0);
                    if (pagination) pagination.destructor();
		        }
		    } catch (error) {
		        console.error("Search Error:", error);
		        if (typeof showDhxAlert === 'function') showDhxAlert("ERR: " + error.message);
		    } finally {
		        $('#loading').fadeOut(150);
		    }
		}
		
		function doExcel() {	
			if(grid.data.getLength() == 0) {
				alert("조회 결과가 없습니다. 먼저 조회를 해주세요.");
				return;
			}
			const now = new Date();
			const formattedDateTime = now.getFullYear() 
			                        + String(now.getMonth() + 1).padStart(2, '0') 
			                        + String(now.getDate()).padStart(2, '0') 
			                        + String(now.getHours()).padStart(2, '0') 
			                        + String(now.getMinutes()).padStart(2, '0');
			var fileName = "changeSetList_" + formattedDateTime;
			
			// 그리드에 로드된 전체 데이터를 바로 추출
			fnGridExcelDownLoad(grid, "", fileName);
	    }
		
		grid.events.on("cellClick", function(row,column,e){
			if(column.id == "Version") {
				goInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
			} else {
				var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+row.ItemID
						+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+row.ChangeSetID+"&itemMainPage=/itm/itemInfo/itemMainMgt";
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,row.ItemID);
			}
		}); 
</script>