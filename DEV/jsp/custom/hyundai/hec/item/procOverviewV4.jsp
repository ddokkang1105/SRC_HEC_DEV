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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

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
	.row-highlight{
		background-color: #f2f8ff !important;
	}
</style>
<script type="text/javascript">
	var chkReadOnly = true;	
	
	// cmm
	var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
	var s_itemID = `${s_itemID}`;
	var changeSetID = `${changeSetID}`;
	var accMode = `${accMode}`;
	
</script>
<%-- <script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script> --%>
<script type="text/javascript">
	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		// 하위항목
		renderChildItemList();
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		};
		
		// info
		renderItemInfoList();
		
		// file
		renderFileList();
		
		// 프로세스 정의
		renderAttr('AT00003');
		
		// 참고사항
		renderAttr('AT00006');
		
		
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
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
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
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}
	}
	
	
	
	//---------------------------------------------------------
	//[GRID] START ::
	//---------------------------------------------------------
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grdChildGridArea",  {
		columns: [
            { 
                width: 50, 
                id: "CHK", 
                header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true, align: "center" }], 
                align: "center", 
                type: "boolean", 
                editable: true, 
                sortable: false 
            },
            { 
                width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align: "center" }], align: "center",
                htmlEnable: true,
                template: function (text, row, col) {
                    return row.ItemTypeImg ? '<img src="${root}${HTML_IMG_DIR}/item/' + row.ItemTypeImg + '" width="18" height="18">' : "";
                }
            },
            { width: 130, id: "Identifier", header: [{ text: "${menu.LN00106}", align: "center" }], align: "left" },
            { id: "ItemName", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left", gravity: 1.5, htmlEnable: true },
            { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align: "center" }], align: "center" },
            { width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center" },
            { width: 140, id: "Name", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
            { width: 140, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
            { width: 100, id: "ItemStatusText", header: [{ text: "${menu.LN00027}", align: "center" }], align: "center", htmlEnable: true },
            { 
                width: 50, id: "FileIcon", header: [{ text: "File", align: "center" }], align: "center",
                htmlEnable: true,
                template: function (text, row, col) {
                    return row.FileIcon ? '<img src="${root}${HTML_IMG_DIR}/item/' + row.FileIcon + '" width="7" height="11">' : "";
                }
            }
        ],
        autoWidth: true,
        resizable: true,
        selection: "row",
        tooltip: false,
        multiselection: true,
        keyNavigation: true  
	});
	
	
	grid.events.on("cellClick", function(row, col, e) {
	    gridOnRowSelect(row.id, col.id);
	});
	
	function gridOnRowSelect(row, id) {
	    var rowData = grid.data.getItem(row);
	    if(!rowData) return;
		
	    if(id !== 'CHK' && id !== 'FileIcon') {
	        doDetail(rowData.ItemID, rowData.ClassCode);
	    }
	    else if(id === 'FileIcon') {
	        var fileCheck = rowData.FileIcon || "";
	        if(fileCheck.indexOf("blank.gif") < 1) {
	            var url = "selectFilePop.do";
	            var data = "?s_itemID=" + rowData.ItemID;
	            window.open(url+data, "", "width=650, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");    
	        }
	    }
	    else{
			tranSearchCheck = false;
		}
	}

	grid.events.on("afterEditEnd", function(value, row, col) {
	    if (col.id === "CHK") {
	        fnOnCheck(row.id, value);
	    }
	});
	
	function fnOnCheck(rowId,state){
		if (state) {
	        grid.addRowCss(rowId, "row-highlight");
	    } else {
	        grid.removeRowCss(rowId, "row-highlight");
	    }
	}
	
	layout.getCell("a").attach(grid);
		
	function doDetail(avg1, avg2){
		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop&itemMainPage=itm/itemInfo/itemMainMgt";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	
	// [하위항목] 조회 및 grid 셋팅
	async function renderChildItemList() {
		
		const option = $("#option").val();
		const searchKey = $("#searchKey").val();
	   	let searchValue = $("#searchValue1").val();
	   	searchValue = encodeURIComponent(searchValue);
	   	const TreeDataFiltered = await loadTreeDataFiltered();
		
		const requestData = { 
				listType : 'child', 
				languageID, 
				s_itemID, 
				option,
				filterType : `${filterType}`,
				TreeDataFiltered,
				defDimTypeID : `${defDimTypeID}`,
				defDimValueID : `${defDimValueID}`,
				searchKey,
				searchValue,
				showTOJ : `${showTOJ}`,
				showElement : `${showElement}`
			};
		
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemListInfo.do?" + params;

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
				
				if(result.data.length === 0){
		            grid.data.parse([]);
		            $("#TOT_CNT").html("0");
				} else {
			        grid.data.parse(result.data);
			        $("#TOT_CNT").html(grid.data.getLength());
				}
				
			} else {
				grid.data.parse([]);
	            $("#TOT_CNT").html("0");
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	
	// old
	/*
	function doTcSearchList(){
		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
	}
	
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}
	
	function gridTcInit(){	
		var tcd = setTcGridData();
		tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");

		fnSetColType(tc_gridArea, 20, "img");
		fnSetColType(tc_gridArea, 2, "img");
		
		tc_gridArea.enableRowsHover(true,'grid_hover');
		tc_gridArea.enableMultiselect(true);
		
		tc_gridArea.setColumnHidden(1, true);
		tc_gridArea.setColumnHidden(6, true);
		tc_gridArea.setColumnHidden(8, true);
		tc_gridArea.setColumnHidden(10, true);
		tc_gridArea.setColumnHidden(11, true);
		tc_gridArea.setColumnHidden(12, true);
		tc_gridArea.setColumnHidden(14, true);
		tc_gridArea.setColumnHidden(15, true);
		tc_gridArea.setColumnHidden(16, true);
		tc_gridArea.setColumnHidden(17, true);

		tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		tc_gridArea.attachEvent("onCheckbox",fnOnCheck);
	}

	function setTcGridData(){
		var tcResult = new Object();
		tcResult.title = "${title}";
		tcResult.key = "item_SQL.getSubItemList";
		tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00131},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00042},SCOUNT,ClassCode,${menu.LN00027},Status,ItemID,AuthorID,Blocked,ItemTypeCode,ChangeMgt,File";
		tcResult.cols = "CHK|ItemTypeImg|Identifier|ItemName|ClassName|PjtName|OwnerTeamName|Name|LastUpdated|GUBUN|SCOUNT|ClassCode|ItemStatusText|Status|ItemID|AuthorID|Blocked|ItemTypeCode|ChangeMgt|FileIcon";
		tcResult.widths = "30,30,30,130,*,100,120,140,140,110,0,0,0,100,0,0,0,0,0,0,40";
		tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str";
		tcResult.aligns = "center,center,center,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		tcResult.data = "s_itemID=${itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
			        + "&option="     + $("#option").val()
			        + "&filterType=${filterType}"
			        + "&TreeDataFiltered=${TreeDataFiltered}"  
			        + "&defDimTypeID=${defDimTypeID}"
			        + "&defDimValueID=${defDimValueID}"      
			        + "&searchKey="     + $("#searchKey").val()
			        + "&searchValue="     	+ $("#searchValue").val()
			        + "&showTOJ=${showTOJ}"
			        +"&showElement=${showElement}";
		return tcResult;
	}
	*/
	
	// api
	
	// [treeDataFiltered] 조회 api
	async function loadTreeDataFiltered() {
		const sqlID = 'menu_SQL.selectArcTreeDataFiltered'; 
		const sqlGridList = 'N';
		const SelectMenuId = $("#option").val();
		
	    const requestData = { SelectMenuId, sqlID, sqlGridList };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
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
				return [];
			}

		} catch (error) {
			handleAjaxError(error);
		}

	}
	/**
   	* @function renderFileList
   	* @description 현재 item의 첨부파일 리스트를 api 통해 조회 후 html 렌더링 합니다.
  	*/
	let attachFileList = "";
	async function renderFileList() {
		
	    let requestData = { DocumentID : s_itemID, s_itemID, DocCategory : 'ITM', languageID , isPublic : 'N' };
		
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemFileListInfo.do?" + params;
	    
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			if (result && result.data ) {
				
				// file 정보 조회
				attachFileList = result.data;
				const fileList = document.querySelector("tbody[name='file-list']");

				// 파일 표시
				attachFileList.forEach((file, index) => {
					const fileFormat = file.FileFormat || '';
			        let iconClass = 'log';
			        if (fileFormat.includes('do')) iconClass = 'doc';
			        else if (fileFormat.includes('xl')) iconClass = 'xls';
			        else if (fileFormat.includes('pdf')) iconClass = 'pdf';
			        else if (fileFormat.includes('hw')) iconClass = 'hwp';
			        else if (fileFormat.includes('pp')) iconClass = 'ppt';
					
				    const row = document.createElement('tr');
				    row.innerHTML = `
				        <td>\${index}</td>
				        <td>\${file.FltpName}</td>
				        <td class="alignL pdL10 flex align-center">
					        <span class="btn_pack small icon mgR20" onclick="fileNameClick('\${file.FileName}','\${file.FileRealName}','','\${file.Seq}','\${file.ExtFileURL}');">
					        	<span class="\${iconClass}"></span>
					        </span>
	                    	<span style="cursor:pointer;margin-left:10px;" onclick="fileNameClick('\${file.FileName}','\${file.FileRealName}','','\${file.Seq}','\${file.ExtFileURL}');">
	                        	\${file.FileRealName}
	                    	</span>
	                    	(<span id="fileSize">\${file.FileSize}</span>)
	                    </td>
	                <td>\${file.WriteUserNM}</td>
	                <td>\${file.LastUpdated}</td>
				    `;
				    
				    fileList.appendChild(row);
				});
				
			} else {
				return []; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	/**
   	* @function renderItemInfoList
   	* @description 현재 item의 info를 api 통해 조회 후 html 렌더링 합니다.
  	*/
	async function renderItemInfoList() {
		
		// 1. 아이템 기본정보 불러오기
        const itemInfo = await getItemInfo();
        if (!itemInfo || itemInfo.length === 0) {
            return;
        }
        
     	// 2. Max Version 불러오기
        const maxVersion = await getMaxChangeSetVersion();
     	
     	// 3. render
		const infoTbody = document.querySelector("tbody[name='info-list']");
     	if(infoTbody){
			const row = document.createElement('tr');
		    row.innerHTML = `
		    	<th>프로세스 No.</th>
				<td class="alignL pdL10">\${itemInfo.Identifier}</td>
				<th>Rev. No.</th>
				<td class="alignL pdL10">\${maxVersion}</td>
				<th>Rev. Date</th>
				<td class="alignL pdL10">\${itemInfo.LastUpdated}</td>
				<th>${menu.LN00018}</th>
				<td class="alignL pdL10">\${itemInfo.CurOwnerTeamName}</td>
		    `;
		    infoTbody.appendChild(row);
     	}
		    
	}
	
	/**
   	* @function getItemInfo
   	* @description 현재 item의 info를 api 통해 조회합니다.
  	*/
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
	/**
   	* @function getMaxChangeSetVersion
   	* @description 현재 item의 max Change
  	*/
	async function getMaxChangeSetVersion() {
		
		const sqlID = 'cs_SQL.getItemReleaseVersion';
		const requestData = { itemID : s_itemID, sqlID, sqlGridList : 'N' };
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
     * @function renderAttr
     * @param {String} AttrTypeCode
     * @description itemID과 attrTypeCode 통해 해당 item의 attr Value를 조회하고, html 렌더링 합니다.
     */
 	async function renderAttr(AttrTypeCode){
 	    
 		
 		const requestData = { languageID, s_itemID, accMode, AttrTypeCode };
         
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
 		
 			if (result && result.data && result.data.length > 0) {
 				const html = result.data[0].PlainText || ""; 
 				const editor = document.getElementById(AttrTypeCode);
 				
 				if(editor) editor.innerHTML = html;

 				const script = document.createElement('script');
			    script.type = 'text/javascript';
			    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>';
			    
			    document.body.appendChild(script);
 			} else {
 				return;
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
	
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px; width: 100%;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">기본정보</label>
						<input type="checkbox" class="mgR3 chkbox" name="subItem" id="subItem_chk" checked><label for="subItem_chk" class="mgR3">${menu.LN00006 }</label>
						<input type="checkbox" class="mgR3 chkbox" name="note" id="note_chk" checked><label for="note_chk" class="mgR3">참고사항</label>
						<input type="checkbox" class="mgR3 chkbox" name="fileList" id="file_chk" checked><label for="file_chk" class="mgR3">첨부파일</label>
					</li>
				</ul>
			</div>
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">기본 정보</p>
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tbody name="info-list"></tbody>
				</table>
				
				<p class="cont_title">프로세스 정의</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="AT00003" name="description"></textarea>
						</div>
					</tr>
				</table>
			</div>
			
			<!-- 하위항목 --> 
			<div id="subItem" class="mgB30">
				<p class="cont_title">${menu.LN00006 }</p>
				<div id="gridDiv" class="mgB10 clear">
					<div id="layout" style="width:100%"></div>
				</div>
			</div>
			
			<!-- 참고사항 --> 
			<div id="note" class="mgB30">
				<p class="cont_title">참고사항</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="AT00006" name="AT00006"></textarea>
						</div>
					</tr>
				</table>
			</div>
			
				<!-- 첨부 및 관련 문서 --> 
			<div id="fileList" class="mgB100">
				<p class="cont_title">참고파일</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>문서유형</th>
						<th>문서명</th>
						<th>작성자</th>
						<th>등록일</th>
					</tr>
					<tbody name="file-list"></tbody>
				</table>
			</div>
		</div>
	</div>
</form>
</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
