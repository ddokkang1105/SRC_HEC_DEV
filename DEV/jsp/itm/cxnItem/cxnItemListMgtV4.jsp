<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<!-- 2. Script -->
<script type="text/javascript">
	var positionX,positionY;
	var cxnItemID;
	
	var s_itemID = "${s_itemID}";
	var childCXN = "${childCXN}";
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var cxnTypeList = "${cxnTypeList}";
	var notInCxnClsList = "${notInCxnClsList}";
	
	var ClassCode = "${ClassCode}";
	
	// fileList 호출용
	var option = "${option}";
	var filter = "${filter}";
	var ItemIDs = []; 
	
	$(document).ready(function() {
		LoadAllCxnData();
	});
	
	/**
	 * [메인 실행 함수] 페이지 로드 시 호출되어 모든 연관 항목 데이터를 통합 로드함
	 */
	async function LoadAllCxnData() {
	
	    $('#loading').fadeIn(150);
	
	    // 1. 데이터 가져오기 (비동기 병렬 처리)
	    const promiseAllResults = await Promise.allSettled([
	        reloadCxnItem()
	        // , reloadConnectedProcess() // 만약 선후행 함수가 있다면 여기에 추가
	    ]);
	
	    const cxnItemData = promiseAllResults[0].status === 'fulfilled' ? promiseAllResults[0].value : [];
	
	    // 에러 메시지 처리
	    if (promiseAllResults[0].status === 'rejected') {
	        console.error("일반 연관항목 에러: " + promiseAllResults[0].reason.message);
	    }

	    /**
	     * [내부 헬퍼] 가져온 기본 데이터에 Link와 속성 데이터를 순차적으로 병합 후 그리드 출력
	     */	    
	    async function parseCombinedDataIntoGrid() {
	        const parentData = Array.isArray(cxnItemData) ? cxnItemData : [];
	        
	        // --- 추가된 Link API 호출 구간 ---
	        // 1️⃣ link api 호출하여 이미지/URL 정보 추가
	        const combinedLinkData = await setCxnItemLink(parentData);
	        const dataWithLinks = combinedLinkData || parentData;
	        
	        // 2️⃣ 기존 attr 병합 (link가 포함된 데이터를 인자로 넘김)
	        const mergedItemList = await mergeAttrCxnItemList(dataWithLinks);

	        // 3️⃣ Grid에 출력
	        fnReloadCxnGrid(mergedItemList);
	        
	        $('#loading').fadeOut(150);
	    }
	
	    await parseCombinedDataIntoGrid();
	}
	
	/**
	 * [유틸리티] 속성 객체에서 실제 값을 우선순위에 따라 추출
	 */	
	function getAttrValue(attr) {
	    if (!attr) return "";

	    if (attr.PlainText && attr.PlainText.trim() !== "") {
	        return attr.PlainText;
	    }
	    if (attr.PlainText2 && attr.PlainText2.trim() !== "") {
	        return attr.PlainText2;
	    }
	    if (attr.AttrValue && String(attr.AttrValue).trim() !== "") {
	        return String(attr.AttrValue);
	    }
	    if (attr.Value && String(attr.Value).trim() !== "") {
	        return String(attr.Value);
	    }

	    return "";
	}

	
	
	/**
	 * [API 호출] 일반 연관 항목 리스트를 가져옴
	 */
	async function reloadCxnItem() {
	    const requestData = { s_itemID, languageID, cxnTypeList, notInCxnClsList, ClassCode };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getCxnItemList.do?" + params;

	    const response = await fetch(url, { method: 'GET' });

	    if (!response.ok) {
	    	// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
	    	const errorMessage = data.message || "서버 내 오류 발생";
	    	const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        error.status = response.status;
	        throw error;
	    }

	    const data = await response.json();
	    
	    // success 필드 체크
	    if (!data.success) {
	        const errorMessage = data.message || "요청 처리 실패";
	        const error = new Error(errorMessage);
	        error.type = 'SERVER_ERROR';
	        throw error;
	    }

	    if (data && data.data) {
	        return data.data;
	    } else {
	    	// 서버가 반환한 데이터가 유효하지 않을 경우
	        const error = new Error("서버가 반환한 데이터가 유효하지 않음");
	        error.type = 'INVALID_DATA';
	        throw error;
	    }
	}

	/**
	 * [데이터 병합] 아이템 리스트를 순회하며 각 아이템의 상세 속성값을 가져와 객체에 주입
	 */	
	 async function mergeAttrCxnItemList(cxnItemList) {
	
		    const fetchPromises = cxnItemList.map(async (item) => {
	
		        try {
			        const params = new URLSearchParams({ s_itemID: item.ItemID, languageID: languageID }).toString();
			        const url = "getItemAttrList.do?" + params;
		            const response = await fetch(url);
		            const result = await response.json();
	
		            if (!result.success || !Array.isArray(result.data)) return item;
		            
		            result.data.forEach(attr => {
		                if (!attr.AttrTypeCode) return;
	
		                item[attr.AttrTypeCode] = getAttrValue(attr) ?? "";
	
		            });
	
		        } catch (e) {
		        	console.error("ATTR merge error", e);
		        }
	
		        return item;
		    });
	
		    return await Promise.all(fetchPromises);
		}

	 /**
	  * [데이터 병합] 아이템 리스트를 순회하며 할당된 링크(이미지/URL) 정보를 병합
	  */
		async function setCxnItemLink(combinedData) {
		    
			try {
				
	     	const updatePromises = combinedData.map(async (item) => {
	         
		            const requestData = { 
		                itemID: item.ItemID, 
		                languageID,
		                itemClassCode: item.ClassCode 
		            };
		            
		            if(item.ItemID){
			            const linkData = await loadCxnItemLink(requestData);
			            return {
			                ...item,
			                ...linkData // 추가 데이터 저장
			            };
		            } else {
		            	return item;
		            }
		            
	     	});
	
	     	const resultData = await Promise.all(updatePromises);
	     	return resultData;
	
		    } catch (error) {
		    	return;
		        console.error("데이터 병합 중 오류 발생:", error);
		    }
		}
	
		/**
		 * [API 호출] 특정 아이템의 Link 정보를 서버에서 조회
		 */
		async function loadCxnItemLink(requestData) {
		    
			const params = new URLSearchParams(requestData).toString();
		    const url = "getLinkListFromAttAlloc.do?" + params;
		    
		    try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message);
				}
	
				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message);
				}
	
				if (result && result.data) {
					return result.data;
				} else {
					return;
				}
	
			} catch (error) {
				handleAjaxError(error);
			}
		   
		} 
 
		
	// 아이템에 할당된 link 가져오는 함수
	async function setCxnItemLink(combinedData) {
	    try {
	        const updatePromises = combinedData.map(async (item) => {
	            if(item.ItemID){
	                const requestData = { 
	                    itemID: item.ItemID, 
	                    languageID: languageID,
	                    itemClassCode: item.ClassCode 
	                };
	                const linkData = await loadCxnItemLink(requestData);
	                return { ...item, ...linkData }; // 기존 데이터에 링크 정보 덮어쓰기
	            } else {
	                return item;
	            }
	        });
	        return await Promise.all(updatePromises);
	    } catch (error) {
	        console.error("데이터 병합 중 오류 발생:", error);
	        return combinedData;
	    }
	}
	
	// cxnItem Link 실제 조회 (Fetch)
	async function loadCxnItemLink(requestData) {
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getLinkListFromAttAlloc.do?" + params;
	    
	    try {
	        const response = await fetch(url, { method: 'GET' });
	        if (!response.ok) return null;

	        const result = await response.json();
	        if (result && result.success && result.data) {
	            return result.data;
	        }
	        return null;
	    } catch (error) {
	        console.error("Link API Error:", error);
	        return null;
	    }
	}	

	/**
	 * [그리드 제어] 가공된 데이터를 DHTMLX Grid에 반영하고 총 개수를 업데이트
	 */
	 function fnReloadCxnGrid(newGridData){
		    const modifiedData = newGridData.map(item => {
		        return { 
		            ...item, 
		            id: String(item.ItemID), // Grid 내부 rowId를 ItemID로 고정
		            ClassName: item.ItemTypeImg 
		                ? `<img src="${root}${HTML_IMG_DIR}/item/${item.ItemTypeImg}" width="18" height="18">&nbsp;${item.ClassName}`
		                : item.ClassName
		        };
		    });
		    
		    cxnItemGrid.data.parse(modifiedData);
		    $("#TOT_CNT").html(cxnItemGrid.data.getLength());
	 }

</script>

<body>
<div id="processDIV">	
<form name="cxnItemTreeFrm" id="cxnItemTreeFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	
	<div style="width: 100%;" id="cxnItemlayout"></div>
	
</form>
</div>

<script>
	/**
	 * [그리드 이벤트] 서브로우가 확장될 때 호출되어 상세 속성 데이터를 화면에 렌더링함 (캐시 적용)
	 */
	async function expandCxnSubrowCallback(row, tbody) {
	    try {
	        if (!tbody) return;
	
	        // 1. 이미 데이터가 캐시되어 있다면, 통신 없이 즉시 렌더링
	        if (row._attrLoaded && row._cachedAttrs) {
	            console.log("캐시된 데이터 사용 (ItemID: " + row.ItemID + ")");
	            renderAttrFromMergedItem(tbody, row._cachedAttrs);
	            // 캐시 데이터 로드 후에도 그리드 높이 갱신
	            if (cxnItemGrid && cxnItemGrid.paint) cxnItemGrid.paint();
	            return;
	        }
	
	        // 2. 통신 중복 방지
	        if (row._isFetching) return;
	
	        row._isFetching = true;
	        tbody.innerHTML = "<tr><td colspan='2' style='text-align:center;'>데이터를 불러오는 중...</td></tr>";
	
	        const params = new URLSearchParams({
	            s_itemID: row.ItemID,
	            languageID: languageID
	        }).toString();
	
	        const res = await fetch("getItemAttrList.do?" + params);
	        if (!res.ok) throw new Error("Network error");
	
	        const result = await res.json();
	
	        if (result && result.success && Array.isArray(result.data)) {
	            row._cachedAttrs = result.data; 
	            row._attrLoaded = true;
	            
	            renderAttrFromMergedItem(tbody, row._cachedAttrs);
	        } else {
	            tbody.innerHTML = "<tr><td colspan='2' style='text-align:center;'>속성 정보 없음</td></tr>";
	        }
	
	    } catch (e) {
	        console.error("Data load error:", e);
	        tbody.innerHTML = "<tr><td colspan='2' style='text-align:center; color:red;'>데이터 로드 오류</td></tr>";
	    } finally {
	        row._isFetching = false;
	        if (cxnItemGrid && cxnItemGrid.paint) {
	            cxnItemGrid.paint();
	        }
	    }
	}

	/**
	 * [유틸리티] 문자열에서 HTML 태그를 제거하여 순수 텍스트만 반환
	 */	
	function stripHtml(html) {
	    if (!html) return "";
	    
	    // 1. 임시 div 생성
	    var tempDiv = document.createElement("div");
	    
	    // 2. HTML 삽입 (이 과정에서 브라우저가 DOM 구조로 해석함)
	    tempDiv.innerHTML = html;
	    
	    // 3. 텍스트만 추출 (textContent는 모든 태그를 무시하고 글자만 가져옴)
	    var plainText = tempDiv.textContent || tempDiv.innerText || "";
	    
	    // 4. 불필요한 공백 제거 후 반환
	    return plainText.trim();
	}

	/**
	 * [렌더링] 서브로우 내부의 속성 테이블 HTML을 생성하여 삽입
	 */	
	function renderAttrFromMergedItem(tbody, attrList) {
	    if (!tbody) return;
	    
	    var html = "";
	    if (!attrList || attrList.length === 0) {
	        html = "<tr><td colspan='2' style='text-align:center;'>등록된 속성이 없습니다.</td></tr>";
	    } else {
	        for (var i = 0; i < attrList.length; i++) {
	            var attr = attrList[i];
	            
	            // 1. 이름 추출
	            var attrName = attr.Name || "";
	            
	            // 2. 값 추출 (PlainText가 있다면 그것을 우선하되, 없으면 일반 Value 사용)
	            var rawValue = getAttrValue(attr);
	            var cleanText = stripHtml(rawValue);
	            
	            // 3. HTML 렌더링을 위한 처리
	            // 값이 없으면 빈칸, 있으면 해당 내용을 그대로 둡니다.
	            var displayValue = rawValue ? rawValue : ""; 
	
	            html += "<tr>";
	            html +=     "<th style='background:#f4f4f4; width:30%; text-align:center; font-size:12px; border:1px solid #ddd;'>" + attrName + "</th>";
	            html +=     "<td class='last alignL pdL5 pdR5' style='width:70%; border:1px solid #ddd; background:#fff;'>";
	            html +=         "<div class='attr-content-area' style='width:100%; min-height:45px; padding:8px; line-height:1.5; word-break:break-all;'>";
	            html +=             cleanText; 
	            html +=         "</div>";
	            html +=     "</td>";
	            html += "</tr>";
	        }
	    }
	    
	    tbody.innerHTML = html;
	}

	const columns = [
		{
		    id: "expand",
		    width: 40,
		    header: [{ text: "" }],
		    type: "expand"
		},
		//{ id: "ClassName", width: 120, type: "string", header: [{ text: "ClassName", align: "center" }], align: "center", htmlEnable: true },
		{ id: "TreeName", width: 350, header: [{ text: "${menu.LN00028}", align: "center" }], htmlEnable: true, 
        	template: function (text, row, col) {
        		if(row.parent == "cxnItemGrid") return "";   		
        		if(row.parent != "treegrid" && row.parent != "${s_itemID}"){
					if(row.HaveTeamParent == "Y"){
						return '&emsp;&emsp;&emsp;&emsp;' + row.TreeName;
					} else if(row.IsTeamParent == "Y"){
						return '&emsp;&emsp;&emsp;<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">&nbsp;'+ row.TreeName;
					}else{
						return '&emsp;' + row.TreeName;
        			}
        		}else{
        			return '<img src="${root}${HTML_IMG_DIR}/item/'+row.Icon+'" width="18" height="18">&nbsp;'+ row.TreeName;	        			
        		}
        	} 	
        },
        { id: "ItemPath", type: "string", header: [{ text: "${menu.LN00043}", align: "center" }], autoWidth: true },
        // { id: "LinkType", width: 100, type: "string", header: [{ text: "${menu.LN00038}", align: "center" }], align: "center" },
        { id: "linkImg", width: 50, type: "html", header: [{ text: "Link", align: "center"}], htmlEnable: true, align: "center", sortable: false	//, hidden: true
        		, template: function (text, row, col) {
	        		if(row.linkImg == undefined){
	        			return '<img src="${root}${HTML_IMG_DIR}/item/blank.png" width="19" height="20">';
	        		}else{	
		        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.linkImg+'" width="19" height="20">';
	        		}
            	} 
        },
        { id: "OwnerTeamName", width: 120, type: "string", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center", hidden: true},
        { id: "Name", width: 120, type: "string", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
        { id: "LastUpdated", width: 120, type: "string", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
	];

	var cxnItemlayout = new dhx.Layout("cxnItemlayout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var cxnItemGrid = new dhx.Grid("cxnItemGrid", {
	    columns: columns,

	    subRowConfig: {
	        height: 400,
	        padding: 15,
	        toggleIcon: true
	    },
	    subRow: function (row) {
	        var itemID = row.ItemID || (row.row && row.row.ItemID);
	        if (!itemID) return "<div style='padding:10px;'>ID Error</div>";
	        
	        var safeId = String(itemID).trim();

	        var html = "";
	        // 본문 테이블 생성
	        html += "<div style='padding:10px; height:380px; overflow-y:auto; overflow-x:hidden; background:#f9f9f9;'>";
	        html +=     "<table class='tbl_blue01' style='width:100%; table-layout: fixed; border-top:1px solid #ddd;'>";
	        html +=         "<tbody id='attr-body-" + safeId + "'>";
	        html +=             "<tr><td colspan='2' style='text-align:center;'>데이터를 불러오는 중...</td></tr>";
	        html +=         "</tbody>";
	        html +=     "</table>";
	        html += "</div>";

	        return html;
	    },
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    height: "100%"
	});


	cxnItemlayout.getCell("a").attach(cxnItemGrid);

	cxnItemGrid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(cxnItemGrid.data.getLength());
	});
	
	cxnItemGrid.events.on("afterExpand", function (rowId) {
	    const row = cxnItemGrid.data.getItem(rowId);
	    if (!row) return;

	    setTimeout(() => {
	        const targetId = "attr-body-" + row.ItemID;
	        const tbody = document.getElementById(targetId);
	        
	        if (tbody) {
	            // 캐시 여부와 상관없이 콜백 실행 
	            // (콜백 내부에서 캐시가 있으면 fetch를 안 하도록 설계됨)
	            expandCxnSubrowCallback(row, tbody);
	        }
	    }, 250); 
	});

	// cell click 시 fetch 
	cxnItemGrid.events.on("cellClick", function(row,column,e){
		
		if (column.id === "expand") return;
		
		if(column.id != "ClassName" && column.id == "linkImg"){
			if(row.linkUrl != "" && row.linkUrl != undefined ){
				fnOpenLink(row.ItemID,row.linkUrl,row.lovCode,row.attrTypeCode);
			}
		} else if(column.id != "ClassName" && column.id == "Name" && row.AuthorID != "" && row.AuthorID != undefined ){
			var url = "viewMbrInfo.do?memberID="+row.AuthorID;		
			window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');		
		}else if(column.id != "ClassName" && column.id == "LinkType" && row.CXNItemID != "" && row.CXNItemID != undefined){	
			doPtgDetail(row.CXNItemID);
		} else if(column.id != "ClassName"){
			if(row.ItemID != undefined && row.ItemID != ""){ doPtgDetail(row.ItemID); }
		}
	});

	/**
	 * [팝업] 아이템 상세 정보 팝업창을 오픈
	 */	
	function doPtgDetail(avg){		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	

	function fnOpenItemTree(itemTypeCode, searchValue, cxnClassCode){
		$("#cxnTypeCode").val(itemTypeCode);
		$("#cxnClassCode").val(cxnClassCode);
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&searchValue="+searchValue
			+"&openMode=assign&s_itemID=${s_itemID}";

		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){
		//alert(1);
	}

	/**
	 * [팝업] Link 컬럼 클릭 시 해당 연결 URL로 이동 팝업 오픈
	 */	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}
	
	
	function reloadCxnFileGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
 		$("#TOT_CNT_CXN_FILES").html(targetGrid.data.getLength());
 	}
	
</script>

</body>



