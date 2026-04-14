<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea_pop;				//그리드 전역변수
    
	$(document).ready(function() {	
		fnSelect('ItemTypeCode', '&Deactivated=1', 'itemTypeCode', '', 'Select');
		gridPopInit();
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridPopInit(){			
		var d = setGridPopData("${dimTypeID}");		
		p_gridArea_pop = fnNewInitGrid("grdGridAreaPop", d);
		p_gridArea_pop.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea_pop, 1, "ch");
		p_gridArea_pop.setColumnHidden(9, true);
		p_gridArea_pop.setColumnHidden(10, true);	
		p_gridArea_pop.setColumnHidden(11, true);
		p_gridArea_pop.enableAutoHeight(true, 275);
	}
	function setGridPopData(avg){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimNewSelectList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017},ID";
		result.cols = "CHK|Identifier|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version|ID";
		result.widths = "28,28,50,95,*,80,70,70,70,0,0,0"; //5
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str"; //5
		result.aligns = "center,center,center,center,left,center,center,center,left,center,center,center"; //5
		result.data = "dimTypeID=${dimTypeID}&s_itemID=${dimValueID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainClassCode="+$("#newClassCodePop").val();
		return result;
	}
	function doSetGridPopData(){
		if($("#ItemTypeCode").val() == ""){alert("${WM00041_1}");return false;}	
		if($("#newClassCodePop").val() == ""){alert("${WM00041_2}");return false;}	
		var d = setGridPopData("${dimTypeID}");
		fnLoadDhtmlxGridJson(p_gridArea_pop, d.key, d.cols, d.data, false, '', 'TOT_CNT2');
	}	

	function selectitemType(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg+"&hasDim=1"; //파라미터들
		var target = "newClassCodePop";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
	// END ::: GRID	
	//===============================================================================
	function addNewDimItem(){
		if(p_gridArea_pop.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 
		}else{
			//if(confirm("선택된 항목을 추가 하시겠습니까?")){    
			if(confirm("${CM00012}")){    
				var checkedRows = p_gridArea_pop.getCheckedRows(1).split(",");
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	var url = "NewSubDimenstion.do";
			     	var data = "DimTypeID=${dimTypeID}&DimValueID=${dimValueID}&loginID=${sessionScope.loginInfo.sessionUserId}&s_itemID="+p_gridArea_pop.cells(checkedRows[i], 11).getValue();
			     	var target = "blankFrame";
			     	if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
			     	ajaxPage(url, data, target);
				}
			    
			    $(".popup_div").hide();
				$("#mask").hide();
			}
		}	
	}
		
</script>


<div class="popup01">
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
							&nbsp;${menu.LN00021}
							<select id="ItemTypeCode" name="ItemTypeCode" onchange="selectitemType(this.value)" ></select>
							&nbsp;${menu.LN00016}				
							<select id="newClassCodePop" name="newClassCodePop"></select> 
							<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSetGridPopData();" value="검색">              		
						</td>
						<td class="alignR pdR10">
							&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addNewDimItem()"></span>
						</td>
	               	</tr>
       			</table>
       		</div>
  		<div class="con01 mgL10">	
     		<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
			<div id="grdGridAreaPop" style="width:100%;height:250px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>