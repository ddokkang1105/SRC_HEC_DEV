<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>

<!-- 2. Script -->
<script type="text/javascript">
	var grid;				//그리드 전역변수
    
	$(document).ready(function() {		
		changeClassCode('${itemClassCode}', '${itemTypeCode}');
		$('#AttrCode').change(function(){changeAttrCode($(this).val());});
		
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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
		if(grid.data.findAll(e => e.checkbox).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 
		}else{
			// 실행하시겠습니까?   
			if(confirm("${CM00042}")){
				var items = grid.data.findAll(e => e.checkbox).map(e => e.ItemID).join(",");
			    
			    var url = "exeConsolidation.do";
			    var data = "masterItemId=${masterItemId}&items=" + items;
			    var target = "blankFrame";
			    ajaxPage(url, data, target);
			    
				self.close();
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
				<div class="child_search01">
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
				<div class="mgL10 mgR10">	
			   		<div class="alignL mgT5 mgB5">	
						<p style="color:#1141a1;">Total <span id="TOT_CNT2"></span></p>
					</div>
					<div id="layout" style="width:100%;height:300px;"></div>  		
				</div>
			</div>
		</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	grid = new dhx.Grid("grdGridAreaPop",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true, align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 60, id: "Identifier", header: [{ text: "${menu.LN00015}", align:"center" }], align:"center"},
	        { width: 100, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }]},
	        { id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }]},
	        { width: 70, id: "TeamName", header: [{ text: "${menu.LN00014}", align:"center" }], align:"center"},
	        { width: 70, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center"},
	        { width: 70, id: "Name", header: [{ text: "SR ${menu.LN00004}", align:"center" }], align:"center"},
	        { width: 70, id: "CreationTime", header: [{ text: "CR ${menu.LN00013}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	layout.getCell("a").attach(grid);
	
	function doSetGridPopData(){
		var sqlID = "search_SQL.getSearchList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&ItemTypeCode=${itemTypeCode}"
			+ "&ClassCode=${itemClassCode}"
			+ "&sqlID="+sqlID;
			
		if("${searchValue}" != ""){
			param = param + "&baseCondition1=${searchValue}"+ "&AttrCodeBase1=AT00001";
		}else{
			if($("#AttrCode").val() == "identifier"){
				param = param + "&baseCondition2="+$("#searchValue").val();
			}else{
				param = param + "&baseCondition1="+$("#searchValue").val()+ "&AttrCodeBase1="+$("#AttrCode").val();
			}
		}
		param = param+ "&masterItemId=${masterItemId}";
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
		 		fnMasterChk('');
		 		$("#TOT_CNT2").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>