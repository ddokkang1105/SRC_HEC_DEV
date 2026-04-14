<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 관련항목 추가용 페이지(팝업) ->
<!-- 
	@RequestMapping(value = "/newPertinentListGrid.do")
	* item_SQL.xml - getPertinentNewList_gridList
	* Action
	  - Add  :: createCxnItem.do
	* SubMenu - processChildMenu  
-->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00044" var="WM00044"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
	$(window).load(function(){$("#searchPValue").focus();});
	$(document).ready(function() {
		$('.searchPList').click(function(){doPSearchList();});
		$('#searchPValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});		
		var data = "&option=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";		
		fnSelect('newPClassCode', data, 'classCodeOption', 'All');
		PgridInit();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	function PgridInit(){		
		var d = setPGridData();		
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");		
		pp_grid1.setColumnHidden(8, true);
		fnSetColType(pp_grid1, 1, "ch");
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}	
	function setPGridData(){		
		var result = new Object();
		result.title = "${title}";
		result.key = "item_SQL.getPertinentNewList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},Path,${menu.LN00028},${menu.LN00016},${menu.LN00014},${menu.LN00018},ItemID";	//9
		result.cols = "CHK|Identifier|FatherName|ItemName|ClassName|TeamName|OwnerTeamName|ItemID";
		result.widths = "30,30,80,200,150,100,80,80,0";
		result.sorting = "int,int,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,left,left,left,left,left,center";
		result.data = "ItemTypeCode=${ItemTypeCode}"
					+ "&s_itemID=${s_itemID}"	
					+ "&searchKey=" 		+ $('#searchPKey').val()
					+ "&searchValue=" 		+ $('#searchPValue').val()
		            + "&ClassCode="     	+ $("#newPClassCode").val()
		 			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	 			
		return result;
	}
	function gridOnRowSelect(id, ind){/*if(ind != 1){parent.doPDetail(pp_grid1.cells(id, 8).getValue());}*/	}
	function doOnCheckPert(id) {alert("cellId : " + id + " || value : " + pp_grid1.cells(id, 8).getValue());}
	// END ::: GRID	
	//===============================================================================
	function doPSearchList(){if(doCheckValid()){var d = setPGridData();fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);}}
	function doCheckValid(){var isCheck=true;if($('#newPClassCode').val() == ""){alert("${WM00044}");isCheck=false;}else if($("#searchPValue").val() == ""){alert("${WM00045}");isCheck=false;}return isCheck;}
	function doPDetail(avg){		
		var url    = "subMenu.do"; // 요청이 날라가는 주소
		var data   = "url=processChildMenu&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID="+$("#s_itemID").val()+"&s_itemID="+avg;
		var target = "objInfo";
		ajaxPage(url, data, target);
	}
	function processNEW(){
		if(pp_grid1.getCheckedRows(1).length == 0){alert("${WM00023}");			
		}else{
			//if(confirm("선택된 항목을 추가 하시겠습니까?")){	
			if(confirm("${CM00012}")){		
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");
				var items =""; 
				for(var i = 0 ; i < checkedRows.length; i++ ){
					items += pp_grid1.cells(checkedRows[i], 8).getValue() +",";
				}
				items = items.substr(0,items.length -1);
				var url = "createCxnItem.do";
				var data = "s_itemID=${s_itemID}&option=${option}&loginID=${sessionScope.loginInfo.sessionUserId}&FinalData=Final&Category=ST2&items="+items;
				var target = "blankFrame";
				
				//alert(data);
				
				ajaxPage(url, data, target);	
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					pp_grid1.deleteRow(checkedRows[i]);
				}
			}
		}	
	}	
	function popupColose(){
		doTcSearchList();
	}
</script>
<div class="popup01">
<ul>
  <li class="con_zone"><!-- 세로사이즈 바뀝니다 100,200,300,400 -->
	<div class="title popup_title"> <span class="pdL10"> Searcj</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn"
			src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close" >
		</div>
	</div>
	<div class="szone">
		<div class="child_search">
			<table  cellpadding="0" class="tbl_popup" cellspacing="0" border="0" width="100%">
            	<colgroup>
            		<col width="70">
            		<col width="150">
            		<col width="100">
            		<col>
            		<col width="70">
            	</colgroup>
            	<tr>
               		<td>${menu.LN00016}</td>
               		<td>
						<select id="newPClassCode" name="newPClassCode"  class="sel">
						</select>
               		</td>
               		<td>					
						<select id="searchPKey" name="searchPKey" class="sel" >
							<option value="Name">Name</option>
							<option value="Code" 
								<c:if test="${searchKey == 'Code'}"> selected="selected"</c:if>	
							>Code</option>
							<option value="Info" 
								<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>	
							>${menu.LN00005}</option>					
						</select>
					</td>
					<td class="alignC">
						<input type="text" id="searchPValue" name="searchPValue" value="${searchValue}" class="text" style="width:170px;ime-mode:active;"></input>
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="검색">&nbsp;
					</td>
					<td class="alignC">
					    <span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="processNEW()" ></span>	
					</td>
               	</tr>
   			</table>
   		</div>
  		<div class="con01 mgL10">
		    <div id="grdPAArea" style="width:100%;height:315px;"></div>
  		</div>
	</div>
	</li>
	<li class="con_rizone"></li>
	</ul>
</div>