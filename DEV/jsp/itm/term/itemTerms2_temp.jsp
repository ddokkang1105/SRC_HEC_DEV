<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>

<form name="standardTermsSchFrm" id="standardTermsSchFrm" action="" method="post">
<div style="padding: 10px 10px 10px 10px;">
	<input type="hidden" id="languageID" name="languageID" value="${languageID}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="itemID" name="itemID" value="${itemID}">
	<div id="dictionary_search">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
				<col width="20%">
				<col width="80%">			
			</colgroup>		
			<tr>		
			  <th class="alignL pdL10">Search</th> 
			  <td class="alignL pdL10 last" >
			 	 <select id="termSearch" style="width:100px;height:22px;" class="mgR10">
					<option value="total">통합</option>
					<option value="name">용어</option>
					<option value="desc">용어정의</option>
				</select>							
			  	<input type="text" id="textCondition" name="textCondition" value=""  class="text" style="width:150px;ime-mode:active;"/>
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
        		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearch()">
        		<c:if test="${not empty csr}" >
        			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnRegistTerms()"></span>&nbsp;
        		</c:if>
<!--         		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel"></span> -->
        	</li>
        </div>
		
		<div id="gridDiv" style="width:100%;" class="clear" >
			<div id="layout"></div> <!--layout 추가한 부분-->
			<div id="pagination"></div>
		</div>
		<div id="dictionary_footer"></div>
	</div>
</form>	

<script type="text/javascript">
	var searchValue = "${searchValue}";
	let gridData = [];
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		
		if(searchValue != ""){
			$("#textCondition").val(searchValue);
			document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
			document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
			
		}else{
			document.getElementById("schResultMsg").innerHTML = "search all terms.";
		}
		
		doSearchList();
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$("#standardTermsSchFrm").submit(function(){
			return false;			
		});
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	const layout = new dhx.Layout("layout", { 
		rows: [	
			{
				id: "a",
			},
		]
	});
	
	function template(row) {
		let result = '<span style=font-weight:bold>'+row.Name+'</span>'
		if(row.enName) result += '<span style=font-weight:bold> / '+row.enName+'</span>';
		if(row.cnName) result += '<span style=font-weight:bold> / '+row.cnName+'</span>';
		if(row.Description) result += '<br><br>[KOR]<br>'+row.Description;
		if(row.enDescription) result += '<br>[ENG]<br>'+row.enDescription;
		if(row.cnDescription) result += '<br>[CN]<br>'+row.cnDescription;
		return result;
	};

	const list = new dhx.List("list", {
	    css: "dhx_widget--bordered",
	    template: template,
	});
	
// 	const grid = new dhx.Grid('layout', {
// 		columns: [
// 			{ fillspace: true, id: "Terms", header: [{ text: "${menu.LN00290}" , align: "center" }], align: "left", htmlEnable: true,
// 	        	template: function (text, row, col) {
// 	        		let result = '<div class="term-list"><span style=font-weight:bold>'+row.Name+'</span>'
// 	        		if(row.enName) result += '<span style=font-weight:bold> / '+row.enName+'</span>';
// 	        		if(row.cnName) result += '<span style=font-weight:bold> / '+row.cnName+'</span>';
// 	        		if(row.Description) result += '<br>'+row.Description;
// 	        		if(row.enDescription) result += '<br>'+row.enDescription;
// 	        		if(row.cnDescription) result += '<br>'+row.cnDescription;
// 	        		result += "</div>"
// 	        		return result;
// 	            }
// 			},
// // 			{ hidden:true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
// // 			{ hidden:true, width: 30, id: "CHK", header: [{ text: "" }], align: "center", type: "boolean"},
// // 			{ hidden:true, width: 50, id: "Name", header: [{ text: "${menu.LN00002}" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 50, id: "enName", header: [{ text: "${menu.LN00002}" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 50, id: "cnName", header: [{ text: "${menu.LN00002}" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 50, id: "ItemID", header: [{ text: "itemID" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 200, id: "Description", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 200, id: "enDescription", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"},
// // 			{ hidden:true, width: 200, id: "cnDescription", header: [{ text: "${menu.LN00290}" , align: "left" }], align: "left"}
// 		],
// 		autoWidth: true,
// 		selection: true,
// 		tooltip: false,
// // 		rowHeight: 45,
// 		autoHeight: true,
// 	});

	layout.getCell("a").attach(list);
	$("#TOT_CNT").html(list.data.getLength());


	const pagination = new dhx.Pagination("pagination", {
	    data: list.data,
	    pageSize: 20,
	});	

	// END ::: GRID
	//===============================================================================

	//grid ROW선택시
	list.events.on("click", function(id, e){
			gridOnRowSelect(list.data.getItem(id));
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
			var url = "viewTermDetail.do?itemID="+itemID+"&csr=${csr}"+"&mgt=${mgt}&option=${option}";
			window.open(url,'_blank','width=1000, height=720, left=200, top=100,scrollbar=yes,resizble=0');
		}
	}
	
	/** 검색버튼 , All버튼 */
	$('.searchList1').click(function(){
		const textCondition = document.querySelector("#textCondition").value;
		// 검색 결과 그리드 리스트 화면 표시
		 if ($("#textCondition").val() == "") {
			 document.getElementById("schResultMsg").innerHTML = "search all terms.";
		} else {
			// textbox에 입력된 검색 조건 
			document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
			document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
		}

		if(textCondition == "") list.data.parse(gridData.filter(e => e.ClassCode == "CL11004"));
		else {
			const regex  =new RegExp(textCondition, "gi"); // 대소문자 구분 없이 찾기
			if(document.getElementById("termSearch").value == "total") list.data.parse(gridData.filter(e => regex.test(e.Name) || regex.test(e.enName) || regex.test(e.cnName) || regex.test(e.Description) || regex.test(e.enDescription) || regex.test(e.cnDescription)));
			if(document.getElementById("termSearch").value == "name") list.data.parse(gridData.filter(e => regex.test(e.Name) || regex.test(e.enName) || regex.test(e.cnName)));
			if(document.getElementById("termSearch").value == "desc") list.data.parse(gridData.filter(e => regex.test(e.Description) || regex.test(e.enDescription) || regex.test(e.cnDescription)));
		}
		 
		 document.getElementById("TOT_CNT").innerText = list.data.getRawData().length;
	});
	
	$("#textCondition").keypress(function(onkey){
		const textCondition = document.querySelector("#textCondition").value;
		if(onkey.keyCode == "13") {
			// 검색 결과 그리드 리스트 화면 표시
			 if ($("#textCondition").val() == "") {
				 document.getElementById("schResultMsg").innerHTML = "search all terms.";
			} else {
				// textbox에 입력된 검색 조건 
				document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
				document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
			}
						
			 if(textCondition == "") list.data.parse(gridData.filter(e => e.ClassCode == "CL11004"));
			else {
				const regex  =new RegExp(textCondition, "gi"); // 대소문자 구분 없이 찾기
				if(document.getElementById("termSearch").value == "total") list.data.parse(gridData.filter(e => regex.test(e.Name) || regex.test(e.enName) || regex.test(e.cnName) || regex.test(e.Description) || regex.test(e.enDescription) || regex.test(e.cnDescription)));
				if(document.getElementById("termSearch").value == "name") list.data.parse(gridData.filter(e => regex.test(e.Name) || regex.test(e.enName) || regex.test(e.cnName)));
				if(document.getElementById("termSearch").value == "desc") list.data.parse(gridData.filter(e => regex.test(e.Description) || regex.test(e.enDescription) || regex.test(e.cnDescription)));
			}
			
			document.getElementById("TOT_CNT").innerText = list.data.getRawData().length;
			
			return false;
		}
	});
	
	/** [A,B,C...버튼 클릭] */
	$('.searchList2').click(function(){
		// 검색 결과 리스트 취득
// 		doSearchList();
		document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
		document.getElementById("inputCondition").innerHTML = $(this).attr('alt');
		
		list.data.parse(gridData.filter(e => e.Name.at(0) === $(this).attr('alt') || e.enName.at(0) === $(this).attr('alt')));
		$("#TOT_CNT").html(list.data.getLength());
	});
	
	const hangul = {
		"ㄱ" : {first : "가" , last : "낗"},
		"ㄴ" : {first : "나" , last : "닣"},
		"ㄷ" : {first : "다" , last : "딯"},
		"ㄹ" : {first : "라" , last : "맇"},
		"ㅁ" : {first : "마" , last : "밓"},
		"ㅂ" : {first : "바" , last : "삫"},
		"ㅅ" : {first : "사" , last : "앃"},
		"ㅇ" : {first : "아" , last : "잏"},
		"ㅈ" : {first : "자" , last : "짛"},
		"ㅊ" : {first : "차" , last : "칳"},
		"ㅋ" : {first : "카" , last : "킿"},
		"ㅍ" : {first : "파" , last : "핗"},
		"ㅌ" : {first : "타" , last : "팋"},
		"ㅎ" : {first : "하" , last : "힣"},
	}
	
	/** [ㄱ,ㄴ,ㄷ...버튼 클릭] */
	$('.searchList3').click(function(){
		document.getElementById("schResultMsg").innerHTML = "Search words starting from <font color='#c01020'><span id='inputCondition'></span></font>.";
		document.getElementById("inputCondition").innerHTML = $(this).attr('alt');
		let a = $(this).attr('alt');
		let b = hangul[$(this).attr('alt')].first;
		let c = hangul[$(this).attr('alt')].last;
		const regex = new RegExp(`[\${a}-\${a}|\${b}-\${c}]`, '');
		
		list.data.parse(gridData.filter(e => e.Name.at(0).match(regex) || e.enName.at(0).match(regex)));
		$("#TOT_CNT").html(list.data.getLength());
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

	function fnRegistTerms(){
		var url = "editTermDetail.do?csr=${csr}&option=${option}";
		window.open(url,'_blank','width=900, height=680, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	//조회
	function doSearchList(){
		$("#loading").fadeIn(150);
		var sqlID = "standardTerms_SQL.getSubItemList";
		var param =   "&defaultLang=${defaultLang}"
					+ "&itemID="	        + $('#itemID').val()
					+ "&lovCode=${lovCode}"
					+ "&mgt=${mgt}"
					+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				$("#loading").fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
// 	function findDescendants(data, startId) {
// 		const result = [];
		
// 		function recurse(currentId) {
// 			for (const item of data) {
// 		    	if (item.ParentID == currentId) {
// 					result.push(item);
// 					recurse(item.ItemID);
// 		    	}
// 		  	}
// 		}
		
// 		recurse(startId);
// 		return result;
// 	}
	
	function fnReloadGrid(newGridData){
// 		const result = findDescendants(JSON.parse(newGridData), "${itemID}");
		gridData = (JSON.parse(newGridData)).filter(e => e.ClassCode == "CL11004");
		console.log(gridData);
 		list.data.parse(gridData);
 		$("#TOT_CNT").html(list.data.getLength());
 	}

	
	function doExcel() {
		list.showColumn('RNUM');
		list.showColumn('Name');
		list.hideColumn('Terms');
		list.showColumn('Description');

		fnGridExcelDownLoad(); 

		list.hideColumn('RNUM');
		list.hideColumn('Name');
		list.showColumn('Terms');
		list.hideColumn('Description');
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
	
	function clearSearch() {
		list.data.parse(gridData.filter(e => e.ClassCode == "CL11004"));
		$("#textCondition").val("");
		$("#TOT_CNT").html(list.data.getLength());
		document.getElementById("schResultMsg").innerHTML = "search all terms.";
	}
</script>

