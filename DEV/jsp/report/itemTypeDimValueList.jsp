<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 1. Include CSS/JS -->
<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;}
	
</style>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00030" var="WM00030"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00031" var="WM00031"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>

<script>
	var dimTypeID = "${dimTypeID}";
	var dimensionCache = {};
	const  dimValName = "";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
		// 엑셀 버튼 클릭 시, 엑셀 다운로드
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});

		loadItemTypeCodeList();

	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	// 상단 select 박스 리스트 호출
	async function loadItemTypeCodeList() {
		try {
	        const params = new URLSearchParams({
	            sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
				sqlGridList: "N",
				sqlID: "report_SQL.getItemTypeCodeFromItemDim"
	        });

			const url = "getData.do?" + params;

			const response = await fetch(url, { method: "GET" });
			if (!response.ok) throw new Error("Failed to load itemTypeCodeList");

			const result = await response.json();
			const list = result?.data || []; 

			const select = document.getElementById("ItemTypeCode");

			select.innerHTML = '<option value="">Select</option>';

			list.forEach(item => {
				const opt = document.createElement("option");
				opt.value = item.CODE;
				opt.textContent = item.NAME;
				select.appendChild(opt);
			});
		} catch (e) {
			console.error("loadItemTypeCodeList error:", e);
		}
	}

	var layout = new dhx.Layout("excelGridArea", { rows: [{ id: "a" }] });
	
	// 그리드 컬럼 정의
	const baseCols = [
	    { width: 50, id: "RNUM",       header: [{ text: "${menu.LN00024}", align: "center" }], align: "center", sort: "int" },
	    { width: 80, id: "Identifier", header: [{ text: "${menu.LN00015}", align: "center" }], align: "center" },
	    { width: 200, id: "ItemName",  header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
	    { width: 300, id: "Path",       header: [{ text: "${menu.LN00043}", align: "center" }], align: "left" },
	    { width: 100, id: "ClassName",  header: [{ text: "${menu.LN00016}", align: "center" }], align: "center" },
	];
	
	var gridData = [];
	
	// grid 설정
	var grid = new dhx.Grid(null, {
	    columns: baseCols,
	    autoWidth: false,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);
	
	// 체크박스 편집 X
	grid.events.on("beforeEditStart", function(row, col) {
	    if (col.id.startsWith("DimValueName")) {
	        return false; 
	    }
	});	
  
	/**
	* [메인 프로세스] 검색 버튼 클릭 시 실행
	*/
	async function getDimensionInfo() {
	    const itemTypeCode = $("#ItemTypeCode").val();
	    if (!itemTypeCode) { alert("${WM00041}"); return; }
	
	    if (dimensionCache[itemTypeCode]) {
	        const cached = dimensionCache[itemTypeCode];

	        grid.setColumns(cached.columns); // 컬럼 재설정
	        grid.data.parse(cached.rows); // 데이터 바인딩
	        
	        $("#divExcelDownBtn").show();
	        return; // API 호출 없이 종료
	    }		    
	    
	    try {
	        $('#loading').fadeIn(150);

	        const params = new URLSearchParams({
	            ItemTypeCode: itemTypeCode,
	            DimTypeID: dimTypeID,
	            sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
				sqlGridList: "N",
				sqlID: "report_SQL.getDimInfoWithItemTypeCode"
	        });

			const url = "getData.do?" + params;

	        const response = await fetch(url, {
	            method: "GET",
	            headers: { "Content-Type": "application/x-www-form-urlencoded" }
	        });
	        
	        const result = await response.json();
	        
	        if (!result.success || !result.data || result.data.length === 0) {
	            alert("조회된 Dimension 정보가 없습니다.");
	            
	            grid.data.removeAll(); // 기존 데이터 삭제
	            grid.setColumns(baseCols); // 컬럼을 기본 컬럼으로 초기화
	            $("#divExcelDownBtn").hide(); // 엑셀 버튼 숨김		            
	            return;
	        }
	
			// 체크박스 컬럼 생성
	        const dynCols = result.data.map((item, i) => ({
	            id: "DimValueName" + (i + 1),
	            width: 100,
	            header: [{ text: item.DimValueName || "N/A", align: "center" }], 
	            align: "center",
	            type: "boolean",  
	            editable: true    
	        }));
	
	        const newColumns = [...baseCols, ...dynCols]; // 새 컬럼 배열 생성
	        
	        grid.setColumns(newColumns); // 컬럼 먼저 세팅
	
	        // dimValueID 추출
	        const dimValueIds = result.data.map(d => d.DimValueID).join(",");
	        //await loadGridData(dimValueIds, itemTypeCode);
	        
			// 본문 데이터 호출
	        const processedData = await loadGridData(dimValueIds, itemTypeCode);
	
			// row, column 배열 재정립
	        dimensionCache[itemTypeCode] = {
	            columns: newColumns,
	            rows: processedData
	        };
	
	    } catch (e) {
	        console.error("Column Error:", e);
	    } finally {
	        $('#loading').fadeOut(150);
	    }
	}
	   
	/**
	 * [데이터 로드] 그리드 본문에 표시될 실제 매핑 데이터를 가져옴
	 */	
	async function loadGridData(dimValueIds, itemTypeCode) {
	    const params = new URLSearchParams({
	        ID: dimValueIds,
	        itemTypeCode: itemTypeCode,
	        s_itemID: dimTypeID,
	        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
			sqlID: "report_SQL.itemDimValueProcessInfo"
	    });
	    
		const url = "getData.do?" + params;
	    
	    const response = await fetch(url, {
	        method: "GET",
	        headers: { "Content-Type": "application/x-www-form-urlencoded" }
	    });
	
	    const result = await response.json();
	      
		// data 배열 가져오기 / 없으면 빈 배열 반환
		const rows = result?.data || [];

		// console.log("rows length:", rows.length);
		// console.log("first row:", rows[0]);

		const dimValueIdsArr = dimValueIds.split(",");
	    let processedData = [];
	    
		// 가져온 데이터를 CodeID 기준 그룹화 + DimValueName 추가
	    if (rows && rows.length > 0) {
	        let rowMap = {};
	        let currentCodeId = "";
	        let rnum = 1;
	        
	        for (const r of rows) {
	            const rowCodeId = String(r.CodeID);
	            
	            if (rowCodeId !== currentCodeId) {
	                if (currentCodeId !== "") {
	                    processedData.push(rowMap);
	                    rnum++;
	                }
	                currentCodeId = rowCodeId;
	                rowMap = {
	                    RNUM: rnum,
	                    Identifier: r.Identifier,
	                    ItemName: r.ItemName,
	                    Path: r.Path,
	                    ClassName: r.ClassName
	                };
	            }
	            
	            for (let i = 0; i < dimValueIdsArr.length; i++) {
	                if (dimValueIdsArr[i] === String(r.DimValueID)) {
	                    rowMap["DimValueName" + (i + 1)] = true; 
	                }
	            }
	        }
	        processedData.push(rowMap); // 마지막 행 추가
	    }
	
	    // console.log("Final Processed Data for Grid:", processedData); 
	
	    grid.data.parse(processedData); 
	    $("#divExcelDownBtn").show(); 
	    
	    return processedData;
	}
	   
 	function fnReload(newGridData){
 	 	
 	    grid.data.parse(newGridData);

 	} 
 	
</script>

<div id="framecontent" class="mgT10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col>
			</colgroup>
			<tr>
				<!-- Download Option -->
				<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;${menu.LN00021}</th>
				<td colspan="3" class="pdB5">
					<select id="ItemTypeCode" name="ItemTypeCode"></select>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="getDimensionInfo();" value="검색">
				</td>
			</tr>
		</table>
	</div>

<!-- BIGIN :: LIST_GRID -->
<div id="maincontent">
	<div id="divExcelDownBtn" class="alignBTN mgB5" style="display:none;">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</div>
	<div class="file_search_list">
		<div id="excelGridArea" style="width:100%"></div>
	</div>
</div>	

<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>	
<!-- END :: LIST_GRID -->
