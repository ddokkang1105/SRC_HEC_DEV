<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
</style>
<script type="text/javascript">
	var root = "${root}";	
	var HTML_IMG_DIR_ITEM = "${HTML_IMG_DIR_ITEM}"; 
	var languageID  = "${sessionScope.loginInfo.sessionCurrLangType}";
	var itemID      = "${itemID}";
	var s_itemID      = "${itemID}";
	var hideBlocked = "${hideBlocked}";
	var changeSetID = "${changeSetID}";
	var csFilterYN = "${csFilterYN}";
	var cxnTypeList = "${cxnTypeList}";
	var notInCxnClsList = "${notInCxnClsList}";
	var accMode = "${accMode}";
	var showInvisible = "${showInvisible}";
	var attrUrl = `${attrUrl}`;

	$(document).ready(function(){		
		
		$('.chkbox').click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$('#frontFrm input:checkbox:not(:checked)').each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		var height = setWindowHeight();
		document.getElementById("htmlReport").style.height = (height - 55)+"px";
		
		// item 정보
		renderItemInfo();
		
		// item attr 정보
		renderItemAttrList();
		
		// 첨부파일 리스트		
		renderFileListByOption();
		
		// 선/후행 process
		renderConnectedProcess();
		
		// 액티비티 리스트 
		renderActivityList();
		
		// Rule Set & KPI
		renderRelItemList();

		// 변경이력
		renderItemHistoryList();
		
		// dimension
		renderDimensionList();
		
		// [ api 호출 end ]
		
		
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}

		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	// 관련항목 팝업
	function clickItemEvent(trObj) {
		// item Popup
		var url = "itemMainMgt.do?"
				+"itemMainPage=/itm/itemInfo/itemMainMgt"
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID="+trObj
 				+"&accMode="+accMode
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 변경이력 팝업
	function clickChangeHistoryEvent(trObj) {
		var url = "viewItemChangeInfo.do?"
				+"changeSetID="+$(trObj).find("#ChangeSetID").text()
 				+"&StatusCode="+$(trObj).find("#ChangeStsCode").text()
				+"&ProjectID"+$(trObj).find("#ChangeStsCode").text()
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&isItemInfo=Y&seletedTreeId=${itemID}&isStsCell=Y";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
	// TODO : 수정 필요
	function reload(){
		var mdlOption= "${mdlOption}";
		if(itemPropURL != "" || itemPropURL != null){
			var itemPropURL = "${url}";
			var avg4 = itemPropURL;
			if(mdlOption != null && mdlOption != ""){
				avg4 += ","+mdlOption;
			}
			setActFrame("viewItemProperty", '', '', avg4,'');
		} else {
			var itemPropURL = "${itemPropURL}";
			parent.fnSetItemClassMenu("viewItemProperty", "${itemID}", "&mdlOption="+mdlOption+"&itemPropURL="+itemPropURL+"&scrnType=clsMain");
		}
	}
	
	// attr Link 클릭
	function fnRunLink(url,attrUrl,attrTypeCode,varFilter){
		var lovCode = "${lovCode}"; 
		var itemID = "${s_itemID}";
		var fromItemID = "${fromItemID}";
		if(fromItemID != ""){
			itemID = fromItemID;
		}
		
		if(url == null || url == ""){
			url = attrUrl;		
		}
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}	
		 else if (url.includes("cxnItemListPop")) {
			url = url+".do?s_itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode + varFilter;
			window.open(url,'','width=750, height=500, left=200, top=100, scrollbar=yes,resizable=yes');					
		}
		
		 else if (url.includes("cxnItemListMgtV4")) {
			 	url =  url + ".do";
				var data = "s_itemID=" + itemID + varFilter
				var w = 1200;
				var h = 800;
				openUrlWithDhxModal(url, data, title="", w, h)			 
			 
				//url = url+".do?s_itemID="+itemID + varFilter;
				//window.open(url,'','width=1200, height=800, left=200, top=100, scrollbar=yes,resizable=yes');					
		}
		
		 else {
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
			window.open(url,'_newtab');					
		}
	} 
		
</script>		
		


</head>
<body>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<!-- main path -->
		<div style="height: 20px;padding: 12px 0;">
			<p class="shortcut"></p>
		</div>
				
		<div id="itemDiv">
			<div style="height: 22px; padding: 10px 0; width: 100%;">
				<ul>
					<!-- main title -->
					<li class="floatL pdL10 itemTitle"></li>
					<li class="floatR pdR10">
						<input type="checkbox" class="mgR5 chkbox" name="process" checked>ITEM 정보
						<input type="checkbox" class="mgR5 chkbox" name="attachFile">${menu.LN00019}
						<input type="checkbox" class="mgR5 chkbox" name="occurrence">선/후행 Process
						<input type="checkbox" class="mgR5 chkbox" name="subItem">액티비티
						<input type="checkbox" class="mgR5 chkbox" name="ruleSet">Rule Set
						<input type="checkbox" class="mgR5 chkbox" name="kpi">KPI
						<input type="checkbox" class="mgR5 chkbox" name="csr">변경이력
						<input type="checkbox" class="mgR5 chkbox" name="dimension">Dimension
					</li>
				</ul>
			</div>	
			
			
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">ITEM 정보</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="10%">
						<col width="40%">
						<col width="10%">
						<col width="40%">
					</colgroup>
					<tbody id="itemInfoArea"></tbody>
				</table>
				
				<table class="tbl_preview mgT10">
					<tbody id="itemAttrListArea"></tbody>
				</table>
			</div>
			
			
			<!-- BIGIN :: 첨부파일 -->
			<div id="attachFile" class="mgB30" style="display:none;">
				<p class="cont_title">${menu.LN00019}</p>
				<table class="tbl_preview" id="fileListTable">
					<colgroup>
						<col width="5%">
						<col width="8%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>No</th>
						<th>${menu.LN00091}</th>
						<th>Version</th>
						<th>${menu.LN00101}</th>
						<th>${menu.LN00027}</th>
					</tr>
				</table>
			</div>
			
			<!-- BIGIN :: 선/후행 Process -->
			<div id="occurrence" class="mgB30" style="display:none;">
				<p class="cont_title">선/후행 Process</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="8%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>No</th>
						<th>구분</th>
						<th>ID</th>
						<th>명칭</th>
						<th>상태</th>
					</tr>
					<tbody id="elementListTbody">
					</tbody>
				</table>
			</div>
					
			<!-- BIGIN :: 액티비티 -->
			<div id="subItem" class="mgB30" style="display:none;">
				<p class="cont_title">액티비티</p>
				<table style="able-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview borderR mgT20">
					<colgroup> 
						<col width="12%">
						<col width="13%">
						<col width="42%">
						<col width="10%">
						<col width="10%">
						<col width="13%">
					</colgroup>
					<tr>
						<th>Activity ID</th>
						<th>Activity 명</th>
						<th>Guideline</th>
						<th>Role</th>
						<th>System</th>
						<th>T-Code</th>
					</tr>
					<tbody id="activityListTbody"></tbody>
				</table>
			</div>
			
			<!-- BIGIN :: Rule set -->
			<div id="ruleSet" class="mgB30" style="display:none;">
				<p class="cont_title">Rule set</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="55%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>ID</th>
						<th>명칭</th>
						<th>개요</th>
					</tr>
					<tbody id="ruleSetListTbody"></tbody>
				</table>	
			</div>
			
			<!-- BIGIN :: KPI -->
			<div id="kpi" class="mgB30" style="display:none;">
				<p class="cont_title">KPI</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="55%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>ID</th>
						<th>명칭</th>
						<th>개요</th>
					</tr>
					<tbody id="kpiListTbody"></tbody>
				</table>	
			</div>
			
			<!-- BIGIN :: 변경이력 -->
			<div id="csr" class="mgB30" style="display:none;">
				<p class="cont_title">변경이력</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="13%">
						<col width="12%">
						<col width="10%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>Version</th>
						<th>변경구분</th>
						<th>담당자</th>
						<th>시작일</th>
						<th>수정일</th>
						<th>승인일</th>
						<th>상태</th>
					</tr>
					<tbody id="itemHistoryListTbody"></tbody>
				</table>
			</div>
			
			<!-- BIGIN :: dimension -->
			<div id="dimension" class="mgB30" style="display:none;">
				<p class="cont_title">dimension</p>
				<table class="tbl_preview">
					<tr>
						<th>No</th>
						<th></th>
						<th>Value</th>
					</tr>
					<tbody id="dimensionListTbody"></tbody>
				</table>
			</div>
			
		</div>
	</div>
</form>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>

<script>

// [기본 정보]
async function renderItemInfo() {
	
	try {
        // 1. 아이템 기본정보 불러오기
        const itemInfo = await getItemInfo();
        if (!itemInfo || itemInfo.length === 0) {
            return;
        }
        
        // main path
        let htmlContent = `\${itemInfo.Path}/<font color="#3333FF"><b>\${itemInfo.Identifier} \${itemInfo.ItemName}</b></font>`;
        const shortcutElement = document.querySelector('.shortcut');
        if (shortcutElement) {
            shortcutElement.innerHTML = htmlContent;
        }
        
        // main title
        htmlContent = `
		    <img src="\${root}\${HTML_IMG_DIR_ITEM}/\${itemInfo.ItemTypeImg}">
		    <b>\${itemInfo.ItemName}</b>
		    <img src="\${root}\${HTML_IMG_DIR_ITEM}/img_refresh_02.png" style="width:15px;" id="refresh" onclick="reload()">
		`;
 		const itemTitleElement = document.querySelector('.itemTitle');
        if (itemTitleElement) {
        	itemTitleElement.innerHTML = htmlContent;
        }
		
        // item Info
        const tbody = document.getElementById("itemInfoArea");
		if(!tbody) return;
		
		tbody.innerHTML = `
		  	<tr>
				<th>${menu.LN00016}</th>
				<td class="alignL pdL10" colspan="3">\${itemInfo.ClassName}</td>
			</tr>
			<tr>
				<th>${menu.LN00004}</th>
				<td class="alignL pdL10">\${itemInfo.Name}</td>
				<th>${menu.LN00070}</th>
				<td class="alignL pdL10">\${itemInfo.LastUpdated}</td>
			</tr>
		`;

    } catch (error) {
        console.error("itemInfo 가공 중 오류 발생:", error);
        return; 
    }
	
}


// [AttrList - 조회용 ]
async function renderItemAttrList() {
	
	try {
        // 1. 아이템 기본정보 불러오기
        const attrList = await getItemAttrList();
        if (!attrList || attrList.length === 0) {
            return;
        }
        
        const tbody = document.getElementById("itemAttrListArea");
		if(!tbody) return;
		
		// 1. attrList 가공 
		// 1-1. invisible 비활성화
		const filteredList = attrList.filter(item => String(item.invisible) !== "1");
        // 1-2. dataType에 따른 값 셋팅
		await Promise.all(filteredList.map(async (item) => {
            if (item.DataType === "MLOV") {
                item.PlainText = await getItemAttrMLOV(item.AttrTypeCode, languageID);
            }
        }));
		// 1-3. 중복된 attr 항목의 값 , 로 구분
		const reduceAttrList = filteredList
			.reduce((acc, current) => {
	        // 동일한 attr 항목 ,로 구분
	        const existingItem = acc.find(item => item.Name === current.Name);
	        
	        if (existingItem) {
	            if (current.PlainText) {
	                existingItem.PlainText += ", " + current.PlainText;
	            }
	        } else {
	            acc.push({ ...current });
	        }
	        return acc;
	    }, []);
		
		// 2. RowNum 기준으로 데이터 정렬 및 그룹화
		const rowsMap = reduceAttrList.reduce((acc, item) => {
		    const rowNum = item.RowNum || 0; // RowNum이 없으면 0으로 처리
		    if (!acc[rowNum]) {
		        acc[rowNum] = [];
		    }
		    acc[rowNum].push(item);
		    return acc;
		}, {});

		// 3. RowNum 숫자 순서대로 정렬된 키 배열 생성
		const sortedRowKeys = Object.keys(rowsMap).sort((a, b) => Number(a) - Number(b));
		
		// 4. 테이블 생성 로직
		for (const rowKey of sortedRowKeys) {
		    const rowItems = rowsMap[rowKey]; // 같은 RowNum을 가진 아이템 리스트
		    const currentRow = document.createElement('tr');
		    
		    // 해당 행의 높이는 포함된 아이템 중 가장 큰 AreaHeight를 사용하거나 첫 번째 아이템 기준
		    const maxHeight = Math.max(...rowItems.map(i => i.AreaHeight || 20));
		    currentRow.style.height = maxHeight + "px";
		    tbody.appendChild(currentRow);
		    
		    for (const item of rowItems) {
		        // th (속성명)
		        const th = document.createElement('th');
		        th.style.width = "20%";
		        
		     	// Mandatory 처리
		        if(item.Mandatory == '1') th.innerHTML = '<p style="display:inline;color:#FF0000;">*</p>' + item.Name;
		        else th.innerText = item.Name;
		        currentRow.appendChild(th);

		        // td (값)
		        const td = document.createElement('td');
		        td.classList.add('alignL', 'pdL10');
		        
		        // HTML 처리
		        
		        const isHtml = String(item.HTML).trim() == "1";
		        const content = item.PlainText || "";
		        
		        if (isHtml) {
		        	
		        	let tiny = '';
		        	tiny += '<div style="width:100%; height:'+item.AreaHeight+'px;" class="pd0">'
		        	tiny += '<textarea class="tinymceText" readonly="readonly" name="'+item.AttrTypeCode+'">'+content+'</textarea>'
		        	tiny += '</div>'
		        	td.innerHTML = decodeHtml(tiny);
					
		        } else {
		        	// Link 옵션
					const Link = item.Link || "";
		        	if(Link || attrUrl){
		        		var linkHtml = '<a onClick="fnRunLink(\'' + (item.URL || '') + '\', \'' + (attrUrl || '') + '\', \'' + (item.AttrTypeCode || '') + '\', \'' + (item.VarFilter || '') + '\');" ';
		        			linkHtml += 'style="color:#0054FF; text-decoration:underline; cursor:pointer;">';
		        			linkHtml += content;
		        			linkHtml += '</a>';
           				td.innerHTML = linkHtml;
		        	} else {
			            td.textContent = content;
			            td.style.whiteSpace = "pre-wrap";
		        	}
		        }

		        // ColumnNum에 따른 colspan 처리
		        // rowItems 개수가 1개뿐이거나 ColumnNum이 0이면 colspan 적용
		        if (item.ColumnNum === 0 || rowItems.length === 1) {
		            td.colSpan = 3; 
		        } else {
		            td.style.width = "30%";
		        }
		        
		        currentRow.appendChild(td);
		    };
		};
		
		// 새 스크립트 요소 생성
	    const script = document.createElement('script');
	    script.type = 'text/javascript';
	    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>'; // JSP에서 c:url을 통해 URL 생성

	    document.body.appendChild(script);

    } catch (error) {
        console.error("itemAttrList 가공 중 오류 발생:", error);
        return;
    }
	
}

/**
* @function getItemAttrMLOV
* @description 아이템 attrTypeCode를 통해 MLOV 값을 가공하여 return한다.
* @returns {String} 아이템 attr의 MLOV값
*/
async function getItemAttrMLOV(AttrTypeCode) {

	const sqlID = 'attr_SQL.selectAttrLovOption'; 
	const sqlGridList = 'N';
    const requestData = { s_itemID : AttrTypeCode, languageID, sqlID, sqlGridList };
    const params = new URLSearchParams(requestData).toString();
    const url = "getData.do?" + params;
    
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message, result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}

		if (result && result.data) {
			
			const mLovValue = result.data.map(item => item.NAME || "").join(" / ");
			return mLovValue;
			
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

/**
* @function decodeHtml
* @param {html} html
* @description HTML 엔티티(&lt; 등)를 실제 태그(< 등)로 변환합니다.
* @returns {String} 변환된 html
*/
function decodeHtml(html) {
    const txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}



// [ attach File List ]
async function renderFileListByOption() {
	
	try{
		
		const itemFileOption = await getFileOption();
	  	const isViewer = (itemFileOption === "VIEWER");
	  	
	  	const area = isViewer ? "viewerFileListArea" : "attachFileListArea";
	
		const fileList = await getAttachFileList(); 
		if (!Array.isArray(fileList) || fileList.length === 0) return;
		
		const table = document.getElementById("fileListTable");
		if (!table) return;
		
		let container;
		if (isViewer) {
		    // VIEWER일 때는 div 생성
		    container = document.createElement("div");
		} else {
		    // VIEWER가 아닐 때는 tbody 생성
		    container = document.createElement("tbody");
		}
		container.id = area;
		table.appendChild(container);
		
		container.innerHTML = fileList.map(list => `
		  <tr>
		    <td>
		      <span style="color: blue; cursor:pointer; border-bottom: 1px solid;"
		            onclick="clickItemEvent(\${list.ItemID})">
				\${list.Seq ?? ""}
		      </span>
		    </td>
		    <td class="alignL pdL10">\${list.FltpName ?? ""}</td>
		    <td class="alignL pdL10">\${list.CSVersion ?? ""}</td>
		    <td class="alignL pdL10">\${list.FileRealName ?? ""}</td>
		    <td class="alignL pdL5">\${list.FileStatus ?? ""}</td>
		  </tr>
		`).join("");
		
	} catch (error) {
        console.error("fileList 가공 중 오류 발생:", error);
        return;
    }
		
}

/**
* @function getFileOption
* @description 현재 item의 파일 옵션을 return 합니다.
* @returns {String} 파일 옵션
*/
async function getFileOption() {
	
	const sqlID = 'fileMgt_SQL.getFileOption'; 
	const sqlGridList = 'N';
    const requestData = { itemId : s_itemID, sqlID, sqlGridList };
    const params = new URLSearchParams(requestData).toString();
    const url = "getData.do?" + params;
    
    try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message);
		}

		const result = await response.json();
		if (result && result.data && result.data.length > 0) {
			return result.data;
		} else {
			return ''; // 조회 불가능한 경우
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

// [ Activity List ]
async function renderActivityList() {
	
	try {
        // 1. 하위항목 불러오기
        const subItemList = await getChildItemList();
        
        if (!subItemList || subItemList.length === 0) {
            return ;
        }

        // 2. 하위항목에 attrInfo, conList를 직접 병합 (병렬 처리 후 대기)
        let activityList = subItemList;
        activityList = await mergeAttrConList(subItemList);
        
        const tbody = document.getElementById("activityListTbody");
		
		if(!tbody) return;
		
		tbody.innerHTML = activityList.map(list => `
		  <tr>
		    <td>
		      <span style="color: blue; cursor:pointer; border-bottom: 1px solid;"
		            onclick="clickItemEvent(\${list.ItemID})">
				\${list.Identifier ?? ""}
		      </span>
		    </td>
		    <td class="alignL pdL10">\${list.ItemName ?? ""}</td>
		    <td class="alignL pdL10">\${list.AT00003 ?? ""}</td>
		    <td class="alignL pdL10">\${list.AT00017 ?? ""}</td>
		    <td class="alignL pdL10">\${renderConList(list.conList)}</td>
		    <td class="alignL pdL5">\${list.AT00014 ?? ""}</td>
		  </tr>
		`).join("");

    } catch (error) {
        console.error("activityList 가공 중 오류 발생:", error);
        return;
    }
}

// conList에서 특정 result값 조합 ( activityList 사용 )
function renderConList(conList) {
	if (!Array.isArray(conList) || conList.length === 0) return "";

	return conList
    .filter(list2 => list2.ClassCode === "CNL0104")
    .map(list2 => list2.itemName ?? "")
    .filter(Boolean)
    .join("<br>");
}

// [item History]
async function renderItemHistoryList() {
	
	try {
        // 1. 변경이력 불러오기
        const itemHistoryList = await getItemHistory();
        
        if (!itemHistoryList || itemHistoryList.length === 0) {
            return ;
        }
        
        const tbody = document.getElementById("itemHistoryListTbody");
		
		if(!tbody) return;
		
		tbody.innerHTML = itemHistoryList.map((list, index) => `
			<tr onclick="clickChangeHistoryEvent(${list.ItemID})" style="cursor:pointer;">
		        <td>\${index + 1}</td>
		        <td>\${list.Version ?? ""}</td>
		        <td>\${list.ChangeType ?? ""}</td>
		        <td>\${list.RequestUserName ?? ""}</td>
		        <td>\${list.RequestDate ?? ""}</td>
		        <td>\${list.CompletionDate ?? ""}</td>
		        <td>\${list.ApproveDate ?? ""}</td>
		        <td>\${list.ChangeSts ?? ""}</td>
		        
		        <td class="tdhidden">\${list.ChangeSetID ?? ""}</td>
		        <td class="tdhidden">\${list.ChangeStsCode ?? ""}</td>
		        <td class="tdhidden" >\${list.ProjectID ?? ""}</td>
		        <td class="tdhidden">\${list.ItemID ?? ""}</td>
		    </tr>
		`).join("");

    } catch (error) {
        console.error("itemHistoryList 가공 중 오류 발생:", error);
        return;
    }
	
} 

// [ 연관항목 - Rule Set & KPI ]
async function renderRelItemList() {
	
	try {
        // 1. 연관항목 불러오기
        const relItemList = await getRelItemList();
        if (!relItemList || relItemList.length === 0) {
            return ;
        }
        
        const tbody_kpi = document.getElementById("kpiListTbody");
        const tbody_ruleSet = document.getElementById("ruleSetListTbody");
		
        setHtmlForRelItem(tbody_kpi, 'OJ00008', relItemList);
        setHtmlForRelItem(tbody_ruleSet, 'OJ00007', relItemList);
		
		
    } catch (error) {
        console.error("relItemList 가공 중 오류 발생:", error);
        return;
    }
} 

// itemTypeCode 별 연관항목 html insert
function setHtmlForRelItem(tbody, itemTypeCode, dataList){
	
	if(!tbody) return;
	
	tbody.innerHTML = dataList
    .filter(list => list.ItemTypeCode === itemTypeCode)
    .map((list, index) => `
        <tr onclick="clickItemEvent(\${list.s_itemID})" style="cursor: pointer;">
            <td>\${index + 1}</td>
            <td>\${list.Identifier ?? ""}</td>
            <td class="alignL pdL10">\${list.ItemName ?? ""}</td>
            <td class="alignL pdL10">\${list.ProcessInfo ?? ""}</td>
            
            <td class="tdhidden">\${list.s_itemID ?? ""}</td>
        </tr>
    `).join("");
	
}

// [ 선후행 process ]
async function renderConnectedProcess() {
	
	try {
        const connectedProcessList = await getConnectedProcessList();
        if (!connectedProcessList || connectedProcessList.length === 0) {
            return ;
        }

        const tbody = document.getElementById("elementListTbody");
		
		if(!tbody) return;
		
		tbody.innerHTML = connectedProcessList.map((list,index) => `
		<tr onclick="clickItemEvent(\${list.ItemID})" style="cursor: pointer;">
		    <td>\${index + 1}</td>
		    <td>\${list.LinkType ?? ""}</td>
		    <td>\${list.Identifier ?? ""}</td>
		    <td>\${list.ItemName ?? ""}</td>
		    <td>\${list.StatusName}</td>
		</tr>
		`).join("");
		
    } catch (error) {
        console.error("connectedProcessList 가공 중 오류 발생:", error);
        return []; 
    }
	
}

//[ dimension List ]
async function renderDimensionList() {
	
	try {
        // 1. 하위항목 불러오기
        const dimList = await getDimensionList();
        if (!dimList || dimList.length === 0) {
            return ;
        }
        const tbody = document.getElementById("dimensionListTbody");
		
		if(!tbody) return;
		
		tbody.innerHTML = dimList.map((list,index) => `
		<tr>
		    <td>\${index + 1}</td>
		    <td>\${list.DimTypeName ?? ""}</td>
		    <td>\${list.DimValueName ?? ""}</td>
		</tr>
		`).join("");
		
    } catch (error) {
        console.error("dimension List 가공 중 오류 발생:", error);
        return []; 
    }
	
}


// [조회 api]

//itemInfo 조회
async function getItemInfo() {
	const requestData = { languageID, s_itemID, accMode, changeSetID };
	const params = new URLSearchParams(requestData).toString();
	const url = "getItemInfo.do?" + params;
	
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message, result.status);
		}
	
		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}
	
		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}
	
	} catch (error) {
		handleAjaxError(error);
	}
}

//attrList 조회
async function getItemAttrList() {

	const requestData = { languageID, s_itemID, accMode, changeSetID, showInvisible };
	const params = new URLSearchParams(requestData).toString();
	const url = "getItemAttrList.do?" + params;
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message, result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}

}

//첨부문서 리스트 조회 ( fileAttach 용 )
async function getAttachFileList() {

	let requestData = {
	  languageID,
	  s_itemID,
	  DocumentID: itemID,
	  hideBlocked,
	  changeSetID,
	  isPublic: "N",
	  DocCategory: "ITM"
	};
	
	// csFilter ( item 에 첨부된 전체 파일을 조회하고자 하는 경우 )
	if(csFilterYN !== 'N') requestData = { ...requestData, changeSetID };
	
 	// 연관 file 가져오기
	const rltdItemId = await getRltdItemId();
	if(rltdItemId && rltdItemId !== '') requestData = { ...requestData, rltdItemId };
	
	const params = new URLSearchParams(requestData).toString();
	const url = "getItemFileListInfo.do?" + params;
	
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

//연관항목 id 조회 ( fileAttach 용 )
async function getRltdItemId(){
  const requestData = { languageID, DocumentID: itemID };
  const params = new URLSearchParams(requestData).toString();
  const url = "getRltdItemId.do?" + params;
  
  try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}
}

// 선/후행 프로세스 리스트 조회
async function getConnectedProcessList() {
    const requestData = { s_itemID, languageID, accMode };
    const params = new URLSearchParams(requestData).toString();
    const url = "getConnectedProcessList.do?" + params;

	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}	
}

//하위항목 리스트 조회  ( activityList 사용 )
async function getChildItemList() {
  const requestData = { languageID, s_itemID };
  const params = new URLSearchParams(requestData).toString();
  const url = "getItemListInfo.do?" + params;

  try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}	
}

//subItemID를 통해 attrInfo를 조회하고 merge ( activityList 사용 )
async function mergeAttrConList(subItemList) {
    const fetchPromises = subItemList.map(async (item) => {
        	
    	const requestData = { s_itemID : item.id , conListYN : 'Y' };
		const params = new URLSearchParams(requestData).toString();
		const url = "getItemAttrList.do?" + params;
    	  	
   	  	try {
    		const response = await fetch(url, { method: 'GET' });
    		
    		if (!response.ok) {
    			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
    			throw throwServerError(result.message,result.status);
    		}

    		const result = await response.json();
    		// success 필드 체크
    		if (!result.success) {
    			throw throwServerError(result.message,result.status);
    		}

    		if (result && result.data) {
                 Object.values(result).forEach(attr => {
                     if (attr && typeof attr === 'object' && attr.AttrTypeCode) {
                         
                         item[attr.AttrTypeCode] = attr.PlainText ?? "";
                         if (attr.conList) {
                             item.conList = attr.conList;
                         }
                         
                     }
                 });
    		} else {
    			return [];
    		}

    	} catch (error) {
    		handleAjaxError(error);
    	}	
      
      return item;
    });

    const mergeList = await Promise.all(fetchPromises);
    return mergeList;
}

//변경이력 리스트 조회
async function getItemHistory(){
	const requestData = { s_itemID, languageID};
	const params = new URLSearchParams(requestData).toString();
	const url = "getChangeSetListInfo.do?" + params;
 
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}	

}

//연관항목 리스트 조회 ( KPI , Rule Set )
async function getRelItemList() {
    const requestData = { s_itemID, languageID, cxnTypeList, notInCxnClsList };
    const params = new URLSearchParams(requestData).toString();
    const url = "getCxnItemList.do?" + params;
	
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message,result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message,result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	}	
}

// dimension 리스트 조회
async function getDimensionList() {
	
	const sqlID = 'dim_SQL.selectDim';
	const requestData = { s_itemID, languageID, sqlID };
	const params = new URLSearchParams(requestData).toString();
	const url = "getData.do?" + params;
	
	try {
		const response = await fetch(url, { method: 'GET' });
		
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(result.message, result.status);
		}

		const result = await response.json();
		// success 필드 체크
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}

		if (result && result.data) {
			return result.data;
		} else {
			return [];
		}

	} catch (error) {
		handleAjaxError(error);
	} 
}
 
 /**
  * @function handleAjaxError
  * @description 데이터 로드 실패 시 에러 메시지 팝업 출력
  * @param {Error} err - 발생한 에러 객체
  */
function handleAjaxError(err) {
	console.error(err);
	Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
			.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
}

// [ api ] end

</script>
