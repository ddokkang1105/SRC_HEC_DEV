<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea_pop;				//그리드 전역변수
    
	$(document).ready(function() {	
		
		changeClassCode('${itemClassCode}', '${itemTypeCode}');
		$('#AttrCode').change(function(){changeAttrCode($(this).val());});
		
		gridPopInit();
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridPopInit(){			
		var d = setGridPopData();		
		p_gridArea_pop = fnNewInitGrid("grdGridAreaPop", d);
		p_gridArea_pop.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea_pop.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea_pop.setColumnHidden(2, true);
		p_gridArea_pop.setColumnHidden(3, true);
		p_gridArea_pop.setColumnHidden(11, true);
		p_gridArea_pop.setColumnHidden(12, true);
		p_gridArea_pop.setColumnHidden(13, true);
		fnSetColType(p_gridArea_pop, 1, "ch");
		fnSetColType(p_gridArea_pop, 2, "img");	
		fnSetColType(p_gridArea_pop, 11, "img");
		
		p_gridArea_pop.enableAutoHeight(true, 275);
	}
	
	function setGridPopData(){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "search_SQL.getSearchList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},Report,ItemID,ClassCode";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|CreationTime|Report|ItemID|ClassCode";
		result.widths = "30,30,0,0,60,100,*,70,70,70,70,0,0,0"; // item 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&ItemTypeCode=${itemTypeCode}"
			+ "&ClassCode=${itemClassCode}";
		
		/* var attrArray = new Array();
		var valueArray = new Array();
		valueArray.push($("#AttrCode").val());
		//attrArray.push(valueArray);
		
		//var aval = $(el).val();	
		var lovCode = "";
		var searchValue = "";
		var AttrCodeEscape = "";
		var constraint = "";
		var selectOption = "";
		// [속성] 조건 선택, 입력값 
		if ($("#AttrLov").val() != "" || $("#searchValue").val() != "") {
			if ("Y" == $("#isLov").val()) {
				//result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
				//result.data = result.data+ "&lovCode=" + $("#AttrLov").val();
				lovCode = $("#AttrLov").val();
			} else {
				//result.data = result.data + "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
				//result.data = result.data+ "&searchValue=" + $("#searchValue").val();
				
				searchValue= $("#searchValue").val();
			}
		}
		//valueArray.push($(el).val());
		valueArray.push(lovCode);
		valueArray.push(searchValue);
		valueArray.push(AttrCodeEscape);
		valueArray.push(constraint);
		valueArray.push(selectOption);
		attrArray.push(valueArray);
		
		result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray; */
		
		if("${searchValue}" != ""){
			result.data = result.data + "&baseCondition1=${searchValue}"+ "&AttrCodeBase1=AT00001";
		}else{
			if($("#AttrCode").val() == "identifier"){
				result.data = result.data + "&baseCondition2="+$("#searchValue").val();
			}else{
				result.data = result.data + "&baseCondition1="+$("#searchValue").val()+ "&AttrCodeBase1="+$("#AttrCode").val();
			}
		}
		result.data = result.data+ "&masterItemId=${masterItemId}";
		
		return result;
	}
	
	function doSetGridPopData(){
		var d = setGridPopData();
		fnLoadDhtmlxGridJson(p_gridArea_pop, d.key, d.cols, d.data, false, '', 'TOT_CNT2');
	}	

	function selectitemType(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg+"&hasDim=1"; //파라미터들
		var target = "newClassCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
	// END ::: GRID	
	//===============================================================================
		
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function changeClassCode(avg1, avg2){
		$("#isLov").val("");
		$("#searchValue").attr('style', 'display:inline;width:140px;');
		$("#AttrLov").attr('style', 'display:none;width:120px;');
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&s_itemID="+avg2+"&s_itemID2="+avg1; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	function appendOption(){
		 var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		 $("#AttrCode").prepend("<option value='identifier'>ID</option>");
		 $("#AttrCode").val("AT00001").attr("selected", "selected");
	}	
	
	// [LOV option] 설정
	// 화면에서 선택된 속성의 DataType이 Lov일때, Lov selectList를 화면에 표시
	function changeAttrCode(avg){
		if (avg == "identifier") {
			$("#isLov").val("");
			$("#searchValue").attr('style', 'display:inline;width:140px;');
			$("#AttrLov").attr('style', 'display:none;width:120px;');	
		} else {
			var url = "getAttrLov.do";		
			var data = "attrCode="+avg;
			var target="blankFrame";
			ajaxPage(url, data, target);
		}
		
	}
	function changeAttrCode2(attrCode, dataType, isComLang) {
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		// isComLang == 1 이면, 속성 검색 의 언어 조건을 defaultLang으로 설정 해줌
		if (isComLang == '1') {
			languageID = "${defaultLang}";
			$("#isComLang").val("Y");
		} else {
			$("#isComLang").val("");
		}
		
		if (dataType == "LOV") {
			$("#isLov").val("Y");
			$("#AttrLov").attr('style', 'display:inline;width:120px;');
			$("#searchValue").attr('style', 'display:none;width:140px;');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov";            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxSelect(url, data, target, defaultValue, isAll);
		} else {
			$("#isLov").val("");
			$("#searchValue").attr('style', 'display:inline;width:140px;');
			$("#AttrLov").attr('style', 'display:none;width:120px;');	
		}
	}
	
		
	// [EXE] click
	function exeConsolidation(){
		if(p_gridArea_pop.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 
		}else{
			// 실행하시겠습니까?   
			if(confirm("${CM00042}")){    
				var checkedRows = p_gridArea_pop.getCheckedRows(1).split(",");
				var items = "";
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	if (items == "") {
			    		items = p_gridArea_pop.cells(checkedRows[i], 12).getValue();
			    	} else {
			    		items = items + "," + p_gridArea_pop.cells(checkedRows[i], 12).getValue();
			    	}
				}
			    
			    var url = "exeConsolidation.do";
			    var data = "masterItemId=${masterItemId}&items=" + items;
			    var target = "blankFrame";
			    ajaxPage(url, data, target);
			    
			    $(".popup_div").hide();
				$("#mask").hide();
			}
		}	
	}
		
</script>


<div class="popup01">
	<input type="hidden" id="isLov" name="isLov" value="">
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<colgroup>
            		<col width="70%">
            		<col>
            	</colgroup>
	            	<tr>
	               		<td class="pdL10 alignL">
							<!-- 속성 -->
		    				&nbsp;&nbsp;${menu.LN00031}
		    
							<select id="AttrCode" name="AttrCode" style="width:120px">
								<option value="AT00001">${menu.LN00028}</option>
								<option value="identifier">ID</option>
							</select>
							
							<!-- DataType != 'LOV' -->
							<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px">
							<!-- DataType == 'LOV' -->
							<select id="AttrLov" name="AttrLov" style="display:none;width:120px;" >
								<option value="">Select</option>	
							</select>
							
							<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSetGridPopData();" value="검색">              		
						</td>
						
						<td class="alignR pdR10">
							&nbsp;<span class="btn_pack small icon"><span class="EXE"></span><input value="EXE" type="submit" onclick="exeConsolidation()"></span>
						</td>
	               	</tr>
       			</table>
       		</div>
  		<div class="con01 mgL10">	
     		<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
			<div id="grdGridAreaPop" style="width:100%;height:300px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>