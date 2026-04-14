<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>

 <style>
	.dhx_grid-cell__content {
		display: block;
	}
</style> 

<script type="text/javascript">	
	var searchValue = "${searchValue}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		
		if(searchValue != ""){
			$("#textCondition").val(searchValue);
			$("#searchCondition1").val(setSpecialChar($("#textCondition").val()));
			document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
			document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
			
		}else{
			document.getElementById("schResultMsg").innerHTML = "search all terms.";
		}
		
		// 검색어 자동완성 함수 
		autoComplete("textCondition", "AT00001", "OJ00011", "", "", 5, "top"); 
// 		doSearchList();
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$("#textCondition").keypress(function(onkey){
			if(onkey.keyCode == "13") {
				// 해당 검색조건 이외의 검색 조건 클리어
				$("#searchCondition1").val("");
				$("#searchCondition2").val("");
				$("#searchCondition3").val("");
			
				// 검색 결과 그리드 리스트 화면 표시
				 if ($("#textCondition").val() == "") {
					 document.getElementById("schResultMsg").innerHTML = "search all terms.";
				} else { 
					// textbox에 입력된 검색 조건 
					$("#searchCondition1").val(setSpecialChar($("#textCondition").val()));
					document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
					
					//2025-02-10 화면단 xss filter 적용
					//document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
					var value = $("#textCondition").val();
					document.getElementById("inputCondition").innerHTML = XSSCheck(value);
				}

				doSearchList();
				return false;
			}else{
				keyPressXSSCheck();
			}
		});
		
		$("#standardTermsSchFrm").submit(function(){
			return false;			
		});
		
		/** 검색버튼 , All버튼 */
		$('.searchList1').click(function(){	
			// 해당 검색조건 이외의 검색 조건 클리어
			$("#searchCondition1").val("");
			$("#searchCondition2").val("");
			$("#searchCondition3").val("");
		
			// 검색 결과 그리드 리스트 화면 표시
			 if ($("#textCondition").val() == "") {
				 document.getElementById("schResultMsg").innerHTML = "search all terms.";
			} else { 
				// textbox에 입력된 검색 조건 
				$("#searchCondition1").val(setSpecialChar($("#textCondition").val()));
				document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
				//2025-02-10 화면단 xss filter 적용
				//document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
				var value = $("#textCondition").val();
				document.getElementById("inputCondition").innerHTML = XSSCheck(value);
			}

			doSearchList();
		});
		
		/** [A,B,C...버튼 클릭] */
		$('.searchList2').click(function(){
			// 해당 검색조건 이외의 검색 조건 클리어
			$("#searchCondition1").val("");
			$("#searchCondition3").val("");			
			$("#searchCondition2").val($(this).attr('alt'));
			// 검색 결과 리스트 취득
			doSearchList();
			document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
			document.getElementById("inputCondition").innerHTML = $(this).attr('alt');
		});
		
		/** [ㄱ,ㄴ,ㄷ...버튼 클릭] */
		$('.searchList3').click(function(){
			// 해당 검색조건 이외의 검색 조건 클리어
			$("#searchCondition1").val("");
			$("#searchCondition2").val("");			
			$("#searchCondition3").val($(this).attr('alt'));
			// 검색 조건 설정
			setSearchCondition4($(this).attr('alt'));
			doSearchList();
			document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
			document.getElementById("inputCondition").innerHTML = $(this).attr('alt');
		});
				
	});
		
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function setSearchCondition4(searchCondition3) {
		switch (searchCondition3) {		
			case "ㄱ" : 
				$("#searchCondition4").val("깋");
				break;
			case "ㄴ" : 
				$("#searchCondition4").val("닣");
				break;
			case "ㄷ" : 
				$("#searchCondition4").val("딯");
				break;
			case "ㄹ" : 
				$("#searchCondition4").val("맇");
				break;
			case "ㅁ" : 
				$("#searchCondition4").val("밓");
				break;
			case "ㅂ" : 
				$("#searchCondition4").val("빟");
				break;
			case "ㅅ" : 
				$("#searchCondition4").val("싷");
				break;
			case "ㅇ" : 
				$("#searchCondition4").val("잏");
				break;
			case "ㅈ" : 
				$("#searchCondition4").val("짛");
				break;
			case "ㅊ" : 
				$("#searchCondition4").val("칳");
				break;
			case "ㅋ" : 
				$("#searchCondition4").val("킿");
				break;
			case "ㅌ" : 
				$("#searchCondition4").val("팋");
				break;
			case "ㅍ" : 
				$("#searchCondition4").val("핗");
				break;
			case "ㅎ" : 
				$("#searchCondition4").val("힣");
				break;
		}
	}

	function fnRegistTerms(){
		var url = "editTermDetail.do?csr=${csr}";
		window.open(url,'_blank','width=900, height=680, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	//조회
	function doSearchList(){
		var sqlID = "standardTerms_SQL.getSearchResult";
		var param =   "&defaultLang=${defaultLang}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&clientID="	        + $('#clientID').val()
					+ "&lovCode=${lovCode}"
					+ "&searchCondition1="	+ $('#searchCondition1').val()
					+ "&searchCondition2="	+ $('#searchCondition2').val()
					+ "&searchCondition3="	+ $('#searchCondition3').val()
					+ "&searchCondition4="	+ $('#searchCondition4').val()
					+ "&mgt=${mgt}"
					+ "&sqlID="+sqlID;
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
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}

	
	function doExcel() {
		grid.showColumn('RNUM');
		grid.showColumn('Name');		
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1042") grid.showColumn('KoreanText');
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1033") grid.showColumn('EnglishText');
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "2052") grid.showColumn('ChineseText');
		grid.hideColumn('Terms');

		fnGridExcelDownLoad(grid); 

		grid.hideColumn('RNUM');
		grid.hideColumn('Name');
		grid.showColumn('Terms');
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1042") grid.hideColumn('KoreanText');
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1033") grid.hideColumn('EnglishText');
       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "2052") grid.hideColumn('ChineseText');
	}

	
	// [검색 조건] 특수 문자 처리
	function setSpecialChar(avg) {
		var result = avg;
		var strArray =  result.split("[");
		
		if (strArray.length > 1) { ${csr}
			result = result.split("[").join("[[]");
		}
		
		strArray =  result.split("%");
		if (strArray.length > 1) {
			result = result.split("%").join("!%");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("_");
		if (strArray.length > 1) {
			result = result.split("_").join("!_");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("@");
		if (strArray.length > 1) {
			result = result.split("@").join("!@");
			$("#isSpecial").val("Y");
		}
		
		return result;
	}
	
	function fnCallBack() {
		doSearchList();
		document.getElementById("schResultMsg").innerHTML = "search all terms.";
	}

	
</script>
<form name="standardTermsSchFrm" id="standardTermsSchFrm" action="" method="post">
<div style="padding: 10px 10px 10px 10px;">
	<input type="hidden" id="languageID" name="languageID" value="${languageID}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="clientID" name="clientID" value="${clientID}">
	<input type="hidden" id="searchCondition1" name="searchCondition1" value="${searchCondition1}">
	<input type="hidden" id="searchCondition2" name="searchCondition2" value="${searchCondition2}">
	<input type="hidden" id="searchCondition3" name="searchCondition3" value="${searchCondition3}">
	<input type="hidden" id="searchCondition4" name="searchCondition4" value="${searchCondition4}">
	
	<!-- <input type="hidden" id="totalPage" name="totalPage" value="${totalPage}"> -->
	<!-- <input type="hidden" id="currPage" name="currPage" value="${pageNum}"> -->
	
	<div class="cop_hdtitle">
		<ul>
			<li>
				<h3><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;
				<c:if test="${lovName !=  ''}" >${lovName}</c:if>
				<c:if test="${lovName ==  ''}" >${menu.LN00300}</c:if>
				</h3>
				
			</li>		
		</ul>	
	</div>
	<div id="dictionary_search">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
				<col width="20%">
				<col width="80%">			
			</colgroup>		
			<tr>		
			  <th class="alignL pdL10">Search</th> 
			  <td class="alignL pdL10 last" >
			  	<input type="text" id="textCondition" name="textCondition" value=""  class="text" style="width:150px;ime-mode:active;" autocomplete="name"/>
			  	&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_icon_search.png" class="searchList1" style="cursor:pointer;" >&nbsp;
			  </td>
			</tr>	
			<tr>		
			  <th class="alignL pdL10">Korean</th> 
			  <td class="alignL pdL10 last" style="cursor:pointer;">
			  	<img src="${root}${HTML_IMG_DIR}/dic_korea_01.png" width="16" height="16" alt="ㄱ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_02.png" width="16" height="16" alt="ㄴ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_03.png" width="16" height="16" alt="ㄷ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_04.png" width="16" height="16" alt="ㄹ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_05.png" width="16" height="16" alt="ㅁ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_06.png" width="16" height="16" alt="ㅂ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_07.png" width="16" height="16" alt="ㅅ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_08.png" width="16" height="16" alt="ㅇ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_09.png" width="16" height="16" alt="ㅈ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_10.png" width="16" height="16" alt="ㅊ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_11.png" width="16" height="16" alt="ㅋ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_12.png" width="16" height="16" alt="ㅌ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_13.png" width="16" height="16" alt="ㅍ" class="searchList3">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_korea_14.png" width="16" height="16" alt="ㅎ" class="searchList3">		 
			  </td>
			</tr>	
			<tr>		
			  <th class="alignL pdL10">English</th> 
			  <td class="alignL pdL10 last"  style="cursor:pointer;">
			  	<img src="${root}${HTML_IMG_DIR}/dic_eng_01.png" width="16" height="16" alt="A" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_02.png" width="16" height="16" alt="B" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_03.png" width="16" height="16" alt="C" class="searchList2">&nbsp;	
				<img src="${root}${HTML_IMG_DIR}/dic_eng_04.png" width="16" height="16" alt="D" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_05.png" width="16" height="16" alt="E" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_06.png" width="16" height="16" alt="F" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_07.png" width="16" height="16" alt="G" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_08.png" width="16" height="16" alt="H" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_09.png" width="16" height="16" alt="I" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_10.png" width="16" height="16" alt="J" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_11.png" width="16" height="16" alt="K" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_12.png" width="16" height="16" alt="L" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_13.png" width="16" height="16" alt="M" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_14.png" width="16" height="16" alt="N" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_15.png" width="16" height="16" alt="O" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_16.png" width="16" height="16" alt="P" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_17.png" width="16" height="16" alt="Q" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_18.png" width="16" height="16" alt="R" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_19.png" width="16" height="16" alt="S" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_20.png" width="16" height="16" alt="T" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_21.png" width="16" height="16" alt="U" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_22.png" width="16" height="16" alt="V" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_23.png" width="16" height="16" alt="W" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_24.png" width="16" height="16" alt="X" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_25.png" width="16" height="16" alt="Y" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_26.png" width="16" height="16" alt="Z" class="searchList2">	 
			  </td>
			</tr>	
		</table>
		</div>	
		<div class="countList pdT5 pdB5 " >
	        <li class="count">Total  <span id="TOT_CNT"></span>&nbsp;&nbsp;&nbsp;
	        <span id="schResultMsg">용어사전에서 <font color="#c01020"><span id="inputCondition"></span></font>(으)로 시작하는 데이터를 찾습니다.</span></li>
        	<li class="floatR">
        		<c:if test="${not empty csr}" >
        			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnRegistTerms()"></span>&nbsp;
        		</c:if>
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel"></span>
        	</li>
        </div>
		
		<div id="gridDiv" style="width:100%;" class="clear" >
			<div id="layout"></div> <!--layout 추가한 부분-->
			<div id="pagination"></div>
		</div>
		<div id="dictionary_footer"></div>
</form>	

<script type="text/javascript">	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("layout", { 
		rows: [	
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid('layout', {
		columns: [
			{ fillspace: true, id: "Terms", header: [{ text: "${menu.LN00290}" , align: "center" }], align: "left", htmlEnable: true, 
	        	template: function (text, row, col) {
		       		let result = "";
		       		// 명칭
			       	result += "<span style=font-weight:bold>"+row.Name;
			       	// 약어
			       	if(row.Abbreviation) result += "("+row.Abbreviation+")";
			       	result += "</span><br>";
			       	// 접속한 언어에 따라 AT00056,AT00057,AT00058 중 출력, NULL 일 경우 AT00057(영어)로 출력
			       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1042") result += row.KoreanText ? row.KoreanText : row.EnglishText;
			       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "1033") result += row.EnglishText;
			       	if("${sessionScope.loginInfo.sessionCurrLangType}" == "2052") result += row.ChineseText ? row.ChineseText : row.EnglishText;
		           return result;
	           }
			},
			{ hidden:true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
// 			{ hidden:true, width: 30, id: "CHK", header: [{ text: "" }], align: "center", type: "boolean"},
			{ hidden:true, width: 50, id: "Name", header: [{ text: "${menu.LN00002}" , align: "left" }], align: "left"},
// 			{ hidden:true, width: 50, id: "ItemID", header: [{ text: "itemID" , align: "left" }], align: "left"},
			{ hidden:true, width: 200, id: "KoreanText", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"},
			{ hidden:true, width: 200, id: "EnglishText", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"},
			{ hidden:true, width: 200, id: "ChineseText", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"},
		],
		autoWidth: true,
		selection: true,
		tooltip: false,
		rowHeight: 45,
		data:gridData
	});

	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());


	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});	

	// END ::: GRID
	//===============================================================================

	//grid ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "CHK"){
			gridOnRowSelect(row);
		}
	}); 

	function gridOnRowSelect(row) { 
		var linkOption = "${linkOption}"; 
		var itemID = row.ItemID;
		if(linkOption == "itmStd"){
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&accMode=${accMode}";
			var w = 1400;
			var h = 900;
			itmInfoPopup(url,w,h);
		}else{
			var url = "viewTermDetail.do?itemID="+itemID+"&csr=${csr}"+"&mgt=${mgt}";
			window.open(url,'_blank','width=1000, height=720, left=200, top=100,scrollbar=yes,resizble=0');
		}
	}
	
	<!--2025-02-10 화면단 xss filter 적용-->
	function XSSCheck(value) {
		debugger;
		if(value != null){
			value = value.replace(/\</g, "&lt;");
	        value = value.replace(/\>/g, "&gt;");
		}
	    return value;
	}
	function keyPressXSSCheck() {
		var array = [
				"alert", "prompt","window.","DOMContentLoaded","<img src","onerror"
				,"FSCommand","onAbort","onActivate","onAfterPrint","onAfterUpdate","onBeforeActivate","onBeforeCopy","onBeforeCut",
				"onBeforeDeactivate","onBeforeEditFocus","onBeforePaste","onBeforePrint","onBeforeUnload","onBeforeUpdate","onBegin",
				"onBlur","onBounce","onCellChange","onChange","onClick","onContextMenu","onControlSelect","onCopy","onCut","onDataAvailable",
				"onDataSetChanged","onDataSetComplete","onDblClick","onDeactivate","onDrag","onDragEnd","onDragLeave","onDragEnter","onDragOver",
				"onDragDrop","onDragStart","onDrop","onEnd","onError","onErrorUpdate","onFilterChange","onFinish","onFocus","onFocusIn","onFocusOut",
				"onHashChange","onHelp","onInput","onKeyDown","onKeyPress","onKeyUp","onLayoutComplete","onLoad","onLoseCapture","onMediaComplete","onMediaError",
				"onMessage","onMouseDown","onMouseEnter","onMouseLeave","onMouseMove","onMouseOut","onMouseOver","onMouseUp","onMouseWheel","onMove","onMoveEnd",
				"onMoveStart","onOffline","onOnline","onOutOfSync","onPaste","onPause","onPopState","onProgress","onPropertyChange","onReadyStateChange",
				"onRedo","onRepeat","onReset","onResize","onResizeEnd","onResizeStart","onResume","onReverse","onRowsEnter","onRowExit","onRowDelete",
				"onRowInserted","onScroll","onSeek","onSelect","onSelectionChange","onSelectStart","onStart","onStop","onStorage","onSyncRestored","onSubmit",
				"onTimeError","onTrackChange","onUndo","onUnload","onURLFlip","seekSegmentTime", "document.cookie","vbscript","expression",
				"addEventListener","cached","onpointerover","confirm","onwheel","<script>","javascript","onpointerenter",
				"iframe", "frame", "meta", "embed"]; 
		var input = $("#textCondition").val();
		if(input != null && input != ''){
			var result = array.filter(findXSSTag);
			console.log(result.length)
			console.log(array.length)
			if(result.length != array.length){
				$('#textCondition').val("");
			}
		
		}
	}
	function findXSSTag(value){
		var input = $("#textCondition").val();
		return input.indexOf(value) == -1;
	}
</script>

