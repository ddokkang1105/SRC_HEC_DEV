<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<script type="text/javascript">	
	var p_gridArea;				//그리드 전역변수
	var p_gridExcelArea;
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		gridInit();doSearchList(); document.getElementById("schResultMsg").innerHTML = "search all terms.";
		
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
					document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
				}

				doSearchList();
				return false;
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
				document.getElementById("inputCondition").innerHTML = $("#textCondition").val();
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
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d, "", true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(2, true);	
		p_gridArea.setColumnHidden(4, true);		
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind) {gridOnRowSelect(id,ind);}); 
		
	}
	function gridExcelInit(){		
		var d = setGridExcelData();
		p_gridExcelArea = fnNewInitGrid("grdGridExcelArea", d, "", true);
		p_gridExcelArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridExcelArea.setIconPath("${root}${HTML_IMG_DIR}/");		
		
	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "standardTerms_SQL.getSearchResult";
		result.header = "${menu.LN00024},${menu.LN00002},itemID,${menu.LN00290},${menu.LN00290}";
		result.cols = "Name|ItemID|Terms|Description";
		result.widths = "50,50,50,*,200";
		result.sorting = "str,str,str,str.str";
		result.aligns = "left,left,left,left,left";
		result.data = "pagingArea="   		+ $("#totalPage").val()
					+ "&pageNum=" + $("#currPage").val()
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&clientID="	        + $('#clientID').val()
					+ "&lovCode=${lovCode}"
					+ "&searchCondition1="	+ $('#searchCondition1').val()
					+ "&searchCondition2="	+ $('#searchCondition2').val()
					+ "&searchCondition3="	+ $('#searchCondition3').val()
					+ "&searchCondition4="	+ $('#searchCondition4').val()
					+ "&mgt=${mgt}";

		return result;
	}

	function setGridExcelData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "standardTerms_SQL.getSearchResult";
		result.header = "${menu.LN00024},${menu.LN00028},${menu.LN00290}";
		result.cols = "Name|Description";
		result.widths = "50,200,*";
		result.sorting = "str,str,str";
		result.aligns = "left,left,left";
		result.data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&clientID="	        + $('#clientID').val()
					+ "&lovCode=${lovCode}"
					+ "&searchCondition1="	+ $('#searchCondition1').val()
					+ "&searchCondition2="	+ $('#searchCondition2').val()
					+ "&searchCondition3="	+ $('#searchCondition3').val()
					+ "&searchCondition4="	+ $('#searchCondition4').val()
					+ "&mgt=${mgt}";

		return result;
	}
	function gridOnRowSelect(id, ind){
		var itemID = p_gridArea.cells(id, 2).getValue();
		var url = "viewTermDetail.do?itemID="+itemID+"&csr=${csr}"+"&mgt=${mgt}";
		window.open(url,'_blank','width=1000, height=720, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	function fnRegistTerms(){
		var url = "editTermDetail.do?csr=${csr}";
		window.open(url,'_blank','width=900, height=680, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	//조회
	function doSearchList(){			
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);	
	}
	
	function doExcel() {		

		p_gridArea.setColumnHidden(0, false);
		p_gridArea.setColumnHidden(1, false);
		p_gridArea.setColumnHidden(3, true);		
		p_gridArea.setColumnHidden(4, false);	
		
		
		p_gridArea.toExcel("${root}excelGenerate");

		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(3, false);	
		p_gridArea.setColumnHidden(4, true);		
		
		//$("#standardTermsSchFrm").submit();
		//return false;
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
		gridInit();	
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
	
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc;">
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
			  	<input type="text" id="textCondition" name="textCondition" value=""  class="text" style="width:150px;ime-mode:active;" />
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
        		<c:if test="${csr !=  ''}" >
        			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnRegistTerms()"></span>&nbsp;
        		</c:if>
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel"></span>
        	</li>
        </div>
		
	<div id="gridDiv" style="width:100%;" class="clear" >
	<div id="grdGridArea" style="width:500px;"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<div id="dictionary_footer"></div>
</div>
</form>	

